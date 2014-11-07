V.CRED = { };
V.CRED.DonatorsText = { };

function V.CRED.RegisterDonors( contents, size, headers, code )
	
	MsgC( Color( 0, 255, 0, 255 ), "Donator listing successful.\n" );
	
	local t1 = string.Explode( ";", contents );
	
	for _, v in pairs( t1 ) do
		
		if( v != "" ) then
			
			local t2 = string.Explode( ",", v );
			
			table.insert( V.CRED.DonatorsText, t2[1] .. ": " .. t2[2] .. "." );
			
		end
		
	end
	
end

function V.CRED.FailedDonors( err )
	
	MsgC( Color( 255, 0, 0, 255 ), "ERROR - Could not connect to donator listing (" .. err .. ").\n" );
	
	V.CRED.DonatorsText = {
		"Can't find donors."
	};
	
end

http.Fetch( "http://dl.dropbox.com/u/55263305/veindonors.txt", V.CRED.RegisterDonors, V.CRED.FailedDonors );

function V.CRED.CreatePanel()
	
	if( V.CC.CharCreateOpen ) then return end
	if( V.INV.FrameOpen ) then return end
	if( LocalPlayer().Asleep ) then return end
	
	V.CRED.CredWin = vgui.Create( "DFrame" );
	V.CRED.CredWin:SetSize( 350, 500 );
	V.CRED.CredWin:Center();
	V.CRED.CredWin:SetTitle( "Credits" );
	V.CRED.CredWin:MakePopup();
	V.CRED.CredWin:ShowCloseButton( true );
	
	V.CRED.Sheet = vgui.Create( "VPropertySheet", V.CRED.CredWin );
	V.CRED.Sheet:SetPos( 0, 30 );
	V.CRED.Sheet:SetSize( 350, 470 );
	
	V.CRED.HelpMenu = vgui.Create( "EditablePanel" );
	V.CRED.HelpMenu:SetPos( 0, 0 );
	V.CRED.HelpMenu:SetSize( 350, 450 );
	
	for k, v in pairs( V.CRED.Help ) do
		
		if( string.len( v ) > 0 ) then
			
			local a = vgui.Create( "DLabel", V.CRED.HelpMenu );
			a:SetPos( 10, 10 + 20 * ( k - 1 ) );
			a:SetFont( "VCandara20" );
			a:SetText( v );
			a:SizeToContents();
			
		end
		
	end
	
	V.CRED.Credits = vgui.Create( "EditablePanel" );
	V.CRED.Credits:SetPos( 0, 0 );
	V.CRED.Credits:SetSize( 350, 450 );
	
	for k, v in pairs( V.CRED.Text ) do
		
		if( string.len( v ) > 0 ) then
			
			local a = vgui.Create( "DLabel", V.CRED.Credits );
			a:SetPos( 10, 10 + 20 * ( k - 1 ) );
			a:SetFont( "VCandara20" );
			a:SetText( v );
			a:SizeToContents();
			
		end
		
	end
	
	V.CRED.Donators = vgui.Create( "EditablePanel" );
	V.CRED.Donators:SetPos( 0, 0 );
	V.CRED.Donators:SetSize( 350, 450 );
	
	for k, v in pairs( V.CRED.DonatorsText ) do
		
		if( string.len( v ) > 0 ) then
			
			local a = vgui.Create( "DLabel", V.CRED.Donators );
			a:SetPos( 10, 10 + 20 * ( k - 1 ) );
			a:SetFont( "VCandara20" );
			a:SetText( v );
			a:SizeToContents();
			
		end
		
	end
	
	V.CRED.Donate = vgui.Create( "EditablePanel" );
	V.CRED.Donate:SetPos( 0, 0 );
	V.CRED.Donate:SetSize( 350, 450 );
	
	local a = vgui.Create( "DLabel", V.CRED.Donate );
	a:SetPos( 10, 10 );
	a:SetFont( "VCandara20" );
	a:SetText( "Vein is open-source. Please keep it that\nway by donating - you also get your name\nin the credits, unless you donate\nanonymously." );
	a:SizeToContents();
	
	local b = vgui.Create( "DButton", V.CRED.Donate );
	b:SetPos( 100, 110 );
	b:SetSize( 150, 50 );
	b:SetFont( "VCandara20" );
	b:SetText( "Donate" );
	b:SetFont( "VCandara20" );
	b.DoClick = function( self )
		
		gui.OpenURL( "http://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=ALZ4X4VURFK3A&lc=CA&item_name=Vein&item_number=vein%2dingame&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted" );
		
	end
	
	local b = vgui.Create( "DButton", V.CRED.Donate );
	b:SetPos( 50, 180 );
	b:SetSize( 250, 50 );
	b:SetFont( "VCandara20" );
	b:SetText( "Donate Anonymously" );
	b:SetFont( "VCandara20" );
	b.DoClick = function( self )
		
		gui.OpenURL( "http://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=ALZ4X4VURFK3A&lc=CA&item_name=Vein&item_number=vein%2dingame%2da&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted" );
		
	end
	
	V.CRED.Sheet:AddSheet( "Help", V.CRED.HelpMenu, false, false );
	V.CRED.Sheet:AddSheet( "Development", V.CRED.Credits, false, false );
	V.CRED.Sheet:AddSheet( "Donators", V.CRED.Donators, false, false );
	V.CRED.Sheet:AddSheet( "Donate", V.CRED.Donate, false, false );
	
end