local meta = FindMetaTable( "Entity" );

V.ME = { };

V.ME.EditMenu = nil;

V.ME.Editable			= {
	"v_prop",
	"v_fire",
	"v_sparks",
	"prop_door_rotating",
	"v_light",
	"v_spotlight"
}

V.ME.NoRotation			= {
	"v_fire",
	"v_sparks",
	"prop_door_rotating",
	"v_light"
}

V.ME.Movable			= {
	"v_prop",
	"v_fire",
	"v_sparks",
	"v_light",
	"v_spotlight"
}

V.ME.Removable			= {
	"v_prop",
	"v_fire",
	"v_sparks",
	"v_light",
	"v_spotlight"
}

V.ME.NotSolid			= {
	"v_fire",
	"v_sparks",
	"v_light",
	"v_spotlight"
}

V.ME.Props = { };
V.ME.CHILD = { };
V.ME.BedData = { };
V.ME.ChairData = { };

V.ME.CurProp = "";

function V.ME.AddPropCategory( cat )
	
	V.ME.Props[cat] = { };
	V.ME.CurProp = cat;
	
end

function V.ME.AddProp( mdl, child )
	
	table.insert( V.ME.Props[V.ME.CurProp], mdl );
	V.ME.CHILD[mdl] = child;
	
end

function V.ME.AddPropChild( mdl, child )
	
	V.ME.CHILD[mdl] = child;
	
end

function V.ME.AddBedData( model, pos, ang )
	
	V.ME.BedData[model] = { pos, ang };
	
end

function V.ME.AddChairData( model, pos, ang )
	
	V.ME.ChairData[model] = { pos, ang };
	
end

function meta:IsEditable()
	
	if( self and self:IsValid() and self.IsMapBased and self:IsMapBased() ) then return false end
	if( self and self:IsValid() and table.HasValue( V.ME.Editable, self:GetClass() ) ) then return true end
	return false;
	
end

function meta:IsRotatable()
	
	if( self and self:IsValid() and self.IsMapBased and self:IsMapBased() ) then return false end
	if( self and self:IsValid() and !table.HasValue( V.ME.NoRotation, self:GetClass() ) ) then return true end
	return false;
	
end

function meta:IsMovable()
	
	if( self and self:IsValid() and self.IsMapBased and self:IsMapBased() ) then return false end
	if( self and self:IsValid() and table.HasValue( V.ME.Movable, self:GetClass() ) ) then return true end
	return false;
	
end

function meta:IsRemovable()
	
	if( self and self:IsValid() and self.IsMapBased and self:IsMapBased() ) then return false end
	if( self and self:IsValid() and table.HasValue( V.ME.Removable, self:GetClass() ) ) then return true end
	return false;
	
end

function meta:IsNotSolid()
	
	if( self and self:IsValid() and table.HasValue( V.ME.NotSolid, self:GetClass() ) ) then return true end
	return false;
	
end

function meta:IsProp()
	
	if( self and self:IsValid() and self:GetClass() == "v_prop" ) then return true end
	return false
	
end

function meta:IsDoor()
	
	if( self and self:IsValid() and self:GetClass() == "prop_door_rotating" ) then return true end
	return false
	
end

function game.GetDoors()
	
	local tab = { };
	
	for _, v in pairs( ents.GetAll() ) do
		
		if( v:IsDoor() ) then
			
			table.insert( tab, v );
			
		end
		
	end
	
	return tab;
	
end

function meta:DoorState()
	
	if( !self:IsDoor() ) then return -1 end
	if( !SERVER ) then return -1 end
	
	return self:GetSaveTable().m_eDoorState;
	
end

function meta:DoorDistance()
	
	if( !self:IsDoor() ) then return -1 end
	if( !SERVER ) then return -1 end
	
	return self:GetSaveTable().distance;
	
end

function meta:IsFire()
	
	if( self and self:IsValid() and self:GetClass() == "v_fire" ) then return true end
	return false
	
end

function meta:IsSparks()
	
	if( self and self:IsValid() and self:GetClass() == "v_sparks" ) then return true end
	return false
	
end

function meta:IsLight()
	
	if( self and self:IsValid() and self:GetClass() == "v_light" ) then return true end
	return false
	
end

function meta:IsSpotLight()
	
	if( self and self:IsValid() and self:GetClass() == "v_spotlight" ) then return true end
	return false
	
end

function V.ME.GetTrace()
	
	if( CLIENT ) then
		
		local trace = { };
		trace.start = LocalPlayer():GetShootPos();
		trace.endpos = trace.start + gui.ScreenToVector( gui.MousePos() ) * 32768;
		trace.filter = { LocalPlayer() };
		
		for _, v in pairs( ents.GetAll() ) do
			
			if( !v:IsEditable() ) then
				
				table.insert( trace.filter, v );
				
			end
			
		end
		
		local tr = util.TraceLine( trace );
		return tr;
		
	end
	
	return { };
	
end

