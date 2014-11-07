if( SERVER ) then
	
	AddCSLuaFile( "shared.lua" );
	
end

SWEP.Base				= "weapon_vein_melee_base";

SWEP.PrintName 			= "Pot";

SWEP.ViewModel 			= "models/weapons/vein/v_pot.mdl";
SWEP.WorldModel 		= "models/weapons/vein/w_pot.mdl";

SWEP.HitSounds			= {
	"weapons/vein/pot/01.wav",
	"weapons/vein/pot/02.wav",
	"weapons/vein/pot/03.wav",
	"weapons/vein/pot/04.wav"
};
SWEP.Length				= 70;
