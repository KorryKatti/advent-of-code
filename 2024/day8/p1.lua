local file = io.open("input.txt", "r")
if not file then
    print("Error: input.txt not found!")
    return
end

-- put lines into a 2D grid
local grid = {}
for line in file:lines() do
    table.insert(grid, {})
    for char in line:gmatch(".") do
        table.insert(grid[#grid], char)
    end
end
file:close()

--  to check for antinode conditions and calculate positions
local function find_antinodes(grid)
    local rows = #grid
    local cols = #grid[1]
    local antinodes = {}

    -- go through the grid to find antennas
    for x1 = 1, rows do
        for y1 = 1, cols do
            local char1 = grid[x1][y1]
            if char1 ~= "." then
                for x2 = 1, rows do
                    for y2 = 1, cols do
                        local char2 = grid[x2][y2]
                        if char2 == char1 and not (x1 == x2 and y1 == y2) then
                            local dx = x2 - x1h -- feels funny to use calculus stuff , well one could say i am stupid in making this comment idc
                            local dy = y2 - y1

                            local mx1, my1 = x1 - dx, y1 - dy
                            local mx2, my2 = x2 + dx, y2 + dy

                            if mx1 > 0 and mx1 <= rows and my1 > 0 and my1 <= cols then
                                antinodes[mx1 .. "," .. my1] = true
                            end
                            if mx2 > 0 and mx2 <= rows and my2 > 0 and my2 <= cols then
                                antinodes[mx2 .. "," .. my2] = true
                            end
                        end
                    end
                end
            end
        end
    end

    return antinodes
end

-- Find unique antinodes
local antinodes = find_antinodes(grid)

-- Count unique antinodes
local unique_count = 0
for _ in pairs(antinodes) do
    unique_count = unique_count + 1
end

-- Save results to output.txt
local output_file = io.open("output.txt", "w")
output_file:write("Total unique antinodes: ", unique_count, "\n")

for pos, _ in pairs(antinodes) do
    output_file:write(pos, "\n")
end
output_file:close()


print("Total unique antinodes:", unique_count)
