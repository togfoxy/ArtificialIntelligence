

-- AND
inputs = {}
CorrectTarget = 0
weights = {}
perceptron1 = {}
perceptron2 = {}
output1 = {}
	
InputWeightDelta = {}
InputWeightDelta[1] = {0,0}
InputWeightDelta[2] = {0,0}

intNextPrintLine = 10
intLineSpacing = 11

bolYKey = false
bolNKey = false
bolGKey = false
bolFKey = false

mycounter = 1


function sigmoid(inputstrength)
	 return 1 / (1 + math.exp(-inputstrength / 1))
end

function SetPerceptron1Output()
	-- will return 0 or 1 (which is NOT false/true)
	-- perceptron is the hidden layer perceptron
	mysignalstrength = ((inputs[1] * weights[1][1]) + (inputs[2] * weights[2][1])) - perceptron1.threshold
	--print (mysignalstrength)
	perceptron1.signal = sigmoid(mysignalstrength)
	
	--print (inputs[1])
	--print (weights[1][1])
	--print (inputs[2])
	--print (weights[2][1])
	--print (perceptron1.threshold)
	--print (perceptron1.signal)
	--print ("=====")
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
	-- myoutput is the signal of the current perceptron under review

	local learningrate = 1	-- can change this later
	
	alpha = (myoutput - mytarget) -- *-1
	
	beta = myoutput * ( 1- myoutput) 
	
	charlie = -(mytarget - myoutput) * myoutput * (1 - myoutput)* myinputweight
	
	print("alpha is " .. alpha)
	print("beta is " .. beta)
	print("charlie is " .. charlie)
	
	myvalue = (alpha * beta * charlie * learningrate)
	print(myvalue)
	return myvalue
end

function ApplyDeltaToAllWeights()

	--print("Before delta applied: W1 = " .. weights[1][1])
	weights[1][1] = weights[1][1] + InputWeightDelta[1][1]
	weights[1][2] = weights[1][2] + InputWeightDelta[1][2]
	weights[2][1] = weights[2][1] + InputWeightDelta[2][1]
	weights[2][2] = weights[2][2] + InputWeightDelta[2][2]
	
	-- print ("p1 delta = " .. perceptron1.weightdelta)
	perceptron1.weight = perceptron1.weight + perceptron1.weightdelta
	perceptron2.weight = perceptron2.weight + perceptron2.weightdelta
	
	--print("After delta applied: W1 = " .. weights[1][1])

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
	if key == "f" then
		bolFKey = not bolFKey
	end
	
end

function love.load()
	
	inputs = {0,0}	-- must be zero or one
	


	
	-- these are input weights
	weights[1] = {love.math.random(1,100)/100, love.math.random(1,100)/100}
	weights[2] = {love.math.random(1,100)/100, love.math.random(1,100)/100}
	
	--weights[1] = {6, 6}
	--weights[2] = {6, 6}	
	
	perceptron1.threshold = 0.5	-- ?
	perceptron1.weight = 0.5 --love.math.random(1,100)/100	-- in this topography, there is only one signal going to one output so only need one weight.

	perceptron2.threshold = 0.5 -- ?
	perceptron2.weight = 0.5 -- love.math.random(1,100)/100

	--perceptron1.weight = 6
	--perceptron2.weight = 6
	
	perceptron1.signal = 0	-- off by default
	perceptron2.signal = 0 	-- off by default

	output1.threshold = 0.5	--?
	output1.signal = 0		-- off by default
	
	-- randomise the input
	--local q = love.math.random(0,1)
	--local w = love.math.random(0,1)
	--inputs[1] = q
	--inputs[2] = w
	
	-- for each input, define the required target
	-- this is AND
	if inputs[1] == 1 and inputs[2] == 1 then
		CorrectTarget = 1
	else
		CorrectTarget = 0
	end

	void = love.window.setMode(600, 500)
	love.window.setTitle("Love ANN")
	

end

