V.EF = { }

V.EF.CurMusic = nil;
V.EF.NextRepeat = nil;
V.EF.CurMusicPatch = nil;
V.EF.NextMusic = nil;
V.EF.NextMusicTime = nil;
V.EF.NextActionMusicTime = 0;
V.EF.SongEnd = 0;

V.EF.RainSound = nil;
V.EF.RainSoundPlaying = 0;

V.EF.NextSeeZombie = 0;

function V.EF.FindDuration( str )
	
	for _, v in pairs( V.Music ) do
		
		if( string.find( str, v[1] ) ) then
			
			return v[2];
			
		end
		
	end
	
	return 60;
	
end

function V.EF.PlayMusic( str, fadelen )
	
	if( !fadelen ) then fadelen = 1 end
	
	V.EF.NextMusic = str;
	
	if( fadelen == 0 ) then
		
		V.EF.StopMusic();
		
	end
	
	if( V.EF.CurMusicPatch ) then
		
		V.EF.NextMusicTime = CurTime() + fadelen;
		V.EF.CurMusicPatch:ChangeVolume( 0, fadelen );
		
	else
		
		V.EF.NextMusicTime = CurTime();
		
	end
	
end

function V.EF.FadeMusic( fadelen )
	
	if( !fadelen ) then fadelen = 1 end
	
	if( V.EF.CurMusicPatch and V.EF.CurMusicPatch:IsPlaying() ) then
		
		V.EF.CurMusicPatch:ChangeVolume( 0, fadelen );
		V.EF.StartMusicTime = nil;
		
	end
	
end

function V.EF.StopMusic()
	
	if( V.EF.CurMusicPatch and V.EF.CurMusicPatch:IsPlaying() ) then
		
		V.EF.CurMusicPatch:Stop();
		V.EF.StartMusicTime = nil;
		
	end
	
end

function V.EF.PickGenericSong()
	
	local song = "vein/" .. table.Random( V.EF.GenericPlayable ) .. ".mp3";
	V.EF.PlayMusic( song, 0 );
	
end

function V.EF.PickActionSong()
	
	local song = "vein/" .. table.Random( V.EF.ActionPlayable ) .. ".mp3";
	V.EF.PlayMusic( song, 0 );
	
end

function V.EF.PickSafeActionSong()
	
	local song = "vein/" .. table.Random( V.EF.SafeActionPlayable ) .. ".mp3";
	V.EF.PlayMusic( song, 0 );
	
end

function V.EF.PickHardcoreActionSong()
	
	local song = "vein/" .. table.Random( V.EF.HardcoreActionPlayable ) .. ".mp3";
	V.EF.PlayMusic( song, 0 );
	
end

function V.EF.CanPlayMusic()
	
	if( V.CC.CharCreateOpen ) then return false end
	if( !LocalPlayer():Alive() ) then return false end
	if( !V.Config.MusicEnabled ) then return false end
	if( V.SET.Settings["music"] == "0" ) then return false end
	if( V.Nuked ) then return false end
	return true;
	
end

