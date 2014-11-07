surface.CreateFont( "VSoulMax", {
	font = "Sell Your Soul",
	size = 128,
	weight = 400,
	antialias = true,
	additive = false
} );

surface.CreateFont( "VSoul50", {
	font = "Sell Your Soul",
	size = 50,
	weight = 400,
	antialias = true,
	additive = false
} );

surface.CreateFont( "VSoul30", {
	font = "Sell Your Soul",
	size = 30,
	weight = 400,
	antialias = true,
	additive = false
} );

surface.CreateFont( "VSoul20", {
	font = "Sell Your Soul",
	size = 20,
	weight = 400,
	antialias = true,
	additive = false
} );

surface.CreateFont( "VCandaraScr4", {
	font = "Candara",
	size = math.min( ScrH() / 9, 128 ),
	weight = 400,
	antialias = true,
	additive = false
} );

surface.CreateFont( "VCandara50", {
	font = "Candara",
	size = 50,
	weight = 400,
	antialias = true,
	additive = false
} );

surface.CreateFont( "VCandara30", {
	font = "Candara",
	size = 30,
	weight = 400,
	antialias = true,
	additive = false
} );

surface.CreateFont( "VCandara20", {
	font = "Candara",
	size = 20,
	weight = 400,
	antialias = true,
	additive = false
} );

surface.CreateFont( "VCandara20B", {
	font = "Candara",
	size = 20,
	weight = 700,
	antialias = true,
	additive = false
} );

surface.CreateFont( "VCandara15", {
	font = "Candara",
	size = 15,
	weight = 400,
	antialias = true,
	additive = false
} );

surface.CreateFont( "VCandaraTiny", {
	font = "Candara",
	size = 10,
	weight = 400,
	antialias = true,
	additive = false
} );

V.StartIntro = false;
V.StartIntroTime = -1;
V.BlackScreenAlpha = 255;
V.BlackScreenDir = 0;

function V.SlickBackground( x, y, w, h, nograd )
	
	if( !nograd ) then
		
		for i = 0, math.min( h, 32 ) do
			
			surface.SetDrawColor( 100, 100, 100, math.min( h, 32 ) - i );
			surface.DrawLine( x, y + i, x + w, y + i );
			
		end
		
	end
	
	h = h - 1;
	w = w - 1;
	
	surface.SetDrawColor( 50, 50, 50, 255 );
	
	for i = 0, w + h, 5 do
		
		if( i < h ) then
			
			surface.DrawLine( x + i, y, x, y + i );
			
		elseif( i > w ) then
			
			surface.DrawLine( x + w, y + i - w, x - h + i, y + h );
			
		else
			
			surface.DrawLine( x + i, y, x + i - h, y + h );
			
		end
		
	end
	
end

function V.BSplinePoint( tDiff, tPoints )
    
    local Q = Vector( 0, 0, 0 );
    local tinc = 1 / ( table.getn( tPoints ) - 3 );
    
    tDiff = tDiff + tinc;
    
    for idx, pt in pairs( tPoints ) do
    
        local n = math.calcBSplineN( idx, 4, tDiff, tinc );
		
        Q = Q + (n * pt);
        
    end
    
    return Q;
    
end

function GM:InIntro()
	
	return ( V.FancyIntroStart > -1 and CurTime() - V.FancyIntroStart < 20 );
	
end

function GM:ShouldDrawLocalPlayer()
	
	if( LocalPlayer():IsEffectActive( EF_NODRAW ) ) then return false end
	
	if( GAMEMODE:InIntro() ) then return true end
	if( V.EF.ThirdPerson ) then return true end
	if( LocalPlayer().Sitting ) then return true end
	if( V.DEV.OverridePos and V.DEV.OverrideAng ) then return true end
	
	return false;
	
end

