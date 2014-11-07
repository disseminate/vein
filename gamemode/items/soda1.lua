ITEM.ID 			= "soda1";
ITEM.Name 			= "Soda";
ITEM.Weight 		= 1;
ITEM.Model 			= "models/props_junk/PopCan01a.mdl";
ITEM.Skin			= 0;
ITEM.Stackable 		= true;
ITEM.RemoveOnUse	= true;

ITEM.OnUse = function( data, ply, n )
	
	if( SERVER ) then
		
		V.STAT.AddStatus( ply, V.STAT.STATUS_HUNGER, 1 );
		
	else
		
		V.CB.AddToChat( "You open and drink the soda.", Color( 0, 190, 33, 255 ), "VCandara20", { 1, 2 } );
		
	end
	
end