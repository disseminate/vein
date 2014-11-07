function GM:PlayerBindPress( ply, bind, down )
	
	if( down and string.find( bind, "messagemode" ) and !GAMEMODE:InIntro() ) then
		
		net.Start( "e_chato" );
		net.SendToServer();
		
		V.CB.ShowChatbox();
		return true;
		
	end
	
	if( bind == "gm_showhelp" and down ) then
		
		V.CRED.CreatePanel();
		return true;
		
	end
	
	if( bind == "gm_showteam" and down ) then
		
		local trace = { };
			trace.start = ply:EyePos();
			trace.endpos = trace.start + ply:GetAimVector() * 4096;
			trace.filter = ply;
		local tr = util.TraceLine( trace );
		
		if( tr.Entity and tr.Entity:IsValid() and tr.Entity:IsPlayer() ) then
			
			V.SMEN.CreatePanel( tr.Entity );
			
		else
			
			V.SMEN.CreatePanel();
			
		end
		
		return true;
		
	end
	
	if( bind == "gm_showspare1" and down ) then
		
		V.INV.CreatePanel();
		return true;
		
	elseif( bind == "gm_showspare1" and !down ) then
		
		V.INV.ClosePanel();
		return true;
		
	end
	
	if( bind == "gm_showspare2" and down ) then
		
		V.CC.MakeMenu();
		return true;
		
	end
	
	if( bind == "+attack" and down ) then
		
		if( V.ME.SpawnMenuOpen ) then
			
			return true;
			
		end
		
	end
	
	self.BaseClass:PlayerBindPress( ply, bind, down );
	
end