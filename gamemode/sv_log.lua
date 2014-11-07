function V.SQLLog( t )
	
	local c = file.Read( "Vein/logs/sql.txt" ) or "";
	local ins = tostring( os.date() ) .. "\t" .. t .. "\n";
	file.Write( "Vein/logs/sql.txt", c .. ins );
	
end