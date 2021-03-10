

intNumberofInputs = 2
intNumberofHiddenNodes = 2
intNumberofOutputNodes = 2
fltLearningRate = 0.5
fltBias = 1
errorrate = 1			-- needs to be a non-zero number to avoid 'divide by zero'
previouserrorrate = 1	-- needs to be a non-zero number to avoid 'divide by zero'

nnetwork = {}
nnetwork.inputlayer = {}	-- a list of input perceptrons
nnetwork.hiddenlayer = {}	-- a list of perceptrons
nnetwork.outputlayer = {}	-- a list of one perceptron

bolKeyPress = false	

-- this is a class that can be re-used
inputperceptron = {inputvalue = 0,
					xpos,			-- for graphics
					ypos,			-- for graphics
					weight = {},	-- there will eventually be one weight per hidden p
					weightdelta = {}	-- need to store this during the back prop
					}
inputperceptron.__index = inputperceptron
					
function inputperceptron:new(o)
	o = o or {}
	setmetatable(o,self)
	self.__index = self
	
	o.inputvalue = 0
	o.xpos = 0
	o.ypos = 0
	
	-- this input perceptron will have 1 weight per hidden perceptron	--! need to make this scalable.
	o.weight = {}
	for i = 1, (intNumberofHiddenNodes) do
		o.weight[i] = 0
	end
	o.weightdelta = {}
	return o
end

perceptron = {inputvalue = 0,	-- sum of (inputs * weight)	
				outsignal = 0,	-- the next forward layer will apply this weight to the outsignal. Assumes one output
				xpos,			-- for graphics
				ypos,			-- for graphics
				weight = {},	-- if this is a bias then the weight is used and not outsignal
				weightdelta = {}
			}
perceptron.__index = perceptron
			
function perceptron:new(o)
	o = o or {}
	setmetatable(o,self)
	self.__index = self
	
	o.inputvalue = 0
	o.outsignal = 0
	o.xpos = 0
	o.ypos = 0	
	
	o.weight = {}	-- this will be set up when the network is established
	for i = 1, (intNumberofOutputNodes) do
		o.weight[i] = 0
	end	
	o.weightdelta = {}
	return o
end

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end
			
function EstablishNetwork(numofinputs, numofhiddennodes)

	
	for i = 1,numofinputs + 1 do
		local p
	-- the +1 will give the bias an input (incorrectly) but we'll just ignore that
		p = inputperceptron:new()
		p.xpos = (75)
		p.ypos = (100 * i )
		
		-- fix initial values and weights etc for learning purposes
		if i == 1 then
			-- p.inputvalue = 0.1
			p.inputvalue = 0.25
			p.weight[1] = 0.25	-- W1
			p.weight[2] = 0.35	-- W3
		
		end
		if i == 2 then
			-- p.inputvalue = 0.2
			p.inputvalue = 0.50
			p.weight[1] = 0.15	-- W4
			p.weight[2] = 0.28	-- W2
		end	
		if i == 3 then
			p.inputvalue = 0
			p.weight[1] = 0.45	-- bias b1
			p.weight[2] = 0.45	-- bias b1
		end

		--print("My weights for p" .. i .. " after calling new()")
		--print(p.weight[1],p.weight[2],p.weight[3])
		
		table.insert(nnetwork.inputlayer,p)
		
		--print("My weights for p" .. i .. " in the network after calling new()")
		--print(nnetwork.inputlayer[i].weight[1],nnetwork.inputlayer[i].weight[2],nnetwork.inputlayer[i].weight[3])
		
	end
	
	for i = 1,(numofhiddennodes + 1) do		-- the +1 is for the bias that is applied at the hidden layer
		p = perceptron:new()
		p.xpos = (175)
		p.ypos = (100 * i )
		
		if i == 1 then
			p.weight[1] = 0.35	-- W5
			p.weight[2] = 0.45	-- W7
		
		end
		
		if i == 2 then
			p.weight[1] = 0.20	-- W6
			p.weight[2] = 0.40	-- W8		
		
		end
		
		if i == 3 then
			p.weight[1] = 0.50	-- bias b2
			p.weight[2] = 0.50	-- bias b2	
		
		end		
		
		--for j = 1, intNumberofOutputNodes do
			-- p.weight[j] = love.math.random(0,100)/100	-- random number between 0 and 1
		--end		
		
		table.insert(nnetwork.hiddenlayer,p)
		
		-- the +1 is the bias and that will have a bias weight
	end	

	--print("Inputs")
	--print(nnetwork.inputlayer[1].inputvalue)
	--print(nnetwork.inputlayer[2].inputvalue)
	--print(nnetwork.inputlayer[1].inputvalue)
	--print()
	
	--print("Weights")
	--print(nnetwork.inputlayer[1].weight[1],nnetwork.inputlayer[1].weight[2])
	--print(nnetwork.inputlayer[2].weight[1],nnetwork.inputlayer[2].weight[2])

	for i = 1, (intNumberofOutputNodes) do	
		p = perceptron:new()		-- note that this will create weights but we'll just ignore that.
		p.xpos = (275)
		p.ypos = (100 * i )
		
		table.insert(nnetwork.outputlayer,p)
	end
