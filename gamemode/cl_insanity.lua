V.INS = { };

V.INS.Level = 0;

V.INS.ScreenDraw = nil;
V.INS.ScreenDrawN = 0;
V.INS.BlackScreen = nil;
V.INS.BlackScreenN = 0;
V.INS.DrawPerson = nil;
V.INS.DrawPersonLine = nil;
V.INS.DrawPersonX = nil;
V.INS.DrawPersonY = nil;
V.INS.DrawPersonN = 0;
V.INS.BlackScreenZombie = nil;

V.INS.RenderColormod = nil;
V.INS.RenderColormodN = 0;

V.INS.StalkerScream = Sound( "npc/stalker/go_alert2a.wav" );
V.INS.WhiteNoise = Sound( "vein/white_noise.mp3" );

local param = { };
param["$basetexture"] = "models/gman/gman_facehirez";
param["$bumpmap"] = "models/gman/gmanhirez_normal";
param["$halflambert"] = "1";

V.INS.GManFacemap = CreateMaterial( "vein_gman_facemap", "UnlitGeneric", param );

local param = { };
param["$basetexture"] = "models/flesh";
param["$bumpmap"] = "models/flesh_nrm";
param["$normalmapalphaenvmapmask"] = "1";
param["$halflambert"] = "1";
param["$phong"] = "1";
param["$phongboost"] = "1";
param["$phongfresnelranges"] = "[2 5 10]";
param["$phongexponent"] = "100";

V.INS.FleshMat = CreateMaterial( "vein_flesh", "UnlitGeneric", param );

local param = { };
param["$basetexture"] = "models/charple/charple3_sheet";
param["$bumpmap"] = "models/charple/charple3_normal";
param["$envmap"] = "env_cubemap";
param["$normalmapalphaenvmapmask"] = "1";
param["$envmapcontrast"] = "1";

V.INS.CharpleMat = CreateMaterial( "vein_charple", "UnlitGeneric", param );

local param = { };
param["$basetexture"] = "models/Zombie_Classic/Zombie_Classic_sheet";
param["$bumpmap"] = "models/Zombie_Classic/Zombie_Classic_sheet_normal";
param["$envmap"] = "env_cubemap";
param["$envmapcontrast"] = "1";
param["$normalmapalphaenvmapmask"] = "1";

V.INS.ZombieMat = CreateMaterial( "vein_zombie", "UnlitGeneric", param );

V.INS.RandomMats = {
	V.INS.GManFacemap,
	V.INS.FleshMat,
	V.INS.CharpleMat,
	V.INS.ZombieMat,
}

V.INS.RandomMatsSounds = {
	V.INS.StalkerScream,
	V.INS.WhiteNoise,
}

V.INS.RandomSounds = {
	Sound( "ambient/voices/squeal1.wav" ),
	Sound( "npc/stalker/breathing3.wav" ),
}

V.INS.RandomInjurySounds = {
	Sound( "physics/body/body_medium_break2.wav" ),
	Sound( "physics/body/body_medium_break3.wav" ),
	Sound( "physics/body/body_medium_break4.wav" ),
	Sound( "physics/flesh/flesh_impact_bullet1.wav" ),
	Sound( "physics/flesh/flesh_impact_bullet2.wav" ),
	Sound( "physics/flesh/flesh_impact_bullet3.wav" ),
	Sound( "physics/flesh/flesh_impact_bullet4.wav" ),
	Sound( "physics/flesh/flesh_impact_bullet5.wav" ),
	Sound( "physics/flesh/flesh_squishy_impact_hard1.wav" ),
	Sound( "physics/flesh/flesh_squishy_impact_hard2.wav" ),
	Sound( "physics/flesh/flesh_squishy_impact_hard3.wav" ),
	Sound( "physics/flesh/flesh_squishy_impact_hard4.wav" ),
	Sound( "player/pl_fallpain1.wav" ),
	Sound( "player/pl_fallpain3.wav" ),
	Sound( "player/pl_fallpain3.wav" ),
	Sound( "vein/zombies/zombie_bite1.wav" ),
	Sound( "vein/zombies/zombie_bite2.wav" ),
	Sound( "vein/zombies/zombie_bite3.wav" ),
}

