x=127
text="003020015000"
function _update()
    x=x-1
    if x<0 then x=127 end
end

function _draw()
    cls()
    for i=0,3,1 do
        spr(tonum(sub(text,i3,i3+3)),x+8i,63+flr(cos(x/50)10))
    end
end