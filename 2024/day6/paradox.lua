local Grid = {}
Grid.__index = Grid

function Grid:new(lines)
    local self = setmetatable({}, Grid)
    self.height = #lines
    self.width = #lines[1]
    self.start = {x = 0, y = 0}
    self.obstacles = {}

    for i = 1, self.height do
        for j = 1, self.width do
            local char = lines[i]:sub(j, j)
            if char == "#" then
                table.insert(self.obstacles, {x = i, y = j})
            elseif char == "^" then
                self.start = {x = i, y = j}
            end
        end
    end

    self.pos = {x = self.start.x, y = self.start.y}
    self.directions = {{dx = -1, dy = 0}, {dx = 0, dy = 1}, {dx = 1, dy = 0}, {dx = 0, dy = -1}}
    self.dir = 1
    self.visited = {}
    self.check = 0

    return self
end

function Grid:on_map(x, y)
    return x >= 1 and x <= self.height and y >= 1 and y <= self.width
end

function Grid:turn()
    self.dir = (self.dir % 4) + 1
end

function Grid:step(dx, dy)
    self.pos.x = self.pos.x + dx
    self.pos.y = self.pos.y + dy
end

function Grid:walk()
    while self:on_map(self.pos.x, self.pos.y) do
        self.visited[self.pos.x .. "," .. self.pos.y] = true
        local direction = self.directions[self.dir]
        local nextX = self.pos.x + direction.dx
        local nextY = self.pos.y + direction.dy

        while self:is_obstacle(nextX, nextY) do
            self:turn()
            direction = self.directions[self.dir]
            nextX = self.pos.x + direction.dx
            nextY = self.pos.y + direction.dy
        end

        self:step(direction.dx, direction.dy)
    end

    local visited_count = 0
    for _ in pairs(self.visited) do
        visited_count = visited_count + 1
    end
    return visited_count
end

function Grid:is_obstacle(x, y)
    for _, obstacle in ipairs(self.obstacles) do
        if obstacle.x == x and obstacle.y == y then
            return true
        end
    end
    return false
end

function Grid:check_loop(pos, dir, obstacle)
    self.check = self.check + 1
    print("Check iteration: " .. self.check)

    local check_states = {}

    while self:on_map(pos.x, pos.y) do
        check_states[pos.x .. "," .. pos.y .. "," .. dir] = true
        local direction = self.directions[dir]
        local nextX = pos.x + direction.dx
        local nextY = pos.y + direction.dy

        while self:is_obstacle(nextX, nextY) or (nextX == obstacle.x and nextY == obstacle.y) do
            dir = (dir % 4) + 1
            direction = self.directions[dir]
            nextX = pos.x + direction.dx
            nextY = pos.y + direction.dy
        end

        if check_states[nextX .. "," .. nextY .. "," .. dir] then
            return true
        end

        pos = {x = nextX, y = nextY}
    end

    return false
end

function Grid:add_obstacles()
    local obstacle_count = 0

    for visited in pairs(self.visited) do
        local x, y = visited:match("(%d+),(%d+)")
        x, y = tonumber(x), tonumber(y)
        local obstacle = {x = x, y = y}

        if self:check_loop({x = self.start.x, y = self.start.y}, 1, obstacle) then
            obstacle_count = obstacle_count + 1
        end
    end

    return obstacle_count
end

local file = io.open("map.txt", "r")
local lines = {}
for line in file:lines() do
    table.insert(lines, line)
end
file:close()

local guard = Grid:new(lines)
print("cells visited:", guard:walk())
print(" obstacles for loops:", guard:add_obstacles())

-- this code was influenced by a guy i came across on discord , he helped me a lot i must say
