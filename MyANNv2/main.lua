

intNumberofInputs = 2

nnetwork = {}
nnetwork.inputlayer = {}	-- a list of input perceptrons
nnetwork.hiddenlayer = {}	-- a list of perceptrons
nnetwork.outputlayer = {}	-- a list of one perceptron

-- this needs to be a class that can be re-used
inputperceptron = {inputvalue = 0,		
					weight = {} 	-- there will eventually be one weight per hidden p
					}
					
function inputperceptron:new(o)
	o = o or {}
	setmetatable(o,self)
	self.__index = self
	self.inputvalue = love.math.random(0,9)		-- a silly random number for testing
	-- self.weight = ??	-- there will be 1 weight per hidden perceptron
	return o
end

perceptron = {biasweight = 0,
				outsignal = 0
			}
			
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
		table.insert(nnetwork.inputlayer,p)
	end
	
	for i = 1,numofhiddennodes do
		p = perceptron
		table.insert(nnetwork.hiddenlayer,p)
	end	
end

function ExecuteForwardPass()
	
	print("Executing forward pass")
	myinputvalue = {}
	myweightvalue = {}
	mysignalvalue = 0

	-- take all the equivalent input  from the input layer	
	-- for each perceptron in hidden layer
	for i = 1,#nnetwork.hiddenlayer do	-- for each perceptron
		for j = 1,#nnetwork.inputlayer do	-- for each input
		
			-- for each input node, do the following for this perceptron
			myinputvalue[j] = nnetwork.inputlayer[j].inputvalue		-- capture input node X input value
			
			-- print("For perceptron[".. i .. "], the input from inputron[" .. j .. "] is " .. myinputvalue[j])
			
			-- weights will be nil when initialised because we don't know how many hidden layers exist
			-- this is where we know how many layers we have so initialise them here if necessary
			if nnetwork.inputlayer[j].weight[i] == nil then		-- this is Weight i/j or input i pointing to p j
				math.randomseed(os.time())
				nnetwork.inputlayer[j].weight[i] = love.math.random(0,100)/100
				print(nnetwork.inputlayer[j].weight[i])
			end
			
			myweightvalue[j] = nnetwork.inputlayer[j].weight[i]		-- for input node X, capture weight 1 for p 1 and weight 2 for p 2 etc
			print("For perceptron[" .. i .. "] the myweightvalue[" .. j .. "] = " .. myweightvalue[j])
			
			-- now, for input X, we have a input/weight pair
			--for k = 1, #myinputvalue do
			--	print("Input " .. myinputvalue[k] .. " has weight " .. myweightvalue[k])
			--end
			
			
			
			
			
			
			
			
			
		end

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
