function GM:CalcView( ply, origin, angles, fov )
	
	local view = { };
	view.angles = angles;
	view.origin = origin;
	view.fov = fov;
	
	if( GAMEMODE:InIntro() and V.FancyIntroSpline ) then
		
		local t = CurTime() - V.FancyIntroStart;
		
		local sp = V.FancyIntroSpline;
		
		local vf = V.BSplinePoint( t / 20, sp[1] );
		local af = V.BSplinePoint( t / 20, sp[2] );
		
		return { origin = vf, angles = af, fov = fov };
		
	elseif( LocalPlayer():GetViewEntity() != LocalPlayer() ) then
		
		return { origin = origin + Vector( 0, 0, 64 ), angles = angles, fov = fov };
		
	else
		
		local m = false;
		
		if( V.EF.ThirdPerson ) then
			
			V.EF.DestPos = origin - ply:GetForward() * 30 + ply:GetRight() * 20;
			m = true;
			
		end
		
		if( ply.Sitting and ply.Chair and ply.Chair:IsValid() ) then
			
			local data = V.ME.ChairData[ply.Chair:GetModel()];
			
			if( data ) then
				
				origin = ply.Chair:GetPos() + ply.Chair:GetForward() * data[1].x + ply.Chair:GetRight() * data[1].y + ply.Chair:GetUp() * data[1].z;
				
			else
				
				origin = ply.Chair:GetPos();
				
			end
			
			V.EF.DestPos = origin - ply:GetForward() * 100;
			m = true;
			
		end
		
		if( m ) then
			
			local distance = origin - V.EF.DestPos;
			
			local trace = { };
			trace.start = origin;
			trace.endpos = V.EF.DestPos;
			trace.filter = { ply, ply.Chair };
			
			local tr = util.TraceLine( trace );
			
			V.EF.DestPos = origin + tr.Normal * ( distance:Length() - 10 ) * tr.Fraction;
			
			V.EF.DestAng = angles;
			
			V.EF.CurPos = LerpVector( V.EF.Lerp, V.EF.CurPos, V.EF.DestPos );
			V.EF.CurAng = LerpAngle( V.EF.Lerp, V.EF.CurAng, V.EF.DestAng );
			
			view.angles = V.EF.CurAng;
			view.origin = V.EF.CurPos;
			
		else
			
			-- Normal calc-view
			
		end
		
		if( V.DEV.OverridePos and V.DEV.OverrideAng ) then
			
			view.origin = V.DEV.OverridePos;
			view.angles = V.DEV.OverrideAng;
			
		end
		
	end
	
	local wep = ply:GetActiveWeapon();
	
	if( IsValid( wep ) ) then
		
		local f = wep.GetViewModelPosition;
		if( f ) then
			view.vm_origin, view.vm_angles = f( wep, origin * 1, angles * 1 );
		end
		
	end
	
	return view;
	
end

V.CaptionText = "";
V.CaptionStart = -60;
V.CaptionDuration = 6;

function V.AddCaption( len )
	
	V.CaptionText = net.ReadString();
	V.CaptionStart = CurTime();
	V.CaptionDuration = net.ReadFloat();
	
end
net.Receive( "nHUDCaption", V.AddCaption );

V.FancyIntroStart = -1;
V.FancyIntroOut = false;
V.FancyIntroIn = false;
V.FancyIntroWind = nil;
V.PlayedFancyBassHit = false;

function V.CreateFancyIntro( t )
	
	V.FancyIntroStart = CurTime() - ( t or 0 );
	V.FancyIntroOut = false;
	V.FancyIntroIn = false;
	V.FancyIntroWind = nil;
	V.PlayedFancyBassHit = false;
	
	if( t > 5 ) then
		
		V.PlayedFancyBassHit = true;
		
	end
	
	V.FancyIntroWind = CreateSound( LocalPlayer(), "ambient/wind/wasteland_wind.wav" );
	V.FancyIntroWind:Play();
	
end

