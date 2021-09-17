local randomfunctions = {}

function randomfunctions.AddScreen(strNewScreen)
	table.insert(garrCurrentScreen, strNewScreen)
end

function randomfunctions.RemoveScreen()
	table.remove(garrCurrentScreen)
	if #garrCurrentScreen < 1 then
		love.event.quit()       --! this doesn't dothe same as the EXIT button
	end
end

function randomfunctions.GetNewDirection(bot)
-- bot is an object

	bot.linearvelocityx = love.math.random(-50, 50)
	bot.linearvelocityy = love.math.random(-50, 50)
	
	bot.body:setLinearVelocity(bot.linearvelocityx, bot.linearvelocityy)

end

local function UpdateParents(bot)
-- bot is an object

	if bot.age > garrParent1[16] then
		-- replace parent1 and bump p1 down
		garrParent2 = cf.deepcopy(garrParent1)
		garrParent1 = cf.deepcopy(bot.weights)
		garrParent1[16] = bot.age
	elseif bot.age > garrParent2[16] then
		-- replace parent2
		garrParent2 = cf.deepcopy(bot.weights)
		garrParent2[16] = bot.age
	end

end





function randomfunctions.KillGeneration()

	for k,v in pairs(Agents) do
		UpdateParents(v)
		
		table.remove(Agents, k)
	end

end




function randomfunctions.CheckDie(bot)
-- bot is an object

	local botx = bot.body:getX()		-- x axis
	local boty = bot.body:getY()		-- y axis
	
--print(gintBottomBorder, boty)
	
	if botx < gintLeftBorder or botx > gintRightBorder or boty < gintTopBorder or boty > gintBottomBorder then
		-- dead
-- print("alpha")
		bot.dead = true
		
		if bot.age > gintHighScore then
			gintHighScore = bot.age
		end
		
		UpdateParents(bot)
	
	end
	

	
end

return randomfunctions