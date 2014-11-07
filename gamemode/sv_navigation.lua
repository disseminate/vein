require( "navigation" );

V.NAV = { };

if( nav ) then
	
	MsgC( Color( 0, 255, 0, 255 ), "Navigation module success.\n" );
	
	V.NAV.Generating = false;
	
	V.NAV.Mesh = nav.Create( 48 );
	V.NAV.Mesh:SetDiagonal( true );
	
	function V.NAV.AddSeed( tr )
		
		V.NAV.Mesh:AddWalkableSeed( tr.HitPos, tr.HitNormal );
		
	end
	
	function V.NAV.ClearSeeds()
		
		V.NAV.Mesh:ClearGroundSeeds();
		
	end
	
	function V.NAV.Delete()
		
		V.NAV.Mesh = nav.Create( 48 );
		V.NAV.Mesh:SetDiagonal( true );
		V.NAV.Save();
		
	end
	
	function V.NAV.StartGenerate()
		
		MsgAll( "Node generation initiated." );
		V.NAV.Mesh:Generate( V.NAV.FinishGenerate, V.NAV.GenerateStep );
		V.NAV.Generating = true;
		
	end
	
	function V.NAV.CleanupNodes()
		
		MsgAll( "Cleaning up nodes, this may take a while..." );
		local p = V.NAV.Mesh:GetNodeTotal();
		
		local nodes = V.NAV.Mesh:GetNodes();
		
		for _, v in pairs( nodes ) do
			
			local pos = v:GetPos();
			
			local c = util.PointContents( pos + Vector( 0, 0, 32 ) ); -- Allow zombies to spawn in puddles, but not in lakes
			
			if( bit.band( c, CONTENTS_WATER ) == CONTENTS_WATER ) then
				
				V.NAV.Mesh:RemoveNode( v );
				continue;
				
			end
			
			local trace = { };
			trace.start = pos;
			trace.endpos = pos + Vector( 0, 0, 64 );
			trace.mins = Vector( -16, -16, 0 );
			trace.maxs = Vector( 16, 16, 1 );
			local tr = util.TraceHull( trace );
			
			if( tr.Hit ) then
				
				V.NAV.Mesh:RemoveNode( v );
				continue;
				
			end
			
		end
		
		MsgAll( "Done cleanup! Removed " .. tostring( p - V.NAV.Mesh:GetNodeTotal() ) .. " nodes. Saving..." );
		
	end

	function V.NAV.FinishGenerate()
		
		V.NAV.CleanupNodes();
		V.NAV.Save();
		MsgAll( "Done! Navmesh saved (" .. tostring( V.NAV.Mesh:GetNodeTotal() ) .. " nodes)." );
		V.NAV.Generating = false;
		
	end

	function V.NAV.GenerateStep( nav, n )
		
		MsgAll( "Generating... " .. tostring( n ) .. " nodes." );
		
	end
	
	function V.NAV.Save()
		
		V.NAV.Mesh:Save( "data/Vein/navmeshes/" .. game.GetMap() .. ".nav" );
		
	end
	
	function V.NAV.Load()
		
		if( file.Exists( "Vein/navmeshes/" .. game.GetMap() .. ".nav", "DATA" ) ) then
			
			V.NAV.Mesh:Load( "data/Vein/navmeshes/" .. game.GetMap() .. ".nav" );
			
		end
		
	end
	
	V.NAV.Load();
	
else
	
	MsgC( Color( 255, 0, 0, 255 ), "ERROR - Navigation module not found.\n" );
	
end