function V.PaintFancyIntro()
	
	if( V.FancyIntroStart > -1 ) then
		
		local t = CurTime() - V.FancyIntroStart;
		
		if( t < 20 ) then
			
			draw.RoundedBox( 0, 0, 0, ScrW(), ScrH() * 0.1, Color( 0, 0, 0, 255 ) );
			draw.RoundedBox( 0, 0, ScrH() * 0.9, ScrW(), ScrH() * 0.1, Color( 0, 0, 0, 255 ) );
			
		end
		
		if( !V.PlayedFancyBassHit ) then
			
			surface.PlaySound( "vein/tune18.mp3" );
			V.PlayedFancyBassHit = true;
			
		end
		
		if( t > 6 and t < 22 ) then
			
			surface.SetFont( "VCandaraScr4" );
			local w, h = surface.GetTextSize( "VEIN" );
			
			local d = 1;
			
			if( t <= 6.2 ) then
				
				d = ( t - 6 ) * 5;
				
			end
			
			if( t > 20 ) then
				
				d = math.max( 2 - ( t - 20 ), 0 ) / 2;
				
			end
			
			draw.DrawText( "VEIN", "VCandaraScr4", 20, ScrH() * 0.9 - h - 10, Color( 255, 255, 255, 255 * d ), 0 );
			
		end
		
		if( t >= 20 and V.FancyIntroOut and !V.FancyIntroIn ) then
			
			V.FancyIntroIn = true;
			V.BlackScreenDir = -1;
			
			if( V.FancyIntroWind and V.FancyIntroWind:IsPlaying() ) then
				
				V.FancyIntroWind:FadeOut( 5 );
				
			end
			
		elseif( t >= 15 and !V.FancyIntroOut ) then
			
			V.FancyIntroOut = true;
			V.BlackScreenDir = 1;
			
		end
		
		if( t >= 25 and V.FancyIntroWind ) then
			
			V.FancyIntroWind = nil;
			
		end
		
	end
	
end

function V.OnMinBlackScreen()
	
	
	
end

function V.OnMaxBlackScreen()
	
	if( V.CC.Mode > -1 ) then
		
		V.CC.CharCreate();
		V.CC.StartCharCreateTime = -1;
		
	end
	
	if( LocalPlayer().Asleep and !V.StartSleepStart ) then
		
		V.SleepStart = CurTime();
		V.StartSleepStart = true;
		
	end
	
end

function V.PaintBlackScreen()
	
	V.BlackScreenAlpha = math.Clamp( V.BlackScreenAlpha + FrameTime() * 100 * V.BlackScreenDir, 0, 255 );
	
	if( V.BlackScreenDir != 0 ) then
		
		if( V.BlackScreenAlpha == 0 ) then
			
			V.BlackScreenDir = 0;
			V.OnMinBlackScreen();
			
		end
		
		if( V.BlackScreenAlpha == 255 ) then
			
			V.BlackScreenDir = 0;
			V.OnMaxBlackScreen();
			
		end
		
	end
	
	if( V.BlackScreenAlpha > 0 ) then
		
		draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 0, 0, 0, V.BlackScreenAlpha ) );
		
	end
	
end

function V.PaintIntro()
	
	if( !V.FirstSession and !V.StartIntro and V.StartIntroTime == -1 ) then
		
		V.StartIntroTime = CurTime() - 24;
		V.StartIntro = true;
		
	end
	
	if( !V.StartIntro and V.StartIntroTime == -1 ) then
		
		V.StartIntroTime = CurTime();
		V.StartIntro = true;
		V.EF.PlayMusic( "vein/preface.mp3", 0, true );
		
	end
	
	if( V.StartIntro ) then
		
		local timesince = CurTime() - V.StartIntroTime;
		local fadetime = timesince;
		local text = "";
		local textalph = 255;
		
		if( timesince < 8 ) then
			
			text = "These are the end-times";
			
		elseif( timesince < 16 ) then
			
			text = "There was no hope of survival";
			fadetime = fadetime - 8;
			
		elseif( timesince < 24 ) then
			
			text = "This is how you died"
			fadetime = fadetime - 16;
			
		elseif( !V.CC.CharCreateOpen ) then
			
			V.CC.CharCreate();
			V.StartIntro = false;
			
		end
		
		if( fadetime < 1 ) then
			
			textalph = fadetime * 255;
			
		elseif( fadetime > 6 ) then
			
			textalph = ( 8 - fadetime ) / 2 * 255;
			
		end
		
		draw.DrawText( text, "VSoul50", ScrW() / 2, ScrH() / 2, Color( 255, 255, 255, textalph ), 1 );
		
	end
	
