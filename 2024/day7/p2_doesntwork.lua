
function parse_line(line)
    local target, numbers = line:match("^(%d+): (.+)$")
    target = tonumber(target)
    local nums = {}
    for num in numbers:gmatch("%d+") do
        table.insert(nums, tonumber(num))
    end
    return target, nums
end


function evaluate_expression(numbers, operators)
    local result = numbers[1]
    for i = 1, #operators do
        local op = operators[i]
        local next_num = numbers[i + 1]
        if not next_num then
            error("Mismatch in numbers and operators: Check your operator generation logic.")
        end
        if op == "+" then
            result = result + next_num
        elseif op == "*" then
            result = result * next_num
        elseif op == "||" then
            result = tonumber(tostring(result) .. tostring(next_num))
        end
    end
    return result
end


function generate_operator_combinations(num_slots, operators)
    local combinations = {}
    local function backtrack(current_combination, depth)
        if depth > num_slots then
            table.insert(combinations, current_combination)
            return
        end
        for _, op in ipairs(operators) do
            backtrack(current_combination .. op, depth + 1)
        end
    end
    backtrack("", 1)
    

    local split_combinations = {}
    for _, combination in ipairs(combinations) do
        local op_list = {}
        for i = 1, #combination do
            table.insert(op_list, combination:sub(i, i))
        end
        table.insert(split_combinations, op_list)
    end
    
    return split_combinations
end


function solve_part_two(input)
    local operators = {"+", "*", "||"}
    local valid_targets = {}

    for _, line in ipairs(input) do
        local target, numbers = parse_line(line)
        local num_slots = #numbers - 1
        local operator_combinations = generate_operator_combinations(num_slots, operators)

        -- Check all operator combinations for this line
        local found = false
        for _, op_list in ipairs(operator_combinations) do
            if evaluate_expression(numbers, op_list) == target then
                table.insert(valid_targets, target)
                found = true
                break
            end
        end
    end

    -- Calculate the sum of valid targets
    local total = 0
    for _, value in ipairs(valid_targets) do
        total = total + value
    end
    return total
end


function read_input_file(filename)
    local lines = {}
    for line in io.lines(filename) do
        table.insert(lines, line)
    end
    return lines
end

local input_file = "input.txt" 
local input_data = read_input_file(input_file)
local result = solve_part_two(input_data)
print("Total Calibration Result:", result)
