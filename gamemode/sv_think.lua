function GM:Think()
	
	V.STAT.Think();
	V.I.WeaponThink();
	V.I.ContainerThink();
	GAMEMODE:PlayerMoveThink();
	V.Z.Think();
	V.ME.Think();
	V.AnimThink();
	V.NukeThink();
	V.W.Think();
	
	for _, v in pairs( player.GetBots() ) do
		
		V.BotThink( v );
		
	end
	
end