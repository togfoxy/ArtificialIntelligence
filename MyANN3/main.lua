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

gintScreenWidth = 1440-- 1920
gintScreenHeight = 900-- 1080
garrCurrentScreen = {}		

garrMouse = {}
garrCheese = {}
garrCat = {}
garrParent1 = {}
garrParent2 = {}

gintHighScore = 0

gfltDebug1 = 0
gfltDebug2 = 0
gfltDebug3 = 0


function love.keyreleased( key, scancode )
	if key == "escape" then
		fun.RemoveScreen()
	end
end

function love.load()

    if love.filesystem.isFused( ) then
        void = love.window.setMode(gintScreenWidth, gintScreenHeight,{fullscreen=false,display=1,resizable=true, borderless=false})	-- display = monitor number (1 or 2)
        gbolDebug = false
    else
        void = love.window.setMode(gintScreenWidth, gintScreenHeight,{fullscreen=false,display=2,resizable=true, borderless=false})	-- display = monitor number (1 or 2)
    end
	
	love.window.setTitle("Mouse " .. gstrGameVersion)

	fun.AddScreen("myscreen")
	
	for i = 1,9 do
		cobjs.CreateMouse()
		cobjs.CreateCheese()
		cobjs.CreateCheese()
		cobjs.CreateCat()
	end
	
	garrParent1 = cf.deepcopy(garrMouse[1].weights)
	garrParent2 = cf.deepcopy(garrMouse[2].weights)
	
	-- table.insert(garrMouse[1], 99)	-- the 16th element is the score
	-- table.insert(garrMouse[2], 99)
end


function love.draw()

	TLfres.beginRendering(gintScreenWidth,gintScreenHeight)

	dobjs.DrawScreen()
	dobjs.DrawMouse()
	dobjs.DrawCheese()
	dobjs.DrawCat()
	
	TLfres.endRendering({0, 0, 0, 1})	
end

function love.update(dt)

	-- process each mouse
	for k,v in ipairs(garrMouse) do
		v.age = v.age + dt
		v.actiontimer = v.actiontimer - dt
		v.currentdecisiontimer = v.currentdecisiontimer - dt
		
		if v.currentdecisiontimer <= 0 then
			v.currentdecisiontimer = 1
			
			-- decide new decision
			v.currentdecision = nn.GetDecision(v,k)
			-- if k == 1 then print(dt) end
		end
		
		if v.actiontimer <= 0 then
			v.actiontimer = 1
			
			--! need to take new action based on existing decision
			if v.currentdecision == 0 then
				-- do nothing
					v.targetx = 0
					v.targety = 0			
				
			elseif v.currentdecision == 1 then
				-- move towards closest cheese
				-- executed every 1 second
				local closestcheese = 0
				local closestdistance = 0
				
				for q,w in ipairs(garrCheese) do
					local cheesedistance = cf.GetDistance(w.x,w.y,v.x,v.y)
					
					if closestdistance == 0 then
						closestdistance = cheesedistance
						closestcheese = q
					elseif cheesedistance < closestdistance then
						closestdistance = cheesedistance
						closestcheese = q
					end
					
					-- closest cheese is now captured in closestcheese
					v.targetx = garrCheese[closestcheese].x
					v.targety = garrCheese[closestcheese].y

				end
			elseif v.currentdecision == 2 then
				-- flee from cat
				local closestcat = 0
				local closestdistance = 0
				
				for q,w in ipairs(garrCat) do
				
					assert(w.x ~= nil)
					assert(w.y ~= nil)
				
					local catdistance = cf.GetDistance(w.x,w.y,v.x,v.y)
					
					assert(catdistance ~= nil and catdistance > 0)
					
					if closestdistance == 0 then
						closestdistance = catdistance
						closestcat = q
					elseif catdistance < closestdistance then
						closestdistance = catdistance
						closestcat = q
					end
				end
				
				-- determine vector to this cat
				local xvect = garrCat[closestcat].x - v.x
				local yvect = garrCat[closestcat].y - v.y
				
				-- swap vector around so we move away
				local newxvect,newyvect = cf.ScaleVector(xvect,yvect,-1)
				
				-- introduce a small angular deflection
				newxvect = cf.round(newxvect * love.math.random(0.5,1.5),0)
				newyvect = cf.round(newyvect * love.math.random(0.5,1.5),0)
				
				v.targetx = v.x + newxvect
				v.targety = v.y + newyvect				
			end
		end
		
		
	end
	
	fun.SetCatTargets(dt)
	
	fun.MoveMouse(dt)	
	
	fun.MoveCat(dt)
	
	fun.EatMouse()
	
	fun.EatCheese()
	
	--fun.AgeMouse()
	
	fun.DespawnMouse()
	
	
	
end