if( CLIENT ) then
	
	V.ME.SpawnMenuDown = false;
	
	function GM:OnSpawnMenuOpen()
		
		if( !LocalPlayer():IsAdmin() ) then return end
		
		V.ME.SpawnMenuOpen = true;
		
		V.ME.WorldOverlay = vgui.Create( "VWorldOverlay" );
		V.ME.WorldOverlay:SetSize( ScrW(), ScrH() );
		V.ME.WorldOverlay:SetPos( 0, 0 );
		V.ME.WorldOverlay:SetMouseInputEnabled( true );
		
		V.ME.EditorSelect = vgui.Create( "DFrame", V.ME.WorldOverlay );
		V.ME.EditorSelect:SetSize( ScrW(), 100 );
		V.ME.EditorSelect:SetPos( 0, ScrH() - 100 );
		V.ME.EditorSelect:SetTitle( "Spawn Menu" );
		V.ME.EditorSelect:SetDraggable( false );
		V.ME.EditorSelect:ShowCloseButton( false );
		
		V.ME.CreateProp = vgui.Create( "DButton", V.ME.EditorSelect );
		V.ME.CreateProp:SetPos( 10, 40 );
		V.ME.CreateProp:SetSize( 110, 50 );
		V.ME.CreateProp:SetText( "Prop" );
		V.ME.CreateProp:SetFont( "VCandara20" );
		V.ME.CreateProp.DoClick = function( self )
			
			net.Start( "nMEProp" );
			net.SendToServer();
			
		end
		
		V.ME.CreateFire = vgui.Create( "DButton", V.ME.EditorSelect );
		V.ME.CreateFire:SetPos( 130, 40 );
		V.ME.CreateFire:SetSize( 110, 50 );
		V.ME.CreateFire:SetText( "Fire" );
		V.ME.CreateFire:SetFont( "VCandara20" );
		V.ME.CreateFire.DoClick = function( self )
			
			net.Start( "nMEFire" );
			net.SendToServer();
			
		end
		
		V.ME.CreateSparks = vgui.Create( "DButton", V.ME.EditorSelect );
		V.ME.CreateSparks:SetPos( 250, 40 );
		V.ME.CreateSparks:SetSize( 110, 50 );
		V.ME.CreateSparks:SetText( "Sparks" );
		V.ME.CreateSparks:SetFont( "VCandara20" );
		V.ME.CreateSparks.DoClick = function( self )
			
			net.Start( "nMESparks" );
			net.SendToServer();
			
		end
		
		V.ME.CreateLight = vgui.Create( "DButton", V.ME.EditorSelect );
		V.ME.CreateLight:SetPos( 370, 40 );
		V.ME.CreateLight:SetSize( 110, 50 );
		V.ME.CreateLight:SetText( "Light" );
		V.ME.CreateLight:SetFont( "VCandara20" );
		V.ME.CreateLight.DoClick = function( self )
			
			net.Start( "nMELight" );
			net.SendToServer();
			
		end
		
		V.ME.CreateSpotLight = vgui.Create( "DButton", V.ME.EditorSelect );
		V.ME.CreateSpotLight:SetPos( 490, 40 );
		V.ME.CreateSpotLight:SetSize( 110, 50 );
		V.ME.CreateSpotLight:SetText( "Spotlight" );
		V.ME.CreateSpotLight:SetFont( "VCandara20" );
		V.ME.CreateSpotLight.DoClick = function( self )
			
			net.Start( "nMESpotLight" );
			net.SendToServer();
			
		end
		
		gui.EnableScreenClicker( true );
		
	end
	
	V.CursorOnWorldOverlay = false;
	
	function V.ME.SpawnMenuClick( mouse, pressed )
		
		if( !LocalPlayer():IsAdmin() ) then return end
		
		if( !V.ME.SpawnMenuOpen ) then return end
		
		local tr = V.ME.GetTrace();
		
		if( pressed and V.CursorOnWorldOverlay ) then
			
			if( mouse == MOUSE_LEFT ) then
				
				if( tr.Entity and tr.Entity:IsValid() and tr.Entity:IsEditable() and tr.Entity != V.ME.Selected and !IsValid( LocalPlayer():GetHoveredWidget() ) and !IsValid( LocalPlayer():GetPressedWidget() ) ) then
					
					if( V.ME.Selected and V.ME.Selected:IsMovable() ) then
						
						net.Start( "nMEAxisKill" );
							net.WriteEntity( V.ME.Selected );
						net.SendToServer();
						
					end
					
					V.ME.Selected = tr.Entity;
					
					V.ME.RotateMode = false;
					
					net.Start( "nMESelectEnt" );
						net.WriteEntity( V.ME.Selected );
					net.SendToServer();
					
				end
				
			elseif( mouse == MOUSE_RIGHT ) then
				
				if( V.ME.Selected and V.ME.Selected:IsValid() and V.ME.Selected:IsRotatable() ) then
					
					if( V.ME.RotateMode ) then
						
						V.ME.RotateMode = false;
						
						net.Start( "nMESelectEnt" );
						net.WriteEntity( V.ME.Selected );
						net.SendToServer();
						
					else
						
						V.ME.RotateMode = true;
						
						net.Start( "nMERotate" );
							net.WriteEntity( V.ME.Selected );
						net.SendToServer();
						
					end
					
				end
				
			end
			
		end
		
	end
	
	function V.ME.InvalidatePropPanel( models )
		
		if( V.ME.ChangeModelDialogPane ) then
			
			V.ME.ChangeModelDialogPane:Remove();
			
		end
		
		V.ME.ChangeModelDialogPane = vgui.Create( "DScrollPanel", V.ME.ChangeModelDialog );
		V.ME.ChangeModelDialogPane:Dock( FILL );
		V.ME.ChangeModelDialogPane:DockMargin( 216, 30, 0, 0 );
		
		local x = 0;
		local y = 0;
		
		for k, v in pairs( models ) do
		
			local mdl = vgui.Create( "VInventoryItem" );
			V.ME.ChangeModelDialogPane:AddItem( mdl );
			mdl:SetModel( v );
			mdl:SetPos( x, y );
			
			x = x + 64;
			
			if( x + 64 > V.ME.ChangeModelDialog:GetWide() - 216 ) then
				
				x = 0;
				y = y + 64;
				
			end
			
			local function f( self )
				
				net.Start( "nMESetModel" );
					net.WriteEntity( V.ME.Selected );
					net.WriteString( self.Entity:GetModel() );
				net.SendToServer();
				
				V.ME.Selected:SetModel( self.Entity:GetModel() ); -- for skin gui prediction
				
				if( V.ME.Skin ) then
					
					V.ME.Skin:SetMax( V.ME.Selected:SkinCount() - 1 );
					V.ME.Skin:SetValue( math.min( V.ME.Selected:GetSkin(), V.ME.Selected:SkinCount() - 1 ) );
					
				end
				
				V.ME.ChangeModelDialog:Remove();
				
			end
			mdl:SetButton( f );
			
		end
		
	end
	
	function V.ME.OpenEdit()
		
		if( !LocalPlayer():IsAdmin() ) then return end
		
		if( V.ME.EditMenu and V.ME.EditMenu:IsValid() ) then
			
			V.ME.EditMenu:Remove();
			
		end
		
		V.ME.EditMenu = nil;
		
		if( V.ME.Selected ) then
			
			V.ME.EditMenu = vgui.Create( "DFrame", V.ME.WorldOverlay );
			V.ME.EditMenu:SetSize( 200, ScrH() - 120 );
			V.ME.EditMenu:SetPos( ScrW() - 200, 10 );
			V.ME.EditMenu:SetTitle( "Prop" );
			V.ME.EditMenu:SetDraggable( false );
			V.ME.EditMenu:ShowCloseButton( false );
			
			local tab = net.ReadTable();
			
			for k, v in pairs( tab ) do
				
				V.ME.Selected[k] = v;
				
			end
			
			if( V.ME.Selected:IsRemovable() ) then
				
				V.ME.RemoveProp = vgui.Create( "DButton", V.ME.EditMenu );
				V.ME.RemoveProp:SetPos( 10, ScrH() - 170 );
				V.ME.RemoveProp:SetSize( 180, 40 );
				V.ME.RemoveProp:SetText( "Remove" );
				V.ME.RemoveProp:SetFont( "VCandara20" );
				V.ME.RemoveProp.DoClick = function( self )
					
					net.Start( "nMERemove" );
						net.WriteEntity( V.ME.Selected );
					net.SendToServer();
					
					if( V.ME.EditMenu and V.ME.EditMenu:IsValid() ) then
						
						V.ME.EditMenu:Remove();
						
					end
					
					V.ME.EditMenu = nil;
					
					net.Start( "nMEAxisKill" );
						net.WriteEntity( V.ME.Selected );
					net.SendToServer();
					
					V.ME.Selected = nil;
					
				end
				
			end
			
			if( V.ME.Selected:IsRotatable() ) then
				
				V.ME.AlignProp = vgui.Create( "DButton", V.ME.EditMenu );
				V.ME.AlignProp:SetPos( 10, ScrH() - 220 );
				V.ME.AlignProp:SetSize( 180, 40 );
				V.ME.AlignProp:SetText( "Align To Ground" );
				V.ME.AlignProp:SetFont( "VCandara20" );
				V.ME.AlignProp.DoClick = function( self )
					
					net.Start( "nMEAlign" );
						net.WriteEntity( V.ME.Selected );
					net.SendToServer();
					
				end
				
			end
			
			if( V.ME.Selected:IsMovable() ) then
				
				V.ME.DropProp = vgui.Create( "DButton", V.ME.EditMenu );
				V.ME.DropProp:SetPos( 10, ScrH() - 270 );
				V.ME.DropProp:SetSize( 180, 40 );
				V.ME.DropProp:SetText( "Drop To Ground" );
				V.ME.DropProp:SetFont( "VCandara20" );
				V.ME.DropProp.DoClick = function( self )
					
					net.Start( "nMEDrop" );
						net.WriteEntity( V.ME.Selected );
					net.SendToServer();
					
				end
				
			end
			
			if( V.ME.Selected:IsProp() ) then
				
				V.ME.ChangeModel = vgui.Create( "DButton", V.ME.EditMenu );
				V.ME.ChangeModel:SetPos( 10, 40 );
				V.ME.ChangeModel:SetSize( 180, 40 );
				V.ME.ChangeModel:SetText( "Change Model" );
				V.ME.ChangeModel:SetFont( "VCandara20" );
				V.ME.ChangeModel.DoClick = function( self )
					
					if( !V.ME.ChangeModelDialog or !V.ME.ChangeModelDialog:IsValid() ) then
						
						V.ME.ChangeModelDialog = vgui.Create( "DFrame" );
						V.ME.ChangeModelDialog:SetSize( ScrW() - 220, ScrH() - 120 );
						V.ME.ChangeModelDialog:SetPos( 10, 10 );
						V.ME.ChangeModelDialog:SetTitle( "Change Model" );
						V.ME.ChangeModelDialog:SetDraggable( false );
						
						V.ME.ChangeModelDialogMenu = vgui.Create( "DScrollPanel", V.ME.ChangeModelDialog );
						V.ME.ChangeModelDialogMenu:SetPos( 0, 30 );
						V.ME.ChangeModelDialogMenu:SetSize( 216, V.ME.ChangeModelDialog:GetTall() - 30 );
						
						local y = 0;
						local r = { };
						
						for k, v in pairs( V.ME.Props ) do
							
							local but = vgui.Create( "DButton" );
							but:SetSize( 200, 50 );
							but:SetText( k );
							but:SetFont( "VCandara20" );
							but.Data = v;
							V.ME.ChangeModelDialogMenu:AddItem( but );
							but:SetPos( 0, y );
							but.DoClick = function( self )
								
								for _, v in pairs( r ) do
									
									v.m_bSelected = false;
									
								end
								
								self.m_bSelected = true;
								
								V.ME.InvalidatePropPanel( self.Data );
								
							end
							
							table.insert( r, but );
							
							y = y + 50;
							
						end
						
					end
					
				end
				
				V.ME.BedCheck = vgui.Create( "DCheckBoxLabel", V.ME.EditMenu );
				V.ME.BedCheck:SetPos( 10, 90 );
				V.ME.BedCheck:SetText( "Can sleep on" );
				V.ME.BedCheck:SetValue( V.ME.Selected.Bed and 1 or 0 );
				V.ME.BedCheck:SizeToContents();
				V.ME.BedCheck.OnChange = function( self, val )
					
					net.Start( "nMESetBed" );
						net.WriteEntity( V.ME.Selected );
						net.WriteBit( val );
					net.SendToServer();
					
					V.ME.Selected.Bed = val;
					
				end
				
				V.ME.ChairCheck = vgui.Create( "DCheckBoxLabel", V.ME.EditMenu );
				V.ME.ChairCheck:SetPos( 10, 120 );
				V.ME.ChairCheck:SetText( "Can sit on" );
				V.ME.ChairCheck:SetValue( V.ME.Selected.Chair and 1 or 0 );
				V.ME.ChairCheck:SizeToContents();
				V.ME.ChairCheck.OnChange = function( self, val )
					
					net.Start( "nMESetChair" );
						net.WriteEntity( V.ME.Selected );
						net.WriteBit( val );
					net.SendToServer();
					
					V.ME.Selected.Chair = val;
					
				end
				
				V.ME.ContainerType = vgui.Create( "DComboBox", V.ME.EditMenu );
				V.ME.ContainerType:SetPos( 10, 150 );
				V.ME.ContainerType:SetSize( 180, 20 );
				V.ME.ContainerType:SetTextColor( Color( 255, 255, 255, 255 ) );
				V.ME.ContainerType:SetFont( "VCandara15" );
				
				for k, v in pairs( V.I.ContainerPresets ) do
					
					local s = false;
					
					if( V.ME.Selected.Container == k ) then
						s = true;
					end
					
					V.ME.ContainerType:AddChoice( v[1], nil, s );
					
				end
				
				V.ME.ContainerType.OpenMenu = function( self, pControlOpener ) -- super duper
					
					if ( pControlOpener ) then
						if ( pControlOpener == self.TextEntry ) then
							return
						end
					end
					
					if ( #self.Choices == 0 ) then return end
					
					if ( IsValid( self.Menu ) ) then
						self.Menu:Remove()
						self.Menu = nil
					end
					
					self.Menu = DermaMenu()
					
						for k, v in pairs( self.Choices ) do
							local d = self.Menu:AddOption( v, function() self:ChooseOption( v, k ) end )
							d:SetTextColor( Color( 255, 255, 255, 255 ) );
							d:SetFont( "VCandara15" );
						end
						
						local x, y = self:LocalToScreen( 0, self:GetTall() )
						
						self.Menu:SetMinimumWidth( self:GetWide() )
						self.Menu:Open( x, y, false, self )
						
				end
				
				V.ME.ContainerType.OnSelect = function( self, i, val, data )
					
					net.Start( "nMESetContainerType" );
						net.WriteEntity( V.ME.Selected );
						net.WriteFloat( i - 1 );
					net.SendToServer();
					
					V.ME.Selected.Container = i - 1;
					
				end
				
				V.ME.ContainerReset = vgui.Create( "DButton", V.ME.EditMenu );
				V.ME.ContainerReset:SetPos( 10, 180 );
				V.ME.ContainerReset:SetSize( 180, 20 );
				V.ME.ContainerReset:SetText( "Reset Contents" );
				V.ME.ContainerReset:SetFont( "VCandara20" );
				V.ME.ContainerReset.DoClick = function( self )
					
					net.Start( "nMEResetContainer" );
						net.WriteEntity( V.ME.Selected );
					net.SendToServer();
					
				end
				
				V.ME.ColorMixer = vgui.Create( "DColorMixer", V.ME.EditMenu );
				V.ME.ColorMixer:SetPos( 10, 210 );
				V.ME.ColorMixer:SetSize( 180, 200 );
				V.ME.ColorMixer:SetColor( V.ME.Selected:GetColor() );
				
				V.ME.ColorMixer.ValueChanged = function( self, color )
					
					net.Start( "nMESetColor" );
						net.WriteEntity( V.ME.Selected );
						net.WriteTable( color );
					net.SendToServer();
					
				end
				
				V.ME.SkinText = vgui.Create( "DLabel", V.ME.EditMenu );
				V.ME.SkinText:SetPos( 10, 420 );
				V.ME.SkinText:SetFont( "VCandara15" );
				V.ME.SkinText:SetText( "Skin" );
				V.ME.SkinText:SizeToContents();
				
				V.ME.Skin = vgui.Create( "VNumSlider", V.ME.EditMenu );
				V.ME.Skin:SetPos( 10, 440 );
				V.ME.Skin:SetWide( 180 );
				V.ME.Skin:SetMin( 0 );
				V.ME.Skin:SetMax( V.ME.Selected:SkinCount() - 1 );
				V.ME.Skin:SetDecimals( 0 );
				V.ME.Skin:SizeToContents();
				
				V.ME.Skin:SetValue( math.min( V.ME.Selected:GetSkin(), V.ME.Selected:SkinCount() - 1 ) );
				
				V.ME.Skin.ValueChanged = function( self, val )
					
					net.Start( "nMESetSkin" );
						net.WriteEntity( V.ME.Selected );
						net.WriteFloat( val );
					net.SendToServer();
					
				end
				
			end
			
			if( V.ME.Selected:IsFire() ) then
			
				V.ME.EditMenu:SetTitle( "Fire" );
				
				V.ME.FireSmall = vgui.Create( "DButton", V.ME.EditMenu );
				V.ME.FireSmall:SetPos( 10, 40 );
				V.ME.FireSmall:SetSize( 180, 40 );
				V.ME.FireSmall:SetText( "Small" );
				V.ME.FireSmall:SetFont( "VCandara20" );
				V.ME.FireSmall.DoClick = function( self )
					
					net.Start( "nMEFireSize" );
					net.WriteEntity( V.ME.Selected );
					net.WriteFloat( 32 );
					net.SendToServer();
					
				end
				
				V.ME.FireMed = vgui.Create( "DButton", V.ME.EditMenu );
				V.ME.FireMed:SetPos( 10, 90 );
				V.ME.FireMed:SetSize( 180, 40 );
				V.ME.FireMed:SetText( "Medium" );
				V.ME.FireMed:SetFont( "VCandara20" );
				V.ME.FireMed.DoClick = function( self )
					
					net.Start( "nMEFireSize" );
					net.WriteEntity( V.ME.Selected );
					net.WriteFloat( 64 );
					net.SendToServer();
					
				end
				
				V.ME.FireLarge = vgui.Create( "DButton", V.ME.EditMenu );
				V.ME.FireLarge:SetPos( 10, 140 );
				V.ME.FireLarge:SetSize( 180, 40 );
				V.ME.FireLarge:SetText( "Large" );
				V.ME.FireLarge:SetFont( "VCandara20" );
				V.ME.FireLarge.DoClick = function( self )
					
					net.Start( "nMEFireSize" );
					net.WriteEntity( V.ME.Selected );
					net.WriteFloat( 128 );
					net.SendToServer();
					
				end
				
			end
			
			if( V.ME.Selected:IsDoor() ) then
				
				V.ME.EditMenu:SetTitle( "Door" );
				
				V.ME.LockDoor = vgui.Create( "DButton", V.ME.EditMenu );
				V.ME.LockDoor:SetPos( 10, 40 );
				V.ME.LockDoor:SetSize( 180, 40 );
				V.ME.LockDoor:SetText( "Lock" );
				V.ME.LockDoor:SetFont( "VCandara20" );
				V.ME.LockDoor.DoClick = function( self )
					
					net.Start( "nMEDoor" );
						net.WriteEntity( V.ME.Selected );
						net.WriteData( 1, 1 );
					net.SendToServer();
					
				end
				
				V.ME.UnlockDoor = vgui.Create( "DButton", V.ME.EditMenu );
				V.ME.UnlockDoor:SetPos( 10, 90 );
				V.ME.UnlockDoor:SetSize( 180, 40 );
				V.ME.UnlockDoor:SetText( "Unlock" );
				V.ME.UnlockDoor:SetFont( "VCandara20" );
				V.ME.UnlockDoor.DoClick = function( self )
					
					net.Start( "nMEDoor" );
						net.WriteEntity( V.ME.Selected );
						net.WriteData( 0, 1 );
					net.SendToServer();
					
				end
				
				V.ME.DamageDoor = vgui.Create( "DButton", V.ME.EditMenu );
				V.ME.DamageDoor:SetPos( 10, 140 );
				V.ME.DamageDoor:SetSize( 180, 40 );
				V.ME.DamageDoor:SetText( "Damage" );
				V.ME.DamageDoor:SetFont( "VCandara20" );
				V.ME.DamageDoor.DoClick = function( self )
					
					net.Start( "nMEDamageDoor" );
						net.WriteEntity( V.ME.Selected );
					net.SendToServer();
					
				end
				
			end
			
			if( V.ME.Selected:IsSparks() ) then
				
				V.ME.EditMenu:SetTitle( "Sparks" );
				
				V.ME.SparkMagnitudeText = vgui.Create( "DLabel", V.ME.EditMenu );
				V.ME.SparkMagnitudeText:SetPos( 10, 40 );
				V.ME.SparkMagnitudeText:SetFont( "VCandara15" );
				V.ME.SparkMagnitudeText:SetText( "Magnitude" );
				V.ME.SparkMagnitudeText:SizeToContents();
				
				V.ME.SparkMagnitude = vgui.Create( "DComboBox", V.ME.EditMenu );
				V.ME.SparkMagnitude:SetPos( 10, 60 );
				V.ME.SparkMagnitude:SetSize( 180, 20 );
				
				V.ME.SparkMagnitude:AddChoice( "Small", "1", ( V.ME.Selected.Magnitude == "1" ) );
				V.ME.SparkMagnitude:AddChoice( "Medium", "2", ( V.ME.Selected.Magnitude == "2" ) );
				V.ME.SparkMagnitude:AddChoice( "Large", "5", ( V.ME.Selected.Magnitude == "5" ) );
				V.ME.SparkMagnitude:AddChoice( "Huge", "8", ( V.ME.Selected.Magnitude == "8" ) );
				
				V.ME.SparkMagnitude.OnSelect = function( self, i, val, data )
					
					net.Start( "nMESparksMagnitude" );
						net.WriteEntity( V.ME.Selected );
						net.WriteString( data );
					net.SendToServer();
					
					V.ME.Selected.Magnitude = data;
					
				end
				
				V.ME.SparkTrailLengthText = vgui.Create( "DLabel", V.ME.EditMenu );
				V.ME.SparkTrailLengthText:SetPos( 10, 90 );
				V.ME.SparkTrailLengthText:SetFont( "VCandara15" );
				V.ME.SparkTrailLengthText:SetText( "Trail Length" );
				V.ME.SparkTrailLengthText:SizeToContents();
				
				V.ME.SparkTrailLength = vgui.Create( "DComboBox", V.ME.EditMenu );
				V.ME.SparkTrailLength:SetPos( 10, 110 );
				V.ME.SparkTrailLength:SetSize( 180, 20 );
				
				V.ME.SparkTrailLength:AddChoice( "Small", "1", ( V.ME.Selected.TrailLength == "1" ) );
				V.ME.SparkTrailLength:AddChoice( "Medium", "2", ( V.ME.Selected.TrailLength == "2" ) );
				V.ME.SparkTrailLength:AddChoice( "Large", "3", ( V.ME.Selected.TrailLength == "3" ) );
				
				V.ME.SparkTrailLength.OnSelect = function( self, i, val, data )
					
					net.Start( "nMESparksTrailLength" );
						net.WriteEntity( V.ME.Selected );
						net.WriteString( data );
					net.SendToServer();
					
					V.ME.Selected.TrailLength = data;
					
				end
				
				V.ME.SparkMaxDelayText = vgui.Create( "DLabel", V.ME.EditMenu );
				V.ME.SparkMaxDelayText:SetPos( 10, 140 );
				V.ME.SparkMaxDelayText:SetFont( "VCandara15" );
				V.ME.SparkMaxDelayText:SetText( "Max Spark Delay" );
				V.ME.SparkMaxDelayText:SizeToContents();
				
				V.ME.SparkMaxDelay = vgui.Create( "VNumSlider", V.ME.EditMenu );
				V.ME.SparkMaxDelay:SetPos( 10, 160 );
				V.ME.SparkMaxDelay:SetWide( 180 );
				V.ME.SparkMaxDelay:SetMin( 0 );
				V.ME.SparkMaxDelay:SetMax( 30 );
				V.ME.SparkMaxDelay:SizeToContents();
				
				V.ME.SparkMaxDelay:SetValue( V.ME.Selected.MaxDelay );
				
				V.ME.SparkMaxDelay.ValueChanged = function( self, val )
					
					net.Start( "nMESparksMaxDelay" );
						net.WriteEntity( V.ME.Selected );
						net.WriteFloat( val );
					net.SendToServer();
					
					V.ME.Selected.MaxDelay = val;
					
				end
				
			end
			
			if( V.ME.Selected:IsLight() ) then
				
				V.ME.EditMenu:SetTitle( "Light" );
				
				local c = V.ME.Selected:GetDTVector( 0 )
				
				V.ME.ColorMixer = vgui.Create( "DColorMixer", V.ME.EditMenu );
				V.ME.ColorMixer:SetPos( 10, 40 );
				V.ME.ColorMixer:SetSize( 180, 180 );
				V.ME.ColorMixer:SetColor( Color( c.x, c.y, c.z, 255 ) );
				
				V.ME.ColorMixer.ValueChanged = function( self, color )
					
					net.Start( "nMELightColor" );
						net.WriteEntity( V.ME.Selected );
						net.WriteTable( color );
					net.SendToServer();
					
				end
				
				V.ME.LightBrightnessText = vgui.Create( "DLabel", V.ME.EditMenu );
				V.ME.LightBrightnessText:SetPos( 10, 230 );
				V.ME.LightBrightnessText:SetFont( "VCandara15" );
				V.ME.LightBrightnessText:SetText( "Brightness" );
				V.ME.LightBrightnessText:SizeToContents();
				
				V.ME.LightBrightness = vgui.Create( "VNumSlider", V.ME.EditMenu );
				V.ME.LightBrightness:SetPos( 10, 250 );
				V.ME.LightBrightness:SetWide( 180 );
				V.ME.LightBrightness:SetMin( 0 );
				V.ME.LightBrightness:SetMax( 3 );
				V.ME.LightBrightness:SetDecimals( 0 );
				V.ME.LightBrightness:SizeToContents();
				
				V.ME.LightBrightness:SetValue( V.ME.Selected:GetDTFloat( 0 ) );
				
				V.ME.LightBrightness.ValueChanged = function( self, val )
					
					net.Start( "nMELightBrightness" );
						net.WriteEntity( V.ME.Selected );
						net.WriteFloat( val );
					net.SendToServer();
					
				end
				
				V.ME.LightSizeText = vgui.Create( "DLabel", V.ME.EditMenu );
				V.ME.LightSizeText:SetPos( 10, 280 );
				V.ME.LightSizeText:SetFont( "VCandara15" );
				V.ME.LightSizeText:SetText( "Size" );
				V.ME.LightSizeText:SizeToContents();
				
				V.ME.LightSize = vgui.Create( "VNumSlider", V.ME.EditMenu );
				V.ME.LightSize:SetPos( 10, 300 );
				V.ME.LightSize:SetWide( 180 );
				V.ME.LightSize:SetMin( 0 );
				V.ME.LightSize:SetMax( 1024 );
				V.ME.LightSize:SizeToContents();
				
				V.ME.LightSize:SetValue( V.ME.Selected:GetDTFloat( 1 ) );
				
				V.ME.LightSize.ValueChanged = function( self, val )
					
					net.Start( "nMELightSize" );
						net.WriteEntity( V.ME.Selected );
						net.WriteFloat( val );
					net.SendToServer();
					
				end
				
				V.ME.LightDecayText = vgui.Create( "DLabel", V.ME.EditMenu );
				V.ME.LightDecayText:SetPos( 10, 330 );
				V.ME.LightDecayText:SetFont( "VCandara15" );
				V.ME.LightDecayText:SetText( "Decay" );
				V.ME.LightDecayText:SizeToContents();
				
				V.ME.LightDecay = vgui.Create( "VNumSlider", V.ME.EditMenu );
				V.ME.LightDecay:SetPos( 10, 350 );
				V.ME.LightDecay:SetWide( 180 );
				V.ME.LightDecay:SetMin( 0 );
				V.ME.LightDecay:SetMax( 20 );
				V.ME.LightDecay:SizeToContents();
				
				V.ME.LightDecay:SetValue( V.ME.Selected:GetDTFloat( 2 ) );
				
				V.ME.LightDecay.ValueChanged = function( self, val )
					
					net.Start( "nMELightDecay" );
						net.WriteEntity( V.ME.Selected );
						net.WriteFloat( val );
					net.SendToServer();
					
				end
				
			end
			
			if( V.ME.Selected:IsSpotLight() ) then
				
				V.ME.EditMenu:SetTitle( "Spotlight" );
				
				local c = V.ME.Selected:GetDTVector( 0 )
				
				V.ME.ColorMixer = vgui.Create( "DColorMixer", V.ME.EditMenu );
				V.ME.ColorMixer:SetPos( 10, 40 );
				V.ME.ColorMixer:SetSize( 180, 180 );
				V.ME.ColorMixer:SetColor( Color( c.x, c.y, c.z, 255 ) );
				
				V.ME.ColorMixer.ValueChanged = function( self, color )
					
					net.Start( "nMESpotLightColor" );
						net.WriteEntity( V.ME.Selected );
						net.WriteTable( color );
					net.SendToServer();
					
				end
				
				V.ME.SpotLightWidthText = vgui.Create( "DLabel", V.ME.EditMenu );
				V.ME.SpotLightWidthText:SetPos( 10, 230 );
				V.ME.SpotLightWidthText:SetFont( "VCandara15" );
				V.ME.SpotLightWidthText:SetText( "Width" );
				V.ME.SpotLightWidthText:SizeToContents();
				
				V.ME.SpotLightWidth = vgui.Create( "VNumSlider", V.ME.EditMenu );
				V.ME.SpotLightWidth:SetPos( 10, 250 );
				V.ME.SpotLightWidth:SetWide( 180 );
				V.ME.SpotLightWidth:SetMin( 1 );
				V.ME.SpotLightWidth:SetMax( 80 );
				V.ME.SpotLightWidth:SetDecimals( 0 );
				V.ME.SpotLightWidth:SizeToContents();
				
				V.ME.SpotLightWidth:SetValue( V.ME.Selected:GetDTFloat( 0 ) );
				
				V.ME.SpotLightWidth.ValueChanged = function( self, val )
					
					net.Start( "nMESpotLightWidth" );
						net.WriteEntity( V.ME.Selected );
						net.WriteFloat( val );
					net.SendToServer();
					
				end
				
				V.ME.SpotLightLengthText = vgui.Create( "DLabel", V.ME.EditMenu );
				V.ME.SpotLightLengthText:SetPos( 10, 280 );
				V.ME.SpotLightLengthText:SetFont( "VCandara15" );
				V.ME.SpotLightLengthText:SetText( "Length" );
				V.ME.SpotLightLengthText:SizeToContents();
				
				V.ME.SpotLightLength = vgui.Create( "VNumSlider", V.ME.EditMenu );
				V.ME.SpotLightLength:SetPos( 10, 300 );
				V.ME.SpotLightLength:SetWide( 180 );
				V.ME.SpotLightLength:SetMin( 1 );
				V.ME.SpotLightLength:SetMax( 2000 );
				V.ME.SpotLightLength:SizeToContents();
				
				V.ME.SpotLightLength:SetValue( V.ME.Selected:GetDTFloat( 1 ) );
				
				V.ME.SpotLightLength.ValueChanged = function( self, val )
					
					net.Start( "nMESpotLightLength" );
						net.WriteEntity( V.ME.Selected );
						net.WriteFloat( val );
					net.SendToServer();
					
				end
				
			end
			
		end
		
	end
	net.Receive( "nMEOpenEdit", V.ME.OpenEdit );
	
	function GM:OnSpawnMenuClose()
		
		if( !LocalPlayer():IsAdmin() ) then return end
		
		V.ME.SpawnMenuOpen = false;
		
		if( V.ME.WorldOverlay and V.ME.WorldOverlay:IsValid() ) then
			
			V.ME.WorldOverlay:Remove();
			
		end
		
		if( V.ME.EditorSelect and V.ME.EditorSelect:IsValid() ) then
			
			V.ME.EditorSelect:Remove();
			
		end
		
		if( V.ME.EditMenu and V.ME.EditMenu:IsValid() ) then
			
			V.ME.EditMenu:Remove();
			
		end
		
		if( V.ME.ChangeModelDialog and V.ME.ChangeModelDialog:IsValid() ) then
			
			V.ME.ChangeModelDialog:Remove();
			
		end
		
		V.ME.WorldOverlay = nil;
		V.ME.EditorSelect = nil;
		V.ME.EditMenu = nil;
		V.ME.ChangeModelDialog = nil;
		
		if( V.ME.Selected and V.ME.Selected:IsValid() and V.ME.Selected:IsMovable() ) then
			
			net.Start( "nMEAxisKill" );
			net.WriteEntity( V.ME.Selected );
			net.SendToServer();
			
		end
		
		V.ME.Selected = nil;
		
		gui.EnableScreenClicker( false );
		
	end
	
	function V.ME.PreDrawHalos()
		
		if( V.ME.SpawnMenuOpen ) then
			
			halo.Add( ents.FindByClass( "v_fire" ), Color( 255, 0, 0, 255 ), 2, 2, 2, true, false );
			halo.Add( ents.FindByClass( "v_sparks" ), Color( 255, 255, 0, 255 ), 2, 2, 2, true, false );
			halo.Add( ents.FindByClass( "v_light" ), Color( 0, 255, 0, 255 ), 2, 2, 2, true, false );
			halo.Add( ents.FindByClass( "v_spotlight" ), Color( 128, 255, 128, 255 ), 2, 2, 2, true, false );
			
			local tr = V.ME.GetTrace();
			
			local pre = LocalPlayer():GetPressedWidget();
			local hov = LocalPlayer():GetHoveredWidget();
			
			if( V.CursorOnWorldOverlay and tr.Entity and tr.Entity:IsValid() and tr.Entity:IsEditable() and !IsValid( pre ) and !IsValid( hov ) ) then
				
				halo.Add( { tr.Entity }, Color( 255, 255, 255, 255 ), 2, 2, 2, true, false );
				
			end
			
			if( IsValid( pre ) ) then
				
				halo.Add( { pre:GetParent():GetParent() }, pre:GetColor(), 2, 2, 2, true, false );
				
			end
			
		end
		
	end
	
else
	
	function nMEProp( len, ply )
		
		if( !ply:IsAdmin() ) then return end
		
		local trace = { };
		trace.start = ply:EyePos();
		trace.endpos = trace.start + ply:GetAimVector() * 4096;
		trace.filter = ply;
		local tr = util.TraceLine( trace );
		
		local prop = ents.Create( "v_prop" );
		prop:SetPos( tr.HitPos );
		prop:SetAngles( Angle() );
		prop:SetModel( "models/props_debris/concrete_cynderblock001.mdl" );
		prop:Spawn();
		
		local child = V.ME.CHILD["models/props_debris/concrete_cynderblock001.mdl"];
		
		if( child ) then
			
			local c = ents.Create( "v_propchild" );
			c:SetPos( tr.HitPos );
			c:SetAngles( Angle() );
			c:SetModel( child );
			c:Spawn();
			c:SetParent( prop );
			prop.Child = c;
			
			prop:DeleteOnRemove( c );
			
		end
		
	end
	net.Receive( "nMEProp", nMEProp );
	
	function nMEDoor( len, ply )
		
		if( !ply:IsAdmin() ) then return end
		
		local ent = net.ReadEntity();
		local l = tonumber( net.ReadData( 1 ) );
		
		if( ent and ent:IsValid() and ent:IsDoor() ) then
			
			if( l == 0 ) then
				
				ent:Fire( "Unlock" );
				
			else
				
				ent:Fire( "Lock" );
				
			end
			
		end
		
	end
	net.Receive( "nMEDoor", nMEDoor );
	
	function nMEDamageDoor( len, ply )
		
		if( !ply:IsAdmin() ) then return end
		
		local ent = net.ReadEntity();
		
		if( ent and ent:IsValid() and ent:IsDoor() ) then
			
			V.ME.DamageDoor( ent );
			
		end
		
	end
	net.Receive( "nMEDamageDoor", nMEDamageDoor );
	
	function nMEFire( len, ply )
		
		if( !ply:IsAdmin() ) then return end
		
		local trace = { };
		trace.start = ply:EyePos();
		trace.endpos = trace.start + ply:GetAimVector() * 4096;
		trace.filter = ply;
		local tr = util.TraceLine( trace );
		
		local fire = ents.Create( "v_fire" );
		fire:SetPos( tr.HitPos );
		fire:Spawn();
		
	end
	net.Receive( "nMEFire", nMEFire );
	
	function nMEFireSize( len, ply )
		
		if( !ply:IsAdmin() ) then return end
		
		local ent = net.ReadEntity();
		local size = net.ReadFloat();
		
		if( !ent:IsFire() ) then return end
		
		if( ent and ent:IsValid() ) then
			
			ent:SetSize( size );
			
		end
		
	end
	net.Receive( "nMEFireSize", nMEFireSize );
	
	function nMESparks( len, ply )
		
		if( !ply:IsAdmin() ) then return end
		
		local trace = { };
		trace.start = ply:EyePos();
		trace.endpos = trace.start + ply:GetAimVector() * 4096;
		trace.filter = ply;
		local tr = util.TraceLine( trace );
		
		local sparks = ents.Create( "v_sparks" );
		sparks:SetPos( tr.HitPos );
		sparks:Spawn();
		
	end
	net.Receive( "nMESparks", nMESparks );
	
	function nMESparksMagnitude( len, ply )
		
		if( !ply:IsAdmin() ) then return end
		
		local ent = net.ReadEntity();
		local size = net.ReadString();
		
		if( !ent:IsSparks() ) then return end
		
		if( ent and ent:IsValid() ) then
			
			ent:SetMagnitude( size );
			
		end
		
	end
	net.Receive( "nMESparksMagnitude", nMESparksMagnitude );
	
	function nMESparksTrailLength( len, ply )
		
		if( !ply:IsAdmin() ) then return end
		
		local ent = net.ReadEntity();
		local size = net.ReadString();
		
		if( !ent:IsSparks() ) then return end
		
		if( ent and ent:IsValid() ) then
			
			ent:SetTrailLength( size );
			
		end
		
	end
	net.Receive( "nMESparksTrailLength", nMESparksTrailLength );
	
	function nMESparksMaxDelay( len, ply )
		
		if( !ply:IsAdmin() ) then return end
		
		local ent = net.ReadEntity();
		local delay = net.ReadFloat();
		
		if( !ent:IsSparks() ) then return end
		
		if( ent and ent:IsValid() ) then
			
			ent:SetMaxDelay( delay );
			
		end
		
	end
	net.Receive( "nMESparksMaxDelay", nMESparksMaxDelay );
	
	function nMELight( len, ply )
		
		if( !ply:IsAdmin() ) then return end
		
		local trace = { };
		trace.start = ply:EyePos();
		trace.endpos = trace.start + ply:GetAimVector() * 4096;
		trace.filter = ply;
		local tr = util.TraceLine( trace );
		
		local sparks = ents.Create( "v_light" );
		sparks:SetPos( tr.HitPos );
		sparks:Spawn();
		
	end
	net.Receive( "nMELight", nMELight );
	
	function nMELightColor( len, ply )
		
		if( !ply:IsAdmin() ) then return end
		
		local ent = net.ReadEntity();
		local color = net.ReadTable();
		
		if( !ent:IsLight() ) then return end
		
		if( ent and ent:IsValid() ) then
			
			ent:SetLightColor( color );
			
		end
		
	end
	net.Receive( "nMELightColor", nMELightColor );
	
	function nMELightBrightness( len, ply )
		
		if( !ply:IsAdmin() ) then return end
		
		local ent = net.ReadEntity();
		local b = net.ReadFloat();
		
		if( !ent:IsLight() ) then return end
		
		if( ent and ent:IsValid() ) then
			
			ent:SetBrightness( b );
			
		end
		
	end
	net.Receive( "nMELightBrightness", nMELightBrightness );
	
	function nMELightSize( len, ply )
		
		if( !ply:IsAdmin() ) then return end
		
		local ent = net.ReadEntity();
		local b = net.ReadFloat();
		
		if( !ent:IsLight() ) then return end
		
		if( ent and ent:IsValid() ) then
			
			ent:SetSize( b );
			
		end
		
	end
	net.Receive( "nMELightSize", nMELightSize );
	
	function nMELightDecay( len, ply )
		
		if( !ply:IsAdmin() ) then return end
		
		local ent = net.ReadEntity();
		local b = net.ReadFloat();
		
		if( !ent:IsLight() ) then return end
		
		if( ent and ent:IsValid() ) then
			
			ent:SetDecay( b );
			
		end
		
	end
	net.Receive( "nMELightDecay", nMELightDecay );
	
	function nMESpotLight( len, ply )
		
		if( !ply:IsAdmin() ) then return end
		
		local trace = { };
		trace.start = ply:EyePos();
		trace.endpos = trace.start + ply:GetAimVector() * 4096;
		trace.filter = ply;
		local tr = util.TraceLine( trace );
		
		local sl = ents.Create( "v_spotlight" );
		sl:SetPos( tr.HitPos );
		sl:Spawn();
		
	end
	net.Receive( "nMESpotLight", nMESpotLight );
	
	function nMESpotLightColor( len, ply )
		
		if( !ply:IsAdmin() ) then return end
		
		local ent = net.ReadEntity();
		local color = net.ReadTable();
		
		if( !ent:IsSpotLight() ) then return end
		
		if( ent and ent:IsValid() ) then
			
			ent:SetSpotColor( color );
			
		end
		
	end
	net.Receive( "nMESpotLightColor", nMESpotLightColor );
	
	function nMESpotLightWidth( len, ply )
		
		if( !ply:IsAdmin() ) then return end
		
		local ent = net.ReadEntity();
		local b = net.ReadFloat();
		
		if( !ent:IsSpotLight() ) then return end
		
		if( ent and ent:IsValid() ) then
			
			ent:SetWidth( b );
			
		end
		
	end
	net.Receive( "nMESpotLightWidth", nMESpotLightWidth );
	
	function nMESpotLightLength( len, ply )
		
		if( !ply:IsAdmin() ) then return end
		
		local ent = net.ReadEntity();
		local b = net.ReadFloat();
		
		if( !ent:IsSpotLight() ) then return end
		
		if( ent and ent:IsValid() ) then
			
			ent:SetLength( b );
			
		end
		
	end
	net.Receive( "nMESpotLightLength", nMESpotLightLength );
	
	function nMESelectEnt( len, ply )
		
		if( !ply:IsAdmin() ) then return end
		
		local ent = net.ReadEntity();
		
		if( ent:IsMovable() ) then
			
			if( ent.axis and ent.axis:IsValid() ) then
				
				ent.axis:Remove();
				
			end
			
			ent.axis = ents.Create( "widget_vein_move" );
			ent.axis:Setup( ent, nil, false, 100 );
			ent.axis:Spawn();
			ent.axis:SetNWFloat( "Priority", 0.5 );
			ent.axis:InvalidateSize();
			ent:DeleteOnRemove( ent.axis );
			
		end
		
		net.Start( "nMEOpenEdit" );
			if( ent:IsProp() ) then
				net.WriteTable( { Container = ent:GetContainer(), Bed = ent.Bed, Chair = ent.Chair } );
			elseif( ent:IsSparks() ) then
				net.WriteTable( { Magnitude = ent:GetMagnitude(), TrailLength = ent:GetTrailLength(), MaxDelay = ent:GetMaxDelay() } );
			else
				net.WriteTable( { } );
			end
		net.Send( ply );
		
	end
	net.Receive( "nMESelectEnt", nMESelectEnt );
	
	function nMERotate( len, ply )
		
		if( !ply:IsAdmin() ) then return end
		
		local ent = net.ReadEntity();
		
		if( !ent:IsRotatable() ) then return end
		
		if( ent.axis and ent.axis:IsValid() ) then
			
			ent.axis:Remove();
			
		end
		
		ent.axis = ents.Create( "widget_vein_move" );
		ent.axis:Setup( ent, nil, true, 100 );
		ent.axis:Spawn();
		ent.axis:SetNWFloat( "Priority", 0.5 );
		ent.axis:InvalidateSize();
		ent:DeleteOnRemove( ent.axis );
		
	end
	net.Receive( "nMERotate", nMERotate );
	
	function nMEAxisKill( len, ply )
		
		if( !ply:IsAdmin() ) then return end
		
		local ent = net.ReadEntity();
		
		if( !ent:IsMovable() ) then return end
		
		if( ent.axis and ent.axis:IsValid() ) then
			
			ent.axis:Remove();
			
		end
		
	end
	net.Receive( "nMEAxisKill", nMEAxisKill );
	
	function nMEAlign( len, ply )
		
		if( !ply:IsAdmin() ) then return end
		
		local ent = net.ReadEntity();
		
		if( !ent:IsRotatable() ) then return end
		
		local trace = { };
		trace.start = ent:GetPos();
		trace.endpos = trace.start - Vector( 0, 0, 4096 );
		trace.filter = ent;
		local tr = util.TraceLine( trace );
		
		local n = tr.HitNormal:Angle();
		
		ent:SetAngles( Angle( n.p + 90, n.y, n.r ) );
		
	end
	net.Receive( "nMEAlign", nMEAlign );
	
	function nMEDrop( len, ply )
		
		if( !ply:IsAdmin() ) then return end
		
		local ent = net.ReadEntity();
		
		if( !ent:IsMovable() ) then return end
		
		local trace = { };
		trace.start = ent:GetPos();
		trace.endpos = trace.start - Vector( 0, 0, 4096 );
		trace.filter = ent;
		local tr = util.TraceLine( trace );
		
		local n = tr.HitPos;
		
		ent:SetPos( n );
		
	end
	net.Receive( "nMEDrop", nMEDrop );
	
	function nMERemove( len, ply )
		
		if( !ply:IsAdmin() ) then return end
		
		local ent = net.ReadEntity();
		
		if( !ent:IsRemovable() ) then return end
		
		if( ent and ent:IsValid() ) then
			
			ent:Remove();
			
		end
		
	end
	net.Receive( "nMERemove", nMERemove );
	
	function nMESetModel( len, ply )
		
		if( !ply:IsAdmin() ) then return end
		
		local ent = net.ReadEntity();
		local mdl = net.ReadString();
		
		if( !ent:IsProp() ) then return end
		
		if( ent and ent:IsValid() ) then
			
			ent:SetModel( mdl );
			ent:PhysicsRefresh();
			
			if( V.ME.CHILD[mdl] ) then
				
				if( ent.Child and ent.Child:IsValid() ) then
					
					ent.Child:SetModel( V.ME.CHILD[mdl] );
					ent.Child:PhysicsRefresh();
					
				else
					
					local c = ents.Create( "v_propchild" );
					c:SetPos( ent:GetPos() );
					c:SetAngles( ent:GetAngles() );
					c:SetModel( V.ME.CHILD[mdl] );
					c:Spawn();
					c:SetParent( ent );
					ent.Child = c;
					
					ent:DeleteOnRemove( c );
					
				end
				
			else
				
				if( ent.Child and ent.Child:IsValid() ) then
					
					ent.Child:Remove();
					
				end
				
				ent.Child = nil;
				
			end
			
			if( ent.axis ) then
				
				ent.axis:InvalidateSize();
				
			end
			
		end
		
	end
	net.Receive( "nMESetModel", nMESetModel );
	
	function nMESetBed( len, ply )
		
		if( !ply:IsAdmin() ) then return end
		
		local ent = net.ReadEntity();
		local b = net.ReadBit();
		
		if( !ent:IsProp() ) then return end
		
		if( ent and ent:IsValid() ) then
			
			ent.Bed = ( b == 1 );
			
		end
		
	end
	net.Receive( "nMESetBed", nMESetBed );
	
	function nMESetChair( len, ply )
		
		if( !ply:IsAdmin() ) then return end
		
		local ent = net.ReadEntity();
		local b = net.ReadBit();
		
		if( !ent:IsProp() ) then return end
		
		if( ent and ent:IsValid() ) then
			
			ent.Chair = ( b == 1 );
			
		end
		
	end
	net.Receive( "nMESetChair", nMESetChair );
	
	function nMESetContainerType( len, ply )
		
		if( !ply:IsAdmin() ) then return end
		
		local ent = net.ReadEntity();
		local b = net.ReadFloat();
		
		if( !ent:IsProp() ) then return end
		
		if( ent and ent:IsValid() ) then
			
			ent:SetContainer( b );
			
		end
		
	end
	net.Receive( "nMESetContainerType", nMESetContainerType );
	
	function nMEResetContainer( len, ply )
		
		if( !ply:IsAdmin() ) then return end
		
		local ent = net.ReadEntity();
		
		if( !ent:IsProp() ) then return end
		
		if( ent and ent:IsValid() and ent:GetContainer() > 0 ) then
			
			ent.Inventory = { };
			ent.NextContainerUpdate = CurTime();
			
		end
		
	end
	net.Receive( "nMEResetContainer", nMEResetContainer );
	
	function nMESetColor( len, ply )
		
		if( !ply:IsAdmin() ) then return end
		
		local ent = net.ReadEntity();
		local col = net.ReadTable();
		
		if( !ent:IsProp() ) then return end
		
		if( ent and ent:IsValid() ) then
			
			ent:SetColor( col );
			
		end
		
	end
	net.Receive( "nMESetColor", nMESetColor );
	
	function nMESetSkin( len, ply )
		
		if( !ply:IsAdmin() ) then return end
		
		local ent = net.ReadEntity();
		local skin = net.ReadFloat();
		
		if( !ent:IsProp() ) then return end
		
		if( ent and ent:IsValid() ) then
			
			ent:SetSkin( skin );
			
		end
		
	end
	net.Receive( "nMESetSkin", nMESetSkin );
	
end

function GM:InitPostEntity()
	
	V.W.InitPostEntity();
	V.MD.InitPostEntity();
	V.I.InitPostEntity();
	V.ME.InitPostEntity();
	
end

function nMEDamageDoorClient( len )
	
	local ent = net.ReadEntity();
	ent.DoorHealth = net.ReadFloat();
	
end
net.Receive( "nMEDamageDoorClient", nMEDamageDoorClient );

function nMEDoorMaxClient( len )
	
	local ent = net.ReadEntity();
	ent.DoorMaxHealth = net.ReadFloat();
	
end
net.Receive( "nMEDoorMaxClient", nMEDoorMaxClient );

function V.ME.DamageDoor( ent, n )
	
	if( !n ) then n = 1; end
	
	if( SERVER ) then
		
		ent.DoorHealth = ent.DoorHealth - n;
		
		net.Start( "nMEDamageDoorClient" );
			net.WriteEntity( ent );
			net.WriteFloat( ent.DoorHealth );
		net.Broadcast();
		
	end
	
	if( ent.DoorHealth <= 0 ) then
		
		ent:EmitSound( "physics/wood/wood_crate_break" .. math.random( 1, 4 ) .. ".wav" );
		ent:Remove();
		
	end
	
end

function V.ME.ZombieDamageDoor( ent )
	
	if( !ent.NextZombieTime ) then ent.NextZombieTime = 0 end
	
	if( CurTime() >= ent.NextZombieTime ) then
		
		ent.NextZombieTime = CurTime() + ( V.Config.DoorBreakTime / 8 );
		V.ME.DamageDoor( ent, 1 );
		
	end
	
end

function V.ME.Think()
	
	if( SERVER and V.ME.NextSave and CurTime() >= V.ME.NextSave ) then
		
		V.ME.NextSave = CurTime() + 20;
		V.ME.SaveMap();
		
	end
	
	if( CLIENT ) then
		
		local b = nil;
		
		if( input.IsMouseDown( MOUSE_LEFT ) ) then
			b = MOUSE_LEFT;
		elseif( input.IsMouseDown( MOUSE_RIGHT ) ) then
			b = MOUSE_RIGHT;
		end
		
		if( !V.ME.SpawnMenuDown and b ) then
			
			V.ME.SpawnMenuDown = true;
			V.ME.SpawnMenuClick( b, true );
			
		elseif( V.ME.SpawnMenuDown and !b ) then
			
			V.ME.SpawnMenuDown = false;
			V.ME.SpawnMenuClick( b, false );
			
		end
		
	end
	
end

function V.ME.LoadMapElement( id, tab )
	
	if( #tab <= 1 ) then return end
	
	if( id == 1 ) then
		
		local x, y, z = tonumber( tab[2] ), tonumber( tab[3] ), tonumber( tab[4] );
		local p, ya, r = tonumber( tab[5] ), tonumber( tab[6] ), tonumber( tab[7] );
		local model = tab[8];
		local color = tab[9];
		local bed = tonumber( tab[10] );
		local chair = tonumber( tab[11] );
		local cont = tonumber( tab[12] );
		local skin = tonumber( tab[13] );
		
		if( SERVER ) then
			
			local e = ents.Create( "v_prop" );
			e:SetPos( Vector( x, y, z ) );
			e:SetAngles( Angle( p, ya, r ) );
			e:SetModel( model );
			e:SetSkin( skin );
			e:Spawn();
			
			local expl = string.Explode( ",", color );
			e:SetColor( Color( tonumber( expl[1] ), tonumber( expl[2] ), tonumber( expl[3] ), tonumber( expl[4] ) ) )
			
			e.Bed = ( bed == 1 );
			e.Chair = ( chair == 1 );
			e:SetContainer( cont );
			
			local child = V.ME.CHILD[model];
			
			if( child ) then
				
				local c = ents.Create( "v_propchild" );
				c:SetPos( Vector( x, y, z ) );
				c:SetAngles( Angle( p, ya, r ) );
				c:SetModel( child );
				c:Spawn();
				c:SetParent( e );
				e.Child = c;
				
				e:DeleteOnRemove( c );
				
			end
			
		end
		
	elseif( id == 2 ) then
		
		local x, y, z = tonumber( tab[2] ), tonumber( tab[3] ), tonumber( tab[4] );
		local size = tab[5];
		
		if( SERVER ) then
			
			local e = ents.Create( "v_fire" );
			e:SetPos( Vector( x, y, z ) );
			e:Spawn();
			e:SetSize( size );
			
		end
		
	elseif( id == 3 ) then
		
		local x, y, z = tonumber( tab[2] ), tonumber( tab[3] ), tonumber( tab[4] );
		local magnitude = tab[5];
		local maxdelay = tonumber( tab[6] );
		local traillength = tab[7];
		
		if( SERVER ) then
			
			local e = ents.Create( "v_sparks" );
			e:SetPos( Vector( x, y, z ) );
			e:Spawn();
			e:SetMagnitude( magnitude );
			e:SetMaxDelay( maxdelay );
			e:SetTrailLength( traillength );
			
		end
		
	elseif( id == 4 ) then
		
		local x, y, z = tonumber( tab[2] ), tonumber( tab[3] ), tonumber( tab[4] );
		local color = tab[5];
		local brightness = tonumber( tab[6] );
		local size = tonumber( tab[7] );
		local decay = tonumber( tab[8] );
		
		if( SERVER ) then
			
			local e = ents.Create( "v_light" );
			e:SetPos( Vector( x, y, z ) );
			e:Spawn();
			
			local expl = string.Explode( ",", color );
			e:SetLightColor( Color( tonumber( expl[1] ), tonumber( expl[2] ), tonumber( expl[3] ), tonumber( expl[4] ) ) )
			
			e:SetBrightness( brightness );
			e:SetSize( size );
			e:SetDecay( decay );
			
		end
		
	elseif( id == 5 ) then
		
		local x, y, z = tonumber( tab[2] ), tonumber( tab[3] ), tonumber( tab[4] );
		local ap, ay, ar = tonumber( tab[5] ), tonumber( tab[6] ), tonumber( tab[7] );
		local color = tab[8];
		local width = tonumber( tab[9] );
		local length = tonumber( tab[10] );
		
		if( SERVER ) then
			
			local e = ents.Create( "v_spotlight" );
			e:SetPos( Vector( x, y, z ) );
			e:SetAngles( Angle( ap, ay, ar ) );
			e:Spawn();
			
			local expl = string.Explode( ",", color );
			e:SetSpotColor( Color( tonumber( expl[1] ), tonumber( expl[2] ), tonumber( expl[3] ), tonumber( expl[4] ) ) )
			
			e:SetWidth( width );
			e:SetLength( length );
			
		end
		
	end
	
end

function V.ME.LoadMap()
	
	local f = "Vein/mapdata/" .. game.GetMap() .. ".txt";
	
	if( file.Exists( f, "DATA" ) ) then
		
		local ff = file.Open( f, "r", "DATA" );
		local a = ff:Read( ff:Size() );
		ff:Close();
		
		if( a ) then
			
			local lines = string.Explode( "\n", a );
			
			for _, v in pairs( lines ) do
				
				local argtab = string.Explode( " ", v );
				
				V.ME.LoadMapElement( tonumber( argtab[1] ), argtab );
				
			end
			
		end
		
	end
	
end

function V.ME.SaveMap()
	
	if( V.Nuked ) then return end
	
	local f = "Vein/mapdata/" .. game.GetMap() .. ".txt";
	local c = "";
	
	for _, v in pairs( ents.FindByClass( "v_prop" ) ) do
		
		if( v.IsMapBased and v:IsMapBased() ) then continue; end
		
		local pos = v:GetPos();
		local ang = v:GetAngles();
		
		c = c .. "1 ";
		c = c .. tostring( pos.x ) .. " " .. tostring( pos.y ) .. " " .. tostring( pos.z );
		c = c .. " " .. tostring( ang.p ) .. " " .. tostring( ang.y ) .. " " .. tostring( ang.r );
		c = c .. " " .. v:GetModel();
		c = c .. " " .. v:GetColor().r .. "," .. v:GetColor().g .. "," .. v:GetColor().b .. "," .. v:GetColor().a;
		c = c .. " " .. ( v.Bed and "1" or "0" );
		c = c .. " " .. ( v.Chair and "1" or "0" );
		c = c .. " " .. tostring( v.Container );
		c = c .. " " .. tostring( v:GetSkin() );
		
		c = c .. "\n";
		
	end
	
	for _, v in pairs( ents.FindByClass( "v_fire" ) ) do
		
		if( v.IsMapBased and v:IsMapBased() ) then continue; end
		
		local pos = v:GetPos();
		local size = v:GetSize();
		
		c = c .. "2 ";
		c = c .. tostring( pos.x ) .. " " .. tostring( pos.y ) .. " " .. tostring( pos.z );
		c = c .. " " .. tostring( size );
		
		c = c .. "\n";
		
	end
	
	for _, v in pairs( ents.FindByClass( "v_sparks" ) ) do
		
		if( v.IsMapBased and v:IsMapBased() ) then continue; end
		
		local pos = v:GetPos();
		local magnitude = v:GetMagnitude();
		local maxdel = v:GetMaxDelay();
		local trail = v:GetTrailLength();
		
		c = c .. "3 ";
		c = c .. tostring( pos.x ) .. " " .. tostring( pos.y ) .. " " .. tostring( pos.z );
		c = c .. " " .. tostring( magnitude ) .. " " .. tostring( maxdel ) .. " " .. tostring( trail );
		
		c = c .. "\n";
		
	end
	
	for _, v in pairs( ents.FindByClass( "v_light" ) ) do
		
		if( v.IsMapBased and v:IsMapBased() ) then continue; end
		
		local pos = v:GetPos();
		local color = v:GetLightColor();
		local b = v:GetBrightness();
		local s = v:GetSize();
		local d = v:GetDecay();
		
		c = c .. "4 ";
		c = c .. tostring( pos.x ) .. " " .. tostring( pos.y ) .. " " .. tostring( pos.z );
		c = c .. " " .. color[1] .. "," .. color[2] .. "," .. color[3] .. ",255";
		c = c .. " " .. tostring( b ) .. " " .. tostring( s ) .. " " .. tostring( d );
		
		c = c .. "\n";
		
	end
	
	for _, v in pairs( ents.FindByClass( "v_spotlight" ) ) do
		
		if( v.IsMapBased and v:IsMapBased() ) then continue; end
		
		local pos = v:GetPos();
		local ang = v:GetAngles();
		local color = v:GetLightColor();
		local w = v:GetWidth();
		local l = v:GetLength();
		
		c = c .. "5 ";
		c = c .. tostring( pos.x ) .. " " .. tostring( pos.y ) .. " " .. tostring( pos.z );
		c = c .. " " .. tostring( ang.p ) .. " " .. tostring( ang.y ) .. " " .. tostring( ang.r );
		c = c .. " " .. color[1] .. "," .. color[2] .. "," .. color[3] .. ",255";
		c = c .. " " .. tostring( w ) .. " " .. tostring( l );
		
		c = c .. "\n";
		
	end
	
	local ff = file.Open( f, "w", "DATA" );
	if( !ff ) then file.Write( f, "" ); end
	ff:Write( c );
	ff:Close();
	
end

V.CurSpotlightWatch = nil;

function GM:OnEntityCreated( ent )
	
	if( CLIENT and ent:IsPlayer() ) then
		
		ent:SetCustomCollisionCheck( !V.Config.PlayerCollision );
		
	end
	
end

V.ME.ConvertableClasses = {
	"prop_physics",
	"prop_dynamic",
	"prop_dynamic_override"
}

function GM:EntityKeyValue( ent, key, val )
	
	if( table.HasValue( V.ME.ConvertableClasses, ent:GetClass() ) ) then
		
		if( key == "vein" and val == "1" ) then
			
			ent.ToConvertToVein = true;
			
		end
		
		if( key == "bed" ) then
			
			ent.Bed = ( val == "1" );
			
		end
		
		if( key == "chair" ) then
			
			ent.Chair = ( val == "1" );
			
		end
		
		if( key == "container" ) then
			
			ent.Container = tonumber( val );
			
		end
		
	end
	
end

function V.ME.ConvertToVein( v )
	
	if( !v or !v:IsValid() ) then return end
	
	local pos = v:GetPos();
	local ang = v:GetAngles();
	local mdl = v:GetModel();
	local skin = v:GetSkin();
	local c = v:GetColor();
	local n = v:GetName();

	local bed = v.Bed;
	local chair = v.Chair;
	local cont = v.Container;

	v:Remove();

	local e = ents.Create( "v_prop" );
	e:SetPos( pos );
	e:SetAngles( ang );
	e:SetModel( mdl );
	e:SetSkin( skin );
	e:SetColor( c );
	e:SetName( n );
	e:Spawn();
	e:SetDTInt( 0, 1 );

	e.Bed = bed or false;
	e.Chair = chair or false;
	if( cont and cont > 0 ) then
		e:SetContainer( cont );
	end

	local child = V.ME.CHILD[mdl];

	if( child ) then
		
		local c = ents.Create( "v_propchild" );
		c:SetPos( pos );
		c:SetAngles( ang );
		c:SetModel( child );
		c:Spawn();
		c:SetParent( e );
		e.Child = c;
		
		e:DeleteOnRemove( c );
		
	end
	
end

function V.ME.InitPostEntity()
	
	if( SERVER ) then
		
		V.ME.LoadMap();
		V.ME.NextSave = CurTime() + 20;
		
		if( !file.Exists( "Vein/navmeshes/" .. game.GetMap() .. ".nav", "DATA" ) ) then
			
			V.NoMesh = true;
			
		end
		
		for _, x in pairs( V.ME.ConvertableClasses ) do
			
			for _, v in pairs( ents.FindByClass( x ) ) do
				
				if( v.ToConvertToVein ) then
					
					timer.Simple( 2, function() V.ME.ConvertToVein( v ) end ); -- Let physics props settle.
					
				end
				
			end
			
		end
		
	end
	
	for _, v in pairs( ents.FindByClass( "prop_door_rotating" ) ) do
		
		v.DoorHealth = 8;
		v.DoorMaxHealth = 8;
		
	end
	
end