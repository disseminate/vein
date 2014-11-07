V.CC = { };

function V.CC.CreateNet( com, func, delay )
	
	local function f( len, ply )
		
		if( !ply["Next" .. com] ) then ply["Next" .. com] = 0 end
		
		if( CurTime() >= ply["Next" .. com] ) then
			
			ply["Next" .. com] = CurTime() + delay;
			func( ply );
			
		end
		
	end
	net.Receive( com, f );
	util.AddNetworkString( com );
	
end

function V.CC.LoadChar( ply )
	
	local id = net.ReadFloat();
	
	if( V.SQL.CharExists( ply, id ) ) then
		
		V.SQL.LoadChar( ply, id );
		
	end
	
end
V.CC.CreateNet( "e_lc", V.CC.LoadChar, 2 );

function V.CC.CreateChar( ply )
	
	local model = net.ReadFloat();
	local skin = net.ReadFloat();
	local gender = net.ReadFloat();
	local name = net.ReadString();
	local desc = net.ReadString();
	
	local res, _ = V.GoodChar( model, skin, gender, name, desc );
	
	if( res and V.SQL.GetNumChars( ply ) < V.Config.MaxCharacters ) then
		
		local modelstr;
		
		if( gender == 0 ) then
			
			modelstr = V.MaleValidModels[model].Model;
			
		else
			
			modelstr = V.FemaleValidModels[model].Model;
			
		end
		
		local id = V.SQL.SaveNewCharacter( ply, name, desc, modelstr, skin );
		V.SQL.LoadChar( ply, id );
		
		net.Start( "nCharAdd" );
			net.WriteString( name );
			net.WriteString( modelstr );
			net.WriteFloat( id );
			net.WriteFloat( skin );
			net.WriteBit( false );
		net.Send( ply );
		
	end
	
end
V.CC.CreateNet( "e_cc", V.CC.CreateChar, 2 );

function V.CC.DeleteChar( ply )
	
	local id = net.ReadFloat();
	
	if( V.SQL.CharExists( ply, id ) and V.SQL.CharID( ply ) != id ) then
		
		V.SQL.DeleteChar( ply, id );
		
		net.Start( "nCharDelete" );
			net.WriteFloat( id );
		net.Send( ply );
		
	end
	
end
V.CC.CreateNet( "e_dc", V.CC.DeleteChar, 1 );

function V.CC.UseItem( ply )
	
	V.I.UseItem( ply, net.ReadString(), false, net.ReadString() );
	
end
V.CC.CreateNet( "e_ui", V.CC.UseItem, 0 );

function V.CC.KillItem( ply )
	
	V.I.KillItem( ply, net.ReadString() );
	
end
V.CC.CreateNet( "e_ki", V.CC.KillItem, 0 );

function V.CC.CraftItems( ply )
	
	local tab = net.ReadTable();
	local craft, used, amt = V.I.CanCraftItem( tab );
	
	if( craft ) then
		
		for _, v in pairs( tab ) do
			
			if( !V.I.HasItem( ply, v ) ) then
				
				return;
				
			end
			
		end
		
		V.I.GiveItem( ply, craft, amt );
		
		for _, v in pairs( used ) do
			
			V.I.RemoveItem( ply, v );
			
		end
		
	end
	
end
V.CC.CreateNet( "e_gic", V.CC.CraftItems, 0 );

function V.CC.Chat( ply )
	
	V.CCMD.OnChat( ply, net.ReadString() );
	
end
V.CC.CreateNet( "e_c", V.CC.Chat, 0 );

function V.CC.ChatOpened( ply )
	
	ply:SetTyping( "Typing..." );
	
end
V.CC.CreateNet( "e_chato", V.CC.ChatOpened, 0 );

function V.CC.ChatClosed( ply )
	
	ply:SetTyping( "" );
	
end
V.CC.CreateNet( "e_chatc", V.CC.ChatClosed, 0 );

function V.CC.PDesc( ply )
	
	local str = net.ReadString();
	
	if( string.len( str ) > V.Config.MaxDescLen ) then str = string.sub( str, 1, V.Config.MaxDescLen ) end
	
	ply:SetPDesc( str );
	V.SQL.SaveCharacterField( ply, "PDesc", str );
	
end
V.CC.CreateNet( "e_pd", V.CC.PDesc, 1 );

function V.CC.Sleep( ply )
	
	if( !ply.Asleep ) then
		
		ply.Asleep = true;
		ply.AsleepTime = CurTime() + 10;
		ply.Bed = self;
		
		ply:StripWeapons();
		
	end
	
end
V.CC.CreateNet( "e_sl", V.CC.Sleep, 10 );

function V.CC.SetClothing( ply )
	
	if( !V.I.HasItem( ply, "tshirt" ) ) then return end
	
	local n = net.ReadFloat();
	local good = false;
	
	local i = V.ModelToInt( ply:GetModel(), ply:GetSkin() );
	
	if( !i ) then return end
	
	if( ply:IsFemale() ) then
		
		if( table.HasValue( V.FemaleValidModels[i].Skin, n ) ) then
			
			good = true;
			
		end
		
	else
		
		if( table.HasValue( V.MaleValidModels[i].Skin, n ) ) then
			
			good = true;
			
		end
		
	end
	
	if( good ) then
		
		V.I.RemoveItem( ply, "tshirt", 1 );
		
		ply:SetSkin( n );
		V.SQL.SaveCharacterField( ply, "Skin", tostring( n ) );
		
	end
	
end
V.CC.CreateNet( "e_sc", V.CC.SetClothing, 1 );

function V.CC.Panic( ply )
	
	V.STAT.Panic( ply );
	
end
V.CC.CreateNet( "e_panic", V.CC.Panic, 10 );

function V.CC.TakeContainerItem( ply )
	
	local ent = net.ReadEntity();
	local id = net.ReadString();
	
	local d = ply:GetPos():Distance( ent:GetPos() );
	
	if( d <= 256 ) then
		
		V.I.TakeContainerItem( ply, ent, id );
		
	end
	
end
V.CC.CreateNet( "e_tci", V.CC.TakeContainerItem, 0 );

function V.CC.Trade( ply )
	
	local ent = net.ReadEntity();
	local id = net.ReadString();
	
	local d = ply:GetPos():Distance( ent:GetPos() );
	
	if( d <= 256 ) then
		
		if( ent:GetClass() == "v_prop" ) then
			
			if( ent:GetContainer() > 0 ) then
				
				V.I.CheckInvent( ent );
				local preset = V.I.ContainerPresets[ent:GetContainer()];
				
				if( V.I.GetNum( ent ) < preset[2] ) then
					
					if( V.I.GetItemByID( id ).OnDestroy ) then
						V.I.GetItemByID( id ):OnDestroy( ply, 1 );
					end
					
					V.I.RemoveItem( ply, id, 1, true );
					V.I.GiveItem( ent, id, 1, true, false, true );
					
				end
				
			end
			
		elseif( ent:IsPlayer() ) then
			
			if( V.I.GetItemByID( id ).OnDestroy ) then
				V.I.GetItemByID( id ):OnDestroy( ply, 1 );
			end
			
			V.I.RemoveItem( ply, id, 1, true );
			V.I.GiveItem( ent, id, 1, true );
			
		end
		
	end
	
end
V.CC.CreateNet( "e_trade", V.CC.Trade, 0 );