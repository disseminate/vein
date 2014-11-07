sql.Query( "CREATE TABLE IF NOT EXISTS v_chars ( id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL );" );
sql.Query( "CREATE TABLE IF NOT EXISTS v_players ( id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL );" );

V.SQL = { };

V.SQL.CharTable = {
	{ "UserID", "TEXT" },
	{ "Name", "TEXT" },
	{ "Model", "TEXT" },
	{ "Skin", "NUMBER" },
	{ "PDesc", "TEXT" },
	{ "Inventory", "TEXT" },
	{ "Dead", "NUMBER" },
	{ "DeadTime", "NUMBER" },
	{ "DeadPos", "TEXT" },
	{ "BittenTime", "NUMBER" },
	{ "Time", "NUMBER" },
	{ "Status", "TEXT" }
};

V.SQL.PlayerTable = {
	{ "SteamID", "TEXT" },
	{ "CreationTime", "TIMESTAMP" },
};

for _, v in pairs( V.SQL.CharTable ) do
	
	local b = sql.Query( "SELECT " .. v[1] .. " FROM v_chars" );
	
	if( b == false and string.find( sql.LastError(), "no such column" ) ) then
		
		sql.Query( "ALTER TABLE v_chars ADD COLUMN " .. v[1] .. " " .. v[2] );
		
	end
	
end

for _, v in pairs( V.SQL.PlayerTable ) do
	
	local b = sql.Query( "SELECT " .. v[1] .. " FROM v_players" );
	
	if( b == false and string.find( sql.LastError(), "no such column" ) ) then
		
		sql.Query( "ALTER TABLE v_players ADD COLUMN " .. v[1] .. " " .. v[2] );
		
	end
	
end

function V.SQL.CheckMode()
	
	if( V.MySQL ) then
		
		require( "mysqloo" );
		
		if( mysqloo ) then
			
			MsgC( Color( 0, 255, 0, 255 ), "MySQLOO module success.\n" );
			
			V.SQL.DB = mysqloo.connect( V.MySQLHost, V.MySQLUser, V.MySQLPass, V.MySQLData, V.MySQLPort );
			
			function V.SQL.DB:onConnected()
				
				MsgC( Color( 0, 255, 0, 255 ), "MySQL connection success.\n" );
				
				V.SQL.MySQLQuery( "CREATE TABLE IF NOT EXISTS v_chars ( id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, UserID TEXT, Name TEXT, Model TEXT, Skin NUMBER, PDesc TEXT, Inventory TEXT, Dead NUMBER, DeadTime NUMBER, DeadPos TEXT, BittenTime NUMBER, LastPos TEXT, Time NUMBER, Status TEXT );" );
				V.SQL.MySQLQuery( "CREATE TABLE IF NOT EXISTS v_players ( id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, SteamID TEXT, CreationTime TIMESTAMP );" );
				
				for _, v in pairs( V.SQL.CharTable ) do
					
					V.SQL.MySQLQuery( "IF COL_LENGTH('v_chars','" .. v[1] .. "') IS NULL BEGIN ALTER TABLE v_chars ADD " .. v[1] .. " " .. v[2] .. " END" );
					
				end
				
				for _, v in pairs( V.SQL.PlayerTable ) do
					
					V.SQL.MySQLQuery( "IF COL_LENGTH('v_players','" .. v[1] .. "') IS NULL BEGIN ALTER TABLE v_players ADD " .. v[1] .. " " .. v[2] .. " END" );
					
				end
				
			end
			
			function V.SQL.DB:onConnectionFailed( e )
				
				MsgC( Color( 255, 0, 0, 255 ), "MySQL connection failure (\"" .. e .. "\").\n" );
				MsgC( Color( 255, 0, 0, 255 ), "Reverting to SQLite.\n" );
				V.MySQL = false;
				
			end
			
			V.SQL.DB:connect();
			
		else
			
			MsgC( Color( 255, 0, 0, 255 ), "ERROR - MySQLOO module not found.\n" );
			MsgC( Color( 255, 0, 0, 255 ), "Reverting to SQLite.\n" );
			V.MySQL = false;
			
		end
		
	end
	
end

function V.SQL.DumpTable( t )
	
	PrintTable( V.SQL.Query( "SELECT * FROM " .. t ) );
	
end

