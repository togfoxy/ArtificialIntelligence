
local createobjects = {}


function createobjects.CreateLander()

	local Lander = {}
    Lander.x = love.math.random((gintScreenWidth * 0.1),(gintScreenWidth * 0.9))
    Lander.y = gintScreenHeight/2
	Lander.angle = 270 -- love.math.random(0,359)
	Lander.vx = 0
	Lander.vy = 0
	Lander.speed = 1 --love.math.random(1,10) / 10
	Lander.engineOn = false
	Lander.imgEngine = love.graphics.newImage("/images/engine.png")
	Lander.img = love.graphics.newImage("/images/ship.png")
	Lander.engineOn = false
	
	Lander.bolGameOver = false
	Lander.score = 999
	Lander.age = 0
	
	Lander.output1 = 0
	Lander.output2 = 0
	Lander.output3 = 0
	
	Lander.weights = {}

	--local randombias = love.math.random(0,10) / 10
	--table.insert(Lander.weights, randombias)

	-- take a mix of both parents
	local newsequence = {}
	
	if love.math.random(2,3) == 2 then
		for i = 1, 29, 2 do
			newsequence[i] = garrParent1[i]
			newsequence[i + 1] = garrParent2[i + 1]
		end
	else
		for i = 2, 28, 2 do
			newsequence[i] = garrParent1[i]
			newsequence[i + 1] = garrParent2[i + 1]
		end
		newsequence[1] = garrParent1[1]
		newsequence[30] = garrParent2[30]
	end
	
-- print(inspect(newsequence))
	
	-- now randomise
	local numtorandomise = (1 - (gintRoundWin / gintNumBots)) * 30
	numtorandomise = cf.round(numtorandomise,0)
	
	if numtorandomise <= 1 then numtorandomise = 1 end
	if numtorandomise > 4 then numtorandomise = 4 end
	
	if gintRoundWin < 33 then numtorandomise = 3 end
	if gintRoundWin >= 33 and gintRoundWin <= 66 then numtorandomise = 2 end
	if gintRoundWin > 66 then numtorandomise = 1 end
	
	numtorandomise = 1

	for i = 1,numtorandomise do
		local rndgene = love.math.random(1,30)
		
		--if numtorandomise <= 10 then
			local randombias = love.math.random(0,5)
			if randombias == 0 then
				-- big change
				newsequence[rndgene] = love.math.random(0,10) / 10
			else
				-- incremental change
				if love.math.random(0,l) == 0 then
					newsequence[rndgene] = newsequence[rndgene] - 0.1
				else
					newsequence[rndgene] = newsequence[rndgene] + 0.1
				end
			end
			
		--else
		--	local randombias = love.math.random(0,10) / 10
		--	newsequence[rndgene] = randombias
		--end
	end
	
	Lander.weights = cf.deepcopy(newsequence)
	

	table.insert(Lander.weights, 999) 		-- score	
	
	table.insert(garrLanders, Lander)


end

return createobjects