end

function V.PaintThink()
	
	if( V.CC.CharCreateOpen ) then
		
		if( V.CC.StartCharCreateTime == -1 ) then
			
			V.CC.StartCharCreateTime = CurTime();
			V.CC.MakeVGUIComponents();
			
		end
		
	end
	
end

V.SeeAll = false;

function V.PaintOtherPeople()
	
	if( V.BlackScreenAlpha == 255 ) then return end
	
	for _, v in pairs( player.GetAll() ) do
		
		if( v != LocalPlayer() ) then
			
			if( !v.HUDAlph ) then
				
				v.HUDAlph = 0;
				
			end
			
			local pos = ( v:EyePos() + Vector( 0, 0, 10 ) ):ToScreen();
			
			if( V.SeeAll or ( pos.visible and LocalPlayer():CanSee( v ) and LocalPlayer():GetPos():Distance( v:GetPos() ) < 1024 and !v:GetNoDraw() ) ) then
				
				v.HUDAlph = math.Clamp( v.HUDAlph + FrameTime(), 0, 1 );
				
			elseif( v.HUDAlph > 0 ) then
				
				v.HUDAlph = math.Clamp( v.HUDAlph - FrameTime(), 0, 1 );
				
			end
			
			if( v.HUDAlph > 0 ) then
				
				draw.DrawText( v:RPName(), "VCandara20", pos.x + 1, pos.y + 1, Color( 0, 0, 0, v.HUDAlph * 255 ), 1 );
				draw.DrawText( v:RPName(), "VCandara20", pos.x, pos.y, Color( 200, 200, 200, v.HUDAlph * 255 ), 1 );
				
				draw.DrawText( v:Typing(), "VCandara20", pos.x + 1, pos.y + 21, Color( 0, 0, 0, v.HUDAlph * 255 ), 1 );
				draw.DrawText( v:Typing(), "VCandara20", pos.x, pos.y + 20, Color( 200, 200, 0, v.HUDAlph * 255 ), 1 );
				
				if( V.SeeAll ) then
					
					local d = math.ceil( LocalPlayer():EyePos():Distance( v:EyePos() ) * 0.01905 );
					draw.DrawText( tostring( d ) .. "m", "VCandara20", pos.x + 1, pos.y + 21, Color( 0, 0, 0, v.HUDAlph * 255 ), 1 );
					draw.DrawText( tostring( d ) .. "m", "VCandara20", pos.x, pos.y + 20, Color( 200, 200, 0, v.HUDAlph * 255 ), 1 );
					
				end
				
			end
			
		end
		
	end
	
	if( V.SeeAll ) then
		
		for _, v in pairs( ents.FindByClass( "v_zombie" ) ) do
			
			local pos = ( v:EyePos() + Vector( 0, 0, 10 ) ):ToScreen();
			
			draw.DrawText( "Z", "VCandara20", pos.x + 1, pos.y + 1, Color( 0, 0, 0, 255 ), 1 );
			draw.DrawText( "Z", "VCandara20", pos.x, pos.y, Color( 200, 0, 0, 255 ), 1 );
			
		end
		
	end
	
end

