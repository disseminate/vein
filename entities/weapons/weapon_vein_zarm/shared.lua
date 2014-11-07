if( SERVER ) then
	
	AddCSLuaFile( "shared.lua" );
	
end

SWEP.Base				= "weapon_vein_melee_base";

SWEP.PrintName 			= "Zombie Arm";

SWEP.ViewModel 			= "models/weapons/vein/v_zarm.mdl";
SWEP.WorldModel 		= "models/weapons/vein/w_zarm.mdl";

SWEP.HitSounds			= {
	"physics/flesh/flesh_squishy_impact_hard1.wav",
	"physics/flesh/flesh_squishy_impact_hard2.wav",
	"physics/flesh/flesh_squishy_impact_hard3.wav",
	"physics/flesh/flesh_squishy_impact_hard4.wav",
};
SWEP.Length				= 80;
