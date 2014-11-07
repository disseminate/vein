include( "shared.lua" );

function ENT:Draw()
	
	if( V.ME.ContextOpen ) then
		
		self:DrawModel();
		
	end
	
	local dlight = DynamicLight( self:EntIndex() );
	if( dlight ) then
		dlight.Pos = self:GetPos() + Vector( 0, 0, 32 );
		dlight.r = 255;
		dlight.g = 150;
		dlight.b = 0;
		dlight.Brightness = 2;
		dlight.Size = 200;
		dlight.Decay = 200 * 5;
		dlight.DieTime = CurTime() + 1;
	end
	
end