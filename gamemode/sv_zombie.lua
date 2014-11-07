V.Z = { };

function V.Z.CreateZombie( pos, norm, t )
	
	local e = ents.Create( "v_zombie" );
	e:SetPos( pos + norm * 4 );
	e:Spawn();
	e:Activate();
	
	if( t ) then
		
		e:SetEnemy( t );
		e:SeeEnemy();
		
	end
	
	return e;
	
end

function V.Z.CreateZombieHorde( p, size, atk )
	
	if( !nav ) then return end
	
	if( V.NAV.Mesh:GetNodeTotal() == 0 ) then return end
	
	local z = p.z;
	local radius = 128;
	local fpos;
	
	for _ = 1, size do -- each zombie to spawn
		
		local ang = math.Rand( 0, 2 * math.pi );
		local s = math.sin( ang );
		local c = math.cos( ang );
		local m = math.random( 32, radius );
		
		local found = false;
		
		local trace = { };
		trace.start = Vector( p.x + s * m, p.y + c * m, p.z );
		trace.endpos = trace.start + Vector( 0, 0, -4096 ); -- todo: spawn zombies above players (??)
		local tr = util.TraceLine( trace );
		
		local pos = V.NAV.Mesh:GetClosestNode( tr.HitPos ):GetPosition();
		local norm = Vector();
		
		for _ = 1, 56 do -- Find somewhere we can spawn the zombie. After 512 units (that's 128 + 56 * 8), stop, it's not a horde anymore.
			
			if( V.Z.CanSpawnZombie( pos ) ) then -- We're good for this one! End the loop and spawn him.
				
				radius = 100;
				found = true;
				break;
				
			end
			
			ang = math.Rand( 0, 2 * math.pi ); -- Didn't find one. Let's determine a new node.
			s = math.sin( ang );
			c = math.cos( ang );
			radius = radius + 8; -- Slightly increase the radius if we didn't find anywhere.
			
			m = math.random( 32, radius );
			
			trace = { };
			trace.start = Vector( p.x + s * m, p.y + c * m, p.z );
			trace.endpos = trace.start + Vector( 0, 0, -4096 );
			tr = util.TraceLine( trace );
			
			pos = V.NAV.Mesh:GetClosestNode( tr.HitPos ):GetPosition();
			norm = V.NAV.Mesh:GetClosestNode( tr.HitPos ):GetNormal();
			
		end
		
		if( found ) then
			
			V.Z.CreateZombie( pos, norm, atk );
			
		end
		
	end
	
end

function V.Z.CreateZombieGroup( nerd, size )
	
	V.Z.CreateZombieHorde( nerd:GetPos(), size, nerd );
	
end

function V.Z.CanSpawnZombie( pos, nolos )
	
	if( V.Nuked ) then return false; end
	
	if( V.Z.GetNumZombies() >= V.Config.MaxZombiesTotal ) then return false end
	
	local c = util.PointContents( pos );
	if( bit.band( c, CONTENTS_SOLID ) == CONTENTS_SOLID ) then return false end -- world, window
	
	local trace = { };
	trace.start = pos;
	trace.endpos = pos + Vector( 0, 0, 64 );
	trace.mins = Vector( -16, -16, 0 );
	trace.maxs = Vector( 16, 16, 1 );
	
	if( !nolos ) then
		
		for _, v in pairs( player.GetAll() ) do
			
			if( v:VisibleVec( pos ) ) then return false end
			if( v:CanSeePos( pos ) ) then return false end
			if( v:CanSeePos( pos + Vector( 0, 0, 72 ) ) ) then return false end
			
		end
		
	end
	
	return true;
	
end

function V.Z.GetZombies()
	
	return ents.FindByClass( "v_zombie" );
	
end

function V.Z.GetNumZombies()
	
	return #V.Z.GetZombies();
	
end

function V.Z.Think()
	
	if( !V.Config.AutoZombieSpawn or !nav or !V.NAV or V.NAV.Generating ) then return end
	
	if( V.Z.GetNumZombies() < V.Config.MaxZombies ) then
		
		if( nav and V.NAV and V.NAV.Mesh and V.NAV.Mesh:GetNodeTotal() > 0 ) then
			
			local node = V.NAV.Mesh:GetNodes()[ math.random( 1, V.NAV.Mesh:GetNodeTotal() ) ];
			local pos = node:GetPosition();
			local norm = node:GetNormal();
			
			if( V.Z.CanSpawnZombie( pos ) ) then
				
				V.Z.CreateZombie( pos, norm );
				
			end
			
		end
		
	end
	
end

function V.Z.GetClosestZombie( pos, r )
	
	local z;
	local least = r or math.huge;
	
	for _, v in pairs( V.Z.GetZombies() ) do
		
		local d = v:GetPos():Distance( pos );
		if( d < least ) then
			
			z = v;
			least = d;
			
		end
		
	end
	
	return z;
	
end

function V.Z.ClearZombies()
	
	for _, v in pairs( V.Z.GetZombies() ) do
		
		v:Remove();
		
	end
	
end

local sharedtasks_e = { }
sharedtasks_e["TASK_INVALID"] = 0
sharedtasks_e["TASK_RESET_ACTIVITY"] = 1
sharedtasks_e["TASK_WAIT"] = 2
sharedtasks_e["TASK_ANNOUNCE_ATTACK"] = 3
sharedtasks_e["TASK_WAIT_FACE_ENEMY"] = 4
sharedtasks_e["TASK_WAIT_FACE_ENEMY_RANDOM"] = 5
sharedtasks_e["TASK_WAIT_PVS"] = 6
sharedtasks_e["TASK_SUGGEST_STATE"] = 7
sharedtasks_e["TASK_TARGET_PLAYER"] = 8
sharedtasks_e["TASK_SCRIPT_WALK_TO_TARGET"] = 9
sharedtasks_e["TASK_SCRIPT_RUN_TO_TARGET"] = 10
sharedtasks_e["TASK_SCRIPT_CUSTOM_MOVE_TO_TARGET"] = 11
sharedtasks_e["TASK_MOVE_TO_TARGET_RANGE"] = 12
sharedtasks_e["TASK_MOVE_TO_GOAL_RANGE"] = 13
sharedtasks_e["TASK_MOVE_AWAY_PATH"] = 14
sharedtasks_e["TASK_GET_PATH_AWAY_FROM_BEST_SOUND"] = 15
sharedtasks_e["TASK_SET_GOAL"] = 16
sharedtasks_e["TASK_GET_PATH_TO_GOAL"] = 17
sharedtasks_e["TASK_GET_PATH_TO_ENEMY"] = 18
sharedtasks_e["TASK_GET_PATH_TO_ENEMY_LKP"] = 19
sharedtasks_e["TASK_GET_CHASE_PATH_TO_ENEMY"] = 20
sharedtasks_e["TASK_GET_PATH_TO_ENEMY_LKP_LOS"] = 21
sharedtasks_e["TASK_GET_PATH_TO_ENEMY_CORPSE"] = 22
sharedtasks_e["TASK_GET_PATH_TO_PLAYER"] = 23
sharedtasks_e["TASK_GET_PATH_TO_ENEMY_LOS"] = 24
sharedtasks_e["TASK_GET_FLANK_RADIUS_PATH_TO_ENEMY_LOS"] = 25
sharedtasks_e["TASK_GET_FLANK_ARC_PATH_TO_ENEMY_LOS"] = 26
sharedtasks_e["TASK_GET_PATH_TO_RANGE_ENEMY_LKP_LOS"] = 27
sharedtasks_e["TASK_GET_PATH_TO_TARGET"] = 28
sharedtasks_e["TASK_GET_PATH_TO_TARGET_WEAPON"] = 29
sharedtasks_e["TASK_CREATE_PENDING_WEAPON"] = 30
sharedtasks_e["TASK_GET_PATH_TO_HINTNODE"] = 31
sharedtasks_e["TASK_STORE_LASTPOSITION"] = 32
sharedtasks_e["TASK_CLEAR_LASTPOSITION"] = 33
sharedtasks_e["TASK_STORE_POSITION_IN_SAVEPOSITION"] = 34
sharedtasks_e["TASK_STORE_BESTSOUND_IN_SAVEPOSITION"] = 35
sharedtasks_e["TASK_STORE_BESTSOUND_REACTORIGIN_IN_SAVEPOSITION"] = 36
sharedtasks_e["TASK_REACT_TO_COMBAT_SOUND"] = 37
sharedtasks_e["TASK_STORE_ENEMY_POSITION_IN_SAVEPOSITION"] = 38
sharedtasks_e["TASK_GET_PATH_TO_COMMAND_GOAL"] = 39
sharedtasks_e["TASK_MARK_COMMAND_GOAL_POS"] = 40
sharedtasks_e["TASK_CLEAR_COMMAND_GOAL"] = 41
sharedtasks_e["TASK_GET_PATH_TO_LASTPOSITION"] = 42
sharedtasks_e["TASK_GET_PATH_TO_SAVEPOSITION"] = 43
sharedtasks_e["TASK_GET_PATH_TO_SAVEPOSITION_LOS"] = 44
sharedtasks_e["TASK_GET_PATH_TO_RANDOM_NODE"] = 45
sharedtasks_e["TASK_GET_PATH_TO_BESTSOUND"] = 46
sharedtasks_e["TASK_GET_PATH_TO_BESTSCENT"] = 47
sharedtasks_e["TASK_RUN_PATH"] = 48
sharedtasks_e["TASK_WALK_PATH"] = 49
sharedtasks_e["TASK_WALK_PATH_TIMED"] = 50
sharedtasks_e["TASK_WALK_PATH_WITHIN_DIST"] = 51
sharedtasks_e["TASK_WALK_PATH_FOR_UNITS"] = 52
sharedtasks_e["TASK_RUN_PATH_FLEE"] = 53
sharedtasks_e["TASK_RUN_PATH_TIMED"] = 54
sharedtasks_e["TASK_RUN_PATH_FOR_UNITS"] = 55
sharedtasks_e["TASK_RUN_PATH_WITHIN_DIST"] = 56
sharedtasks_e["TASK_STRAFE_PATH"] = 57
sharedtasks_e["TASK_CLEAR_MOVE_WAIT"] = 58
sharedtasks_e["TASK_SMALL_FLINCH"] = 59
sharedtasks_e["TASK_BIG_FLINCH"] = 60
sharedtasks_e["TASK_DEFER_DODGE"] = 61
sharedtasks_e["TASK_FACE_IDEAL"] = 62
sharedtasks_e["TASK_FACE_REASONABLE"] = 63
sharedtasks_e["TASK_FACE_PATH"] = 64
sharedtasks_e["TASK_FACE_PLAYER"] = 65
sharedtasks_e["TASK_FACE_ENEMY"] = 66
sharedtasks_e["TASK_FACE_HINTNODE"] = 67
sharedtasks_e["TASK_PLAY_HINT_ACTIVITY"] = 68
sharedtasks_e["TASK_FACE_TARGET"] = 69
sharedtasks_e["TASK_FACE_LASTPOSITION"] = 70
sharedtasks_e["TASK_FACE_SAVEPOSITION"] = 71
sharedtasks_e["TASK_FACE_AWAY_FROM_SAVEPOSITION"] = 72
sharedtasks_e["TASK_SET_IDEAL_YAW_TO_CURRENT"] = 73
sharedtasks_e["TASK_RANGE_ATTACK1"] = 74
sharedtasks_e["TASK_RANGE_ATTACK2"] = 75
sharedtasks_e["TASK_MELEE_ATTACK1"] = 76
sharedtasks_e["TASK_MELEE_ATTACK2"] = 77
sharedtasks_e["TASK_RELOAD"] = 78
sharedtasks_e["TASK_SPECIAL_ATTACK1"] = 79
sharedtasks_e["TASK_SPECIAL_ATTACK2"] = 80
sharedtasks_e["TASK_FIND_HINTNODE"] = 81
sharedtasks_e["TASK_FIND_LOCK_HINTNODE"] = 82
sharedtasks_e["TASK_CLEAR_HINTNODE"] = 83
sharedtasks_e["TASK_LOCK_HINTNODE"] = 84
sharedtasks_e["TASK_SOUND_ANGRY"] = 85
sharedtasks_e["TASK_SOUND_DEATH"] = 86
sharedtasks_e["TASK_SOUND_IDLE"] = 87
sharedtasks_e["TASK_SOUND_WAKE"] = 88
sharedtasks_e["TASK_SOUND_PAIN"] = 89
sharedtasks_e["TASK_SOUND_DIE"] = 90
sharedtasks_e["TASK_SPEAK_SENTENCE"] = 91
sharedtasks_e["TASK_WAIT_FOR_SPEAK_FINISH"] = 92
sharedtasks_e["TASK_SET_ACTIVITY"] = 93
sharedtasks_e["TASK_RANDOMIZE_FRAMERATE"] = 94
sharedtasks_e["TASK_SET_SCHEDULE"] = 95
sharedtasks_e["TASK_SET_FAIL_SCHEDULE"] = 96
sharedtasks_e["TASK_SET_TOLERANCE_DISTANCE"] = 97
sharedtasks_e["TASK_SET_ROUTE_SEARCH_TIME"] = 98
sharedtasks_e["TASK_CLEAR_FAIL_SCHEDULE"] = 99
sharedtasks_e["TASK_PLAY_SEQUENCE"] = 100
sharedtasks_e["TASK_PLAY_PRIVATE_SEQUENCE"] = 101
sharedtasks_e["TASK_PLAY_PRIVATE_SEQUENCE_FACE_ENEMY"] = 102
sharedtasks_e["TASK_PLAY_SEQUENCE_FACE_ENEMY"] = 103
sharedtasks_e["TASK_PLAY_SEQUENCE_FACE_TARGET"] = 104
sharedtasks_e["TASK_FIND_COVER_FROM_BEST_SOUND"] = 105
sharedtasks_e["TASK_FIND_COVER_FROM_ENEMY"] = 106
sharedtasks_e["TASK_FIND_LATERAL_COVER_FROM_ENEMY"] = 107
sharedtasks_e["TASK_FIND_BACKAWAY_FROM_SAVEPOSITION"] = 108
sharedtasks_e["TASK_FIND_NODE_COVER_FROM_ENEMY"] = 109
sharedtasks_e["TASK_FIND_NEAR_NODE_COVER_FROM_ENEMY"] = 110
sharedtasks_e["TASK_FIND_FAR_NODE_COVER_FROM_ENEMY"] = 111
sharedtasks_e["TASK_FIND_COVER_FROM_ORIGIN"] = 112
sharedtasks_e["TASK_DIE"] = 113
sharedtasks_e["TASK_WAIT_FOR_SCRIPT"] = 114
sharedtasks_e["TASK_PUSH_SCRIPT_ARRIVAL_ACTIVITY"] = 115
sharedtasks_e["TASK_PLAY_SCRIPT"] = 116
sharedtasks_e["TASK_PLAY_SCRIPT_POST_IDLE"] = 117
sharedtasks_e["TASK_ENABLE_SCRIPT"] = 118
sharedtasks_e["TASK_PLANT_ON_SCRIPT"] = 119
sharedtasks_e["TASK_FACE_SCRIPT"] = 120
sharedtasks_e["TASK_PLAY_SCENE"] = 121
sharedtasks_e["TASK_WAIT_RANDOM"] = 122
sharedtasks_e["TASK_WAIT_INDEFINITE"] = 123
sharedtasks_e["TASK_STOP_MOVING"] = 124
sharedtasks_e["TASK_TURN_LEFT"] = 125
sharedtasks_e["TASK_TURN_RIGHT"] = 126
sharedtasks_e["TASK_REMEMBER"] = 127
sharedtasks_e["TASK_FORGET"] = 128
sharedtasks_e["TASK_WAIT_FOR_MOVEMENT"] = 129
sharedtasks_e["TASK_WAIT_FOR_MOVEMENT_STEP"] = 130
sharedtasks_e["TASK_WAIT_UNTIL_NO_DANGER_SOUND"] = 131
sharedtasks_e["TASK_WEAPON_FIND"] = 132
sharedtasks_e["TASK_WEAPON_PICKUP"] = 133
sharedtasks_e["TASK_WEAPON_RUN_PATH"] = 134
sharedtasks_e["TASK_WEAPON_CREATE"] = 135
sharedtasks_e["TASK_ITEM_PICKUP"] = 136
sharedtasks_e["TASK_ITEM_RUN_PATH"] = 137
sharedtasks_e["TASK_USE_SMALL_HULL"] = 138
sharedtasks_e["TASK_FALL_TO_GROUND"] = 139
sharedtasks_e["TASK_WANDER"] = 140
sharedtasks_e["TASK_FREEZE"] = 141
sharedtasks_e["TASK_GATHER_CONDITIONS"] = 142
sharedtasks_e["TASK_IGNORE_OLD_ENEMIES"] = 143
sharedtasks_e["TASK_DEBUG_BREAK"] = 144
sharedtasks_e["TASK_ADD_HEALTH"] = 145
sharedtasks_e["TASK_ADD_GESTURE_WAIT"] = 146
sharedtasks_e["TASK_ADD_GESTURE"] = 147
sharedtasks_e["TASK_GET_PATH_TO_INTERACTION_PARTNER"] = 148
sharedtasks_e["TASK_PRE_SCRIPT"] = 149

ai.GetTaskID = function( taskName )

	return sharedtasks_e[taskName]

end