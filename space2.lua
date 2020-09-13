function title_screen()
	spr(64,16,10,12,3)
	spr(128,16,34,12,3)
	print('press z to start',32,100,11)
	//print('yami productions',0,123,11)
end

function start_game()
	palt(0, true)
	for i=0,128,1 do
		stars1[i]={i,flr(rnd(127)),7}
		stars2[i]={i,flr(rnd(127)),5}
	end
	gen_asteroid()
	restart()
end