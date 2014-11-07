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

-- Name, default amount, icon, text
V.STAT.List = { };
V.STAT.List[V.STAT.STATUS_HUNGER] = { "Hunger", 0, "icon16/vein/cutlery.png", { "Starving", "Famished", "Hungry", "Peckish", "", "Lightly Fed", "Well-Fed", "Heavily Fed", "Stuffed" } };
V.STAT.List[V.STAT.STATUS_EXHAUSTION] = { "Exhaustion", 0, "icon16/vein/water.png", { "Out of Breath", "Excessive Exertion", "High Exertion", "Exertion", "Caught Breath", "", "", "", "" } };
V.STAT.List[V.STAT.STATUS_SLEEP] = { "Sleep", 0, "icon16/vein/eye-half.png", { "Exhausted", "Very Tired", "Tired", "Drowsy", "Awake", "", "", "", "" } };
V.STAT.List[V.STAT.STATUS_PANIC] = { "Panic", 0, "icon16/vein/brain--exclamation.png", { "Terrified", "Panicked", "Scared", "Frightened", "Calm", "", "", "", "" } };
V.STAT.List[V.STAT.STATUS_ZOMBIE] = { "Sickness", 0, "icon16/vein/bug.png", { "Terminal", "Nauseous", "Sick", "Under the Weather", "Healthy", "", "", "", "" } };
V.STAT.List[V.STAT.STATUS_INJURED] = { "Injured", 0, "icon16/vein/target.png", { "Crippled", "Injured", "Hurt", "Nicked", "Healthy", "", "", "", "" } };
V.STAT.List[V.STAT.STATUS_PAIN] = { "Pain", 0, "icon16/vein/pin.png", { "Agony", "Stinging Pain", "Pain", "Throbbing", "Fine", "", "", "", "" } };
V.STAT.List[V.STAT.STATUS_DRUNK] = { "Inebriation", 0, "icon16/vein/beer.png", { "Shitfaced", "Wasted", "Drunk", "Tipsy", "Sober", "", "", "", "" } };
V.STAT.List[V.STAT.STATUS_DEAD] = { "Dead", 0, "icon16/vein/skull.png", { "", "", "", "Dead", "", "", "", "", "" } };
V.STAT.List[V.STAT.STATUS_ZOMBIFIED] = { "Zombie", 0, "icon16/vein/skull-mad.png", { "", "", "", "Zombie", "", "", "", "", "" } };
V.STAT.List[V.STAT.STATUS_SICK] = { "Sick", 0, "icon16/vein/bug.png", { "Terminal", "Nauseous", "Sick", "Under the Weather", " Healthy", "", "", "", "" } };

V.STAT.Colors = {
	Color( 171, 25, 3, 255 ),
	Color( 150, 46, 7, 255 ),
	Color( 129, 67, 11, 255 ),
	Color( 107, 88, 14, 255 ),
	Color( 85, 109, 18, 255 ),
	Color( 64, 130, 22, 255 ),
	Color( 42, 152, 25, 255 ),
	Color( 21, 173, 29, 255 ),
	Color( 0, 194, 33, 255 )
}

function V.STAT.CheckStatus()
	
	if( !LocalPlayer().Status ) then
		
		LocalPlayer().Status = { };
		
		for k, v in pairs( V.STAT.List ) do
			
			if( LocalPlayer().Status ) then
				
				LocalPlayer().Status[k] = v[2];
				
			end
			
		end
		
	end
	
end

function V.STAT.GetStatus( ply, stat )
	
	if( !ply or !ply:IsValid() ) then return 0 end
	if( !ply.Status ) then return 0 end
	return ply.Status[stat];
	
end

function V.STAT.SyncStatus( len )
	
	V.STAT.CheckStatus();
	
	local stat = net.ReadFloat();
	local val = net.ReadFloat();
	
	if( LocalPlayer().Status ) then
		
		LocalPlayer().Status[stat] = val;
		
	end
	
	V.INS.UpdateInsanity();
	
end
net.Receive( "nStatSync", V.STAT.SyncStatus );

