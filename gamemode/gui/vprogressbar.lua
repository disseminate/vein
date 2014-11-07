local PANEL = { };

function PANEL:Init()

    self:SetPaintBackground( false );
    self:SetPaintBackgroundEnabled( false );
    self:SetPaintBorderEnabled( false );
	
	self.Min = 0;
	self.Max = 100;
	self.Val = 0;
	
	self.Text = "";
	self.TextColor = Color( 255, 255, 255, 255 );
	
end

function PANEL:SetBounds( min, max )
	
	self.Min = min;
	self.Max = max;
	
end

function PANEL:SetText( t )
	
	self.Text = t;
	
end

function PANEL:SetTextColor( c )
	
	self.TextColor = c;
	
end

function PANEL:SetValue( val )
	
	self.Val = val;
	
end

function PANEL:SetValuePerc( val )
	
	self.Val = self.Min + ( val * ( self.Max - self.Min ) );
	
end

function PANEL:Paint( w, h )
	
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 220 ) );
	
	local perc = math.Clamp( ( self.Val - self.Min ) / ( self.Max - self.Min ), 0, 1 );
	
	if( perc > 0 ) then
		
		draw.RoundedBox( 0, 0, 0, w * perc, h, Color( 58, 25, 25, 220 ) );
		draw.RoundedBox( 0, 0, 0, w * perc, h / 2, Color( 255, 255, 255, 3 ) );
		
	end
	
	if( self.Text ) then
		
		draw.SimpleTextOutlined( self.Text, "VCandara20", w / 2, h / 2, self.TextColor, 1, 1, 0, Color( 255, 255, 255, 255 ) );
		
	end
	
end

vgui.Register( "VProgressBar", PANEL, "DPanel" );