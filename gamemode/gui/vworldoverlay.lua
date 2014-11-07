local PANEL = { };

function PANEL:Init()
	
	self:SetWorldClicker( true );
	
end

function PANEL:Paint( w, h )
	
	
	
end

function PANEL:OnCursorEntered()
	
	V.CursorOnWorldOverlay = true;
	
end

function PANEL:OnCursorExited()
	
	V.CursorOnWorldOverlay = false;
	
end

vgui.Register( "VWorldOverlay", PANEL, "EditablePanel" );