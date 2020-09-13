char=0

function print_text()
	text=''
	if(text_num==1)then
		text="the year is 2027.\nit is time of great innovation\nand technological advancement.\npoland is still using coal\nto produce electricity.\nall coal mines on earth are\nempty.\nyour job is collecting coal in\nshlo\'nsk system.\nbut beware,goornycs will try to\nkill you!\nto collect coal just shoot to\nasteroids and ships.\nuse arrows and z to shoot.\nthose blue-green circles which\ncan drop from enemies are\nupgrades for you lazors.\nyour ship has shields.\nthey need few seconds to\nregenerate."
	elseif(text_num==2)then
		text="vuy'eck,grand champion of\nthe goornycs wants to\ndestroy your ship\nand take all your coal.\nyou can't allow to this!\nfight with him and win!"
	elseif(text_num==3)then
		text="you win.you've got so much coal.\nit\'s time to come home."	
	else
		text="yami, you suck! something goes wrong! they shouldn\'t see this text!"
	end
	print(sub(text,0,char),2,1,11)
	if(char<#text)then
		char=char+1
	end
	if(s_counter<10)then
		s_counter=s_counter+1
	end
end