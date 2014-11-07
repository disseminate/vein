include( "gui/vskin.lua" );

include( "gui/vinventoryitem.lua" );
include( "gui/vcharpanel.lua" );
include( "gui/vstatusmodel.lua" );
include( "gui/vprogressbar.lua" );
include( "gui/vhorizontalrule.lua" );
include( "gui/vblackscreen.lua" );
include( "gui/vpropertysheet.lua" );
include( "gui/vnumslider.lua" );
include( "gui/vworldoverlay.lua" );
include( "gui/vinventoryitemslot.lua" );

include( "shared.lua" );

include( "gui/util.lua" );

include( "sh_accessor.lua" );
include( "sh_admin.lua" );
include( "sh_anims.lua" );
include( "sh_chatcmd.lua" );
include( "sh_items.lua" );
include( "sh_mapedit.lua" );
include( "sh_weather.lua" );
include( "sh_widgets.lua" );
include( "cl_binds.lua" );
include( "cl_charcreate.lua" );
include( "cl_chatbox.lua" );
include( "cl_credits.lua" );
include( "cl_dev.lua" );
include( "cl_effects.lua" );
include( "cl_hud.lua" );
include( "cl_insanity.lua" );
include( "cl_inventory.lua" );
include( "cl_misc.lua" );
include( "cl_scoreboard.lua" );
include( "cl_settings.lua" );
include( "cl_status.lua" );
include( "cl_statusmenu.lua" );
include( "cl_think.lua" );

include( "sh_config.lua" );

local files = file.Find( GM.FolderName .. "/gamemode/cl_mapdata/" .. game.GetMap() .. ".lua", "LUA", "namedesc" );

for _, v in pairs( files ) do
	
	include( "cl_mapdata/" .. v );
	
end

function GM:Initialize()
	
	V.ValidateDirectories();
	V.SET.LoadSettings();
	
end

V.FirstSession = false;

function netSession( len )
	
	V.FirstSession = true;
	
end
net.Receive( "Session", netSession );