if( SERVER ) then
	
	AddCSLuaFile( "shared.lua" );
	
end

SWEP.Base				= "weapon_vein_melee_base";

SWEP.PrintName 			= "Bat";

SWEP.ViewModel 			= "models/weapons/vein/v_bat.mdl";
SWEP.WorldModel 		= "models/weapons/vein/w_bat.mdl";

SWEP.Holdtype			= "melee2";
SWEP.TwoHanded			= true;
SWEP.HitSounds			= {
	"weapons/vein/bat/01.wav",
	"weapons/vein/bat/02.wav",
	"weapons/vein/bat/03.wav",
	"weapons/vein/bat/04.wav"
};