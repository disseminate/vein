AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( "shared.lua" );

function ENT:UpdateTransmitState()
	
	return TRANSMIT_ALWAYS;
	
end

function ENT:Initialize()
	
	self:SetModel( "models/props_junk/PropaneCanister001a.mdl" );
	self:SetSkin( 1 );
	self:PhysicsRefresh();
	
	self.Sprite = ents.Create( "env_sprite" );
	self.Sprite:SetKeyValue( "model", "sprites/redglow1.vmt" );
	self.Sprite:SetKeyValue( "scale", "0.2" );
	self.Sprite:SetKeyValue( "renderamt", "255" );
	self.Sprite:SetKeyValue( "rendercolor", "255 255 255" );
	self.Sprite:SetPos( self:GetPos() + Vector( 0, 0, 12 ) );
	self.Sprite:SetParent( self );
	self.Sprite:Spawn();
	self.Sprite:Activate();
	self.Sprite:Fire( "HideSprite" );
	
end

function ENT:Use( ply )
	
	if( !self.BoomTime ) then
		
		self.BoomTime = CurTime() + 9;
		
		for i = 0, 8 do
			
			timer.Simple( i, function()
				
				if( self and self:IsValid() ) then
					
					self:EmitSound( "buttons/button16.wav" );
					
					self.Sprite:Fire( "ShowSprite" );
					self.Sprite:Fire( "HideSprite", "", "0.15" );
					
				end
				
			end );
			
		end
		
	end
	
end

function ENT:Think()
	
	if( self.BoomTime and CurTime() >= self.BoomTime ) then
		
		self:Explode();
		self:Remove();
		
	end
	
end

function ENT:PhysicsRefresh()
	
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );
	
	local p = self:GetPhysicsObject();
	
	if( p and p:IsValid() ) then
		
		p:EnableMotion( false );
		
	end
	
end

function ENT:Explode()
	
	util.ScreenShake( self:GetPos(), 5, 120, 1, 4096 );
	self:EmitSound( "ambient/explosions/explode_1.wav" );
	
end

function ENT:OnRemove()
	
	
	
end