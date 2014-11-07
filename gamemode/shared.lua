DeriveGamemode( "base" );

V = { };
local meta = FindMetaTable( "Player" );
local emeta = FindMetaTable( "Entity" );

GM.Name = "Vein";
GM.Author = "Disseminate";
GM.Website = "http://facepunch.com/showthread.php?t=1148261";
GM.Email = "disseminate@luaforfood.com";

math.randomseed( os.time() );

game.AddParticles( "particles/vman_nuke.pcf" );
PrecacheParticleSystem( "dustwave_tracer" );

function meta:IsFemale()
	
	if( string.find( string.lower( self:GetModel() ), "female" ) ) then
		
		return true;
		
	end
	
	return false;
	
end

function V.ModelToInt( mdl, skin )
	
	for k, v in pairs( V.MaleValidModels ) do
		
		if( v.Model == mdl and table.HasValue( v.Skin, skin ) ) then
			
			return k;
			
		end
		
	end
	
	for k, v in pairs( V.FemaleValidModels ) do
		
		if( v.Model == mdl and table.HasValue( v.Skin, skin ) ) then
			
			return k;
			
		end
		
	end
	
end

function V.GoodChar( model, skin, gender, name, desc )
	
	if( gender != 0 and gender != 1 ) then
		
		return false, "Invalid gender!";
		
	end
	
	if( gender == 0 and !V.MaleValidModels[model] ) then
		
		return false, "Invalid model!";
		
	end
	
	if( gender == 1 and !V.FemaleValidModels[model] ) then
		
		return false, "Invalid model!";
		
	end
	
	if( gender == 0 and !table.HasValue( V.MaleValidModels[model].Skin, skin ) ) then
		
		return false, "Invalid skin!";
		
	end
	
	if( gender == 1 and !table.HasValue( V.FemaleValidModels[model].Skin, skin ) ) then
		
		return false, "Invalid skin!";
		
	end
	
	if( string.len( name ) < 5 ) then
		
		return false, "Name is too short.";
		
	end
	
	if( string.len( name ) > 30 ) then
		
		return false, "Name is too long.";
		
	end
	
	if( string.len( desc ) > V.Config.MaxDescLen ) then
		
		return false, "Description is too long.";
		
	end
	
	return true;
	
end

function GM:GetGameDescription()
	
	return "Vein";
	
end

function V.FindPlayer( name )
	
	name = string.lower( name );
	
	for k, v in pairs( player.GetAll() ) do
		
		if( string.find( string.lower( v:RPName() ), name ) ) then
			return v;
		end
		
		if( string.find( string.lower( v:Nick() ), name ) ) then
			return v;
		end
		
		if( string.lower( v:SteamID() ) == name ) then
			return v;
		end
		
	end

end

function V.ValidateDirectories()
	
	if( !file.IsDir( "Vein", "DATA" ) ) then
		
		file.CreateDir( "Vein" );
		
	end
	
	if( !file.IsDir( "Vein/logs", "DATA" ) ) then
		
		file.CreateDir( "Vein/logs" );
		
	end
	
	if( !file.IsDir( "Vein/settings", "DATA" ) ) then
		
		file.CreateDir( "Vein/settings" );
		file.Write( "Vein/settings/settings.txt", "" );
		
	end
	
	if( !file.IsDir( "Vein/mapdata", "DATA" ) ) then
		
		file.CreateDir( "Vein/mapdata" );
		
	end
	
	if( !file.IsDir( "Vein/navmeshes", "DATA" ) ) then
		
		file.CreateDir( "Vein/navmeshes" );
		
	end
	
end

function meta:CanSee( ent )
	
	local trace = { };
	trace.start = self:EyePos();
	trace.endpos = ent:EyePos();
	trace.filter = { self, ent };
	trace.mask = MASK_VISIBLE;
	local tr = util.TraceLine( trace );
	
	if( tr.Fraction == 1.0 ) then
		
		return true;
		
	end
	
	return false;
	
end

function meta:CanHear( ent )
	
	local trace = { };
	trace.start = self:EyePos();
	trace.endpos = ent:EyePos();
	trace.filter = self;
	trace.mask = MASK_SOLID;
	local tr = util.TraceLine( trace );
	
	if( IsValid( tr.Entity ) and tr.Entity:EntIndex() == ent:EntIndex() ) then
		
		return true;
		
	end
	
	return false;
	
end

function meta:CanSeePos( pos )
	
	local trace = { };
	trace.start = self:EyePos();
	trace.endpos = pos;
	trace.filter = self;
	local tr = util.TraceLine( trace );
	
	if( tr.Fraction == 1.0 ) then
		
		return true;
		
	end
	
	return false;
	
