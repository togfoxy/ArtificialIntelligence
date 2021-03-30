intNumberofInputs = 6
intNumberofHiddenNodes = 4
intNumberofOutputNodes = 1
fltLearningRate = 0.25
errorrate = 1

intLoopNumber = 0

nnetwork = {}
nnetwork.inputlayer = {}	-- a list of input perceptrons
nnetwork.hiddenlayer = {}	-- a list of perceptrons
nnetwork.outputlayer = {}	-- a list of one perceptron
arrCorrectOutcome = {}		-- an array that holds one expected outcome per outome node

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

function EstablishNetwork(numofinputs, numofhiddennodes)
local xdistance = 150
	
	for i = 1,numofinputs + 1 do
		local p
	-- the +1 will give the bias an input (incorrectly) but we'll just ignore that
		p = inputperceptron:new()
		p.xpos = (75)
		p.ypos = (100 * i )
		
		-- fix initial values and weights etc for learning purposes
		for j = 1,numofhiddennodes do
			p.inputvalue = 0
			p.weight[j] = love.math.random(0,100)/100
		end
		table.insert(nnetwork.inputlayer,p)
	end
	
	for i = 1,(numofhiddennodes + 1) do		-- the +1 is for the bias that is applied at the hidden layer
		p = perceptron:new()
		p.xpos = (75 + xdistance)
		p.ypos = (100 * i )
		
		for j = 1,intNumberofOutputNodes do
			p.inputvalue = 0
			p.weight[j] = love.math.random(0,100)/100
		end
		table.insert(nnetwork.hiddenlayer,p)
	end	

	for i = 1, (intNumberofOutputNodes) do	
		p = perceptron:new()		-- note that this will create weights but we'll just ignore that.
		p.xpos = (75 + xdistance + xdistance)
		p.ypos = (100 * i )
		
		table.insert(nnetwork.outputlayer,p)
	end
end

function SetCorrectOutcome()
	-- manually set this to one per output node
	
	for i = 1, intNumberofOutputNodes do
		arrCorrectOutcome[1] = 1
	end
end

function ExecuteForwardPass()

	-- input * weight = hidden node inputvalue
	-- hidden node input value * activation function = hidden node outsignal
	for i = 1,intNumberofHiddenNodes do	-- for each perceptron, ignoring any bias node
		-- do the weight * input thing
		mytempresult = 0
		for j = 1,intNumberofInputs do	-- for each input, ignoring bias node
			mytempresult = mytempresult + (nnetwork.inputlayer[j].weight[i] * nnetwork.inputlayer[j].inputvalue)
		end
		
		-- apply the hidden layer bias just once for this perceptron, remembering it's the same bias value for all nodes in this layer
		-- the bias node is the node hanging off the end of the layer: intNumberofHiddenNodes+1
		mytempresult = mytempresult + (nnetwork.inputlayer[intNumberofInputs + 1].weight[1])
	
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
			mytempresult = mytempresult + (nnetwork.hiddenlayer[j].weight[i] * nnetwork.hiddenlayer[j].outsignal)
		end	
		
		-- apply the bias
		mytempresult = mytempresult + (nnetwork.hiddenlayer[intNumberofHiddenNodes + 1].weight[1])
	
		nnetwork.outputlayer[i].inputvalue = mytempresult
	
		-- do the activation function and set output signal
		nnetwork.outputlayer[i].outsignal = ApplyActivation(nnetwork.outputlayer[i].inputvalue)	
	end	


end

function ApplyActivation(unadjustedinput)

	local eulersnumber = 2.7182
	return 1/(1+eulersnumber^-unadjustedinput)

end

function SetInputValues()
	-- set up random values
	
	-- note that I'm artificially determining an expected outcome inside this loop out of convenience
	local mytotalinput = 0
	
	for i = 1, intNumberofInputs do
		nnetwork.inputlayer[i].inputvalue = ApplyActivation((love.math.random(0,10)/10))
		mytotalinput = mytotalinput + nnetwork.inputlayer[i].inputvalue
	end
	
	arrCorrectOutcome[1] = mytotalinput / intNumberofInputs		-- this is effectively a percentage that says the lower the inputs then the lower the expected output
