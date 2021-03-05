

intNumberofInputs = 2
intNumberofHiddenNodes = 2
intNumberofOutputNodes = 2
fltLearningRate = 1
fltBias = 1

nnetwork = {}
nnetwork.inputlayer = {}	-- a list of input perceptrons
nnetwork.hiddenlayer = {}	-- a list of perceptrons
nnetwork.outputlayer = {}	-- a list of one perceptron

-- this is a class that can be re-used
inputperceptron = {inputvalue = 0,
					xpos,			-- for graphics
					ypos,			-- for graphics
					weight = {} 	-- there will eventually be one weight per hidden p
					}
inputperceptron.__index = inputperceptron
					
function inputperceptron:new(o)
	o = o or {}
	setmetatable(o,self)

	o.inputvalue = 0
	o.xpos = 0
	o.ypos = 0
	
	-- this input perceptron will have 1 weight per hidden perceptron	--! need to make this scalable.
	o.weight = {}
	for i = 1, (intNumberofHiddenNodes) do
		o.weight[i] = love.math.random(0,100)/100	-- random number between 0 and 1
	end
	return o
end


perceptron = {weight = 0,		-- the next forward layer will apply this weight to the outsignal. Assumes one output
				xpos,			-- for graphics
				ypos,			-- for graphics
				outsignal = 0
			}
perceptron.__index = perceptron
			
function perceptron:new(o)
	o = o or {}
	setmetatable(o,self)
	self.__index = self
	o.xpos = 0
	o.ypos = 0	
	self.outsignal = 0
	self.weight = love.math.random(0,100)/100 -- random number between 0 and 1. This is assigned to every perceptron but only the LAST perceptron is considered the bias.
	return o
end
			
--outputperceptron = perceptron

bolKeyPress = true				


function EstablishNetwork(numofinputs, numofhiddennodes)

	local p
	for i = 1,numofinputs do
		-- the +1 will give the bias an input (incorrectly) but we'll just ignore that
		p = inputperceptron:new()
		p.xpos = (75)
		p.ypos = (100 * i )
		
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

	-- assumes a single output nodes	--!
	p = perceptron:new()
	p.xpos = (275)
	p.ypos = (100 * 1 )	--!
	table.insert(nnetwork.outputlayer,p)
end

function ApplyActivation(unadjustedinput)
	--print("Applying activation on " .. unadjustedinput)
	if unadjustedinput > 0 then 
		return 1
	else 
		return 0
	end
end

function ExecuteForwardPass()
	
	--print("Executing forward pass")
	
	myinputvalue = {}
	myweightvalue = {}
	mysignalvalue = 0
	mytempresult = 0
	

	-- take all the equivalent input from the input layer and process every node in the hidden layer
	
	for i = 1,intNumberofHiddenNodes do	-- for each perceptron, ignoring any bias node
		
		
		for j = 1,intNumberofInputs do	-- for each input, ignoring bias node
		
			-- determine the input value from input joint.dampingRatio
			-- this is easy because there is only one input value
			-- the perceptron will receive multiple input values so store that in a list
			myinputvalue[i] = nnetwork.inputlayer[j].inputvalue		-- capture input value for input node j
			
						--print("For perceptron[".. i .. "], the input from inputron[" .. j .. "] is " .. myinputvalue[j])
						--print("Weight for input[" .. j .. "][" .. i .. "] is " .. nnetwork.inputlayer[j].weight[i])
			
			-- determine the weight that joins input[j] to this perceptron[i]
			-- the perceptron will receive multiple weights (one per input) so store that in a list 
			
			myweightvalue[i] = nnetwork.inputlayer[j].weight[i]		-- for input node j, capture weight 1 for p 1 and weight 2 for p 2 etc
																	--  for THIS perceptron (i) myweightvalue
				
						--print("For perceptron[" .. i .. "] the input for inputnode[" .. j .. "] is value " .. myinputvalue[i])
						--print("The weight coming into this perceptron is " .. myweightvalue[i])
						--print()
		end
		
		-- do the multiplication and summing bit
		local mytempresult = 0		
		for k = 1, #myinputvalue do
			mytempresult = mytempresult + (myinputvalue[k] * myweightvalue[k])
			--print("input value * weight = " .. myinputvalue[k] .. " * " .. myweightvalue[k] .. " = " .. myinputvalue[k] * myweightvalue[k])
			--print("sum of mytempresult = " .. mytempresult)
		end
		
		-- apply the hidden layer bias just once for this perceptron, remembering it's the same bias value for all nodes in this layer
		-- the bias node is the node hanging off the end of the layer: intNumberofHiddenNodes+1
		mytempresult = mytempresult + (nnetwork.hiddenlayer[intNumberofHiddenNodes + 1].weight * fltBias)
		
		-- do the activation function
		-- mytempresult = ApplyActivation(mytempresult)
		
		
		-- set the signal for this perceptron
		--print("The signal for perceptron[" .. i .. "] before assignment is " .. nnetwork.hiddenlayer[i].outsignal)
		nnetwork.hiddenlayer[i].outsignal = mytempresult
		--print("and is now " .. nnetwork.hiddenlayer[i].outsignal)

	end	

	-- take all the signal outputs and weights from every node in the hidden layer and feed that to the output node
	myinputvalue = nil
	myweightvalue = nil
	mytempresult = 0
	
	for m = 1, intNumberofHiddenNodes do
		-- a simple output * weight
		mytempresult = mytempresult + (nnetwork.hiddenlayer[m].outsignal * nnetwork.hiddenlayer[m].weight)
		--print(mytempresult)
	end
	-- add the bias for the output
	mytempresult = mytempresult + (nnetwork.outputlayer[1].weight * fltBias)
	
	-- set the network signal
	--print(mytempresult)
	nnetwork.outputlayer[1].outsignal = mytempresult
	
	-- done forward pass
	--print("Network signal strength is " .. nnetwork.outputlayer[1].outsignal)
	
	
