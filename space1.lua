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
weapons={{3,1},{4,1.2},{5,1.4},{6,1.6},{7,1.8},{8,2},{9,2.2},{10,2.4},{11,2.6},{12,2.8},{13,3},{14,3.4},{15,3.6}}
weapon_pack={}
shield=1
shield_lvl={7,12,1,8,0}
debug=0
title=true
is_boss_fight=false
is_splash_screen=false
text_num=1

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

function draw_win_screen()
	circfill(12,64,12,1)
	circfill(115,64,12,1)
	rectfill(12,52,115,76,1)
	circfill(12,64,10,11)
	circfill(115,64,10,11)
	rectfill(14,54,113,74,11)
	print('you win',50,58,1)
	print('press x to restart',28,67,1)
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
	counter=0
	a_counter=0
	s_counter=10
	sh_counter=0
	e_counter=0
	gen_asteroid()
	char=0
	text_num=2
	is_boss_fight=false
	boss={80,49,10,10,20}
end
//--------------------------------------------------------------------------
//asteroids functions
function gen_asteroid()
	add(asteroids,{140,flr(rnd(100)+30),flr(rnd(8))+7})
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
	//debug=types
	types=ceil(rnd(types))
	if(types==1)then
		size=1
	else
		size=2
	end
	//add(enemies,{128,flr(rnd(100)+20),types,types,size,32+pow(2,(types-1)),0})
	add(enemies,{128,flr(rnd(100)+20),types,types,size,32+2*(types-1),0})
	e_counter=1
end

function destroy_enemy(enemy)
	enemy[3]=255 enemy[6]=255	
end

function remove_enemy(o)
	if(o[3]==255)then
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
	add(shoots,{ship[1]+16,ship[2]+4,weapon})
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
	spr(weapons[shoot[3]][1],shoot[1],shoot[2])
end
//--------------------------------------------------------------------------
//enemies shoots funtions
function gen_e_shoot(enemy)
	add(e_shoots,{enemy[1]-8,enemy[2]+4,40+enemy[3],enemy[3]-1})
end

function destroy_e_shoot(e_shoot)
	e_shoot[3]=255
end

function del_e_shoot(o)
	if(o[3]==255)then
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
	if(weapon_pack[1]==nil and weapon<#weapons)then
		if(flr(rnd(4))==1)then
			weapon_pack[1]=enemy[1]
			weapon_pack[2]=enemy[2]
		end
	end
end

function destroy_weapon_pack()
	weapon_pack={}
end

function move_weapon_pack()
	if(weapon_pack[1]!=nil)then
		if(weapon_pack[1]<-8)then
			destroy_weapon_pack()
		else
			weapon_pack[1]=weapon_pack[1]-1.3
		end
	end
end

function draw_weapon_pack()
	if(weapon_pack[1]!=nil)then
		spr(18,weapon_pack[1],weapon_pack[2])
	end
end
//--------------------------------------------------------------------------

function _init()
	title_screen()
	palt(0, true)
	for i=0,128,1 do
		stars1[i]={i,flr(rnd(127)),7}
		stars2[i]={i,flr(rnd(127)),5}
	end
	//start_game()
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
			if(is_splash_screen==true) then
				//text_num=text_num+1
				is_splash_screen=false
				char=0
			elseif(title==true)then
				title=false
				//is_boss_fight=true
				text_num=1
				is_splash_screen=true
				s_counter=0
			else
				shoot()
				s_counter=0
				sfx(0)
				if(score>=30000)then
					is_boss_fight=true
				end
			end
		end
	else
		if(btn(5))then
			restart()
		end
	end
end

function _draw()
	cls()
	if(lives<=0)then
		draw_end_screen()
	else
		//print(debug,10,30,1)
		move_stars(stars2,0.2)
		move_stars(stars1,0.3)
		if(is_splash_screen==true)then
			print_text()
		elseif(title==false and is_splash_screen==false)then
			spr(ship[3],ship[1],ship[2],2,2)
			draw_shields()
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
			if(counter>10)then
				counter=0
				was_hit=false
			elseif(counter>0)then
				counter=counter+1
			end
			draw_gui()
			draw_lives()
			print_score()
			if(is_boss_fight==true)then
				boss_fight()
			else
				for i=1,#asteroids,1 do
					move_asteroid(asteroids[i],0.7)
					if(counter==0)then
						if(check_col_aship(asteroids[i],ship)==true)then
							counter=counter+1
						end
					end
					draw_asteroid(asteroids[i])
				end
				if(#enemies<8 and score>100 and e_counter==0)then
					gen_enemy()
				end
				if(e_counter>0)then
					e_counter=e_counter+1
					if(e_counter>=50)then
						e_counter=0
					end
				end
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
					for j=1,#shoots,1 do
						check_col_shoot_eshoot(shoots[j],e_shoots[i])
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
				if(weapon_pack[1]!=nil)then
					move_weapon_pack()
					check_col_wpship(ship,weapon_pack)
					draw_weapon_pack()
				end
				foreach(enemies,remove_enemy)
				foreach(e_shoots,del_e_shoot)
			end
		else
			title_screen()
		end
	end
end