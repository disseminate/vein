V.INV = { };
V.INV.PanelContents = { };
V.INV.FrameOpen = false;

function V.INV.GetTrace()
	
	if( CLIENT ) then
		
		local trace = { };
		trace.start = LocalPlayer():GetShootPos();
		trace.endpos = trace.start + gui.ScreenToVector( gui.MousePos() ) * 32768;
		trace.filter = { LocalPlayer() };
		
		for _, v in pairs( ents.GetAll() ) do
			
			if( v:GetClass() != "v_prop" and !v:IsPlayer() ) then
				
				table.insert( trace.filter, v );
				
			end
			
		end
		
		local tr = util.TraceLine( trace );
		return tr;
		
	end
	
	return { };
	
end

function dragndrop.HandleDroppedInGame()

	local panel = vgui.GetHoveredPanel()
	if ( !IsValid( panel ) ) then return end
	if ( panel:GetClassName() != "CGModBase" ) then return end
	
	local tr = V.INV.GetTrace();
	
	if( tr.Entity and tr.Entity:IsValid() ) then
		
		local panel = dragndrop.GetDroppable()[1];
		
		local id = panel.ItemID;
		
		local d = LocalPlayer():GetPos():Distance( tr.Entity:GetPos() );
		
		if( d <= 256 ) then
			
			net.Start( "e_trade" );
				net.WriteEntity( tr.Entity );
				net.WriteString( panel:GetItem() );
			net.SendToServer();
			
		end
		
	end
	
end

function V.INV.PreDrawHalos()
	
	local panel = vgui.GetHoveredPanel()
	if ( !IsValid( panel ) ) then return end
	if ( panel:GetClassName() != "CGModBase" ) then return end
	if( !dragndrop.IsDragging() ) then return end
	
	local tr = V.INV.GetTrace();
	
	if( tr.Entity and tr.Entity:IsValid() ) then
		
		local d = LocalPlayer():GetPos():Distance( tr.Entity:GetPos() );
		
		if( d <= 256 ) then
			
			halo.Add( { tr.Entity }, Color( 255, 255, 255, 255 ), 2, 2, 2, true, false );
			
		end
		
	end
	
end