function V.PaintDoors()
	
	if( V.BlackScreenAlpha == 255 ) then return end
	
	local trace = { };
		trace.start = LocalPlayer():EyePos();
		trace.endpos = trace.start + LocalPlayer():GetAimVector() * 512;
		trace.filter = LocalPlayer();
	local tr = util.TraceLine( trace );
	
	if( tr.Entity and tr.Entity:IsValid() and tr.Entity:GetClass() == "v_plank" ) then
		
		tr.Entity = tr.Entity:GetOwner();
		
	end
	
	if( tr.Entity and tr.Entity:IsValid() and tr.Entity:IsDoor() ) then
		
		if( !tr.Entity.HUDAlph ) then
			
			tr.Entity.HUDAlph = 0;
			
		end
		
		tr.Entity.HUDP = tr.HitPos;
		
		tr.Entity.HUDAlph = math.Clamp( tr.Entity.HUDAlph + FrameTime(), 0, 1 );
		
	end
	
	for _, v in pairs( ents.FindByClass( "prop_door_rotating" ) ) do
		
		if( !v.HUDAlph ) then
			
			v.HUDAlph = 0;
			
		end
		
		if( v.HUDP ) then
			
			local pos = v.HUDP:ToScreen();
			
			if( v.HUDAlph > 0 and tr.Entity != v ) then
				
				v.HUDAlph = math.Clamp( v.HUDAlph - FrameTime(), 0, 1 );
				
			end
			
			if( pos.visible and v.HUDAlph > 0 ) then
				
				if( !v.DoorHealth ) then
					
					v.DoorHealth = 8;
					
				end
				
				if( !v.DoorMaxHealth ) then
					
					v.DoorMaxHealth = 8;
					
				end
				
				local c = Color( Lerp( v.DoorHealth / v.DoorMaxHealth, 171, 0 ), Lerp( v.DoorHealth / v.DoorMaxHealth, 25, 194 ), Lerp( v.DoorHealth / v.DoorMaxHealth, 3, 33 ), v.HUDAlph * 255 );
				
				if( v.DoorHealth > 8 ) then
					
					local _ = ( v.DoorHealth - 8 ) / ( v.DoorMaxHealth - 8 );
					c = Color( Lerp( _, 64, 200 ), Lerp( _, 64, 200 ), Lerp( _, 64, 200 ), v.HUDAlph * 255 );
					
				end
				
				local text = tostring( v.DoorHealth or 8 ) .. "/" .. tostring( v.DoorMaxHealth or 8 );
				local padding = 5;
				
				surface.SetFont( "VCandara20" );
				local w, h = surface.GetTextSize( text );
				
				draw.RoundedBox( 0, pos.x - ( w / 2 ) - padding, pos.y - padding, w + padding * 2, h + padding * 2, Color( 0, 0, 0, v.HUDAlph * 220 ) );
				
				draw.DrawText( text, "VCandara20", pos.x + 1, pos.y + 1, Color( 0, 0, 0, v.HUDAlph * 255 ), 1 );
				draw.DrawText( text, "VCandara20", pos.x, pos.y, c, 1 );
				
			end
			
		end
		
	end
	
end

function V.PaintSleep()
	
	if( V.SleepStart ) then
		
		
		
	end
	
end

function V.PaintDead( nuke )
	
	if( V.Dead or nuke ) then
		
		V.EF.DrawDead();
		
		local t = CurTime() - V.DieStart;
		
		local tab = string.FormattedTime( V.DieTime );
		
		local text = "You survived for ";
		
		if( math.floor( tab.h ) > 0 ) then
			
			local h = "hours";
			
			if( math.floor( tab.h ) == 1 ) then
				
				h = "hour";
				
			end
			
			text = text .. tostring( math.floor( tab.h ) ) .. " " .. h .. ", ";
			
		end
		
		if( math.floor( tab.m ) > 0 ) then
			
			local m = "minutes";
			
			if( math.floor( tab.m ) == 1 ) then
				
				m = "minute";
				
			end
			
			text = text .. tostring( math.floor( tab.m ) ) .. " " .. m .. ", and ";
			
		end
		
		local s = "seconds";
		
		if( tab.s == 1 ) then
			
			s = "second";
			
		end
		
		text = text .. tostring( tab.s ) .. " " .. s;
		
		local col = Color( 255, 255, 255, 255 );
		
		if( nuked ) then
			
			col = Color( 0, 0, 0, 255 );
			
		end
		
		draw.DrawText( text, "VCandara50", ScrW() / 2, ScrH() + 50 - math.min( t * 10, ScrH() / 2 + 50 ), col, 1 );
		
	end
	
end

