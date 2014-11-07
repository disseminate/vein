function ENT:SelectSchedule( iNPCState )
	
	self:SetSchedule( SCHED_IDLE_STAND );
	
end

ENT.TalkToPlayer = ai_schedule.New( "TalkToPlayer" );
ENT.TalkToPlayer:EngTask( "TASK_FACE_PLAYER", 1 );