ITEM.ID 			= "takeout";
ITEM.Name 			= "Chinese Takeout";
ITEM.Weight 		= 2;
ITEM.Model 			= "models/props_junk/garbage_takeoutcarton001a.mdl";
ITEM.Skin			= 0;
ITEM.Stackable 		= true;
ITEM.RemoveOnUse	= true;

ITEM.OnUse = function( data, ply, n )
	
	if( SERVER ) then
		
		V.STAT.AddStatus( ply, V.STAT.STATUS_HUNGER, 1 );
		
	else
		
		V.CB.AddToChat( "You eat the Chinese takeout.", Color( 0, 190, 33, 255 ), "VCandara20", { 1, 2 } );
		
	end
	
end