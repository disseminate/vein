V.ADMIN = { };

if( CLIENT ) then
	
	function V.ADMIN.LISTCOMMANDS( len )
		
		local str = net.ReadString();
		local expl = string.Explode( "\n", str );
		
		for _, v in pairs( expl ) do
			
			MsgC( Color( 229, 201, 91, 255 ), v .. "\n" );
			
		end
		
	end
	net.Receive( "nAdminListCommands", V.ADMIN.LISTCOMMANDS );
	
	function V.ADMIN.nAdminNoRegular()
		
		V.CB.AddToChat( "Error: You must be an admin to do that.", Color( 200, 0, 0, 255 ), "VCandara20", { 1, 3 } );
		
	end
	net.Receive( "nAdminNoRegular", V.ADMIN.nAdminNoRegular );
	
	function V.ADMIN.nAdminNoSuper()
		
		V.CB.AddToChat( "Error: You must be a superadmin to do that.", Color( 200, 0, 0, 255 ), "VCandara20", { 1, 3 } );
		
	end
	net.Receive( "nAdminNoSuper", V.ADMIN.nAdminNoSuper );
	
	function V.ADMIN.nAdminNoTarget()
		
		V.CB.AddToChat( "Error: No target specified.", Color( 200, 0, 0, 255 ), "VCandara20", { 1, 3 } );
		
	end
	net.Receive( "nAdminNoTarget", V.ADMIN.nAdminNoTarget );
	
	function V.ADMIN.nAdminNoValue()
		
		V.CB.AddToChat( "Error: No value specified.", Color( 200, 0, 0, 255 ), "VCandara20", { 1, 3 } );
		
	end
	net.Receive( "nAdminNoValue", V.ADMIN.nAdminNoValue );
	
	function V.ADMIN.nAdminInvalidValue()
		
		V.CB.AddToChat( "Error: Invalid value specified.", Color( 200, 0, 0, 255 ), "VCandara20", { 1, 3 } );
		
	end
	net.Receive( "nAdminInvalidValue", V.ADMIN.nAdminInvalidValue );
	
	function V.ADMIN.nAdminNoTargetF()
		
		V.CB.AddToChat( "Error: No target found.", Color( 200, 0, 0, 255 ), "VCandara20", { 1, 3 } );
		
	end
	net.Receive( "nAdminNoTargetF", V.ADMIN.nAdminNoTargetF );
	
	function V.ADMIN.nAdminNoZombie()
		
		V.CB.AddToChat( "Error: Could not spawn zombie.", Color( 200, 0, 0, 255 ), "VCandara20", { 1, 3 } );
		
	end
	net.Receive( "nAdminNoZombie", V.ADMIN.nAdminNoZombie );
	
	function V.ADMIN.nAdminInvalidBantime()
		
		V.CB.AddToChat( "Error: Invalid ban time.", Color( 200, 0, 0, 255 ), "VCandara20", { 1, 3 } );
		
	end
	net.Receive( "nAdminInvalidBantime", V.ADMIN.nAdminInvalidBantime );
	
	function V.ADMIN.nAdminRestart( len )
		
		local ply = net.ReadEntity();
		
		V.CB.AddToChat( ply:Nick() .. " is restarting the server in five seconds.", Color( 200, 0, 0, 255 ), "VCandara30", { 1, 2, 3 } );
		
	end
	net.Receive( "nAdminRestart", V.ADMIN.nAdminRestart );
	
	function V.ADMIN.nAdminKick( len )
		
		local nick = net.ReadString();
		local ply = net.ReadEntity();
		local reason = net.ReadString();
		
		if( string.len( reason ) > 0 ) then
			
			V.CB.AddToChat( ply:Nick() .. " kicked " .. nick .. ": \"" .. reason .. "\"", Color( 229, 201, 98, 255 ), "VCandara20", { 1, 3 } );
			
		else
			
			V.CB.AddToChat( ply:Nick() .. " kicked " .. nick, Color( 229, 201, 98, 255 ), "VCandara20", { 1, 3 } );
			
		end
		
	end
	net.Receive( "nAdminKick", V.ADMIN.nAdminKick );
	
	function V.ADMIN.nAdminBan( len )
		
		local nick = net.ReadString();
		local ply = net.ReadEntity();
		local time = net.ReadFloat();
		local reason = net.ReadString();
		
		local col = ": ";
		
		if( string.len( reason ) == 0 ) then
			
			col = "";
			
		end
		
		if( time == 0 ) then
			
			V.CB.AddToChat( ply:Nick() .. " permabanned " .. nick .. col .. "\"" .. reason .. "\"", Color( 229, 201, 98, 255 ), "VCandara20", { 1, 3 } );
			
		else
			
			V.CB.AddToChat( ply:Nick() .. " banned " .. nick .. " for " .. tostring( time ) .. " minutes" .. col .. "\"" .. reason .. "\"", Color( 229, 201, 98, 255 ), "VCandara20", { 1, 3 } );
			
		end
		
	end
	net.Receive( "nAdminBan", V.ADMIN.nAdminBan );
	
	function V.ADMIN.nAdminToggleSeeAll( len )
		
		V.SeeAll = !V.SeeAll;
		
	end
	net.Receive( "nAdminToggleSeeAll", V.ADMIN.nAdminToggleSeeAll );
	
	function V.ADMIN.nAdminGiveItem()
		
		local ply = net.ReadEntity();
		local item = net.ReadString();
		V.CB.AddToChat( "Gave " .. item .. " to " .. ply:Nick(), Color( 229, 201, 98, 255 ), "VCandara20", { 1, 3 } );
		
	end
	net.Receive( "nAdminGiveItem", V.ADMIN.nAdminGiveItem );
	
	function V.ADMIN.nAdminReceiveItem()
		
		local ply = net.ReadEntity();
		local item = net.ReadString();
		V.CB.AddToChat( "Received " .. item .. " from " .. ply:Nick(), Color( 229, 201, 98, 255 ), "VCandara20", { 1, 3 } );
		
	end
	net.Receive( "nAdminReceiveItem", V.ADMIN.nAdminReceiveItem );
	
