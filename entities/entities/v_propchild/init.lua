AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( "shared.lua" );

function ENT:Initialize()
	
	self:PhysicsRefresh();
	
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

function ENT:Use( ply )
	
	
	
end

function ENT:OnTakeDamage( dmg )
	
	
	
end