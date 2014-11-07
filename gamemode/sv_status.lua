V.STAT = { };

V.STAT.STATUS_HUNGER = 1;
V.STAT.STATUS_EXHAUSTION = 2;
V.STAT.STATUS_SLEEP = 3;
V.STAT.STATUS_PANIC = 4;
V.STAT.STATUS_ZOMBIE = 5;
V.STAT.STATUS_INJURED = 6;
V.STAT.STATUS_PAIN = 7;
V.STAT.STATUS_DRUNK = 8;
V.STAT.STATUS_DEAD = 9;
V.STAT.STATUS_ZOMBIFIED = 10;
V.STAT.STATUS_SICK = 11;

-- Name, decay amount, decay time (seconds), min, max, default amount
V.STAT.List = { };
V.STAT.List[V.STAT.STATUS_HUNGER] = { "Hunger", -1, 1200, -4, 4, 0 };
V.STAT.List[V.STAT.STATUS_EXHAUSTION] = { "Exhaustion", 0, math.huge, -4, 0, 0 };
V.STAT.List[V.STAT.STATUS_SLEEP] = { "Sleep", -1, 1200, -4, 0, 0 };
V.STAT.List[V.STAT.STATUS_PANIC] = { "Panic", 1, 60, -4, 0, 0 };
V.STAT.List[V.STAT.STATUS_ZOMBIE] = { "Sickness", 0, math.huge, -4, 0, 0 };
V.STAT.List[V.STAT.STATUS_INJURED] = { "Injured", 0, math.huge, -4, 0, 0 };
V.STAT.List[V.STAT.STATUS_PAIN] = { "Pain", 1, 200, -4, 0, 0 };
V.STAT.List[V.STAT.STATUS_DRUNK] = { "Inebriation", 1, 180, -4, 0, 0 };
V.STAT.List[V.STAT.STATUS_DEAD] = { "Dead", 0, math.huge, -1, 0, 0 };
V.STAT.List[V.STAT.STATUS_ZOMBIFIED] = { "Zombie", 0, math.huge, -1, 0, 0 };
V.STAT.List[V.STAT.STATUS_SICK] = { "Sick", 1, 200, -4, 0, 0 };

function V.STAT.Init( ply )
	
	for k, v in pairs( V.STAT.List ) do
		
		ply.Status[k] = V.STAT.List[k][6];
		ply.StatusUpdate[k] = CurTime() + V.STAT.List[k][3];
		
	end
	
end

function V.STAT.SendAllStatus( ply )
	
	for k, v in pairs( ply.Status ) do
		
		net.Start( "nStatSync" );
			net.WriteFloat( k );
			net.WriteFloat( v );
		net.Send( ply );
		
	end
	
end

function V.STAT.SendStatus( ply, stat )
	
	net.Start( "nStatSync" );
		net.WriteFloat( stat );
		net.WriteFloat( ply.Status[stat] );
	net.Send( ply );
	
end

function V.STAT.OnUpdate( ply, stat )
	
	V.SQL.SaveStatus( ply );
	V.STAT.SendStatus( ply, stat );
	
end

function V.STAT.GetStatus( ply, stat )
	
	if( !ply.Status ) then return 0 end
	if( !ply.Status[stat] ) then return 0 end
	return ply.Status[stat];
	
end

function V.STAT.AddStatus( ply, stat, amt )
	
	amt = amt or 1;
	
	if( !ply.Status ) then return end
	if( !ply.Status[stat] ) then return end
	
	ply.Status[stat] = math.min( V.STAT.GetStatus( ply, stat ) + amt, V.STAT.List[stat][5] );
	ply.StatusUpdate[stat] = V.GetCharTime( ply ) + V.STAT.List[stat][3];
	
	V.STAT.OnUpdate( ply, stat );
	
end