end

function GM:GetPlayerSpeed( ply )
	
	local walk = 110;
	local run = 250;
	
	run = run + ( ( run - walk ) / 4 ) * V.STAT.GetStatus( ply, V.STAT.STATUS_EXHAUSTION );
	
	local invPerc = ( 250 - V.I.GetWeight( ply ) ) / 250;
	
	walk = walk * invPerc;
	run = run * invPerc;
	
	return walk, run;
	
end

function GM:Move( ply, data )
	
	if( !ply or !ply:IsValid() ) then return end
	
	if( ply.Chair and ply.Chair:IsValid() ) then
		
		data:SetVelocity( Vector() );
		return true;
		
	end
	
	if( ply.Asleep ) then
		
		data:SetVelocity( Vector() );
		return true;
		
	end
	
	if( ply.LastShot and CurTime() - ply.LastShot < ply.LastShotDelay + 0.1 ) then
		
		data:SetMaxSpeed( 0 );
		data:SetVelocity( Vector() );
		
	end
	
end

function GM:SetupMove( ply, data )
	
	if( !ply or !ply:IsValid() ) then return end
	
	if( ply.Chair and ply.Chair:IsValid() ) then
		
		data:SetVelocity( Vector() );
		data:SetOrigin( ply.Chair:GetPos() );
		return true;
		
	end
	
end

V.CCMODE_CREATE_N = 0;
V.CCMODE_SELECT_N = 1;
V.CCMODE_DELETE = 2;
V.CCMODE_CREATE = 3;
V.CCMODE_SELECT = 4;

V.ZombieModels = {
	"models/nmr_zombie/berny.mdl",
	"models/nmr_zombie/casual_02.mdl",
	"models/nmr_zombie/herby.mdl",
	"models/nmr_zombie/jogger.mdl",
	"models/nmr_zombie/julie.mdl",
	"models/nmr_zombie/maxx.mdl",
	"models/nmr_zombie/officezom.mdl",
	"models/nmr_zombie/toby.mdl",
};

V.InstantCrushDeath = {
	"func_tracktrain",
};

function emeta:IsZombie()
	
	return ( self:GetClass() == "v_zombie" );
	
end

function GM:ShouldCollide( e1, e2 )
	
	if( e1 and e2 and e1:IsValid() and e2:IsValid() ) then
		
		if( e1:IsZombie() and e2:IsZombie() ) then return false end
		if( e1:IsPlayer() and e2:IsPlayer() ) then return false end
		
		if( e1:IsPlayer() and e2:IsNotSolid() ) then return false end
		if( e2:IsPlayer() and e1:IsNotSolid() ) then return false end
		
	end
	
	return true;
	
end

function V.SanitizeString( arg )
	
	local ret = string.lower( arg );
	ret = string.gsub( ret, "[^%a^%s]", "" );
	ret = string.gsub( ret, " his", "" );
	ret = string.gsub( ret, " her", "" );
	ret = string.gsub( ret, " their", "" );
	ret = string.gsub( ret, " its", "" );
	ret = string.gsub( ret, " the", "" );
	ret = string.gsub( ret, " to", "" );
	ret = string.gsub( ret, " a", "" );
	ret = string.gsub( ret, " him", "" );
	ret = string.Trim( ret );
	return ret;
	
end

function V.OnScreen( ply, ent )
	
	if( type( ent ) != "Entity" and type( ent ) != "NPC" ) then
		
		local d = ply:GetAimVector():Dot( ( ent - ply:GetPos() ):GetNormal() );
		
		if( d > 0.55 ) then
			
			return true;
			
		end
		
		return false;
		
	end
	
	local d = ply:GetAimVector():Dot( ( ent:GetPos() - ply:GetPos() ):GetNormal() );
	
	if( d > 0.55 ) then
		
		return true;
		
	end
	
	return false;
	
end

function V.GetAimMod( ply )
	
	return 1;
	
end

function V.Outside( pos )
	
	local trace = { };
	trace.start = pos;
	trace.endpos = trace.start + Vector( 0, 0, 32768 );
	trace.mask = MASK_BLOCKLOS;
	local tr = util.TraceLine( trace );
	
	if( tr.HitSky ) then return true end
	
	return false;
	
end

function GM:OnReloaded()
	
	if( SERVER ) then
		
		
		
	else
		
		--V.CC.KillVGUIComponents();
		
	end
	
end

V.MD = { };

function V.MD.InitPostEntity()
	
end