V.VignetteMat = CreateMaterial( "effects/veinvignette", "UnlitGeneric", {
	["$basetexture"]	= "effects/veinvignette",
	["$transparent"]	= 1,
	["$alpha"]			= 0.8
} );

V.VignetteMatID = surface.GetTextureID( "effects/veinvignette" );

function V.PaintVignette()
	
	surface.SetDrawColor( 255, 255, 255, 255 );
	surface.SetTexture( V.VignetteMatID );
	surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() );
	
end

V.HUDRainDrops = { };
V.HUDRainNextGenerate = 0;
V.HUDRainMatID = surface.GetTextureID( "particle/warp_ripple3" );

function V.PaintRain()
	
	if( render.GetDXLevel() <= 90 ) then return end
	
	local s = GAMEMODE:CalcView( LocalPlayer(), LocalPlayer():EyePos(), LocalPlayer():EyeAngles(), 75 );
	
	if( V.W.Raining and V.Outside( s.origin ) and s.angles.p < 15 ) then
		
		if( CurTime() > V.HUDRainNextGenerate ) then
			
			V.HUDRainNextGenerate = CurTime() + math.Rand( 0.1, 0.4 );
			
			local t = { };
			t.x = math.random( 0, ScrW() );
			t.y = math.random( 0, ScrH() );
			t.r = math.random( 20, 40 );
			t.c = CurTime();
			
			table.insert( V.HUDRainDrops, t );
			
		end
		
	end
	
	for k, v in pairs( V.HUDRainDrops ) do
		
		if( CurTime() - v.c > 1 ) then
			table.remove( V.HUDRainDrops, k );
			continue;
		end
		
		surface.SetDrawColor( 255, 255, 255, 255 * ( 1 - ( CurTime() - v.c ) ) );
		surface.SetTexture( V.HUDRainMatID );
		surface.DrawTexturedRect( v.x, v.y, v.r, v.r );
		
	end
	
end

V.CurStatusX = { };
V.TargStatusX = { };

function V.PaintStatus()
	
	V.STAT.CheckStatus();
	
	if( LocalPlayer():KeyDown( IN_WALK ) ) then
		
		for k, v in pairs( LocalPlayer().Status ) do
			
			if( v != 0 ) then
				
				V.TargStatusX[k] = 0;
				
			else
				
				V.TargStatusX[k] = -200;
				
			end
			
		end
		
	else
		
		for k, v in pairs( LocalPlayer().Status ) do
			
			V.TargStatusX[k] = -200;
			
		end
		
	end
	
	local y = ScrH() / 2 - 48;
	
	local UrgentTab = { };
	local NonUrgentTab = { };
	
	for k, v in pairs( LocalPlayer().Status ) do
		
		if( v < 0 ) then
			
			UrgentTab[k] = v;
			V.TargStatusX[k] = 0;
			
		else
			
			NonUrgentTab[k] = v;
			
		end
		
		if( !V.CurStatusX[k] ) then V.CurStatusX[k] = 0 end
		
		local diff = ( V.TargStatusX[k] - V.CurStatusX[k] ) / 5;
		V.CurStatusX[k] = math.Approach( V.CurStatusX[k], V.TargStatusX[k], diff );
		
	end
	
	for k, v in pairs( UrgentTab ) do
		
		local val = v + 5;
		
		local tex = V.STAT.List[k][3];
		local col = V.STAT.Colors[val];
		local t = V.STAT.List[k][4][val];
		
		local x0 = V.CurStatusX[k];
		
		draw.RoundedBox( 0, x0, y, 200, 24, Color( 0, 0, 0, 220 ) );
		
		surface.SetDrawColor( col );
		surface.SetMaterial( Material( tex ) );
		surface.DrawTexturedRect( x0 + 4, y + 4, 16, 16 );
		
		draw.DrawText( t, "VCandara20", x0 + 24, y + 2, Color( 255, 255, 255, 255 ), 0 );
		
		y = y + 32;
		
	end
	
	for k, v in pairs( NonUrgentTab ) do
		
		local val = v + 5;
		
		local tex = V.STAT.List[k][3];
		local col = V.STAT.Colors[val];
		local t = V.STAT.List[k][4][val];
		
		local x0 = V.CurStatusX[k];
		
		draw.RoundedBox( 0, x0, y, 200, 24, Color( 0, 0, 0, 220 ) );
		
		surface.SetDrawColor( col );
		surface.SetMaterial( Material( tex ) );
		surface.DrawTexturedRect( x0 + 4, y + 4, 16, 16 );
		
		draw.DrawText( t, "VCandara20", x0 + 24, y + 2, Color( 255, 255, 255, 255 ), 0 );
		
		y = y + 32;
		
	end
	