function V.STAT.SubStatus( ply, stat, amt )
	
	amt = amt or 1;
	
	if( !ply.Status ) then return end
	if( !ply.Status[stat] ) then return end
	
	ply.Status[stat] = math.max( V.STAT.GetStatus( ply, stat ) - amt, V.STAT.List[stat][4] );
	ply.StatusUpdate[stat] = V.GetCharTime( ply ) + V.STAT.List[stat][3];
	
	V.STAT.OnUpdate( ply, stat );
	
end

function V.STAT.SetStatus( ply, stat, amt )
	
	amt = amt or V.STAT.List[k][6];
	
	ply.Status[stat] = math.Clamp( amt, V.STAT.List[stat][4], V.STAT.List[stat][5] );
	ply.StatusUpdate[stat] = V.GetCharTime( ply ) + V.STAT.List[stat][3];
	
	V.STAT.OnUpdate( ply, stat );
	
end

function V.STAT.Think()
	
	for _, v in pairs( player.GetAll() ) do
		
		if( v.Asleep ) then
			
			if( !v.SendAsleep ) then
				
				net.Start( "nStartSleep" );
					net.WriteEntity( v );
					net.WriteEntity( v.Bed );
				net.Broadcast();
				
			end
			
			if( CurTime() >= v.AsleepTime ) then
				
				v.Asleep = nil;
				v.AsleepTime = nil;
				v.SendAsleep = nil;
				v.Bed = nil;
				
				V.STAT.AddStatus( v, V.STAT.STATUS_SLEEP, 2 );
				V.STAT.SubStatus( v, V.STAT.STATUS_HUNGER, 2 );
				
				net.Start( "nStopSleep" );
					net.WriteEntity( v );
				net.Broadcast();
				
			end
			
		end
		
		if( !v.Status ) then continue; end
		
		V.STAT.UpdateZombie( v );
		V.STAT.UpdateHealth( v );
		V.STAT.Cough( v );
		
		for k, s in pairs( v.Status ) do
			
			if( v:Alive() and V.GetCharTime( v ) > v.StatusUpdate[k] ) then
				
				v.Status[k] = math.Clamp( s + V.STAT.List[k][2], V.STAT.List[k][4], V.STAT.List[k][5] );
				v.StatusUpdate[k] = V.GetCharTime( v ) + V.STAT.List[k][3];
				
				V.STAT.OnUpdate( v, k );
				
			end
			
		end
		
	end
	
end

function V.STAT.Death( ply )
	
	V.STAT.SetStatus( ply, V.STAT.STATUS_HUNGER, 0 );
	V.STAT.SetStatus( ply, V.STAT.STATUS_EXHAUSTION, 0 );
	V.STAT.SetStatus( ply, V.STAT.STATUS_SLEEP, 0 );
	V.STAT.SetStatus( ply, V.STAT.STATUS_PANIC, 0 );
	V.STAT.SetStatus( ply, V.STAT.STATUS_PAIN, 0 );
	V.STAT.SetStatus( ply, V.STAT.STATUS_DRUNK, 0 );
	V.STAT.SetStatus( ply, V.STAT.STATUS_ZOMBIE, 0 );
	V.STAT.SetStatus( ply, V.STAT.STATUS_SICK, 0 );
	
end

function V.STAT.Panic( ply )
	
	V.STAT.SetStatus( ply, V.STAT.STATUS_PANIC, -4 );
	
end

function V.STAT.GetZombieState( dt )
	
	local d = V.Config.ZombieTurnTime / 5;
	
	if( dt > 5 * d ) then
		
		return -5;
		
	elseif( dt > 4 * d ) then
		
		return -4;
		
	elseif( dt > 3 * d ) then
		
		return -3;
		
	elseif( dt > 2 * d ) then
		
		return -2;
		
	elseif( dt > d ) then
		
		return -1;
		
	else
		
		return 0;
		
	end
	
end