end

function ApplyActivation(unadjustedinput)

	local eulersnumber = 2.7182
	return 1/(1+eulersnumber^-unadjustedinput)

end

function ExecuteForwardPass()
	
	--print("Executing forward pass")
	
	myinputvalue = {}
	myweightvalue = {}
	mysignalvalue = 0
	mytempresult = 0
	

	-- take all the equivalent input from the input layer and process every node in the hidden layer
	
	for i = 1,intNumberofHiddenNodes do	-- for each perceptron, ignoring any bias node
		-- do the weight * input thing
		mytempresult = 0
		for j = 1,intNumberofInputs do	-- for each input, ignoring bias node
			mytempresult = mytempresult + (nnetwork.inputlayer[j].weight[i] * nnetwork.inputlayer[j].inputvalue)
		end
		
		-- apply the hidden layer bias just once for this perceptron, remembering it's the same bias value for all nodes in this layer
		-- the bias node is the node hanging off the end of the layer: intNumberofHiddenNodes+1
		mytempresult = mytempresult + (nnetwork.inputlayer[intNumberofInputs + 1].weight[1] * fltBias)
	
		nnetwork.hiddenlayer[i].inputvalue = mytempresult

		-- do the activation function and set output signal
		nnetwork.hiddenlayer[i].outsignal = ApplyActivation(nnetwork.hiddenlayer[i].inputvalue)
	end	
	
	-- now calculate forward and update output nodes
	for i = 1, intNumberofOutputNodes do	-- for each output node ...
		-- do the weight * input thing
		--print("===o" .. i .. "=========")
		mytempresult = 0
		for j = 1,intNumberofHiddenNodes do	-- for each hidden node, ignoring bias node
		--print(nnetwork.hiddenlayer[j].weight[i] .. " * " .. nnetwork.hiddenlayer[j].outsignal)
			mytempresult = mytempresult + (nnetwork.hiddenlayer[j].weight[i] * nnetwork.hiddenlayer[j].outsignal)
		end	
		
		-- apply the bias
		mytempresult = mytempresult + (nnetwork.hiddenlayer[intNumberofHiddenNodes + 1].weight[1] * fltBias)
	
		nnetwork.outputlayer[i].inputvalue = mytempresult
	
		-- do the activation function and set output signal
		nnetwork.outputlayer[i].outsignal = ApplyActivation(nnetwork.outputlayer[i].inputvalue)	
	
	
	end
end

function GetErrorRate(requiredtarget)
	-- requiredtarget = an array of correct values per output
	
	local totalerror = 0
	
	for i = 1, #requiredtarget do
		local thisoutputerror = 0
		thisoutputerror = fltLearningRate * (requiredtarget[i] - nnetwork.outputlayer[i].outsignal)^2
		totalerror = totalerror + thisoutputerror
		
		--thisoutputerror = (requiredtarget[i] - nnetwork.outputlayer[i].outsignal)^2
		--totalerror = totalerror + thisoutputerror
		
	end
	return totalerror
end