end

function V.PaintCaption()
	
	local t = CurTime() - V.CaptionStart;
	
	if( t >= 0 and t < V.CaptionDuration ) then
		
		local amul = 0;
		
		if( t < 0.5 ) then
			
			amul = t * 2;
			
		end
		
		if( t >= 0.5 and t < V.CaptionDuration - 0.5 ) then
			
			amul = 1;
			
		end
		
		if( t >= V.CaptionDuration - 0.5 ) then
			
			amul = 1 - ( ( t - ( V.CaptionDuration - 0.5 ) ) * 2 );
			
		end
		
		draw.DrawText( V.CaptionText, "VCandara50", ScrW() / 2, ScrH() * 4/5, Color( 255, 255, 255, amul * 255 ), 1 );
		
	end
	
end

function GM:HUDPaint()
	
	V.PaintOtherPeople();
	V.PaintDoors();
	
	if( !V.CB.ChatBox ) then
		
		V.CB.DrawChatLines();
		
	end
	
	V.INS.DrawHUD();
	
	V.PaintVignette();
	V.PaintRain();
	V.PaintStatus();
	V.PaintSleep();
	V.PaintDead();
	V.PaintBlackScreen();
	V.PaintIntro();
	V.PaintFancyIntro();
	V.PaintCaption();
	
	if( V.Nuked ) then
		
		if( CurTime() - V.NukeStart <= 0.2 ) then
			
			surface.SetDrawColor( 255, 255, 255, 255 * math.Clamp( ( CurTime() - V.NukeStart ) * 5, 0, 1 ) );
			
		else
			
			surface.SetDrawColor( 255, 255, 255, 255 * ( 1 - math.Clamp( ( ( CurTime() - V.NukeStart ) - 0.2 ) / 3, 0, 1 ) ) );
			
		end
		
		surface.DrawRect( 0, 0, ScrW(), ScrH() );
		
	end
	
end

function GM:RenderScreenspaceEffects()
	
	if( V.BlackScreenAlpha == 255 ) then return end
	
	V.INS.Render();
	V.STAT.Render();
	
	local tab = { };
	
	tab[ "$pp_colour_addr" ] 		= 0;
	tab[ "$pp_colour_addg" ] 		= 0;
	tab[ "$pp_colour_addb" ] 		= 0;
	tab[ "$pp_colour_brightness" ] 	= 0;
	tab[ "$pp_colour_contrast" ] 	= 1;
	tab[ "$pp_colour_colour" ] 		= 1 - 0.45 * tonumber( V.SET.Settings["colormul"] );
	tab[ "$pp_colour_mulr" ] 		= 0;
	tab[ "$pp_colour_mulg" ] 		= 0;
	tab[ "$pp_colour_mulb" ] 		= 0;
	
	DrawColorModify( tab );
	
end

function GM:HUDShouldDraw( str )
	
	if( str == "CHudWeaponSelection" ) then return false end
	if( str == "CHudAmmo" ) then return false end
	if( str == "CHudAmmoSecondary" ) then return false end
	if( str == "CHudHealth" ) then return false end
	if( str == "CHudCrosshair" ) then return false end
	if( str == "CHudChat" ) then return false end
	if( str == "CHudDamageIndicator" ) then return false end
	return true
	
end

function GM:PreDrawHalos()
	
	V.ME.PreDrawHalos();
	V.INV.PreDrawHalos();
	
end