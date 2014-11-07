ITEM.ID 			= "plank";
ITEM.Name 			= "Wood Plank";
ITEM.Weight 		= 5;
ITEM.Model 			= "models/props_debris/wood_board06a.mdl";
ITEM.Skin			= 0;
ITEM.Stackable 		= true;

ITEM.OnUse = function( data, ply, n )
	
	if( SERVER ) then
		
		if( V.I.HasItem( ply, "hammer" ) ) then
			
			local trace = { };
			trace.start = ply:EyePos();
			trace.endpos = trace.start + ply:GetAimVector() * 128;
			trace.filter = ply;
			
			local tr = util.TraceLine( trace );
			
			if( tr.Entity and tr.Entity:IsValid() and tr.Entity:IsDoor() ) then
				
				if( !tr.Entity.Barricades ) then
					
					if( tr.Entity:DoorState() == 0 ) then
						
						tr.Entity.OldDoorDistance = tr.Entity:DoorDistance();
						tr.Entity:Fire( "SetRotationDistance", "5" );
						
						tr.Entity.Barricades = { };
						
						local a = tr.Entity:OBBMins();
						local b = tr.Entity:OBBMaxs();
						
						for i = 1, 3 do
							
							local p = tr.Entity:GetPos() + Vector( 0, 0, 12 + a.z + 24 * i ) + tr.HitNormal * 6 + tr.Entity:GetRight() * -32;
							
							local b = ents.Create( "v_plank" );
							b:SetPos( p );
							b:SetAngles( tr.Entity:GetAngles() + Angle( 0, 0, 90 + math.random( -10, 10 ) ) );
							b:Spawn();
							b:SetDoor( tr.Entity );
							
						end
						
						tr.Entity:EmitSound( "physics/wood/wood_plank_impact_hard" .. math.random( 1, 5 ) .. ".wav" );
						
						V.I.RemoveItem( ply, data.ID, 1, true );
						
					end
					
				end
				
			end
			
		end
		
	else
		
		if( !V.I.HasItem( ply, "hammer" ) ) then
			
			V.CB.AddToChat( "You need a hammer for this.", Color( 200, 0, 0, 255 ), "VCandara20", { 1, 2 } );
			
		end
		
	end
	
end