function ExecuteBackaPropagation(mytarget)
	-- mytarget is an array that has one target for each output node


	--print("===================")
	--print("Beginning back prop")
	--print("===================")

	for i = 1, intNumberofOutputNodes do	-- for each output node
		for j = 1,intNumberofHiddenNodes do
			local alpha
			local beta
			local charlie
			local weightdelta

			alpha = -(mytarget[i] - nnetwork.outputlayer[i].outsignal)
			beta = -(nnetwork.outputlayer[i].outsignal * (1- nnetwork.outputlayer[i].outsignal))
			charlie = nnetwork.hiddenlayer[j].outsignal
			weightdelta = alpha * beta * charlie
	
			nnetwork.hiddenlayer[j].weightdelta[i] = fltLearningRate * weightdelta
			-- print("Delta for hidden node " .. j,i .." is " .. nnetwork.hiddenlayer[j].weightdelta[i])
			
		end
	end
	-- print("*******")
	
	-- weights feeding the output layer are now adjusted.
	
	-- need to adjust the weights coming out of the input layer
	for i = 1, intNumberofHiddenNodes do
		for j = 1, intNumberofInputs do
		
			-- randomly adjust weights in the correct direction
			local rndomweightdelta = (love.math.random(0,50))/100
			
			-- reduce the rndomweightdelta towards zero as the error rate approaches zero
			local errortrendfactor = errorrate / previouserrorrate
			-- print (errorrate,previouserrorrate,errortrendfactor)
			rndomweightdelta = rndomweightdelta * errortrendfactor
			
			if errorrate < 0 then
				rndomweightdelta = rndomweightdelta * -1
			end
			nnetwork.inputlayer[j].weightdelta[i] = rndomweightdelta
		end
	end
	
	-- now to apply all the deltas
	for i = 1,intNumberofInputs do
		for j = 1, intNumberofHiddenNodes do
			if nnetwork.inputlayer[i].weightdelta[j] ~= nil then
				nnetwork.inputlayer[i].weight[j] = nnetwork.inputlayer[i].weight[j] + nnetwork.inputlayer[i].weightdelta[j]
				nnetwork.inputlayer[i].weightdelta[j] = 0	-- reset this weight for next time
			end
		end
	end
	for i = 1,intNumberofHiddenNodes do
		for j = 1, intNumberofOutputNodes do
			if nnetwork.hiddenlayer[i].weightdelta[j] ~= nil then
				nnetwork.hiddenlayer[i].weight[j] = nnetwork.hiddenlayer[i].weight[j] + nnetwork.hiddenlayer[i].weightdelta[j]
				nnetwork.hiddenlayer[i].weightdelta[j] = 0
			end
		end
	end
end

function love.keypressed(key, scancode, isrepeat)
	bolKeyPress = true
end
function love.load()

	void = love.window.setMode(400, 400)
	love.window.setTitle("Love Classes")
	
	EstablishNetwork(2,2)
end

function love.update(dt)

	if bolKeyPress then
		-- bolKeyPress = false
		bolKeyPress = true
	
		local correctoutcome = {}	-- for training
		
		-- nnetwork.inputlayer[1].inputvalue = 0.1
		-- nnetwork.inputlayer[2].inputvalue = 0.2
		correctoutcome[1] = 0
		correctoutcome[2] = 1
		--[[
		-- load inputs into input layer
		for i = 1,intNumberofInputs do
			--print("Enter input #" .. i)
			
			-- these next two lines are syntacially the same. Left here for learning.
			--nnetwork.inputlayer[i].setinputvalue(nnetwork.inputlayer[i],tonumber(io.stdin:read()))
			nnetwork.inputlayer[i].inputvalue = (tonumber(io.stdin:read()))
			--print(nnetwork.inputlayer[i].inputvalue)
		end
		
		--	get outs for training purposes
		print("Enter the correct outcome: ")
		correctoutcome = tonumber(io.stdin:read())
		]]--
		-- execute 1 forward pass
		ExecuteForwardPass()
		
		previouserrorrate = errorrate
		errorrate = GetErrorRate(correctoutcome)		-- send in an array and get a single number back
		-- print("Error rate is " .. errorrate)

		-- execute back prop	
		ExecuteBackaPropagation(correctoutcome)
		
		-- wait for signal to proceeed to next iteration

	end
end

