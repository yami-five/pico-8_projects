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
station=0
begin=true
s=-200
tree_sprite=72
cloud_sprite=160
t1=0
cloud_speed=0.2
clouds={
	44,21,
	85,13,
	99,27,
	23,28,
	4,13,
	114,7,
	59,22,
	20,25,
	10,24,
	0,4,
	39,10,
	108,25,
	108,14,
	54,6,
	68,17,
	79,18,
	33,30,
	76,21,
	71,24,
	102,23,
}
fade={
	0xa5a5.8,
	0x0a0a.8,
	0x2080.8,
	0x0200.8,
	0x0000.8,
}
patterns={
	0xf7fd.8,
	0xfbfe.8,
	0xfdf7.8,
	0xfefb.8
}
part=1

function change_height()
	if counter%50==0 then
		if height==1 then height=0
		else height=1
		end
	end
end

function draw_locomotive(a)
	spr(128,-20+48*a+s,80+height,2,2)
	change_height()
	spr(130,-4+48*a+s,80+height,2,2)
	change_height()
	spr(132,12+48*a+s,80+height,2,2)
	change_height()
end

function draw_car(a)
	spr(0,-20+48*a+s,80+height,2,2)
	change_height()
	spr(2,-4+48*a+s,80+height,2,2)
	change_height()
	spr(0,12+48*a+s,80+height,2,2,-1)
	change_height()
end

function draw_tracks()
    for i=0,128,4 do
        line(0+i+tracks,92,0+i+tracks,97,5)
    end
    line(0,92,127,92,127,6)
    line(0,97,127,97,127,6)
    if begin==false then
        if counter%2==0 then
            tracks=tracks-1
        end
        if tracks==0 then tracks=5 end
    end
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

function draw_station()
	spr(134,5+station,76,7,2)
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
	spr(141,110,5,2,2)
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

function change_tree_sprite()
	if t1==500 then tree_sprite=68
	elseif t1==625 then tree_sprite=64 
	elseif t1==800 then tree_sprite=4
	end
end

function change_cloud_sprite()
	if t1==500 then cloud_sprite=162
	elseif t1==700 then cloud_sprite=164
	elseif t1==900 then cloud_sprite=166
	end
end

function draw_clouds()
	for i=1,21,2 do
		spr(cloud_sprite,flr(clouds[i]),clouds[i+1],2,2)
	end
end

function move_clouds()
	for i=1,21,2 do
		clouds[i]-=cloud_speed
		if clouds[i]<-16 then clouds[i]=127 end
	end
end

function update_train()
	counter=counter+1
	move_clouds()
    if begin==false then
		cloud_speed=2
		change_tree_sprite()
        if counter%10==0 then
            if sunrise==1 then
                if sky1<95 then sky1=sky1+1
                else sunrise=0
                end
                if skybottom==0 and sky2<44 then sky2=sky2+1 
                else csky3={0xca, 0xac, 10}    
                end
                if sky3<58 then 
					sky3=sky3+1 
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
    	if station>-100 then station-=1 end
    	foreach(flowers_seq,update_flower_pos)
    elseif begin==true and counter==300 then
        begin=false
        counter=0
	elseif begin==true and counter<250 and counter>50 then
		s+=1
	end
end

function draw_train()
	fillp()
	cls(12)
	draw_sky1()
	draw_mountains()
	draw_trees(16,8)
	draw_trees(0,tree_sprite)
	rectfill(0,90,127,96,4)
	rectfill(0,97,127,127,3)
	rectfill(0,110,127,127,11)
    draw_station()
	draw_tracks()
	draw_car(0)
	draw_car(1)
	draw_locomotive(2)
	foreach(flowers_seq,draw_flower)
	change_tree_sprite()
	change_cloud_sprite()
	draw_clouds()
	-- print(t1)
	if t1>1500 then 
		fillp(fade[flr((t1-1500)*0.05)+1]) 
		rectfill(0,0,127,127,0)
	end
    if t1==150 then sfx(8) end
    if t1==300 then 
        sfx(6,1) 
        sfx(7,2)
    end
end

t2=0
ts=0.00

