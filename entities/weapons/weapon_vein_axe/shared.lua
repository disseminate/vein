if( SERVER ) then
	
	AddCSLuaFile( "shared.lua" );
	
end

SWEP.Base				= "weapon_vein_melee_base";

SWEP.PrintName 			= "Axe";

SWEP.ViewModel 			= "models/weapons/vein/v_axe.mdl";
SWEP.WorldModel 		= "models/weapons/vein/w_axe.mdl";

SWEP.Holdtype			= "melee2";
SWEP.TwoHanded			= true;
SWEP.HitSounds			= {
	"weapons/vein/axe/01.wav",
	"weapons/vein/axe/02.wav",
	"weapons/vein/axe/03.wav",
	"weapons/vein/axe/04.wav"
};
SWEP.DamageType			= DMG_SLASH;
