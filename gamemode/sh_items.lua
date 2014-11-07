V.I = { };
V.I.Items = { };

function V.I.ParseItems()
	
	local files = file.Find( GAMEMODE.FolderName .. "/gamemode/items/*.lua", "LUA", "namedesc" );
	
	for _, v in pairs( files ) do
		
		if( SERVER ) then
			
			AddCSLuaFile( GAMEMODE.FolderName .. "/gamemode/items/" .. v );
			
		end
		
		ITEM 				= { };
		ITEM.ID 			= "UNFORMATTED";
		ITEM.Name 			= "UNFORMATTED";
		ITEM.Weight 		= 0;
		ITEM.Model 			= "models/Kleiner.mdl";
		ITEM.Skin			= 0;
		ITEM.Stackable		= false;
		ITEM.RemoveOnUse	= false;
		ITEM.WeaponClass	= "";
		ITEM.Book			= "";
		ITEM.Sound			= "";
		ITEM.UseModes		= { "Use" };
		
		include( GAMEMODE.FolderName .. "/gamemode/items/" .. v );
		
		if( string.len( ITEM.WeaponClass ) > 0 ) then
			
			ITEM.OnUse = function( data, ply, n )
				
				if( ply:HasWeapon( data.WeaponClass ) ) then
					
					ply:GetWeapon( data.WeaponClass ):HolsterAnim();
					
				elseif( SERVER ) then
					
					V.I.QueueWeapon( ply, data.WeaponClass );
					
				end
				
			end

			ITEM.OnDestroy = function( data, ply, n )
				
				if( n <= 1 and ply:HasWeapon( data.WeaponClass ) ) then
					
					ply:GetWeapon( data.WeaponClass ):HolsterAnim();
					
				end
				
			end
			
			if( weapons.Get( ITEM.WeaponClass ) ) then
				
				ITEM.Model = weapons.Get( ITEM.WeaponClass ).WorldModel;
				
			else
				
				MsgN( ITEM.WeaponClass )
				
			end
			
		end
		
		if( string.len( ITEM.Book ) > 0 ) then
			
			ITEM.OnUse = function( data, ply, n )
				
				if( CLIENT ) then
					
					V.I.OpenBook( data.Book );
					
				end
				
			end
			
		end
		
		table.insert( V.I.Items, ITEM );
		
		ITEM = nil;
		
	end
	
end

function V.I.InitPostEntity()	
	
	V.I.ParseItems();
	
	if( CLIENT ) then
		
		for _, v in pairs( V.I.Items ) do
			
			util.PrecacheModel( v.Model );
			
		end
		
	end
	
end

V.I.ContainerPresets = { };
V.I.ContainerPresetItems = { };

V.I.ContainerPresets[0] = { "None", 0 };

function V.I.AddContainerType( id, name, n )
	
	V.I.ContainerPresets[id] = { name, n };
	V.I.ContainerPresetItems[id] = { };
	
	V.I.ContainerInternal = id;
	
end

function V.I.AddContainerItem( item, rarity )
	
	table.insert( V.I.ContainerPresetItems[V.I.ContainerInternal], { item, rarity } );
	
end

V.I.Books = { };

function V.I.AddBook( title )
	
	V.I.Books[title] = { };
	
end

function V.I.AddChapter( title, chap, text )
	
	V.I.Books[title][chap] = text;
	
end

function V.I.ContainerThink()
	
	for _, v in pairs( ents.FindByClass( "v_prop" ) ) do
		
		if( v:GetContainer() > 0 ) then
			
			if( CurTime() >= v.NextContainerUpdate ) then
				
				v.NextContainerUpdate = CurTime() + V.ContainerRefreshRate;
				V.I.ContainerReset( v );
				
			end
			
		end
		
	end
	
end