V.INS.RandomColormods = {
	
}

local tab = { };

tab[ "$pp_colour_addr" ] 		= 0;
tab[ "$pp_colour_addg" ] 		= 0;
tab[ "$pp_colour_addb" ] 		= 0;
tab[ "$pp_colour_brightness" ] 	= 0;
tab[ "$pp_colour_contrast" ] 	= 1;
tab[ "$pp_colour_colour" ] 		= 1;
tab[ "$pp_colour_mulr" ] 		= 255;
tab[ "$pp_colour_mulg" ] 		= 0;
tab[ "$pp_colour_mulb" ] 		= 0;

table.insert( V.INS.RandomColormods, tab );

local tab = { };

tab[ "$pp_colour_addr" ] 		= 255;
tab[ "$pp_colour_addg" ] 		= 0;
tab[ "$pp_colour_addb" ] 		= 0;
tab[ "$pp_colour_brightness" ] 	= 0;
tab[ "$pp_colour_contrast" ] 	= 1;
tab[ "$pp_colour_colour" ] 		= 1;
tab[ "$pp_colour_mulr" ] 		= 0;
tab[ "$pp_colour_mulg" ] 		= 0;
tab[ "$pp_colour_mulb" ] 		= 0;

table.insert( V.INS.RandomColormods, tab );

tab[ "$pp_colour_addr" ] 		= 0;
tab[ "$pp_colour_addg" ] 		= 0;
tab[ "$pp_colour_addb" ] 		= 0;
tab[ "$pp_colour_brightness" ] 	= 0;
tab[ "$pp_colour_contrast" ] 	= 200;
tab[ "$pp_colour_colour" ] 		= 200;
tab[ "$pp_colour_mulr" ] 		= 0;
tab[ "$pp_colour_mulg" ] 		= 0;
tab[ "$pp_colour_mulb" ] 		= 0;

table.insert( V.INS.RandomColormods, tab );

function V.INS.DrawHUD()
	
	if( V.INS.ScreenDraw ) then
		
		surface.SetDrawColor( 255, 255, 255, 255 );
		surface.SetMaterial( V.INS.ScreenDraw );
		surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() );
		
		V.INS.ScreenDrawN = V.INS.ScreenDrawN + 1;
		
		if( V.INS.ScreenDrawN > 15 ) then
			
			V.INS.ScreenDraw = nil;
			V.INS.ScreenDrawN = 0;
			LocalPlayer().InsaneSound:Stop();
			LocalPlayer().InsaneSound = nil;
			
		end
		
	end
	
	if( V.INS.BlackScreen ) then
		
		surface.SetDrawColor( 0, 0, 0, 255 );
		surface.DrawRect( 0, 0, ScrW(), ScrH() );
		
		V.INS.BlackScreenN = V.INS.BlackScreenN + 1;
		
		if( V.INS.BlackScreenN > 100 ) then
			
			V.INS.BlackScreen = nil;
			V.INS.BlackScreenN = 0;
			
			if( V.INS.BlackScreenZombie ) then V.INS.BlackScreenZombie:Remove() end
			
		end
		
	end
	
	if( V.INS.WhiteScreen ) then
		
		local t = CurTime() - V.INS.WhiteScreen;
		local a = 0;
		
		if( t < 3 ) then
			
			a = 1;
			
		elseif( t < 4 ) then
			
			a = 1 - ( t - 3 );
			
		end
		
		if( a == 0 ) then V.INS.WhiteScreen = nil; end
		
		surface.SetDrawColor( 255, 255, 255, a * 255 );
		surface.DrawRect( 0, 0, ScrW(), ScrH() );
		
	end
	
	if( V.INS.DrawPerson ) then
		
		if( !V.INS.DrawPersonLine ) then
			
			V.INS.DrawPersonLine = string.gsub( table.Random( V.InsanityText ), "name", V.INS.DrawPerson );
			
		end
		
		if( !V.INS.DrawPersonX ) then
			
			V.INS.DrawPersonX = math.random( 100, ScrW() - 100 );
			
		end
		
		if( !V.INS.DrawPersonY ) then
			
			V.INS.DrawPersonY = math.random( 100, ScrH() - 100 );
			
		end
		
		local a = math.random( 30, 255 );
		draw.DrawText( V.INS.DrawPersonLine, "VCandara50", V.INS.DrawPersonX, V.INS.DrawPersonY, Color( 200, 0, 0, a ), 1 );
		
		V.INS.DrawPersonN = V.INS.DrawPersonN + 1;
		
		if( V.INS.DrawPersonN > 50 ) then
			
			V.INS.DrawPerson = nil;
			V.INS.DrawPersonLine = nil;
			V.INS.DrawPersonX = nil;
			V.INS.DrawPersonY = nil;
			V.INS.DrawPersonN = 0;
			
		end
		
	end
	
