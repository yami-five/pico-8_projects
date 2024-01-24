w=16
h=16
t=0
fire={}
buffer={}
p={7,10,9,8,4,2,1}

function _init()
	for y=1,h,1 do
		add(fire,{})
		for x=1,w,1 do
			add(fire[y],0)
		end
	end
	buffer=fire
	//memset(0x8000,0x00,0x2000)
end

function hex(value)
	result=tostr(value,true)
	result=sub(result,6,6)
	return result
end

function _update()
 t+=1
end

function _draw()
	cls()
	draw_fire()
end

function draw_fire()
	if t%10==0 then
		for x=1,w,1 do 
			fire[x][h] = abs(32768+rnd(128))%7+1
		end
		for y=1,h,1 do	
			for x=1,w,1 do
				fire[x][y]=
						(fire[(x+w)%w+1][(y+1)%h+1]
					+fire[x%w+1][(y+1)%h+1]
					+fire[(x+1)%w+1][(y+1)%h+1]
					+fire[x%w+1][(y+2)%h+1])%7
			end
		end
	end
	for y=1,h,1 do
		for x=1,w,1 do
			buffer[x][y]=p[fire[x][y]]
			pset(x+56,y+56,buffer[x][y])
		end
	end
end