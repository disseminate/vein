if( SERVER ) then
	
	AddCSLuaFile( "shared.lua" );
	
end

SWEP.Base				= "weapon_vein_melee_base";

SWEP.PrintName 			= "Hammer";

SWEP.ViewModel 			= "models/weapons/vein/v_hammer.mdl";
SWEP.WorldModel 		= "models/weapons/vein/w_hammer.mdl";

SWEP.HitSounds			= {
	"weapons/vein/hammer/01.wav",
	"weapons/vein/hammer/02.wav",
	"weapons/vein/hammer/03.wav",
	"weapons/vein/hammer/04.wav"
};
SWEP.Length				= 60;
