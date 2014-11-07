AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( "shared.lua" );

function ENT:UpdateTransmitState()
	
	return TRANSMIT_ALWAYS;
	
end

function ENT:SetupDataTables()
	
	self:DTVar( "Int", 0, "MapBased" );
	
	self:SetDTInt( 0, 0 );
	
end

function ENT:Initialize()
	
	self:PhysicsRefresh();
	
	self:SetUseType( SIMPLE_USE );
	
	self.Container = 0;
	
end

function ENT:Use( ply )
	
	if( !self.NextUse ) then self.NextUse = 0 end
	if( CurTime() < self.NextUse ) then return end
	
	self.NextUse = CurTime() + 0.5;
	
	if( self.Bed ) then
		
		if( !ply.Asleep ) then
			
			net.Start( "nConfirmSleep" );
			net.Send( ply );
			
		end
		
	elseif( self.Chair and !self.Occupant ) then
		
		if( !ply.Sitting ) then
			
			ply.Sitting = true;
			ply.Chair = self;
			self.Occupant = ply;
			
			ply:StripWeapons();
			
			ply.DeltaSitPos = ply:GetPos() - self:GetPos();
			
			net.Start( "nEnterChair" );
				net.WriteEntity( ply );
				net.WriteEntity( self );
			net.Broadcast();
			
		end
		
	elseif( self.Chair and self.Occupant == ply ) then
		
		ply.Sitting = false;
		ply.Chair = nil;
		self.Occupant = nil;
		
		ply:SetPos( self:GetPos() + ply.DeltaSitPos );
		
		net.Start( "nExitChair" );
			net.WriteEntity( ply );
			net.WriteEntity( self );
		net.Broadcast();
		
	elseif( self:GetContainer() > 0 and ( !self.NextOpen or CurTime() >= self.NextOpen ) ) then
		
		local d = ply:GetPos():Distance( self:GetPos() );
		
		if( d <= 256 ) then
			
			self.NextOpen = CurTime() + 1;
			
			V.I.SendContainerInventory( ply, self, true );
			
		end
		
	end
	
end

function ENT:PhysicsRefresh()
	
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );
	
	local p = self:GetPhysicsObject();
	
	if( p and p:IsValid() ) then
		
		p:EnableMotion( false );
		
	end
	
end

function ENT:SetContainer( type )
	
	self.Container = type;
	self.NextContainerUpdate = CurTime();
	
end

function ENT:GetContainer()
	
	return self.Container;
	
end

function ENT:IsMapBased()
	
	return self:GetDTInt( 0 ) == 1;
	
end

function ENT:KeyValue( key, val )
	
	if( key == "model" ) then
		
		self:SetModel( val );
		self:SetDTInt( 0, 1 );
		
	end
	
	if( key == "bed" ) then
		
		self.Bed = ( val == "1" );
		
	end
	
	if( key == "chair" ) then
		
		self.Chair = ( val == "1" );
		
	end
	
	if( key == "container" ) then
		
		self:SetContainer( tonumber( val ) );
		
	end
	
end

function ENT:AcceptInput( name, activator, caller, data )
	
	if( string.lower( name ) == "break" ) then
		
		self:GibBreakClient( Vector() );
		
	end
	
end

function ENT:OnTakeDamage( dmg )
	
	
	
end