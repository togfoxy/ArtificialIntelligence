

-- AND
inputs = {}
weights = {}
perceptron1 = {}
perceptron2 = {}
output1 = {}
	
local InputWeightDelta = {}
InputWeightDelta[1] = {0,0}
InputWeightDelta[2] = {0,0}

ACTIVATION_RESPONSE = 1

intNextPrintLine = 10
intLineSpacing = 11

bolYKey = false
bolNKey = false
bolGKey = false


function sigmoid(x)

	return 1 / (1 + math.exp(-x / ACTIVATION_RESPONSE))

end

function SetPerceptron1Output()
	-- will return 0 or 1 (which is NOT false/true)
	-- perceptron is the hidden layer perceptron
	perceptron1.signal = sigmoid(inputs[1] * weights[1][1] + inputs[2] * weights[2][1] - perceptron1.threshold)
	
end

function SetPerceptron2Output()
	
	perceptron2.signal = sigmoid(inputs[1] * weights[1][2] + inputs[2] * weights[2][2] - perceptron2.threshold)
	
end

function SetOutputSignal()

	-- set perceptron signals based on inputs and weights and the perceptron threshold
	SetPerceptron1Output()
	SetPerceptron2Output()
	
	-- set the output signal based on perceptron outputs and weights and the output threshold
	output1.signal = sigmoid(perceptron1.signal * perceptron1.weight + perceptron2.signal * perceptron2.weight - output1.threshold)
end

function Errorsize(mytarget,myoutput)

	return (0.5 * (mytarget - myoutput)^2)

end


function GetBackPropDeltaOnePerceptron(myoutput,mytarget,myinputweight)
	-- the output has sent a signal and that signal will have an error rate
	-- determine the delta weight for the first input into that output

	local learningrate = 1	-- can change this later
	
	alpha = myoutput - mytarget
	
	beta = myoutput * ( 1- myoutput) 
	
	charlie = -(mytarget - myoutput) * myoutput * (1 - myoutput)* myinputweight
	
	--print("alpha is " .. alpha)
	--print("alpha is " .. beta)
	--print("alpha is " .. charlie)
	
	myvalue = (alpha * beta * charlie * learningrate)
	--print(myvalue)
	return myvalue
end

function ApplyDeltaToAllWeights()

	weights[1][1] = weights[1][1] + InputWeightDelta[1][1]
	weights[1][2] = weights[1][2] + InputWeightDelta[1][2]
	weights[2][1] = weights[2][1] + InputWeightDelta[2][1]
	weights[2][2] = weights[2][2] + InputWeightDelta[2][2]
	
	perceptron1.signal = perceptron1.signal + perceptron1.weightdelta
	perceptron2.signal = perceptron2.signal + perceptron2.weightdelta
	

end

function love.keyreleased(key)
   if key == "y" then
      bolYKey = true
   end
   if key == "n" then
      bolNKey = true
   end
   if key == "g" then
		bolGKey = true
	end
end

function love.load()
	
	inputs = {1,1}	-- must be zero or one
	
	-- these are input weights
	weights[1] = {love.math.random(0,100) / 100, love.math.random(0,100) / 100}
	weights[2] = {love.math.random(0,100) / 100, love.math.random(0,100) / 100}
	
	perceptron1.threshold = 0.5	-- ?
	perceptron1.weight = 0.5	-- in this topography, there is only one signal going to one output so only need one weight.

	perceptron2.threshold = 0.5 -- ?
	perceptron2.weight = 0.5

	perceptron1.signal = 0	-- off by default
	perceptron2.signal = 0 	-- off by default

	output1.threshold = 0.5	--?
	output1.signal = 0		-- off by default

	void = love.window.setMode(600, 500)
	love.window.setTitle("Love ANN")
	

end

