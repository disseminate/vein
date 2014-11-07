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
	
	self:SetOverlayTexture( "overlays/rug001a" );
	self:SetScale( 1 );
	
end