function V.INV.ItemPressed( self )
	
	local v = V.I.GetItemByID( self:GetItem() );
	
	local n = v.UseModes;
	
	if( #n == 1 ) then
		
		net.Start( "e_ui" );
			net.WriteString( self:GetItem() );
			net.WriteString( n[1] );
		net.SendToServer();
		
		V.I.UseItem( LocalPlayer(), self:GetItem(), n[1] );
		
		V.INV.RebuildInventory();
		
	else
		
		local m = DermaMenu();
		
		for k, v in pairs( n ) do
			
			local panel = m:AddOption( v, function()
				
				net.Start( "e_ui" );
					net.WriteString( self:GetItem() );
					net.WriteString( v );
				net.SendToServer();
				
				V.I.UseItem( LocalPlayer(), self:GetItem(), v );
				
				V.INV.RebuildInventory();
				
			end );
			panel:SetTextColor( Color( 255, 255, 255, 255 ) );
			panel:SetFont( "VCandara15" );
			
		end
		
		m:Open();
		
	end
	
end

function V.INV.CreatePanel()
	
	if( V.CC.CharCreateOpen ) then return end
	if( V.INV.FrameOpen ) then return end
	if( LocalPlayer().Asleep ) then return end
	if( !LocalPlayer():Alive() ) then return end
	
	V.INV.FrameOpen = true;
	
	V.INV.MainBar = vgui.Create( "EditablePanel" );
	V.INV.MainBar:SetSize( 100, ScrH() );
	V.INV.MainBar:SetPos( ScrW() - 100, 0 );
	V.INV.MainBar.Paint = function( self )
		
		surface.SetDrawColor( 0, 0, 0, 220 );
		surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() );
		
	end
	V.INV.MainBar:MakePopup();
	
	V.INV.WeightBar = vgui.Create( "VProgressBar", V.INV.MainBar );
	V.INV.WeightBar:SetPos( 10, ScrH() - 30 );
	V.INV.WeightBar:SetSize( 80, 20 );
	V.INV.WeightBar:SetBounds( 0, 250 );
	V.INV.WeightBar:SetValuePerc( V.I.GetInvWeightFrac( LocalPlayer() ) );
	V.INV.WeightBar:SetText( tostring( V.I.GetWeight( LocalPlayer() ) ) .. "/250" );
	V.INV.WeightBar:SetTextColor( V.I.GetWeight( LocalPlayer() ) > 250 and Color( 200, 0, 0, 255 ) or Color( 255, 255, 255, 255 ) );
	
	V.INV.SubPanel = vgui.Create( "DScrollPanel", V.INV.MainBar );
	V.INV.SubPanel:Dock( FILL );
	V.INV.SubPanel:DockMargin( 0, 0, 0, 100 );
	V.INV.SubPanel:Receiver( "inventorysub", function( receiver, droppable, bDoDrop, command, x, y )
		
		if( bDoDrop and !table.HasValue( V.INV.PanelContents, droppable[1] ) ) then
			
			V.INV.SubPanel:AddItem( droppable[1] );
			table.insert( V.INV.PanelContents, droppable[1] );
			
			for i = 0, 3 do
				
				if( droppable[1] == V.INV.CraftSlots[i].Item ) then
					
					V.INV.CraftSlots[i].Item = nil;
					
				end
				
			end
			
			droppable[1]:SetButton( V.INV.ItemPressed );
			
			V.INV.RebuildInventory();
			
		end
		
	end );
	
	V.INV.CraftPanel = vgui.Create( "DFrame" );
	V.INV.CraftPanel:SetSize( 376, 114 );
	V.INV.CraftPanel:SetPos( ScrW() - 100 - 10 - 376, ScrH() - 114 );
	V.INV.CraftPanel:SetTitle( "Crafting" );
	V.INV.CraftPanel:ShowCloseButton( false );
	V.INV.CraftPanel:SetDraggable( false );
	
	V.INV.CraftSlots = { };
	
	for i = 0, 3 do
		
		V.INV.CraftSlots[i] = vgui.Create( "VInventoryItemSlot", V.INV.CraftPanel );
		V.INV.CraftSlots[i]:SetPos( 10 + 74 * i, 40 );
		V.INV.CraftSlots[i]:SetSize( 64, 64 );
		V.INV.CraftSlots[i]:Receiver( "craft", function( receiver, droppable, bDoDrop, command, x, y )
			
			if( bDoDrop and !receiver.Item ) then
				
				for i = 0, 3 do
					
					if( droppable[1] == V.INV.CraftSlots[i].Item ) then
						
						V.INV.CraftSlots[i].Item = nil;
						
					end
					
				end
				
				droppable[1]:SetParent( receiver );
				droppable[1]:SetPos( 0, 0 );
				droppable[1]:SetButton( function() end );
				
				for k, v in pairs( V.INV.PanelContents ) do
					
					if( v == droppable[1] ) then
						
						table.remove( V.INV.PanelContents, k );
						
					end
					
				end
				
				receiver.Item = droppable[1];
				
				V.INV.RebuildInventory();
				
			end
			
		end );
		
	end
	
	V.INV.CraftBut = vgui.Create( "DButton", V.INV.CraftPanel );
	V.INV.CraftBut:SetPos( 306, 40 );
	V.INV.CraftBut:SetSize( 60, 64 );
	V.INV.CraftBut:SetText( "OK" );
	V.INV.CraftBut:SetFont( "VCandara30" );
	V.INV.CraftBut.DoClick = function( self )
		
		local ids = { };
		
		for i = 0, 3 do
			
			local item = V.INV.CraftSlots[i].Item;
			
			if( item ) then
				
				table.insert( ids, item:GetItem() );
				
			end
			
		end
		
		local craft, used, amt = V.I.CanCraftItem( ids );
		
		if( craft ) then
			
			net.Start( "e_gic" );
				net.WriteTable( ids );
			net.SendToServer();
			
			V.I.GiveItem( LocalPlayer(), craft, amt );
			
			for _, v in pairs( used ) do
				
				V.I.RemoveItem( LocalPlayer(), v );
				
			end
			
		end
		
		for i = 0, 3 do
			
			local item = V.INV.CraftSlots[i].Item;
			
			if( item ) then
				
				V.INV.SubPanel:AddItem( item );
				table.insert( V.INV.PanelContents, item );
				item:SetButton( V.INV.ItemPressed );
				
				V.INV.CraftSlots[i].Item = nil;
				
			end
			
		end
		
		V.INV.RebuildInventory();
		
	end
	
	V.INV.GarbagePanel = vgui.Create( "DFrame" );
	V.INV.GarbagePanel:SetSize( 158, 114 );
	V.INV.GarbagePanel:SetPos( ScrW() - 100 - 10 - 376 - 10 - 158, ScrH() - 114 );
	V.INV.GarbagePanel:SetTitle( "Garbage" );
	V.INV.GarbagePanel:ShowCloseButton( false );
	V.INV.GarbagePanel:SetDraggable( false );
	
	V.INV.GarbageSlot = vgui.Create( "VInventoryItemSlot", V.INV.GarbagePanel );
	V.INV.GarbageSlot:SetPos( 10, 40 );
	V.INV.GarbageSlot:SetSize( 138, 64 );
	V.INV.GarbageSlot:Receiver( "garbage", function( receiver, droppable, bDoDrop, command, x, y )
		
		if( bDoDrop ) then
			
			net.Start( "e_ki" );
				net.WriteString( droppable[1]:GetItem() );
			net.SendToServer();
			
			V.I.KillItem( LocalPlayer(), droppable[1]:GetItem() );
			
			V.INV.RebuildInventory();
			
		end
		
	end );
	
	V.I.CheckInvent( LocalPlayer() );
	
	V.INV.BuildInventory();
	V.INV.RebuildInventory();
	
