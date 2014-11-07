function GM:SetupPlayerVisibility( ply )
	
	if( ply.FirstSession ) then
		
		AddOriginToPVS( Vector( 50, -840, 264 ) );
		
	end
	
end

V.NukePos = Vector( 37, -3881, 133 );
