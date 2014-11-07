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
	
	self.SparkEnt = ents.Create( "env_spark" );
	self.SparkEnt:SetPos( self:GetPos() );
	self.SparkEnt:SetKeyValue( "spawnflags", "64" );
	self.SparkEnt:Spawn();
	self.SparkEnt:Activate();
	self.SparkEnt:Fire( "StartSpark" );
	
	self:DeleteOnRemove( self.SparkEnt );
	
	self:DrawShadow( false );
	
	self:SetMagnitude( "2" );
	self:SetMaxDelay( 0 );
	self:SetTrailLength( "1" );
	
end

function ENT:SetMagnitude( n )
	
	self.SparkSize = n;
	
	if( self.SparkEnt and self.SparkEnt:IsValid() ) then
		
		self.SparkEnt:SetKeyValue( "Magnitude", n );
		
	end
	
end

function ENT:GetMagnitude()
	
	return self.SparkSize;
	
end

function ENT:SetMaxDelay( n )
	
	self.MaxDelay = n;
	
	if( self.SparkEnt and self.SparkEnt:IsValid() ) then
		
		self.SparkEnt:SetKeyValue( "MaxDelay", n );
		self.SparkEnt:Fire( "StopSpark" );
		self.SparkEnt:Fire( "StartSpark" );
		
	end
	
end

function ENT:GetMaxDelay()
	
	return self.MaxDelay;
	
end

function ENT:SetTrailLength( n )
	
	self.TrailLength = n;
	
	if( self.SparkEnt and self.SparkEnt:IsValid() ) then
		
		self.SparkEnt:SetKeyValue( "TrailLength", n );
		
	end
	
end

function ENT:GetTrailLength()
	
	return self.TrailLength;
	
end

function ENT:KeyValue( key, val )
	
	if( key == "Magnitude" ) then
		
		self:SetMagnitude( val );
		
	end
	
	if( key == "MaxDelay" ) then
		
		self:SetMaxDelay( tonumber( val ) );
		
	end
	
	if( key == "TrailLength" ) then
		
		self:SetTrailLength( val );
		
	end
	
end

function ENT:Think()
	
	local spark = self.SparkEnt;
	
	if( spark and spark:IsValid() ) then
		
		if( spark:GetPos() != self:GetPos() ) then
			
			spark:SetPos( self:GetPos() );
			
		end
		
	end
	
end