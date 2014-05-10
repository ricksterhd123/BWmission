startPos = {
	x = -693.8955078125,
	y =  966.255859375,
	z =  9,
	car = {
		whitelist = {
			475,	-- Sabre (ID: 475);
		},
		pos = {-703.3359375, 966.048828125, 12.40469455719}
	},
}

finish = {
	-- x,y,z,maxtime,mincash
	{0,0,3,120000,10000}
}

-- Returns random position
function getRandomEndPosition()
	math.randomseed(getTickCount())
	local pos = endPos[math.random(#endPos)]

	local x, y, z, maxTime, money = pos[1], pos[2], pos[3], pos[4], pos[5]

	return x, y, z, maxTime, money
end

function getRandomCarID()
	math.randomseed(getTickCount())
	local ID = startPos.car.whitelist[math.random(#startPos.car.whitelist)]

	return ID
end
