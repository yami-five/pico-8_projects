counter=0
a_counter=0
s_counter=10
sh_counter=0
e_counter=0
ship={10,56,0}
stars1={}
stars2={}
asteroids={}
enemies={}
e_shoots={}
lives=5
was_hit=false
score=0
shoots={}
weapon=1
weapons={{3,1},{4,1.1},{5,1.2},{6,1.3}}
weapon_pack={}
shield=1
shield_lvl={7,12,1,8,0}

//interface functions
function print_score()
	str=''
	for i=1,10-#(tostr(score)..'00'),1 do
		str=str..'0'
	end
	str=str..tostr(score)..'00'
	print(str,120-#str*4,3,1)
end

function draw_lives()
	for i=0,lives-1,1 do
		spr(2,(1+i*10)+6,1)
	end
end

function draw_gui()
	circfill(12,0,12,1)
	circfill(115,0,12,1)
	rectfill(12,0,115,12,1)
	circfill(12,0,10,11)
	circfill(115,0,10,11)
	rectfill(14,0,113,10,11)
end

function draw_end_screen()
	circfill(12,64,12,1)
	circfill(115,64,12,1)
	rectfill(12,52,115,76,1)
	circfill(12,64,10,11)
	circfill(115,64,10,11)
	rectfill(14,54,113,74,11)
	print('you died',48,58,1)
	print('press x to restart',28,67,1)
end
//--------------------------------------------------------------------------
//background functions
function move_stars(stars,speed)
	for i=1,128,1 do
		stars[i][1]=stars[i][1]-speed
		if(stars[i][1]<0)then
			stars[i][1]=128
		end
		pset(flr(stars[i][1]),stars[i][2],stars[i][3])	
	end
end
//--------------------------------------------------------------------------
//player functions
function draw_shields()
	if(shield<5 and lives>0)then
		circ(ship[1]+8,ship[2]+8,12,shield_lvl[shield])
	end
end

function restart()
	ship[1]=10
	ship[2]=56
	score=0
	enemies={}
	asteroids={}
	shoots={}
	e_shoots={}
	lives=5
	shield=1
	gen_asteroid()
end
//--------------------------------------------------------------------------
//asteroids functions
function gen_asteroid()
	add(asteroids,{140,flr(rnd(110)+20),flr(rnd(8))+7})
end

function remove_asteroid(asteroid)
	del(asteroids,asteroid)
end

function draw_asteroid(asteroid)
	circfill(asteroid[1],asteroid[2],asteroid[3],5)
	circfill(asteroid[1]+1,asteroid[2]-1,asteroid[3]-3,4)
	circfill(asteroid[1]+2,asteroid[2]-2,ceil(asteroid[3]/2)-2,15)
end

function move_asteroid(asteroid,speed)
	if(asteroid[1]<(asteroid[3]+20)*(-1))then
		remove_asteroid(asteroid)
		gen_asteroid()
	else
		asteroid[1]=asteroid[1]-speed
	end
end
//--------------------------------------------------------------------------
//enemies functions
function pow(number,exp)
	if(exp==0)then
		return 0
	else
		result=1
		for i=1,exp,1 do
			result=result*number
		end
		return result
	end
end

function gen_enemy()
	types=0 size=0
	if(score>7500)then
		types=5
	elseif(score>3000)then
		types=4
	elseif(score>1000)then
		types=3
	elseif(score>500)then
		types=2
	elseif(score>100)then
		types=1
	end
	types=ceil(rnd(types))
	if(types==1)then
		size=1
	else
		size=2
	end
	add(enemies,{128,flr(rnd(100)+20),types,types,size,32+pow(2,(types-1)),0})
	e_counter=1
end

function destroy_enemy(enemy)
	enemy[3]=99 enemy[6]=99	
end

function remove_enemy(o)
	if(o[3]==99)then
		del(enemies,o)
	end
end

function draw_enemy(enemy)
	if(enemy!=nil)then
		spr(enemy[6],enemy[1],enemy[2],enemy[5],enemy[5])
	end
end

function move_enemy(enemy)
	if(enemy!=nil)then
		enemy[1]=enemy[1]-1
		if(enemy[1]<-15 or enemy[4]<1)then
			destroy_enemy(enemy)
		end
	end
end
//--------------------------------------------------------------------------
//players shoots functions
function shoot()
	add(shoots,{ship[1]+16,ship[2]+4})
end

function del_shoot(shoot)
	del(shoots,shoot)
end

function move_shoot(shoot)
	if(shoot!=nil)then
		if(shoot[1]>127)then
			del_shoot(shoot)
		else
			shoot[1]=shoot[1]+1
		end
	end
end

function draw_shoot(shoot)
	spr(weapons[weapon][1],shoot[1],shoot[2])
end
//--------------------------------------------------------------------------
//enemies shoots funtions
function gen_e_shoot(enemy)
	add(e_shoots,{enemy[1]-8,enemy[2]+4,40+enemy[3]})
end

function destroy_e_shoot(e_shoot)
	e_shoot[3]=99
end

function del_e_shoot(o)
	if(o[3]==99)then
		del(e_shoots,o)
	end
end

function move_e_shoot(e_shoot)
	if(e_shoot!=nil)then
		if(e_shoot[1]<-8)then
			destroy_e_shoot(e_shoot)
		else
			e_shoot[1]=e_shoot[1]-1.3
		end
	end
end

function draw_e_shoot(e_shoot)
	spr(e_shoot[3],e_shoot[1],e_shoot[2])
end
//--------------------------------------------------------------------------
//weapon pack funtions
function gen_weapon_pack(enemy)
	if(#weapon_pack==0 and weapon<#weapons)then
		if(flr(rnd(2))==1)then
			print('here!',64,64,1)
			weapon_pack[1]=enemy[1]
			weapon_pack[2]=enemy[2]
		end
	end
end

function destroy_weapon_pack()
	weapon_pack={}
end

function move_weapon_pack()
	if(#weapon_pack!=0)then
		if(weapon_pack[1]<-8)then
			destroy_weapon_pack()
		else
			weapon_pack[1]=weapon_pack[1]-1.3
		end
	end
end

function draw_weapon_pack()
	if(#weapon_pack!=0)then
		spr(18,weapon_pack[1],weapon_pack[2])
	end
end
//--------------------------------------------------------------------------
//collisions functions
function culc_dist(obj1,obj2)
	distance=(obj2[1]-obj1[1])*(obj2[1]-obj1[1])
	distance=distance+(obj2[2]-obj1[2])*(obj2[2]-obj1[2])
	return sqrt(distance)
end

function check_col_aship(obj1,obj2)
	if(obj1!=nil)then
		distance=culc_dist(obj1,{obj2[1]+8.5,obj2[2]+8.5})
		if(distance!=0 and distance<=obj1[3]+8)then
			if(counter==0 and was_hit==false)then
				if(shield<5)then
					shield=shield+1
				end
				if(shield>=5)then
					lives=lives-1
					sh_counter=1
				end
				was_hit=true
			end
			return true
		else
			return false
		end
	end
end

function check_col_ashoot(obj1,obj2)
	if(obj1!=nil and obj2!=nil)then
		distance=culc_dist(obj1,{obj2[1]+8,obj2[2]+4.5})
		if(distance!=0 and distance<=obj1[3])then
			obj1[3]=obj1[3]-3*weapons[weapon][2]
			del_shoot(obj2)
			score=score+10
			if(obj1[3]<7)then
				remove_asteroid(obj1)
			end
		end
	end
end

function check_col_eship(obj1,obj2)
	if(obj2[3]!=99)then
		distance=culc_dist({obj1[1]+4*obj1[5],obj1[2]+4*obj1[5]},{obj2[1]+8.5,obj2[2]+8.5})
		if(distance!=0 and distance<=4*obj1[5]+8)then
			if(counter==0 and was_hit==false)then
				if(shield<5)then
					shield=shield+1
				end
				if(shield>=5)then
					lives=lives-1*obj1[3]
					sh_counter=1
				end
				gen_weapon_pack(obj2)
				was_hit=true
			end		
			return true
		else
			return false
		end
	end
end

function check_col_eshoot(obj1,obj2)
	if(obj1[3]!=99 and obj2!=nil)then
		distance=culc_dist({obj1[1]+4*obj1[5],obj1[2]+4*obj1[5]},{obj2[1]+8,obj2[2]+4.5})
		if(distance!=0 and distance<=4*obj1[5])then
			obj1[4]=obj1[4]-weapons[weapon][2]
			del_shoot(obj2)
			if(obj1[4]<1)then
				destroy_enemy(obj1)
				gen_weapon_pack(obj1)
			end
			score=score+1*obj1[3]
		end
	end
end

function check_col_eeshoot(obj1,obj2)
	if(obj2[3]!=99)then
		distance=culc_dist({obj1[1]+8.5,obj1[2]+8.5},{obj2[1],obj2[2]+4.5})
		if(distance!=0 and distance<=8)then
			if(counter==0 and was_hit==false)then
				if(shield<5)then
					shield=shield+1
				end
				if(shield>=5)then
					lives=lives-1*obj1[3]
					sh_counter=1
				end
				obj2[3]=99
				was_hit=true
			end		
			return true
		else
			return false
		end
	end
end

function check_col_wpship(obj1,obj2)
	distance=culc_dist({obj1[1]+8.5,obj1[2]+8.5},{obj2[1],obj2[2]+4.5})
	if(distance!=0 and distance<=8)then
		weapon=weapon+1
		destroy_weapon_pack()
	end
end
//--------------------------------------------------------------------------

function _init()
	palt(0, true)
	for i=0,128,1 do
		stars1[i]={i,flr(rnd(127)),7}
		stars2[i]={i,flr(rnd(127)),5}
	end
	gen_asteroid()
end

function _update()
	if(lives>0)then
		if(btn(0)and ship[1]>0)then
			ship[1]=ship[1]-2.5
		end
		if(btn(1)and ship[1]<112)then
			ship[1]=ship[1]+2.5
		end
		if(btn(2)and ship[2]>14)then
			ship[2]=ship[2]-2.5
		end
		if(btn(3)and ship[2]<112)then
			ship[2]=ship[2]+2.5
		end
		if(btn(4)and s_counter==10)then
			shoot()
			s_counter=0
		end
	else
		if(btn(5))then
			restart()
		end
	end
end

function _draw()
	cls()
	move_stars(stars2,0.2)
	move_stars(stars1,0.3)
	for i=1,#asteroids,1 do
		move_asteroid(asteroids[i],0.7)
		if(counter==0)then
			if(check_col_aship(asteroids[i],ship)==true)then
				counter=counter+1
			end
		end
		draw_asteroid(asteroids[i])
	end
	if(#enemies<11 and score>10 and e_counter==0)then
		gen_enemy()
	end
	if(e_counter>0)then
		e_counter=e_counter+1
		if(e_counter>=50)then
			e_counter=0
		end
	end
	if(lives>0)then
		spr(ship[3],ship[1],ship[2],2,2)
	end
	draw_shields()
	for i=1,#enemies,1 do
		move_enemy(enemies[i])
		draw_enemy(enemies[i])
	end
	for i=1,#enemies,1 do
		if(counter==0)then
			if(check_col_eship(enemies[i],ship)==true)then
				counter=counter+1
				enemies[i][7]=enemies[i][7]+1
				if(enemies[i][7]==enemies[i][3]*15)then
					enemies[i][7]=0
				end
			end
		end
		if(enemies[i][7]==0 and enemies[i][3]!=1)then
			gen_e_shoot(enemies[i])
			enemies[i][7]=enemies[i][7]+1
		elseif(enemies[i][7]==15*enemies[i][3])then
			enemies[i][7]=0
		elseif(enemies[i][7]>0 and enemies[i][3]!=1)then
			enemies[i][7]=enemies[i][7]+1
		end
	end
	for i=1,#e_shoots,1 do
		move_e_shoot(e_shoots[i])
		if(counter==0)then
			if(check_col_eeshoot(ship,e_shoots[i])==true)then
				counter=counter+1
			end
		end
		draw_e_shoot(e_shoots[i])
	end
	a_counter=a_counter+1
	if(a_counter==60)then
		if(#asteroids<10)then
			gen_asteroid()
		end
		a_counter=0
	end
	if(sh_counter>0)then
		sh_counter=sh_counter+1
		if(sh_counter%6!=0)then
			print('attention! shields down!',16,16,8)
		end
		if(sh_counter>=50)then
			sh_counter=0
			shield=1
		end
	end
	for i=1,#shoots,1 do
		move_shoot(shoots[i])
	end
	for i=1,#shoots,1 do
		draw_shoot(shoots[i])
	end
	if(s_counter<10)then
		s_counter=s_counter+1
	end
	for i=1,#shoots,1 do
		for j=1,#asteroids,1 do
			check_col_ashoot(asteroids[j],shoots[i])
		end
	end
	for i=1,#shoots,1 do
		for j=1,#enemies,1 do
			check_col_eshoot(enemies[j],shoots[i])
		end
	end
	if(counter>10)then
		counter=0
		was_hit=false
	elseif(counter>0)then
		counter=counter+1
	end
	draw_gui()
	draw_lives()
	print_score()
	if(#weapon_pack!=0)then
		move_weapon_pack()
		draw_weapon_pack()
		check_col_wpship(ship,weapon_pack)
	end
	foreach(enemies,remove_enemy)
	foreach(e_shoots,del_e_shoot)
	if(lives<=0)then
		draw_end_screen()
	end
end