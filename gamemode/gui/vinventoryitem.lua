local PANEL = { };

AccessorFunc( PANEL, "m_fAnimSpeed", 	"AnimSpeed" )
AccessorFunc( PANEL, "Entity", 			"Entity" )
AccessorFunc( PANEL, "vCamPos", 		"CamPos" )
AccessorFunc( PANEL, "fFOV", 			"FOV" )
AccessorFunc( PANEL, "vLookatPos", 		"LookAt" )
AccessorFunc( PANEL, "colAmbientLight", "AmbientLight" )
AccessorFunc( PANEL, "colColor", 		"Color" )
AccessorFunc( PANEL, "bAnimated", 		"Animated" )

V_MODELPANEL = { };
V_MODELPANEL.VIEWDATA = { };

function PANEL:CalcPanelDims() -- spawnicon code from garry
	
	if( !V_MODELPANEL.VIEWDATA[self.Entity:GetModel()] ) then
		
		if( self.Entity:LookupAttachment( "eyes" ) > 0 ) then
			
			local at = self.Entity:GetAttachment( self.Entity:LookupAttachment( "eyes" ) );
			
			local ViewAngle = at.Ang + Angle( -10, 160, 0 );
			local ViewPos = at.Pos + ViewAngle:Forward() * -60 + ViewAngle:Up() * -2;
			local view = { };
			
			view.fov = 10;
			view.origin = ViewPos;
			view.angles = ViewAngle;
			
			V_MODELPANEL.VIEWDATA[self.Entity:GetModel()] = view;
			
		else
			
			local mn, mx = self.Entity:GetRenderBounds()
			local middle = ( mn + mx ) * 0.5
			local size = 0
			size = math.max( size, math.abs(mn.x) + math.abs(mx.x) );
			size = math.max( size, math.abs(mn.y) + math.abs(mx.y) );
			size = math.max( size, math.abs(mn.z) + math.abs(mx.z) );
			
			size = size * ( 1 - ( size / 900 ) );
			
			local ViewAngle = Angle( 25, 220, 0 )
			local ViewPos = self.Entity:GetPos() + ViewAngle:Forward() * size * -15
			local view = { };
			
			view.fov		= 4 + size * 0.04;
			view.origin	 	= ViewPos + middle;
			view.angles		= ViewAngle;
			
			V_MODELPANEL.VIEWDATA[self.Entity:GetModel()] = view;
			
		end
		
	end
	
end

function PANEL:Init()
	
	self:SetSize( 64, 64 );
	self.LastPaint = 0;
	
	self:SetText( "" );
	self:SetAnimSpeed( 0.5 );
	self:SetAnimated( true );
	
	self:SetAmbientLight( Color( 50, 50, 50 ) );
	
	self:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) );
	self:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) );
	
	self:SetColor( Color( 255, 255, 255, 255 ) );
	
	self.Entity = ClientsideModel( "models/humans/group01/male_01.mdl", RENDER_GROUP_OPAQUE_ENTITY );
	self.Entity:SetNoDraw( true );
	
	self:CalcPanelDims();
	
	self:SetCamPos( Vector( 50, 50, 50 ) );
	self:SetLookAt( Vector( 0, 0, 40 ) );
	self:SetFOV( 70 );
	
	self.HasModel = false;
	
	self.Selected = false;
	
	self.CornerText = "";

end

function PANEL:SetCornerText( text )
	
	self.CornerText = text;
	
end

function PANEL:SetModel( strModelName )
	
	self.Entity:SetModel( strModelName );
	self.Entity:SetNoDraw( true );
	
	self:CalcPanelDims();
	
	if( string.len( strModelName ) == 0 ) then
		
		self.HasModel = false;
		
	else
		
		self.HasModel = true;
		
	end
	
end

function PANEL:GetModel()
	
	return self.Entity:GetModel();
	
end

function PANEL:SetSkin( i )
	
	self.Entity:SetSkin( i );
	
end

function PANEL:SetButton( func )
	
	self.Button = func;
	
end

function PANEL:Paint()
	
	if( !IsValid( self.Entity ) ) then return end
	if( !self.HasModel ) then return end
	
	local x, y = self:LocalToScreen( 0, 0 )
	
	self:LayoutEntity( self.Entity );
	
	local dat = V_MODELPANEL.VIEWDATA[self.Entity:GetModel()];
	
	cam.Start3D( dat.origin, dat.angles, dat.fov + ( self.Selected and ( math.sin( CurTime() * 4 ) ) or 0 ), x, y, self:GetSize() )
		cam.IgnoreZ( true )
		
		render.SuppressEngineLighting( true )
		render.SetLightingOrigin( self.Entity:GetPos() )
		render.ResetModelLighting( self.colAmbientLight.r/255, self.colAmbientLight.g/255, self.colAmbientLight.b/255 )
		render.SetColorModulation( self.colColor.r/255, self.colColor.g/255, self.colColor.b/255 )
		render.SetBlend( self.colColor.a / 255 )
		
		for i=0, 6 do
			local col = self.DirectionalLight[ i ]
			if ( col ) then
				render.SetModelLighting( i, col.r/255, col.g/255, col.b/255 )
			end
		end
		
		self.Entity:DrawModel()
		
		render.SuppressEngineLighting( false )
		cam.IgnoreZ( false )
	cam.End3D()
	
	if( string.len( self.CornerText ) > 0 ) then
		
		surface.SetFont( "VCandara20" );
		local _, th = surface.GetTextSize( self.CornerText );
		
		draw.DrawText( self.CornerText, "VCandara20", self:GetWide() - 5, self:GetTall() - 5 - th, Color( 200, 200, 200, 255 ), 2 );
		
	end
	
	self.LastPaint = RealTime()
	
end

PANEL.Anims = { };
PANEL.Anims["idle"] = { "idle_subtle", "idle_all" };
PANEL.Anims["walk"] = { "walk_all", "WalkUnarmed_all", "walk_all_moderate" };

function PANEL:StartAnimation( set )
	
	if( !self.Anims[set] ) then return end
	
	local seq = -1;
	
	for _, v in pairs( self.Anims[set] ) do
		
		if( seq <= 0 ) then
			
			seq = self.Entity:LookupSequence( v );
			
		end
		
		if( seq > 0 ) then
			
			self.bAnimated = true;
			self.Entity:ResetSequence( seq );
			break;
			
		end
		
	end
	
end

function PANEL:RunAnimation()
	self.Entity:FrameAdvance( ( RealTime() - self.LastPaint ) * self.m_fAnimSpeed );
end

function PANEL:StartScene( name )
	
	if ( IsValid( self.Scene ) ) then
		self.Scene:Remove()
	end
	
	self.Scene = ClientsideScene( name, self.Entity )
	
end

function PANEL:OnMousePressed( code )
	
	if( self:IsDraggable() ) then
		
		self:MouseCapture( true )
		self:DragMousePress( code );
		
	end
	
end

function PANEL:OnMouseReleased( code )
	
	self:MouseCapture( false )
	
	if( self:DragMouseRelease( code ) ) then
		return;
	end
	
	if( self.Button ) then
		
		self:Button();
		
	end
	
end

function PANEL:LayoutEntity( Entity )
	
	if( self.bAnimated ) then
		self:RunAnimation();
	end
	
end

function PANEL:SetItem( id )
	
	self.ItemID = id;
	self:SetTooltip( V.I.GetItemByID( id ).Name );
	
end

function PANEL:GetItem()
	
	return self.ItemID;
	
end

vgui.Register( "VInventoryItem", PANEL, "DModelPanel" );