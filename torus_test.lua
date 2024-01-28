pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
t1=0
texture_size=2
texture1='8e8e'
texture2='3d3d'
texture3='bcbc'
texture4='1212'
texture5='f4f4'
texture6='1e1e'
-- texture1='0123456789abcdef'
--rysuje linie od x1y do x2y
	--linia jest zawsze pozioma
    function rasterize(y, x0, x1, uv0, uv1, uv2, inv,p0,p1,p2,texture)
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
        for x = x0, x1, 1 do
            Ba=((p1[2]-p2[2])*(x*2-p2[1])+(p2[1]-p1[1])*(y-p2[2]))*inv
            Bb=((p2[2]-p0[2])*(x*2-p2[1])+(p0[1]-p2[1])*(y-p2[2]))*inv
            Bc=1-Ba-Bb
            uv_x=Ba*uv0[1]+Bb*uv1[1]+Bc*uv2[1]
            uv_y=Ba*uv0[2]+Bb*uv1[2]+Bc*uv2[2]
            uv_x = max(0, min(1, uv_x))
            uv_x=flr(uv_x*texture_size)+1
            uv_y = max(0, min(1, uv_y))
            uv_y=flr(uv_y*texture_size)+1
            texture1_index=flr((uv_y-1) *texture_size + uv_x)
            texture1_index = max(0, min(256, texture1_index))
            local texture1_color1 = sub(texture,texture1_index,texture1_index)
            -- Ba=((p1[2]-p2[2])*((x*2+1)-p2[1])+(p2[1]-p1[1])*(y-p2[2]))*inv
            -- Bb=((p2[2]-p0[2])*((x*2+1)-p2[1])+(p0[1]-p2[1])*(y-p2[2]))*inv
            -- Bc=1-Ba-Bb
            -- uv_x=Ba*uv0[1]+Bb*uv1[1]+Bc*uv2[1]
            -- uv_y=Ba*uv0[2]+Bb*uv1[2]+Bc*uv2[2]
            -- uv_x = max(0, min(1, uv_x))
            -- uv_x=flr(uv_x*4)+1
            -- uv_y = max(0, min(1, uv_y))
            -- uv_y=flr(uv_y*4)+1
            -- texture1_index=flr((uv_y-1) *4 + uv_x)
            -- texture1_index = max(0, min(16, texture1_index))
            -- local texture1_color2 = sub(texture1,texture1_index,texture1_index)
            memset(0x6000 + y * 64 + x, "0x"..texture1_color1..texture1_color1, 2)
            -- p ,. rinth("uv_x: " .. uv_x .. " uv_y: " .. uv_y .. " color: " .. texture1_color1 ,'test.txt',false)
            -- printh("Ba: " .. Ba .. " Bb: " .. Bb .. " Bc: " .. Bc,'test.txt',false)
            -- printh("uv0[1]: " .. uv0[1] .. " uv0[2]: " .. uv0[2] .. " uv1[1]: " .. uv1[1] .. " p1[2]: " .. uv1[2] .. " uv2[1]: " .. uv2[1] .. " uv2[2]: " .. uv2[2],'test.txt',false)
            -- printh("x: " .. x .. " y: " .. y,'test.txt',false)
            -- printh("p0[1]: " .. p0[1] .. " p0[2]:" .. p0[2],'test.txt',false)
            -- printh("p1[1]: " .. p1[1] .. " p1[2]:" .. p1[2],'test.txt',false)
            -- printh("p2[1]: " .. p2[1] .. " p2[2]:" .. p2[2],'test.txt',false)
            -- printh("x0: " .. x0 .. " x1:" .. x1,'test.txt',false)
        end
    end
    
    function tri(x0,y0,x1,y1,x2,y2,uv0,uv1,uv2,texture)
        local x,xx,y,q,q2,uv;
        if (y0>y1) y=y0;y0=y1;y1=y;x=x0;x0=x1;x1=x;uv=uv0;uv0=uv1;uv1=uv;
        if (y0>y2) y=y0;y0=y2;y2=y;x=x0;x0=x2;x2=x;uv=uv0;uv0=uv2;uv2=uv;
        if (y1>y2) y=y1;y1=y2;y2=y;x=x1;x1=x2;x2=x;uv=uv1;uv1=uv2;uv2=uv;
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
        inv=1/((y1-y2)*(x0-x2)+(x2-x1)*(y0-y2))
        if flr(y0)<flr(y1) then
            q=0;
            xd=1; if(x1<x0) xd=-1
            while y<=y1 do
                rasterize(y,x,xx,uv0,uv1,uv2,inv,{x0,y0},{x1,y1},{x2,y2},texture);
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
                rasterize(y,x,xx,uv0,uv1,uv2,inv,{x0,y0},{x1,y1},{x2,y2},texture);
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
    
    function tric(a,b,c,d,e,f,uv0,uv1,uv2,texture)
        local e1x,e1y,e2x,e2y,xpr;
        e1x=c-a;
        e1y=d-b;
        e2x=e-a;
        e2y=f-b;
        xpr=e1x*e2y-e1y*e2x;
        if (xpr<0) return;
        return tri(a,b,c,d,e,f,uv0,uv1,uv2,texture);
    end
    
    
    function rotate(x,y,a)
        local c=cos(a) s=sin(a)
        if t1>500 then return c*x+s*y, s*x-c*y
        else return c*x-s*y, s*x+c*y end
    end

function update_cube()
	t1+=1
