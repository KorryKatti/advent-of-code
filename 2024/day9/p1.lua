local function read_input_file(filename)
    local file = io.open(filename, "r")
    if not file then 
        error("Could not open input file: " .. filename)
    end
    local content = file:read("*a")
    file:close()
    return content:gsub("%s+", "")
end

local function parse_disk_map(disk_map)
    local blocks = {}
    local file_id = 0  -- start from 0 
    local pos = 1

    while pos <= #disk_map do
        -- Get file length
        local file_len = tonumber(disk_map:sub(pos, pos))
        if not file_len then
            error(string.format("Invalid file length at position %d", pos))
        end
        pos = pos + 1

        local free_len = 0
        if pos <= #disk_map then
            free_len = tonumber(disk_map:sub(pos, pos))
            if not free_len then
                error(string.format("Invalid free space length at position %d", pos))
            end
            pos = pos + 1
        end

        for _ = 1, file_len do
            table.insert(blocks, file_id)
        end

        for _ = 1, free_len do
            table.insert(blocks, ".")
        end

        file_id = file_id + 1
    end

    return blocks
end

local function print_disk_state(blocks)
    local result = {}
    for _, block in ipairs(blocks) do
        table.insert(result, block == "." and "." or tostring(block))
    end
    print(table.concat(result))
end

local function calculate_checksum(blocks)
    local checksum = 0
    for pos = 1, #blocks do
        if blocks[pos] ~= "." then
            checksum = checksum + ((pos - 1) * blocks[pos])
        end
    end
    return checksum
end

local function find_rightmost_file_block(blocks)
    for i = #blocks, 1, -1 do
        if blocks[i] ~= "." then
            return i
        end
    end
    return nil
end

local function find_leftmost_free_space(blocks)
    for i = 1, #blocks do
        if blocks[i] == "." then
            return i
        end
    end
    return nil
end

local function compact_disk(blocks)
    local steps = {table.concat(blocks, "")}
    
    while true do
        local rightmost_file = find_rightmost_file_block(blocks)
        local leftmost_space = find_leftmost_free_space(blocks)
        
        if not rightmost_file or not leftmost_space or leftmost_space > rightmost_file then
            break
        end
        
        -- Move the file block to the free space
        blocks[leftmost_space] = blocks[rightmost_file]
        blocks[rightmost_file] = "."
        
        steps[#steps + 1] = table.concat(blocks, "")
        print_disk_state(blocks)
    end
    
    return blocks
end

-- Main execution
local disk_map = read_input_file("input.txt")
local blocks = parse_disk_map(disk_map)
print_disk_state(blocks)


local compacted = compact_disk(blocks)

local checksum = calculate_checksum(compacted)
print("\nFinal checksum:", checksum)