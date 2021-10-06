local nn = {}

local function LoadInput(myarr)



end

function nn.GetDecision(v,myindex)

	local input1 = v.y		-- height		--250
	local input2 = v.angle
	local input2 = 0.5
	local input3 = v.vx
	local input4 = v.vy
	local input5 = v.speed
	local bias = 1 		-- bias
	
	--input1 = math.ceiling((gintLandY - input1) / 10)
	input1 =((gintLandY - input1) / 250)
	input4 = input4 / 2.1944	-- an attempt to normalise this input. 2.1941 is the maximum possible vy before crashing.
	
	if myindex == 2 then
		--print("inputs: " .. input4)
	end
	
	--if myindex == 1 then
		--print(myindex)
	--end

	-- this is the sigmoid function that converts all signals to 0 -> 1
	--signal = 1 / (1 + exp((signalSum * -1) / 1))
	
	-- calculate inputsum for H1 and H2
	local H1SignalSum = input1 * v.weights[1] + input2 * v.weights[2] + input3 * v.weights[3] + input4 * v.weights[4] + input5 * v.weights[5] + bias * v.weights[6]
	local H2SignalSum = input1 * v.weights[7] + input2 * v.weights[8] + input3 * v.weights[9] + input4 * v.weights[10] + input5 * v.weights[11] + bias * v.weights[12]
	local H3SignalSum = input1 * v.weights[13] + input2 * v.weights[14] + input3 * v.weights[15] + input4 * v.weights[16] + input5 * v.weights[17] + bias * v.weights[18]
	
	if myindex == 2 then
		--print("H1SS: " .. H1SignalSum, H2SignalSum, H3SignalSum)
	end	
	
	-- calculate output for H1 and H2 and H3
	-- softmax activation function 
	local eulersnumber = 2.71828
	local a = eulersnumber ^ H1SignalSum
	local b = eulersnumber ^ H2SignalSum
	local c = eulersnumber ^ H3SignalSum
	local mysum = a + b + 3
	local H1Output = a / mysum
	local H2Output = b / mysum
	local H3Output = c / mysum
	
	if myindex == 1 then
		--print(H1Output,H2Output,H3Output)
	end
	
	-- -- calculate output for H1 and H2
	-- -- sigmoid
	-- local H1Output = 1 / (1 + math.exp((H1SignalSum * -1) / 1))
	-- local H2Output = 1 / (1 + math.exp((H2SignalSum * -1) / 1))
	
	if myindex == 1 then
		-- print("H1O: " .. H1Output, "H2O: " .. H2Output)
	end		

	-- calculate inputsum for output1 and output2 and output3
	O1SignalSum = H1Output * v.weights[19] + H2Output * v.weights[20] + H3Output * v.weights[21] + bias * v.weights[22]
	O2SignalSum = H1Output * v.weights[23] + H2Output * v.weights[24] + H3Output * v.weights[25] + bias * v.weights[26]
	O3SignalSum = H1Output * v.weights[27] + H2Output * v.weights[28] + H3Output * v.weights[29] + bias * v.weights[30]
	
	--print(O1SignalSum,O2SignalSum,O3SignalSum)

	-- activate the three output signals (not sure why!)
	O1Output = 1 / (1 + math.exp((O1SignalSum * -1) / 1))
	O2Output = 1 / (1 + math.exp((O2SignalSum * -1) / 1))
	O3Output = 1 / (1 + math.exp((O3SignalSum * -1) / 1))
	
	if myindex == 1 then
		--print(O1Output,O2Output,O3Output)
	end	
	
	v.output1 = O1Output
	v.output2 = O2Output
	v.output3 = O3Output

	if myindex == 1 then
		--print(v.output1,O2Output,O3Output)
	end	

	-- determine decision
	if O1Output > O2Output and O1Output > O3Output then
		return 1
	elseif O2Output >= O1Output and O2Output >= O3Output then
		return 2
	elseif O3Output >= O1Output and O3Output >= O2Output then
		return 3
	else
		--print("Error: " .. O1Output, O2Output, O3Output)
		return 0
	end	
	

end


return nn