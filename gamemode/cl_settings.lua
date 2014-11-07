V.SET = { };
V.SET.Settings = { };

function V.SET.SaveSettings()
	
	local s = "";
	
	for k, v in pairs( V.SET.Settings ) do
		
		s = s .. tostring( k ) .. "$" .. tostring( v ) .. "\n";
		
	end
	
	local f = file.Open( "Vein/settings/settings.txt", "w", "DATA" );
	if( !f ) then MsgN( "No settings file" ) return end
	
	f:Write( s );
	f:Close();
	
end

function V.SET.LoadSettings()
	
	local f = file.Open( "Vein/settings/settings.txt", "r", "DATA" );
	if( !f ) then MsgN( "No settings file" ) return end
	
	local s = f:Read( f:Size() );
	f:Close();
	
	if( s ) then
		
		local e = string.Explode( "\n", s );
		
		for _, v in pairs( e ) do
			
			if( v != "" ) then
				
				local kv = string.Explode( "$", v );
				V.SET.Settings[kv[1]] = kv[2];
				
			end
			
		end
		
	end
	
end

function V.SET.OpenSettings()
	
	if( V.SET.Window ) then
		
		V.SET.Window:Remove();
		
	end
	
	V.SET.Window = vgui.Create( "DFrame", V.CC.BlackBar );
	V.SET.Window:SetSize( 200, ScrH() - 120 );
	V.SET.Window:SetPos( 0, 110 );
	V.SET.Window:SetTitle( "Settings" );
	V.SET.Window:SetDraggable( false );
	V.SET.Window:ShowCloseButton( false );
	
	V.SET.ColorModText = vgui.Create( "DLabel", V.SET.Window );
	V.SET.ColorModText:SetPos( 10, 40 );
	V.SET.ColorModText:SetFont( "VCandara15" );
	V.SET.ColorModText:SetText( "Colormod Amount" );
	V.SET.ColorModText:SizeToContents();
	
	V.SET.ColorMod = vgui.Create( "VNumSlider", V.SET.Window );
	V.SET.ColorMod:SetPos( 10, 60 );
	V.SET.ColorMod:SetWide( 180 );
	V.SET.ColorMod:SetMin( 0 );
	V.SET.ColorMod:SetMax( 10 );
	V.SET.ColorMod:SetDecimals( 0 );
	V.SET.ColorMod:SizeToContents();
	
	V.SET.ColorMod:SetValue( math.Round( tonumber( V.SET.Settings["colormul"] ) * 10 ) );
	
	V.SET.ColorMod.ValueChanged = function( self, val )
		
		V.SET.Settings["colormul"] = tostring( val / 10 );
		V.SET.SaveSettings();
		
	end
	
	V.SET.Music = vgui.Create( "DCheckBoxLabel", V.SET.Window );
	V.SET.Music:SetPos( 10, 100 );
	V.SET.Music:SetText( "Play music" );
	V.SET.Music:SetValue( ( V.SET.Settings["music"] == "1" ) and 1 or 0 );
	V.SET.Music:SizeToContents();
	V.SET.Music.OnChange = function( self, val )
		
		V.SET.Settings["music"] = tobool( val ) and "1" or "0";
		V.SET.SaveSettings();
		
	end
	
	V.SET.FancyRain = vgui.Create( "DCheckBoxLabel", V.SET.Window );
	V.SET.FancyRain:SetPos( 10, 120 );
	V.SET.FancyRain:SetText( "High-quality rain" );
	V.SET.FancyRain:SetValue( ( V.SET.Settings["fancyrain"] == "1" ) and 1 or 0 );
	V.SET.FancyRain:SizeToContents();
	V.SET.FancyRain.OnChange = function( self, val )
		
		V.SET.Settings["fancyrain"] = tobool( val ) and "1" or "0";
		V.SET.SaveSettings();
		
	end
	
end