function V.SQL.Query( q )
	
	if( V.SQL.NoQuery ) then return end
	
	if( V.MySQL and V.SQL.DB ) then
		
		return V.SQL.MySQLQuery( q );
		
	end
	
	local ret = sql.Query( q );
	
	if( !ret ) then
		
		return { };
		
	end
	
	for k, v in pairs( ret ) do
		
		if( type( v ) == "table" ) then
			
			for m, n in pairs( v ) do
				
				if( n == "NULL" ) then
					
					ret[k][m] = "";
					
				end
				
			end
			
		end
		
		if( v == "NULL" ) then
			
			ret[k] = "";
			
		end
		
	end
	
	return ret;
	
end

function V.SQL.MySQLQuery( q )
	
	local qo = V.SQL.DB:query( q );
	local ret = { };
	
	function qo:onSuccess( data )
		
		ret = data;
		
	end
	
	function qo:onError( err, sql )
		
		MsgC( Color( 255, 0, 0, 255 ), "MYSQL ERROR - \"" .. err .. "\" from \"" .. sql .. "\"\n" );
		
	end
	
	qo:start();
	--qo:wait();
	
	for k, v in pairs( ret ) do
		
		if( type( v ) == "table" ) then
			
			for m, n in pairs( v ) do
				
				if( n == "NULL" ) then
					
					ret[k][m] = "";
					
				end
				
			end
			
		end
		
		if( v == "NULL" ) then
			
			ret[k] = "";
			
		end
		
	end
	
	PrintTable( ret );
	
	return ret;
	
end

function V.SQL.Purge()
	
	V.SQL.Query( "DELETE FROM sqlite_sequence WHERE name = 'v_chars';" );
	V.SQL.Query( "DELETE FROM sqlite_sequence WHERE name = 'v_players';" );
	V.SQL.Query( "DROP TABLE 'v_players';" );
	V.SQL.Query( "DROP TABLE 'v_chars';" );
	
	V.SQL.NoQuery = true;
	
end

function V.SQL.UserID( ply )
	
	return ply.SQLUserID;
	
end

function V.SQL.SetUserID( ply, val )
	
	ply.SQLUserID = val;
	
end

function V.SQL.CharID( ply )
	
	return ply.SQLCharID;
	
end

function V.SQL.SetCharID( ply, val )
	
	ply.SQLCharID = val;
	
end

