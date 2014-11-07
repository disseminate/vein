AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( "shared.lua" );

function ENT:SetupDataTables()
	
	self:DTVar( "Vector", 0, "Color" );
	self:DTVar( "Float", 0, "Width" );
	self:DTVar( "Float", 1, "Length" );
	
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
	
	V.CurSpotlightWatch = self;
	
	self.SpotEnt = ents.Create( "point_spotlight" );
	self.SpotEnt:SetPos( self:GetPos() );
	self.SpotEnt:SetAngles( self:GetAngles() );
	self.SpotEnt:SetKeyValue( "spawnflags", "1" );
	self.SpotEnt:Spawn();
	self.SpotEnt:Fire( "LightOn" );
	
	self:DeleteOnRemove( self.SpotEnt );
	
	timer.Simple( 0.5, function() -- THIS IS SHIT THIS IS SHIT THIS IS SHIT
		
		if( self and self:IsValid() and self.SpotEnt and self.SpotEnt:IsValid() ) then
			
			for _, v in pairs( ents.FindByClass( "spotlight_end" ) ) do
				
				if( v:GetOwner() == self.SpotEnt ) then
					
					self.SpotEnt.SpotlightEnd = v;
					self.SpotEnt:DeleteOnRemove( v );
					
				end
				
			end
			
			for _, v in pairs( ents.FindByClass( "beam" ) ) do
				
				local att = v:GetSaveTable().m_hAttachEntity;
				
				if( att == self.SpotEnt ) then
					
					self.SpotEnt.Beam = v;
					self.SpotEnt:DeleteOnRemove( v );
					
				end
				
			end
			
		end
		
	end );
	
	self.SpotEnt:SetParent( self );
	
	self:DrawShadow( false );
	
	self:SetSpotColor( Color( 255, 255, 255, 255 ) );
	self:SetWidth( 50 );
	self:SetLength( 500 );
	
end

function ENT:SetSpotColor( c )
	
	self:SetDTVector( 0, Vector( c.r, c.g, c.b ) );
	
	if( self.SpotEnt and self.SpotEnt:IsValid() ) then
		
		self.SpotEnt:SetKeyValue( "rendercolor", tostring( c.r ) .. " " .. tostring( c.g ) .. " " .. tostring( c.b ) .. " 255" );
		
		if( self.SpotEnt.Beam ) then
			
			self.SpotEnt.Beam:SetColor( Color( c.r, c.g, c.b, 64 ) );
			
		end
		
	end
	
	self:SetLength( self:GetLength() ); -- update the spotlight
	
end

function ENT:GetLightColor()
	
	return self:GetDTVector( 0 );
	
end

function ENT:SetWidth( i )
	
	self:SetDTFloat( 0, i );
	
	if( self.SpotEnt and self.SpotEnt:IsValid() ) then
		
		self.SpotEnt:SetKeyValue( "spotlightwidth", tostring( i ) );
		self.SpotEnt:SetSaveValue( "SpotlightWidth", i );
		
		if( self.SpotEnt.Beam ) then
			
			self.SpotEnt.Beam:SetSaveValue( "m_fWidth", i );
			
		end
		
	end
	
	self:SetLength( self:GetLength() ); -- update the spotlight
	
end

function ENT:GetWidth()
	
	return self:GetDTFloat( 0 );
	
end

function ENT:SetLength( i )
	
	self:SetDTFloat( 1, i );
	
	if( self.SpotEnt and self.SpotEnt:IsValid() ) then
		
		self.SpotEnt:SetKeyValue( "spotlightlength", tostring( i ) );
		
		if( self.SpotEnt.SpotlightEnd and self.SpotEnt.Beam ) then
			
			local ang = self.SpotEnt.Beam:GetAngles();
			self.SpotEnt.SpotlightEnd:SetPos( self.SpotEnt:GetPos() + ang:Forward() * i );
			
		end
		
	end
	
end

function ENT:GetLength()
	
	return self:GetDTFloat( 1 );
	
end

function ENT:KeyValue( key, val )
	
	if( key == "rendercolor" ) then
		
		local e = string.Explode( " ", val );
		local r = tonumber( e[1] );
		local g = tonumber( e[2] );
		local b = tonumber( e[3] );
		self:SetSpotColor( Color( r, g, b, 255 ) );
		
	end
	
	if( key == "spotlightwidth" ) then
		
		self:SetWidth( tonumber( val ) );
		
	end
	
	if( key == "spotlightlength" ) then
		
		self:SetLength( tonumber( val ) );
		
	end
	
end
