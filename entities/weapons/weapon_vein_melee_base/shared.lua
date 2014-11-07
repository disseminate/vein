if( SERVER ) then
	
	AddCSLuaFile( "shared.lua" );
	
end

SWEP.Base				= "weapon_vein_base";
SWEP.ViewModelFlip 		= false;

SWEP.PrintName 			= "Melee Base";

SWEP.ViewModel 			= "";
SWEP.WorldModel 		= "";

SWEP.Holdtype			= "melee";
SWEP.TwoHanded			= false;
SWEP.HolsterDelay		= 1;
SWEP.Length				= 80;
SWEP.Damage				= 10;
SWEP.DamageType			= DMG_CLUB;
SWEP.FreezeTime			= 0.7;

function SWEP:Initialize()
	
	self:SetWeaponHoldType( self.Holdtype );
	
end

function SWEP:Precache()
	
	util.PrecacheModel( self.ViewModel );
	util.PrecacheModel( self.WorldModel );
	util.PrecacheSound( "weapons/iceaxe/iceaxe_swing1.wav" );
	
	if( self.HitSounds ) then
		
		for _, v in pairs( self.HitSounds ) do
			
			util.PrecacheSound( v );
			
		end
		
	end
	
end

function SWEP:ChildDeploy()
	
	self.DeployStart = CurTime();
	
end

function SWEP:PrimaryAttack()
	
	if( !IsFirstTimePredicted() ) then return end
	if( self.Owner.LastShot and CurTime() - self.Owner.LastShot < self.Owner.LastShotDelay ) then return end
	if( self.Owner:IsWorldClicking() ) then return false end
	
	self:PlaySound( "weapons/iceaxe/iceaxe_swing1.wav", 100, 100 );
	
	self.Owner:ViewPunch( Angle( 5, 8, -2 ) );
	self.Owner:SetAnimation( PLAYER_ATTACK1 );
	
	local trace = { };
	trace.start = self.Owner:GetShootPos();
	trace.endpos = trace.start + self.Owner:GetAimVector() * self.Length;
	trace.filter = self.Owner;
	local tr = util.TraceLine( trace );
	
	if( tr.Hit ) then
		
		self:SendWeaponAnim( ACT_VM_HITCENTER );
		
		if( self.HitSounds ) then
			
			self:PlaySound( table.Random( self.HitSounds ), 100, 100 );
			
		end
		
		if( tr.Entity ) then
			
			local dmg = DamageInfo();
			dmg:SetDamage( self.Damage );
			dmg:SetDamageForce( Vector( 0, 0, 1 ) );
			dmg:SetDamagePosition( tr.HitPos );
			dmg:SetDamageType( self.DamageType );
			dmg:SetAttacker( self.Owner );
			dmg:SetInflictor( self );
			
			tr.Entity:DispatchTraceAttack( dmg, tr.StartPos, tr.HitPos );
			
		end
		
	else
		
		self:SendWeaponAnim( ACT_VM_MISSCENTER );
		
	end
	
	self:Freeze( self.FreezeTime );
	
end