end

function V.INV.BuildInventory()
	
	V.INV.PanelContents = { };
	
	local n = 0;
	
	for k, v in pairs( LocalPlayer().Inventory ) do
		
		local item = V.I.GetItemByID( v.ID );
		
		local mdl = vgui.Create( "VInventoryItem" );
		V.INV.SubPanel:AddItem( mdl );
		mdl:SetPos( 10, 10 + 74 * n );
		mdl:SetModel( item.Model );
		mdl:SetSkin( item.Skin );
		mdl:SetItem( v.ID );
		mdl.id = k;
		mdl.n = n;
		mdl.mdl = item.Model;
		mdl.skin = item.Skin;
		if( v.Num > 1 ) then
			mdl:SetCornerText( "x" .. tostring( v.Num ) );
		end
		mdl:Droppable( "inventorysub" );
		mdl:Droppable( "craft" );
		mdl:Droppable( "garbage" );
		
		mdl:SetButton( V.INV.ItemPressed );
		
		table.insert( V.INV.PanelContents, mdl );
		
		n = n + 1;
		
	end
	
end

function V.INV.RebuildInventory()
	
	for k, v in pairs( V.INV.PanelContents ) do
		
		local has = false;
		
		for m, n in pairs( LocalPlayer().Inventory ) do
			
			if( n.ID == v:GetItem() ) then
				
				has = true;
				
			end
			
		end
		
		if( !has ) then
			
			v:Remove();
			table.remove( V.INV.PanelContents, k );
			
		end
		
	end
	
	for m, n in pairs( LocalPlayer().Inventory ) do
		
		local has = false;
		
		for k, v in pairs( V.INV.PanelContents ) do
			
			if( n.ID == v:GetItem() ) then
				
				has = true;
				v.id = m; -- Update inventory IDs before doing anything to do with inventory!
				
			end
			
		end
		
		for i = 0, 3 do
			
			if( V.INV.CraftSlots[i].Item ) then
				
				if( V.INV.CraftSlots[i].Item:GetItem() == n.ID ) then
					
					has = true;
					V.INV.CraftSlots[i].Item.id = m;
					
				end
				
			end
			
		end
		
		if( !has ) then
			
			local item = V.I.GetItemByID( n.ID );
			
			local mdl = vgui.Create( "VInventoryItem" );
			V.INV.SubPanel:AddItem( mdl );
			mdl:SetModel( item.Model );
			mdl:SetSkin( item.Skin );
			mdl:SetItem( n.ID );
			mdl.id = k;
			mdl.mdl = item.Model;
			mdl.skin = item.Skin;
			mdl:Droppable( "inventorysub" );
			mdl:Droppable( "craft" );
			mdl:Droppable( "garbage" );
			
			mdl:SetButton( V.INV.ItemPressed );
			
			table.insert( V.INV.PanelContents, mdl );
			
		end
		
	end
	
	local n = 0;
	
	for k, v in pairs( V.INV.PanelContents ) do
		
		v:SetPos( 10, 10 + 74 * n );
		v.n = n;
		
		if( LocalPlayer().Inventory[v.id] and LocalPlayer().Inventory[v.id].Num > 1 ) then
			
			v:SetCornerText( "x" .. tostring( LocalPlayer().Inventory[v.id].Num ) );
			
		else
			
			v:SetCornerText( "" );
			
		end
		
		n = n + 1;
		
	end
	
	V.INV.SubPanel:PerformLayout();
	V.INV.WeightBar:SetValuePerc( V.I.GetInvWeightFrac( LocalPlayer() ) );
	V.INV.WeightBar:SetText( tostring( V.I.GetWeight( LocalPlayer() ) ) .. "/250" );
	V.INV.WeightBar:SetTextColor( V.I.GetWeight( LocalPlayer() ) > 250 and Color( 255, 0, 0, 255 ) or Color( 255, 255, 255, 255 ) );
	
end

function V.INV.ClosePanel()
	
	if( !V.INV.MainBar ) then return end
	
	V.INV.MainBar:Remove();
	V.INV.WeightBar:Remove();
	V.INV.SubPanel:Remove();
	V.INV.CraftPanel:Remove();
	V.INV.GarbagePanel:Remove();
	
	for _, v in pairs( V.INV.PanelContents ) do
		
		v:Remove();
		
	end
	
	V.INV.PanelContents = { };
	
	V.INV.FrameOpen = false;
	
	V.INV.MainBar = nil;
	
	dragndrop.Clear();
	CloseDermaMenus();
	
end