AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( "shared.lua" );

function ENT:SetupDataTables()
	
	self:DTVar( "Vector", 0, "Color" );
	self:DTVar( "Float", 0, "Brightness" );
	self:DTVar( "Float", 1, "Size" );
	self:DTVar( "Float", 2, "Decay" );
	
end

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
	
	self:DrawShadow( false );
	
	self:SetLightColor( Color( 255, 255, 255, 255 ) );
	self:SetBrightness( 1 );
	self:SetSize( 256 );
	self:SetDecay( 5 );
	
end

function ENT:SetLightColor( c )
	
	self:SetDTVector( 0, Vector( c.r, c.g, c.b ) );
	
end

function ENT:GetLightColor()
	
	return self:GetDTVector( 0 );
	
end

function ENT:SetBrightness( i )
	
	self:SetDTFloat( 0, i );
	
end

function ENT:GetBrightness()
	
	return self:GetDTFloat( 0 );
	
end

function ENT:SetSize( i )
	
	self:SetDTFloat( 1, i );
	
end

function ENT:GetSize()
	
	return self:GetDTFloat( 1 );
	
end

function ENT:SetDecay( i )
	
	self:SetDTFloat( 2, i );
	
end

function ENT:GetDecay()
	
	return self:GetDTFloat( 2 );
	
end

function ENT:KeyValue( key, val )
	
	if( key == "color" ) then
		
		local e = string.Explode( " ", val );
		local r = tonumber( e[1] );
		local g = tonumber( e[2] );
		local b = tonumber( e[3] );
		self:SetLightColor( Color( r, g, b, 255 ) );
		
	end
	
	if( key == "brightness" ) then
		
		self:SetBrightness( tonumber( val ) );
		
	end
	
	if( key == "size" ) then
		
		self:SetSize( tonumber( val ) );
		
	end
	
	if( key == "decay" ) then
		
		self:SetDecay( tonumber( val ) );
		
	end
	
end
