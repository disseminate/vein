if( SERVER ) then
	
	AddCSLuaFile( "shared.lua" );
	
end

SWEP.Base				= "weapon_vein_melee_base";

SWEP.PrintName 			= "Sledgehammer";

SWEP.ViewModel 			= "models/weapons/vein/v_sledge.mdl";
SWEP.WorldModel 		= "models/weapons/vein/w_sledge.mdl";

SWEP.Holdtype			= "melee2";
SWEP.TwoHanded			= true;
SWEP.HitSounds			= {
	"weapons/vein/sledge/01.wav",
	"weapons/vein/sledge/02.wav",
	"weapons/vein/sledge/03.wav",
	"weapons/vein/sledge/04.wav"
};