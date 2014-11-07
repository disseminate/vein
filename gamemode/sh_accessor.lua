local NetStrings = {
	"RPName",
	"PDesc",
	"Typing",
	"Zombie"
};

local meta = FindMetaTable( "Entity" );

function meta:SetNetString( k, v )
	
	if( SERVER ) then
		
		self["NET_" .. k] = v;
		
		net.Start( "nNetVar" );
			net.WriteString( k );
			net.WriteString( v );
			net.WriteEntity( self );
		net.Broadcast();
		
	end
	
end

if( CLIENT ) then
	
	function netSendNetPack( len )
		
		local t = net.ReadTable();
		local e = net.ReadEntity();
		
		for k, v in pairs( t ) do
			
			e["NET_" .. k] = v;
			
		end
		
	end
	net.Receive( "nNetPack", netSendNetPack );
	
	function netSendNetVar( len )
		
		local a = net.ReadString();
		local b = net.ReadString();
		local e = net.ReadEntity();
		
		e["NET_" .. a] = b;
		
	end
	net.Receive( "nNetVar", netSendNetVar );
	
end

function meta:SyncNetStrings( targ )
	
	local tab = { };
	
	for k, v in pairs( targ:GetTable() ) do
		
		if( string.find( k, "NET_" ) ) then
			
			tab[string.sub( k, 5 )] = v;
			
		end
		
	end
	
	net.Start( "nNetPack" );
		net.WriteTable( tab );
		net.WriteEntity( targ );
	net.Send( self );
	
end

function meta:GetOtherNetStrings()
	
	for _, v in pairs( player.GetAll() ) do
		
		if( v != self ) then
			
			self:SyncNetStrings( v );
			
		end
		
	end
	
end

function meta:GetNetString( k )
	
	return self["NET_" .. k] or "";
	
end

for _, v in pairs( NetStrings ) do
	
	meta["Set" .. v] = function( self, val )
		
		self:SetNetString( v, val );
		
	end
	
	meta[v] = function( self )
		
		return self:GetNetString( v );
		
	end
	
end