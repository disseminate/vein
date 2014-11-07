if( SERVER ) then
	
	AddCSLuaFile( "shared.lua" );
	
end

SWEP.Base				= "weapon_vein_base";

SWEP.PrintName 			= "Shotgun";

SWEP.ViewModel 			= "models/weapons/vein/v_shotgun.mdl";
SWEP.WorldModel 		= "models/weapons/vein/w_shotgun.mdl";

SWEP.TwoHanded			= true;

function SWEP:Initialize()
	
	self:SetWeaponHoldType( "shotgun" );
	
end

function SWEP:Precache()
	
	util.PrecacheModel( "models/weapons/vein/v_shotgun.mdl" );
	util.PrecacheModel( "models/weapons/vein/w_shotgun.mdl" );
	util.PrecacheSound( "weapons/vein/shotgun/m3-1.wav" );
	util.PrecacheSound( "weapons/vein/shotgun/m3_pump.wav" );
	util.PrecacheSound( "weapons/shotgun/shotgun_empty.wav" );
	
end

function SWEP:ChildDeploy()
	
	self.DeployStart = CurTime();
	self.Cocked = false;
	
end

function SWEP:ChildThink()
	
	if( self.DeployStart and !self.Cocked ) then
		
		local t = CurTime() - self.DeployStart;
		
		if( t >= 0.35 ) then
			
			self.Cocked = true;
			self:PlaySound( "weapons/vein/shotgun/m3_pump.wav", 100, 100 );
			
		end
		
	end
	
end

function SWEP:PrimaryAttack()
	
	if( !IsFirstTimePredicted() ) then return end
	if( self.Owner.LastShot and CurTime() - self.Owner.LastShot < self.Owner.LastShotDelay ) then return end
	if( self.Owner:IsWorldClicking() ) then return false end
	
	if( !V.I.HasItem( self.Owner, "shotgunammo" ) ) then
		
		self:PlaySound( "weapons/shotgun/shotgun_empty.wav", 100, 100 );
		
		return;
		
	end
	
	self:SpawnHorde( 2, 6 );
	self:PlaySound( "weapons/vein/shotgun/m3-1.wav", 100, 100, 8192 );
	
	V.I.RemoveItem( self.Owner, "shotgunammo" );
	
	self:ShootEffects();
	
	self.Owner:ViewPunch( Angle( -20, 0, 0 ) );
	
	local bullet 		= { };
	bullet.Num			= 8;
	bullet.Src 			= self.Owner:GetShootPos();
	bullet.Dir 			= self.Owner:GetAimVector();
	bullet.Spread 		= Vector( .05 * V.GetAimMod( self.Owner ), .05 * V.GetAimMod( self.Owner ), 0 );
	bullet.AmmoType 	= "pistol";
	bullet.TracerName	= "Tracer";
	bullet.Tracer		= 1;
	bullet.Force		= 10;
	bullet.Damage		= 10;
	
	self:FireBullets( bullet );
	
	self:Freeze( 1.2 );
	
end