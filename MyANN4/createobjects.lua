local createobjects = {}

function createobjects.CreateAgent()
	-- initialises agents and bots
	-- Agents (non-physics)
	bot = {}
	bot.decisiontimer = 0
	bot.age = 0
	bot.dead = false
	bot.weights = {}
	bot.output1 = 0
	bot.output2 = 0
	bot.output3 = 0
	bot.correctdecision = false
	
	-- random genome
	if #garrParent1 == 0 or #garrParent2 == 0 then
		bot.weights = {}
		for i = 1, 15 do
			local randombias = love.math.random(0,10) / 10
			table.insert(bot.weights, randombias)
			
		end
		table.insert(bot.weights, 0) 		-- score
	else
		-- take a mix of both parents
		local newsequence = {}
		for i = 1, 15, 2 do
			newsequence[i] = garrParent1[i]
			newsequence[i+1] = garrParent2[i+1]
			
		end
		newsequence[16] = 0		-- score
		
		-- now randomise
		for i = 1,8 do
			local rndgene = love.math.random(1,15)
			local randombias = love.math.random(0,10) / 10
			newsequence[rndgene] = randombias
		end
		newsequence[16] = 0		-- score
		
		bot.weights = cf.deepcopy(newsequence)
		bot.weights[16] = 0
	end	
	
	

	-- physics stuff
	x = love.math.random(gintLeftBorder + 20, gintRightBorder - 20)
	y = love.math.random(gintTopBorder + 20, gintBottomBorder - 20)
	bot.body = love.physics.newBody(world,x,y,"dynamic")
	bot.body:setLinearDamping(0.5)
	bot.body:setMass(love.math.random(60,120))
	bot.shape = love.physics.newCircleShape(gintAgentRadius)
	bot.fixture = love.physics.newFixture(bot.body, bot.shape, 1)		-- the 1 is the density
	bot.fixture:setRestitution(1.5)
	bot.fixture:setSensor(true)	-- false = bounce
	bot.fixture:setUserData(bot.ID)
	
	bot.linearvelocityx = love.math.random(-50, 50)
	bot.linearvelocityy = love.math.random(-50, 50)
	
	bot.body:setLinearVelocity(bot.linearvelocityx, bot.linearvelocityy)
	
	table.insert(Agents, bot)

end

return createobjects