function V.EF.Think()
	
	V.NukeThink();
	
	if( V.W.Raining ) then
		
		if( !V.W.RainSound ) then
			
			V.W.RainSound = CreateSound( LocalPlayer(), "ambient/weather/crucial_rumble_rain.wav" );
			V.W.RainSound:PlayEx( 0, 100 );
			
		end
		
		local s = GAMEMODE:CalcView( LocalPlayer(), LocalPlayer():EyePos(), LocalPlayer():EyeAngles(), 75 );
		
		if( V.Outside( s.origin ) and V.EF.RainSoundPlaying != 0.4 ) then
			
			V.W.RainSound:ChangeVolume( 0.4, 1 );
			V.EF.RainSoundPlaying = 0.4;
			
		elseif( !V.Outside( s.origin ) ) then
			
			if( util.IsSkyboxVisibleFromPoint( s.origin ) and V.EF.RainSoundPlaying != 0.15 ) then
				
				V.W.RainSound:ChangeVolume( 0.15, 1 );
				V.EF.RainSoundPlaying = 0.15;
				
			elseif( !util.IsSkyboxVisibleFromPoint( s.origin ) and V.EF.RainSoundPlaying != 0 ) then
				
				V.W.RainSound:ChangeVolume( 0, 1 );
				V.EF.RainSoundPlaying = 0;
				
			end
			
		end
		
	elseif( V.EF.RainSoundPlaying > 0 ) then
		
		V.W.RainSound:ChangeVolume( 0, 1 );
		V.EF.RainSoundPlaying = 0;
		
	end
	
	if( GAMEMODE:InIntro() ) then return end
	if( V.INS.Level >= 3 ) then return end
	
	if( V.EF.NextMusicTime and CurTime() >= V.EF.NextMusicTime ) then
		
		V.EF.CurMusic = V.EF.NextMusic;
		
		V.EF.CurMusicPatch = CreateSound( LocalPlayer(), V.EF.CurMusic );
		V.EF.CurMusicPatch:Play();
		
		V.EF.SongEnd = CurTime() + V.EF.FindDuration( V.EF.CurMusic );
		
		V.EF.NextMusic = nil;
		V.EF.NextMusicTime = nil;
		
	end
	
	if( !V.EF.CurMusicPatch or ( V.EF.CurMusicPatch and CurTime() > V.EF.SongEnd ) ) then
		
		if( !V.EF.NextActionMusicTime ) then
			
			V.EF.NextActionMusicTime = 0;
			
		elseif( V.EF.CanPlayMusic() ) then
			
			if( #V.EF.ZombiesNearMe( 240 ) > 20 and !LocalPlayer():IsEFlagSet( EFL_NOCLIP_ACTIVE ) ) then -- lots of zombies, small radius!
				
				V.EF.PickHardcoreActionSong();
				V.EF.NextActionMusicTime = CurTime() + math.random( 600, 900 );
				V.EF.NextGeneric = CurTime() + math.random( 200, 300 );
				
			elseif( #V.EF.ZombiesNearMe( 768 ) > 20 and CurTime() > V.EF.NextActionMusicTime ) then
				
				if( #V.EF.ArmedPlayersNearMe( 128 ) > 1 ) then
					
					V.EF.PickSafeActionSong();
					
				else
					
					V.EF.PickActionSong();
					
				end
				
				V.EF.NextActionMusicTime = CurTime() + math.random( 600, 900 );
				V.EF.NextGeneric = CurTime() + math.random( 200, 300 );
				
			end
			
		end
		
		if( !V.EF.NextGeneric ) then
			
			V.EF.NextGeneric = 0;
			
		elseif( CurTime() >= V.EF.NextGeneric and V.EF.CanPlayMusic() ) then
			
			V.EF.PickGenericSong();
			V.EF.NextActionMusicTime = CurTime() + math.random( 200, 300 );
			V.EF.NextGeneric = CurTime() + math.random( 600, 900 );
			
		end
		
	end
	
	for _, v in pairs( ents.FindByClass( "v_zombie" ) ) do
		
		local pos = v:EyePos():ToScreen();
		
		if( pos.visible ) then
			
			if( LocalPlayer():CanSee( v ) ) then -- We can see and have line of sight to the zombie
				
				local d = v:GetPos():Distance( LocalPlayer():GetPos() );
				
				if( d < 100 and V.STAT.GetStatus( ply, V.STAT.STATUS_DRUNK ) < 1 ) then
					
					if( CurTime() > V.EF.NextSeeZombie ) then
						
						V.EF.Panic();
						
					end
					
				end
				
				V.EF.NextSeeZombie = CurTime() + 1200;
				
				break;
				
			end
			
		end
		
	end
	
end

function V.EF.UM( um )
	
	local str = net.ReadString();
	local dur = net.ReadFloat();
	
	V.EF.PlayMusic( str, dur );
	
end
net.Receive( "nEffectPlayMusic", V.EF.UM );

function V.EF.SM( um )
	
	V.EF.StopMusic();
	
end
net.Receive( "nEffectStopMusic", V.EF.SM );

function V.EF.Panic()
	
	if( !V.CC.CharCreateOpen ) then
		
		surface.PlaySound( "vein/panic.mp3" );
		V.STAT.Panic();
		
	end
	
end

function nPlayExpression( len )
	
	local ent = net.ReadEntity();
	local scene = net.ReadString();
	
	if( ent.Expression and ent.Expression:IsValid() ) then
		
		ent.Expression:Remove();
		
	end
	
	ent.Expression = ClientsideScene( scene, ent );
	
end
net.Receive( "nPlayExpression", nPlayExpression );

V.EF.ThirdPerson = false;
V.EF.CurPos = Vector();
V.EF.CurAng = Angle();
V.EF.DestPos = Vector();
V.EF.DestAng = Angle();

V.EF.Lerp = 0.05;

function V.EF.SetThirdPerson( b )
	
	V.EF.CurPos = LocalPlayer():EyePos();
	V.EF.CurAng = LocalPlayer():EyeAngles();
	V.EF.ThirdPerson = b;
	
end

function V.EF.GetThirdPerson()
	
	return V.EF.ThirdPerson;
	
end

V.EF.MatBlur = Material( "pp/blurscreen" );

function V.EF.DrawDead()
	
	if( V.Dead ) then
		
		local frac = math.Clamp( ( CurTime() - V.DieStart ) / 5, 0, 5 ) / 5;
		
		surface.SetMaterial( V.EF.MatBlur );
		surface.SetDrawColor( 255, 255, 255, 255 )
		
		for i = 0.33, 1, 0.33 do
			
			V.EF.MatBlur:SetFloat( "$blur", frac * 5 * i );
			render.UpdateScreenEffectTexture();
			surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() );
			
		end
		
		surface.SetDrawColor( 10, 10, 10, 200 * frac );
		surface.DrawRect( 0, 0, ScrW(), ScrH() );
		
	end
	
end

function nDie( len )
	
	local b = net.ReadFloat();
	local t = net.ReadFloat();
	
	V.Dead = true;
	V.DieTime = t;
	
	if( b == 0 ) then
		
		V.EF.PlayMusic( "vein/youaredead.mp3", 0 );
		V.DieStart = CurTime();
		
	else
		
		V.DieStart = -math.huge;
		
	end
	
	V.INS.UpdateInsanity();
	
end
net.Receive( "nDie", nDie );

function nDieReset( len )
	
	V.Dead = nil;
	V.DieTime = nil;
	
end
net.Receive( "nDieReset", nDieReset );

function nNuke( len )
	
	V.NukeStart = CurTime();
	V.Nuked = true;
	V.EF.StopMusic();
	
	LocalPlayer():EmitSound( Sound( "vein/nuke.mp3" ), 511 );
	
end
net.Receive( "nNuke", nNuke );

function V.NukeThink()
	
	if( V.Nuked ) then
		
		local t = CurTime() - V.NukeStart;
		
		if( t >= 1 and !V.NukeFX ) then
			
			V.NukeFX = true;
			
		end
		
	end
	
end

function GM:PreDrawOpaqueRenderables()
	
	for _, v in pairs( ents.FindByClass( "class C_EnvProjectedTexture" ) ) do
		
		local p = v:GetParent();
		
		if( p and p:IsValid() and p:IsPlayer() ) then
			
			v:SetAngles( p:GetAimVector():Angle() );
			v:SetRenderAngles( p:GetAimVector():Angle() );
			
		end
		
	end
	
end

function V.EF.ZombiesNearMe( r )
	
	local n = { };
	
	for _, v in pairs( ents.FindByClass( "v_zombie" ) ) do
		
		if( LocalPlayer():GetPos():Distance( v:GetPos() ) < r ) then
			
			table.insert( n, v );
			
		end
		
	end
	
	return n;
	
end

function V.EF.ArmedPlayersNearMe( r )
	
	local n = { };
	
	for _, v in pairs( player.GetAll() ) do
		
		if( LocalPlayer():GetPos():Distance( v:GetPos() ) < r and v:GetActiveWeapon() != NULL ) then
			
			table.insert( n, v );
			
		end
		
	end
	
	return n;
	
end

--[[
	Bugged L4D blendmode materials:
	"brick/mainstreet_brickwall_01a",
	"brick/mainstreet_brickwall_01b",
	"brick/mainstreet_brickwall_01c",
	"brick/urban_a_brickwall_02b",
	"brick/urban_a_brickwall_03a",
	"brick/urban_a_brickwall_03b",
	"brick/urban_brickwall_01a",
	"brick/urban_brickwall_02a",
	"brick/urban_brickwall_02b",
	"brick/urban_brickwall_03a",
	"brick/urban_brickwall_03a_white",
	"brick/urban_brickwall_03b",
	"brick/urban_brickwall_03b_white",
	"brick/urban_brickwall_05a",
	"brick/urban_brickwall_05b",
	"brick/urban_brickwall_05c",
	"brick/urban_brickwall_06a",
	"brick/urban_brickwall_06c",
	"brick/wall20",
	"models/props_unique/urban_brickwall_03a",
	"models/props_unique/urban_brickwall_03a_lighter",
	"models/props_urban/urban_brickwall_03a",
	"nature/blenddirt01grass_ruddy_small",
	"plaster/rooffloor_tar02",
--]]