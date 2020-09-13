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
				if(lives>0)then 
					sfx(1) 
				end
				//debug=obj1[3]
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
			sfx(3)
			if(obj1[3]<7)then
				remove_asteroid(obj1)
			end
		end
	end
end

function check_col_eship(obj1,obj2)
	if(obj2[3]!=255)then
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
				if(lives>0)then sfx(1) end
			end		
			return true
		else
			return false
		end
	end
end

function check_col_eshoot(obj1,obj2)
	if(obj1[3]!=255 and obj2!=nil)then
		distance=culc_dist({obj1[1]+4*obj1[5],obj1[2]+4*obj1[5]},{obj2[1]+8,obj2[2]+4.5})
		if(distance!=0 and distance<=4*obj1[5])then
			obj1[4]=obj1[4]-weapons[weapon][2]
			del_shoot(obj2)
			if(obj1[4]<1)then
				destroy_enemy(obj1)
				gen_weapon_pack(obj1)
				sfx(2)
			end
			score=score+1*obj1[3]
		end
	end
end

function check_col_eeshoot(obj1,obj2)
	if(obj2[3]!=255)then
		distance=culc_dist({obj1[1]+8.5,obj1[2]+8.5},{obj2[1],obj2[2]+4.5})
		if(distance!=0 and distance<=8)then
			if(counter==0 and was_hit==false)then
				if(shield<5)then
					shield=shield+1*obj2[4]
				end
				if(shield>=5)then
					lives=lives-1
					sh_counter=1
				end
				obj2[3]=255
				was_hit=true
			end		
			return true
		else
			return false
		end
	end
end

function check_col_wpship(obj1,obj2)
	if(weapon_pack[1]!=nil)then
		distance=culc_dist({obj1[1]+8.5,obj1[2]+8.5},{obj2[1],obj2[2]+4.5})
		if(distance!=0 and distance<=10)then
			weapon=weapon+1
			destroy_weapon_pack()
			sfx(4)
		end
	end
end

function check_col_shoot_eshoot(shoot,eshoot)
	if(eshoot[3]!=255)then
		if(eshoot[3]==42 or eshoot[3]==43)then
			if((shoot[1]+8<eshoot[1]+1 and shoot[1]+8>eshoot[1]-2)and(shoot[2]<eshoot[2]+2 and shoot[2]>eshoot[2]-2))then
				eshoot[3]=255
				del_shoot(shoot)
			end
		else
			if((shoot[1]+8<eshoot[1]+1 and shoot[1]+8>eshoot[1]-2)and(shoot[2]<eshoot[2]+4 and shoot[2]>eshoot[2]-4))then
				eshoot[3]=255
				del_shoot(shoot)
			end
		end
	end
end

function check_col_lazor_ship(obj1,obj2)
	if(obj1[1]>=0 and obj1[1]+16<=obj2[1] and obj1[2]>obj2[2]-8 and obj1[2]<obj2[2]+40)then
		if(counter==0 and was_hit==false)then
			if(shield<5)then
				shield=shield+3
			end
			if(shield>=5)then
				lives=lives-1*obj1[3]
				sh_counter=1
			end
			was_hit=true
			if(lives>0)then sfx(1) end	
		end
	end
end

function check_col_bship(boss,ship)
	up=0 down=0
	if(boss[3]>0)then
		up=up-22
	else
		up=up-9
	end
	if(boss[4]>0)then
		down=down+52
	else
		down=down+25
	end
	if(ship[1]+16>boss[1] and ship[2]>boss[2]+up and ship[2]+16<boss[2]+down)then
		if(counter==0 and was_hit==false)then
			if(shield<5)then
				shield=shield+1
			end
			if(shield>=5)then
				lives=lives-1
				sh_counter=1
			end
			was_hit=true
			if(lives>0)then sfx(1) end
			ship[1]=ship[1]-5
		end		
		return true
	else
		return false	
	end
end

function check_col_bshoot(boss,shoot)
	if(shoot!=nil)then
		up=0 down=0
		if(boss[3]>0)then
			up=up-22
		else
			up=up-9
		end
		if(boss[4]>0)then
			down=down+52
		else
			down=down+25
		end
		if(shoot[1]+8>boss[1] and shoot[2]+4>=boss[2]+up and shoot[2]+4<=boss[2]+down)then
			if(boss[3]>0 or boss[4]>0)then
				boss[3]=boss[3]-weapons[weapon][2]
				if(boss[3]<0)then boss[3]=0 end
				boss[4]=boss[4]-weapons[weapon][2]
				if(boss[4]<0)then boss[4]=0 end
			else
				boss[5]=boss[5]-weapons[weapon][2]
				if(boss[5]<0)then boss[5]=0 end
			end
			del_shoot(shoot)
			sfx(2)
		end	
	end
end
//--------------------------------------------------------------------------
