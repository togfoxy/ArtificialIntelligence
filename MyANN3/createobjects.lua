
local createobjects = {}


function createobjects.CreateMouse()

	local myMouse = {}
	myMouse.x = love.math.random(0, gintScreenWidth)
	myMouse.y = love.math.random(0, gintScreenHeight)
	myMouse.targetx = 0
	myMouse.targety = 0
	myMouse.currentdecision = 0
	myMouse.currentdecisiontimer = 0		-- seconds
	myMouse.actiontimer = 0				-- seconds
	myMouse.score = 0
	myMouse.age = 0
	myMouse.output1 = 0
	myMouse.output2 = 0
	myMouse.output3 = 0
	
	-- random genome
	if #garrParent1 == 0 or #garrParent2 == 0 then
		myMouse.weights = {}
		for i = 1, 15 do
			local randombias = love.math.random(0,10) / 10
			table.insert(myMouse.weights, randombias)
			
		end
		table.insert(myMouse.weights, 0) 		-- score
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
		
		myMouse.weights = cf.deepcopy(newsequence)
		myMouse.weights[16] = 0
	end
	
	myMouse.weights[16] = 0		-- score
	myMouse.score = 0
	table.insert(garrMouse, myMouse)
	
-- print(inspect(myMouse.weights))

	assert(myMouse.score == 0)
	assert(myMouse.weights[16] == 0)

end

function createobjects.CreateCheese()

	local myCheese = {}
	myCheese.x = love.math.random(0, gintScreenWidth)
	myCheese.y = love.math.random(0, gintScreenHeight)
	
	table.insert(garrCheese, myCheese)


end

function createobjects.CreateCat()

	local myCat = {}
	myCat.x = love.math.random(0, gintScreenWidth)
	myCat.y = love.math.random(0, gintScreenHeight)
	myCat.target = nil 				-- this is an actual mouse
	myCat.targetx = 0
	myCat.targety = 0
	myCat.currentdecision = 0		-- seconds
	myCat.currentdecisiontimer = 0
	myCat.actiontimer = 0				-- seconds	
	
	table.insert(garrCat, myCat)
	
	

end

return createobjects