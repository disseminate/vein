function V.I.CreateEnt( pos, ang, id )
	
	local e = ents.Create( "v_item" );
	e:SetPos( pos );
	e:SetAngles( ang );
	e:Spawn();
	e:SetItem( id );
	
	return e;
	
end

function V.I.CheckWeaponFlashlight( ply )
	
	if( ply:GetActiveWeapon() != NULL and ply:GetActiveWeapon().TwoHanded ) then
		
		if( ply:FlashlightIsOn() ) then
			
			ply:Flashlight( false );
			
		end
		
	end
	
end

function V.I.QueueWeapon( ply, class )
	
	if( ply:GetActiveWeapon() and ply:GetActiveWeapon() != NULL ) then
		
		ply:GetActiveWeapon():HolsterAnim();
		
	end
	
	if( ply.Sitting ) then return end
	if( ply.Asleep ) then return end
	
	ply.WeaponQueued = class;
	
end

function V.I.WeaponThink()
	
	for _, v in pairs( player.GetAll() ) do
		
		if( #v:GetWeapons() == 0 and v.WeaponQueued ) then
			
			v:Give( v.WeaponQueued );
			local tab = weapons.Get( v.WeaponQueued );
			
			v:GetViewModel():SetModel( tab.ViewModel );
			v:GetActiveWeapon():Deploy();
			
			v.WeaponQueued = nil;
			V.I.CheckWeaponFlashlight( v );
			
		end
		
	end
	
end