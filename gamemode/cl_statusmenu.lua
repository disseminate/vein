V.SMEN = { };

function V.SMEN.CreatePanel( t )
	
	if( V.CC.CharCreateOpen ) then return end
	if( V.INV.FrameOpen ) then return end
	if( LocalPlayer().Asleep ) then return end
	if( !LocalPlayer():Alive() ) then return end
	
	local model = LocalPlayer():GetModel();
	local skin = LocalPlayer():GetSkin();
	
	if( t and t:IsValid() ) then
		
		model = t:GetModel();
		skin = t:GetSkin();
		
	end
	
	V.SMEN.MenuWin = vgui.Create( "DFrame" );
	V.SMEN.MenuWin:SetSize( 500, 500 );
	V.SMEN.MenuWin:Center();
	V.SMEN.MenuWin:SetTitle( "Character" );
	V.SMEN.MenuWin:MakePopup();
	V.SMEN.MenuWin:ShowCloseButton( true );
	
	V.SMEN.MDL = vgui.Create( "VStatusModel", V.SMEN.MenuWin );
	V.SMEN.MDL:SetPos( 250 - ( 135 / 2 ), 45 );
	V.SMEN.MDL:SetSize( 135, 135 );
	
	if( V.INS.Level >= 3 ) then
		
		V.SMEN.MDL:SetModel( table.Random( V.ZombieModels ) );
		
	else
		
		V.SMEN.MDL:SetModel( model );
		V.SMEN.MDL:SetSkin( skin );
		
	end
	
	if( V.INS.Level >= 4 ) then
		
		V.SMEN.MDL:SetMaterial( "models/flesh" );
		
	end
	
	V.SMEN.MDL:StartAnimation( "idle" );
	
	if( t and t:IsValid() ) then
		
		V.SMEN.MDL.NoMovement = true;
		
	else
		
		if( V.INS.Level >= 1 ) then
			
			V.SMEN.MDL:StartScene( "scenes/expressions/citizen_scared_combat_01.vcd" );
			
		end
		
	end
	
	V.SMEN.Rule = vgui.Create( "VHorizontalRule", V.SMEN.MenuWin );
	V.SMEN.Rule:SetPos( 15, 195 );
	V.SMEN.Rule:SetSize( 470, 1 );
	
	local desc = LocalPlayer():PDesc();
	
	if( t and t:IsValid() ) then
		
		desc = t:PDesc();
		
	end
	
	if( V.INS.Level >= 4 ) then
		
		desc = string.gsub( table.Random( V.InsanityText ), "name", table.Random( player.GetAll() ):RPName() );
		
	end
	
	V.SMEN.PDesc = vgui.Create( "DScrollPanel", V.SMEN.MenuWin );
	V.SMEN.PDesc:SetPos( 15, 250 );
	V.SMEN.PDesc:SetSize( 470, 250 - 15 - 20 - 15 );
	
	V.SMEN.PDesc.Text = vgui.Create( "DLabel" );
	V.SMEN.PDesc:AddItem( V.SMEN.PDesc.Text );
	V.SMEN.PDesc.Text:SetPos( 0, 0 );
	V.SMEN.PDesc.Text:SetSize( 470 - 16, 100 );
	V.SMEN.PDesc.Text:SetFont( "VCandara30" );
	V.SMEN.PDesc.Text:SetWrap( true );
	V.SMEN.PDesc.Text:SetAutoStretchVertical( true );
	V.SMEN.PDesc.Text:SetText( desc );
	
	if( V.INS.Level >= 3 ) then
		
		V.SMEN.PDesc.Text:SetTextColor( Color( 200, 0, 0, 255 ) );
		
	end
	
	V.SMEN.PDesc:PerformLayout();
	
	if( !t or !t:IsValid() ) then
		
		V.SMEN.But = vgui.Create( "DButton", V.SMEN.MenuWin );
		V.SMEN.But:SetPos( 15, V.SMEN.MenuWin:GetTall() - 15 - 20 );
		V.SMEN.But:SetSize( 100, 20 );
		V.SMEN.But:SetText( "Edit" );
		V.SMEN.But:SetFont( "VCandara20" );
		V.SMEN.But.DoClick = V.SMEN.EditDesc;
		
	end
	
	V.SMEN.MenuWin.PaintChild = function( self )
		
		local name = LocalPlayer():RPName();
		
		if( t and t:IsValid() ) then
			
			name = t:RPName();
			
		end
		
		draw.DrawText( name, "VCandara50", 250, 45 + 135 + 5 + 10, Color( 255, 255, 255, 255 ), 1 );
		
	end
	
end

function V.SMEN.EditDesc( b )
	
	V.SMEN.DescWin = vgui.Create( "DFrame" );
	V.SMEN.DescWin:SetSize( 300, 300 );
	V.SMEN.DescWin:Center();
	V.SMEN.DescWin:SetTitle( "Change Description" );
	V.SMEN.DescWin:ShowCloseButton( false );
	V.SMEN.DescWin.PaintChild = function( self )
		
		if( V.SMEN.DescEntry ) then
			
			local len = string.len( V.SMEN.DescEntry:GetValue() );
			local maxlen = V.Config.MaxDescLen;
			
			local col = Color( 255, 255, 255, 255 );
			
			if( len > maxlen ) then
				
				col = Color( 255, 0, 0, 255 );
				
			end
			
			draw.DrawText( tostring( len )  .. "/" .. tostring( maxlen ), "VCandara20", 5 + 215 + ( 300 - ( 5 + 215 ) ) / 2, 35, col, 1 );
			
		end
		
	end
	V.SMEN.DescWin:MakePopup();
	
	V.SMEN.DescEntry = vgui.Create( "DTextEntry", V.SMEN.DescWin );
	V.SMEN.DescEntry:SetTextColor( Color( 200, 200, 200, 255 ) );
	V.SMEN.DescEntry:SetFont( "VCandara20" );
	V.SMEN.DescEntry:SetPos( 5, 35 );
	V.SMEN.DescEntry:SetSize( 215, 260 );
	V.SMEN.DescEntry:SetText( LocalPlayer():PDesc() );
	V.SMEN.DescEntry:SetEditable( true );
	V.SMEN.DescEntry:SetMultiline( true );
	V.SMEN.DescEntry:RequestFocus();
	
	V.SMEN.DescBut = vgui.Create( "DButton", V.SMEN.DescWin );
	V.SMEN.DescBut:SetPos( 300 - 70 - 5, 300 - 40 - 5 );
	V.SMEN.DescBut:SetSize( 70, 40 );
	V.SMEN.DescBut:SetText( "Done" );
	V.SMEN.DescBut:SetFont( "VCandara20" );
	V.SMEN.DescBut.DoClick = function( b )
		
		local val = V.SMEN.DescEntry:GetValue();
		
		if( string.len( val ) > V.Config.MaxDescLen ) then
			
			val = string.sub( val, 1, V.Config.MaxDescLen );
			
		end
		
		net.Start( "e_pd" );
			net.WriteString( val );
		net.SendToServer();
		
		if( V.SMEN.PDesc.Text ) then
			
			V.SMEN.PDesc.Text:SetText( val );
			
		end
		
		V.SMEN.DescEntry:Remove();
		V.SMEN.DescBut:Remove();
		V.SMEN.DescWin:Remove();
		
	end;
	
end