end

function GetErrorRate(requiredtarget)
	return requiredtarget - nnetwork.outputlayer[1].outsignal
end


function ExecuteBackaPropagation(mytarget, networksignal)

	--print("===================")
	--print("Beginning back prop")
	--print("===================")
	--print("mytarget = " .. mytarget)
	--print("network signal = " .. networksignal)
	
	for i = 1, (intNumberofHiddenNodes) do	-- the bias is down later on
	
		--print("Hidden signal = " .. nnetwork.hiddenlayer[i].outsignal)
		
		myvalue = -(mytarget - networksignal) * networksignal * (1 - networksignal) * nnetwork.hiddenlayer[i].outsignal
		--print("Backpropping for P[" .. i .. "] with value " .. myvalue)
		nnetwork.hiddenlayer[i].weight = nnetwork.hiddenlayer[i].weight - myvalue
		--print("New weight for this P is now " .. nnetwork.hiddenlayer[i].weight)
	end
	
	-- the bias in the hidden layer needs to be updated
	--print("Hidden bias weight = " .. nnetwork.hiddenlayer[intNumberofHiddenNodes+1].weight)
	
	myvalue = -(mytarget - networksignal) * networksignal * (1 - networksignal) * nnetwork.hiddenlayer[intNumberofHiddenNodes+1].weight
	--print("Backpropping for P[" .. intNumberofHiddenNodes+1 .. "] with value " .. myvalue)
	nnetwork.hiddenlayer[intNumberofHiddenNodes+1].weight = nnetwork.hiddenlayer[intNumberofHiddenNodes+1].weight - myvalue
	--print("New weight for this P is now " .. nnetwork.hiddenlayer[intNumberofHiddenNodes+1].weight)
	
	
	
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
	
		local correctoutcome	-- for training
		
		nnetwork.inputlayer[1].inputvalue = 1
		nnetwork.inputlayer[2].inputvalue = 1
		correctoutcome = 1
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
		
		local errorrate = GetErrorRate(correctoutcome)
		print("Error rate is " .. errorrate)

		-- execute back prop	
		ExecuteBackaPropagation(correctoutcome, nnetwork.outputlayer[1].outsignal)
		
		-- wait for signal to proceeed to next iteration

	end
end

function love.draw()

	
	for i = 1, intNumberofInputs do
		love.graphics.setColor(222/255, 52/255, 235/255)
		love.graphics.circle("fill", nnetwork.inputlayer[i].xpos, nnetwork.inputlayer[i].ypos, 25)
	
		love.graphics.setColor(1, 1, 1)
		love.graphics.print(nnetwork.inputlayer[i].inputvalue,nnetwork.inputlayer[i].xpos - 20,nnetwork.inputlayer[i].ypos - 10)
	
		love.graphics.print(nnetwork.inputlayer[i].inputvalue,nnetwork.inputlayer[i].xpos - 20,nnetwork.inputlayer[i].ypos - 10)
	
	end
	
	
	
	for i = 1, intNumberofHiddenNodes do
		love.graphics.setColor(52/255, 235/255, 229/255)
		love.graphics.circle("fill", nnetwork.hiddenlayer[i].xpos, nnetwork.hiddenlayer[i].ypos, 25)
	
	
	end
	
	for i = 1, 1 do
		love.graphics.setColor(235/255, 164/255, 52/255)
		love.graphics.circle("fill", nnetwork.outputlayer[i].xpos, nnetwork.outputlayer[i].ypos, 25)
	
	
	end
	
	-- draw lines with weights for inputs to hidden nodes
	for i = 1, intNumberofInputs do
		for j = 1, intNumberofHiddenNodes do
			
			x1 = nnetwork.inputlayer[i].xpos
			y1 = nnetwork.inputlayer[i].ypos 
			x2 = nnetwork.hiddenlayer[j].xpos
			y2 = nnetwork.hiddenlayer[j].ypos
			
			love.graphics.setColor(1, 1, 1)
			love.graphics.line(x1,y1,x2,y2)
			
			-- draw the weight
			x3 = (x1 + (x2-x1)/2) - 20
			y3 = ((y1 + (y2-y1)/2) - 20) + (i * 10)
			love.graphics.setColor(1, 1, 1)			
			love.graphics.print(nnetwork.inputlayer[j].weight[j],x3,y3)			
		
		
		
		end

	end
	
	
	
	
end
































