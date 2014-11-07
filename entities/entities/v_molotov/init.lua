AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( "shared.lua" );

function ENT:UpdateTransmitState()
	
	return TRANSMIT_ALWAYS;
	
end

function ENT:Initialize()
	
	self:PhysicsRefresh();
	
end

function ENT:PhysicsRefresh()
	
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );
	
	local p = self:GetPhysicsObject();
	
	if( p and p:IsValid() ) then
		
		p:Wake();
		
	end
	
end

function ENT:PhysicsCollide( cdata, obj )
	
	if( SERVER ) then
		
		self:EmitSound( Sound( "weapons/vein/molotov/0" .. tostring( math.random( 1, 4 ) ) .. ".wav" ) );
		
		self:MakeFire();
		
		self:Remove();
		
	end
	
end

function ENT:MakeFire()
	
	for i = 1, 20 do
		
		local a = math.Rand( 0, 2 * math.pi );
		local s = math.sin( a );
		local c = math.cos( a );
		local r = math.random( 0, 256 );
		
		local x = c * r;
		local y = s * r;
		
		local trace = { };
		trace.start = self:GetPos();
		trace.endpos = trace.start + Vector( x, y, 48 );
		trace.filter = self;
		local tr = util.TraceLine( trace );
		
		if( !tr.Hit ) then
			
			local trace = { };
			trace.start = tr.HitPos;
			trace.endpos = trace.start + Vector( 0, 0, -32768 );
			trace.filter = self;
			tr = util.TraceLine( trace );
			
		end
		
		local del = math.Rand( 0, 1 );
		
		local fireEnt = ents.Create( "env_fire" );
		fireEnt:SetPos( tr.HitPos );
		fireEnt:SetKeyValue( "spawnflags", "1" );
		fireEnt:SetKeyValue( "attack", "4" );
		fireEnt:SetKeyValue( "firesize", "128" );
		fireEnt:Spawn();
		fireEnt:Activate();
		fireEnt:Fire( "Enable", "", del );
		fireEnt:Fire( "StartFire", "", del );
		
		SafeRemoveEntityDelayed( fireEnt, math.random( 28, 35 ) );
		
	end
	
end