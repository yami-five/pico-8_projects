t=0;
function rasterize(y,x0,x1,c)
	if (y<0 or y>127) return
	local q,n
	n=(flr(y)%2)*0.5
	x0+=n;
	x1+=n;
	if (x1<x0) q=x0 x0=x1 x1=q
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
	return c*x-s*y, s*x+c*y
end


function _update()
	t+=1
end

function _draw()
	cls();
	local r,qt;
	qt=t*0.01;
	
	-- model
	v={
		0.5, 0, -0.5, -- 0
		0.5, 0, -0.5, -- 1
		0.5, 0, 0.5, -- 2
		-0.5, 0, 0.5, -- 3
		0, 0, 1, -- 3
	};
	faces=4;
	f={
		0,1,4,
		1,2,4,
		2,3,4,
		1,2,3,
	}
	-- transform
	vt={};
	for i=1,2*4,2 do
		local x,y,z;
		-- read
		x=v[i];
		y=v[i+1];
		z=v[i+2];
		 	-- process
		y,z=rotate(y,z,qt*0.9);
		x,z=rotate(x,z,qt*0.3);
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
	for i=1,faces*3,3 do
		local a,b,c;
		a=f[i];
		b=f[i+1];
		c=f[i+2];
		cc=colors[(i+2)/3]
		tric(
			vt[a*2+1],
			vt[a*2+2],
			vt[b*2+1],
			vt[b*2+2],
			vt[c*2+1],
			vt[c*2+2],
			cc)
	end
end