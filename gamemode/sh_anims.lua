function GM:CalcMainActivity( ply, velocity )
	
	ply.CalcIdeal = ACT_MP_STAND_IDLE;
	ply.CalcSeqOverride = -1;
	
	local spd = velocity:Length2D();
	
	if( GAMEMODE:HandlePlayerJumping( ply, velocity ) ) then
		
	elseif( ply:Crouching() ) then
		
		if( spd > 0.5 ) then
			
			ply.CalcIdeal = ACT_MP_CROUCHWALK;
			
		else
			
			ply.CalcIdeal = ACT_MP_CROUCH_IDLE;
			
		end
		
	else
		
		if( spd > 150 ) then
			
			ply.CalcIdeal = ACT_MP_RUN;
			
		elseif( spd > 0.5 ) then
			
			ply.CalcIdeal = ACT_MP_WALK;
			
		end
		
	end
	
	if( ply:WaterLevel() >= 2 ) then
		
		ply.CalcIdeal = ACT_MP_SWIM;
		
	end
	
	if( ply:GetMoveType() == 8 ) then
		
		ply.CalcIdeal = ACT_FLY;
		
	end
	
	-- a bit of a hack because we're missing ACTs for a couple holdtypes
	local weapon = ply:GetActiveWeapon()
	
	if ply.CalcIdeal == ACT_MP_CROUCH_IDLE &&
		IsValid(weapon) &&
		( weapon:GetHoldType() == "knife" || weapon:GetHoldType() == "melee2" ) then
		
		ply.CalcSeqOverride = ply:LookupSequence("cidle_" .. weapon:GetHoldType())
	end
	
	if( ( ply.Asleep and ply.Bed and ply.Bed:IsValid() ) or ( CLIENT and V.DEV.BedDev ) ) then
		
		ply.CalcSeqOverride = ply:LookupSequence( "Lying_Down" );
		
	end
	
	if( ply.Sitting and ply.Chair and ply.Chair:IsValid() ) then
		
		ply.CalcSeqOverride = ply:LookupSequence( "sit" );
		
	end
	
	if( table.HasValue( V.ZombieModels, ply:GetModel() ) ) then
		
		local a, b = V.CalcZombieActivity( ply, velocity );
		return a, b;
		
	end
	
	return ply.CalcIdeal, ply.CalcSeqOverride;

end

function V.CalcZombieActivity( ply, vel )
	
	local spd = vel:Length2D();
	
	if( spd > 210 ) then
		
		return ACT_RUN, -1;
		
	elseif( spd > 0.5 ) then
		
		return ACT_WALK, -1;
		
	end
	
	return ACT_IDLE, -1;
	
end

function GM:UpdateAnimation( ply, vel, maxspeed )
	
	local len = vel:Length2D();
	local movefactor = len / 600;
	ply:SetPoseParameter( "move_factor", movefactor );
	
	if( CLIENT ) then
		
		if( V.DEV.BedDev ) then
			
			ply.Bed = ply:GetEyeTrace().Entity;
			
		end
		
		if( ( ply.Asleep or V.DEV.BedDev ) and ply.Bed and ply.Bed:IsValid() ) then
			
			local data = V.ME.BedData[ply.Bed:GetModel()];
			
			if( data ) then
				
				ply:SetPos( ply.Bed:GetPos() + ply.Bed:GetForward() * data[1].x + ply.Bed:GetRight() * data[1].y + ply.Bed:GetUp() * data[1].z );
				ply:SetRenderAngles( ply.Bed:GetAngles() + data[2] );
				
			else
				
				ply:SetPos( ply.Bed:GetPos() );
				ply:SetRenderAngles( ply.Bed:GetAngles() + Angle( 0, 90, 0 ) );
				
			end
			
		end
		
		if( ply.Sitting and ply.Chair and ply.Chair:IsValid() ) then
			
			local data = V.ME.ChairData[ply.Chair:GetModel()];
			
			if( data ) then
				
				ply:SetPos( ply.Chair:GetPos() + ply.Chair:GetForward() * data[1].x + ply.Chair:GetRight() * data[1].y + ply.Chair:GetUp() * data[1].z );
				ply:SetRenderAngles( ply.Chair:GetAngles() + data[2] );
				
			else
				
				ply:SetPos( ply.Chair:GetPos() );
				ply:SetRenderAngles( ply.Chair:GetAngles() + Angle( 0, 90, 0 ) );
				
			end
			
		end
		
	end
	
	self.BaseClass:UpdateAnimation( ply, vel, maxspeed );
	
end

function V.DoVCDGesture( ply, gest )
	
	if( !ply:GetActiveWeapon() or ply:GetActiveWeapon() == NULL ) then
		
		ply:AddVCDSequenceToGestureSlot( GESTURE_SLOT_CUSTOM, ply:LookupSequence( gest ), 0, true );
		
	end
	
end

function V.EnterChair( len )
	
	if( SERVER ) then return end
	
	local ply = net.ReadEntity();
	local chair = net.ReadEntity();
	
	if( ply == LocalPlayer() ) then
		
		V.EF.CurPos = chair:GetPos() - ply:GetForward() * 100;
		
	end
	
	ply.Sitting = true;
	ply.Chair = chair;
	chair.Occupant = ply;
	
