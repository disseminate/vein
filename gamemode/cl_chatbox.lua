V.CB = { };

local h = ScrH() / 4;
local w = ScrW() / 3;

local b = 10;
local numbuts = 4;

local buth = 20;
local butw = ( w - ( numbuts + 1 ) * b ) / numbuts;

V.CB.CurFilter = 1;

V.CB.ChatLines = { };

function V.CB.AddToChat( text, col, font, filter )
	
	table.insert( V.CB.ChatLines, { text, col, font, filter, CurTime() } );
	
	if( #V.CB.ChatLines > 100 ) then
		
		table.remove( V.CB.ChatLines, 1 );
		
	end
	
	MsgC( col, text .. "\n" );
	
end

function V.CB.ChangeFilter( b )
	
	if( V.CB.CurFilter == V.CB.ALL.N ) then V.CB.ALL:SetDisabled( false ); end
	if( V.CB.CurFilter == V.CB.IC.N ) then V.CB.IC:SetDisabled( false ); end
	if( V.CB.CurFilter == V.CB.OOC.N ) then V.CB.OOC:SetDisabled( false ); end
	
	V.CB.CurFilter = b.N;
	b:SetDisabled( true );
	
end

function V.CB.FormatLine( str, font, size )

	local start = 1;
	local c = 1;
	
	surface.SetFont( font );
	
	local endstr = "";
	local n = 0;
	local lastspace = 0;
	local lastspacemade = 0;
	
	while( string.len( str or "" ) > c ) do
	
		local sub = string.sub( str, start, c );
	
		if( string.sub( str, c, c ) == " " ) then
			lastspace = c;
		end

		if( surface.GetTextSize( sub ) >= size and lastspace ~= lastspacemade ) then
			
			local sub2;
			
			if( lastspace == 0 ) then
				lastspace = c;
				lastspacemade = c;
			end
			
			if( lastspace > 1 ) then
				sub2 = string.sub( str, start, lastspace - 1 );
				c = lastspace;
			else
				sub2 = string.sub( str, start, c );
			end
			
			endstr = endstr .. sub2 .. "\n";
			
			lastspace = c + 1;
			lastspacemade = lastspace;
			
			start = c + 1;
			n = n + 1;
		
		end
	
		c = c + 1;
	
	end
	
	if( start < string.len( str or "" ) ) then
	
		endstr = endstr .. string.sub( str or "", start );
	
	end
	
	return endstr, n;

end

function V.CB.CreateChatbox()
	
	V.CB.ChatBox = vgui.Create( "EditablePanel" );
	V.CB.ChatBox:SetPos( b, ScrH() - b - h );
	V.CB.ChatBox:SetSize( w, h );
	V.CB.ChatBox.Paint = function( self )
		
		surface.SetDrawColor( 0, 0, 0, 220 );
		surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() );
		
	end
	V.CB.ChatBox:MakePopup();
	
	V.CB.ALL = vgui.Create( "DButton", V.CB.ChatBox );
	V.CB.ALL:SetSize( butw, buth );
	V.CB.ALL:SetPos( b + ( butw + b ) * 0, b );
	V.CB.ALL:SetText( "ALL" );
	V.CB.ALL:SetFont( "VCandara20" );
	V.CB.ALL.N = 1;
	if( V.CB.CurFilter == V.CB.ALL.N ) then V.CB.ALL:SetDisabled( true ); end
	V.CB.ALL.DoClick = V.CB.ChangeFilter;

	V.CB.IC = vgui.Create( "DButton", V.CB.ChatBox );
	V.CB.IC:SetSize( butw, buth );
	V.CB.IC:SetPos( b + ( butw + b ) * 1, b );
	V.CB.IC:SetText( "IC" );
	V.CB.IC:SetFont( "VCandara20" );
	V.CB.IC.N = 2;
	if( V.CB.CurFilter == V.CB.IC.N ) then V.CB.IC:SetDisabled( true ); end
	V.CB.IC.DoClick = V.CB.ChangeFilter;

	V.CB.OOC = vgui.Create( "DButton", V.CB.ChatBox );
	V.CB.OOC:SetSize( butw, buth );
	V.CB.OOC:SetPos( b + ( butw + b ) * 2, b );
	V.CB.OOC:SetText( "OOC" );
	V.CB.OOC:SetFont( "VCandara20" );
	V.CB.OOC.N = 3;
	if( V.CB.CurFilter == V.CB.OOC.N ) then V.CB.OOC:SetDisabled( true ); end
	V.CB.OOC.DoClick = V.CB.ChangeFilter;
	
	V.CB.X = vgui.Create( "DButton", V.CB.ChatBox );
	V.CB.X:SetSize( butw, buth );
	V.CB.X:SetPos( b + ( butw + b ) * 3, b );
	V.CB.X:SetFont( "marlett" );
	V.CB.X:SetText( "r" );
	V.CB.X.DoClick = V.CB.HideChatbox;
	
	V.CB.ChatLand = vgui.Create( "DScrollPanel", V.CB.ChatBox );
	V.CB.ChatLand:SetPos( b, b + buth + b );
	V.CB.ChatLand:SetSize( w - b * 2, h - b * 4 - buth - 20 );
	V.CB.ChatLand.Paint = function( self )
		
		surface.SetDrawColor( 0, 0, 0, 220 );
		surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() );
		
	end
	
	V.CB.ChatLandContent = vgui.Create( "EditablePanel" );
	V.CB.ChatLandContent:SetPos( 0, 0 );
	V.CB.ChatLandContent:SetSize( w - b * 2, 20 );
	V.CB.ChatLandContent.Paint = function( self )
		
		V.CB.DrawChatLines( true, 255, V.CB.ChatLand );
		
	end
	
	V.CB.ChatLand:AddItem( V.CB.ChatLandContent );
	
	V.CB.ChatBar = vgui.Create( "DTextEntry", V.CB.ChatBox );
	V.CB.ChatBar:SetTextColor( Color( 200, 200, 200, 255 ) );
	V.CB.ChatBar:SetFont( "VCandara20" );
	V.CB.ChatBar:SetPos( b, h - 20 - b );
	V.CB.ChatBar:SetSize( w - b * 2, 20 );
	V.CB.ChatBar:SetText( "" );
	V.CB.ChatBar.OnEnter = function( self )
		
		if( string.len( self:GetValue() ) > 0 ) then
			
			net.Start( "e_c" );
				net.WriteString( self:GetValue() );
			net.SendToServer();
			
			V.CCMD.OnChat( LocalPlayer(), self:GetValue() );
			
		end
		
		net.Start( "e_chatc" );
		net.SendToServer();
		
		V.CB.HideChatbox();
		
	end
	V.CB.ChatBar.OnTextChanged = function( self )
		
		local cc = V.CCMD.StringHasCommand( self:GetValue() );
		
		if( cc ) then
			
			self:SetTextColor( Color( cc[3].r, cc[3].g, cc[3].b, 255 ) );
			
		else
			
			self:SetTextColor( Color( 200, 200, 200, 255 ) );
			
		end
		
	end
	V.CB.ChatBar:RequestFocus();
	
