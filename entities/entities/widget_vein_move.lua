
AddCSLuaFile()

DEFINE_BASECLASS( "widget_vein_arrow" )

local widget_axis_arrow = { Base = "widget_vein_arrow" }

function widget_axis_arrow:Initialize()

	BaseClass.Initialize( self )
		
end

function widget_axis_arrow:SetupDataTables()

	BaseClass.SetupDataTables( self )
	self:SetDTInt( 1, 0 );

end

function widget_axis_arrow:ArrowDragged( pl, mv, dist )

	self:GetParent():OnArrowDragged( self:GetDTInt( 1 ), dist, pl, mv )

end

scripted_ents.Register( widget_axis_arrow, "widget_vein_axis_arrow" )

--
-- widget_axis_disc
--

DEFINE_BASECLASS( "widget_vein_disc" )

local widget_axis_disc = { Base = "widget_vein_disc" }

function widget_axis_disc:Initialize()

	BaseClass.Initialize( self )
		
end

function widget_axis_disc:SetupDataTables()

	BaseClass.SetupDataTables( self )
	self:SetDTInt( 1, 0 );

end


function widget_axis_disc:ArrowDragged( pl, mv, dist )

	self:GetParent():OnArrowDragged( self:GetDTInt( 1 ), dist, pl, mv )

end

scripted_ents.Register( widget_axis_disc, "widget_vein_axis_disc" )




local matArrow = Material( "widgets/arrow.png" )

DEFINE_BASECLASS( "widget_vein_base" )

function ENT:Initialize()

	BaseClass.Initialize( self )
	
	self:SetCollisionBounds( Vector( -1, -1, -1 ), Vector( 1, 1, 1 ) )
	self:SetSolid( SOLID_NONE )
	
end

function ENT:OnClick( ply ) MsgN( "OnClick" ) end
function ENT:OnRightClick( ply ) MsgN( "OnRightClick" ) end
function ENT:PressedThink( pl, mv ) MsgN( "PressedThink" ) end
function ENT:PressedShouldDraw( widget ) MsgN( "PressedShouldDraw" ) return true end
function ENT:PressStart( pl, mv ) MsgN( "PressStart" ) end
function ENT:PressEnd( pl, mv ) MsgN( "PressEnd" ) end
function ENT:DragThink( pl, mv, dist ) MsgN( "DragThink" ) end

function ENT:Setup( ent, boneid, rotate, size )
	
	self.Rotating = rotate;
	
	self:FollowBone( ent, boneid or 0 )
	self:SetLocalPos( Vector( 0, 0, 0 ) )
	self:SetLocalAngles( Angle( 0, 0, 0 ) )
	
	local EntName = "widget_vein_axis_arrow"
	if ( rotate ) then EntName = "widget_vein_axis_disc" end

	self.ArrowX = ents.Create( EntName )
		self.ArrowX:SetParent( self )
		self.ArrowX:SetColor( Color( 255, 0, 0, 255 ) )
		self.ArrowX:Spawn()
		self.ArrowX:SetLocalPos( Vector( 0, 0, 0 ) )
		self.ArrowX:SetLocalAngles( Vector(1,0,0):Angle() )
		self.ArrowX:SetSize( size );
		self.ArrowX:SetDTInt( 1, 1 );
		self.ArrowX:SetDTInt( 0, 5 );
		
	self.ArrowY = ents.Create( EntName )
		self.ArrowY:SetParent( self )
		self.ArrowY:SetColor( Color( 0, 230, 50, 255 ) )
		self.ArrowY:Spawn()
		self.ArrowY:SetLocalPos( Vector( 0, 0, 0 ) )
		self.ArrowY:SetLocalAngles( Vector(0,1,0):Angle() )
		self.ArrowY:SetSize( size );
		self.ArrowY:SetDTInt( 1, 2 );
		self.ArrowY:SetDTInt( 0, 5 );
		
	self.ArrowZ = ents.Create( EntName )
		self.ArrowZ:SetParent( self )
		self.ArrowZ:SetColor( Color( 50, 100, 255, 255 ) )
		self.ArrowZ:Spawn()
		self.ArrowZ:SetLocalPos( Vector( 0, 0, 0 ) )
		self.ArrowZ:SetLocalAngles( Vector(0,0,1):Angle() )
		self.ArrowZ:SetSize( size );
		self.ArrowZ:SetDTInt( 1, 3 );
		self.ArrowZ:SetDTInt( 0, 5 );
			
end

function ENT:Draw()	
end

function ENT:InvalidateSize()
	
	self.ArrowX:InvalidateSize( self:GetParent() );
	self.ArrowY:InvalidateSize( self:GetParent() );
	self.ArrowZ:InvalidateSize( self:GetParent() );
	
end

function ENT:OnArrowDragged( num, dist, pl, mv )
	
	if( CLIENT ) then return end
	
	if( self.Rotating ) then
		
		local ent = self:GetParent();
		local arrow;
		
		if ( num == 2 ) then arrow = self.ArrowX end
		if ( num == 3 ) then arrow = self.ArrowY end
		if ( num == 1 ) then arrow = self.ArrowZ end
		
		if ( !IsValid( arrow ) ) then return end
		
		local a = arrow:GetAngles();
		
		if ( !IsValid( ent ) ) then return end
		
		local ang = ent:GetAngles();
		
		if ( num == 2 ) then ang:RotateAroundAxis( a:Right(), -dist ); end
		if ( num == 3 ) then ang:RotateAroundAxis( a:Up(), dist ); end
		if ( num == 1 ) then ang:RotateAroundAxis( a:Up(), -dist ); end
		
		ent:SetAngles( ang );
		
	else
		
		local ent = self:GetParent();
		local arrow;
		
		if ( num == 1 ) then arrow = self.ArrowX end
		if ( num == 2 ) then arrow = self.ArrowY end
		if ( num == 3 ) then arrow = self.ArrowZ end
		
		if ( !IsValid( arrow ) ) then return end
		
		local fwd = arrow:GetAngles():Forward();
		
		if ( !IsValid( ent ) ) then return end
		
		local v = fwd * dist;
		
		ent:SetPos( ent:GetPos() + v );
		
	end

end