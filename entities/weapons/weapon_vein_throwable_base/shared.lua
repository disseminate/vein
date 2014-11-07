if( SERVER ) then
	
	AddCSLuaFile( "shared.lua" );
	
end

SWEP.Base				= "weapon_vein_base";
SWEP.ViewModelFlip 		= false;

SWEP.PrintName 			= "Throwable Base";

SWEP.ViewModel 			= "";
SWEP.WorldModel 		= "";

SWEP.Holdtype			= "grenade";
SWEP.TwoHanded			= false;
SWEP.HolsterDelay		= 1;
SWEP.FreezeTime			= 1;

SWEP.ThrowItem			= "";
SWEP.ThrowEnt			= "";

function SWEP:Initialize()
	
	self:SetWeaponHoldType( self.Holdtype );
	
end

function SWEP:Precache()
	
	util.PrecacheModel( self.ViewModel );
	util.PrecacheModel( self.WorldModel );
	
end

function SWEP:ChildDeploy()
	
	self.DeployStart = CurTime();
	
end

function SWEP:PrimaryAttack()
	
	if( !IsFirstTimePredicted() ) then return end
	if( self.Throwing ) then return end
	if( self.Owner:IsWorldClicking() ) then return false end
	
	self.Owner:ViewPunch( Angle( 5, 8, -2 ) );
	self.Owner:SetAnimation( PLAYER_ATTACK1 );
	
	self:SendWeaponAnim( ACT_VM_MISSCENTER );
	
	self.Throwing = true;
	self.ThrowTime = CurTime() + 0.18;
	
	self:Freeze( self.FreezeTime );
	
end

function SWEP:ChildThink()
	
	if( !IsFirstTimePredicted() ) then return end
	
	if( self.Throwing and !self.Thrown and CurTime() > self.ThrowTime ) then
		
		self.Thrown = true;
		
		if( V.I.HasItem( self.Owner, self.ThrowItem ) ) then
			
			if( SERVER ) then
				
				local t = ents.Create( self.ThrowEnt );
				t:SetPos( self.Owner:GetShootPos() + self.Owner:GetAimVector() * 40 );
				t:SetAngles( Angle() );
				t:SetModel( self.WorldModel );
				t:Spawn();
				t:GetPhysicsObject():SetVelocity( self.Owner:GetAimVector() * 600 );
				t:GetPhysicsObject():AddAngleVelocity( Vector( math.random( -600, 600 ), math.random( -600, 600 ), math.random( -600, 600 ) ) );
				
			end
			
			V.I.RemoveItem( self.Owner, self.ThrowItem, 1 );
			
		end
		
		if( SERVER ) then
			
			self:Remove();
			
		end
		
	end
	
end