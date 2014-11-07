include( "shared.lua" );

function ENT:Draw()
	
	if( V.ME.ContextOpen ) then
		
		self:DrawModel();
		
	end
	
end

function ENT:Think()
	
	local d = DynamicLight( self:EntIndex() );
	
	if( d ) then
		
		local v = self:GetDTVector( 0 );
		d.Pos = self:GetPos();
		d.r = v.x;
		d.g = v.y;
		d.b = v.z;
		d.Brightness = self:GetDTFloat( 0 );
		d.Size = self:GetDTFloat( 1 );
		d.Decay = self:GetDTFloat( 2 );
		d.DieTime = CurTime() + 1;
		
	end
	
end