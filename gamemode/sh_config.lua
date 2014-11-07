V.Config = { };

local files = file.Find( GM.FolderName .. "/gamemode/config/*.lua", "LUA", "namedesc" );

for _, v in pairs( files ) do
	
	if( SERVER ) then
		
		AddCSLuaFile( "config/" .. v );
		
	end
	
	include( "config/" .. v );
	
end

if( !game.IsDedicated() ) then
	
	V.Config.CharacterSafeTime = 0;
	V.Config.PVPDamage = false;
	V.Config.ZombieTurnTime = 60;
	
end