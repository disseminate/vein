ENT.Type = "anim";
ENT.Base = "base_anim";

function ENT:SetupDataTables()
	
	self:NetworkVar( "String", 0, "OverlayTexture", { KeyName = "overlaytexture" } );
	self:NetworkVar( "Float", 0, "Scale", { KeyName = "scale" } );
	
end