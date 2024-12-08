local file = io.open("input.txt", "r")
if not file then
    print("input.txt not found!")
    return
end

local grid = {}
for line in file:lines() do
    local row = {}
    for char in line:gmatch(".") do
        table.insert(row, char)
    end
    table.insert(grid, row)
end
file:close()

function gcd_func(a, b)
    while b ~= 0 do
        a, b = b, a % b
    end
    return a
end

function draw_full_line(x1, y1, x2, y2, antinodes, rows, cols)
    local dx = x2 - x1
    local dy = y2 - y1
    local gcd = math.abs(dx ~= 0 and dy ~= 0 and gcd_func(dx, dy) or (dx ~= 0 and dx or dy))
    dx = dx / gcd
    dy = dy / gcd

    local nx, ny = x1, y1
    while nx >= 1 and ny >= 1 and nx <= rows and ny <= cols do
        local pos = nx .. "," .. ny
        antinodes[pos] = true
        nx = nx - dx
        ny = ny - dy
    end

    nx, ny = x1 + dx, y1 + dy
    while nx >= 1 and ny >= 1 and nx <= rows and ny <= cols do
        local pos = nx .. "," .. ny
        antinodes[pos] = true
        nx = nx + dx
        ny = ny + dy
    end
end

function find_antinodes(grid)
    local antinodes = {}
    local rows = #grid
    local cols = #grid[1]

    for x1 = 1, rows do
        for y1 = 1, cols do
            local char1 = grid[x1][y1]
            if char1 ~= "." then
                for x2 = 1, rows do
                    for y2 = 1, cols do
                        local char2 = grid[x2][y2]
                        if char1 == char2 and (x1 ~= x2 or y1 ~= y2) then
                            draw_full_line(x1, y1, x2, y2, antinodes, rows, cols)
                        end
                    end
                end
            end
        end
    end

    return antinodes
end

local antinodes = find_antinodes(grid)
local unique_count = 0
for _ in pairs(antinodes) do
    unique_count = unique_count + 1
end

local output_file = io.open("output.txt", "w")
if output_file then
    output_file:write("Total unique antinodes: " .. unique_count .. "\n")
    for pos, _ in pairs(antinodes) do
        output_file:write(pos .. "\n")
    end
    output_file:close()
else
    print("Error writing output.txt!")
end

print("Total unique antinodes:", unique_count)