function V.I.ContainerReset( ent )
	
	if( ent:GetContainer() > 0 ) then
		
		V.I.CheckInvent( ent );
		
		if( #ent.Inventory > 0 ) then return end
		
		local preset = V.I.ContainerPresets[ent:GetContainer()];
		local items = V.I.ContainerPresetItems[ent:GetContainer()];
		
		for i = 1, preset[2] do
			
			local a = table.Random( items );
			local rarity = a[2];
			local c = math.random( 1, rarity );
			
			if( c == rarity ) then
				
				V.I.GiveItem( ent, a[1], 1 );
				
			end
			
		end
		
	end
	
end

function V.I.GetItemByID( id )
	
	for _, v in pairs( V.I.Items ) do
		
		if( v.ID == id ) then
			
			return v;
			
		end
		
	end
	
end

function V.I.NumItemByID( id )
	
	local n = 0;
	
	for _, v in pairs( V.I.Items ) do
		
		if( v.ID == id ) then
			
			n = n + 1;
			
		end
		
	end
	
	return n;
	
end

function V.I.CheckInvent( ply )
	
	if( !ply.Inventory ) then ply.Inventory = { }; end
	
end

function V.I.ClearInvent( ply )
	
	ply.Inventory = { };
	
	if( SERVER ) then
		
		net.Start( "nClearInvent" );
		net.Send( ply );
		
	end
	
end

function V.I.GetNum( ply )
	
	local n = 0;
	
	for k, v in pairs( ply.Inventory or { } ) do
		
		n = n + v.Num;
		
	end
	
	return n;
	
end

function V.I.GetWeight( ply )
	
	local w = 0;
	
	for k, v in pairs( ply.Inventory or { } ) do
		
		w = w + V.I.GetItemByID( v.ID ).Weight * v.Num;
		
	end
	
	return w;
	
end

function V.I.GetInvWeightFrac( ply )
	
	local w = V.I.GetWeight( ply );
	local perc = math.Clamp( w / 250, 0, 0.999 );
	return perc;
	
end

function V.I.HasItem( ply, id )
	
	V.I.CheckInvent( ply );
	
	for k, v in pairs( ply.Inventory ) do
		
		if( v.ID == id ) then
			
			return k;
			
		end
		
	end
	
	return false;
	
end

function V.I.RemoveIndex( ply, id )
	
	V.I.CheckInvent( ply );
	table.remove( ply.Inventory, id );
	
end

if( CLIENT ) then
	
	function V.I.PlaySound( id )
		
		local item = V.I.GetItemByID( id );
		
		if( string.len( item.Sound ) > 0 ) then
			
			surface.PlaySound( item.Sound );
			
		end
		
	end
	
	function V.I.GiveItem( ply, id, num )
		
		V.I.CheckInvent( ply );
		
		local n = V.I.HasItem( ply, id );
		
		if( n and V.I.GetItemByID( id ).Stackable ) then
			
			ply.Inventory[n].Num = ply.Inventory[n].Num + num or 1;
			
		else
			
			table.insert( ply.Inventory, { ID = id, Num = num or 1 } );
			util.PrecacheModel( V.I.GetItemByID( id ).Model );
			
		end
		
	end
	
	function V.I.RemoveItem( ply, id, num )
		
		V.I.CheckInvent( ply );
		
		local n = V.I.HasItem( ply, id );
		
		if( n ) then
			
			ply.Inventory[n].Num = ply.Inventory[n].Num - ( num or 1 );
			
			if( ply.Inventory[n].Num <= 0 ) then
				
				V.I.RemoveIndex( ply, n );
				
			end
			
		end
		
		if( V.INV.MainBar ) then
			
			V.INV.RebuildInventory();
			
		end
		
	end
	
	function V.I.UseItem( ply, id, mode )
		
		if( ply.CharCreate ) then return end
		if( ply.Asleep ) then return end
		if( !ply:Alive() ) then return end
		
		V.I.CheckInvent( ply );
		
		local n = V.I.HasItem( ply, id );
		
		if( n and V.I.GetItemByID( id ).OnUse ) then
			
			V.I.GetItemByID( id ).OnUse( V.I.GetItemByID( id ), ply, ply.Inventory[n].Num, mode );
			
			if( V.I.GetItemByID( id ).UseSounds and SERVER ) then
				
				ply:EmitSound( Sound( table.Random( V.I.GetItemByID( id ).UseSounds ) ) );
				
			end
			
			if( V.I.GetItemByID( id ).RemoveOnUse ) then
				
				V.I.RemoveItem( ply, id );
				
			end
			
		end
		
		if( V.INV.MainBar ) then
			
			V.INV.RebuildInventory();
			
		end
		
	end
	
	function V.I.KillItem( ply, id )
		
		V.I.CheckInvent( ply );
		
		local n = V.I.HasItem( ply, id );
		
		if( n ) then
			
			if( V.I.GetItemByID( id ).OnDestroy ) then
				
				V.I.GetItemByID( id ).OnDestroy( V.I.GetItemByID( id ), ply, V.I.NumItemByID( id ) );
				
			end
			
			V.I.RemoveItem( ply, id );
			
		end
		
		if( V.INV.MainBar ) then
			
			V.INV.RebuildInventory();
			
		end
		
	end
	
	function V.I.ClearInventNet( len )
		
		V.I.ClearInvent( LocalPlayer() );
		
	end
	net.Receive( "nClearInvent", V.I.ClearInventNet );

	function V.I.GiveItemNet( len )
		
		local id = net.ReadString();
		local num = net.ReadFloat();
		local s = net.ReadFloat();
		
		V.I.GiveItem( LocalPlayer(), id, num );
		
		if( s == 1 ) then
			
			V.I.PlaySound( id );
			
		end
		
	end
	net.Receive( "nItemGive", V.I.GiveItemNet );
	
	function V.I.RemoveItemNet( len )
		
		local id = net.ReadString();
		local num = net.ReadFloat();
		
		V.I.RemoveItem( LocalPlayer(), id, num );
		
	end
	net.Receive( "nItemRemove", V.I.RemoveItemNet );
	
	function V.I.UseItemNet( len )
		
		local id = net.ReadString();
		
		V.I.UseItem( LocalPlayer(), id );
		
	end
	net.Receive( "nItemUse", V.I.UseItemNet );
	
	function V.I.KillItemNet( len )
		
		local id = net.ReadString();
		
		V.I.KillItem( LocalPlayer(), id );
		
	end
	net.Receive( "nItemKill", V.I.KillItemNet );
	
	function V.I.ContainerOpen( len )
		
		local ent = net.ReadEntity();
		local pre = net.ReadFloat();
		local inv = net.ReadTable();
		local open = net.ReadFloat();
		
		ent.Inventory = inv;
		ent.Container = pre;
		
		if( open == 1 ) then
			
			V.I.OpenContainer( ent );
			
		end
		
	end
	net.Receive( "nContainerOpen", V.I.ContainerOpen );
	
	function V.I.OpenContainer( ent )
		
		local w = math.max( ( 64 * #ent.Inventory + 10 ) + 10, 276 );
		
		local h = 104;
		
		V.I.ContainerWin = vgui.Create( "DFrame" );
		V.I.ContainerWin:SetSize( w, h );
		V.I.ContainerWin:Center();
		V.I.ContainerWin:SetTitle( "Contents" );
		V.I.ContainerWin:MakePopup();
		V.I.ContainerWin:ShowCloseButton( true );
		
		V.I.ContainerRefresh( ent );
		
	end
	
	function V.I.ContainerRefresh( ent )
		
		if( V.I.ContainerWin.ItemButtons ) then
			
			for _, v in pairs( V.I.ContainerWin.ItemButtons ) do
				
				v:Remove();
				
			end
			
		end
		
		V.I.ContainerWin.ItemButtons = { };
		
		local w = math.max( ( 74 * #ent.Inventory ) + 10, 276 );
		V.I.ContainerWin:SetSize( w, 104 );
		V.I.ContainerWin:Center();
		
		for k, v in pairs( ent.Inventory ) do
			
			local item = V.I.GetItemByID( v.ID );
			
			if( !item ) then
				
				MsgC( Color( 255, 0, 0, 255 ), "ERROR - Missing item: " .. v.ID .. "\n" );
				continue;
				
			end
			
			V.I.ContainerWin.ItemButtons[k] = vgui.Create( "VInventoryItem", V.I.ContainerWin );
			V.I.ContainerWin.ItemButtons[k]:SetPos( 10 + 74 * ( k - 1 ), 30 );
			V.I.ContainerWin.ItemButtons[k]:SetModel( item.Model );
			V.I.ContainerWin.ItemButtons[k]:SetSkin( item.Skin );
			V.I.ContainerWin.ItemButtons[k]:SetItem( v.ID );
			if( v.Num > 1 ) then
				V.I.ContainerWin.ItemButtons[k]:SetCornerText( "x" .. tostring( v.Num ) );
			end
			
			local function f( self )
				
				local d = LocalPlayer():GetPos():Distance( ent:GetPos() );
				
				if( d <= 256 ) then
					
					net.Start( "e_tci" );
						net.WriteEntity( ent );
						net.WriteString( v.ID );
					net.SendToServer();
					
					V.I.TakeContainerItem( LocalPlayer(), ent, v.ID );
					
					self:Remove();
					
				end
				
			end
			V.I.ContainerWin.ItemButtons[k]:SetButton( f );
			
		end
		
	end
	
	function V.I.OpenBook( title )
		
		V.I.ContainerWin = vgui.Create( "DFrame" );
		V.I.ContainerWin:SetSize( 600, 450 );
		V.I.ContainerWin:Center();
		V.I.ContainerWin:SetTitle( title );
		V.I.ContainerWin:MakePopup();
		V.I.ContainerWin:ShowCloseButton( true );
		
		if( table.Count( V.I.Books[title] ) == 1 ) then
			
			for k, v in pairs( V.I.Books[title] ) do
				
				local t, n = V.CB.FormatLine( v, "VCandara20", 580 );
				
				local a = vgui.Create( "DLabel", V.I.ContainerWin );
				a:SetPos( 10, 10 );
				a:SetSize( 580, 420 );
				a:SetFont( "VCandara20" );
				a:SetText( t );
				a:SizeToContents();
				
			end
			
		else
			
			V.I.ContainerWin.Sheet = vgui.Create( "VPropertySheet", V.I.ContainerWin );
			V.I.ContainerWin.Sheet:SetPos( 0, 30 );
			V.I.ContainerWin.Sheet:SetSize( 600, 420 );
			
			for k, v in pairs( V.I.Books[title] ) do
				
				local panel = vgui.Create( "DScrollPanel" );
				panel:SetPos( 0, 0 );
				panel:SetSize( 580, 420 );
				
				local t, n = V.CB.FormatLine( v, "VCandara20", 580 );
				
				local a = vgui.Create( "DLabel", panel );
				a:SetPos( 10, 10 );
				a:SetSize( 580, 420 );
				a:SetFont( "VCandara20" );
				a:SetText( t );
				a:SizeToContentsY();
				
				V.I.ContainerWin.Sheet:AddSheet( k, panel, false, false );
				
			end
			
		end
		
	end
	
else
	
	function V.I.SendContainerInventory( ply, ent, open )
		
		V.I.CheckInvent( ent );
		
		net.Start( "nContainerOpen" );
			net.WriteEntity( ent );
			net.WriteFloat( ent:GetContainer() );
			net.WriteTable( ent.Inventory );
			net.WriteFloat( open and 1 or 0 );
		net.Send( ply );
		
	end
	
	function V.I.GiveItem( ply, id, num, pred, nosave, s )
		
		if( SERVER and pred and ply:IsPlayer() ) then
			
			net.Start( "nItemGive" );
				net.WriteString( id );
				net.WriteFloat( num or 1 );
				net.WriteFloat( s and 1 or 0 );
			net.Send( ply );
			
		end
		
		V.I.CheckInvent( ply );
		
		local n = V.I.HasItem( ply, id );
		
		if( n and V.I.GetItemByID( id ).Stackable ) then
			
			ply.Inventory[n].Num = ply.Inventory[n].Num + num or 1;
			
		else
			
			table.insert( ply.Inventory, { ID = id, Num = num or 1 } );
			
		end
		
		if( !nosave and ply:IsPlayer() ) then
			
			V.SQL.SaveInventory( ply );
			
		end
		
	end
	
	function V.I.RemoveItem( ply, id, num, pred, nosave )
		
		if( pred and ply:IsPlayer() ) then
			
			net.Start( "nItemRemove" );
				net.WriteString( id );
				net.WriteFloat( num or 1 );
			net.Send( ply );
			
		end
		
		V.I.CheckInvent( ply );
		
		local n = V.I.HasItem( ply, id );
		
		if( n ) then
			
			ply.Inventory[n].Num = ply.Inventory[n].Num - ( num or 1 );
			
			if( ply.Inventory[n].Num <= 0 ) then
				
				V.I.RemoveIndex( ply, n );
				
			end
			
			if( !nosave and ply:IsPlayer() ) then
				
				V.SQL.SaveInventory( ply );
				
			end
			
		end
		
	end
	
	function V.I.UseItem( ply, id, pred, mode )
		
		if( ply.CharCreate ) then return end
		if( ply.Asleep ) then return end
		if( !ply:Alive() ) then return end
		
		if( SERVER and pred and ply:IsPlayer() ) then
			
			net.Start( "nItemUse" );
				net.WriteString( id );
			net.Send( ply );
			
		end
		
		if( CLIENT and type( ply ) == "number" ) then
			
			id = net.ReadString();
			ply = LocalPlayer();
			
		end
		
		V.I.CheckInvent( ply );
		
		local n = V.I.HasItem( ply, id );
		
		if( n and V.I.GetItemByID( id ).OnUse ) then
			
			V.I.GetItemByID( id ).OnUse( V.I.GetItemByID( id ), ply, ply.Inventory[n].Num, mode );
			
			if( V.I.GetItemByID( id ).RemoveOnUse ) then
				
				V.I.RemoveItem( ply, id );
				
			end
			
		end
		
	end
	
	function V.I.KillItem( ply, id, pred )
		
		if( pred and ply:IsPlayer() ) then
			
			net.Start( "nItemKill" );
				net.WriteString( id );
			net.Send( ply );
			
		end
		
		V.I.CheckInvent( ply );
		
		local n = V.I.HasItem( ply, id );
		
		if( n ) then
			
			if( V.I.GetItemByID( id ).OnDestroy ) then
				
				V.I.GetItemByID( id ).OnDestroy( V.I.GetItemByID( id ), ply, V.I.NumItemByID( id ) );
				
			end
			
			V.I.RemoveItem( ply, id );
			
		end
		
	end
	
end

V.I.Craftables = { };

function V.I.RegisterRecipe( ret, tools, ingredients, amount )
	
	table.insert( V.I.Craftables, { ret, tools, ingredients, amount } );
	
end

function V.I.CanCraftItem( tab ) -- Caveat: No duplicate items (ie, 2 logs and 1 coke)
	
	for k, v in pairs( V.I.Craftables ) do
		
		if( #v[2] + #v[3] == #tab ) then
			
			local good = true;
			
			for _, n in pairs( v[2] ) do
				
				if( !table.HasValue( tab, n ) ) then
					
					good = false;
					
				end
				
			end
			
			for _, n in pairs( v[3] ) do
				
				if( !table.HasValue( tab, n ) ) then
					
					good = false;
					
				end
				
			end
			
			if( good ) then return v[1], v[3], v[4] end
			
		end
		
	end
	
end

function V.I.TakeContainerItem( ply, ent, id )
	
	if( !V.I.HasItem( ent, id ) ) then return end
	
	V.I.GiveItem( ply, id, 1 );
	V.I.RemoveItem( ent, id, 1 );
	
	if( CLIENT ) then
		
		if( V.I.ContainerWin ) then
			
			V.I.ContainerRefresh( ent );
			
		end
		
		V.I.PlaySound( id );
		
	end
	
end
