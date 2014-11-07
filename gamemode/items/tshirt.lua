ITEM.ID 			= "tshirt";
ITEM.Name 			= "T-Shirt";
ITEM.Weight 		= 1;
ITEM.Model 			= "models/props/de_tides/Vending_tshirt.mdl";
ITEM.Skin			= 0;

ITEM.OnUse = function( data, ply, n )
	
	if( SERVER ) then return end
	
	local skin = ply:GetSkin();
	
	local function ChangeSkin( i )
		
		skin = skin + i;
		
		local n;
		if( ply:IsFemale() ) then
			n = #V.FemaleValidModels[V.ModelToInt( ply:GetModel(), ply:GetSkin() )].Skin;
		else
			n = #V.MaleValidModels[V.ModelToInt( ply:GetModel(), ply:GetSkin() )].Skin;
		end
		
		if( skin < 1 ) then
			
			if( !ply:IsFemale() ) then
				
				skin = #V.MaleValidModels[V.ModelToInt( ply:GetModel(), ply:GetSkin() )].Skin;
				
			else
				
				skin = #V.FemaleValidModels[V.ModelToInt( ply:GetModel(), ply:GetSkin() )].Skin;
				
			end
			
		elseif( skin > n ) then
			
			skin = 1;
			
		end
		
	end
	
	local c = vgui.Create( "DFrame" );
	c:SetSize( 300, 500 );
	c:Center();
	c:SetTitle( "Change Clothes" );
	c:MakePopup();
	
	c.m = vgui.Create( "VCharPanel", c );
	c.m:SetFOV( 20 );
	c.m:SetPos( 20, 40 );
	c.m:SetSize( 260, 410 );
	c.m:SetModel( ply:GetModel() );
	c.m:SetSkin( skin );
	c.m:StartAnimation( "idle" );
	c.m.Entity:SetAngles( Angle() );
	
	c.l = V.GUI.MakeButton( c, 30, 250, 40, 40, "3" );
	c.l:SetFont( "marlett" );
	c.l.DoClick = function( self ) ChangeSkin( -1 ) c.m:SetSkin( skin ) end
	
	c.r = V.GUI.MakeButton( c, 230, 250, 40, 40, "4" );
	c.r:SetFont( "marlett" );
	c.r.DoClick = function( self ) ChangeSkin( 1 ) c.m:SetSkin( skin ) end
	
	c.b = vgui.Create( "DButton", c );
	c.b:SetPos( 20, 460 );
	c.b:SetSize( 260, 20 );
	c.b:SetText( "Done" );
	c.b:SetFont( "VCandara20" );
	c.b.DoClick = function( b )
		
		net.Start( "e_sc" );
			net.WriteFloat( skin );
		net.SendToServer();
		
		V.I.RemoveItem( ply, "tshirt" );
		
		c:Remove();
		
	end
	
end