--rysuje linie od x1y do x2y
	--linia jest zawsze pozioma
    function rasterize(y,x0,x1,c)
        if (y<0 or y>127) return
        local q,n
        n=(flr(y)%2)*0.5
        x0+=n;
        x1+=n;
        --x0 musi byc mniejsze, bo od niego rysowania jest linia
        if (x1<x0) q=x0 x0=x1 x1=q
        --srpawdzenie czy linia bylaby narysowana poza ekranem
        if (x1<0 or x0>127) return
        y=flr(y);
        if (x0<0) x0=0
        if (x1>127) x1=127
        x0=flr(x0/2);
        x1=flr(x1/2);
        q=x1-x0;
        memset(0x6000+y*64+x0,c,q)
    end
    
    function tri(x0,y0,x1,y1,x2,y2,c)
        local x,xx,y,q,q2;
        if (y0>y1) y=y0;y0=y1;y1=y;x=x0;x0=x1;x1=x;
        if (y0>y2) y=y0;y0=y2;y2=y;x=x0;x0=x2;x2=x;
        if (y1>y2) y=y1;y1=y2;y2=y;x=x1;x1=x2;x2=x;
        local dx01,dy01,dx02,dy02;
        local xd,xxd;
        if (y2<0 or y0>127) return --clip
        y=y0;
        x=x0;
        xx=x0;
        dx01=x1-x0;
        dy01=y1-y0;
        dy02=y2-y0;
        dx02=x2-x0;
        dx12=x2-x1;
        dy12=y2-y1;
        q2=0;
        xxd=1; if(x2<x0) xxd=-1
        if flr(y0)<flr(y1) then
            q=0;
            xd=1; if(x1<x0) xd=-1
            while y<=y1 do
                rasterize(y,x,xx,c);
                y+=1;
                q+=dx01;
                q2+=dx02;
                while xd*q>=dy01 do
                    q-=xd*dy01
                    x+=xd
                end
                while xxd*q2>=dy02 do
                    q2-=xxd*dy02
                    xx+=xxd
                end
            end
        end
        
        if flr(y1)<flr(y2) then
            q=0;
            x=x1
            xd=1; if (x2<x1) xd=-1
            while y<=y2 and y<128 do
                rasterize(y,x,xx,c);
                y+=1;
                q+=dx12;
                q2+=dx02;
                while xd*q>dy12 do
                    q-=xd*dy12
                    x+=xd
                end
                while xxd*q2>dy02 do
                    q2-=xxd*dy02
                    xx+=xxd
                end
            end
        end
    end
    
    function tric(a,b,c,d,e,f,g)
        local e1x,e1y,e2x,e2y,xpr;
        e1x=c-a;
        e1y=d-b;
        e2x=e-a;
        e2y=f-b;
        xpr=e1x*e2y-e1y*e2x;
        if (xpr<0) return;
        return tri(a,b,c,d,e,f,g);
    end
    
    
    function rotate(x,y,a)
        local c=cos(a) s=sin(a)
        if t1>500 then return c*x+s*y, s*x-c*y
        else return c*x-s*y, s*x+c*y end
    end

function update_cube()
	t1+=1
	t2+=1
	if t2>11 then t2=0 end
	if t1>750 and ts>-0.005 then ts-=0.005
	elseif ts<1.01 then ts+=0.005 end
end
function draw_cube()
	cls()
	-- stripes
	fillp()
	rectfill(0,63,127,127,1)
	for h=0,64,2 do
		fillp()
		for i=0,5,1 do
			line(-6+flr(i/3)+h*2+t2,63,-144+i+h*6+t2*3,120,3)
			line(-144+i+h*6+t2*3,120,-144+i+h*6+t2*3,127,3)
		end
	end
	fillp(patterns[flr(t2/3)+1])
	rectfill(0,120,127,127,0x6)
    
	local r,qt;
	qt=t1*0.01;
	
	-- model
	v={
		-1*ts,-1*ts,-1*ts, -- 0
		 1*ts,-1*ts,-1*ts, -- 1
		-1*ts, 1*ts,-1*ts, -- 2
		 1*ts, 1*ts,-1*ts, -- 3
		-1*ts,-1*ts, 1*ts, -- 4
		 1*ts,-1*ts, 1*ts, -- 5
		-1*ts, 1*ts, 1*ts, -- 6
		 1*ts, 1*ts, 1*ts, -- 7
	};
	faces=8;
	f={
		1,0,5,4,
		2,3,6,7,
		0,1,2,3,
		5,4,7,6,
		0,2,4,6,
		3,1,7,5,
	}
	-- transform
	vt={};
	for i=1,3*8,3 do
		local x,y,z;
		-- read
		x=v[i];
		y=v[i+1];
		z=v[i+2];
		 	-- process
		--rotacja
		y,z=rotate(y,z,qt*0.9);
		x,z=rotate(x,z,qt*0.3);
		--przesuwanie gora dol i na boki
		-- x+=sin(t*0.007); 	
		-- y+=sin(t*0.005);
		--ustawianie wspolrzednych
		z=z+5;
		x=x*96/z+64;
		y=y*96/z+64;
			-- write
		vt[i]=x;
		vt[i+1]=y;
		vt[i+2]=z;
	end
	
	-- material
	colors={
		0xbbbb,
		0x8888,
		0xaaaa,
		0xeeee,
		0xdddd,
		0xcccc,
	}
		-- triangles
	for i=1,faces*3,4 do
		--petla wyciaga kolejne sciany z listy
		local a,b,c,d;
		a=f[i];
		b=f[i+1];
		c=f[i+2];
		d=f[i+3];
