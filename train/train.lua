height=1
tracks=5
counter=0
trees=32
mountains=32
sky1=0
sky2=0
sky3=0
csky1={0x12, 0x21, 2}
csky2={0x2e, 0xe2, 14}
csky3={0xea, 0xae, 10}
sunrise=1
skybottom=0

function change_height()
	if counter%50==0 then
		if height==1 then height=0
		else height=1
		end
	end
end

function draw_locomotive(a)
	spr(128,-20+48*a,80+height,2,2)
	change_height()
	spr(130,-4+48*a,80+height,2,2)
	change_height()
	spr(132,12+48*a,80+height,2,2)
	change_height()
end

function draw_car(a)
	spr(0,-20+48*a,80+height,2,2)
	change_height()
	spr(2,-4+48*a,80+height,2,2)
	change_height()
	spr(0,12+48*a,80+height,2,2,-1)
	change_height()
end

function draw_tracks()
	for i=0,128,4 do
		line(0+i+tracks,92,0+i+tracks,97,5)
	end
	line(0,92,127,92,127,6)
	line(0,97,127,97,127,6)
	if counter%2==0 then
		tracks=tracks-1
	end
	if tracks==0 then tracks=5 end
end

function draw_trees(mod,sprite)
	for i=-32,160,32 do
		spr(sprite,0+i+trees-mod,60,4,4)
	end
end

function draw_sun()
	circfill(116,12,8,10)
	line(106,12,96,12,10)
	line(116,22,116,32,10)
	line(109,19,102,26,10)
end

function _update()
	counter=counter+1
	if counter%10==0 then
        if sunrise==1 then
            if sky1<95 then sky1=sky1+1
            else sunrise=0
            end
            if skybottom==0 and sky2<44 then sky2=sky2+1 
            else csky3={0xca, 0xac, 10}    
            end
            if sky3<58 then sky3=sky3+1 
            else 
                sky3=-30
                sky2=30
                csky2={0xc7, 0x7c, 7}
                skybottom=1
            end
            if skybottom==0 and sky1>30 then 
                csky1={0x1c, 0xc1, 12}
                csky2={0xce, 0xec, 14}
            end
            if skybottom==1 and sky2<36 then
                sky2=sky2+1
            end
        end
		counter=0 
		mountains=mountains-1
		if mountains<0 then mountains=32 end
	end
    if counter==100 then counter=0 end
	trees=trees-1
	if trees==-32 then trees=32 end
 foreach(flowers_seq,update_flower_pos)
end

function _draw()
	cls(12)
	draw_sky1()
	draw_mountains()
	draw_trees(16,8)
	draw_trees(0,4)
	rectfill(0,90,127,96,4)
	rectfill(0,97,127,127,3)
	rectfill(0,110,127,127,11)
	draw_tracks()
	draw_tracks()
	draw_car(0)
	draw_car(1)
	draw_locomotive(2)
	foreach(flowers_seq,draw_flower)
end

flowers_seq={
	{12,-24,110,2,2,-1,1},
	{12,0,110,2,2,1,1},
	{12,24,115,2,2,-1,-1},
	{12,48,120,2,2,-1,1},
    {12,72,110,2,2,1,-1},
    {12,96,110,2,2,1,-1},
    {12,120,112,2,2,-1,-1},
    {12,144,115,2,2,-1,1}
}

function update_flower_pos(flower)
	flower[2]=flower[2]-3
	if flower[2]==-48 then flower[2]=144 end
end

function draw_flower(flower)
	spr(flower[1],
		flower[2],
		flower[3],
		flower[4],
		flower[5],
		flower[6],
		flower[7])
end

function draw_stars()
	stars={
		31,67,
		105,51,
		108,75,
		22,19,
		3,79,
		22,51,
		26,46,
		37,40,
		78,94,
		50,45,
		96,69,
		72,95,
		61,88,
		1,82,
		64,53,
		88,64,
		72,4,
		77,51,
		46,92,
		102,75,
	}
	for i=1,16,1 do
		pset(stars[i],stars[i+1],10)
	end
end

function draw_mountains()
	rectfill(0,62,127,80,13)
	rectfill(0,80,127,120,1)
	for i=-32,160,32 do
		spr(32,0+i+mountains,48,4,2)
	end
end

function draw_clouds()
	spr(44,0+mountains,0,4,2)
end

lvl1='0b0111111111011111'
lvl2='0b0101111101011111'
lvl3='0b0101101101011111'
lvl4='0b0111101001011010'

function draw_sky1()
    cls(1)
	draw_stars()
    draw_sky_layer(86, csky1[1], csky1[2], csky1[3], sky1)
    draw_sky_layer(100, csky2[1], csky2[2], csky2[3], sky2)
    draw_sky_layer(114, csky3[1], csky3[2], csky3[3], sky3)
end

function draw_sky_layer(baseh, ccombo1, ccombo2, clayer, slayer)
	fillp(lvl1)
    rectfill(0,baseh-16-slayer,128,baseh-14-slayer,ccombo1)
	fillp(lvl1)
    rectfill(0,baseh-14-slayer,128,baseh-12-slayer,ccombo1)
    fillp(lvl2)
    rectfill(0,baseh-12-slayer,128,baseh-10-slayer,ccombo1) 
    fillp(lvl3)
    rectfill(0,baseh-10-slayer,128,baseh-8-slayer,ccombo1)
    fillp(lvl4)
    rectfill(0,baseh-8-slayer,128,baseh-6-slayer,ccombo1)
    fillp(lvl3)
    rectfill(0,baseh-6-slayer,128,baseh-4-slayer,ccombo2)
    fillp(lvl2)
    rectfill(0,baseh-4-slayer,128,baseh-2-slayer,ccombo2)
    fillp(lvl1)
    rectfill(0,baseh-2-slayer,128,baseh-slayer,ccombo2)
    fillp()
    rectfill(0,baseh-slayer,128,128,clayer)
end