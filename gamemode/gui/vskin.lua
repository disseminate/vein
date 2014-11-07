local SKIN = { };

SKIN.PrintName 		= "Vein";
SKIN.Author			= "Disseminate";
SKIN.DermaVersion	= 1;

SKIN.fontFrame				= "VCandara30";
SKIN.fontTab				= "VCandara30";

SKIN.colButtonText			= Color( 200, 200, 200, 255 );
SKIN.colButtonTextDisabled	= Color( 100, 100, 100, 255 );
SKIN.fontButton				= "VCandara30";

SKIN.Colours = {}

SKIN.Colours.Window = {}
SKIN.Colours.Window.TitleActive			= Color( 200, 200, 200, 255 );
SKIN.Colours.Window.TitleInactive		= Color( 200, 200, 200, 255 );

SKIN.Colours.Button = {}
SKIN.Colours.Button.Normal				= Color( 200, 200, 200, 255 );
SKIN.Colours.Button.Hover				= Color( 200, 200, 200, 255 );
SKIN.Colours.Button.Down				= Color( 200, 200, 200, 255 );
SKIN.Colours.Button.Disabled			= Color( 100, 100, 100, 255 );

SKIN.Colours.Label = { }
SKIN.Colours.Label.Default		= Color( 200, 200, 200, 255 );
SKIN.Colours.Label.Bright		= Color( 200, 200, 200, 255 );
SKIN.Colours.Label.Dark			= Color( 100, 100, 100, 255 );
SKIN.Colours.Label.Highlight	= Color( 200, 200, 200, 255 );

SKIN.Colours.Tab = {}
SKIN.Colours.Tab.Active = {}
SKIN.Colours.Tab.Active.Normal			= GWEN.TextureColor( 4 + 8 * 4, 508 );
SKIN.Colours.Tab.Active.Hover			= GWEN.TextureColor( 4 + 8 * 5, 508 );
SKIN.Colours.Tab.Active.Down			= GWEN.TextureColor( 4 + 8 * 4, 500 );
SKIN.Colours.Tab.Active.Disabled		= GWEN.TextureColor( 4 + 8 * 5, 500 );

SKIN.Colours.Tab.Inactive = {}
SKIN.Colours.Tab.Inactive.Normal		= GWEN.TextureColor( 4 + 8 * 6, 508 );
SKIN.Colours.Tab.Inactive.Hover			= GWEN.TextureColor( 4 + 8 * 7, 508 );
SKIN.Colours.Tab.Inactive.Down			= GWEN.TextureColor( 4 + 8 * 6, 500 );
SKIN.Colours.Tab.Inactive.Disabled		= GWEN.TextureColor( 4 + 8 * 7, 500 );

SKIN.Colours.Tree = {}
SKIN.Colours.Tree.Lines					= GWEN.TextureColor( 4 + 8 * 10, 508 );		---- !!!
SKIN.Colours.Tree.Normal				= GWEN.TextureColor( 4 + 8 * 11, 508 );
SKIN.Colours.Tree.Hover					= GWEN.TextureColor( 4 + 8 * 10, 500 );
SKIN.Colours.Tree.Selected				= GWEN.TextureColor( 4 + 8 * 11, 500 );

SKIN.Colours.Properties = {}
SKIN.Colours.Properties.Line_Normal			= GWEN.TextureColor( 4 + 8 * 12, 508 );
SKIN.Colours.Properties.Line_Selected		= GWEN.TextureColor( 4 + 8 * 13, 508 );
SKIN.Colours.Properties.Line_Hover			= GWEN.TextureColor( 4 + 8 * 12, 500 );
SKIN.Colours.Properties.Title				= GWEN.TextureColor( 4 + 8 * 13, 500 );
SKIN.Colours.Properties.Column_Normal		= GWEN.TextureColor( 4 + 8 * 14, 508 );
SKIN.Colours.Properties.Column_Selected		= GWEN.TextureColor( 4 + 8 * 15, 508 );
SKIN.Colours.Properties.Column_Hover		= GWEN.TextureColor( 4 + 8 * 14, 500 );
SKIN.Colours.Properties.Border				= GWEN.TextureColor( 4 + 8 * 15, 500 );
SKIN.Colours.Properties.Label_Normal		= GWEN.TextureColor( 4 + 8 * 16, 508 );
SKIN.Colours.Properties.Label_Selected		= GWEN.TextureColor( 4 + 8 * 17, 508 );
SKIN.Colours.Properties.Label_Hover			= GWEN.TextureColor( 4 + 8 * 16, 500 );

