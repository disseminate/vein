local PANEL = { };

function PANEL:Init()

    self:SetPaintBackground( false );
    self:SetPaintBackgroundEnabled( false );
    self:SetPaintBorderEnabled( false );
	
end

function PANEL:Paint()
	
	draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 150 ) );
	
	surface.SetDrawColor( 150, 150, 150, 255 );
	surface.DrawLine( 0, 0, self:GetWide() - 1, 0 );
	surface.DrawLine( self:GetWide() - 1, 0, self:GetWide() - 1, self:GetTall() - 1 );
	surface.DrawLine( 0, 0, 0, self:GetTall() - 1 );
	surface.DrawLine( 0, self:GetTall() - 1, self:GetWide() - 1, self:GetTall() - 1 );
	
end

vgui.Register( "VInventoryItemSlot", PANEL, "DPanel" );