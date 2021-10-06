gstrGameVersion = "0.01"

inspect = require 'inspect'
-- https://github.com/kikito/inspect.lua

TLfres = require "tlfres"
-- https://love2d.org/wiki/TLfres

cobjs = require "createobjects"
dobjs = require "drawobjects"
fun = require "functions"
cf = require "commonfunctions"
nn = require "nn"
inspect = require "inspect"

gintScreenWidth = love.graphics.getWidth()
gintScreenHeight = love.graphics.getHeight()

garrCurrentScreen = {}		

garrLanders = {}
garrParent1 = {}
garrParent2 = {}
garrWinCount = {}

gintLandY = 550
gintGenNumber = 1
gintNumBots = 99
gintRoundWin = 0

-- print(gintScreenHeight / 2, gintLandY)

function checkiflanded(Lander)
	if Lander.age > 15 then	
		Lander.bolGameOver = true
		Lander.score = Lander.age * 2
	end
	
	if Lander.y <= 0 then
		Lander.bolGameOver = true
		Lander.score = 999
	end
	
	
	if Lander.y >= gintLandY - 10 then
		Lander.bolGameOver = true
		Lander.score = Lander.vy * 10 + (Lander.age / 4)
		
		if Lander.vy <= 0.25 then gintRoundWin = gintRoundWin + 1 end
	end

end

function myPrint(Lander)
    local sDebug = "Angle= "..tostring(cf.round(Lander.angle,3))
    sDebug = sDebug.." vx= "..tostring(cf.round(Lander.vx,3));
    sDebug = sDebug.." vy= "..tostring(cf.round(Lander.vy,3));
	sDebug = sDebug.." y= "..tostring(cf.round(Lander.y,3));
	

    love.graphics.print(sDebug, 0, 0)

	sDebug = "Generation: " .. gintGenNumber    
	love.graphics.print(sDebug, 0, 15)
	
	-- parent 1
	local mystring = ""
	for k,v in ipairs(garrParent1) do
		mystring = mystring .. cf.round(v,1) .. " "
	end
	love.graphics.print(mystring, 5, 28)		
	
	-- parent 2
	local mystring = ""
	for k,v in ipairs(garrParent2) do
		mystring = mystring .. cf.round(v,1) .. " "
	end
	love.graphics.print(mystring, 5, 43)

	-- outputs
	love.graphics.setColor(0,1,0)
	love.graphics.print(cf.round(Lander.output1,4), 5, 58)
	love.graphics.print(cf.round(Lander.output2,4), 75, 58)
	love.graphics.print(cf.round(Lander.output3,4), 150, 58)
	love.graphics.setColor(1,1,1)
	
end

function velocity(Lander, dt)
      Lander.x = Lander.x + Lander.vx 
      Lander.y = Lander.y + Lander.vy
end

function shipMovement(Lander, dt)


	Lander.vy = Lander.vy + (0.6 * dt)

	if math.abs(Lander.vx) > 1 then
		if Lander.vx > 0 then
			Lander.vx = 1
		else 
			Lander.vx = -1
		end
	end

	if Lander.vy > 5 then
		Lander.vy = 5
	elseif Lander.vy < -1 then
		Lander.vy = -1
	end

end

function CheckForAllDead()
-- if all dead then generation is over

	for k,v in pairs(garrLanders) do
		if not v.bolGameOver then return end
	end

	for k,v in pairs(garrLanders) do
		UpdateParents(v)		
	end	
	
	garrLanders = {}
	gintGenNumber = gintGenNumber + 1
	
	for i = 1, gintNumBots do
		cobjs.CreateLander()
	end
	
	table.insert(garrWinCount, gintRoundWin)
	gintRoundWin = 0

end

function UpdateParents(bot)
-- bot is an object

	if bot.score < garrParent1[31] then
		-- replace parent1 and bump p1 down
		garrParent2 = cf.deepcopy(garrParent1)
		garrParent1 = cf.deepcopy(bot.weights)
		garrParent1[31] = bot.score
-- print("alpha")
	elseif bot.score < garrParent2[31] then
		-- replace parent2
		garrParent2 = cf.deepcopy(bot.weights)
		garrParent2[31] = bot.score
-- print("beta")
	end

end

function pressright(v,dt)
	v.angle = v.angle + (90 * dt)
	if v.angle > 360 then v.angle = 0 end
end

function pressleft(v,dt)
	v.angle = v.angle - (90 * dt)
	if v.angle < 0 then v.angle = 360 end
end

function pressup(v,dt)
	v.engineOn = true
	local angle_radian = math.rad(v.angle)
	local force_x = math.cos(angle_radian) * (v.speed * dt)
	local force_y = math.sin(angle_radian) * (v.speed * dt)

	v.vx = v.vx + force_x
	v.vy = v.vy + force_y

end