end
net.Receive( "nEnterChair", V.EnterChair );

function V.ExitChair( len )
	
	if( SERVER ) then return end
	
	local ply = net.ReadEntity();
	local chair = net.ReadEntity();
	
	ply.Sitting = false;
	ply.Chair = nil;
	chair.Occupant = nil;
	
end
net.Receive( "nExitChair", V.ExitChair );

local IdleActivityTranslate = { }
IdleActivityTranslate[ ACT_MP_STAND_IDLE ] 					= ACT_HL2MP_IDLE;
IdleActivityTranslate[ ACT_MP_WALK ] 						= ACT_HL2MP_WALK;
IdleActivityTranslate[ ACT_MP_RUN ] 						= ACT_HL2MP_RUN;
IdleActivityTranslate[ ACT_MP_CROUCH_IDLE ] 				= ACT_HL2MP_IDLE_CROUCH;
IdleActivityTranslate[ ACT_MP_CROUCHWALK ] 					= ACT_HL2MP_WALK_CROUCH;
IdleActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= ACT_HL2MP_GESTURE_RANGE_ATTACK;
IdleActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= ACT_HL2MP_GESTURE_RANGE_ATTACK;
IdleActivityTranslate[ ACT_MP_RELOAD_STAND ]		 		= ACT_HL2MP_GESTURE_RELOAD;
IdleActivityTranslate[ ACT_MP_RELOAD_CROUCH ]		 		= ACT_HL2MP_GESTURE_RELOAD;
IdleActivityTranslate[ ACT_MP_JUMP ] 						= ACT_HL2MP_JUMP_SLAM;
IdleActivityTranslate[ ACT_MP_SWIM_IDLE ] 					= ACT_HL2MP_SWIM;
IdleActivityTranslate[ ACT_MP_SWIM ] 						= ACT_HL2MP_SWIM;

local MeleeIndex = {
	[ "pistol" ] 		= ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND,
	[ "revolver" ] 		= ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND,
	[ "smg" ] 			= ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND,
	[ "grenade" ] 		= nil,
	[ "ar2" ] 			= ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND,
	[ "shotgun" ] 		= ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND,
	[ "rpg" ]	 		= ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND,
	[ "gravgun" ] 		= ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND,
	[ "crossbow" ] 		= ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND,
	[ "melee" ] 		= nil,
	[ "slam" ] 			= nil,
	[ "normal" ]		= nil,
	[ "fist" ]			= nil,
	[ "melee2" ]		= nil,
	[ "passive" ]		= nil,
	[ "knife" ]			= nil,
	[ "camera" ]		= nil,
	[ "duel" ]			= ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND,
	[ "magic" ]			= nil,
	[ "zombie" ]		= nil,
}

function GM:TranslateActivity( ply, act )
	
	local act = act;
	local newact = ply:TranslateWeaponActivity( act );
	
	if( act == newact ) then
		return IdleActivityTranslate[ act ];
	end
	
	return newact;
	
end

function V.AnimThink()
	
	for _, v in pairs( player.GetAll() ) do
		
		if( v.SpeechEndTime and CurTime() <= v.SpeechEndTime ) then
			
			if( !v.WordEndTime or v.WordEndTime < CurTime() ) then
				
				local selected = table.Random( v.SpeechTab );
				
				local seq = selected[3];
				local time = selected[4];
				
				v.WordEndTime = CurTime() + time;
				
				V.DoVCDGesture( v, seq );
				
			end
			
		end
		
	end
	
end

V.ChatGestures = { };
V.SpecialGestures = { };

function V.AddNewChatGesture( mode, gender, seq, len )
	
	table.insert( V.ChatGestures, { mode, gender, seq, len } );
	
end

function V.AddSpecialGestureLine( me, seq )
	
	table.insert( V.SpecialGestures, { me, seq } );
	
end

table.insert( V.SpecialGestures, { "kamerninuos", "kam_sraghfronch" } );

function GM:DoChatGestures( ply, cmd, text )
	
	local tab = { };
	local f = ply:IsFemale();
	
	for _, v in pairs( V.ChatGestures ) do
		
		if( f and bit.band( v[2], 1 ) != 1 ) then continue end
		if( !f and bit.band( v[2], 2 ) != 2 ) then continue end
		
		if( cmd == 0 ) then -- Local
			
			if( bit.band( v[1], 1 ) == 1 ) then
				
				table.insert( tab, v );
				
			end
			
		elseif( cmd == 1 ) then -- Yell
			
			if( bit.band( v[1], 2 ) == 2 ) then
				
				table.insert( tab, v );
				
			end
			
		elseif( cmd == 2 ) then -- Whisper
			
			if( bit.band( v[1], 4 ) == 4 ) then
				
				table.insert( tab, v );
				
			end
			
		end
		
	end
	
	if( #tab > 0 ) then
		
		local t = string.len( text ) / 10;
		
		ply.SpeechEndTime = CurTime() + t;
		ply.SpeechTab = tab;
		
	end
	
end
