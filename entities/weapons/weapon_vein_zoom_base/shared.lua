if( SERVER ) then
	
	AddCSLuaFile( "shared.lua" );
	
end

SWEP.Base				= "weapon_vein_base";

SWEP.Zoomable			= true;

SWEP.Zoomed				= false;
SWEP.FOV				= 20;
SWEP.SensitivityScale	= 0.25;

SWEP.ZoomClickDelay		= 0.4;

SWEP.ScopeTextureTop	= "gmod/scope";
SWEP.ScopeTexture		= "gmod/scope-refract";

SWEP.ScopeCrosshairs	= true;

function SWEP:SecondaryAttack()
	
	if( !IsFirstTimePredicted() ) then return end
	if( self.Owner:IsWorldClicking() ) then return false end
	if( self.Owner.LastZoomClick and CurTime() - self.Owner.LastZoomClick < self.ZoomClickDelay ) then return end
	
	self.Owner.LastZoomClick = CurTime();
	self.StartZoom = CurTime();
	
	self.Zoomed = !self.Zoomed;
	self.RefreshDOF = true;
	
end

function SWEP:TranslateFOV( fov )
	
	if( self.StartZoom ) then
		
		local t = CurTime() - self.StartZoom;
		
		if( ( t >= 0.2 and self.Zoomed ) or ( t < 0.2 and !self.Zoomed ) ) then
			
			return self.FOV;
			
		end
		
	end
	
	return fov;
	
end

function SWEP:AdjustMouseSensitivity()
	
	if( self.StartZoom ) then
		
		local t = CurTime() - self.StartZoom;
		
		if( ( t >= 0.2 and self.Zoomed ) or ( t < 0.2 and !self.Zoomed ) ) then
			
			return self.SensitivityScale;
			
		end
		
	end
	
	return 1;
	
end

function SWEP:DrawHUD()
	
	if( self.StartZoom ) then
		
		local t = CurTime() - self.StartZoom;
		
		if( ( t >= 0.2 and self.Zoomed ) or ( t < 0.2 and !self.Zoomed ) ) then
			
			local h = ScrH();
			local w = ( 4 / 3 ) * h;
			
			local dw = ( ScrW() - w ) / 2;
			
			surface.SetDrawColor( Color( 0, 0, 0, 255 ) );
			surface.DrawRect( 0, 0, dw, h );
			surface.DrawRect( w + dw, 0, dw, h );
			
			if( render.GetDXLevel() >= 90 ) then
				
				surface.SetTexture( surface.GetTextureID( self.ScopeTexture ) );
				surface.SetDrawColor( Color( 255, 255, 255, 255 ) );
				surface.DrawTexturedRect( dw, 0, w, h );
				
			end
			
			surface.SetTexture( surface.GetTextureID( self.ScopeTextureTop ) );
			surface.SetDrawColor( Color( 0, 0, 0, 255 ) );
			surface.DrawTexturedRect( dw, 0, w, h );
			
			if( self.ScopeCrosshairs ) then
				
				surface.SetDrawColor( Color( 0, 0, 0, 255 ) );
				
				surface.DrawLine( 0, ScrH() / 2, ScrW(), ScrH() / 2 );
				surface.DrawLine( ScrW() / 2, 0, ScrW() / 2, ScrH() );
				
			end
			
		end
		
		if( t > 0 and t <= 0.4 ) then
			
			local a = 0;
			
			if( t < 0.2 ) then
				
				a = t / 0.2;
				
			elseif( t < 0.4 ) then
				
				a = 1 - ( ( t - 0.2 ) / 0.2 );
				
			end
			
			surface.SetDrawColor( Color( 0, 0, 0, 255 * a ) );
			surface.DrawRect( 0, 0, ScrW(), ScrH() );
			
		end
		
	end
	
end