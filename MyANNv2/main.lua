

intNumberofInputs = 2
intNumberofHiddenNodes = 2
fltLearningRate = 1
fltBias = 1

nnetwork = {}
nnetwork.inputlayer = {}	-- a list of input perceptrons
nnetwork.hiddenlayer = {}	-- a list of perceptrons
nnetwork.outputlayer = {}	-- a list of one perceptron

-- this is a class that can be re-used
inputperceptron = {inputvalue = 0,		
					weight = {} 	-- there will eventually be one weight per hidden p
					}
inputperceptron.__index = inputperceptron
					
function inputperceptron:new(o)
	o = o or {}
	setmetatable(o,self)

	o.inputvalue = 0
	
	-- this input perceptron will have 1 weight per hidden perceptron	--! need to make this scalable.
	o.weight = {}
	for i = 1, (intNumberofHiddenNodes) do
		o.weight[i] = love.math.random(0,100)/100	-- random number between 0 and 1
	end
	return o
end


perceptron = {weight = 0,		-- the next forward layer will apply this weight to the outsignal. Assumes one output
				biasweight = 0,	-- this will be initialised to a random value
				outsignal = 0
			}
perceptron.__index = perceptron
			
function perceptron:new(o)
	o = o or {}
	setmetatable(o,self)
	self.__index = self
	self.outsignal = 0
	self.weight = 0
	self.biasweight = love.math.random(0,100)/100	-- random number between 0 and 1. This is assigned to every perceptron but only the LAST perceptron is considered teh bias.
	return o
end
			
--outputperceptron = perceptron

bolKeyPress = false				


function EstablishNetwork(numofinputs, numofhiddennodes)

	local p
	for i = 1,numofinputs do
		-- the +1 will give the bias an input (incorrectly) but we'll just ignore that
		p = inputperceptron:new()
		
		--print("My weights for p" .. i .. " after calling new()")
		--print(p.weight[1],p.weight[2],p.weight[3])
		
		table.insert(nnetwork.inputlayer,p)
		
		--print("My weights for p" .. i .. " in the network after calling new()")
		--print(nnetwork.inputlayer[i].weight[1],nnetwork.inputlayer[i].weight[2],nnetwork.inputlayer[i].weight[3])
		
	end
	
	for i = 1,(numofhiddennodes + 1) do		-- the +1 is for the bias that is applied at the hidden layer
		p = perceptron:new()
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

	-- assumes a single output nodes
	p = perceptron:new()
	table.insert(nnetwork.outputlayer,p)
end

function ApplyActivation(unadjustedinput)
	print("Applying activation on " .. unadjustedinput)
	if unadjustedinput > 0 then 
		return 1
	else 
		return 0
	end
end

function ExecuteForwardPass()
	
	print("Executing forward pass")
	
	myinputvalue = {}
	myweightvalue = {}
	mysignalvalue = 0
	

	-- take all the equivalent input from the input layer
	
	for i = 1,intNumberofHiddenNodes do	-- for each perceptron, ignoring any bias node
		local mytempresult = 0
		
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
				
						print("For perceptron[" .. i .. "] the input for inputnode[" .. j .. "] is value " .. myinputvalue[i])
						print("The weight coming into this perceptron is " .. myweightvalue[i])
						print()
		end
		
		-- do the multiplication and summing bit		
		for k = 1, #myinputvalue do
			print("input value * weight = " .. myinputvalue[k] .. " * " .. myweightvalue[k])
			mytempresult = mytempresult + (myinputvalue[k] * myweightvalue[k])
			print("mytempresult = " .. mytempresult)
		end
		
		-- apply the bias just once for this perceptron, remembering it's the same bias value for all nodes in this layer
		-- the bias node is the node hanging off the end of the layer: intNumberofHiddenNodes+1
		mytempresult = mytempresult + (nnetwork.hiddenlayer[intNumberofHiddenNodes+1].biasweight * fltBias)
		
		-- do the activation function
		mytempresult = ApplyActivation(mytempresult)
		print(mytempresult)
		
		-- set the signal for this perceptron
		print("The signal for perceptron[" .. i .. "] before assignment is " .. nnetwork.hiddenlayer[i].outsignal)
		nnetwork.hiddenlayer[i].outsignal = mytempresult
		print("and is now " .. nnetwork.hiddenlayer[i].outsignal)

	end	


	
end

function love.keypressed(key, scancode, isrepeat)
	bolKeyPress = true
end

function love.load()

	void = love.window.setMode(60, 50)
	love.window.setTitle("Love Classes")
	
	EstablishNetwork(2,2)
end

function love.update(dt)

	local correctoutcome	-- for training
	
	-- load inputs into input layer
	for i = 1,intNumberofInputs do
		print("Enter input #" .. i)
		
		-- these next two lines are syntacially the same. Left here for learning.
		--nnetwork.inputlayer[i].setinputvalue(nnetwork.inputlayer[i],tonumber(io.stdin:read()))
		nnetwork.inputlayer[i].inputvalue = (tonumber(io.stdin:read()))
		--print(nnetwork.inputlayer[i].inputvalue)
	end
	
	--	get outs for training purposes
	print("Enter the correct outcome: ")
	correctoutcome = tonumber(io.stdin:read())
	
	-- execute 1 forward pass
	ExecuteForwardPass()
	
	
	
	

		-- output signal strength and error rate
		-- execute back prop
	
	-- wait for signal to proceeed to next iteration
	repeat
	until bolKeyPress
		
		
		


end

function love.draw()

end
































