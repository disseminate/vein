if( SERVER ) then
	
	AddCSLuaFile( "shared.lua" );
	
end

SWEP.Base				= "weapon_vein_base";

SWEP.PrintName 			= "Revolver";

SWEP.ViewModel 			= "models/weapons/vein/v_revolver.mdl";
SWEP.WorldModel 		= "models/weapons/vein/w_revolver.mdl";

SWEP.TwoHanded			= true;

function SWEP:Initialize()
	
	self:SetWeaponHoldType( "revolver" );
	
end

function SWEP:Precache()
	
	util.PrecacheModel( "models/weapons/vein/v_revolver.mdl" );
	util.PrecacheModel( "models/weapons/vein/w_revolver.mdl" );
	util.PrecacheSound( "weapons/vein/revolver/fire.wav" );
	util.PrecacheSound( "weapons/pistol/pistol_empty.wav" );
	
end

function SWEP:PrimaryAttack()
	
	if( !IsFirstTimePredicted() ) then return end
	if( self.Owner.LastShot and CurTime() - self.Owner.LastShot < self.Owner.LastShotDelay ) then return end
	if( self.Owner:IsWorldClicking() ) then return false end
	
	if( !V.I.HasItem( self.Owner, "revolverammo" ) ) then
		
		self:PlaySound( "weapons/pistol/pistol_empty.wav", 100, 100 );
		
		return;
		
	end
	
	self:SpawnHorde( 1, 3 );
	self:PlaySound( "weapons/vein/revolver/fire.wav", 100, 100, 4096 );
	
	V.I.RemoveItem( self.Owner, "revolverammo" );
	
	self:ShootEffects();
	
	self.Owner:ViewPunch( Angle( -10, 0, 0 ) );
	
	local bullet 		= { };
	bullet.Num			= 1;
	bullet.Src 			= self.Owner:GetShootPos();
	bullet.Dir 			= self.Owner:GetAimVector();
	bullet.Spread 		= Vector( .02 * V.GetAimMod( self.Owner ), .02 * V.GetAimMod( self.Owner ), 0 );
	bullet.AmmoType 	= "pistol";
	bullet.TracerName	= "Tracer";
	bullet.Tracer		= 1;
	bullet.Force		= 10;
	bullet.Damage		= 10;
	
	self:FireBullets( bullet );
	
	self:Freeze( 1 );
	
end