SKIN.Colours.Category = {}
SKIN.Colours.Category.Header				= GWEN.TextureColor( 4 + 8 * 18, 500 );
SKIN.Colours.Category.Header_Closed			= GWEN.TextureColor( 4 + 8 * 19, 500 );
SKIN.Colours.Category.Line = {}
SKIN.Colours.Category.Line.Text				= GWEN.TextureColor( 4 + 8 * 20, 508 );
SKIN.Colours.Category.Line.Text_Hover		= GWEN.TextureColor( 4 + 8 * 21, 508 );
SKIN.Colours.Category.Line.Text_Selected	= GWEN.TextureColor( 4 + 8 * 20, 500 );
SKIN.Colours.Category.Line.Button			= GWEN.TextureColor( 4 + 8 * 21, 500 );
SKIN.Colours.Category.Line.Button_Hover		= GWEN.TextureColor( 4 + 8 * 22, 508 );
SKIN.Colours.Category.Line.Button_Selected	= GWEN.TextureColor( 4 + 8 * 23, 508 );
SKIN.Colours.Category.LineAlt = {}
SKIN.Colours.Category.LineAlt.Text				= GWEN.TextureColor( 4 + 8 * 22, 500 );
SKIN.Colours.Category.LineAlt.Text_Hover		= GWEN.TextureColor( 4 + 8 * 23, 500 );
SKIN.Colours.Category.LineAlt.Text_Selected		= GWEN.TextureColor( 4 + 8 * 24, 508 );
SKIN.Colours.Category.LineAlt.Button			= GWEN.TextureColor( 4 + 8 * 25, 508 );
SKIN.Colours.Category.LineAlt.Button_Hover		= GWEN.TextureColor( 4 + 8 * 24, 500 );
SKIN.Colours.Category.LineAlt.Button_Selected	= GWEN.TextureColor( 4 + 8 * 25, 500 );

SKIN.Colours.TooltipText	= Color( 200, 200, 200, 255 );

SKIN.colTextEntryText			= Color( 255, 255, 255, 255 )
SKIN.colTextEntryTextHighlight	= Color( 255, 255, 255, 255 )

SKIN.fontCategoryHeader			= "VCandara20";

function SKIN:PaintFrame( panel )
	
	if( !panel.LaidOut ) then
		
		panel.LaidOut = self;
		panel.PerformLayout = self.LayoutFrame;
		
	end
	
	surface.SetDrawColor( 0, 0, 0, 220 );
	surface.DrawRect( 0, 0, panel:GetWide(), panel:GetTall() );
	
	surface.SetDrawColor( 25, 25, 25, 255 );
	surface.DrawRect( 0, 0, panel:GetWide(), 30 );
	V.SlickBackground( 0, 0, panel:GetWide(), 30 );
	
	if( panel.PaintChild ) then
		
		panel.PaintChild( panel );
		
	end
	
end

function SKIN.LayoutFrame( panel )
	
    panel.lblTitle:SetFont( panel.LaidOut.fontFrame );
	
	panel.btnClose:SetDrawBackground( true );
    panel.btnClose:SetPos( panel:GetWide() - 30, 0 );
    panel.btnClose:SetSize( 30, 30 );
    panel.btnClose:SetText( "r" );
    panel.btnClose:SetFont( "marlett" );
	
	panel.btnMaxim:Remove();
	panel.btnMinim:Remove();
    
    panel.lblTitle:SetPos( 10, 0 );
    panel.lblTitle:SetSize( panel:GetWide() - 30, 30 );
	
end

function SKIN:PaintButton( panel, w, h )
	
	if( panel.m_bBackground ) then
		
		if( ( panel.Hovered or panel.m_bSelected ) and !panel:GetDisabled() ) then
			
			surface.SetDrawColor( 58, 25, 25, 255 );
			
		else
			
			surface.SetDrawColor( 25, 25, 25, 255 );
			
		end
		
		surface.DrawRect( 0, 0, w, h );
		
		if( !panel:GetDisabled() ) then
			
			V.SlickBackground( 0, 0, w, h );
			
		end
		
	end
	
end

function SKIN:PaintWindowCloseButton( panel, w, h )

	return SKIN:PaintButton( panel, w, h );

end

function SKIN:SchemeButton( panel )
	
    if( panel:GetDisabled() ) then
        panel:SetTextColor( self.colButtonTextDisabled );
    else
        panel:SetTextColor( self.colButtonText );
    end
    
    DLabel.ApplySchemeSettings( panel );
	
end

function SKIN:PaintButtonDown( panel, w, h )
	
	if( !panel.LaidOut ) then
		
		panel.LaidOut = true;
		panel:SetText( "u" );
		panel:SetFont( "marlett" );
		
	end
	
	if( panel.Hovered ) then
		
		surface.SetDrawColor( 58, 25, 25, 255 );
		
	else
		
		surface.SetDrawColor( 25, 25, 25, 255 );
		
	end
	
	surface.DrawRect( 0, 0, w, h );
	
	V.SlickBackground( 0, 0, w, h );