end

V.ADMIN.Commands = { };

function V.ADMIN.RPA( ply, cmd, args )
	
	if( !ply:IsAdmin() ) then
		
		net.Start( "nAdminNoRegular" );
		net.Send( ply );
		return;
		
	end
	
	local c = args[1];
	
	if( !c ) then
		
		local str = "";
		
		for k, v in pairs( V.ADMIN.Commands ) do
			
			str = str .. k .. " " .. v.HelpArgs .. "\t\t\t" .. v.Desc .. "\n";
			
		end
		
		net.Start( "nAdminListCommands" );
			net.WriteString( str );
		net.Send( ply );
		
	else
		
		if( V.ADMIN.Commands[c] ) then
			
			if( V.ADMIN.Commands[c].SA and !ply:IsSuperAdmin() ) then
				
				net.Start( "nAdminNoSuper" );
				net.Send( ply );
				return;
				
			end
			
			if( #args - 1 < V.ADMIN.Commands[c].RequiredArgs ) then
				
				net.Start( V.ADMIN.Commands[c].ArgMessage );
				net.Send( ply );
				return;
				
			end
			
			table.remove( args, 1 );
			V.ADMIN.Commands[c].Func( ply, args );
			
		end
		
	end
	
end
if( SERVER ) then
	concommand.Add( "rpa", V.ADMIN.RPA );
end

function V.ADMIN.RegisterCommand( tab )
	
	tab.SA 				= tab.SA or false;
	tab.RequiredArgs 	= tab.RequiredArgs or 0;
	tab.ArgMessage 		= tab.ArgMessage or "nAdminNoValue";
	tab.HelpArgs 		= tab.HelpArgs or "";
	tab.Desc 			= tab.Desc or "";
	
	V.ADMIN.Commands[tab.Command] = tab;
	
end

local function Restart( ply, args )
	
	net.Start( "nAdminRestart" );
		net.WriteEntity( ply );
	net.Broadcast();
	
	timer.Simple( 5, function() game.ConsoleCommand( "changelevel " .. game.GetMap() .. "\n" ) end );
	
end

local tab 	= { };
	tab.Command = "restart";
	tab.Func 	= Restart;
	tab.SA 		= true;
	tab.Desc 	= "Restart the server.";
V.ADMIN.RegisterCommand( tab );

local function Kick( ply, args )
	
	local targ = V.FindPlayer( args[1] );
	local reason = args[2] or "";
	
	if( targ and targ:IsValid() ) then
		
		local nick = targ:Nick();
		
		V.SEC.Drop( targ:UserID(), reason );
		
		net.Start( "nAdminKick" );
			net.WriteString( nick );
			net.WriteEntity( ply );
			net.WriteString( reason );
		net.Broadcast();
		
	else
		
		net.Start( "nAdminNoTargetF" );
		net.Send( ply );
		
	end
	
end

local tab = { };
	tab.Command 		= "kick";
	tab.Func 			= Kick;
	tab.RequiredArgs 	= 1;
	tab.ArgMessage 		= "nAdminNoTarget";
	tab.HelpArgs 		= "[target] (reason)";
	tab.Desc 			= "Kick a player.";
V.ADMIN.RegisterCommand( tab );

local function Ban( ply, args )
	
	if( !args[2] or !tonumber( args[2] ) or tonumber( args[2] ) < 0 or tonumber( args[2] ) > 604800 ) then
		
		net.Start( "nAdminInvalidBantime" );
		net.Send( ply );
		return;
		
	end
	
	local targ = V.FindPlayer( args[1] );
	local time = tonumber( args[2] );
	local reason = args[3];
	
	if( targ and targ:IsValid() ) then
		
		local nick = targ:Nick();
		
		targ:Ban( time, reason or "Banned by " .. ply:Nick() );
		
		V.SEC.Drop( targ:UserID(), reason or "Banned by " .. ply:Nick() );
		
		net.Start( "nAdminBan" );
			net.WriteString( nick );
			net.WriteEntity( ply );
			net.WriteFloat( time );
			net.WriteString( reason or "" );
		net.Broadcast();
		
	else
		
		net.Start( "nAdminNoTargetF" );
		net.Send( ply );
		
	end
	
end

local tab = { };
	tab.Command 		= "ban";
	tab.Func 			= Ban;
	tab.RequiredArgs 	= 1;
	tab.ArgMessages 	= "nAdminNoTarget";
	tab.HelpArgs 		= "[target] [time] (reason)";
	tab.Desc 			= "Ban a player.";
V.ADMIN.RegisterCommand( tab );

local function Observe( ply, args )
	
	if( not ply:IsEFlagSet( EFL_NOCLIP_ACTIVE ) ) then
		
		ply:GodEnable();
		
		if( V.Config.InvisibleObserve ) then
			
			ply:SetNoDraw( true );
			
		end
		
		ply:SetNotSolid( true );
		ply:SetMoveType( 8 );
		
		ply:AddEFlags( EFL_NOCLIP_ACTIVE );
		
	else
		
		ply:GodDisable();
		
		if( V.Config.InvisibleObserve ) then
			
			ply:SetNoDraw( false );
			
		end
		
		ply:SetNotSolid( false );
		ply:SetMoveType( 2 );
		
		ply:RemoveEFlags( EFL_NOCLIP_ACTIVE );
		
	end
	
end

local tab = { };
	tab.Command = "observe";
	tab.Func 	= Observe;
	tab.Desc 	= "Enter noclip."
V.ADMIN.RegisterCommand( tab );

local function Goto( ply, args )
	
	local targ = V.FindPlayer( args[1] );
	
	if( targ and targ:IsValid() ) then
		
		ply:SetPos( targ:GetPos() );
		
	else
		
		net.Start( "nAdminNoTargetF" );
		net.Send( ply );
		
	end
	
end

local tab = { };
	tab.Command = "goto";
	tab.Func 	= Goto;
	tab.Desc 	= "Teleport to a player."
V.ADMIN.RegisterCommand( tab );

local function Bring( ply, args )
	
	local targ = V.FindPlayer( args[1] );
	
	if( targ and targ:IsValid() ) then
		
		targ:SetPos( ply:GetPos() );
		
	else
		
		net.Start( "nAdminNoTargetF" );
		net.Send( ply );
		
	end
	
end

local tab = { };
	tab.Command = "bring";
	tab.Func 	= Bring;
	tab.Desc 	= "Teleport a player to you."
V.ADMIN.RegisterCommand( tab );

local function SeeAll( ply, args )
	
	net.Start( "nAdminToggleSeeAll" );
	net.Send( ply );
	
end

local tab = { };
	tab.Command = "seeall";
	tab.Func 	= SeeAll;
	tab.Desc 	= "Toggle SeeAll mode."
V.ADMIN.RegisterCommand( tab );

local function GiveItem( ply, args )
	
	local targ;
	local itemid;
	
	if( #args == 1 ) then
		
		local trace = { };
		trace.start = ply:EyePos();
		trace.endpos = trace.start + ply:GetAimVector() * 4096;
		trace.filter = ply;
		
		local tr = util.TraceLine( trace );
		
		targ = tr.Entity;
		
		if( !tr.Entity or !tr.Entity:IsValid() or !tr.Entity:IsPlayer() ) then
			
			targ = ply;
			
		end
		
		if( !V.I.GetItemByID( args[1] ) ) then
			
			net.Start( "nAdminInvalidValue" );
			net.Send( ply );
			return;
			
		end
		
		itemid = args[1];
		
	else
		
		targ = V.FindPlayer( args[1] );
		
		if( !V.I.GetItemByID( args[2] ) ) then
			
			net.Start( "nAdminInvalidValue" );
			net.Send( ply );
			return;
			
		end
		
		itemid = args[2];
		
	end
	
	if( !args[3] ) then args[3] = "1" end
	
	if( tonumber( args[3] ) < 1 ) then
		
		net.Start( "nAdminInvalidValue" );
		net.Send( ply );
		return;
		
	end
	
	if( targ and targ:IsValid() and targ:IsPlayer() ) then
		
		V.I.GiveItem( targ, itemid, tonumber( args[3] ), true );
		
		net.Start( "nAdminGiveItem" );
			net.WriteEntity( targ );
			net.WriteString( V.I.GetItemByID( itemid ).Name );
		net.Send( ply );
		
		if( ply != targ ) then
			
			net.Start( "nAdminReceiveItem" );
				net.WriteEntity( ply );
				net.WriteString( V.I.GetItemByID( itemid ).Name );
			net.Send( targ );
			
		end
		
	else
		
		net.Start( "nAdminNoTargetF" );
		net.Send( ply );
		
	end
	
end

local tab = { };
	tab.Command 		= "giveitem";
	tab.Func 			= GiveItem;
	tab.RequiredArgs 	= 1;
	tab.ArgMessages 	= "nAdminNoValue";
	tab.HelpArgs 		= "[target] [item] (stack amount)";
	tab.Desc 			= "Give a player an item.";
V.ADMIN.RegisterCommand( tab );

local function ListItems( ply, cmd, args )
	
	for _, v in pairs( V.I.Items ) do
		
		ply:PrintMessage( 2, v.Name .. " - \"" .. v.ID .. "\"" );
		
	end
	
end

local tab = { };
	tab.Command = "listitems";
	tab.Func 	= ListItems;
	tab.Desc	= "List all items.";
V.ADMIN.RegisterCommand( tab );

local function ChangeModel( ply, args )
	
	local targ = V.FindPlayer( args[1] );
	local model = args[2];
	local skin = args[3] or 0;
	
	if( targ and targ:IsValid() ) then
		
		targ:SetModel( model );
		targ:SetSkin( skin );
		
		V.SQL.SaveCharacterField( ply, "Model", model );
		V.SQL.SaveCharacterField( ply, "Skin", skin );
		
	else
		
		net.Start( "nAdminNoTargetF" );
		net.Send( ply );
		
	end
	
end

local tab = { };
	tab.Command 		= "changemodel";
	tab.Func 			= ChangeModel;
	tab.RequiredArgs 	= 2;
	tab.ArgMessages 	= "nAdminNoValue";
	tab.HelpArgs 		= "[target] [model] (skin)";
	tab.Desc 			= "Set a character's model.";
V.ADMIN.RegisterCommand( tab );

local function SetRain( ply, args )
	
	local b = tobool( args[1] );
	V.W.SetRain( b );
	
end

local tab = { };
	tab.Command 		= "setrain";
	tab.Func 			= SetRain;
	tab.RequiredArgs 	= 1;
	tab.ArgMessages 	= "nAdminNoValue";
	tab.HelpArgs 		= "[0/1]";
	tab.Desc 			= "Set if its raining or not.";
V.ADMIN.RegisterCommand( tab );

local function PlayMusic( ply, args )
	
	local h = false;
	
	for _, v in pairs( V.Music ) do
		
		if( args[1] == v[1] ) then
			
			h = true;
			
		end
		
	end
	
	if( h ) then
		
		net.Start( "nEffectPlayMusic" );
			net.WriteString( "vein/" .. args[1] .. ".mp3" );
			net.WriteFloat( 1 );
		net.Broadcast();
		
	else
		
		net.Start( "nAdminInvalidValue" );
		net.Send( ply );
		
	end
	
end

local tab = { };
	tab.Command 		= "playmusic";
	tab.Func 			= PlayMusic;
	tab.RequiredArgs 	= 1;
	tab.ArgMessages 	= "nAdminNoValue";
	tab.HelpArgs 		= "[name]";
	tab.Desc 			= "Play a song retrieved with listmusic.";
V.ADMIN.RegisterCommand( tab );

local function ListMusic( ply, cmd, args )
	
	for _, v in pairs( V.Music ) do
		
		ply:PrintMessage( 2, v[1] .. " - " .. string.ToMinutesSeconds( v[2] ) );
		
	end
	
end

local tab = { };
	tab.Command = "listmusic";
	tab.Func 	= ListMusic;
	tab.Desc	= "List all music.";
V.ADMIN.RegisterCommand( tab );

local function CreateZombie( ply, cmd, args )
	
	local trace = { };
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 4096;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	
	if( V.Z.CanSpawnZombie( tr.HitPos, true ) ) then
		
		V.Z.CreateZombie( tr.HitPos, tr.HitNormal );
		
	else
		
		net.Start( "nAdminNoZombie" );
		net.Send( ply );
		
	end
	
end

local tab = { };
	tab.Command = "createzombie";
	tab.Func 	= CreateZombie;
	tab.Desc	= "Spawn a single zombie.";
V.ADMIN.RegisterCommand( tab );

local function ClearZombies( ply, cmd, args )
	
	for _, v in pairs( V.Z.GetZombies() ) do
		
		v:Remove();
		
	end
	
end

local tab = { };
	tab.Command = "clearzombies";
	tab.Func 	= ClearZombies;
	tab.Desc	= "Remove all zombies on the map.";
V.ADMIN.RegisterCommand( tab );

local function AddSeed( ply, cmd, args )
	
	if( !nav ) then return end
	V.NAV.AddSeed( ply:GetEyeTraceNoCursor() );
	
end

local tab = { };
	tab.Command = "nav_addseed";
	tab.Func 	= AddSeed;
	tab.SA		= true;
	tab.Desc	= "Add a navigation seed in the direction you're looking at. You should add a seed wherever you want zombies to be able to go. There only needs to be one seed for every surface area (ie. one outside, one in a sealed room, etc). Run nav_generate after this.";
V.ADMIN.RegisterCommand( tab );

local function GenerateNav( ply, cmd, args )
	
	if( !nav ) then return end
	V.NAV.StartGenerate();
	
end

local tab = { };
	tab.Command = "nav_generate";
	tab.Func 	= GenerateNav;
	tab.SA		= true;
	tab.Desc	= "Generate the navmesh based on the seeds added.";
V.ADMIN.RegisterCommand( tab );

local function ClearNav( ply, cmd, args )
	
	if( !nav ) then return end
	V.NAV.ClearSeeds();
	
end

local tab = { };
	tab.Command = "nav_clearseeds";
	tab.Func 	= ClearNav;
	tab.SA		= true;
	tab.Desc	= "Clear all navseeds.";
V.ADMIN.RegisterCommand( tab );

local function DeleteNav( ply, cmd, args )
	
	if( !nav ) then return end
	V.NAV.Delete();
	
end

local tab = { };
	tab.Command = "nav_delete";
	tab.Func 	= DeleteNav;
	tab.SA		= true;
	tab.Desc	= "Delete the entire navmesh. WARNING - CANNOT BE UNDONE.";
V.ADMIN.RegisterCommand( tab );

local function ToggleZombieSpawning( ply, cmd, args )
	
	V.Config.AutoZombieSpawn = !V.Config.AutoZombieSpawn;
	
end

local tab = { };
	tab.Command = "togglezombiespawning";
	tab.Func 	= ToggleZombieSpawning;
	tab.Desc	= "Toggle zombies automatically spawning.";
V.ADMIN.RegisterCommand( tab );

local function Nuke( ply, args )
	
	V.SQL.Purge();
	V.Nuked = true;
	V.NukedStart = CurTime();
	
	local files = file.Find( "Vein/mapdata/*.txt", "DATA", "namedesc" );
	
	for _, v in pairs( files ) do
		
		file.Delete( "Vein/mapdata/" .. v );
		
	end
	
	net.Start( "nNuke" );
	net.Broadcast();
	
end

function V.NukeThink()
	
	if( V.Nuked ) then
		
		if( !V.NukeInitialDamage ) then
			
			V.NukeInitialDamage = true;
			
			for _, v in pairs( ents.FindByClass( "func_breakable" ) ) do
				
				v:Fire( "Break" );
				
			end
			
			for _, v in pairs( ents.FindByClass( "func_breakable_surf" ) ) do
				
				v:Fire( "Shatter", "0 0 1" );
				
			end
			
			for _, v in pairs( ents.FindByClass( "v_prop" ) ) do
				
				v:Ignite( 30, 1 );
				
			end
			
			for _, v in pairs( ents.FindByClass( "prop_door_rotating" ) ) do
				
				v:Ignite( 30, 1 );
				
			end
			
			for _, v in pairs( player.GetAll() ) do
				
				v:Ignite( 30, 1 );
				
			end
			
			util.ScreenShake( Vector( 0, 0, 0 ), 2, 10, 50, 32768 );
			
			if( V.NukePos ) then
				
				local e = ents.Create( "info_particle_system" );
				e:SetPos( V.NukePos );
				e:SetKeyValue( "effect_name", "vman_nuke" );
				e:SetKeyValue( "start_active", "1" );
				e:Spawn();
				e:Activate();
				
			end
			
		end
		
		if( CurTime() - V.NukedStart > 6 and !V.NukeShock and V.NukePos ) then
			
			V.NukeShock = true;
			
			ParticleEffect( "dustwave_tracer", V.NukePos, Angle() );
			
		end
		
		if( CurTime() - V.NukedStart > 7.5 and !V.NukeArrived ) then
			
			V.NukeArrived = true;
			
			for _, v in pairs( player.GetAll() ) do
				
				v:ViewPunch( Angle( -30, 0, 0 ) );
				
			end
			
			for _, v in pairs( ents.FindByClass( "func_breakable_surf" ) ) do
				
				v:Fire( "Shatter", "0 0 32768" );
				
			end
			
			for _, v in pairs( ents.FindByClass( "v_zombie" ) ) do
				
				v:Die();
				
			end
			
			for _, v in pairs( ents.FindByClass( "v_survivor" ) ) do
				
				v:Die();
				
			end
			
			util.ScreenShake( Vector( 0, 0, 0 ), 200, 100, 200, 32768 );
			
			if( V.NukePos ) then
				
				for _, v in pairs( player.GetAll() ) do
					
					local f = ( v:GetPos() - V.NukePos ):GetNormal() * 400 + Vector( 0, 0, math.random( 100, 200 ) );
					v:SetVelocity( f );
					
				end
				
			end
			
		end
		
		if( CurTime() - V.NukedStart > 30 ) then
			
			game.ConsoleCommand( "changelevel " .. game.GetMap() .. "\n" );
			
		end
		
	end
	
end

local tab 	= { };
	tab.Command = "nuke";
	tab.Func 	= Nuke;
	tab.SA 		= true;
	tab.Desc 	= "Drop a nuclear bomb (will wipe database).";
V.ADMIN.RegisterCommand( tab );