function love.draw()

	-- draw input nodes + bias
	for i = 1, intNumberofInputs + 1 do
		love.graphics.setColor(222/255, 52/255, 235/255)
		love.graphics.circle("fill", nnetwork.inputlayer[i].xpos, nnetwork.inputlayer[i].ypos, 25)
	
		if i <= intNumberofInputs then -- don't print a value for the bias as it is irrelevan
			love.graphics.setColor(1, 1, 1)
			love.graphics.print(nnetwork.inputlayer[i].inputvalue,nnetwork.inputlayer[i].xpos - 20,nnetwork.inputlayer[i].ypos - 10)
		end

	
	end
	
	-- draw hidden nodes + bias
	for i = 1, intNumberofHiddenNodes + 1 do
		love.graphics.setColor(52/255, 235/255, 229/255)
		love.graphics.circle("fill", nnetwork.hiddenlayer[i].xpos, nnetwork.hiddenlayer[i].ypos, 25)
	
		-- draw the input value
		if i <= intNumberofHiddenNodes then	-- don't print a value for the bias as it is irrelevant
			love.graphics.setColor(255,0, 0)
			love.graphics.print(round(nnetwork.hiddenlayer[i].inputvalue,4),nnetwork.hiddenlayer[i].xpos - 20,nnetwork.hiddenlayer[i].ypos - 10)
		end
		
		-- draw the out signal strength
		if i <= intNumberofHiddenNodes then	-- don't print a value for the bias as it is irrelevant
			love.graphics.setColor(255, 0, 0)
			love.graphics.print(round(nnetwork.hiddenlayer[i].outsignal,4),nnetwork.hiddenlayer[i].xpos + -15,nnetwork.hiddenlayer[i].ypos + 0)
		end
		
	end
	
	-- draw output nodes
	for i = 1, intNumberofOutputNodes do
		love.graphics.setColor(235/255, 164/255, 52/255)
		love.graphics.circle("fill", nnetwork.outputlayer[i].xpos, nnetwork.outputlayer[i].ypos, 25)

		-- draw the input value
		if i <= intNumberofOutputNodes then	-- don't print a value for the bias as it is irrelevant
			love.graphics.setColor(255,0, 0)
			love.graphics.print(round(nnetwork.outputlayer[i].inputvalue,4),nnetwork.outputlayer[i].xpos - 20,nnetwork.outputlayer[i].ypos - 10)
		end
		
		-- draw the out signal strength
		if i <= intNumberofOutputNodes then	-- don't print a value for the bias as it is irrelevant
			love.graphics.setColor(255, 0, 0)
			love.graphics.print(round(nnetwork.outputlayer[i].outsignal,4),nnetwork.outputlayer[i].xpos + -15,nnetwork.outputlayer[i].ypos + 0)
		end
	end
	
	-- draw lines with weights for inputs to hidden nodes
	for i = 1, intNumberofInputs + 1 do
		for j = 1, intNumberofHiddenNodes do
			
			x1 = nnetwork.inputlayer[i].xpos
			y1 = nnetwork.inputlayer[i].ypos 
			x2 = nnetwork.hiddenlayer[j].xpos
			y2 = nnetwork.hiddenlayer[j].ypos
			
			love.graphics.setColor(1, 1, 1,0.5)
			love.graphics.line(x1,y1,x2,y2)
			
			-- draw the weight
			x3 = (x1 + (x2-x1)/2) - 30
			y3 = ((y1 + (y2-y1)/2) - 30) + (i * 15)
			love.graphics.setColor(1, 1, 1)			
			love.graphics.print(round(nnetwork.inputlayer[i].weight[j],4),x3,y3)			
		end
	end
	
	-- draw lines from hidden to outputs
	for i = 1, intNumberofHiddenNodes + 1 do	-- includes bias
		for j = 1, intNumberofOutputNodes do
		
			x1 = nnetwork.hiddenlayer[i].xpos
			y1 = nnetwork.hiddenlayer[i].ypos
			x2 = nnetwork.outputlayer[j].xpos
			y2 = nnetwork.outputlayer[j].ypos
			
			love.graphics.setColor(1, 1, 1,0.5)
			love.graphics.line(x1,y1,x2,y2)			
		
			-- draw the weight
			x3 = (x1 + (x2-x1)/2) - 30
			y3 = ((y1 + (y2-y1)/2) - 30) + (i * 10)
			
			--print(x1,y1,x2,y2)
			--print(i, j)
			
			love.graphics.setColor(1, 1,1,1)			
			love.graphics.print(round(nnetwork.hiddenlayer[i].weight[j],4),x3,y3)			
		
		
		
		end
	
	
	
	
	end
	
	-- draw the error rate
	love.graphics.print(round(errorrate,6),10,10)
	
end
































