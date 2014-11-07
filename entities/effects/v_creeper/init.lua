function EFFECT:Init( data )
	
	self.NextScream = 0;
	local origin = data:GetOrigin();
	self.Distance = data:GetMagnitude();
	
	self.Entity:SetModel( "models/nmr_zombie/zombiekid_girl.mdl" );
	self.Entity:SetPos( origin );
	self.Entity:SetSequence( self.Entity:LookupSequence( "idle" ) );
	self.Entity:SetPlaybackRate( 1.0 );
	
	V.INS.Creeper = self.Entity;
	
end

function EFFECT:Think()
	
	if( CurTime() > self.NextScream ) then
		
		self.NextScream = CurTime() + 6;
		self:EmitSound( Sound( "npc/witch/voice/retreat/horrified_" .. tostring( math.random( 1, 4 ) ) .. ".wav" ) );
		
	end
	
	if( !V.INS.SeenCreeper and V.OnScreen( LocalPlayer(), self.Entity ) ) then
		
		V.INS.SeenCreeper = CurTime() + 0.3;
		
	end
	
	local ang = ( LocalPlayer():GetPos() - self.Entity:GetPos() ):Angle();
	self.Entity:SetAngles( ang );
	
	if( self.Entity:GetPos():Distance( LocalPlayer():GetPos() ) > self.Distance + 64 or self.Entity:GetPos():Distance( LocalPlayer():GetPos() ) < self.Distance - 64 ) then
		
		V.INS.Creeper = nil;
		V.INS.SeenCreeper = nil;
		return false;
		
	end
	
	return true;
	
end

function EFFECT:Render()
	
	self.Entity:DrawModel();
	
end
