ITEM.ID 			= "milkcarton";
ITEM.Name 			= "Milk Carton";
ITEM.Weight 		= 2;
ITEM.Model 			= "models/props_junk/garbage_milkcarton002a.mdl";
ITEM.Skin			= 0;
ITEM.Stackable 		= true;
ITEM.RemoveOnUse	= true;

ITEM.OnUse = function( data, ply, n )
	
	if( SERVER ) then
		
		V.STAT.AddStatus( ply, V.STAT.STATUS_HUNGER, 1 );
		
	else
		
		V.CB.AddToChat( "You drink the milk from the carton.", Color( 0, 190, 33, 255 ), "VCandara20", { 1, 2 } );
		
	end
	
end