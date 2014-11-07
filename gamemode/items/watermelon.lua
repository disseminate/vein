ITEM.ID 			= "watermelon";
ITEM.Name 			= "Watermelon";
ITEM.Weight 		= 4;
ITEM.Model 			= "models/props_junk/watermelon01.mdl";
ITEM.Skin			= 0;
ITEM.RemoveOnUse	= true;
ITEM.RemoveOnUse	= true;

ITEM.OnUse = function( data, ply, n )
	
	if( SERVER ) then
		
		V.STAT.AddStatus( ply, V.STAT.STATUS_HUNGER, 4 );
		
	else
		
		V.CB.AddToChat( "You eat the watermelon. You must have been pretty hungry.", Color( 0, 190, 33, 255 ), "VCandara20", { 1, 2 } );
		
	end
	
end