if( SERVER ) then
	
	AddCSLuaFile( "shared.lua" );
	
end

SWEP.Base				= "weapon_vein_melee_base";

SWEP.PrintName 			= "Spanner";

SWEP.ViewModel 			= "models/weapons/vein/v_spanner.mdl";
SWEP.WorldModel 		= "models/weapons/vein/w_spanner.mdl";

SWEP.HitSounds			= {
	"weapons/vein/spanner/01.wav",
	"weapons/vein/spanner/02.wav",
	"weapons/vein/spanner/03.wav",
	"weapons/vein/spanner/04.wav"
};
SWEP.Length				= 60;
