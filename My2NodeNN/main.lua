
lr = 1
bias = 1

Input1 = {}

Input1.weights = {love.math.random(1,100)/100,love.math.random(1,100)/100,love.math.random(1,100)/100}	--input 1 has 2 weights

Input2 = {}
Input2.weights = {love.math.random(1,100)/100,love.math.random(1,100)/100,love.math.random(1,100)/100}	--input 2 has 2 weights

Perceptron1 = {}
Perceptron1.biasweight = love.math.random(1,100)/100

Perceptron2 = {}
Perceptron2.biasweight = love.math.random(1,100)/100

Output1 = {}
Output1.biasweight = love.math.random(1,100)/100

function UpdatePerceptron(myInput1, myInput2, myPerceptron, target)

	myvalue = myInput1.value*myInput1.weights[1] + myInput2.value*myInput2.weights[1] + bias*myPerceptron.biasweight
	if myvalue > 0 then 
		myvalue = 1
	else
		myvalue = 0
	end	

	errorrate = target - myvalue
	myInput1.weights[1] = myInput1.weights[1] + errorrate * myInput1.value * lr
	myInput2.weights[1] = myInput2.weights[1] + errorrate * myInput2.value * lr
	myPerceptron.biasweight = myPerceptron.biasweight + errorrate * bias * lr
	
	
end




function Perceptron1(input1, input2, target)

	outputP = input1*weights[1] + input2*weights[2] + bias*weights[3]
	if outputP > 0 then 
		outputP = 1
	else
		outputP = 0
	end
	
	errorrate = target - outputP
	weights[1] = weights[1] + errorrate * input1 * lr
	weights[2] = weights[2] + errorrate * input2 * lr
	weights[3] = weights[3] + errorrate * bias * lr
	
	return outputP
end

function love.load()

	void = love.window.setMode(600, 500)
	love.window.setTitle("Love ANN")
		
	for i = 1,50 do
	
		Input1.value = 1
		Input2.value = 1
		UpdatePerceptron(Input1,Input2,Output1,1)	-- 4th param is the target
		
		Input1.value = 1
		Input2.value = 0
		UpdatePerceptron(Input1,Input2,Output1,0)		
		
		Input1.value = 0
		Input2.value = 1
		UpdatePerceptron(Input1,Input2,Output1,0)		
		
		Input1.value = 0
		Input2.value = 0
		UpdatePerceptron(Input1,Input2,Output1,0)

	end

	print("Enter x: ")
	x = tonumber(io.stdin:read())

	print("Enter y: ")
	y = tonumber(io.stdin:read())

	outputP = x*Input1.weights[1] + y*Input2.weights[1] + bias*Output1.biasweight


	if outputP > 0 then
	   outputP = 1
	else 
	   outputP = 0
	end
	print(x .. " and " .. y .. " is : " .. outputP)
	print()
	print(Input1.weights[1],Input2.weights[1],Output1.biasweight)	
	
	
end










