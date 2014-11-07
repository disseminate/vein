V.DEV = { };

V.DEV.Laser = Material( "cable/redlaser" );

V.DEV.RenderIntroCam = false;
V.DEV.IntroCamSegments = 30;

function V.DEV.RenderIntro()
	
	if( V.DEV.RenderIntroCam ) then
		
		if( V.FancyIntroSpline ) then
			
			local lastv = V.FancyIntroSpline[1][1];
			
			for i = 1, V.DEV.IntroCamSegments do
				
				local perc = i / V.DEV.IntroCamSegments;
				
				local sp = V.FancyIntroSpline;
				
				local vf = V.BSplinePoint( perc, sp[1] );
				
				render.SetMaterial( V.DEV.Laser );
				render.DrawBeam( lastv, vf, 5, 1, 1, Color( 255, 255, 255, 255 ) );
				
				lastv = vf;
				
			end
			
		end
		
	end
	
end

V.DEV.BedDev = false;

function V.DEV.ToggleBedDev()
	
	V.DEV.BedDev = true;
	
end

function V.DEV.EyePos()
	
	local p = LocalPlayer():EyePos();
	local a = LocalPlayer():EyeAngles();
	
	MsgN( p );
	MsgN( a );
	
end
concommand.Add( "dev_eyepos", V.DEV.EyePos );