function V.STAT.UpdateZombie( ply )
	
	if( ply:Alive() and ply.BittenTime ) then
		
		local dt = V.GetCharTime( ply ) - ply.BittenTime;
		
		if( V.STAT.GetStatus( ply, V.STAT.STATUS_ZOMBIE ) != V.STAT.GetZombieState( dt ) ) then
			
			if( V.STAT.GetZombieState( dt ) < -4 ) then
				
				ply:Kill();
				ply.BittenTime = nil;
				
			else
				
				V.STAT.SetStatus( ply, V.STAT.STATUS_ZOMBIE, V.STAT.GetZombieState( dt ) );
				
			end
			
		end
		
	else
		
		if( V.Config.InfectedWater and ply:WaterLevel() == 3 and !ply:IsEFlagSet( EFL_NOCLIP_ACTIVE ) and V.GetCharTime( ply ) >= V.Config.CharacterSafeTime ) then
			
			ply.BittenTime = V.GetCharTime( ply );
			
		end
		
	end
	
end

function V.STAT.Cough( ply )
	
	if( V.STAT.GetStatus( ply, V.STAT.STATUS_SICK ) >= 0 and V.STAT.GetStatus( ply, V.STAT.STATUS_ZOMBIE ) >= 0 ) then
		
		ply.NextCough = nil;
		return;
		
	end
	
	if( !ply.NextCough ) then
		
		ply.NextCough = CurTime() + math.random( 40, 80 );
		
	end
	
	if( CurTime() > ply.NextCough and !ply:IsEFlagSet( EFL_NOCLIP_ACTIVE ) ) then
		
		ply.NextCough = CurTime() + math.random( 40, 80 );
		
		local p = 100;
		
		if( ply:IsFemale() ) then
			
			p = 120;
			
		end
		
		ply:EmitSound( Sound( "ambient/voices/cough" .. tostring( math.random( 1, 4 ) ) .. ".wav" ), 100, p );
		
		for _, v in pairs( V.Z.GetZombies() ) do
			
			v:HearPlayer( ply, 256 );
			
		end
		
	end
	
end

function V.STAT.UpdateHealth( ply )
	
	local l = 0;
	
	if( ply:Health() >= 100 ) then
		
		l = 0;
		
	elseif( ply:Health() >= 75 ) then
		
		l = -1;
		
	elseif( ply:Health() >= 50 ) then
		
		l = -2;
		
	elseif( ply:Health() > 25 ) then
		
		l = -3;
		
	else
		
		l = -4;
		
	end
	
	if( !ply:Alive() ) then
		
		l = 0;
		
	end
	
	if( V.STAT.GetStatus( ply, V.STAT.STATUS_INJURED ) != l ) then
		
		V.STAT.SetStatus( ply, V.STAT.STATUS_INJURED, l );
		
	end
	
	if( !ply:Alive() and V.GetCharTime( ply ) >= V.Config.CharacterSafeTime ) then
		
		if( ply.MyZombie and ply.MyZombie:IsValid() ) then
			
			if( V.STAT.GetStatus( ply, V.STAT.STATUS_ZOMBIFIED ) != -1 ) then
				V.STAT.SetStatus( ply, V.STAT.STATUS_ZOMBIFIED, -1 );
			end
			if( V.STAT.GetStatus( ply, V.STAT.STATUS_DEAD ) != 0 ) then
				V.STAT.SetStatus( ply, V.STAT.STATUS_DEAD, 0 );
			end
			
		else
			
			if( V.STAT.GetStatus( ply, V.STAT.STATUS_ZOMBIFIED ) != 0 ) then
				V.STAT.SetStatus( ply, V.STAT.STATUS_ZOMBIFIED, 0 );
			end
			if( V.STAT.GetStatus( ply, V.STAT.STATUS_DEAD ) != -1 ) then
				V.STAT.SetStatus( ply, V.STAT.STATUS_DEAD, -1 );
			end
			
		end
		
	end
	
end