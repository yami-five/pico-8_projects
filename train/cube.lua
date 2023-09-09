t1=0
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

t2=0

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
        x0=flr(x0/2+0.5);
        x1=flr(x1/2+0.5);
        q=x1-x0;
        memset(0x0000+y*64+x0,c,q)
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
		-1,-1,-1, -- 0
		 1,-1,-1, -- 1
		-1, 1,-1, -- 2
		 1, 1,-1, -- 3
		-1,-1, 1, -- 4
		 1,-1, 1, -- 5
		-1, 1, 1, -- 6
		 1, 1, 1, -- 7
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
	
 memset(0x0000, 0x00, 0x2000)
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
	cls()
	spr(0,0,0,16,16)
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