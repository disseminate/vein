
AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.RenderGroup 		= RENDERGROUP_TRANSLUCENT
ENT.Widget				= true

ENT.Materials			=
{
	Button = Material( "widgets/btn.png" )
}

function ENT:SetupDataTables()

	--self:NetworkVar( "Float", 0, "SizeVar" );		-- Size (bounds)
	self:SetNWFloat( "SizeVar", 4 );

end

--
-- Unfilled, for override. Self explanatory.
-- Called on both client and server in multiplayer
-- Only on the server in singleplayer.
--
function ENT:OnClick( ply )end
function ENT:OnRightClick( ply ) end
function ENT:PressedThink( pl, mv ) end
function ENT:PressedShouldDraw( widget ) return true end
function ENT:PressStart( pl, mv ) end
function ENT:PressEnd( pl, mv ) end
function ENT:DragThink( pl, mv, dist ) end

--
-- Set our dimensions etc
--
function ENT:Initialize()
	
	self:SetCollisionGroup( COLLISION_GROUP_WORLD )
	self:DrawShadow( false )
	self:EnableCustomCollisions()
	self.Color = Color( 0, 255, 255 )
	self.Color_Hover = Color( 255, 255, 255 )
	
	if ( SERVER ) then
		self:SetSize( 4 )
	end
	
end

function ENT:GetSize()
	return self:GetNWFloat( "SizeVar" )
end

function ENT:SetSize( size )
	
	if ( self:GetSize() == size ) then return end
	
	self:SetNWFloat( "SizeVar", size )
	self:SetSolid( SOLID_BBOX )
	self:SetCollisionBounds( Vector( size, size, size) * -0.5, Vector( size, size, size) * 0.5 )

end

function ENT:GetGrabPos( Pos, Forward )

	local fwd = Forward
	local eye = Pos
	
	local planepos = self:GetPos()
	local planenrm = (eye-planepos):GetNormal()
	
	return util.IntersectRayWithPlane( eye, fwd, planepos, planenrm )

end

function ENT:PressedThinkInternal( ply, mv )
	
	if( !ply:IsAdmin() ) then return end
	
	if ( !ply.WidgetMove ) then
		ply.WidgetMove = {}
		ply.WidgetMove.EyePos = ply:EyePos()
		ply.WidgetMove.EyeVec = ply:GetAimVector()
	end

	local OldPos = self:GetGrabPos( ply.WidgetMove.EyePos, ply.WidgetMove.EyeVec )
	local NewPos = self:GetGrabPos( ply:EyePos(), ply:GetAimVector() )
	
	if ( NewPos && OldPos ) then
	
		local dist = self:WorldToLocal(OldPos) - self:WorldToLocal( NewPos )
		
		if ( dist:Length() > 0.01 ) then
			self:DragThink( ply, mv, dist )
		end
	
	end

	self:PressedThink( ply, mv )
	
	-- Store the (new) old eye positions
	ply.WidgetMove.EyePos = ply:EyePos()
	ply.WidgetMove.EyeVec = ply:GetAimVector()
	
end


--
-- Called by widget's Tick hook when a mouse button was
-- pressed while hovering over this widget
--
function ENT:OnPress( ply, iButton, mv )
	
	if( !ply:IsAdmin() ) then return end
	
	if ( self.Pressed ) then return end
	
	ply:SetPressedWidget( self )
	
	ply.WidgetMove = {}
	ply.WidgetMove.EyePos = ply:EyePos()
	ply.WidgetMove.EyeVec = ply:GetAimVector()
	
	self:PressStart( ply, mv )
			
end

--
-- Called by widget's Tick hook when a mouse button was
-- released while this widget is pressed
--
function ENT:OnRelease( ply, iButton, mv )
	
	if( !ply:IsAdmin() ) then return end
	
	ply:SetPressedWidget( NULL )
	ply.WidgetMove = nil
	self:PressEnd( ply, mv )
	
	--
	-- The player has to click and release on the widget
	-- or we assume they clicked and changed their mind 
	-- so dragged off.. like people do sometimes.
	--
	if ( ply:GetHoveredWidget() != self ) then return end
	
	--
	-- Left Mouse
	--
	if ( iButton == 1 ) then
		self:OnClick( ply )
	end
	
	--
	-- Right Mouse
	--
	if ( iButton == 1 ) then
		self:OnRightClick( ply )
	end
			
end

function ENT:IsHovered()
	return ( LocalPlayer():GetHoveredWidget() == self and LocalPlayer():IsAdmin() )
end

function ENT:SomethingHovered()
	return ( IsValid( LocalPlayer():GetHoveredWidget() ) and LocalPlayer():IsAdmin() )
end

function ENT:IsPressed()
	return LocalPlayer():GetPressedWidget() == self
end

function ENT:Draw()

	widgets.RenderMe( self )
	
end

function ENT:OverlayRender()

	local col = Color( 255, 255, 255, 255 )
	
	if ( self:IsHovered() ) then
		col = Color( 20, 50, 100, 255 )
	elseif ( self:SomethingHovered() ) then
		-- less alpha
	end
	
	if ( self:IsPressed() ) then
	
		col = Color( 180, 180, 50, 255 )
		
		if ( LocalPlayer():GetHoveredWidget() == LocalPlayer():GetPressedWidget() ) then
			col = Color( 255, 255, 100, 255 )
		end
		
	end
	
	local vSize = Vector( self:GetSize(), self:GetSize(), self:GetSize() )

	render.SetColorMaterialIgnoreZ()
	render.DrawCube( self:GetPos(), vSize, ColorAlpha( col, 0.8 ), false )
	
	render.SetColorMaterial()
	render.DrawCube( self:GetPos(), vSize, col, false )		
	
end
