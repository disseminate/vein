V.CCMD = { };
V.CCMD.CC = { };

function V.CCMD.AddChatCommand( cmd, cb, col )
	
	table.insert( V.CCMD.CC, { cmd, cb, col } );
	
end

function V.CCMD.StringHasCommand( str )
	
	for _, v in pairs( V.CCMD.CC ) do
		
		if( str and string.find( str, v[1], nil, true ) == 1 ) then
			
			return v;
			
		end
		
	end
	
	return false;
	
end

function V.CCMD.GetRF( ply, maxd, muffled )
	
	local rp = { };
	
	for _, v in pairs( player.GetAll() ) do
		
		if( v != ply ) then
			
			local dist = maxd;
			
			if( maxd != muffled and !ply:CanHear( v ) ) then
				
				dist = muffled;
				
			end
			
			if( v:GetPos():Distance( ply:GetPos() ) < dist ) then
				
				table.insert( rp, v );
				
			end
			
		end
		
	end
	
	if( #rp == 0 ) then return end
	
	return rp;
	
end

local function LocalChat( ply, arg )
	
	if( !ply:Alive() ) then
		
		if( CLIENT ) then
			
			V.CB.AddToChat( "You can't talk, you're dead.", Color( 200, 0, 0, 255 ), "VCandara20", { 1, 2 } );
			
		end
		
		return;
		
	end
	
	GAMEMODE:DoChatGestures( ply, 0, arg );
	
	if( SERVER ) then
		
		local rp = V.CCMD.GetRF( ply, V.Config.TalkRange, V.Config.TalkRangeMuffled );
		
		net.Start( "nChatLocal" );
			net.WriteEntity( ply );
			net.WriteString( arg );
		net.Send( rp );
		
	else
		
		local name = ply:RPName();
		V.CB.AddToChat( name .. ": " .. arg, Color( 200, 200, 200, 255 ), "VCandara20", { 1, 2 } );
		
	end
	
end

local function Yell( ply, arg )
	
	if( !ply:Alive() ) then
		
		if( CLIENT ) then
			
			V.CB.AddToChat( "You can't yell, you're dead.", Color( 200, 0, 0, 255 ), "VCandara20", { 1, 2 } );
			
		end
		
		return;
		
	end
	
	GAMEMODE:DoChatGestures( ply, 1, arg );
	
	if( SERVER ) then
		
		local rp = V.CCMD.GetRF( ply, V.Config.YellRange, V.Config.YellRangeMuffled );
		
		net.Start( "nChatYell" );
			net.WriteEntity( ply );
			net.WriteString( arg );
		net.Send( rp );
		
		if( V.Config.PlayerSpawnZombies and nav ) then
			
			V.Z.CreateZombieGroup( ply, math.random( 1, 3 ) );
			
		end
		
		for _, v in pairs( V.Z.GetZombies() ) do
			
			v:HearPlayer( ply, 1024 );
			
		end
		
	else
		
		local name = ply:RPName();
		V.CB.AddToChat( name .. ": " .. arg, Color( 200, 50, 50, 255 ), "VCandara30", { 1, 2 } );
		
	end
	
end
V.CCMD.AddChatCommand( "/y ", Yell, Color( 200, 50, 50, 255 ) );

local function Whisper( ply, arg )
	
	if( !ply:Alive() ) then
		
		if( CLIENT ) then
			
			V.CB.AddToChat( "You can't whisper, you're dead.", Color( 200, 0, 0, 255 ), "VCandara20", { 1, 2 } );
			
		end
		
		return;
		
	end
	
	GAMEMODE:DoChatGestures( ply, 2, arg );
	
	if( SERVER ) then
		
		local rp = V.CCMD.GetRF( ply, V.Config.WhisperRange, V.Config.WhisperRangeMuffled );
		
		net.Start( "nChatWhisper" );
			net.WriteEntity( ply );
			net.WriteString( arg );
		net.Send( rp );
		
	else
		
		local name = ply:RPName();
		V.CB.AddToChat( name .. ": " .. arg, Color( 255, 255, 255, 255 ), "VCandara15", { 1, 2 } );
		
	end
	
end
V.CCMD.AddChatCommand( "/w ", Whisper, Color( 255, 255, 255, 255 ) );

local function Me( ply, arg )
	
	if( SERVER ) then
		
		local rp = V.CCMD.GetRF( ply, V.Config.TalkRange, V.Config.TalkRange );
		
		net.Start( "nChatMe" );
			net.WriteEntity( ply );
			net.WriteString( arg );
		net.Send( rp );
		
	else
		
		for _, v in pairs( V.SpecialGestures ) do
			
			if( v[1] == V.SanitizeString( arg ) ) then
				
				V.DoVCDGesture( ply, v[2] );
				
			end
			
		end
		
		local name = ply:RPName();
		V.CB.AddToChat( name .. " " .. arg, Color( 139, 224, 151, 255 ), "VCandara20B", { 1, 2 } );
		
	end
	
end
V.CCMD.AddChatCommand( "/me ", Me, Color( 139, 224, 151, 255 ) );

local function It( ply, arg )
	
	if( SERVER ) then
		
		local rp = V.CCMD.GetRF( ply, V.Config.TalkRange, V.Config.TalkRange );
		
		net.Start( "nChatIt" );
			net.WriteString( arg );
		net.Send( rp );
		
	else
		
		V.CB.AddToChat( arg, Color( 98, 158, 107, 255 ), "VCandara20B", { 1, 2 } );
		
	end
	
end
V.CCMD.AddChatCommand( "/it ", It, Color( 98, 158, 107, 255 ) );

local function LOOC( ply, arg )
	
	if( SERVER ) then
		
		local rp = V.CCMD.GetRF( ply, V.Config.TalkRange, V.Config.TalkRangeMuffled );
		
		net.Start( "nChatLocalOOC" );
			net.WriteEntity( ply );
			net.WriteString( arg );
		net.Send( rp );
		
	else
		
		local name = ply:RPName();
		V.CB.AddToChat( name .. " [LOOC]: " .. arg, Color( 104, 192, 255, 255 ), "VCandara20", { 1, 3 } );
		
	end
	
end
V.CCMD.AddChatCommand( "[[", LOOC, Color( 104, 192, 255, 255 ) );

local function OOC( ply, arg )
	
	if( SERVER ) then
		
		local rf = { };
		
		for _, v in pairs( player.GetAll() ) do
			
			if( v != ply ) then
				
				table.insert( rf, v );
				
			end
			
		end
		
		net.Start( "nChatOOC" );
			net.WriteEntity( ply );
			net.WriteString( arg );
		net.Send( rf );
		
	else
		
		local name = ply:RPName();
		V.CB.AddToChat( name .. " [OOC]: " .. arg, Color( 83, 153, 204, 255 ), "VCandara20", { 1, 3 } );
		
	end
	
end
V.CCMD.AddChatCommand( "//", OOC, Color( 83, 153, 204, 255 ) );

local function PM( ply, arg )
	
	if( SERVER ) then
		
		local rf = { };
		table.insert( rf, ply );
		
		local targ = string.Explode( " ", arg )[1];
		local tply = V.FindPlayer( targ );
		
		if( tply ) then
			
			table.insert( rf, tply );
			
		else
			
			return;
			
		end
		
		net.Start( "nChatPM" );
			net.WriteEntity( ply );
			net.WriteEntity( tply );
			net.WriteString( string.sub( arg, string.len( targ ) + 2 ) );
		net.Send( rf );
		
	end
	
end
V.CCMD.AddChatCommand( "/pm ", PM, Color( 255, 216, 0, 255 ) );

local function A( ply, arg )
	
	if( SERVER ) then
		
		local rf = { };
		
		for _, v in pairs( player.GetAll() ) do
			
			if( v:IsAdmin() ) then
				
				table.insert( rf, v );
				
			end
			
		end
		
		if( #rf == 0 ) then
			
			net.Start( "nChatAB" );
			net.Send( ply );
			
		else
			
			table.insert( rf, ply );
			
			net.Start( "nChatA" );
				net.WriteEntity( ply );
				net.WriteString( arg );
			net.Send( rf );
			
		end
		
	end
	
end
V.CCMD.AddChatCommand( "/a ", A, Color( 255, 80, 0, 255 ) );

function V.CCMD.OnChat( ply, msg )
	
	if( ply.CharCreate ) then return end
	if( ply.Asleep ) then return end
	
	local cc = V.CCMD.StringHasCommand( msg );
	
	if( cc ) then
		
		cc[2]( ply, string.Trim( string.sub( msg, string.len( cc[1] ) + 1 ) ) );
		
	else
		
		LocalChat( ply, msg );
		
	end
	
end

if( CLIENT ) then

V.CCMD.UM = { };

function V.CCMD.UM.LocalChat( len )
	
	local ply = net.ReadEntity();
	local str = net.ReadString();
	
	LocalChat( ply, str );
	
end
net.Receive( "nChatLocal", V.CCMD.UM.LocalChat );

function V.CCMD.UM.Yell( len )
	
	local ply = net.ReadEntity();
	local str = net.ReadString();
	
	Yell( ply, str );
	
end
net.Receive( "nChatYell", V.CCMD.UM.Yell );

function V.CCMD.UM.Whisper( len )
	
	local ply = net.ReadEntity();
	local str = net.ReadString();
	
	Whisper( ply, str );
	
end
net.Receive( "nChatWhisper", V.CCMD.UM.Whisper );

function V.CCMD.UM.Me( len )
	
	local ply = net.ReadEntity();
	local str = net.ReadString();
	
	Me( ply, str );
	
end
net.Receive( "nChatMe", V.CCMD.UM.Me );

function V.CCMD.UM.It( len )
	
	local str = net.ReadString();
	
	It( nil, str );
	
end
net.Receive( "nChatIt", V.CCMD.UM.It );

function V.CCMD.UM.LOOC( len )
	
	local ply = net.ReadEntity();
	local str = net.ReadString();
	
	LOOC( ply, str );
	
end
net.Receive( "nChatLocalOOC", V.CCMD.UM.LOOC );

function V.CCMD.UM.OOC( len )
	
	local ply = net.ReadEntity();
	local str = net.ReadString();
	
	OOC( ply, str );
	
end
net.Receive( "nChatOOC", V.CCMD.UM.OOC );

function V.CCMD.UM.PM( len )
	
	local ply = net.ReadEntity();
	local targ = net.ReadEntity();
	local str = net.ReadString();
	
	local name = ply:RPName();
	local tname = targ:RPName();
	
	V.CB.AddToChat( name .. " [PM to " .. tname .. "]: " .. str, Color( 255, 216, 0, 255 ), "VCandara20", { 1, 3 } );
	
end
net.Receive( "nChatPM", V.CCMD.UM.PM );

function V.CCMD.UM.A( len )
	
	local ply = net.ReadEntity();
	local str = net.ReadString();
	
	local name = ply:RPName();
	
	V.CB.AddToChat( name .. " [Admin]: " .. str, Color( 255, 80, 0, 255 ), "VCandara20", { 1, 3 } );
	
end
net.Receive( "nChatA", V.CCMD.UM.A );

function V.CCMD.UM.AB( len )
	
	V.CB.AddToChat( "Error: No admins online.", Color( 255, 0, 0, 255 ), "VCandara20", { 1, 3 } );
	
end
net.Receive( "nChatAB", V.CCMD.UM.AB );

function V.CCMD.UM.FPM( len )
	
	local n = net.ReadString();
	V.CB.AddToChat( "Error: Player '" .. n .. "' not found.", Color( 200, 0, 0, 255 ), "VCandara20", { 1, 3 } );
	
end
net.Receive( "CCMD_FPM", V.CCMD.UM.FPM );

end