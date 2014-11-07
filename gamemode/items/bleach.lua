ITEM.ID 			= "bleach";
ITEM.Name 			= "Bleach";
ITEM.Weight 		= 1;
ITEM.Model 			= "models/props_junk/garbage_plasticbottle001a.mdl";
ITEM.Skin			= 0;
ITEM.Stackable 		= true;

ITEM.OnUse = function( data, ply, n )
	
	if( CLIENT ) then
		
		V.CB.AddToChat( "It probably wouldn't be a good idea to drink this.", Color( 200, 0, 0, 255 ), "VCandara20", { 1, 2 } );
		
	end
	
end