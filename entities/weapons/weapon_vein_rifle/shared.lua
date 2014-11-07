if( SERVER ) then
	
	AddCSLuaFile( "shared.lua" );
	
end

SWEP.Base				= "weapon_vein_base";

SWEP.PrintName 			= "Military Rifle";

SWEP.ViewModel 			= "models/weapons/vein/v_rifle.mdl";
SWEP.WorldModel 		= "models/weapons/vein/w_rifle.mdl";

SWEP.TwoHanded			= true;
SWEP.ViewModelFlip		= true;

SWEP.Primary.Automatic	= true;

SWEP.HolsterDelay		= 1;

function SWEP:Initialize()
	
	self:SetWeaponHoldType( "smg" );
	
end

function SWEP:Precache()
	
	util.PrecacheModel( "models/weapons/vein/v_rifle.mdl" );
	util.PrecacheModel( "models/weapons/vein/w_rifle.mdl" );
	util.PrecacheSound( "weapons/vein/rifle/famas-1.wav" );
	util.PrecacheSound( "weapons/shotgun/shotgun_empty.wav" );
	
end

function SWEP:PrimaryAttack()
	
	if( !IsFirstTimePredicted() ) then return end
	if( self.Owner.LastShot and CurTime() - self.Owner.LastShot < self.Owner.LastShotDelay ) then return end
	if( self.Owner:IsWorldClicking() ) then return false end
	
	if( !V.I.HasItem( self.Owner, "rifleammo" ) ) then
		
		self:PlaySound( "weapons/shotgun/shotgun_empty.wav", 100, 100 );
		self:SetNextPrimaryFire( CurTime() + 0.1 );
		return;
		
	end
	
	self:SpawnHorde( 0, 1 );
	self:PlaySound( "weapons/vein/rifle/famas-1.wav", 100, 100, 4096 );
	
	V.I.RemoveItem( self.Owner, "rifleammo" );
	
	self:ShootEffects();
	
	self.Owner:ViewPunch( Angle( -1, 0, 0 ) );
	
	local bullet 		= { };
	bullet.Num			= 1;
	bullet.Src 			= self.Owner:GetShootPos();
	bullet.Dir 			= self.Owner:GetAimVector();
	bullet.Spread 		= Vector( .04 * V.GetAimMod( self.Owner ), .04 * V.GetAimMod( self.Owner ), 0 );
	bullet.AmmoType 	= "pistol";
	bullet.TracerName	= "Tracer";
	bullet.Tracer		= 1;
	bullet.Force		= 5;
	bullet.Damage		= 5;
	
	self:FireBullets( bullet );
	
	self:Freeze( 0.1 );
	
end