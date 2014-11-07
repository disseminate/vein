local spawning = { };

gameevent.Listen( "player_connect" );
gameevent.Listen( "player_disconnect" );

V.SEC = { };
V.SEC.WL = { };
V.SEC.WLE = false;

function V.SEC.AddWhitelistSteamID( s )
	
	table.insert( V.SEC.WL, s );
	
end

function V.SEC.Drop( uid, reason )
	
	game.ConsoleCommand( "kickid " .. tostring( uid ) .. " " .. tostring( reason ) .. "\n" );
	
end

function V.SEC.Player_connect( data )
	
	local r = hook.Call( "PlayerPasswordAuth", GAMEMODE, data.name, "", data.networkid, data.address );
	
	if( type( r ) == "string" ) then
		
		V.SEC.Drop( data.userid, r );
		return;
		
	end
	
	table.insert( spawning, data.userid );
	
end
hook.Add( "player_connect", "V.SEC.Player_connect", V.SEC.Player_connect );

function V.SEC.Player_disconnect( data )
	
	for k, v in pairs( spawning ) do
		
		if( data.userid == v ) then
			
			table.remove( spawning, k );
			break;
			
		end
		
	end
	
end
hook.Add( "player_disconnect", "V.SEC.Player_disconnect", V.SEC.Player_disconnect );

function V.SEC.PlayerInitialSpawn( ply )
	
	for k, v in pairs( spawning ) do
		
		if( ply:UserID() == v ) then
			
			table.remove( spawning, k );
			break;
			
		end
		
	end
	
end
hook.Add( "PlayerInitialSpawn", "V.SEC.PlayerInitialSpawn", V.SEC.PlayerInitialSpawn );

function V.SEC.PlayerPasswordAuth( user, pass, steam, ip )
	
	if( V.SEC.WLE ) then
		
		if( table.HasValue( V.SEC.WL, steam ) or table.HasValue( V.SEC.WL, ip ) ) then
			
			return true;
			
		end
		
		MsgN( "Whitelist disallowed for " .. user );
		return "You're not on the whitelist, nerd.";
		
	end
	
	return true;
	
end
hook.Add( "PlayerPasswordAuth", "V.SEC.PlayerPasswordAuth", V.SEC.PlayerPasswordAuth );