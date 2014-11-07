include( "shared.lua" );

function ENT:Draw()
	
	if( V.ME.ContextOpen ) then
		
		self:DrawModel();
		
	end
	
end
