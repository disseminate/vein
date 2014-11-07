ITEM.ID 			= "orange";
ITEM.Name 			= "Orange";
ITEM.Weight 		= 1;
ITEM.Model 			= "models/props/cs_italy/orange.mdl";
ITEM.Skin			= 0;
ITEM.Stackable 		= true;
ITEM.RemoveOnUse	= true;

ITEM.OnUse = function( data, ply, n )
	
	if( SERVER ) then
		
		V.STAT.AddStatus( ply, V.STAT.STATUS_HUNGER, 1 );
		
	else
		
		V.CB.AddToChat( "You eat the orange.", Color( 0, 190, 33, 255 ), "VCandara20", { 1, 2 } );
		
	end
	
end