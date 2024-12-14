local file = io.open("input.txt", "r")
local arr = {}

-- Read and parse the input file
if file then
    for line in file:lines() do
        local px, py, vx, vy = line:match("p=(%-?%d+),(%-?%d+)%s+v=(%-?%d+),(%-?%d+)")
        if px and py and vx and vy then
            table.insert(arr, {px = tonumber(px), py = tonumber(py), vx = tonumber(vx), vy = tonumber(vy)})
        end
    end
    file:close()
else
    error("Unable to open input file!")
end

local q = {{0, 0}, {0, 0}}

-- Process each robot's position after 100 seconds
for _, robot in ipairs(arr) do
    local x = (robot.px + 100 * robot.vx) % 101
    local y = (robot.py + 100 * robot.vy) % 103

    if x ~= 50 and y ~= 51 then
        local quadrantX = x > 50 and 2 or 1
        local quadrantY = y > 51 and 2 or 1
        q[quadrantX][quadrantY] = q[quadrantX][quadrantY] + 1
    end
end

-- Calculate and print the safety factor
print(q[1][1] * q[1][2] * q[2][1] * q[2][2])


-- took inspiration from a github repo