end

function V.INS.Render()
	
	if( V.INS.RandomColormod ) then
		
		DrawColorModify( V.INS.RandomColormod );
		
		V.INS.RenderColormodN = V.INS.RenderColormodN + 1;
		
		if( V.INS.RenderColormodN > 10 ) then
			
			V.INS.RandomColormod = nil;
			V.INS.RenderColormodN = 0;
			
		end
		
	end
	
end

function V.INS.Effect1()
	
	V.INS.ScreenDraw = table.Random( V.INS.RandomMats );
	
	LocalPlayer().InsaneSound = CreateSound( LocalPlayer(), table.Random( V.INS.RandomMatsSounds ) );
	LocalPlayer().InsaneSound:Play();
	
end

function V.INS.Effect2()
	
	LocalPlayer():EmitSound( table.Random( V.INS.RandomSounds ) );
	
end

function V.INS.Effect3()
	
	LocalPlayer():EmitSound( table.Random( V.INS.RandomInjurySounds ) );
	
end

function V.INS.Effect4()
	
	V.INS.DrawPerson = table.Random( player.GetAll() ):RPName();
	
end

function V.INS.Effect5()
	
	V.INS.RandomColormod = table.Random( V.INS.RandomColormods );
	
end

function V.INS.Effect6()
	
	V.INS.BlackScreen = true;
	LocalPlayer():EmitSound( table.Random( V.INS.RandomInjurySounds ) );
	
end

function V.INS.Effect7()
	
	local dist = 500;
	
	for i = 1, 16 do
		
		local a = math.random( -180, 180 ) / 25;
		local c = math.cos( a );
		local s = math.sin( a );
		
		local x = dist * c;
		local y = dist * s;
		
		local pos = LocalPlayer():GetPos();
		local t = Vector( pos.x + x, pos.y + y, pos.z );
		
		if( !V.OnScreen( LocalPlayer(), t ) ) then
			
			local trace = { };
			trace.start = LocalPlayer():EyePos();
			trace.endpos = pos;
			trace.filter = LocalPlayer();
			
			local tr = util.TraceLine( trace );
			
			if( tr.Fraction == 1 ) then
				
				local trace = { };
				trace.start = LocalPlayer():EyePos();
				trace.endpos = pos + Vector( 0, 0, 48 );
				trace.filter = LocalPlayer();
				
				local tr = util.TraceLine( trace );
				
				if( tr.Fraction == 1 ) then
					
					local ed = EffectData();
						ed:SetOrigin( t );
						ed:SetMagnitude( LocalPlayer():GetPos():Distance( t ) );
					util.Effect( "v_creeper", ed );
					
					break;
					
				end
				
			end
			
		end
		
	end
	
end

function V.INS.Effect8()
	
	local rply = table.Random( player.GetAll() );
	rply:SetModel( table.Random( V.ZombieModels ) );
	
end

