local drawobjects = {}


function drawobjects.DrawAgents()

	for k,v in pairs(Agents) do
		
		local x = v.body:getX()
		local y = v.body:getY()
	
		love.graphics.setColor(1,1,1,1)
		love.graphics.circle("fill", x,y, gintAgentRadius )	

		love.graphics.print(cf.round(v.age,0), x + 10, y - 10)
		
		
		if k == 1 then
			love.graphics.setColor(0,1,1,1)
			love.graphics.print(cf.round(v.output1,4), 5,40)
			love.graphics.print(cf.round(v.output2,4), 75,40)
			love.graphics.print(cf.round(v.output3,4), 150,40)
		end	
		
		
	end


end

function drawobjects.DrawWorld()

	local drawingx = gintLeftBorder
	local drawingy = gintTopBorder
	local drawingwidth = gintBorderWidth
	local drawingheight = gintBorderHeight
	
	love.graphics.setColor(1,1,1,1)
	love.graphics.rectangle("line", gintLeftBorder,gintTopBorder,drawingwidth,drawingheight)

	-- highscore
	love.graphics.print(cf.round(gintHighScore,0), 5,5)
	
	-- parent 1
	local mystring = garrParent1[1] .. " " .. garrParent1[2] .. " " .. garrParent1[3]  .. " " .. garrParent1[4] .. " " ..  garrParent1[5] .. " " ..  garrParent1[6] .. " " ..  garrParent1[7] .. " " ..  garrParent1[8] .. " " ..  garrParent1[9] .. " " ..  garrParent1[10] .. " " ..  garrParent1[11] .. " " ..  garrParent1[12] .. " " ..  garrParent1[13] .. " " ..  garrParent1[14] .. " " ..  garrParent1[15] .. " : " .. cf.round(garrParent1[16],0)
	love.graphics.print(mystring, 5, 15)
	
	-- parent 2
	local mystring = garrParent2[1] .. " " .. garrParent2[2] .. " " .. garrParent2[3]  .. " " .. garrParent2[4] .. " " ..  garrParent2[5] .. " " ..  garrParent2[6] .. " " ..  garrParent2[7] .. " " ..  garrParent2[8] .. " " ..  garrParent2[9] .. " " ..  garrParent2[10] .. " " ..  garrParent2[11] .. " " ..  garrParent2[12] .. " " ..  garrParent2[13] .. " " ..  garrParent2[14] .. " " ..  garrParent2[15]  .. " : " .. cf.round(garrParent2[16],0)
	love.graphics.print(mystring, 5, 28)	
	
	

end

return drawobjects