end

function GetErrorRate()
	local totalerror = 0

	for i = 1, intNumberofOutputNodes do
		--thisoutputerror = (arrCorrectOutcome[i] - nnetwork.outputlayer[i].outsignal)^2
		thisoutputerror = (arrCorrectOutcome[i] - nnetwork.outputlayer[i].outsignal)
		totalerror = totalerror + thisoutputerror
	end
	return totalerror
end

function ExecuteBackProp()

	-- determine weight deltas for hidden nodes including the bias
	for i = 1, intNumberofOutputNodes do	-- for each output node
		for j = 1,intNumberofHiddenNodes + 1 do

			weightdelta = (love.math.random(0,50))/1000	-- get some random number
			weightdelta = weightdelta * errorrate	-- scale it by the degree of error
			
			nnetwork.hiddenlayer[j].weightdelta[i] = fltLearningRate * weightdelta
			-- print("Delta for hidden node " .. j,i .." is " .. nnetwork.hiddenlayer[j].weightdelta[i])
		end
	end
	
	-- need to determine the weight delta coming out of the input layer
	for i = 1, intNumberofHiddenNodes do
		for j = 1, intNumberofInputs + 1 do

			-- randomly adjust weights in the correct direction
			local weightdelta = (love.math.random(0,50))/1000			
			-- reduce the rndomweightdelta towards zero as the error rate approaches zero
			local weightdelta = weightdelta * errorrate
			
			nnetwork.inputlayer[j].weightdelta[i] = fltLearningRate * weightdelta
		end
	end


	-- now apply the delta's
	for i = 1,intNumberofInputs + 1 do
		for j = 1, intNumberofHiddenNodes do
			if nnetwork.inputlayer[i].weightdelta[j] ~= nil then
				nnetwork.inputlayer[i].weight[j] = nnetwork.inputlayer[i].weight[j] + nnetwork.inputlayer[i].weightdelta[j]
				nnetwork.inputlayer[i].weightdelta[j] = 0	-- reset this weight for next time
			end
		end
	end	
	
	for i = 1,intNumberofHiddenNodes + 1 do
		for j = 1, intNumberofOutputNodes do
			if nnetwork.hiddenlayer[i].weightdelta[j] ~= nil then
				nnetwork.hiddenlayer[i].weight[j] = nnetwork.hiddenlayer[i].weight[j] + nnetwork.hiddenlayer[i].weightdelta[j]
				nnetwork.hiddenlayer[i].weightdelta[j] = 0
			end
		end
	end
end


function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function love.load()

	void = love.window.setMode(400, 750)
	love.window.setTitle("Love ANNv3")
	
	EstablishNetwork(11, 5)

	SetInputValues()
	
	-- will not do this line for now. Outcomes are artificially set in the income function
	--SetCorrectOutcome()

end

function love.update(dt)

	ExecuteForwardPass()
	
	errorrate = GetErrorRate()
	
	ExecuteBackProp()


end


function love.draw()

	-- draw input nodes + bias
	for i = 1, intNumberofInputs + 1 do
		love.graphics.setColor(222/255, 52/255, 235/255)
		love.graphics.circle("fill", nnetwork.inputlayer[i].xpos, nnetwork.inputlayer[i].ypos, 25)
	
		if i <= intNumberofInputs then -- don't print a value for the bias as it is irrelevan
			love.graphics.setColor(1, 1, 1)
			love.graphics.print(round(nnetwork.inputlayer[i].inputvalue,2),nnetwork.inputlayer[i].xpos - 20,nnetwork.inputlayer[i].ypos - 10)
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
	
	-- draw the expected outcome
	love.graphics.print("Outcome[1]: " .. round(arrCorrectOutcome[1],3),10,10)
	
	-- draw the error rate
	love.graphics.print("Error rate: " .. round(errorrate,3),10,25)
	
	-- draw the loop number
	love.graphics.print("Loop num: " .. round(intLoopNumber,3),10,40)

end
































