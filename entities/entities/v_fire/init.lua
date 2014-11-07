AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( "shared.lua" );

function ENT:Initialize()
	
	self:SetModel( "models/Combine_Helicopter/helicopter_bomb01.mdl" );
	
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );
	
	local p = self:GetPhysicsObject();
	
	if( p and p:IsValid() ) then
		
		p:EnableMotion( false );
		
	end
	
	self:SetMaterial( "debug/white" );
	
	self.FireEnt = ents.Create( "env_fire" );
	self.FireEnt:SetPos( self:GetPos() );
	self.FireEnt:SetKeyValue( "spawnflags", "1" );
	self.FireEnt:Spawn();
	self.FireEnt:Activate();
	self.FireEnt:Fire( "Enable" );
	self.FireEnt:Fire( "StartFire" );
	
	self:DeleteOnRemove( self.FireEnt );
	
	self:DrawShadow( false );
	
	self:SetSize( 64 );
	
end

function ENT:SetSize( n )
	
	self.FireSize = n;
	
	if( self.FireEnt and self.FireEnt:IsValid() ) then
		
		self.FireEnt:SetKeyValue( "firesize", n );
		self.FireEnt:Fire( "Extinguish" );
		self.FireEnt:Fire( "StartFire", "", 0.1 );
		
	end
	
end

function ENT:GetSize()
	
	return self.FireSize;
	
end

function ENT:KeyValue( key, val )
	
	if( key == "size" ) then
		
		self:SetSize( tonumber( val ) );
		
	end
	
end

function ENT:Think()
	
	local fire = self.FireEnt;
	
	if( fire and fire:IsValid() ) then
		
		if( fire:GetPos() != self:GetPos() ) then
			
			fire:SetPos( self:GetPos() ); -- Parenting does weird things to the fire.
			
		end
		
	end
	
end