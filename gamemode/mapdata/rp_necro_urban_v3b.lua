function GM:SetupPlayerVisibility( ply )
	
	if( ply.FirstSession ) then
		
		AddOriginToPVS( Vector( 1990, -158, 860 ) );
		
	end
	
end

function V.MD.InitPostEntity()
	
	if( SERVER ) then
		
		for _, v in pairs( ents.FindByClass( "func_precipitation" ) ) do
			
			v:Remove();
			
		end
		
		for _, v in pairs( ents.FindByName( "rainfall" ) ) do
			
			v:Fire( "Volume", "0", 1 );
			
		end
		
		for _, v in pairs( ents.FindByName( "rainfall_2" ) ) do
			
			v:Fire( "Volume", "0", 1 );
			
		end
		
		for _, v in pairs( ents.FindByName( "rainfall_tap" ) ) do
			
			v:Fire( "Volume", "0", 1 );
			
		end
		
		for _, v in pairs( ents.FindByName( "thunder_timer" ) ) do
			
			v:Remove();
			
		end
		
		for _, v in pairs( ents.FindByName( "thunder_01" ) ) do
			
			v:Remove();
			
		end
		
		for _, v in pairs( ents.FindByName( "thunder_02" ) ) do
			
			v:Remove();
			
		end
		
		for _, v in pairs( ents.FindByName( "thunder_03" ) ) do
			
			v:Remove();
			
		end
		
		for _, v in pairs( ents.FindByName( "thunder_04" ) ) do
			
			v:Remove();
			
		end
		
	end
	
end