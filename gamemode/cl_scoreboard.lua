V.SC = { };

V.SC.Board = nil;

V.SC.PingLow = Material( "vgui/icon_con_high" );
V.SC.PingMed = Material( "vgui/icon_con_medium" );
V.SC.PingHigh = Material( "vgui/icon_con_low" );

function GM:ScoreboardShow()
	
	V.SC.MakeBoard();
	
end

function GM:ScoreboardHide()
	
	gui.EnableScreenClicker( false );
	
	if( V.SC.Board ) then
		
		V.SC.Board:Remove();
		
	end
	
	V.SC.Board = nil;
	
end

function V.SC.Think()
	
	if( V.SC.Board ) then
		
		V.SC.Board:SetTitle( GetHostName() );
		
	end
	
end

function V.SC.MakeBoard()
	
	V.SC.Board = vgui.Create( "DFrame" );
	V.SC.Board:SetSize( 400, 600 );
	V.SC.Board:Center();
	V.SC.Board:SetTitle( GetHostName() );
	V.SC.Board:ShowCloseButton( false );
	
	local pane = vgui.Create( "DScrollPanel", V.SC.Board );
	pane:SetPos( 0, 30 );
	pane:SetSize( 400, 570 );
	pane.Paint = function( self, w, h )
		
		local n = 0;
		local d = 0;
		
		if( self.VBar:GetOffset() ) then
			
			d = self.VBar:GetOffset();
			
		end
		
		for _, v in pairs( player.GetAll() ) do
			
			if( n % 2 == 0 ) then
				
				surface.SetDrawColor( 25, 25, 25, 255 );
				surface.DrawRect( 0, n * 32 + d, 385, 32 );
				
			end
			
			local ping = v:Ping();
			local x = 385 - 32;
			local y = n * 32;
			local tex = V.SC.PingHigh;
			
			if( ping < 60 ) then
				
				tex = V.SC.PingLow;
				
			elseif( ping < 180 ) then
				
				tex = V.SC.PingMed;
				
			else
				
				tex = V.SC.PingHigh;
				
			end
			
			surface.SetDrawColor( 255, 255, 255, 255 );
			surface.SetMaterial( tex );
			surface.DrawTexturedRect( x, y + d, 32, 32 );
			
			n = n + 1;
			
		end
		
	end
	
	content = vgui.Create( "EditablePanel" );
	content:SetPos( 0, 0 );
	content:SetSize( 385, 570 );
	
	pane:AddItem( content );
	
	local n = 0;
	
	for _, v in pairs( player.GetAll() ) do
		
		local sid = vgui.Create( "AvatarImage", content );
		sid:SetPos( 0, n * 32 );
		sid:SetSize( 32, 32 );
		sid:SetPlayer( v );
		
		local name = vgui.Create( "DLabel", content );
		name:SetPos( 42, n * 32 );
		name:SetSize( 385 - 32, 32 );
		name:SetFont( "VCandara20" );
		name:SetText( v:Nick() );
		
		n = n + 1;
		
	end
	
	content:SetTall( n * 32 );
	pane:PerformLayout();
	
	gui.EnableScreenClicker( true );
	
end