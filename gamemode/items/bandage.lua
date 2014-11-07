ITEM.ID 			= "bandage";
ITEM.Name 			= "Bandage";
ITEM.Weight 		= 1;
ITEM.Model 			= "models/props/cs_office/Paper_towels.mdl";
ITEM.Skin			= 0;
ITEM.Stackable 		= true;
ITEM.UseModes		= { "Bandage Self", "Bandage Other" };

ITEM.OnUse = function( data, ply, n, mode )
	
	if( mode == "Bandage Self" ) then
		
		V.I.RemoveItem( ply, data.ID, 1 );
		
		if( SERVER ) then
			
			ply:SetHealth( math.min( ply:Health() + 25, 100 ) );
			
		else
			
			V.CB.AddToChat( "You apply the bandage to yourself.", Color( 0, 190, 33, 255 ), "VCandara20", { 1, 2 } );
			
		end
		
	else
		
		local trace = { };
		trace.start = ply:GetShootPos();
		trace.endpos = trace.start + ply:GetAimVector() * 128;
		trace.filter = ply;
		local tr = util.TraceLine( trace );
		
		if( tr.Entity and tr.Entity:IsValid() and tr.Entity:IsPlayer() ) then
			
			if( SERVER ) then
				
				tr.Entity:SetHealth( math.min( tr.Entity:Health() + 25, 100 ) );
				
			else
				
				V.CB.AddToChat( "You apply the bandage to " .. tr.Entity:RPName() .. ".", Color( 0, 190, 33, 255 ), "VCandara20", { 1, 2 } );
				
			end
			
			V.I.RemoveItem( ply, data.ID, 1 );
			
		elseif( CLIENT ) then
			
			V.CB.AddToChat( "You need to be looking at someone for this.", Color( 200, 0, 0, 255 ), "VCandara20", { 1, 2 } );
			
		end
		
	end
	
end