if( SERVER ) then
	
	AddCSLuaFile( "shared.lua" );
	
end

SWEP.Base				= "weapon_vein_throwable_base";

SWEP.PrintName 			= "Molotov";

SWEP.ViewModel 			= "models/weapons/vein/v_molotov.mdl";
SWEP.WorldModel 		= "models/weapons/vein/w_molotov.mdl";

SWEP.ThrowItem			= "molotov";
SWEP.ThrowEnt			= "v_molotov";