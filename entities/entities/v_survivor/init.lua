AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( "shared.lua" );
include( "schedules.lua" );

ENT.MaleLines = { };
ENT.MaleLines[1] = { "vo/npc/male01/getgoingsoon.wav", "Are we going to get going soon?", 3 };

function ENT:Initialize()
	
	self:SetModel( "models/humans/group01/male_01.mdl" );

    self:SetHullType( HULL_HUMAN );
    self:SetHullSizeNormal();
	
    self:SetSolid( SOLID_BBOX );
    self:SetMoveType( MOVETYPE_STEP );
	
   	self:CapabilitiesAdd( CAP_MOVE_GROUND + CAP_ANIMATEDFACE + CAP_TURN_HEAD );
   	
    self:SetMaxYawSpeed( 50 );
	
	self:SetHealth( 20 );
	
	self.Dead = false;
	
end

function ENT:SpawnBlood( pos )
	
	local ed = EffectData();
	ed:SetOrigin( pos );
	util.Effect( "BloodImpact", ed );
	
end

function ENT:OnTakeDamage( dmg )
	
	if( self.Dead ) then return end
	
	local pos = dmg:GetDamagePosition();
	local type = dmg:GetDamageType();
	
	if( type == DMG_SLASH or dmg:IsBulletDamage() ) then
		
		self:SpawnBlood( pos );
		
	end
	
	if( dmg:IsBulletDamage() ) then
		
		self:SetHealth( 0 );
		
	else
		
		self:SetHealth( self:Health() - dmg:GetDamage() );
		
	end
	
	if( self:Health() <= 0 ) then
		
		self:Die();
		
	end
	
end

function ENT:FindClosestPlayer()
	
	local d = math.huge;
	local p = nil;
	
	for _, v in pairs( player.GetAll() ) do
		
		local r = v:GetPos():Distance( self:GetPos() )
		
		if( r < d ) then
			
			d = r;
			p = v;
			
		end
		
	end
	
	return p, d;
	
end

function ENT:Think()
	
	if( self.Dead ) then return end
	
	if( !self.NextTalk ) then self.NextTalk = CurTime(); end
	
	if( CurTime() > self.NextTalk ) then
		
		local p, d = self:FindClosestPlayer();
		
		if( d < 384 ) then
			
			self.NextTalk = CurTime() + math.random( 10, 15 );
			self:Talk( p );
			
		end
		
	end
	
end

function ENT:Talk( ply )
	
	local line = table.Random( self.MaleLines );
	
	self:StartSchedule( self.TalkToPlayer );
	self:EmitSound( Sound( line[1] ) );
	
	net.Start( "nHUDCaption" );
		net.WriteString( line[2] );
		net.WriteFloat( line[3] );
	net.Send( ply );
	
end

function ENT:Die()
	
	self.Dead = true;
	self:SetRenderFX( 23 );
	
	timer.Simple( 1, function()
		if( self and self:IsValid() ) then
			self:Remove();
		end
	end );
	
end