end

function SKIN:PaintButtonUp( panel, w, h )
	
	if( !panel.LaidOut ) then
		
		panel.LaidOut = true;
		panel:SetText( "t" );
		panel:SetFont( "marlett" );
		
	end
	
	if( panel.Hovered ) then
		
		surface.SetDrawColor( 58, 25, 25, 255 );
		
	else
		
		surface.SetDrawColor( 25, 25, 25, 255 );
		
	end
	
	surface.DrawRect( 0, 0, w, h );
	
	V.SlickBackground( 0, 0, w, h );

end

function SKIN:PaintTextEntry( panel )
	
	local w, h = panel:GetSize();
	
	if( panel:GetDrawBackground() ) then
		
		surface.SetDrawColor( 25, 25, 25, 255 );
		surface.DrawRect( 0, 0, w, h );
		
	end
	
	V.SlickBackground( 0, 0, w, h );
	
	surface.SetDrawColor( 150, 150, 150, 255 );
	surface.DrawOutlinedRect( 0, 0, w, h );
	
	panel:DrawTextEntryText( panel:GetTextColor(), Color( 255, 255, 255, 255 ), Color( 255, 255, 255, 200 ) );
	
end

function SKIN:PaintVScrollBar( panel )
	
	
	
end

function SKIN:PaintScrollBarGrip( panel )
	
	local w, h = panel:GetSize();
	surface.SetDrawColor( 25, 25, 25, 255 );
	surface.DrawRect( 0, 0, w, h );
	V.SlickBackground( 0, 0, w, h, true );
	
end

function SKIN:PaintPropertySheet( panel, w, h )
	
	surface.SetDrawColor( 25, 25, 25, 255 );
	surface.DrawRect( 0, 0, w, 30 );
	
end

function SKIN:PaintTab( panel, w, h )
	
	if( panel:GetPropertySheet():GetActiveTab() == panel ) then
		
		surface.SetDrawColor( 58, 25, 25, 255 );
		surface.DrawRect( 0, 0, w, h );
		return;
		
	end
	
	surface.SetDrawColor( 25, 25, 25, 255 );
	surface.DrawRect( 0, 0, w, h );
	
end

function SKIN:PaintTooltip( panel, w, h )

	draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 220 ) );

end

function SKIN:PaintComboBox( panel, w, h )
	
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 220 ) );
	
end

local Tooltip = nil -- :/
local TooltippedPanel = nil

local function RemoveTooltip( PositionPanel )
	
	if( !Tooltip or !Tooltip:IsValid() ) then return true end
	
	Tooltip:Close();
	Tooltip = nil;
	return true;

end

function FindTooltip( panel )
	
	while( panel and panel:IsValid() ) do
	
		if( panel.strTooltipText or panel.pnlTooltipPanel ) then
			return panel.strTooltipText, panel.pnlTooltipPanel, panel;
		end
		
		panel = panel:GetParent();
	
	end
	
end

function ChangeTooltip( panel )

	RemoveTooltip();
	
	local Text, Panel, PositionPanel = FindTooltip( panel );
	
	if( !Text and !Panel ) then return end

	Tooltip = vgui.Create( "DTooltip" );
	Tooltip:SetFont( "VCandara20" ); -- I hate redoing all the tooltip code for setting font. 
	
	if( Text ) then
	
		Tooltip:SetText( Text );
		
	else
	
		Tooltip:SetContents( Panel, false );
	
	end

	Tooltip:OpenForPanel( PositionPanel );
	TooltippedPanel = panel;

end

function EndTooltip( panel )

	if( !TooltippedPanel ) then return end
	if( TooltippedPanel != panel ) then return end

	RemoveTooltip();

end

local function PaintNotches( x, y, w, h, num )

	if ( !num ) then return end

	local space = w / num
	
	for i=0, num do
	
		surface.DrawRect( x + i * space, y+4,	1,  5 )
	
	end

end

function SKIN:PaintNumSlider( panel, w, h )

	surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
	surface.DrawRect( 8, h/2-1,		w-15,  1 )
	
	PaintNotches( 8, h/2-1,		w-16,  1, panel.m_iNotches )

end

function SKIN:PaintMenu( panel, w, h )

	draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 220 ) );
	
end

function SKIN:PaintMenuOption( panel, w, h )
	
	if( panel.Hovered or panel.Highlight ) then
		
		draw.RoundedBox( 0, 0, 0, w, h, Color( 58, 25, 25, 255 ) );
		
	end
	
end


derma.DefineSkin( "Vein", "Vein Skin", SKIN );