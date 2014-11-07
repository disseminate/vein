local meta = FindMetaTable( "Player" );

function GM:PlayerInitialSpawn( ply )
	
	self.BaseClass:PlayerInitialSpawn( ply );
	
	ply:SetCustomCollisionCheck( !V.Config.PlayerCollision );
	
	ply.CharCreate = true;
	
	if( ply:IsBot() ) then
		
		return;
		
	end
	
	for _, v in pairs( game.GetDoors() ) do
		
		net.Start( "nMEDoorMaxClient" );
			net.WriteEntity( v );
			net.WriteFloat( v.DoorMaxHealth );
		net.Send( ply );
		
		net.Start( "nMEDamageDoorClient" );
			net.WriteEntity( v );
			net.WriteFloat( v.DoorHealth );
		net.Send( ply );
		
	end
	
	V.SQL.GetUserID( ply );
	
	local charList = V.SQL.GetCharList( ply );
	
	if( #charList == 0 ) then
		
	elseif( #charList > 0 ) then
		
		net.Start( "nCharMode" );
			net.WriteFloat( 1 );
		net.Send( ply );
		
	end
	
	V.RefreshClientChars( ply, charList );
	
	if( V.W.Raining ) then
		
		net.Start( "nSetRain" );
			net.WriteFloat( 1 );
		net.Broadcast();
		
	end
	
end

function GM:InitialSafeSpawn( ply )
	
	ply:Freeze( true );
	ply.Frozen = true;
	
	ply:InitFlashlight();
	
	if( ply.FirstSession ) then
		
		net.Start( "Session" );
		net.Send( ply );
		
	end
	
end

function meta:InitFlashlight()
	
	if( self.FlashlightEnt and self.FlashlightEnt:IsValid() ) then
		
		self.FlashlightEnt:Remove();
		
	end
	
	self.FlashlightEnt = ents.Create( "env_projectedtexture" );
	self.FlashlightEnt:SetParent( self );
	self.FlashlightEnt:SetLocalPos( Vector( 0, 0, 60 ) );
	self.FlashlightEnt:SetLocalAngles( Angle() );
	self.FlashlightEnt:SetKeyValue( "enableshadows", 1 );
	self.FlashlightEnt:SetKeyValue( "farz", 1024 );
	self.FlashlightEnt:SetKeyValue( "nearz", 32 );
	self.FlashlightEnt:SetKeyValue( "lightfov", 50 );
	self.FlashlightEnt:SetKeyValue( "lightcolor", "255 255 255 30" );
	self.FlashlightEnt:Spawn();
	self.FlashlightEnt:Input( "SpotlightTexture", NULL, NULL, "effects/flashlight001" );
	self.FlashlightEnt:Fire( "TurnOff" );
	self.FlashlightOn = false;
	
	self.FlashlightEnt:SetParent( self );
	self.FlashlightEnt:Fire( "SetParent", tostring( self:EntIndex() ) );
	
end

function meta:Flashlight( b )
	
	if( b ) then
		
		self.FlashlightOn = true;
		self.FlashlightEnt:Fire( "TurnOn" );
		
	else
		
		self.FlashlightOn = false;
		self.FlashlightEnt:Fire( "TurnOff" );
		
	end
	
end

function meta:FlashlightIsOn()
	
	return self.FlashlightOn;
	
end

function GM:PlayerSwitchFlashlight( ply, on )
	
	if( !ply:FlashlightIsOn() and ply:GetActiveWeapon() != NULL and ply:GetActiveWeapon().TwoHanded ) then
		
		return false;
		
	end
	
	if( ply.FlashlightEnt and ply.FlashlightEnt:IsValid() and ply:Alive() ) then
		
		ply:EmitSound( Sound( "items/flashlight1.wav" ) );
		
		if( ply:FlashlightIsOn() ) then
			
			ply:Flashlight( false );
			
		else
			
			ply:Flashlight( true );
			
		end
		
	end
	
	return false;
	
end

function V.GetCharTime( ply )
	
	if( ply.CharLoadTime and ply.CharLoadTimeS ) then
		
		return math.floor( ply.CharLoadTime + ( CurTime() - ply.CharLoadTimeS ) );
		
	end
	
end

function V.BotThink( bot )
	
	if( !bot.BotSetup ) then
		
		local gen = math.random( 1, 2 ) == 1;
		
		local name = table.Random( V.MaleFirstNames ) .. " " .. table.Random( V.LastNames );
		local m = table.Random( V.MaleValidModels );
		
		if( gen ) then
			
			name = table.Random( V.FemaleFirstNames ) .. " " .. table.Random( V.LastNames );
			m = table.Random( V.FemaleValidModels );
			
		end
		
		local model = m.Model;
		local skin = table.Random( m.Skin );
		
		V.LoadCharData( bot, {
			Name = name,
			Model = model,
			Skin = skin,
			PDesc = "Your typical resident of " .. game.GetMap() .. ", they were employed at the local " .. table.Random( { "market", "brothel", "police department", "mill", "school" } ) .. " and sold a bit of " .. table.Random( { "weed", "coke", "meth", "acid", "MDMA" } ) .. " on the side.",
			Inventory = "",
			Status = "",
			Dead = 0,
			Time = 0
		} );
		
		bot:InitFlashlight();
		
		bot.BotSetup = true;
		
	end
	
end

function GM:PlayerShouldTakeDamage( ply, attacker )
	
	if( !V.Config.PVPDamage and attacker:IsPlayer() ) then return false end
	if( ply:IsEFlagSet( EFL_NOCLIP_ACTIVE ) ) then return false end
	if( V.NukeInitialDamage ) then return false end
	
	return true;
	
end

function GM:EntityTakeDamage( ent, dmg )
	
	if( ent:IsPlayer() ) then
		
		if( !V.Config.PVPDamage and dmg:GetAttacker():IsPlayer() ) then return end
		
		local dt = dmg:GetDamageType();
		
		if( dt == DMG_BULLET ) then -- it fucking hurts to be shot
			
			V.STAT.SubStatus( ent, V.STAT.STATUS_PAIN, 2 );
			
		elseif( dt == DMG_FALL ) then
			
			V.STAT.SubStatus( ent, V.STAT.STATUS_PAIN, 1 );
			
		else
			
			if( dmg:GetDamage() > 50 ) then
				
				V.STAT.SubStatus( ent, V.STAT.STATUS_PAIN, 4 );
				
			elseif( dmg:GetDamage() > 35 ) then
				
				V.STAT.SubStatus( ent, V.STAT.STATUS_PAIN, 2 );
				
			elseif( dmg:GetDamage() > 20 ) then
				
				V.STAT.SubStatus( ent, V.STAT.STATUS_PAIN, 1 );
				
			end
			
		end
		
	end
	
	return self.BaseClass:EntityTakeDamage( ent, dmg )
	
end

function GM:PlayerDeath( ply, inf, killer )
	
	local pain = false;
	
	if( killer:IsZombie() ) then
		
		pain = true;
		
	end
	
	ply.PainfulDeath = pain;
	
	if( ply.AlreadyDead ) then
		
		net.Start( "nDie" );
			net.WriteFloat( 1 );
			net.WriteFloat( ply.DeadTime );
		net.Send( ply );
		return;
		
	end
	
	if( V.GetCharTime( ply ) < V.Config.CharacterSafeTime ) then
		
		ply.NextSpawnTime = CurTime() + 2;
		ply.DeathTime = CurTime();
		
	else
		
		net.Start( "nDie" );
			net.WriteFloat( 0 );
			net.WriteFloat( V.GetCharTime( ply ) );
		net.Send( ply );
		
		V.STAT.Death( ply );
		
		V.SQL.SaveCharacterField( ply, "Dead", "1" );
		V.SQL.SaveCharacterField( ply, "DeadTime", tostring( V.GetCharTime( ply ) ) );
		V.SQL.SaveCharacterField( ply, "DeadPos", tostring( ply:GetPos() ) );
		
		ply.BecomeZombie = CurTime() + V.Config.CharacterZombifyTime;
		
	end
	
end

function V.FindMyZombie( ply, already )
	
	local r = 128;
	
	if( already ) then r = math.huge; end
	
	if( !already and V.Z.CanSpawnZombie( ply:GetPos(), true ) ) then
		
		local trace = { };
		trace.start = ply:GetPos();
		trace.endpos = trace.start - Vector( 0, 0, 32768 );
		trace.filter = ply;
		local tr = util.TraceLine( trace );
		
		ply.MyZombie = V.Z.CreateZombie( tr.HitPos, tr.HitNormal );
		
		if( ply:IsFemale() and !ply.MyZombie:IsFemale() ) then
			
			ply.MyZombie:SetModel( "models/nmr_zombie/julie.mdl" );
			
		end
		
		if( !ply:IsFemale() and ply.MyZombie:IsFemale() ) then
			
			ply.MyZombie:SetModel( "models/nmr_zombie/casual_02.mdl" );
			
		end
		
		ply.MyZombie:StartSchedule( ply.MyZombie.DeadRise );
		
		ply:GetRagdollEntity():Remove();
		
	else
		
		local z = V.Z.GetClosestZombie( ply:GetPos(), r );
		
		if( z ) then
			
			ply.MyZombie = z;
			
		end
		
	end
	
	if( ply.MyZombie ) then
		
		if( !already ) then
			
			ply.SetMyZombieView = CurTime() + 3.766;
			
		else
			
			ply.SetMyZombieView = CurTime();
			
		end
		
	else
		
		V.SQL.SaveCharacterField( ply, "Dead", "2" );
		
	end
	
end

function GM:PlayerDeathThink( ply )
	
	if( V.GetCharTime( ply ) < V.Config.CharacterSafeTime ) then
		
		self.BaseClass:PlayerDeathThink( ply );
		
	else
		
		if( ply.BecomeZombie and CurTime() > ply.BecomeZombie and V.GetCharTime( ply ) >= V.Config.CharacterSafeTime ) then
			
			ply.BecomeZombie = nil;
			
			V.FindMyZombie( ply );
			
		end
		
	end
	
	if( ply.SetMyZombieView and CurTime() > ply.SetMyZombieView ) then
		
		ply.SetMyZombieView = nil;
		
		if( ply.MyZombie and ply.MyZombie:IsValid() ) then
			
			ply:SetViewEntity( ply.MyZombie );
			
		end
		
	end
	
end

function V.PreLoadCharData( ply, id )
	
	if( V.SQL.CharID( ply ) and ply.CharLoadTime and ply.CharLoadTimeS ) then
		
		local q = "UPDATE v_chars SET Time = '" .. tostring( V.GetCharTime( ply ) ) .. "' WHERE UserID = '" .. V.SQL.UserID( ply ) .. "' AND id = " .. tostring( V.SQL.CharID( ply ) );
		V.SQL.Query( q );
		
	end
	
	if( !ply:Alive() and ply.MyZombie and ply.MyZombie:IsValid() ) then
		
		V.SQL.SaveCharacterField( ply, "DeadPos", tostring( ply.MyZombie:GetPos() ) );
		
	end
	
	ply:StripWeapons();
	ply:SetHealth( 100 );
	
end

function GM:PlayerDisconnect( ply )
	
	V.PreLoadCharData( ply, V.SQL.CharID( ply ) );
	
end

function V.LoadCharData( ply, d )
	
	if( !ply:Alive() ) then
		
		ply:Spawn();
		
	end
	
	ply:SetRPName( d.Name );
	ply:SetModel( d.Model );
	ply:SetSkin( d.Skin );
	ply:SetPDesc( d.PDesc );
	
	ply.CharModel = d.Model;
	
	ply.CharLoadTime = tonumber( ( d.Time or 0 ) );
	ply.CharLoadTimeS = CurTime();
	
	if( d.BittenTime and tonumber( d.BittenTime ) and tonumber( d.BittenTime ) > 0 ) then
		
		ply.BittenTime = d.BittenTime;
		
	else
		
		ply.BittenTime = nil;
		
	end
	
	ply.DeadMode = d.Dead;
	
	if( tonumber( ply.DeadMode ) > 0 ) then
		
		ply.AlreadyDead = true;
		ply.DeadTime = d.DeadTime;
		ply:SetPos( Vector( d.DeadPos ) );
		ply:Kill();
		
		if( tonumber( ply.DeadMode ) == 1 ) then
			
			V.FindMyZombie( ply, true );
			
		end
		
	else
		
		ply.AlreadyDead = false;
		
		net.Start( "nDieReset" );
		net.Send( ply );
		
	end
	
	V.SQL.LoadInventory( ply, d.Inventory );
	V.SQL.LoadStatus( ply, d.Status );
	
	if( ply.FirstSession ) then
		
		timer.Simple( 20, function()
			
			if( ply and ply:IsValid() ) then
				
				ply:Freeze( false );
				ply.Frozen = false;
				ply.CharCreate = false;
				
			end
			
		end );
		
	else
		
		ply:Freeze( false );
		ply.Frozen = false;
		ply.CharCreate = false;
		
	end
	
	if( V.NoMesh and !ply.SentNoMeshWarning ) then
		
		ply.SentNoMeshWarning = true;
		
		net.Start( "nNoMesh" );
		net.Send( ply );
		
	end
	
	ply:GetOtherNetStrings();
	
end

function V.RefreshClientChars( ply, charList )
	
	net.Start( "nCharClear" );
	net.Send( ply );
	
	for _, v in pairs( charList ) do
		
		net.Start( "nCharAdd" );
			net.WriteString( v.Name );
			net.WriteString( v.Model );
			net.WriteFloat( tonumber( v.id ) );
			net.WriteFloat( tonumber( v.Skin ) );
			net.WriteBit( ( tonumber( v.Dead ) > 0 ) );
		net.Send( ply );
		
	end
	
end

V.ExpressionTranslate = { };
V.ExpressionTranslate["Vein.Idle"] = "scenes/expressions/citizen_normal_idle_01.vcd";
V.ExpressionTranslate["Vein.Fear"] = "scenes/expressions/citizen_scared_combat_01.vcd";
V.ExpressionTranslate["Vein.Anger"] = "scenes/expressions/citizen_angry_combat_01.vcd";

function V.PlayScene( ent, xp )
	
	if( V.ExpressionTranslate[xp] ) then
		
		net.Start( "nPlayExpression" );
			net.WriteEntity( ent );
			net.WriteString( V.ExpressionTranslate[xp] );
		net.Broadcast();
		return;
		
	end
	
	net.Start( "nPlayExpression" );
		net.WriteEntity( ent );
		net.WriteString( xp );
	net.Broadcast();
	
end

function GM:PlayerSpawn( ply )
	
	self.BaseClass:PlayerSpawn( ply );
	
	ply:SetWalkSpeed( 90 );
	ply:SetRunSpeed( 180 );
	
	if( !V.Config.PlayerCollision ) then
		
		ply:SetNoCollideWithTeammates( true );
		ply:SetAvoidPlayers( true );
		
	end
	
	if( ply.CharModel ) then
		
		ply:SetModel( ply.CharModel );
		
	end
	
	ply.MyZombie = nil;
	ply:SetViewEntity( nil );
	
	if( !ply.InitialSafeSpawn ) then
		
		ply.InitialSafeSpawn = true;
		hook.Call( "InitialSafeSpawn", self, ply );
		
	end
	
end

function GM:PlayerLoadout( ply )
	
	
	
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )
	
	ply:Freeze( false );
	ply.Frozen = false;
	
	if( tonumber( ply.DeadMode ) != 1 ) then
		
		ply:CreateRagdoll();
		
	end
	
	if( ply:FlashlightIsOn() ) then
		
		ply:Flashlight( false );
		
	end
	
end

function GM:PlayerDeathSound( ply )
	
	if( ply.PainfulDeath ) then
		
		if( ply:IsFemale() ) then
			
			ply:EmitSound( Sound( "vo/npc/female01/pain0" .. tostring( math.random( 1, 9 ) ) .. ".wav" ) );
			
		else
			
			ply:EmitSound( Sound( "vo/npc/male01/pain0" .. tostring( math.random( 1, 9 ) ) .. ".wav" ) );
			
		end
		
		ply.PainfulDeath = nil;
		
	end
	
	return true;
	
end

function GM:PlayerMoveThink()
	
	for _, v in pairs( player.GetAll() ) do
		
		if( !v.NextExhaustDetract ) then v.NextExhaustDetract = CurTime(); end
		
		if( CurTime() > v.NextExhaustDetract ) then
			
			if( v:KeyDown( IN_SPEED ) and v:GetVelocity():Length2D() > 0 and !v:IsEFlagSet( EFL_NOCLIP_ACTIVE ) ) then
				
				V.STAT.SubStatus( v, V.STAT.STATUS_EXHAUSTION );
				
			else
				
				V.STAT.AddStatus( v, V.STAT.STATUS_EXHAUSTION );
				
			end
			
			local RemainTime = 10;
			
			if( v:GetActiveWeapon() != NULL ) then
				
				RemainTime = 5;
				
			end
			
			v.NextExhaustDetract = CurTime() + RemainTime;
			
		end
		
		local walk, run = GAMEMODE:GetPlayerSpeed( v );
		
		if( v:GetRunSpeed() != run ) then
			
			v:SetRunSpeed( run );
			
		end
		
		if( v:GetWalkSpeed() != walk ) then
			
			v:SetWalkSpeed( walk );
			
		end
		
	end
	
end

function GM:PlayerCanHearPlayersVoice( targ, ply )
	
	if( targ.CharCreate ) then return false, false; end
	
	local d = targ:GetPos():Distance( ply:GetPos() );
	
	if( d < V.Config.MaxVoiceDistance ) then
		
		return true, false;
		
	end
	
	return false, false;
	
end