function love.keyreleased(key, scancode)
	if key == "escape" then
		fun.RemoveScreen()
	end

	if key == "right" then
		garrLanders[1].angle = garrLanders[1].angle + (90 * dt)
	if garrLanders[1].angle > 360 then garrLanders[1].angle = 0 end
	end   
	if key == "left" then
		garrLanders[1].angle = garrLanders[1].angle - (90 * dt)
	if garrLanders[1].angle < 0 then garrLanders[1].angle = 360 end
	end
	if key == "up" then
		garrLanders[1].engineOn = true
		local angle_radian = math.rad(garrLanders[1].angle)
		local force_x = math.cos(angle_radian) * (garrLanders[1].speed * dt)
		local force_y = math.sin(angle_radian) * (garrLanders[1].speed * dt)

		garrLanders[1].vx = garrLanders[1].vx + force_x
		garrLanders[1].vy = garrLanders[1].vy + force_y

	else
		garrLanders[1].engineOn = false
	end
	
	
end

function love.load()

    if love.filesystem.isFused( ) then
        void = love.window.setMode(gintScreenWidth, gintScreenHeight,{fullscreen=false,display=1,resizable=true, borderless=false})	-- display = monitor number (1 or 2)
        gbolDebug = false
    else
        void = love.window.setMode(gintScreenWidth, gintScreenHeight,{fullscreen=false,display=2,resizable=true, borderless=false})	-- display = monitor number (1 or 2)
    end
	
	love.window.setTitle("Lander AI " .. gstrGameVersion)

	fun.AddScreen("World")
	
	for i = 1,30 do
		local randombias = love.math.random(0,10) / 10
		garrParent1[i] = randombias
	end
	--garrParent1 = {0.5,0,0.8,0.2,1,0.7,0.8,0.4,0.7,0,0.2,0.5,1,0.3,0.5,0.6,0.9,0.1,0.3,0.2,0.9,0.3,0.7,0.1,0.3,0.6,0.3,0.5,1,0.5,3.4}
	table.insert(garrParent1, 999) 		-- score
	
	for i = 1,30 do
		local randombias = love.math.random(0,10) / 10
		garrParent2[i] = randombias
	end	
	--garrParent2 = {0.5,0.3,0.8,0.2,1,0.7,0.8,0.4,0.7,1,0.2,1,1,0.3,0.5,0.1,0,0.9,0.7,0.4,0.9,0.3,0.7,0.1,0.3,0.6,0.3,0.5,1,0.5,4.8}
	table.insert(garrParent2, 999) 		-- score
	
	for i = 1, gintNumBots do
		cobjs.CreateLander()
	end


end

function love.draw()

	--TLfres.beginRendering(gintScreenWidth,gintScreenHeight)
	
	for k,v in ipairs(garrLanders) do
	
		if v.bolGameOver == false then
			love.graphics.draw(v.img, v.x,v.y, math.rad(v.angle), 1, 1, v.img:getWidth()/2, v.img:getHeight()/2)

			love.graphics.print(cf.round(v.vy,1), v.x + 8, v.y - 10)
			
			if v.engineOn == true then
				love.graphics.draw(v.imgEngine, v.x, v.y, math.rad(v.angle), 1, 1, v.imgEngine:getWidth()/2, v.imgEngine:getHeight()/2)
				v.engineOn = false
			end	
		else
			-- erase unless it is a good score
			if v.score < (garrParent2[31] * 1.5) or v.vy <= 0.25 then
				-- draw
				love.graphics.draw(v.img, v.x,v.y, math.rad(v.angle), 1, 1, v.img:getWidth()/2, v.img:getHeight()/2)
				if v.y >= gintLandY - 20 then
					love.graphics.print(cf.round(v.vy,2), v.x + 8, v.y - 10)
				else
					love.graphics.print(cf.round(v.vy,1), v.x + 8, v.y - 10)
				end				
			end
		end
	end

	-- print text at top
	myPrint(garrLanders[1])
  
	love.graphics.line(0,gintLandY, gintScreenWidth,gintLandY)	
	
	-- draw win count
	local mystring = ""
	local mystart = #garrWinCount
	local myend = mystart - 20
	if myend < 1 then myend = 1 end
	
	for i = mystart, myend, -1 do
		if i <= #garrWinCount and i > 0 then
			mystring = mystring .. tostring(garrWinCount[i]) .. "   "
		end
	end
	
	mystring = "Successful landing: " .. mystring
	love.graphics.print(mystring, 100, 565)

	
	

	--TLfres.endRendering({0, 0, 0, 1})

end

function love.update(dt)

	for k,v in ipairs(garrLanders) do
		
		if not v.bolGameOver then
		

		
			local newaction = nn.GetDecision(v,k)
			
			if newaction == 1 then
				--pressleft(v,dt)
			end
			if newaction == 2 then
				--pressright(v,dt)
			end
			if newaction == 3 then
				pressup(v,dt)
			end
			

			
			velocity(v,dt)
			shipMovement(v,dt)
			checkiflanded(v)
			v.age = v.age + dt
			
		else
		end
	end
	
	CheckForAllDead()
	
end











