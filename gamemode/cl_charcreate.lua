V.CC = { };

V.CC.Model = 1;
V.CC.Skin = 1;
V.CC.Gender = 0;

V.CC.Mode = V.CCMODE_CREATE_N;
V.CC.CharCreateOpen = false;
V.CC.StartCharCreateTime = -1;

V.CC.ErrText = "";
V.CC.ErrStartTime = 0;

V.CC.Chars = { };

V.CC.ModelIcons = { };

V.CC.CharButtons = { };

V.CurChar = -1;

function V.GetCurChar( len )
	
	V.CurChar = net.ReadFloat();
	
end
net.Receive( "nCharReceive", V.GetCurChar );

function V.CC.SetMode( len )
	
	V.CC.Mode = net.ReadFloat();
	
end
net.Receive( "nCharMode", V.CC.SetMode );

function V.CC.ClearChars()
	
	V.CC.Chars = { };
	
end
net.Receive( "nCharClear", V.CC.ClearChars );

function V.CC.AddChar( len )
	
	local name = net.ReadString();
	local model = net.ReadString();
	local id = net.ReadFloat();
	local skin = net.ReadFloat();
	local dead = net.ReadBit();
	table.insert( V.CC.Chars, { name, id, model, skin, dead } );
	
end
net.Receive( "nCharAdd", V.CC.AddChar );

function V.CC.RemChar( len )
	
	local id = net.ReadFloat();
	
	for k, v in pairs( V.CC.Chars ) do
		
		if( v[2] == id ) then
			
			table.remove( V.CC.Chars, k );
			return;
			
		end
		
	end
	
end
net.Receive( "nCharDelete", V.CC.RemChar );

