if( SERVER ) then
	
	AddCSLuaFile( "shared.lua" );
	
end

SWEP.Base				= "weapon_vein_base";

SWEP.PrintName 			= "Pistol";

SWEP.ViewModel 			= "models/weapons/vein/v_pistol.mdl";
SWEP.WorldModel 		= "models/weapons/vein/w_pistol.mdl";

SWEP.TwoHanded			= true;

function SWEP:Initialize()
	
	self:SetWeaponHoldType( "revolver" );
	
end

function SWEP:Precache()
	
	util.PrecacheModel( "models/weapons/vein/v_pistol.mdl" );
	util.PrecacheModel( "models/weapons/vein/w_pistol.mdl" );
	util.PrecacheSound( "weapons/vein/pistol/m9-1.wav" );
	util.PrecacheSound( "weapons/pistol/pistol_empty.wav" );
	
end

function SWEP:PrimaryAttack()
	
	if( !IsFirstTimePredicted() ) then return end
	if( self.Owner.LastShot and CurTime() - self.Owner.LastShot < self.Owner.LastShotDelay ) then return end
	if( self.Owner:IsWorldClicking() ) then return false end
	
	if( !V.I.HasItem( self.Owner, "pistolammo" ) ) then
		
		self:PlaySound( "weapons/pistol/pistol_empty.wav", 100, 100 );
		
		return;
		
	end
	
	self:SpawnHorde( 1, 3 );
	self:PlaySound( "weapons/vein/pistol/m9-1.wav", 100, 100, 4096 );
	
	V.I.RemoveItem( self.Owner, "pistolammo" );
	
	self:ShootEffects();
	
	self.Owner:ViewPunch( Angle( -10, 0, 0 ) );
	
	local bullet 		= { };
	bullet.Num			= 1;
	bullet.Src 			= self.Owner:GetShootPos();
	bullet.Dir 			= self.Owner:GetAimVector();
	bullet.Spread 		= Vector( .04 * V.GetAimMod( self.Owner ), .04 * V.GetAimMod( self.Owner ), 0 );
	bullet.AmmoType 	= "pistol";
	bullet.TracerName	= "Tracer";
	bullet.Tracer		= 1;
	bullet.Force		= 10;
	bullet.Damage		= 5;
	
	self:FireBullets( bullet );
	
	self:Freeze( 0.5 );
	
end