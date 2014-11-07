V.W = { };

V.W.IsNight = false;
V.W.TurnOnAtNight = { };
V.W.TurnOffAtNight = { };

function V.W.InitPostEntity()
	
	if( SERVER ) then
	
		local fog = ents.FindByClass( "env_fog_controller" )[1];
		local sky = ents.FindByClass( "sky_camera" )[1];
		local spt = ents.FindByClass( "env_skypaint" )[1];
		
		if( fog and fog:IsValid() ) then
			V.W.FogSettings = fog:GetKeyValues();
		end
		
		if( sky and sky:IsValid() ) then
			V.W.SkySettings = sky:GetKeyValues();
		end
		
		if( spt and spt:IsValid() ) then
			V.W.SkyPaintSettings = spt:GetKeyValues();
		end
		
	end
	
end

function V.W.Night()
	
	V.W.IsNight = true;
	
	if( CLIENT ) then return end
	
	for _, v in pairs( V.W.TurnOnAtNight ) do
		
		local tab = ents.FindByName( v );
		for _, n in pairs( tab ) do
			
			n:Fire( "TurnOn", "", 0 );
			
		end
		
	end
	
	for _, v in pairs( V.W.TurnOffAtNight ) do
		
		local tab = ents.FindByName( v );
		for _, n in pairs( tab ) do
			
			n:Fire( "TurnOff", "", 0 );
			
		end
		
	end
	
	for _, v in pairs( ents.FindByClass( "env_sun" ) ) do
		
		v:Fire( "TurnOff", "", 0 );
		
	end
	
	for _, v in pairs( ents.FindByClass( "light_environment" ) ) do
		
		v:Fire( "TurnOff", "", 0 );
		
	end
	
end

function V.W.Day()
	
	V.W.IsNight = false;
	
	if( CLIENT ) then return end
	
	for _, v in pairs( V.W.TurnOnAtNight ) do
		
		local tab = ents.FindByName( v );
		for _, n in pairs( tab ) do
			
			n:Fire( "TurnOff", "", 0 );
			
		end
		
	end
	
	for _, v in pairs( V.W.TurnOffAtNight ) do
		
		local tab = ents.FindByName( v );
		for _, n in pairs( tab ) do
			
			n:Fire( "TurnOn", "", 0 );
			
		end
		
	end
	
	for _, v in pairs( ents.FindByClass( "env_sun" ) ) do
		
		v:Fire( "TurnOn", "", 0 );
		
	end
	
	for _, v in pairs( ents.FindByClass( "light_environment" ) ) do
		
		v:Fire( "TurnOn", "", 0 );
		
	end
	
end

V.W.Raining = false;

if( CLIENT ) then
	
	function V.W.nSetRain()
		
		V.W.Raining = tobool( net.ReadFloat() );
		
	end
	net.Receive( "nSetRain", V.W.nSetRain );

	function V.W.Think()
		
		if( V.W.Raining ) then
			
			local pos = LocalPlayer():GetPos();
			local drop = EffectData();
				drop:SetOrigin( pos );
				drop:SetMagnitude( 512 );
				drop:SetRadius( 80 );
			util.Effect( "v_rain", drop );
			
		end
		
	end
	
else
	
	function V.W.Initialize()
		
		V.W.NextToggleRain = math.random( V.Config.MinRainToggleTime, V.Config.MaxRainToggleTime );
		
	end
	
	function V.W.SetRain( b )
		
		V.W.Raining = b;
		
		net.Start( "nSetRain" );
			net.WriteFloat( b and 1 or 0 );
		net.Broadcast();
		
	end
	
	function V.W.Think()
		
		if( V.Config.RainAuto ) then
			
			if( CurTime() > V.W.NextToggleRain ) then
				
				V.W.SetRain( !V.W.Raining );
				V.W.NextToggleRain = CurTime() + math.random( V.Config.MinRainToggleTime, V.Config.MaxRainToggleTime );
				
			end
			
		end
		
		for _, v in pairs( player.GetAll() ) do
			
			if( v.BittenTime ) then
				
				v.StartOutside = nil;
				continue;
				
			end
			
			if( V.Outside( v:GetPos() ) and V.W.Raining and !v:IsEFlagSet( EFL_NOCLIP_ACTIVE ) ) then
				
				if( !v.StartOutside ) then v.StartOutside = CurTime() end
				
				if( CurTime() - v.StartOutside > 240 ) then
					
					if( V.STAT.GetStatus( v, V.STAT.STATUS_SICK > -4 ) ) then
						
						V.STAT.SetStatus( v, V.STAT.STATUS_SICK, -4 );
						
					end
					
				elseif( CurTime() - v.StartOutside > 180 ) then
					
					if( V.STAT.GetStatus( v, V.STAT.STATUS_SICK > -3 ) ) then
						
						V.STAT.SetStatus( v, V.STAT.STATUS_SICK, -3 );
						
					end
					
				elseif( CurTime() - v.StartOutside > 120 ) then
					
					if( V.STAT.GetStatus( v, V.STAT.STATUS_SICK > -2 ) ) then
						
						V.STAT.SetStatus( v, V.STAT.STATUS_SICK, -2 );
						
					end
					
				elseif( CurTime() - v.StartOutside > 60 ) then
					
					if( V.STAT.GetStatus( v, V.STAT.STATUS_SICK > -1 ) ) then
						
						V.STAT.SetStatus( v, V.STAT.STATUS_SICK, -1 );
						
					end
					
				end
				
			else
				
				v.StartOutside = nil;
				
			end
			
		end
		
	end
	
end