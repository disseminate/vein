if( SERVER ) then
	
	AddCSLuaFile( "shared.lua" );
	
end

SWEP.Base				= "weapon_vein_zoom_base";

SWEP.PrintName 			= "Binoculars";

SWEP.ViewModel 			= "models/weapons/vein/v_pistol.mdl";
SWEP.WorldModel 		= "models/weapons/vein/w_pistol.mdl";

SWEP.TwoHanded			= true;

SWEP.ScopeCrosshairs	= false;

function SWEP:Initialize()
	
	self:SetWeaponHoldType( "revolver" );
	
end

function SWEP:Precache()
	
	util.PrecacheModel( "models/weapons/vein/v_pistol.mdl" );
	util.PrecacheModel( "models/weapons/vein/w_pistol.mdl" );
	
end
