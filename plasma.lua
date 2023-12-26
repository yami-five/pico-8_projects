w=128
h=128
t=0

function hex(value)
	result=tostr(value,true)
	result=sub(result,6,6)
	return result
end

function _update()
 t+=0.02
 //if t>16 then t=0 end
end

function _draw()
	cls()
	draw_plasma()
end

function draw_plasma()
	for y=0,127,1 do
		for x=0,127,1 do
			c=(
				16+(16*sin(x/64-t))+
				16+(16*sin(y/128-t))+
				16+(16*sin((x%2+y%2)/64-t))+
				16+(16*sin(sqrt(x*x+y*y-t)/128))
			)/2
			pset(x,y,(c+t)%6+8)
		end
	end
end