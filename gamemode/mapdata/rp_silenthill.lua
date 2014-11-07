function GM:SetupPlayerVisibility( ply )
	
	if( ply.FirstSession ) then
		
		AddOriginToPVS( Vector( 1867, 1371, 523 ) );
		
	end
	
end

function V.MD.InitPostEntity()
	
	if( SERVER ) then
		
		for _, v in pairs( ents.FindByClass( "weapon_*" ) ) do
			
			v:Remove();
			
		end
		
	end
	
end