--sciana dzielona jest na dwa trojkaty
--1 abc
--2 bcd
--tric dostaje liste wierzcholkow
--w formie wspolrzednych xy
		cc=colors[(i+3)/4]
		tric(
			vt[a*3+1],
			vt[a*3+2],
			vt[b*3+1],
			vt[b*3+2],
			vt[c*3+1],
			vt[c*3+2],
			cc)
		tric(
			vt[c*3+1],
			vt[c*3+2],
			vt[b*3+1],
			vt[b*3+2],
			vt[d*3+1],
			vt[d*3+2],
			cc)
	end
end

function draw_ending()
	cls()
	-- stripes
	fillp()
	rectfill(0,63,127,127,1)
	for h=0,64,2 do
		fillp()
		for i=0,5,1 do
			line(-6+flr(i/3)+h*2+t2,63,-144+i+h*6+t2*3,120,3)
			line(-144+i+h*6+t2*3,120,-144+i+h*6+t2*3,127,3)
		end
	end
	fillp(patterns[flr(t2/3)+1])
	rectfill(0,120,127,127,0x6)
	for i=1,l*6,6 do
		spr(letters[i],flr(letters[i+1]),letters[i+2],letters[i+3],letters[i+4])
	end
	-- print(letters[6])
	-- print(letters[3])
end

function update_ending()
	t2+=1
	if t2>11 then t2=0 end
	for i=1,l*6,6 do
		letters[i+1]-=0.5
		letters[i+2]+=letters[i+5]
		if letters[i+2]<30 then letters[i+5]=1
		elseif letters[i+2]>35 then letters[i+5]=-1
		end
	end	
end

function _update()
	t1+=1
    if part==1 then update_train()
	elseif part==2 then update_cube()
	else update_ending()
    end
	if t1>1640 and part==1 then	
        part=2
        t1=0
        sfx(0,1)
        sfx(0,2)
        music(1,500)
    elseif t1>1200 and part==2 then
		part=3
	end
end

function _draw()
    if part==1 then draw_train() 
	elseif part==2 then draw_cube()
	else draw_ending()
    end
	-- print(t1)
end

l=41
letters={
	211,130,30,1,1,1, --T
	199,138,31,1,1,1, --H
	192,146,32,1,1,1, --A
	205,154,33,1,1,1, --N
	202,162,34,1,1,1, --K
	210,170,35,1,1,1, --S
	220,178,34,1,1,1, -- 
	197,186,33,1,1,1, --F
	206,194,32,1,1,1, --O
	209,202,31,1,1,1, --R
	220,210,30,1,1,1, -- 
	214,218,31,1,1,1, --W
	192,226,32,1,1,1, --A
	211,234,33,1,1,1, --T
	194,242,34,1,1,1, --C
	199,250,35,1,1,1, --H
	200,258,34,1,1,1, --I
	205,266,33,1,1,1, --N
	198,274,32,1,1,1, --G
	219,282,31,1,1,1, --.
	220,290,30,1,1,1, -- 
	216,298,31,1,1,1, --Y
	206,306,32,1,1,1, --O
	212,314,33,1,1,1, --U
	220,322,34,1,1,1, --
	194,330,35,1,1,1, --C
	192,338,34,1,1,1, --A
	205,346,33,1,1,1, --N
	220,354,32,1,1,1, --
	211,362,31,1,1,1, --T
	212,370,30,1,1,1, --U
	209,378,31,1,1,1, --R
	205,386,32,1,1,1, --N
	220,394,33,1,1,1, --
	200,402,34,1,1,1, --I
	211,410,35,1,1,1, --T
	220,418,34,1,1,1, --
	206,426,33,1,1,1, --O
	197,434,32,1,1,1, --F
	197,442,31,1,1,1, --F
	219,450,30,1,1,1, --.
}