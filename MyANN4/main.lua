gstrGameVersion = "0.01"

TLfres = require "tlfres"
-- https://love2d.org/wiki/TLfres

-- bitser = require 'bitser'

--nativefs = require("nativefs")
-- https://github.com/megagrump/nativefs

--anim8 = require 'anim8'
-- https://github.com/kikito/anim8

inspect = require 'inspect'
-- https://github.com/kikito/inspect.lua

gbolDebug = true
gbolDebug = false

cf = require "commonfunctions"
cobjs = require "createobjects"
dobjs = require "drawobjects"
fun = require "randomfunctions"
nn = require "nn"

gintScreenWidth = 1366
gintScreenHeight = 768
garrCurrentScreen = {}


Agents = {}
garrParent1 = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
garrParent2 = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
garrGoodPool = {}

gintAgentRadius = 7
gintHighScore = 0

screenmargin = 100
gintTopBorder = 0 + screenmargin
gintBottomBorder = gintTopBorder + gintScreenHeight - screenmargin - screenmargin
gintLeftBorder = 0 + screenmargin
gintRightBorder = gintLeftBorder + gintScreenWidth - screenmargin - screenmargin
gintBorderWidth = gintScreenWidth - screenmargin - screenmargin
gintBorderHeight = gintScreenHeight - screenmargin - screenmargin





function love.keyreleased( key, scancode )
	if key == "escape" then
		fun.RemoveScreen()
	end
end

function love.load(arg)
    if love.filesystem.isFused( ) then
        void = love.window.setMode(gintScreenWidth, gintScreenHeight,{fullscreen=true,display=1,resizable=false})	-- display = monitor number (1 or 2)
        gbolDebug = false
    else
        void = love.window.setMode(gintScreenWidth, gintScreenHeight,{fullscreen=true,display=2,resizable=false})	-- display = monitor number (1 or 2)
    end
        
	love.window.setTitle("Space couriers " .. gstrGameVersion)
    
    -- if arg[#arg] == "-debug" then require("mobdebug").start() end
	
    fun.AddScreen("MainMenu")
	
	love.physics.setMeter(1)
	world = love.physics.newWorld(0,0,false)	
	world:setCallbacks(beginContact,_,_,_)
	
	for i = 1,9 do
		cobjs.CreateAgent()
	end

end

function love.draw()

    TLfres.beginRendering(gintScreenWidth,gintScreenHeight)

	dobjs.DrawWorld()
	dobjs.DrawAgents()

	TLfres.endRendering({0, 0, 0, 1})
	
	
end

function love.update(dt)

	for k,v in pairs(Agents) do
		v.age = v.age + dt
		v.decisiontimer = v.decisiontimer - dt
		if v.decisiontimer <= 0 then
			v.decisiontimer = 1
			-- fun.GetNewDirection(v)
			local newoutput = nn.GetDecision(v,k)		-- don't actually use newoutput
			
			
			local xfactor = (v.output1 - 0.5) * (v.output3 * 500)
			local yfactor = (v.output2 - 0.5) * (v.output3 * 500)
			
			bot.linearvelocityx = xfactor
			bot.linearvelocityy = yfactor
		end
		
		v.body:setLinearVelocity(v.linearvelocityx, v.linearvelocityy)
		
		fun.CheckDie(v)
		if v.dead then
			table.remove(Agents, k)
			
			cobjs.CreateAgent()
			
		end
	end
	
	screenmargin = screenmargin + dt
	if screenmargin > ((gintScreenHeight / 2) * 0.75) then
		screenmargin = ((gintScreenHeight / 2) * 0.75)
		
		-- end of this generation
		fun.KillGeneration()
		
		screenmargin = 100
		for i = 1,9 do
			cobjs.CreateAgent()
		end
	end
	
	gintTopBorder = 0 + screenmargin
	gintBottomBorder = gintTopBorder + gintScreenHeight - screenmargin - screenmargin
	gintLeftBorder = 0 + screenmargin
	gintRightBorder = gintLeftBorder + gintScreenWidth - screenmargin - screenmargin
	gintBorderWidth = gintScreenWidth - screenmargin - screenmargin
	gintBorderHeight = gintScreenHeight - screenmargin - screenmargin


	--animation:update(dt)

	world:update(dt) --this puts the world into motion

end