end
function draw_cube()
	cls()
	-- stripes
	    
	local r,qt;
	qt=t1*0.01;
	
	-- model
    vertices=48
	v={
        --1st ring
		0.6, 0, 0.3, -- 0
		0.4, -0.4, 0.3, -- 1
		0, -0.6, 0.3, -- 2
		-0.4, -0.4, 0.3, -- 3
		-0.6, 0, 0.3, -- 4
		-0.4, 0.4, 0.3, -- 5
		0, 0.6, 0.3, -- 6
		0.4, 0.4, 0.3, -- 7
        --2nd ring
		1, 0, 0.3, -- 8
		0.7, -0.7, 0.3, -- 9
		0, -0.9, 0.3, -- 10
		-0.7, -0.7, 0.3, -- 11
		-0.9, 0, 0.3, -- 12
		-0.7, 0.7, 0.3, -- 13
		0, 1, 0.3, -- 14
		0.7, 0.7, 0.3, -- 15
        --3rd ring
		1, 0, 0, -- 16
		0.8, -0.8, 0, -- 17
		0, -1, 0, -- 18
		-0.8, -0.8, 0, -- 19
		-1, 0, 0, -- 20
		-0.8, 0.8, 0, -- 21
		0, 1, 0, -- 22
		0.8, 0.8, 0, -- 23
        --4th ring
		1, 0, -0.3, -- 24
		0.7, -0.7, -0.3, -- 25
		0, -1, -0.3, -- 26
		-0.7, -0.7, -0.3, -- 27
		-1, 0, -0.3, -- 28
		-0.7, 0.7, -0.3, -- 29
		0, 1, -0.3, -- 30
		0.7, 0.7, -0.3, -- 31
        --5th ring
		0.6, 0, -0.3, -- 32
		0.4, -0.4, -0.3, -- 33
		0, -0.6, -0.3, -- 34
		-0.4, -0.4, -0.3, -- 35
		-0.6, 0, -0.3, -- 36
		-0.4, 0.4, -0.3, -- 37
		0, 0.6, -0.3, -- 38
		0.4, 0.4, -0.3, -- 39
        --6th ring
		0.4, 0, 0, -- 40
		0.3, -0.3, 0, -- 41
		0, -0.4, 0, -- 42
		-0.3, -0.3, 0, -- 43
		-0.4, 0, 0, -- 44
		-0.3, 0.3, 0, -- 45
		0, 0.4, 0, -- 46
		0.3, 0.3, 0, -- 47
	};
	faces=96;
	f={
        --5th ring
        40,33,32,
        41,33,42,
        41,34,33,
        42,34,41,
        42,35,34,
        43,35,42,
        43,36,35,
        44,36,43,
        44,37,36,
        45,37,44,
        45,38,37,
        46,38,45,
        46,39,38,
        47,39,46,
        47,32,39,
        40,32,47,
        --6th ring
        0,41,40,
        1,41,0,
        1,42,41,
        2,41,1,
        2,43,42,
        3,43,2,
        3,44,43,
        4,44,3,
        4,45,44,
        5,45,4,
        5,46,45,
        6,46,5,
        6,47,46,
        7,47,6,
        7,40,47,
        0,40,7,
        --1st ring
		8,1,0,
        9,1,8,
        2,1,9,
        10,2,9,
        10,3,2,
        11,3,10,
        11,4,3,
        12,4,11,
        12,5,4,
        13,5,12,
        13,6,5,
        14,6,13,
        14,7,6,
        15,7,14,
        15,0,7,
        8,0,15,
        --2nd ring
        16,9,8,
        17,9,16,
        17,10,9,
        18,10,17,
        18,11,10,
        19,11,18,
        19,12,11,
        20,12,19,
        20,13,12,
        21,13,20,
        21,14,13,
        22,14,21,
        22,15,14,
        23,15,22,
        23,8,15,
        16,8,23,
        --3rd ring
        24,17,16,
        25,17,24,
        25,18,17,
        26,18,25,
        26,19,18,
        27,19,26,
        27,20,19,
        28,20,27,
        28,21,20,
        29,21,28,
        29,22,21,
        30,22,29,
        30,23,22,
        31,23,30,
        31,16,23,
        24,16,31,
        --4th ring
        32,25,24,
        33,25,32,
        33,26,25,
        34,25,33,
        34,27,26,
        35,27,34,
        35,28,27,
        36,28,35,
        36,29,28,
        37,29,36,
        37,30,29,
        38,30,37,
        38,31,30,
        39,31,38,
        39,24,31,
        32,24,39,
	}
	-- transform
	vt={};
	for i=1,3*vertices,3 do
		local x,y,z;
		-- read
		x=v[i]*2;
		y=v[i+1]*2;
		z=v[i+2]*2;
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
	for i=1,3*faces,3 do
		--petla wyciaga kolejne sciany z listy
		local a,b,c;
		a=f[i];
		b=f[i+1];
		c=f[i+2];
--sciana dzielona jest na dwa trojkaty
--1 abc
--2 bcd
--tric dostaje liste wierzcholkow
--w formie wspolrzednych xy
		--cc=colors[(i+3)/4]
        texture=texture1
        if(i<48) then texture=texture1
        elseif(i>=48 and i<96) then texture=texture2
        elseif(i>=96 and i<144) then texture=texture3
        elseif(i>=144 and i<192) then texture=texture4
        elseif(i>=192 and i<240) then texture=texture5
        else texture=texture6 end
		tric(
			vt[a*3+1],
			vt[a*3+2],
			vt[b*3+1],
			vt[b*3+2],
			vt[c*3+1],
			vt[c*3+2],
			{0,0},{1,0},{0,1},texture)
		-- tric(
		-- 	vt[c*3+1],
		-- 	vt[c*3+2],
		-- 	vt[b*3+1],
		-- 	vt[b*3+2],
		-- 	vt[d*3+1],
		-- 	vt[d*3+2],
		-- 	{0,1},{1,0},{1,1})
	end
end

function _update()
	update_cube()
end

function _draw()
    draw_cube()
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
