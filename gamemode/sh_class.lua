local PLAYER_CLASS = { };

PLAYER_CLASS.DisplayName 	= "Vein";

function PLAYER_CLASS:GetHandsModel()
	
	return { model = "models/weapons/c_arms_cstrike.mdl", skin = 1, body = "0100000" };
	
end

player_manager.RegisterClass( "player_vein", PLAYER_CLASS, "player_default" );