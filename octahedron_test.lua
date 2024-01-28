t1=0
texture='677765677656777677776566665677777777655ee55677777776555ee55567776665555ee55556665555555665555555665555677655556676eee6e77e6eee6776eee6eeee6eee676655556ee655556655555556655555556665555ee55556667776555ee55567777777655ee556777777776566665677776777656776567776'
-- texture='0123456789abcdef'
--rysuje linie od x1y do x2y
	--linia jest zawsze pozioma
    function rasterize(y, x0, x1, uv0, uv1, uv2, inv,p0,p1,p2)
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
            uv_x=flr(uv_x*16)+1
            uv_y = max(0, min(1, uv_y))
            uv_y=flr(uv_y*16)+1
            texture_index=flr((uv_y-1) *16 + uv_x)
            texture_index = max(0, min(256, texture_index))
            local texture_color1 = sub(texture,texture_index,texture_index)
            -- Ba=((p1[2]-p2[2])*((x*2+1)-p2[1])+(p2[1]-p1[1])*(y-p2[2]))*inv
            -- Bb=((p2[2]-p0[2])*((x*2+1)-p2[1])+(p0[1]-p2[1])*(y-p2[2]))*inv
            -- Bc=1-Ba-Bb
            -- uv_x=Ba*uv0[1]+Bb*uv1[1]+Bc*uv2[1]
            -- uv_y=Ba*uv0[2]+Bb*uv1[2]+Bc*uv2[2]
            -- uv_x = max(0, min(1, uv_x))
            -- uv_x=flr(uv_x*4)+1
            -- uv_y = max(0, min(1, uv_y))
            -- uv_y=flr(uv_y*4)+1
            -- texture_index=flr((uv_y-1) *4 + uv_x)
            -- texture_index = max(0, min(16, texture_index))
            -- local texture_color2 = sub(texture,texture_index,texture_index)
            memset(0x6000 + y * 64 + x, "0x"..texture_color1..texture_color1, 2)
            -- p ,. rinth("uv_x: " .. uv_x .. " uv_y: " .. uv_y .. " color: " .. texture_color1 ,'test.txt',false)
            -- printh("Ba: " .. Ba .. " Bb: " .. Bb .. " Bc: " .. Bc,'test.txt',false)
            -- printh("uv0[1]: " .. uv0[1] .. " uv0[2]: " .. uv0[2] .. " uv1[1]: " .. uv1[1] .. " p1[2]: " .. uv1[2] .. " uv2[1]: " .. uv2[1] .. " uv2[2]: " .. uv2[2],'test.txt',false)
            -- printh("x: " .. x .. " y: " .. y,'test.txt',false)
            -- printh("p0[1]: " .. p0[1] .. " p0[2]:" .. p0[2],'test.txt',false)
            -- printh("p1[1]: " .. p1[1] .. " p1[2]:" .. p1[2],'test.txt',false)
            -- printh("p2[1]: " .. p2[1] .. " p2[2]:" .. p2[2],'test.txt',false)
            -- printh("x0: " .. x0 .. " x1:" .. x1,'test.txt',false)
        end
    end
    
    function tri(x0,y0,x1,y1,x2,y2,uv0,uv1,uv2)
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
                rasterize(y,x,xx,uv0,uv1,uv2,inv,{x0,y0},{x1,y1},{x2,y2});
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
                rasterize(y,x,xx,uv0,uv1,uv2,inv,{x0,y0},{x1,y1},{x2,y2});
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
    
    function tric(a,b,c,d,e,f,uv0,uv1,uv2)
        local e1x,e1y,e2x,e2y,xpr;
        e1x=c-a;
        e1y=d-b;
        e2x=e-a;
        e2y=f-b;
        xpr=e1x*e2y-e1y*e2x;
        if (xpr<0) return;
        return tri(a,b,c,d,e,f,uv0,uv1,uv2);
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
    vertices=6
	v={
		0, 0, 2, -- 0
		-2, 0, 0, -- 1
		0, -2, 0, -- 2
		2, 0, 0, -- 3
		0, 2, 0, -- 4
		0, 0, -2 -- 5
	};
	faces=8;
	f={
		0,1,2,
		3,0,2,
		0,3,4,
		1,0,4,
        5,1,4,
        3,5,4,
        5,3,2,
        1,5,2
	}
	-- transform
	vt={};
	for i=1,3*vertices,3 do
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
		tric(
			vt[a*3+1],
			vt[a*3+2],
			vt[b*3+1],
			vt[b*3+2],
			vt[c*3+1],
			vt[c*3+2],
			{0.98,0.86},{0.18,0.86},{0.5,0.26})
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