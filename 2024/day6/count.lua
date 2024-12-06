local file = io.open("output.txt", "r")
local map = {}
for line in file:lines() do
    table.insert(map, line)
end
file:close()

local count = 0

for i, row in ipairs(map) do
    for i = 1, #row do
        if row:sub(i, i) == "X" then
            count = count + 1
        end
    end
end

-- Print the count
print("Count:", count)