function V.STAT.Render()
	
	if( !LocalPlayer():Alive() ) then return end
	
	local s = LocalPlayer().Status;
	
	if( !s ) then return end
	
	local cBlurAdd = 0.4; -- Prevents too much blur.
	local drawBlur = false;
	
	if( s[V.STAT.STATUS_ZOMBIE] < 0 or s[V.STAT.STATUS_SICK] < 0 ) then
		
		local m = math.min( s[V.STAT.STATUS_ZOMBIE], s[V.STAT.STATUS_SICK] );
		
		local tab = { };
		
		tab[ "$pp_colour_addr" ] 		= 0;
		tab[ "$pp_colour_addg" ] 		= 0;
		tab[ "$pp_colour_addb" ] 		= 0;
		tab[ "$pp_colour_brightness" ] 	= 0;
		tab[ "$pp_colour_contrast" ] 	= 1;
		tab[ "$pp_colour_colour" ] 		= 1 + 0.25 * m;
		tab[ "$pp_colour_mulr" ] 		= 0;
		tab[ "$pp_colour_mulg" ] 		= 0;
		tab[ "$pp_colour_mulb" ] 		= 0;
		
		DrawColorModify( tab );
		
	end
	
	if( s[V.STAT.STATUS_HUNGER] < -1 ) then
		
		local mul = ( s[V.STAT.STATUS_HUNGER] + 1 ) / -3;
		
		drawBlur = true;
		cBlurAdd = cBlurAdd - 0.3 * mul;
		
	end
	
	if( s[V.STAT.STATUS_SLEEP] < -1 ) then
		
		local mul = ( s[V.STAT.STATUS_SLEEP] + 1 ) / -3;
		
		drawBlur = true;
		cBlurAdd = cBlurAdd - 0.3 * mul;
		
	end
	
	if( s[V.STAT.STATUS_PANIC] < -1 ) then
		
		local mul = ( s[V.STAT.STATUS_PANIC] + 1 ) / -3;
		
		drawBlur = true;
		cBlurAdd = cBlurAdd - 0.3 * mul;
		
	end
	
	if( s[V.STAT.STATUS_PAIN] < 0 ) then
		
		local cMul = s[V.STAT.STATUS_PAIN] / -4;
		
		local tab = { };
		
		tab[ "$pp_colour_addr" ] 		= 2 * 0.02 * cMul;
		tab[ "$pp_colour_addg" ] 		= 0;
		tab[ "$pp_colour_addb" ] 		= 0;
		tab[ "$pp_colour_brightness" ] 	= 0;
		tab[ "$pp_colour_contrast" ] 	= 1 + 1 * cMul;
		tab[ "$pp_colour_colour" ] 		= 1;
		tab[ "$pp_colour_mulr" ] 		= 255 * 0.1 * cMul;
		tab[ "$pp_colour_mulg" ] 		= 0;
		tab[ "$pp_colour_mulb" ] 		= 0;
		
		DrawColorModify( tab );
		
		drawBlur = true;
		cBlurAdd = cBlurAdd - 0.3 * cMul;
		
	end
	
	if( s[V.STAT.STATUS_DRUNK] < 0 ) then
		
		local cMul = s[V.STAT.STATUS_DRUNK] / -4;
		
		drawBlur = true;
		cBlurAdd = cBlurAdd - 0.20 * cMul;
		
	end
	
	if( drawBlur ) then
		
		DrawMotionBlur( math.max( cBlurAdd, 0.1 ), 0.8, 0 );
		
	end
	
end

function V.STAT.StartSleep()
	
	local targ = net.ReadEntity();
	local bed = net.ReadEntity();
	
	if( targ == LocalPlayer() ) then
		
		V.BlackScreenDir = 1;
		
	end
	
	targ.Asleep = true;
	targ.Bed = bed;
	
end
net.Receive( "nStartSleep", V.STAT.StartSleep );

function V.STAT.StopSleep()
	
	local targ = net.ReadEntity();
	
	if( targ == LocalPlayer() ) then
		
		V.BlackScreenDir = -1;
		
	end
	
	targ.Asleep = nil;
	targ.Bed = nil;
	
end
net.Receive( "nStopSleep", V.STAT.StopSleep );

function V.STAT.StopSleepPanic()
	
	local targ = net.ReadEntity();
	
	if( targ == LocalPlayer() ) then
		
		V.BlackScreenDir = -1;
		V.BlackScreenAlpha = 0;
		
	end
	
	V.EF.Panic();
	
	targ.Asleep = nil;
	targ.Bed = nil;
	
end
net.Receive( "nStopSleepPanic", V.STAT.StopSleepPanic );

function V.STAT.Panic()
	
	net.Start( "e_panic" );
	net.SendToServer();
	
end

function V.STAT.ConfirmSleep()
	
	V.STAT.SleepWin = vgui.Create( "DFrame" );
	V.STAT.SleepWin:SetSize( 200, 100 );
	V.STAT.SleepWin:Center();
	V.STAT.SleepWin:SetTitle( "Sleep here?" );
	V.STAT.SleepWin:ShowCloseButton( true );
	V.STAT.SleepWin:MakePopup();
	
	V.STAT.SleepBut = vgui.Create( "DButton", V.STAT.SleepWin );
	V.STAT.SleepBut:SetPos( 10, 40 );
	V.STAT.SleepBut:SetSize( 180, 50 );
	V.STAT.SleepBut:SetText( "OK" );
	V.STAT.SleepBut:SetFont( "VCandara30" );
	V.STAT.SleepBut.DoClick = function( b )
		
		net.Start( "e_sl" );
		net.SendToServer();
		
		V.STAT.SleepWin:Remove();
		V.STAT.SleepBut:Remove();
		
	end;
	
end
net.Receive( "nConfirmSleep", V.STAT.ConfirmSleep );