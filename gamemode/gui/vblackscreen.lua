local PANEL = { };

function PANEL:Init()
	
	self.PaintHooks = { };
	
end

function PANEL:Paint( w, h )
	
	for i = 1, h do
		
		local a = ( i / h ) * 20;
		
		surface.SetDrawColor( a, a, a, 255 );
		surface.DrawLine( 0, i, w, i );
		
	end
	
	for _, v in pairs( self.PaintHooks ) do
		
		v( self, w, h );
		
	end
	
end

vgui.Register( "VBlackScreen", PANEL, "EditablePanel" );