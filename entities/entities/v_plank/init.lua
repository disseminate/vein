AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( "shared.lua" );

function ENT:UpdateTransmitState()
	
	return TRANSMIT_ALWAYS;
	
end

function ENT:Initialize()
	
	self:SetModel( "models/props_debris/wood_board06a.mdl" );
	self:PhysicsRefresh();
	
end

function ENT:Use( ply )
	
	
	
end

function ENT:SetDoor( ent )
	
	table.insert( ent.Barricades, self );
	
	ent:DeleteOnRemove( self );
	
	self:SetOwner( ent );
	
	self.DoorOriginalHealth = ent.DoorHealth;
	
	ent.DoorMaxHealth = ent.DoorMaxHealth + 4;
	ent.DoorHealth = ent.DoorHealth + 4;
	
	net.Start( "nMEDoorMaxClient" );
		net.WriteEntity( ent );
		net.WriteFloat( ent.DoorMaxHealth );
	net.Broadcast();
	
	net.Start( "nMEDamageDoorClient" );
		net.WriteEntity( ent );
		net.WriteFloat( ent.DoorHealth );
	net.Broadcast();
	
end

function ENT:OnTakeDamage()
	
	local n = 0;
	
	for _, v in pairs( self:GetOwner().Barricades ) do
		
		if( v and v:IsValid() ) then
			
			n = n + 1;
			
		end
		
	end
	
	V.ME.DamageDoor( self:GetOwner(), math.ceil( ( self:GetOwner().DoorHealth - 8 ) - ( ( n - 1 ) * 4 ), 0 ) );
	
	self:Break();
	
end

function ENT:Think()
	
	if( !self:GetOwner() or !self:GetOwner():IsValid() or self:GetOwner().DoorHealth <= self.DoorOriginalHealth ) then
		
		self:Break();
		
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

function ENT:Break()
	
	self:EmitSound( "physics/wood/wood_plank_break" .. math.random( 1, 4 ) .. ".wav" );
	self:Remove();
	
end

function ENT:OnRemove()
	
	if( self:GetOwner() and self:GetOwner():IsValid() ) then
		
		self:GetOwner().DoorMaxHealth = self:GetOwner().DoorMaxHealth - 4;
		net.Start( "nMEDoorMaxClient" );
			net.WriteEntity( self:GetOwner() );
			net.WriteFloat( self:GetOwner().DoorMaxHealth );
		net.Broadcast();
		
		if( self:GetOwner().Barricades ) then
			
			local n = 0;
			local i = 0;
			
			for _, v in pairs( self:GetOwner().Barricades ) do
				
				if( v and v:IsValid() ) then
					
					if( v != self ) then
						
						v.DoorOriginalHealth = 8 + i;
						i = i + 4;
						
					end
					
					n = n + 1;
					
				end
				
			end
			
			if( n == 1 ) then
				
				self:GetOwner():Fire( "SetRotationDistance", self:GetOwner().OldDoorDistance );
				
				self:GetOwner().Barricades = nil;
				
			end
			
		end
		
	end
	
end