function love.update(dt)

	SetOutputSignal()
	
	intNextPrintLine = 10
	
	if bolYKey then
		print("Yes!!")
	end
	if bolGKey then
		mycounter = 0
	end
	
	if bolGKey or bolFKey then
	--if mycounter > 0 then
		
		--print("Signal for first perceptron is " .. perceptron1.signal .. " and the weight is " .. perceptron1.weight)
		--print("Initiating backprop for first perceptron.")
		delta = GetBackPropDeltaOnePerceptron(output1.signal,CorrectTarget,perceptron1.weight)
		--print("Delta calculated to be " .. delta)
		perceptron1.weightdelta = delta
		--print()
		
		--print("Signal for second perceptron is " .. perceptron2.signal .. " and the weight is " .. perceptron2.weight)
		--print("Initiating backprop for second perceptron.")
		delta = GetBackPropDeltaOnePerceptron(output1.signal,CorrectTarget,perceptron2.weight)
		--print("Delta calculated to be " .. delta)
		perceptron2.weightdelta = delta
		--print()

		--print("Signal for input[1] (1) is " .. inputs[1] .. " and the weight is " .. weights[1][1])
		--print("Initiating backprop for input[1].")
		delta = GetBackPropDeltaOnePerceptron(perceptron1.signal,CorrectTarget,weights[1][1])
		--print("Delta calculated to be " .. delta)
		InputWeightDelta[1][1] = delta
		--print()		
		
		--print("Signal for input[1] (2) is " .. inputs[1] .. " and the weight is " .. weights[1][2])
		--print("Initiating backprop for input[1] (2).")
		delta = GetBackPropDeltaOnePerceptron(perceptron1.signal,CorrectTarget,weights[1][2])
		--print("Delta calculated to be " .. delta)
		InputWeightDelta[1][2] = delta
		--print()			
		
		--print("Signal for input[2] (1) is " .. inputs[2] .. " and the weight is " .. weights[2][1])
		--print("Initiating backprop for input[2] (1).")
		delta = GetBackPropDeltaOnePerceptron(perceptron1.signal,CorrectTarget,weights[2][1])
		--print("Delta calculated to be " .. delta)
		InputWeightDelta[2][1] = delta
		--print()			
				
		--print("Signal for input[2] (2) is " .. inputs[2] .. " and the weight is " .. weights[2][2])
		--print("Initiating backprop for input[2] (2).")
		delta = GetBackPropDeltaOnePerceptron(perceptron1.signal,CorrectTarget,weights[2][2])
		--print("Delta calculated to be " .. delta)
		InputWeightDelta[2][2] = delta
		--print()			
						
		ApplyDeltaToAllWeights()
		
		-- randomise the input
		--local q = love.math.random(0,1)
		--local w = love.math.random(0,1)
		--inputs[1] = q
		--inputs[2] = w
	
		-- for each input, define the required target
		-- this is AND
		if inputs[1] == 1 and inputs[2] == 1 then
			CorrectTarget = 1
		else
			CorrectTarget = 0
		end

		mycounter = mycounter +1
	end
	
	-- reset keys for next round
	bolYKey = false
	bolNKey = false
	bolGKey = false
	

end

function round(num, idp)
	--Input: number to round; decimal places required
	return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end	


function love.draw()

	--love.graphics.print("Hello world", 10,10)

	

	love.graphics.print("Input 1: " .. inputs[1] .. " Weight 1->1: " .. round(weights[1][1],5) .. " Weight 1->2: " .. round(weights[1][2],5),10,intNextPrintLine)
	intNextPrintLine = intNextPrintLine + intLineSpacing
	
	love.graphics.print("Input 2: " .. inputs[2] .. " Weight 2->1: " .. round(weights[2][1],5) .. " Weight 2->2: " .. round(weights[2][2],5),10,intNextPrintLine)
	intNextPrintLine = intNextPrintLine + intLineSpacing
	intNextPrintLine = intNextPrintLine + intLineSpacing
	
	love.graphics.print("Perceptron weights", 10, intNextPrintLine)
	intNextPrintLine = intNextPrintLine + intLineSpacing	
	
	love.graphics.print(round(perceptron1.weight,5), 10, intNextPrintLine)
	intNextPrintLine = intNextPrintLine + intLineSpacing
	
	love.graphics.print(round(perceptron2.weight,5), 10, intNextPrintLine)
	intNextPrintLine = intNextPrintLine + intLineSpacing
	intNextPrintLine = intNextPrintLine + intLineSpacing
	
	love.graphics.print("The correct target for this input is " .. CorrectTarget, 10, intNextPrintLine)
	intNextPrintLine = intNextPrintLine + intLineSpacing	
	
	intNextPrintLine = intNextPrintLine + intLineSpacing
	love.graphics.print("NN signal is " .. output1.signal, 10,intNextPrintLine)
	intNextPrintLine = intNextPrintLine + intLineSpacing
	
	
	
	love.graphics.print("Error size is " .. Errorsize(CorrectTarget,output1.signal), 10, intNextPrintLine)
	intNextPrintLine = intNextPrintLine + intLineSpacing
	
	intNextPrintLine = intNextPrintLine + intLineSpacing
	love.graphics.print("Press 'G' for another iteration.",10,intNextPrintLine)
	intNextPrintLine = intNextPrintLine + intLineSpacing
	
	--print("Enter the amount of hidden layers in Neural Network (recommended|1) : ")
	--hiddenLayers = tonumber(io.stdin:read())
end

