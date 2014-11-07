V.GUI = { };

function GM:ForceDermaSkin()
	
	return "Vein";
	
end

function V.GUI.MakeButton( parent, x, y, w, h, text )
	
	local but = vgui.Create( "DButton", parent );
	but:SetPos( x, y );
	but:SetSize( w, h );
	but:SetText( text );
	return but;
	
end