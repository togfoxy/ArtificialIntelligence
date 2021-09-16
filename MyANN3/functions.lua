local functions = {}

function functions.AddScreen(strNewScreen)
	table.insert(garrCurrentScreen, strNewScreen)
end

function functions.RemoveScreen()
	table.remove(garrCurrentScreen)
	if #garrCurrentScreen < 1 then
	
		success, message = love.filesystem.write( "tree.txt", inspect(tree))
		if success then
			love.event.quit()       --! this doesn't dothe same as the EXIT button
		end
	end
end

function functions.MoveMouse(dt)

	local speed = 80 * dt
	
	for k,v in ipairs(garrMouse) do
	
		if v.targetx ~= 0 then
	
			if v.targetx > v.x then
				v.x = v.x + speed
			end
			if v.targetx < v.x then
				v.x = v.x - speed
			end
			if v.targety > v.y then
				v.y = v.y + speed
			end
			if v.targety < v.y then
				v.y = v.y - speed
			end
		end
	end


end

function functions.MoveCat(dt)

	local speed = 60 * dt
	
	for k,v in ipairs(garrCat) do
	
		if v.targetx ~= 0 then
	
			if v.targetx > v.x then
				v.x = v.x + speed
			end
			if v.targetx < v.x then
				v.x = v.x - speed
			end
			if v.targety > v.y then
				v.y = v.y + speed
			end
			if v.targety < v.y then
				v.y = v.y - speed
			end
			
			-- check if at destination
			if v.x == v.targetx and v.y == v.targety then
				v.targetx = 0
			end

		end
	end


end

local function UpdateParents(mymouse)
	
	if mymouse.score > garrParent1[16] then
		-- replace parent1 and bump p1 down
		garrParent2 = cf.deepcopy(garrParent1)
		garrParent1 = cf.deepcopy(mymouse.weights)
		garrParent1[16] = mymouse.score
	elseif mymouse.score > garrParent2[16] then
		-- replace parent2
		garrParent2 = cf.deepcopy(mymouse.weights)
		garrParent2[16] = mymouse.score
	end

end

function functions.EatMouse(dt)
-- see if cat is close to mouse

	for k,v in pairs(garrCat) do
		for q,w in pairs(garrMouse) do
			local mousedistance = cf.GetDistance(w.x,w.y,v.x,v.y)
			
			if mousedistance <= mousesize / 2 then
				-- yum

				
				if w.score > gintHighScore then
					gintHighScore = w.score
				end
				
				-- w.weights[16] = w.score				
				
				--! need to see if this mouse performed well
				UpdateParents(w)
				
				w.score = 0
				w.weights[16] = 0
				w.weights = {}
				w = {}
				table.remove(garrMouse,q)
				cobjs.CreateMouse()
				
				v.targetx = 0 		-- makes cat seek a new target
				--table.remove(garrCat, k)
				--cobjs.CreateCat()
				break
			end
		end
	end

end

function functions.EatCheese()
-- see if close to any cheese

	for k,v in ipairs(garrMouse) do
	
		for q,w in ipairs(garrCheese) do
	
			local cheesedistance = cf.GetDistance(w.x,w.y,v.x,v.y)
			
			if cheesedistance <= cheesesize / 2 then
				-- yum
				table.remove(garrCheese, q)
				cobjs.CreateCheese()
				
				v.score = v.score + 1
				v.currentdecision = 0
				v.currentdecisiontimer = 3		-- takes 5 seconds to eat cheese
				
				if k == 1 then print("yum") end
				break
			end

		end
		
	end
end

function functions.AgeMouse()

	for k,v in ipairs(garrMouse) do
		if v.age > 60 then
			-- dead
			-- v.weights[16] = v.score
			if v.score > gintHighScore then
				gintHighScore = v.score
			end		

			UpdateParents(v)
			
			v.score = 0
			v.weights[16] = 0
			v.weights = {}
			v = {}
			table.remove(garrMouse,k)
			cobjs.CreateMouse()
		end	

	end
end

function functions.GetClosestCheeseDistance(mymouse)
-- mymouse is an object
-- returns a distance

	local closestcheese = 0
	local closestdistance = 0
	
	for q,w in ipairs(garrCheese) do
		local cheesedistance = cf.GetDistance(w.x,w.y,mymouse.x,mymouse.y)
		
		if closestdistance == 0 then
			closestdistance = cheesedistance
			closestcheese = q
		elseif cheesedistance < closestdistance then
			closestdistance = cheesedistance
			closestcheese = q
		end
		
		-- closest cheese is now captured in closestcheese
	end

	return closestdistance
end

function functions.GetClosestCatDistance(mymouse)
-- mymouse is an object
-- returns a distance

	local closestcat = 0
	local closestdistance = 0
	
	for q,w in ipairs(garrCat) do
	
		assert(mymouse.x ~= nil)
		assert(mymouse.y ~= nil)
	
		local catdistance = cf.GetDistance(w.x,w.y,mymouse.x,mymouse.y)
		
		assert(catdistance ~= nil and catdistance > 0)
		
		if closestdistance == 0 then
			closestdistance = catdistance
			closestcat = q
		elseif catdistance < closestdistance then
			closestdistance = catdistance
			closestcat = q
		end
	end
	
	return closestdistance
					
end

function functions.SetCatTargets(dt)

	for k,v in ipairs(garrCat) do
		v.currentdecisiontimer = v.currentdecisiontimer - dt
		if v.targetx == 0 or v.currentdecisiontimer <= 0 then
			v.currentdecisiontimer = 1
		
			-- find new target
			closestmouse = 0
			for q,w in ipairs(garrMouse) do
				if k == q then
					closestmouse = q
				end
			end
			
			v.targetx = garrMouse[closestmouse].x
			v.targety = garrMouse[closestmouse].y
		end
	end
end

function functions.DespawnMouse()

	for k,v in ipairs(garrMouse) do
		if v.x < 0 or v.x > gintScreenWidth or v.y < 0 or v.y > gintScreenHeight then
			-- off the screen
			-- dead
			v.score = v.score - 10
			-- v.weights[16] = v.score
			if v.score > gintHighScore then
				gintHighScore = v.score
			end		

			UpdateParents(v)

			v.score = 0
			v.weights[16] = 0
			v.weights = {}	
			v = {}
			table.remove(garrMouse,k)
			cobjs.CreateMouse()			

		end
	end
end

return functions