function V.INS.UpdateInsanity()
	
	V.INS.LastLevel = V.INS.Level or 0;
	V.INS.Level = 0;
	
	local s = LocalPlayer().Status;
	
	if( s ) then
		
		for k, v in pairs( s ) do
			
			if( v < -3 ) then
				
				V.INS.Level = V.INS.Level + 1;
				
			end
			
		end
		
	end
	
	if( s and s[V.STAT.STATUS_ZOMBIE] < 0 ) then
		
		V.INS.Level = math.abs( s[V.STAT.STATUS_ZOMBIE] );
		
	end
	
	if( V.INS.Override ) then V.INS.Level = V.INS.Override end
	
	if( !LocalPlayer():Alive() or ( V.DieStart and V.DieStart <= CurTime() ) ) then V.INS.Level = 0 end
	
	if( V.INS.LastLevel != V.INS.Level ) then
		
		if( V.INS.Level >= 4 ) then
			
			if( V.EF.CurMusicPatch ) then
				
				V.EF.CurMusicPatch:ChangeVolume( 0, 1 );
				
			end
			
			if( !V.INS.Jingle ) then V.INS.Jingle = CreateSound( LocalPlayer(), "vein/insanejingle.wav" ) end
			V.INS.Jingle:Play();
			
			if( V.INS.Level >= 5 ) then
				
				if( !V.INS.Beat ) then V.INS.Beat = CreateSound( LocalPlayer(), "vein/insanebeat.wav" ) end
				V.INS.Beat:Play();
				
			end
			
			V.INS.NextEffect = CurTime() + math.random( 60 / V.INS.Level, 180 / V.INS.Level );
			
		else
			
			if( V.EF.CurMusicPatch ) then
				
				V.EF.CurMusicPatch:ChangeVolume( 1, 1 );
				
			end
			
			if( V.INS.Jingle ) then
				
				V.INS.Jingle:FadeOut( 1 );
				
			end
			
			if( V.INS.Beat ) then
				
				V.INS.Beat:FadeOut( 1 );
				
			end
			
		end
		
	end
	
end

function V.INS.Think()
	
	if( V.INS.Level >= 4 ) then
		
		if( V.INS.SeenCreeper and CurTime() >= V.INS.SeenCreeper ) then
			
			LocalPlayer():SetDSP( 35, false );
			
			V.INS.WhiteScreen = CurTime();
			
			if( V.INS.Creeper ) then
				
				V.INS.Creeper:Remove();
				
			end
			
			V.INS.Creeper = nil;
			V.INS.SeenCreeper = nil;
			
			if( V.INS.Jingle ) then
				
				V.INS.Jingle:Stop();
				
			end
			
			if( V.INS.Beat ) then
				
				V.INS.Beat:Stop();
				
			end
			
			V.INS.NextEffect = CurTime() + math.random( 60 / V.INS.Level, 180 / V.INS.Level );
			V.INS.ResumeJingle = CurTime() + 6;
			
		end
		
		if( V.INS.ResumeJingle and CurTime() >= V.INS.ResumeJingle ) then
			
			V.INS.ResumeJingle = nil;
			
			if( V.INS.Jingle ) then
				
				V.INS.Jingle:Play();
				
			end
			
			if( V.INS.Beat ) then
				
				V.INS.Beat:Play();
				
			end
			
		end
		
		if( V.INS.NextEffect and CurTime() > V.INS.NextEffect ) then
			
			if( V.INS.Creeper ) then
				
				V.INS.Creeper:Remove();
				
			end
			
			V.INS.Creeper = nil;
			V.INS.SeenCreeper = nil;
			
			V.INS.NextEffect = CurTime() + math.random( 60 / V.INS.Level, 180 / V.INS.Level );
			
			V.INS["Effect" .. tostring( math.random( 1, 8 ) )]();
			
		end
		
	else
		
		if( V.INS.Creeper ) then
			
			V.INS.Creeper:Remove();
			
		end
		
		V.INS.Creeper = nil;
		V.INS.SeenCreeper = nil;
		
	end
	
end