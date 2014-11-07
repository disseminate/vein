ITEM.ID 			= "water";
ITEM.Name 			= "Water Bottle";
ITEM.Weight 		= 1;
ITEM.Model 			= "models/props/cs_office/Water_bottle.mdl";
ITEM.Skin			= 0;
ITEM.Stackable 		= true;
ITEM.RemoveOnUse	= true;

ITEM.OnUse = function( data, ply, n )
	
	if( SERVER ) then
		
		V.STAT.AddStatus( ply, V.STAT.STATUS_HUNGER, 1 );
		V.STAT.AddStatus( ply, V.STAT.STATUS_DRUNK, 1 );
		
	else
		
		V.CB.AddToChat( "You drink the water from the bottle.", Color( 0, 190, 33, 255 ), "VCandara20", { 1, 2 } );
		
	end
	
end