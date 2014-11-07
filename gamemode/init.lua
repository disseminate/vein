-- Vein. Started 6/25/2011 by Disseminate.

include( "shared.lua" );
include( "sh_accessor.lua" );
include( "sh_admin.lua" );
include( "sh_anims.lua" );
include( "sh_chatcmd.lua" );
include( "sh_items.lua" );
include( "sh_mapedit.lua" );
include( "sh_weather.lua" );
include( "sh_widgets.lua" );
include( "sv_concommand.lua" );
include( "sv_dev.lua" );
include( "sv_items.lua" );
include( "sv_log.lua" );
include( "sv_navigation.lua" );
include( "sv_net.lua" );
include( "sv_player.lua" );
include( "sv_resource.lua" );
include( "sv_security.lua" );
include( "sv_sql.lua" );
include( "sv_status.lua" );
include( "sv_think.lua" );
include( "sv_zombie.lua" );

include( "sh_config.lua" );
include( "sv_config.lua" );

AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "gui/vskin.lua" );
AddCSLuaFile( "gui/vinventoryitem.lua" );
AddCSLuaFile( "gui/vcharpanel.lua" );
AddCSLuaFile( "gui/vstatusmodel.lua" );
AddCSLuaFile( "gui/vprogressbar.lua" );
AddCSLuaFile( "gui/vhorizontalrule.lua" );
AddCSLuaFile( "gui/vblackscreen.lua" );
AddCSLuaFile( "gui/vpropertysheet.lua" );
AddCSLuaFile( "gui/vnumslider.lua" );
AddCSLuaFile( "gui/vworldoverlay.lua" );
AddCSLuaFile( "gui/vinventoryitemslot.lua" );
AddCSLuaFile( "shared.lua" );
AddCSLuaFile( "gui/util.lua" );
AddCSLuaFile( "sh_accessor.lua" );
AddCSLuaFile( "sh_admin.lua" );
AddCSLuaFile( "sh_anims.lua" );
AddCSLuaFile( "sh_chatcmd.lua" );
AddCSLuaFile( "sh_items.lua" );
AddCSLuaFile( "sh_mapedit.lua" );
AddCSLuaFile( "sh_weather.lua" );
AddCSLuaFile( "sh_widgets.lua" );
AddCSLuaFile( "cl_binds.lua" );
AddCSLuaFile( "cl_charcreate.lua" );
AddCSLuaFile( "cl_chatbox.lua" );
AddCSLuaFile( "cl_credits.lua" );
AddCSLuaFile( "cl_dev.lua" );
AddCSLuaFile( "cl_effects.lua" );
AddCSLuaFile( "cl_hud.lua" );
AddCSLuaFile( "cl_insanity.lua" );
AddCSLuaFile( "cl_inventory.lua" );
AddCSLuaFile( "cl_misc.lua" );
AddCSLuaFile( "cl_scoreboard.lua" );
AddCSLuaFile( "cl_settings.lua" );
AddCSLuaFile( "cl_status.lua" );
AddCSLuaFile( "cl_statusmenu.lua" );
AddCSLuaFile( "cl_think.lua" );

AddCSLuaFile( "sh_config.lua" );

local files = file.Find( GM.FolderName .. "/gamemode/mapdata/" .. game.GetMap() .. ".lua", "LUA", "namedesc" );

for _, v in pairs( files ) do
	
	include( "mapdata/" .. v );
	
end

local files = file.Find( GM.FolderName .. "/gamemode/cl_mapdata/" .. game.GetMap() .. ".lua", "LUA", "namedesc" );

for _, v in pairs( files ) do
	
	AddCSLuaFile( "cl_mapdata/" .. v );
	
end

function GM:Initialize()
	
	game.ConsoleCommand( "net_maxfilesize 64\n" );
	game.ConsoleCommand( "sv_kickerrornum 0\n" );
	game.ConsoleCommand( "lua_log_sv 1\n" );
	
	V.ValidateDirectories();
	
	V.SQL.CheckMode();
	
	V.W.Initialize();
	
end