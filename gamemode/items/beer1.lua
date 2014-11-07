ITEM.ID 			= "beer1";
ITEM.Name 			= "Beer";
ITEM.Weight 		= 1;
ITEM.Model 			= "models/props_junk/garbage_glassbottle003a.mdl";
ITEM.Skin			= 0;
ITEM.Stackable 		= true;
ITEM.RemoveOnUse	= true;

ITEM.OnUse = function( data, ply, n )
	
	if( SERVER ) then
		
		V.STAT.SubStatus( ply, V.STAT.STATUS_DRUNK, 1 );
		V.STAT.AddStatus( ply, V.STAT.STATUS_PANIC, 2 );
		
		V.I.GiveItem( ply, "bottle1", 1 );
		
	else
		
		V.CB.AddToChat( "You drink the beer.", Color( 0, 190, 33, 255 ), "VCandara20", { 1, 2 } );
		
		V.I.GiveItem( ply, "bottle1", 1 );
		
	end
	
end