function V.DEV.ChairEditor()
	
	if( LocalPlayer().Chair and LocalPlayer().Chair:IsValid() ) then
		
		V.DEV.ChairWindow = vgui.Create( "DFrame" );
		V.DEV.ChairWindow:SetSize( 200, 600 );
		V.DEV.ChairWindow:SetPos( 0, 100 );
		V.DEV.ChairWindow:SetTitle( "Chair Editor" );
		V.DEV.ChairWindow:MakePopup();
		V.DEV.ChairWindow:ShowCloseButton( true );
		
		local model = LocalPlayer().Chair:GetModel();
		
		if( !V.ME.ChairData[model] ) then
			
			V.ME.ChairData[model] = { Vector(), Angle() };
			
		end
		
		local t = vgui.Create( "DLabel", V.DEV.ChairWindow );
		t:SetPos( 10, 30 );
		t:SetFont( "VCandara15" );
		t:SetText( "Position - X" );
		t:SizeToContents();
		
		V.DEV.ChairX = vgui.Create( "VNumSlider", V.DEV.ChairWindow );
		V.DEV.ChairX:SetPos( 10, 50 );
		V.DEV.ChairX:SetWide( 180 );
		V.DEV.ChairX:SetMin( -30 );
		V.DEV.ChairX:SetMax( 30 );
		V.DEV.ChairX:SetDecimals( 0 );
		V.DEV.ChairX:SizeToContents();
		
		if( V.ME.ChairData[model] ) then
			V.DEV.ChairX:SetValue( V.ME.ChairData[model][1].x );
		end
		
		V.DEV.ChairX.ValueChanged = function( self, val )
			
			local cd = V.ME.ChairData[model];
			V.ME.ChairData[model] = { Vector( val, cd[1].y, cd[1].z ), cd[2] };
			
		end
		
		local t = vgui.Create( "DLabel", V.DEV.ChairWindow );
		t:SetPos( 10, 80 );
		t:SetFont( "VCandara15" );
		t:SetText( "Position - Y" );
		t:SizeToContents();
		
		V.DEV.ChairY = vgui.Create( "VNumSlider", V.DEV.ChairWindow );
		V.DEV.ChairY:SetPos( 10, 100 );
		V.DEV.ChairY:SetWide( 180 );
		V.DEV.ChairY:SetMin( -30 );
		V.DEV.ChairY:SetMax( 30 );
		V.DEV.ChairY:SetDecimals( 0 );
		V.DEV.ChairY:SizeToContents();
		
		if( V.ME.ChairData[model] ) then
			V.DEV.ChairY:SetValue( V.ME.ChairData[model][1].y );
		end
		
		V.DEV.ChairY.ValueChanged = function( self, val )
			
			local cd = V.ME.ChairData[model];
			V.ME.ChairData[model] = { Vector( cd[1].x, val, cd[1].z ), cd[2] };
			
		end
		
		local t = vgui.Create( "DLabel", V.DEV.ChairWindow );
		t:SetPos( 10, 130 );
		t:SetFont( "VCandara15" );
		t:SetText( "Position - Z" );
		t:SizeToContents();
		
		V.DEV.ChairZ = vgui.Create( "VNumSlider", V.DEV.ChairWindow );
		V.DEV.ChairZ:SetPos( 10, 150 );
		V.DEV.ChairZ:SetWide( 180 );
		V.DEV.ChairZ:SetMin( -30 );
		V.DEV.ChairZ:SetMax( 30 );
		V.DEV.ChairZ:SetDecimals( 0 );
		V.DEV.ChairZ:SizeToContents();
		
		if( V.ME.ChairData[model] ) then
			V.DEV.ChairZ:SetValue( V.ME.ChairData[model][1].z );
		end
		
		V.DEV.ChairZ.ValueChanged = function( self, val )
			
			local cd = V.ME.ChairData[model];
			V.ME.ChairData[model] = { Vector( cd[1].x, cd[1].y, val ), cd[2] };
			
		end
		
		local t = vgui.Create( "DLabel", V.DEV.ChairWindow );
		t:SetPos( 10, 180 );
		t:SetFont( "VCandara15" );
		t:SetText( "Angle - Pan" );
		t:SizeToContents();
		
		V.DEV.ChairAP = vgui.Create( "VNumSlider", V.DEV.ChairWindow );
		V.DEV.ChairAP:SetPos( 10, 200 );
		V.DEV.ChairAP:SetWide( 180 );
		V.DEV.ChairAP:SetMin( -180 );
		V.DEV.ChairAP:SetMax( 180 );
		V.DEV.ChairAP:SetDecimals( 0 );
		V.DEV.ChairAP:SizeToContents();
		
		if( V.ME.ChairData[model] ) then
			V.DEV.ChairAP:SetValue( V.ME.ChairData[model][2].p );
		end
		
		V.DEV.ChairAP.ValueChanged = function( self, val )
			
			local cd = V.ME.ChairData[model];
			V.ME.ChairData[model] = { cd[1], Angle( val, cd[2].y, cd[2].r ) };
			
		end
		
		local t = vgui.Create( "DLabel", V.DEV.ChairWindow );
		t:SetPos( 10, 230 );
		t:SetFont( "VCandara15" );
		t:SetText( "Angle - Yaw" );
		t:SizeToContents();
		
		V.DEV.ChairAY = vgui.Create( "VNumSlider", V.DEV.ChairWindow );
		V.DEV.ChairAY:SetPos( 10, 250 );
		V.DEV.ChairAY:SetWide( 180 );
		V.DEV.ChairAY:SetMin( -180 );
		V.DEV.ChairAY:SetMax( 180 );
		V.DEV.ChairAY:SetDecimals( 0 );
		V.DEV.ChairAY:SizeToContents();
		
		if( V.ME.ChairData[model] ) then
			V.DEV.ChairAY:SetValue( V.ME.ChairData[model][2].y );
		end
		
		V.DEV.ChairAY.ValueChanged = function( self, val )
			
			local cd = V.ME.ChairData[model];
			V.ME.ChairData[model] = { cd[1], Angle( cd[2].p, val, cd[2].r ) };
			
		end
		
		local t = vgui.Create( "DLabel", V.DEV.ChairWindow );
		t:SetPos( 10, 280 );
		t:SetFont( "VCandara15" );
		t:SetText( "Angle - Roll" );
		t:SizeToContents();
		
		V.DEV.ChairAR = vgui.Create( "VNumSlider", V.DEV.ChairWindow );
		V.DEV.ChairAR:SetPos( 10, 300 );
		V.DEV.ChairAR:SetWide( 180 );
		V.DEV.ChairAR:SetMin( -180 );
		V.DEV.ChairAR:SetMax( 180 );
		V.DEV.ChairAR:SetDecimals( 0 );
		V.DEV.ChairAR:SizeToContents();
		
		if( V.ME.ChairData[model] ) then
			V.DEV.ChairAR:SetValue( V.ME.ChairData[model][2].r );
		end
		
		V.DEV.ChairAR.ValueChanged = function( self, val )
			
			local cd = V.ME.ChairData[model];
			V.ME.ChairData[model] = { cd[1], Angle( cd[2].p, cd[2].y, val ) };
			
		end
		
		V.DEV.ChairCopy = vgui.Create( "DButton", V.DEV.ChairWindow );
		V.DEV.ChairCopy:SetPos( 10, 330 );
		V.DEV.ChairCopy:SetSize( 180, 40 );
		V.DEV.ChairCopy:SetText( "Copy to Clipboard" );
		V.DEV.ChairCopy:SetFont( "VCandara20" );
		V.DEV.ChairCopy.DoClick = function( self )
			
			local cdata = V.ME.ChairData[model];
			
			local text = "V.ME.AddChairData( \"" .. model .. "\", Vector( " .. tostring( cdata[1].x ) .. ", " .. tostring( cdata[1].y ) .. ", " .. tostring( cdata[1].z ) .. " ), Angle( " .. tostring( cdata[2].p ) .. ", " .. tostring( cdata[2].y ) .. ", " .. tostring( cdata[2].r ) .. " ) );"
			SetClipboardText( text );
			
		end
		
	end
	
end
concommand.Add( "dev_chairedit", V.DEV.ChairEditor );
