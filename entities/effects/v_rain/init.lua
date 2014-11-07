function EFFECT:Init( data )
	
	local m = data:GetMagnitude();
	local n = data:GetRadius();
	
	local em3D = ParticleEmitter( data:GetOrigin(), true );
	
	if( em3D ) then
		
		for i = 1, n do
			
			local pos = data:GetOrigin() + Vector( math.random( -m, m ), math.random( -m, m ), math.random( m, 2 * m ) );
			
			if( V.Outside( pos ) ) then
				
				local p = em3D:Add( "particle/water_drop", pos );
				
				p:SetAngles( Angle( 0, 0, -90 ) );
				p:SetVelocity( Vector( 0, 0, -1000 ) );
				p:SetDieTime( 5 );
				p:SetStartAlpha( 230 );
				p:SetStartSize( 4 );
				p:SetEndSize( 4 );
				p:SetColor( 255, 255, 255 );
				
				p:SetCollide( true );
				p:SetCollideCallback( function( p, pos, norm )
					
					if( render.GetDXLevel() > 90 and V.SET.Settings["fancyrain"] == "1" and math.random( 1, 10 ) == 1 ) then
						
						local ed = EffectData();
							ed:SetOrigin( pos );
						util.Effect( "v_rainsplash", ed );
						
					end
					
					p:SetDieTime( 0 );
					
				end );
				
			end
			
		end
		
		em3D:Finish();
		
	end
	
	local em2D = ParticleEmitter( data:GetOrigin() );
	
	if( em2D ) then
		
		if( math.random( 1, ( n / 80 ) * 2 ) == 1 ) then
			
			local pos = data:GetOrigin() + Vector( math.random( -m, m ), math.random( -m, m ), math.random( m, 2 * m ) );
			
			if( V.Outside( pos ) ) then
				
				local p = em2D:Add( "effects/rainsmoke", pos );
				
				p:SetVelocity( Vector( 0, 0, -1000 ) );
				p:SetDieTime( 5 );
				p:SetStartAlpha( 6 );
				p:SetStartSize( 166 );
				p:SetEndSize( 166 );
				p:SetColor( 150, 150, 200 );
				
				p:SetCollide( true );
				p:SetCollideCallback( function( p, pos, norm )
					
					p:SetDieTime( 0 );
					
				end );
				
			end
			
		end
		
		em2D:Finish();
		
	end
	
end

function EFFECT:Think()
	
	return false;
	
end

function EFFECT:Render()
	
	
	
end
