function GM:SetupPlayerVisibility( ply )
	
	if( ply.FirstSession ) then
		
		AddOriginToPVS( Vector( 6485, 754, 168 ) );
		
	end
	
end
