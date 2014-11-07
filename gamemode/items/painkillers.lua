ITEM.ID 			= "painkillers";
ITEM.Name 			= "Painkillers";
ITEM.Weight 		= 1;
ITEM.Model 			= "models/props_lab/jar01a.mdl";
ITEM.Skin			= 0;
ITEM.Stackable 		= true;
ITEM.RemoveOnUse	= true;
ITEM.UseSounds		= {
	"player/items/pain_pills/pills_deploy_1.wav",
	"player/items/pain_pills/pills_deploy_2.wav",
	"player/items/pain_pills/pills_deploy_3.wav",
};

ITEM.OnUse = function( data, ply, n )
	
	if( SERVER ) then
		
		V.STAT.AddStatus( ply, V.STAT.STATUS_PAIN, 1 );
		
	else
		
		V.CB.AddToChat( "You down the painkillers.", Color( 0, 190, 33, 255 ), "VCandara20", { 1, 2 } );
		
	end
	
end