

intNumberofInputs = 2

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
	
	-- there will be 1 weight per hidden perceptron	--! need to make this scalable.
	o.weight = {}
    o.weight[1] = love.math.random(0,100)/100
    o.weight[2] = love.math.random(0,100)/100
    o.weight[3] = love.math.random(0,100)/100
	return o
end


perceptron = {biasweight = 0,	-- this will be initialised to a random value
				outsignal = 0
			}
perceptron.__index = perceptron
			
function perceptron:new(o)
	o = o or {}
	setmetatable(o,self)
	self.__index = self
	self.outsignal = 0
	self.biasweight = math.random(0.1,0.9)
	return o

end
			
--outputperceptron = perceptron

bolKeyPress = false				


function EstablishNetwork(numofinputs, numofhiddennodes)

	local p
	for i = 1,numofinputs do
		p = inputperceptron:new()
		
		--print("My weights for p" .. i .. " after calling new()")
		--print(p.weight[1],p.weight[2],p.weight[3])
		
		table.insert(nnetwork.inputlayer,p)
		
		--print("My weights for p" .. i .. " in the network after calling new()")
		--print(nnetwork.inputlayer[i].weight[1],nnetwork.inputlayer[i].weight[2],nnetwork.inputlayer[i].weight[3])
		
	end
	
	for i = 1,numofhiddennodes do
		p = perceptron:new()
		table.insert(nnetwork.hiddenlayer,p)
	end	

	print("Inputs")
	print(nnetwork.inputlayer[1].inputvalue)
	print(nnetwork.inputlayer[2].inputvalue)
	print(nnetwork.inputlayer[1].inputvalue)
	print()
	
	print("Weights")
	print(nnetwork.inputlayer[1].weight[1],nnetwork.inputlayer[1].weight[2])
	print(nnetwork.inputlayer[2].weight[1],nnetwork.inputlayer[2].weight[2])	
end

function ExecuteForwardPass()
	
	print("Executing forward pass")
	
	myinputvalue = {}
	myweightvalue = {}
	mysignalvalue = 0

	-- take all the equivalent input from the input layer
	
	for i = 1,#nnetwork.hiddenlayer do	-- for each perceptron
		for j = 1,#nnetwork.inputlayer do	-- for each input
		
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
				
			-- print("For perceptron[" .. i .. "] the input for inputnode[" .. j .. "] is value " .. myinputvalue[i])
			-- print("The weight coming into this perceptron is " .. myweightvalue[i])
			-- print()
		end

	end	
	
	-- output the pairs for checking
	for k = 1, #myinputvalue do
		print(myinputvalue[k],myweightvalue[k])

	end
	
	
	

	-- do the summing bit
	-- do the activation function
	-- set the signal for this perceptron
	
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
































