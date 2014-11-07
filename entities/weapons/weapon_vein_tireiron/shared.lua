if( SERVER ) then
	
	AddCSLuaFile( "shared.lua" );
	
end

SWEP.Base				= "weapon_vein_melee_base";

SWEP.PrintName 			= "Tire Iron";

SWEP.ViewModel 			= "models/weapons/vein/v_tireiron.mdl";
SWEP.WorldModel 		= "models/weapons/vein/w_tireiron.mdl";

SWEP.HitSounds			= {
	"weapons/vein/bat/01.wav",
	"weapons/vein/bat/02.wav",
	"weapons/vein/bat/03.wav",
	"weapons/vein/bat/04.wav"
};
SWEP.Length				= 120;