function V.CC.MakeMenu()
	
	if( V.CC.CharCreateOpen ) then return end
	if( V.INV.FrameOpen ) then return end
	
	V.CC.BlackBar = vgui.Create( "EditablePanel" );
	V.CC.BlackBar:SetSize( ScrW(), ScrH() );
	V.CC.BlackBar:SetPos( 0, 0 );
	V.CC.BlackBar.Paint = function( self )
		
		surface.SetDrawColor( 0, 0, 0, 150 );
		surface.DrawRect( 0, 0, ScrW(), ScrH() );
		
		local w, h = self:GetSize();
		
		surface.SetDrawColor( 0, 0, 0, 255 );
		surface.DrawRect( 0, 0, w, 100 );
		
	end
	V.CC.BlackBar:MakePopup();
	
	V.CC.ButCreate = V.GUI.MakeButton( V.CC.BlackBar, 20, 20, 200, 60, "Create" );
	V.CC.ButCreate:SetFont( "VCandara30" );
	V.CC.ButCreate.DoClick = function()
		
		V.CC.Mode = V.CCMODE_CREATE;
		V.BlackScreenDir = 1;
		V.CC.DeleteMenu();
		
	end
	
	if( #V.CC.Chars >= V.Config.MaxCharacters ) then
		
		V.CC.ButCreate:SetDisabled( true );
		
	end
	
	V.CC.ButSelect = V.GUI.MakeButton( V.CC.BlackBar, 20 + 200 + 20, 20, 200, 60, "Select" );
	V.CC.ButSelect:SetFont( "VCandara30" );
	V.CC.ButSelect.DoClick = function()
		
		V.CC.Mode = V.CCMODE_SELECT;
		V.BlackScreenDir = 1;
		V.CC.DeleteMenu();
		
	end
	
	V.CC.ButDelete = V.GUI.MakeButton( V.CC.BlackBar, 20 + 200 + 20 + 200 + 20, 20, 200, 60, "Delete" );
	V.CC.ButDelete:SetFont( "VCandara30" );
	V.CC.ButDelete.DoClick = function()
		
		V.CC.Mode = V.CCMODE_DELETE;
		V.BlackScreenDir = 1;
		V.CC.DeleteMenu();
		
	end
	
	if( #V.CC.Chars == 1 ) then
		
		V.CC.ButSelect:SetDisabled( true );
		V.CC.ButDelete:SetDisabled( true );
		
	end
	
	V.CC.ButSettings = V.GUI.MakeButton( V.CC.BlackBar, 20 + 200 + 20 + 200 + 20 + 200 + 20, 20, 200, 60, "Settings" );
	V.CC.ButSettings:SetFont( "VCandara30" );
	V.CC.ButSettings.DoClick = function()
		
		V.SET.OpenSettings();
		
	end
	
	V.CC.ButThird = V.GUI.MakeButton( V.CC.BlackBar, ScrW() - 100 - 20 - 200 - 20, 20, 200, 60, "Toggle Third Person" );
	V.CC.ButThird:SetFont( "VCandara20" );
	V.CC.ButThird.DoClick = function()
		
		V.EF.SetThirdPerson( !V.EF.GetThirdPerson() );
		
	end;
	
	V.CC.ButCancel = V.GUI.MakeButton( V.CC.BlackBar, ScrW() - 100 - 20, 20, 100, 60, "Cancel" );
	V.CC.ButCancel:SetFont( "VCandara20" );
	V.CC.ButCancel.DoClick = V.CC.DeleteMenu;
	
end

function V.CC.DeleteMenu()
	
	V.CC.ButCreate:Remove();
	V.CC.ButSelect:Remove();
	V.CC.ButDelete:Remove();
	V.CC.ButCancel:Remove();
	
	V.CC.BlackBar:Remove();
	V.CC.BlackBar = nil;
	
end

function V.CC.CharCreate()
	
	V.CC.CharCreateOpen = true;
	
end

function V.CC.UpdateModel()
	
	if( V.CC.Gender == 0 ) then
		
		V.CC.ModelViewer:SetModel( V.MaleValidModels[V.CC.Model].Model );
		V.CC.ModelViewer:SetSkin( V.CC.Skin );
		
	else
		
		V.CC.ModelViewer:SetModel( V.FemaleValidModels[V.CC.Model].Model );
		V.CC.ModelViewer:SetSkin( V.CC.Skin );
		
	end
	
end

function V.CC.ChangeGender( i )
	
	if( i != V.CC.Gender ) then
		
		if( i == 0 ) then
			
			V.CC.Model = math.random( 1, #V.MaleValidModels );
			V.CC.Skin = V.MaleValidModels[V.CC.Model].Skin[math.random( 1, #V.MaleValidModels[V.CC.Model].Skin )];
			V.CC.GenderMale.m_bSelected = true;
			V.CC.GenderFemale.m_bSelected = false;
			
		else
			
			V.CC.Model = math.random( 1, #V.FemaleValidModels );
			V.CC.Skin = V.FemaleValidModels[V.CC.Model].Skin[math.random( 1, #V.FemaleValidModels[V.CC.Model].Skin )];
			V.CC.GenderMale.m_bSelected = false;
			V.CC.GenderFemale.m_bSelected = true;
			
		end
		
	end
	
	V.CC.Gender = i;
	
	V.CC.UpdateModel();
	
end

function V.CC.ChangeModel( i )
	
	local last = V.CC.Model;
	V.CC.Model = V.CC.Model + i;
	
	local tab;
	if( V.CC.Gender == 0 ) then tab = V.MaleValidModels; end
	if( V.CC.Gender == 1 ) then tab = V.FemaleValidModels; end
	
	local n = #tab;
	
	if( V.CC.Model < 1 ) then
		
		V.CC.Model = #tab;
		
	elseif( V.CC.Model > n ) then
		
		V.CC.Model = 1;
		
	end
	
	if( tab[V.CC.Model].Skin[1] < tab[last].Skin[1] ) then -- 15 to 0
		
		V.CC.Skin = V.CC.Skin - tab[last].Skin[1];
		
	elseif( tab[V.CC.Model].Skin[1] > tab[last].Skin[1] ) then -- 0 to 15
		
		V.CC.Skin = V.CC.Skin + tab[V.CC.Model].Skin[1];
		
	end
	
	V.CC.UpdateModel();
	
end

function V.CC.ChangeSkin( i )
	
	V.CC.Skin = V.CC.Skin + i;
	
	local first;
	local last;
	
	if( V.CC.Gender == 1 ) then
		
		first = V.FemaleValidModels[V.CC.Model].Skin[1];
		last = V.FemaleValidModels[V.CC.Model].Skin[#V.FemaleValidModels[V.CC.Model].Skin];
		
	else
		
		first = V.MaleValidModels[V.CC.Model].Skin[1];
		last = V.MaleValidModels[V.CC.Model].Skin[#V.MaleValidModels[V.CC.Model].Skin];
		
	end
	
	if( V.CC.Skin < first ) then
		
		V.CC.Skin = last;
		
	elseif( V.CC.Skin > last ) then
		
		V.CC.Skin = first;
		
	end
	
	V.CC.UpdateModel();
	
end

function V.CC.SetPosTopright( panel, x, y )
	
	panel:SetPos( ScrW() - x - panel:GetWide(), y );
	
end

function V.CC.SetPosBottomright( panel, x, y )
	
	panel:SetPos( ScrW() - x - panel:GetWide(), ScrH() - y - panel:GetTall() );
	
end

function V.CC.MakeVGUIComponents()
	
	local w, h = ScrW(), ScrH();
	
	local c0 = h;
	local c1 = w - h;
	local c2 = c1 - 20;
	local c3 = c1 / 2 - 15;
	
	V.CC.Win = vgui.Create( "VBlackScreen" );
	V.CC.Win:SetSize( w, h );
	V.CC.Win:SetPos( 0, 0 );
	V.CC.Win:SetMouseInputEnabled( true );
	V.CC.Win:MakePopup();
	
	if( V.CC.Mode == V.CCMODE_CREATE_N or V.CC.Mode == V.CCMODE_CREATE ) then
		
		V.CC.Gender = math.random( 0, 1 );
		local name = "";
		
		if( V.CC.Gender == 0 ) then
			
			V.CC.Model = math.random( 1, #V.MaleValidModels );
			V.CC.Skin = V.MaleValidModels[V.CC.Model].Skin[math.random( 1, #V.MaleValidModels[V.CC.Model].Skin )];
			name = table.Random( V.MaleFirstNames ) .. " " .. table.Random( V.LastNames );
			
		else
			
			V.CC.Model = math.random( 1, #V.FemaleValidModels );
			V.CC.Skin = V.FemaleValidModels[V.CC.Model].Skin[math.random( 1, #V.FemaleValidModels[V.CC.Model].Skin )];
			name = table.Random( V.FemaleFirstNames ) .. " " .. table.Random( V.LastNames );
			
		end
		
		V.CC.ModelViewer = vgui.Create( "VCharPanel", V.CC.Win );
		V.CC.ModelViewer:SetSize( c0, c0 );
		V.CC.ModelViewer:SetPos( 0, 0 );
		if( V.CC.Gender == 0 ) then
			V.CC.ModelViewer:SetModel( V.MaleValidModels[V.CC.Model].Model );
			V.CC.ModelViewer:SetSkin( V.CC.Skin );
		else
			V.CC.ModelViewer:SetModel( V.FemaleValidModels[V.CC.Model].Model );
			V.CC.ModelViewer:SetSkin( V.CC.Skin );
		end
		V.CC.ModelViewer.Entity:SetAngles( Angle() );
		V.CC.ModelViewer:SetFOV( 30 );
		
		V.CC.NameEntry = vgui.Create( "DTextEntry", V.CC.Win );
		V.CC.NameEntry:SetTextColor( Color( 200, 200, 200, 255 ) );
		V.CC.NameEntry:SetFont( "VCandara50" );
		V.CC.NameEntry:SetPos( c0 + 10, 20 );
		V.CC.NameEntry:SetSize( c2 - 140, 50 );
		V.CC.NameEntry:SetText( name );
		
		V.CC.RandomBut = V.GUI.MakeButton( V.CC.Win, c0 + c2 - 120, 20, 120, 50, "Random" );
		V.CC.RandomBut:SetFont( "VCandara30" );
		V.CC.RandomBut.DoClick = function( self )
			
			if( V.CC.Gender == 0 ) then
				
				V.CC.NameEntry:SetText( table.Random( V.MaleFirstNames ) .. " " .. table.Random( V.LastNames ) );
				
			else
				
				V.CC.NameEntry:SetText( table.Random( V.FemaleFirstNames ) .. " " .. table.Random( V.LastNames ) );
				
			end
			
		end
		
		V.CC.GenderMale = V.GUI.MakeButton( V.CC.Win, c0 + 10, 80, c3, 30, "Male" );
		V.CC.GenderMale:SetFont( "VCandara20" );
		V.CC.GenderMale.DoClick = function( self ) V.CC.ChangeGender( 0 ) end
		if( V.CC.Gender == 0 ) then V.CC.GenderMale.m_bSelected = true; end
		
		V.CC.GenderFemale = V.GUI.MakeButton( V.CC.Win, 0, 0, c3, 30, "Female" );
		V.CC.SetPosTopright( V.CC.GenderFemale, 20, 80 );
		V.CC.GenderFemale:SetFont( "VCandara20" );
		V.CC.GenderFemale.DoClick = function( self ) V.CC.ChangeGender( 1 ) end
		if( V.CC.Gender == 1 ) then V.CC.GenderFemale.m_bSelected = true; end
		
		V.CC.BackFace = V.GUI.MakeButton( V.CC.Win, c0 * 0.3, c0 * 0.1, 50, 50, "3" );
		V.CC.BackFace:SetFont( "marlett" );
		V.CC.BackFace.DoClick = function( self ) V.CC.ChangeModel( -1 ) end
		
		V.CC.ForwardFace = V.GUI.MakeButton( V.CC.Win, c0 * 0.7 - 50, c0 * 0.1, 50, 50, "4" );
		V.CC.ForwardFace:SetFont( "marlett" );
		V.CC.ForwardFace.DoClick = function( self ) V.CC.ChangeModel( 1 ) end
		
		V.CC.BackSkin = V.GUI.MakeButton( V.CC.Win, c0 * 0.2, c0 * 0.8, 50, 50, "3" );
		V.CC.BackSkin:SetFont( "marlett" );
		V.CC.BackSkin.DoClick = function( self ) V.CC.ChangeSkin( -1 ) end
		
		V.CC.ForwardSkin = V.GUI.MakeButton( V.CC.Win, c0 * 0.8 - 50, c0 * 0.8, 50, 50, "4" );
		V.CC.ForwardSkin:SetFont( "marlett" );
		V.CC.ForwardSkin.DoClick = function( self ) V.CC.ChangeSkin( 1 ) end
		
		V.CC.Desc = vgui.Create( "DTextEntry", V.CC.Win );
		V.CC.Desc:SetTextColor( Color( 200, 200, 200, 255 ) );
		V.CC.Desc:SetFont( "VCandara30" );
		V.CC.Desc:SetSize( c2 - 10, h - 240 );
		V.CC.Desc:SetPos( c0 + 10, 120 );
		V.CC.Desc:SetText( "This hapless citizen is in over their head." );
		V.CC.Desc:SetEditable( true );
		V.CC.Desc:SetMultiline( true );
		
		table.insert( V.CC.Win.PaintHooks, function( self, w, h )
			
			if( V.CC.Desc ) then
				
				local x, y = V.CC.Desc:GetPos();
				
				local len = string.len( V.CC.Desc:GetValue() );
				local maxlen = V.Config.MaxDescLen;
				
				local col = Color( 255, 255, 255, 255 );
				
				if( len > maxlen ) then
					
					col = Color( 255, 0, 0, 255 );
					
				end
				
				draw.DrawText( tostring( len )  .. "/" .. tostring( maxlen ), "VCandara20", x, y + V.CC.Desc:GetTall() + 10, col, 0 );
				
			end
			
		end );
		
		V.CC.OKBut = V.GUI.MakeButton( V.CC.Win, 0, 0, 100, 50, "Done" );
		V.CC.SetPosBottomright( V.CC.OKBut, 20, 20 );
		V.CC.OKBut:SetFont( "VCandara30" );
		V.CC.OKBut.DoClick = function( self )
			
			local model = V.CC.Model;
			local skin = V.CC.Skin;
			local gender = V.CC.Gender;
			local name = V.CC.NameEntry:GetValue();
			local desc = V.CC.Desc:GetValue();
			
			local res, err = V.GoodChar( model, skin, gender, name, desc );
			
			if( res ) then
				
				if( CurTime() < V.EF.SongEnd and V.EF.CurMusic == "vein/preface.mp3" ) then
					
					V.EF.FadeMusic( 1 );
					
				end
				
				net.Start( "e_cc" );
					net.WriteFloat( model );
					net.WriteFloat( skin );
					net.WriteFloat( gender );
					net.WriteString( name );
					net.WriteString( desc );
				net.SendToServer();
				
				V.CC.KillVGUIComponents();
				
			else
				
				V.CC.ErrText = err;
				V.CC.ErrStartTime = CurTime();
				
			end
			
		end
		
		table.insert( V.CC.Win.PaintHooks, function( self, w, h )
			
			if( CurTime() - V.CC.ErrStartTime < 5 ) then
				
				local timesince = CurTime() - V.CC.ErrStartTime;
				local textalph = 255;
				
				if( timesince < 1 ) then
					
					textalph = timesince * 255;
					
				elseif( timesince > 4 ) then
					
					textalph = ( ( timesince - 5 ) / -1 ) * 255;
					
				end
				
				if( V.CC.OKBut ) then
					
					local x, y = V.CC.OKBut:GetPos();
					local w, h = V.CC.OKBut:GetSize();
					
					surface.SetFont( "VCandara30" );
					local tw, th = surface.GetTextSize( V.CC.ErrText );
					
					surface.SetTextColor( 200, 200, 200, textalph );
					surface.SetTextPos( x - tw - 10, y + h - th );
					surface.DrawText( V.CC.ErrText );
					
				end
				
			end
			
		end );
		
		if( V.CC.Mode == V.CCMODE_CREATE ) then
			
			V.CC.CancelButton = V.GUI.MakeButton( V.CC.Win, c0 + 10, h - 70, 100, 50, "Cancel" );
			V.CC.CancelButton:SetFont( "VCandara30" );
			V.CC.CancelButton.DoClick = function( self )
				
				V.CC.KillVGUIComponents();
				
			end
			
		end
		
	end
	
	if( V.CC.Mode == V.CCMODE_SELECT_N or V.CC.Mode == V.CCMODE_SELECT ) then
		
		V.CC.ModelViewer = vgui.Create( "VCharPanel", V.CC.Win );
		V.CC.ModelViewer:SetSize( c0, c0 );
		V.CC.ModelViewer:SetPos( 0, 0 );
		V.CC.ModelViewer.Entity:SetAngles( Angle() );
		V.CC.ModelViewer:SetFOV( 30 );
		
		local n = 0;
		V.CC.CharButtons = { };
		
		for _, v in pairs( V.CC.Chars ) do
			
			V.CC.CharButtons[n] = V.GUI.MakeButton( V.CC.Win, c0, 20 + 120 * n, c2, 100, v[1] );
			V.CC.CharButtons[n]:SetFont( "VCandara50" );
			
			if( v[5] > 0 ) then
				
				V.CC.CharButtons[n]:SetTextColor( Color( 116, 50, 0, 255 ) );
				
			end
			
			V.CC.CharButtons[n].DoClick = function( self )
				
				net.Start( "e_lc" );
					net.WriteFloat( self.CharID );
				net.SendToServer();
				
				V.CC.KillVGUIComponents();
				
			end
			V.CC.CharButtons[n].OnCursorEntered = function( self )
				
				V.CC.ModelViewer:SetModel( self.Model );
				V.CC.ModelViewer:SetSkin( self.Skin );
				
			end
			
			V.CC.CharButtons[n].CharName = v[1];
			V.CC.CharButtons[n].CharID = v[2];
			V.CC.CharButtons[n].Model = v[3];
			V.CC.CharButtons[n].Skin = v[4];
			
			if( V.CC.CharButtons[n].CharID == V.CurChar ) then
				
				V.CC.CharButtons[n]:SetDisabled( true );
				
			end
			
			n = n + 1;
			
		end
		
		V.CC.ModelViewer:SetModel( V.CC.CharButtons[0].Model );
		V.CC.ModelViewer:SetSkin( V.CC.CharButtons[0].Skin );
		
		if( V.CC.Mode == V.CCMODE_SELECT ) then
			
			V.CC.CancelButton = V.GUI.MakeButton( V.CC.Win, c0 + 10, h - 70, 100, 50, "Cancel" );
			V.CC.CancelButton:SetFont( "VCandara30" );
			V.CC.CancelButton.DoClick = function( self )
				
				V.CC.KillVGUIComponents();
				
			end
			
		end
		
	end
	
	if( V.CC.Mode == V.CCMODE_DELETE ) then
		
		V.CC.ModelViewer = vgui.Create( "VCharPanel", V.CC.Win );
		V.CC.ModelViewer:SetSize( c0, c0 );
		V.CC.ModelViewer:SetPos( 0, 0 );
		V.CC.ModelViewer.Entity:SetAngles( Angle() );
		V.CC.ModelViewer:SetFOV( 30 );
		
		local n = 0;
		V.CC.CharButtons = { };
		
		for _, v in pairs( V.CC.Chars ) do
			
			V.CC.CharButtons[n] = V.GUI.MakeButton( V.CC.Win, c0, 20 + 120 * n, c2, 100, v[1] );
			V.CC.CharButtons[n]:SetFont( "VCandara50" );
			
			if( v[5] > 0 ) then
				
				V.CC.CharButtons[n]:SetTextColor( Color( 116, 50, 0, 255 ) );
				
			end
			
			V.CC.CharButtons[n].DoClick = function( self )
				
				net.Start( "e_dc" );
					net.WriteFloat( self.CharID );
				net.SendToServer();
				
				V.CC.KillVGUIComponents();
				
			end
			V.CC.CharButtons[n].OnCursorEntered = function( self )
				
				V.CC.ModelViewer:SetModel( self.Model );
				V.CC.ModelViewer:SetSkin( self.Skin );
				
			end
			
			V.CC.CharButtons[n].CharName = v[1];
			V.CC.CharButtons[n].CharID = v[2];
			V.CC.CharButtons[n].Model = v[3];
			V.CC.CharButtons[n].Skin = v[4];
			
			if( V.CC.CharButtons[n].CharID == V.CurChar ) then
				
				V.CC.CharButtons[n]:SetDisabled( true );
				
			end
			
			n = n + 1;
			
		end
		
		V.CC.ModelViewer:SetModel( V.CC.CharButtons[0].Model );
		V.CC.ModelViewer:SetSkin( V.CC.CharButtons[0].Skin );
		
		V.CC.CancelButton = V.GUI.MakeButton( V.CC.Win, c0 + 10, h - 70, 100, 50, "Cancel" );
		V.CC.CancelButton:SetFont( "VCandara30" );
		V.CC.CancelButton.DoClick = function( self )
			
			V.CC.KillVGUIComponents();
			
		end
		
	end
	
end

function V.CC.KillVGUIComponents()
	
	if( V.CC.ModelViewer ) then
		
		V.CC.ModelViewer:Remove();
		
	end
	
	if( V.CC.Win ) then
		
		V.CC.Win:Remove();
		V.CC.Win = nil;
		
	end
	
	V.CC.CharButtons = { };
	
	V.CC.CharCreateOpen = false;
	V.BlackScreenDir = -1;
	V.CC.Mode = -1;
	
	if( V.FirstSession and !V.PlayedIntro ) then
		
		V.CreateFancyIntro( 0 );
		V.PlayedIntro = true;
		
	end
	
end