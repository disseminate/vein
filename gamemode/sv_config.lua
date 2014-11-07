local files = file.Find( GM.FolderName .. "/gamemode/sv_config/*.lua", "LUA", "namedesc" );

for _, v in pairs( files ) do
	
	include( "sv_config/" .. v );
	
end
