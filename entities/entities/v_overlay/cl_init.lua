include( "shared.lua" );

function ENT:Draw()
	
	if( V.ME.SpawnMenuOpen ) then
		
		self:DrawModel();
		
	end
	
	self:SetRenderBoundsWS( self:GetPos() - Vector( 1448, 1448, 1448 ), self:GetPos() + Vector( 1448, 1448, 1448 ) );
	
	local m = V.ME.OverlayExists( self:GetOverlayTexture() );
	
	if( m ) then
		
		cam.Start3D2D( self:GetPos(), self:GetAngles(), self:GetScale() );
			
			surface.SetDrawColor( Color( 255, 255, 255, 255 ) );
			surface.SetMaterial( m );
			surface.DrawTexturedRect( 0, 0, 512, 512 );
			
		cam.End3D2D();
		
	end
	
end
