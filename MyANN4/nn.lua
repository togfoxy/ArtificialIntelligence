local nn = {}



function nn.GetDecision(bot,myindex)
-- 2 2 2 network

	-- get centre of tank
	local centrex = gintScreenWidth / 2
	local centrey = gintScreenHeight / 2
	
	local botx = bot.body:getX()		-- x axis
	local boty = bot.body:getY()		-- y axis

	-- inputs are distance from the origin
	local input1 = botx - centrex
	local input2 = boty - centrey
	local bias = 1 		-- bias
	
	-- normalise the inputs
	input1 = input1 / gintScreenWidth
	input2 = input2 / gintScreenWidth
	
	if myindex == 1 then
		--print("inputs: " .. input1, input2)
	end
	
	-- this is the sigmoid function that converts all signals to 0 -> 1
	--signal = 1 / (1 + exp((signalSum * -1) / 1))
	
	-- calculate inputsum for H1 and H2
	local H1SignalSum = input1 * bot.weights[1] + input2 * bot.weights[3] + bias * bot.weights[5]
	local H2SignalSum = input1 * bot.weights[2] + input2 * bot.weights[4] + bias * bot.weights[6]

	if myindex == 1 then
		--print("H1SS: " .. H1SignalSum, H2SignalSum)
	end	
	
	-- calculate output for H1 and H2
	-- softmax activation function 
	local eulersnumber = 2.71828
	local a = eulersnumber ^ H1SignalSum
	local b = eulersnumber ^ H2SignalSum
	local c = a + b
	local H1Output = a / c
	local H2Output = b / c
	
	if myindex == 1 then
		-- print(a, c, H1Output)
	end
	
	-- -- calculate output for H1 and H2
	-- -- sigmoid
	-- local H1Output = 1 / (1 + math.exp((H1SignalSum * -1) / 1))
	-- local H2Output = 1 / (1 + math.exp((H2SignalSum * -1) / 1))
	
	if myindex == 1 then
		-- print("H1O: " .. H1Output, "H2O: " .. H2Output)
	end		

	-- calculate inputsum for output1 and output2 and output3
	O1SignalSum = H1Output * bot.weights[7] + H2Output * bot.weights[10] + bias * bot.weights[13]
	O2SignalSum = H1Output * bot.weights[8] + H2Output * bot.weights[11] + bias * bot.weights[14]
	O3SignalSum = H1Output * bot.weights[9] + H2Output * bot.weights[12] + bias * bot.weights[15]
	
--print(O1SignalSum,O2SignalSum,O3SignalSum)

	-- activate the three output signals (not sure why!)
	O1Output = 1 / (1 + math.exp((O1SignalSum * -1) / 1))
	O2Output = 1 / (1 + math.exp((O2SignalSum * -1) / 1))
	O3Output = 1 / (1 + math.exp((O3SignalSum * -1) / 1))
	
	if myindex == 1 then
		-- print(O1Output,O2Output,O3Output)
	end	
	
	bot.output1 = O1Output
	bot.output2 = O2Output
	bot.output3 = O3Output
	
	-- -- judge if right move
	-- if ((input1 < 0 and bot.output1 > 0) or
		-- (input1 > 0 and bot.output1 < 0)) and
		-- ((input2 < 0 and bot.output2 > 0) or
		-- (input2 > 0 and bot.output2 < 0)) then
		-- -- good move
		-- table.insert(garrGoodPool, bot.weights)
		-- print("Good pool size = " .. #garrGoodPool)
	-- end

-- print(O1Output,O2Output,O3Output)

	-- determine decision
	if O1Output > O2Output and O1Output > O3Output then
		return 0
	elseif O2Output >= O1Output and O2Output >= O3Output then
		return 1
	elseif O3Output >= O1Output and O3Output >= O2Output then
		return 2
	else
		print("Error: " .. O1Output, O2Output, O3Output)
		return 0
	end	
	

end


return nn