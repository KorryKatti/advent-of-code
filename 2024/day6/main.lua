file = io.open("map.txt","r") -- opens map.txt which is my input from AoC
map = {} -- this is like a table or something
for line in file:lines() do
    table.insert(map,line)
end
file:close()    

-- man why does every programming language try so hard to be unique just build a common syntax and make your language work with it file.close is so much better than file:close
local guardRow, guardCol , guardDir
for rowIndex, row in ipairs(map) do
    for colIndex = 1, #row do
        local cell = row:sub(colIndex,colIndex)
        if cell == "^" or cell == ">" or cell == "v" or cell == "<" then
            guardRow, guardCol, guardDir = rowIndex, colIndex, cell
            print("Guard found at ",guardRow, guardCol," facing ",guardDir)
        end
    end
end

local exit = 0
local outputFile = io.open("output.txt", "w") -- Open the file for writing

while exit ~= 1 do
    -- Mark the current position as visited
    map[guardRow] = map[guardRow]:sub(1, guardCol - 1) .. "X" .. map[guardRow]:sub(guardCol + 1)

    -- Move forward based on guard direction
    local nextRow, nextCol = guardRow, guardCol
    if guardDir == "^" then
        nextRow = guardRow - 1
    elseif guardDir == ">" then
        nextCol = guardCol + 1
    elseif guardDir == "v" then
        nextRow = guardRow + 1
    elseif guardDir == "<" then
        nextCol = guardCol - 1
    end

    -- Check bounds
    if nextRow < 1 or nextRow > #map or nextCol < 1 or nextCol > #map[nextRow] then
        print("Guard exited the map!")
        exit = 1
        break
    end

    -- Get the cell in the direction the guard is moving
    local cell = map[nextRow]:sub(nextCol, nextCol)

    -- Handle encountering an obstacle
    if cell == "#" then
        -- Turn right
        if guardDir == "^" then
            guardDir = ">"
        elseif guardDir == ">" then
            guardDir = "v"
        elseif guardDir == "v" then
            guardDir = "<"
        elseif guardDir == "<" then
            guardDir = "^"
        end
    else
        -- Move the guard to the new position
        guardRow, guardCol = nextRow, nextCol
    end
end

-- Write the final map to the output file
for _, row in ipairs(map) do
    outputFile:write(row .. "\n")
end

outputFile:close() -- Close the file after writing
print("Final map written to output.txt.")
