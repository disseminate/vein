hook.Remove( "PostDrawEffects", "RenderWidgets" );
hook.Remove( "PlayerTick", "TickWidgets" );

widgets = {}

local function UpdateHovered( pl, mv )

	if ( !IsValid( pl ) ) then return end
	if( !pl:IsAdmin() ) then return end

	if ( !pl:Alive() ) then 
		pl:SetHoveredWidget( NULL ) 
		return 
	end

	local OldHovered = pl:GetHoveredWidget()
	pl:SetHoveredWidget( NULL )

	local trace = 
	{
		start	= pl:EyePos(),
		endpos	= pl:EyePos() + pl:GetAimVector() * 16384,
		filter	= function( ent )
		
					  return ent:IsValid() && ent:IsWidget()
		
				  end
	}
	
	widgets.Tracing = true
	local tr = util.TraceLine( trace )
	widgets.Tracing = false
	
	if ( !IsValid( tr.Entity ) ) then return end
	if ( tr.Entity:IsWorld() ) then return end
	if ( !tr.Entity:IsWidget() ) then return end
	
	pl:SetHoveredWidget( tr.Entity )
	pl.WidgetHitPos = tr.HitPos

end

local function UpdateButton( pl, mv, btn, mousebutton )

	local now = mv:KeyDown( btn )
	local was = mv:KeyWasDown( btn )
	local hvr = pl:GetHoveredWidget()
	local prs = pl:GetPressedWidget()
	
	if ( now && !was && IsValid( hvr ) and hvr.OnPress ) then
		hvr:OnPress( pl, mousebutton, mv ) 
	end
	
	if ( !now && was && IsValid( prs ) and prs.OnRelease ) then
		prs:OnRelease( pl, mousebutton, mv )	
	end
	
end

function widgets.PlayerTick( pl, mv )

	UpdateHovered( pl, mv )
	
	UpdateButton( pl, mv, IN_ATTACK, 1 )
	UpdateButton( pl, mv, IN_ATTACK2, 2 )
	
	local prs = pl:GetPressedWidget()
	
	if ( IsValid( prs ) ) then
		prs:PressedThinkInternal( pl, mv )
	end
	
end

local RenderList = {}

function widgets.RenderMe( ent )
	
	if ( LocalPlayer() && IsValid(LocalPlayer():GetPressedWidget()) ) then
	
		if ( !LocalPlayer():GetPressedWidget():PressedShouldDraw( ent ) ) then 
			return 
		end
	
	end
	

	table.insert( RenderList, ent )

end

hook.Add( "PostDrawEffects", "RenderWidgets", function() 
	
	if ( #RenderList == 0 ) then return end

	cam.Start3D( EyePos(), EyeAngles() )

		for k, v in pairs( RenderList ) do
	
			v:OverlayRender()
	
		end
	
	cam.End3D()
	
	RenderList = {}

end )

hook.Add( "PlayerTick", "TickWidgets", function( pl, mv ) widgets.PlayerTick( pl, mv ) end )