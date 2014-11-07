if( SERVER ) then
	
	AddCSLuaFile( "shared.lua" );
	
end

SWEP.Base				= "weapon_vein_melee_base";

SWEP.PrintName 			= "Plank";

SWEP.ViewModel 			= "models/weapons/vein/v_plank.mdl";
SWEP.WorldModel 		= "models/weapons/vein/w_plank.mdl";

SWEP.Holdtype			= "melee";
SWEP.HitSounds			= {
	"weapons/vein/plank/01.wav",
	"weapons/vein/plank/02.wav",
	"weapons/vein/plank/03.wav",
	"weapons/vein/plank/04.wav"
};