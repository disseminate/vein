ITEM.ID 			= "brandy";
ITEM.Name 			= "Brandy";
ITEM.Weight 		= 1;
ITEM.Model 			= "models/props_junk/garbage_glassbottle002a.mdl";
ITEM.Skin			= 0;
ITEM.Stackable 		= true;
ITEM.RemoveOnUse	= true;

ITEM.OnUse = function( data, ply, n )
	
	if( SERVER ) then
		
		V.STAT.SubStatus( ply, V.STAT.STATUS_DRUNK, 2 );
		V.STAT.AddStatus( ply, V.STAT.STATUS_PANIC, 4 );
		
	else
		
		V.CB.AddToChat( "You drink the brandy.", Color( 0, 190, 33, 255 ), "VCandara20", { 1, 2 } );
		
	end
	
end