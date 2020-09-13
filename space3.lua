b_counter=0
boss={80,49,10,10,20}
b_shoots={}

function draw_gui_boss()
	circfill(12,127,12,2)
	circfill(115,127,12,2)
	rectfill(12,115,115,127,2)
	circfill(12,127,10,8)
	circfill(115,127,10,8)
	rectfill(14,117,113,127,8)
	rectfill(13,119,114,125,6)
	if(boss[3]>0 or boss[4]>0)then
		if(boss[3]<3)then
			rectfill(13,119,13+boss[3]*5,125,9)
		elseif(boss[3]<6)then 
			rectfill(13,119,13+boss[3]*5,125,10)
		else 
			rectfill(13,119,13+boss[3]*5,125,3)
		end
		if(boss[4]<3)then 
			rectfill(64,119,64+boss[4]*5,125,9)
		elseif(boss[4]<6)then 
			rectfill(64,119,64+boss[4]*5,125,10)
		else 
			rectfill(64,119,64+boss[4]*5,125,3)
		end
	else
		if(boss[5]<6)then
			rectfill(13,119,14+boss[5]*5,125,9)
		elseif(boss[5]<12)then 
			rectfill(13,119,14+boss[5]*5,125,10)
		else 
			rectfill(13,119,14+boss[5]*5,125,3)
		end
	end
end

function draw_boss()
	spr(196,boss[1]+9,boss[2]-9,3,2)
	spr(228,boss[1]+9,boss[2]+25,3,2)
	if(boss[4]>0)then
		spr(231,boss[1]+12,boss[2]+36,3,2)
	else
		spr(234,boss[1]+12,boss[2]+36,3,2)
	end	
	if(boss[3]>0)then
		spr(199,boss[1]+12,boss[2]-22,3,2)
	else
		spr(202,boss[1]+12,boss[2]-22,3,2)
	end
	spr(192,boss[1],boss[2],4,4)	
end

function move_boss()
	b_counter=b_counter+1
	if(b_counter>200)then
		b_counter=0
		//debug=boss[1]..boss[2]
	elseif(b_counter>185)then
		boss[2]=boss[2]-1
	elseif(b_counter>155)then
		boss[2]=boss[2]+1
	elseif(b_counter>140)then
		boss[2]=boss[2]-1
	elseif(b_counter>100)then
		boss[1]=boss[1]+1
	elseif(b_counter>60)then
		boss[1]=boss[1]-1
	end
end

function draw_b_shoot(b_shoot)
	spr(b_shoot[3],b_shoot[1],b_shoot[2])
end

function gen_b_shoot(_boss)
	//debug=b_counter
	if(_boss[3]>0 or boss[4]>0)then
		if(b_counter%80==0)then
			add(b_shoots,{_boss[1]+1,_boss[2]+30,42,1})
			add(b_shoots,{_boss[1]+1,_boss[2]-6,42,1})	
		else
			add(b_shoots,{_boss[1]-8,_boss[2]+12,43,1})
			add(b_shoots,{_boss[1]-6,_boss[2]+19,43,1})
			add(b_shoots,{_boss[1]-6,_boss[2]+5,43,1})
		end
		if(b_counter==160)then
			add(b_shoots,{_boss[1]+7,_boss[2]+44,45,3})
			add(b_shoots,{_boss[1]+7,_boss[2]-20,45,3})	
		end
	else
		if(b_counter%80==0)then
			add(b_shoots,{_boss[1]+1,_boss[2]+30,42,1})
			add(b_shoots,{_boss[1]+1,_boss[2]-6,42,1})	
		elseif(b_counter!=120)then
			add(b_shoots,{_boss[1]-8,_boss[2]+12,43,1})
			add(b_shoots,{_boss[1]-6,_boss[2]+19,43,1})
			add(b_shoots,{_boss[1]-6,_boss[2]+5,43,1})
		end
	end
end

function destroy_b_shoot(b_shoot)
	b_shoot[3]=99
end

function del_b_shoot(o)
	if(o[3]==99)then
		del(b_shoots,o)
	end
end

function move_b_shoot(b_shoot)
	if(b_shoot!=nil)then
		if(b_shoot[1]<-8)then
			destroy_b_shoot(b_shoot)
		else
			b_shoot[1]=b_shoot[1]-1.3
		end
	end
end

function lazor()
	if(b_counter>=130 and b_counter<=190)then
		circfill(boss[1]-10,boss[2]+16,8,2)
		rectfill(0,boss[2]+8,boss[1]-10,boss[2]+24,2)
		circfill(boss[1]-12,boss[2]+16,6,8)
		rectfill(0,boss[2]+10,boss[1]-12,boss[2]+22,8)
		circfill(boss[1]-14,boss[2]+16,4,14)
		rectfill(0,boss[2]+12,boss[1]-14,boss[2]+20,14)
		circfill(boss[1]-16,boss[2]+16,2,7)
		rectfill(0,boss[2]+14,boss[1]-16,boss[2]+18,7)
	else
  rectfill(0,boss[2]+15,boss[1]-2,boss[2]+16,7)
 end
end

function boss_fight()
	move_boss()
	draw_boss()
	draw_gui_boss()
	if(b_counter>=120 and boss[3]<=0 and boss[4]<=0)then
		lazor()
		if(b_counter>=130 and b_counter<=190)then
			check_col_lazor_ship(ship,boss)
		end
	end
	if(b_counter%40==0)then
		gen_b_shoot(boss)
	end
	for i=1,#b_shoots,1 do
		move_b_shoot(b_shoots[i])
		draw_b_shoot(b_shoots[i])
	end
	for i=1,#b_shoots,1 do
		for j=1,#shoots,1 do
			check_col_shoot_eshoot(shoots[j],b_shoots[i])
		end
		if(counter==0)then
			if(check_col_eeshoot(ship,b_shoots[i])==true)then
				counter=counter+1
			end
		end
		if(boss[5]<=0)then
			text_num=3
			is_splash_screen=true
			s_counter=0
		end
	end
	for i=1,#shoots,1 do
		check_col_bshoot(boss,shoots[i])
	end
	if(check_col_bship(boss,ship)==true)then
		counter=counter+1
	end
end
