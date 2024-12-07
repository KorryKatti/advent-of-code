
local function evaluateExpression(elements, operators)
    local nums = {}
    for i, element in ipairs(elements) do
        nums[i] = tonumber(element)
        if not nums[i] then
            print("Error: Invalid number '" .. element .. "'")
            return nil
        end
    end

    
    local result = nums[1]
    for i = 1, #operators do
        local nextNum = nums[i + 1]
        if operators[i] == "+" then
            result = result + nextNum
        elseif operators[i] == "*" then
            result = result * nextNum
        else
            print("Error: Invalid operator '" .. operators[i] .. "'")
            return nil
        end
    end
    return result
end

local function generateCombinations(operators, n)
    local combinations = {}
    local function helper(current, depth)
        if depth > n then
            table.insert(combinations, current)
            return
        end
        for _, op in ipairs(operators) do
            helper(current .. op, depth + 1)
        end
    end
    helper("", 1)
    return combinations
end

local totalSum = 0

local countedLefts = {}

-- Open the file in read mode
local file = io.open("input.txt", "r")


for line in file:lines() do
    local left, right = string.match(line, "^(.-):(.*)$")
    if left and right then
        left = tonumber(left)  -- Convert the left side to a number
        local elements = {}
        for word in string.gmatch(right, "%S+") do
            table.insert(elements, word)
        end

        -- Generate all combinations of operators
        local operators = {"+", "*"}
        local operatorCombinations = generateCombinations(operators, #elements - 1)

        -- Try each combination
        local found = false
        print("Processing line: " .. line)
        for _, combination in ipairs(operatorCombinations) do
            local operatorList = {}
            for char in string.gmatch(combination, ".") do
                table.insert(operatorList, char)
            end

            -- Evaluate the expression
            local result = evaluateExpression(elements, operatorList)
            if result and result == left then
                --  add the left value to the sum if it hasn't been added before
                if not countedLefts[left] then
                    print("Match found! " .. left .. " = " .. elements[1])
                    for i = 1, #operatorList do
                        io.write(" " .. operatorList[i] .. " " .. elements[i + 1])
                    end
                    print("")
                    totalSum = totalSum + left
                    countedLefts[left] = true  -- Mark this left value as counted
                end
                found = true
            end
        end

        if not found then
            print("No valid combinations found for line: " .. line)
        end
    else
        print("Invalid format in line: " .. line)
    end
end


print("Total sum of matched left sides: " .. totalSum)

-- Close the file
file:close()
