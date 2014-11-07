local PANEL = { };

function PANEL:Init()

    self:SetPaintBackground( false );
    self:SetPaintBackgroundEnabled( false );
    self:SetPaintBorderEnabled( false );
	
end

function PANEL:Paint()
	
	draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 150, 150, 150, 255 ) );
	
end

vgui.Register( "VHorizontalRule", PANEL, "DPanel" );