end

function V.CB.HideChatbox()
	
	V.CB.ChatBox:Remove();
	
	V.CB.ChatBox = nil;
	
	V.CB.ALL = nil;
	V.CB.IC = nil;
	V.CB.OOC = nil;
	V.CB.X = nil;
	
	V.CB.ChatLandContent = nil;
	V.CB.ChatLand = nil;
	V.CB.ChatBar = nil;
	
end

function V.CB.ShowChatbox()
	
	V.CB.CreateChatbox();
	
end

function GM:StartChat()
	
	return true;
	
end

function V.CB.DrawChatLines( panel, a )
	
	if( V.BlackScreenAlpha == 255 ) then return end
	
	if( panel ) then
		
		local ch = 0;
		
		for _, v in pairs( V.CB.ChatLines ) do
			
			local text = v[1];
			local col = v[2];
			local font = v[3];
			local filt = v[4];
			local start = v[5];
			
			if( table.HasValue( filt, V.CB.CurFilter ) ) then
				
				local formatted = V.CB.FormatLine( text, font, w - b * 2 ); -- already sets the font.
				
				local timesince = CurTime() - start;
				
				local fa = 1;
				
				if( timesince < 0.2 ) then
					
					fa = timesince * 5;
					
				elseif( timesince > 9.8 ) then
					
					fa = math.max( math.max( ( 0.2 - ( timesince - 9.8 ) ) * 5, 0 ), a );
					
				end
				
				local expl = string.Explode( "\n", formatted );
				
				for _, v in pairs( expl ) do
					
					local _, h = surface.GetTextSize( v );
					
					surface.SetTextColor( 0, 0, 0, 255 );
					surface.SetTextPos( 1, ch + 1 );
					surface.DrawText( string.sub( v, 1, 196 ) );
					surface.SetTextColor( col.r, col.g, col.b, fa * 255 );
					surface.SetTextPos( 0, ch );
					surface.DrawText( string.sub( v, 1, 196 ) );
					
					ch = ch + h;
					
				end
				
			end
			
		end
		
		if( V.CB.ChatLandContent ) then
			
			local h = V.CB.ChatLandContent:GetTall();
			
			if( h != math.max( ch, 20 ) ) then
				
				V.CB.ChatLandContent:SetTall( math.max( ch, 20 ) );
				V.CB.ChatLand:PerformLayout();
				
				if( V.CB.ChatLand.VBar ) then
					
					V.CB.ChatLand.VBar:SetScroll( math.huge );
					
				end
				
			end
			
		end
		
	else
		
		local ftab = { };
		
		for _, v in pairs( V.CB.ChatLines ) do
			
			if( table.HasValue( v[4], V.CB.CurFilter ) ) then
				
				table.insert( ftab, v );
				
			end
			
		end
		
		local ch = ScrH() - 50;
		
		for i = #ftab, math.max( #ftab - 5, 1 ), -1 do
			
			local x = ftab[i];
			
			local text = x[1];
			local col = x[2];
			local font = x[3];
			local filt = x[4];
			local start = x[5];
			
			local timesince = CurTime() - start;
			
			if( timesince < 10 ) then
				
				local formatted = V.CB.FormatLine( text, font, w - b * 2 );
				local _, h = surface.GetTextSize( formatted );
				ch = ch - h;
				
				local a = 1;
				
				if( timesince < 0.2 ) then
					
					a = timesince * 5;
					
				elseif( timesince > 9.8 ) then
					
					a = ( 0.2 - ( timesince - 9.8 ) ) * 5;
					
				end
				
				local expl = string.Explode( "\n", formatted );
				
				local cch = ch;
				
				for _, v in pairs( expl ) do
					
					if( v != "" ) then
						
						local _, h = surface.GetTextSize( v );
						
						surface.SetTextColor( 0, 0, 0, 255 );
						surface.SetTextPos( 21, cch + 1 );
						surface.DrawText( string.sub( v, 1, 512 ) );
						surface.SetTextColor( col.r, col.g, col.b, a * 255 );
						surface.SetTextPos( 20, cch );
						surface.DrawText( string.sub( v, 1, 512 ) );
						
						cch = cch + h;
						
					end
					
				end
				
			end
			
		end
		
	end
	
end

function GM:OnPlayerChat( ply, text, team, dead )
	
	if( !IsValid( ply ) ) then
		
		V.CB.AddToChat( "Console: " .. text, Color( 200, 0, 0, 255 ), "VCandara20", { 1, 3 } )
		
	end
	
	return true;
	
end