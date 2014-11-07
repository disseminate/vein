local PANEL = { };

AccessorFunc( PANEL, "m_fAnimSpeed", 	"AnimSpeed" )
AccessorFunc( PANEL, "Entity", 			"Entity" )
AccessorFunc( PANEL, "vCamPos", 		"CamPos" )
AccessorFunc( PANEL, "fFOV", 			"FOV" )
AccessorFunc( PANEL, "vLookatPos", 		"LookAt" )
AccessorFunc( PANEL, "colAmbientLight", "AmbientLight" )
AccessorFunc( PANEL, "colColor", 		"Color" )
AccessorFunc( PANEL, "bAnimated", 		"Animated" )

PANEL.PortView = nil;

function PANEL:CalcPortraitDims()
	
	if( self.Entity:LookupAttachment( "eyes" ) > 0 ) then
		
		local at = self.Entity:GetAttachment( self.Entity:LookupAttachment( "eyes" ) );
		
		local ViewAngle = at.Ang + Angle( 0, 180, 0 );
		local ViewPos = at.Pos + ViewAngle:Forward() * -60 + ViewAngle:Up() * -1.5;
		local view = { };
		
		view.fov = 10;
		view.origin = ViewPos;
		view.angles = ViewAngle;
		
		self.PortView = view;
		
	end
	
end

function PANEL:GetHeadYaw()
	
	local x = gui.MouseX();
	local knot = ScrW() / 2;
	
	local diff = ( x - knot ) / knot;
	
	return diff * 45;
	
end

function PANEL:GetHeadPitch()
	
	local y = gui.MouseY();
	local knot = ScrH() / 2;
	
	local diff = ( y - knot ) / knot;
	
	return diff * 20;
	
end

function PANEL:Init()
	
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
	
	self:CalcPortraitDims();
	
	self:SetCamPos( Vector( 50, 50, 50 ) );
	self:SetLookAt( Vector( 0, 0, 40 ) );
	self:SetFOV( 70 );
	
	self.HasModel = false;

end

function PANEL:SetModel( strModelName )
	
	self.Entity:SetModel( strModelName );
	self.Entity:SetNoDraw( true );
	
	self:CalcPortraitDims();
	
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

function PANEL:Paint()
	
	if( !IsValid( self.Entity ) ) then return end
	if( !self.HasModel ) then return end
	
	local x, y = self:LocalToScreen( 0, 0 )
	
	self:LayoutEntity( self.Entity )
	
	local dat = self.PortView;
	
	cam.Start3D( dat.origin, dat.angles, dat.fov, x, y, self:GetSize() )
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
		
		if( self.Selected ) then
			halo.Add( { self.Entity }, Color( 255, 255, 255, 255 ), 3, 3, 3, true, true );
		end
		
		self.Entity:DrawModel()
		
		render.SuppressEngineLighting( false )
		cam.IgnoreZ( false )
	cam.End3D()
	
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

function PANEL:ClearScene()
	
	if ( IsValid( self.Scene ) ) then
		self.Scene:Remove()
	end
	
end

function PANEL:SetMaterial( str )
	
	self.Entity:SetMaterial( str );
	
end

function PANEL:LayoutEntity( Entity )
	
	if( self.bAnimated ) then
		self:RunAnimation();
	end
	
	if( !self.NoMovement ) then
		
		Entity:SetPoseParameter( "head_yaw", self:GetHeadYaw() );
		Entity:SetPoseParameter( "head_pitch", self:GetHeadPitch() );
		
	end
	
end

vgui.Register( "VStatusModel", PANEL, "DModelPanel" );