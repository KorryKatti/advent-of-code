local function read_input_file(filename)
    local file = io.open(filename, "r")
    if not file then 
        error("could not open file: " .. filename)
    end
    local content = file:read("*a")
    file:close()
    return content:gsub("%s+", "")
end

local function parse_disk_map(disk_map)
    local blocks = {}
    local file_info = {}
    local file_id = 0
    local pos = 1
    local current_position = 1

    while pos <= #disk_map do
        local file_len = tonumber(disk_map:sub(pos, pos))
        if not file_len then
            error("invalid file length at position " .. pos)
        end
        pos = pos + 1

        file_info[file_id] = {
            id = file_id,
            length = file_len,
            start_pos = current_position,
            blocks = {}
        }

        for _ = 1, file_len do
            table.insert(blocks, file_id)
            table.insert(file_info[file_id].blocks, current_position)
            current_position = current_position + 1
        end

        local free_len = 0
        if pos <= #disk_map then
            free_len = tonumber(disk_map:sub(pos, pos))
            if not free_len then
                error("invalid free space length at position " .. pos)
            end
            pos = pos + 1
        end

        for _ = 1, free_len do
            table.insert(blocks, ".")
            current_position = current_position + 1
        end

        file_id = file_id + 1
    end

    return blocks, file_info
end

local function find_free_space_span(blocks, start_pos, required_length)
    local current_span = 0
    local span_start = nil

    for i = 1, #blocks do
        if blocks[i] == "." then
            if not span_start then
                span_start = i
            end
            current_span = current_span + 1
            if current_span >= required_length and i < start_pos then
                return span_start
            end
        else
            span_start = nil
            current_span = 0
        end
    end
    return nil
end

local function move_file(blocks, file_info, file_id, target_pos)
    if not target_pos then return false end

    local info = file_info[file_id]
    local file_blocks = {}

    for _, pos in ipairs(info.blocks) do
        table.insert(file_blocks, blocks[pos])
        blocks[pos] = "."
    end

    for i = 1, #file_blocks do
        blocks[target_pos + i - 1] = file_blocks[i]
    end

    info.blocks = {}
    for i = 1, info.length do
        table.insert(info.blocks, target_pos + i - 1)
    end
    info.start_pos = target_pos

    return true
end

local function print_disk_state(blocks, output_file)
    local result = {}
    for _, block in ipairs(blocks) do
        table.insert(result, block == "." and "." or tostring(block))
    end
    local state = table.concat(result)
    print(state)
    output_file:write(state .. "\n")
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

local function compact_disk_part2(blocks, file_info)
    local output_file = io.open("p2.txt", "w")
    if not output_file then
        error("could not open output file p2.txt")
    end

    print("initial state:")
    output_file:write("initial state:\n")
    print_disk_state(blocks, output_file)

    local file_ids = {}
    for id, _ in pairs(file_info) do
        table.insert(file_ids, id)
    end
    table.sort(file_ids, function(a, b) return a > b end)

    print("\ncompacting process:")
    output_file:write("\ncompacting process:\n")
    for _, id in ipairs(file_ids) do
        local info = file_info[id]
        local target_pos = find_free_space_span(blocks, info.start_pos, info.length)
        if target_pos then
            move_file(blocks, file_info, id, target_pos)
            print_disk_state(blocks, output_file)
        end
    end

    output_file:close()
    return blocks
end

local start_time = os.clock()

local disk_map = read_input_file("input.txt")
local blocks, file_info = parse_disk_map(disk_map)
local compacted = compact_disk_part2(blocks, file_info)
local checksum = calculate_checksum(compacted)

local end_time = os.clock()
local elapsed_time = end_time - start_time

local output_file = io.open("p2.txt", "a")
if output_file then
    output_file:write("\nfinal checksum: " .. checksum .. "\n")
    output_file:write("time elapsed: " .. string.format("%.3f", elapsed_time) .. " seconds\n")
    output_file:close()
end

print("\nfinal checksum:", checksum)
print("time elapsed:", string.format("%.3f", elapsed_time), "seconds")
