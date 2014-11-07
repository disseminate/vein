local meta = FindMetaTable( "Player" );

function meta:HasWeapon( class )
	
	local tab = self:GetWeapons();
	
	for _, v in pairs( tab ) do
		
		if( v:GetClass() == class ) then
			
			return true;
			
		end
		
	end
	
	return false;
	
end

function meta:GetWeapon( class )
	
	local tab = self:GetWeapons();
	
	for _, v in pairs( tab ) do
		
		if( v:GetClass() == class ) then
			
			return v;
			
		end
		
	end
	
end

function nNoMesh( len )
	
	local c = vgui.Create( "DFrame" );
	c:SetSize( 500, 250 );
	c:Center();
	c:SetTitle( "No Navmesh!" );
	c:MakePopup();
	
	local formatted = V.CB.FormatLine( "In order to have zombies spawn properly, you need to generate a navmesh for this map.\n\nAim at the ground, and in console, type 'rpa nav_addseed'. You should add a navseed in every closed-off or seperated area you want zombies to spawn in. Once this is done, enter 'rpa nav_generate' and wait for the flooding to finish.", "VCandara20", 480 );
	
	local a = vgui.Create( "DLabel", c );
	a:SetPos( 10, 35 );
	a:SetFont( "VCandara20" );
	a:SetText( formatted );
	a:SizeToContents();
	
end
net.Receive( "nNoMesh", nNoMesh );