function love.update(dt)

	SetOutputSignal()
	
	intNextPrintLine = 10
	
	if bolYKey then
		print("Yes!!")
	end
	if bolNKey then
		print("Yes!!")
		
	end
	

	
	if bolGKey then
		
		print("Signal for first perceptron is " .. perceptron1.signal .. " and the weight is " .. perceptron1.weight)
		print("Initiating backprop for first perceptron.")
		delta = GetBackPropDeltaOnePerceptron(output1.signal,1,perceptron1.weight)
		print("Delta calculated to be " .. delta)
		perceptron1.weightdelta = delta
		print()
		
		print("Signal for second perceptron is " .. perceptron2.signal .. " and the weight is " .. perceptron2.weight)
		print("Initiating backprop for second perceptron.")
		delta = GetBackPropDeltaOnePerceptron(output1.signal,1,perceptron2.weight)
		print("Delta calculated to be " .. delta)
		perceptron2.weightdelta = delta
		print()

		print("Signal for input[1] (1) is " .. inputs[1] .. " and the weight is " .. weights[1][1])
		print("Initiating backprop for input[1].")
		delta = GetBackPropDeltaOnePerceptron(perceptron1.signal,1,weights[1][1])
		print("Delta calculated to be " .. delta)
		InputWeightDelta[1][1] = delta
		print()		
		
		print("Signal for input[1] (2) is " .. inputs[1] .. " and the weight is " .. weights[1][2])
		print("Initiating backprop for input[1] (2).")
		delta = GetBackPropDeltaOnePerceptron(perceptron1.signal,1,weights[1][2])
		print("Delta calculated to be " .. delta)
		InputWeightDelta[1][2] = delta
		print()			
		
		print("Signal for input[2] (1) is " .. inputs[2] .. " and the weight is " .. weights[2][1])
		print("Initiating backprop for input[2] (1).")
		delta = GetBackPropDeltaOnePerceptron(perceptron1.signal,1,weights[2][1])
		print("Delta calculated to be " .. delta)
		InputWeightDelta[2][1] = delta
		print()			
				
		print("Signal for input[2] (2) is " .. inputs[2] .. " and the weight is " .. weights[2][2])
		print("Initiating backprop for input[2] (2).")
		delta = GetBackPropDeltaOnePerceptron(perceptron1.signal,1,weights[2][2])
		print("Delta calculated to be " .. delta)
		InputWeightDelta[2][2] = delta
		print()			
						
		ApplyDeltaToAllWeights()

	end
	
	-- reset keys for next round
	bolYKey = false
	bolNKey = false
	bolGKey = false
	

end


function love.draw()

	--love.graphics.print("Hello world", 10,10)

	
	for i = 1,2 do
		love.graphics.print("Inputs",10,intNextPrintLine)
		intNextPrintLine = intNextPrintLine + intLineSpacing
		
		love.graphics.print(inputs[i],10,intNextPrintLine)
		intNextPrintLine = intNextPrintLine + intLineSpacing
		intNextPrintLine = intNextPrintLine + intLineSpacing	
		
		love.graphics.print("Weights", 10, intNextPrintLine)
		intNextPrintLine = intNextPrintLine + intLineSpacing
		
		love.graphics.print(weights[i], 10, intNextPrintLine)
		intNextPrintLine = intNextPrintLine + intLineSpacing
	end
	-- print(weights[1][1])
	
	intNextPrintLine = intNextPrintLine + intLineSpacing
	love.graphics.print("NN prediction %", 10,intNextPrintLine)
	intNextPrintLine = intNextPrintLine + intLineSpacing
	
	love.graphics.print(output1.signal, 10, intNextPrintLine)
	intNextPrintLine = intNextPrintLine + intLineSpacing
	
	intNextPrintLine = intNextPrintLine + intLineSpacing
	love.graphics.print("Is this preciction correct?",10,intNextPrintLine)
	intNextPrintLine = intNextPrintLine + intLineSpacing
	
	--print("Enter the amount of hidden layers in Neural Network (recommended|1) : ")
	--hiddenLayers = tonumber(io.stdin:read())
end

