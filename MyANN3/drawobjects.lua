cheesesize = 15
catsize = 30
mousesize = 5

local drawobjects = {}
-- put all the drawing routines in here

function drawobjects.DrawScreen()
	love.graphics.setColor(1,1,1,1)
	love.graphics.print(gintHighScore, 5,5)
	
	-- parent 1
	local mystring = garrParent1[1] .. " " .. garrParent1[2] .. " " .. garrParent1[3]  .. " " .. garrParent1[4] .. " " ..  garrParent1[5] .. " " ..  garrParent1[6] .. " " ..  garrParent1[7] .. " " ..  garrParent1[8] .. " " ..  garrParent1[9] .. " " ..  garrParent1[10] .. " " ..  garrParent1[11] .. " " ..  garrParent1[12] .. " " ..  garrParent1[13] .. " " ..  garrParent1[14] .. " " ..  garrParent1[15] .. " : " .. garrParent1[16]
	love.graphics.print(mystring, 5, 15)
	
	-- parent 2
	local mystring = garrParent2[1] .. " " .. garrParent2[2] .. " " .. garrParent2[3]  .. " " .. garrParent2[4] .. " " ..  garrParent2[5] .. " " ..  garrParent2[6] .. " " ..  garrParent2[7] .. " " ..  garrParent2[8] .. " " ..  garrParent2[9] .. " " ..  garrParent2[10] .. " " ..  garrParent2[11] .. " " ..  garrParent2[12] .. " " ..  garrParent2[13] .. " " ..  garrParent2[14] .. " " ..  garrParent2[15]  .. " : " .. garrParent2[16]
	love.graphics.print(mystring, 5, 28)
end

function drawobjects.DrawMouse()

	for k,v in ipairs(garrMouse) do

		if k == 1 then
			love.graphics.setColor(0,1,1,1)
			love.graphics.print(cf.round(v.output1,4), 5,40)
			love.graphics.print(cf.round(v.output2,4), 75,40)
			love.graphics.print(cf.round(v.output3,4), 150,40)
		else
			love.graphics.setColor(1,1,1,1)
		end	
		
		
		-- love.graphics.setColor(1,1,1,1)
		love.graphics.circle("fill",v.x,v.y,mousesize)
		
		love.graphics.print("Decision: " .. v.currentdecision, v.x + 7, v.y - 12)
		-- love.graphics.print("Target X: " .. v.targetx, v.x + 7, v.y - 2)
		love.graphics.print("Score: " .. v.score, v.x + 7, v.y - 2)
		love.graphics.print("Age: " .. cf.round(v.age,0), v.x + 7, v.y + 8)
		-- love.graphics.print("D timer: " .. cf.round(v.currentdecisiontimer,0), v.x + 7, v.y + 18)


	end

end

function drawobjects.DrawCheese()
	
	for k,v in ipairs(garrCheese) do
	
		love.graphics.setColor(238/255,201/255,16/255,1)
		love.graphics.rectangle("fill", v.x - (cheesesize / 2),v.y - (cheesesize / 2), cheesesize,cheesesize)


	end
end

function drawobjects.DrawCat()

	for k,v in ipairs(garrCat) do
	
		local cathalf = catsize / 2
	
		love.graphics.setColor(154/255,154/255,154/255)
		love.graphics.polygon("fill", v.x - cathalf, v.y,   v.x, v.y - cathalf,    v.x + cathalf, v.y,     v.x, v.y + cathalf )
		
		--love.graphics.print("Target X: " .. cf.round(v.targetx,1), v.x + 7, v.y - 2)
		--love.graphics.print("D timer: " .. cf.round(v.currentdecisiontimer,1), v.x + 7, v.y + 8)
		

	end


end

return drawobjects