function V.SQL.GetUserID( ply )
	
	local q = "SELECT id FROM v_players WHERE SteamID = '" .. ply:SteamID() .. "'";
	
	local ret = V.SQL.Query( q );
	
	if( #ret == 0 ) then
		
		V.SQLLog( "No player record for " .. ply:Nick() .. ", creating..." );
		V.SQL.SaveNewPlayer( ply );
		V.SQL.GetUserID( ply );
		
		ply.FirstSession = true;
		
	else
		
		V.SQL.SetUserID( ply, ret[1].id );
		
	end
	
end

function V.SQL.Escape( q )
	
	if( V.MySQL ) then
		
		return V.SQL.DB:escape( q );
		
	end
	
	return sql.SQLStr( q );
	
end

function V.SQL.PlayerExists( ply )
	
	local q = "SELECT id FROM v_players WHERE SteamID = '" .. ply:SteamID() .. "'";
	
	local ret = V.SQL.Query( q );
	
	if( #ret == 0 ) then
		
		return false;
		
	end
	
	return true;
	
end

function V.SQL.SaveNewPlayer( ply )
	
	local steamid = ply:SteamID();
	
	local q = "INSERT INTO v_players ( `SteamID` ) VALUES ( '" .. steamid .. "' )";
	V.SQL.Query( q );
	
	V.SQLLog( "New player record created for " .. ply:Nick() .. "." );
	
end

function V.SQL.CharExists( ply, id )
	
	local q = "SELECT id FROM v_chars WHERE UserID = '" .. V.SQL.UserID( ply ) .. "' AND id = " .. tostring( id );
	
	local ret = V.SQL.Query( q );
	if( #ret == 0 ) then
		
		return false;
		
	end
	
	return true;
	
end

function V.SQL.GetNumChars( ply )
	
	local q = "SELECT COUNT(" .. V.SQL.UserID( ply ) .. ") FROM v_chars GROUP BY UserID";
	local ret = V.SQL.Query( q );
	
	if( ret[1] and ret[1]["COUNT(1)"] ) then
		
		return tonumber( ret[1]["COUNT(1)"] );
		
	end
	
	return 0;
	
end

function V.SQL.GetCharList( ply )
	
	local q = "SELECT id, Name, Model, Skin, Dead FROM v_chars WHERE UserID = '" .. V.SQL.UserID( ply ) .. "'";
	local ret = V.SQL.Query( q );
	
	return ret;
	
end

function V.SQL.LoadChar( ply, id )
	
	V.PreLoadCharData( ply, tostring( id ) );
	
	V.SQL.SetCharID( ply, id );
	
	net.Start( "nCharReceive" );
		net.WriteFloat( id );
	net.Send( ply );
	
	local q = "SELECT * FROM v_chars WHERE UserID = '" .. V.SQL.UserID( ply ) .. "' AND id = " .. tostring( id );
	
	local ret = V.SQL.Query( q );
	V.LoadCharData( ply, ret[1] );
	
end

function V.SQL.SaveNewCharacter( ply, name, desc, model, skin )
	
	local q = "INSERT INTO v_chars ( `UserID`, `Name`, `PDesc`, `Model`, `Skin`, `Dead`, `Time`, `Status` ) VALUES ( '" .. V.SQL.UserID( ply ) .. "', " .. V.SQL.Escape( name ) .. ", " .. V.SQL.Escape( desc ) .. ", '" .. model .. "', '" .. skin .. "', '0', '0', '' )";
	V.SQL.Query( q );
	
	local q = "SELECT id FROM v_chars WHERE `Name` = " .. V.SQL.Escape( name ) .. " AND `UserID` = '" .. V.SQL.UserID( ply ) .. "'";
	local ret = V.SQL.Query( q );
	return ret[1].id;
	
end

function V.SQL.DeleteChar( ply, id )
	
	local q = "DELETE FROM v_chars WHERE `UserID` = '" .. V.SQL.UserID( ply ) .. "' AND `id` = '" .. id .. "'";
	V.SQL.Query( q );
	
end

function V.SQL.SaveCharacterField( ply, field, value )
	
	local q = "UPDATE v_chars";
	q = q .. " SET " .. V.SQL.Escape( field );
	q = q .. " = " .. V.SQL.Escape( value );
	q = q .. " WHERE `id` = '" .. tostring( V.SQL.CharID( ply ) ) .. "'";
	
	V.SQL.Query( q );
	
end

function V.SQL.SaveInventory( ply )
	
	local str = "";
	
	for _, v in pairs( ply.Inventory ) do
		
		str = str .. v.ID .. ":" .. v.Num .. ";";
		
	end
	
	V.SQL.SaveCharacterField( ply, "Inventory", str );
	
end

function V.SQL.LoadInventory( ply, str )
	
	V.I.ClearInvent( ply );
	
	local e = string.Explode( ";", str );
	
	for _, v in pairs( e ) do
		
		local t = string.Explode( ":", v );
		
		if( V.I.GetItemByID( t[1] ) ) then
			
			V.I.GiveItem( ply, t[1], tonumber( t[2] ), true, true );
			
		end
		
	end
	
end

function V.SQL.SaveStatus( ply )
	
	local str = "";
	
	for k, v in pairs( ply.Status ) do
		
		str = str .. tostring( k ) .. ":" .. tostring( v ) .. ":" .. tostring( ply.StatusUpdate[k] ) .. ";";
		
	end
	
	V.SQL.SaveCharacterField( ply, "Status", str );
	
end

function V.SQL.LoadStatus( ply, str )
	
	ply.Status = { };
	ply.StatusUpdate = { };
	
	if( str and string.len( str ) < 1 ) then
		
		V.STAT.Init( ply );
		V.STAT.SendAllStatus( ply );
		return;
		
	end
	
	local e = string.Explode( ";", str );
	table.remove( e, #e ); -- Junk entry
	
	for _, v in pairs( e ) do
		
		local t = string.Explode( ":", v );
		
		local k = tonumber( t[1] );
		local v = tonumber( t[2] );
		local i = tonumber( t[3] );
		
		ply.Status[k] = v;
		ply.StatusUpdate[k] = i or math.huge;
		
	end
	
	V.STAT.SendAllStatus( ply );
	
end