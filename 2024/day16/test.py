import heapq
from collections import deque

class Maze:
    def __init__(self, lines):
        self.grid = [list(row) for row in lines]
        self.height = len(self.grid)
        self.width = len(self.grid[0])
        self.start_position = self.find_position('S')
        self.end_position = self.find_position('E')
        self.directions = [(-1, 0), (0, 1), (1, 0), (0, -1)]
        self.start_state = (self.start_position, 1)
        self.visited_states = {self.start_state: 0}

    def find_position(self, char):
        for row in range(self.height):
            for col in range(self.width):
                if self.grid[row][col] == char:
                    return (row, col)
        return None

    def find_shortest_path_cost(self):
        priority_queue = [(0, self.start_state)]
        while priority_queue:
            current_cost, ((x, y), direction) = heapq.heappop(priority_queue)
            if self.visited_states.get(((x, y), direction), float('inf')) < current_cost:
                continue
            dx, dy = self.directions[direction]
            new_x, new_y = x + dx, y + dy
            if 0 <= new_x < self.height and 0 <= new_y < self.width and self.grid[new_x][new_y] != '#':
                new_cost = current_cost + 1
                next_state = ((new_x, new_y), direction)
                if new_cost < self.visited_states.get(next_state, float('inf')):
                    self.visited_states[next_state] = new_cost
                    heapq.heappush(priority_queue, (new_cost, next_state))
            for new_direction in [(direction - 1) % 4, (direction + 1) % 4]:
                new_cost = current_cost + 1000
                next_state = ((x, y), new_direction)
                if new_cost < self.visited_states.get(next_state, float('inf')):
                    self.visited_states[next_state] = new_cost
                    heapq.heappush(priority_queue, (new_cost, next_state))
        return min(self.visited_states[(self.end_position, d)] for d in range(4) if (self.end_position, d) in self.visited_states)

    def find_shortest_path_tiles(self):
        min_end_cost = self.find_shortest_path_cost()
        shortest_path_tiles = set()
        queue = deque()
        for d in range(4):
            end_state = (self.end_position, d)
            if end_state in self.visited_states and self.visited_states[end_state] == min_end_cost:
                shortest_path_tiles.add(end_state)
                queue.append(end_state)
        while queue:
            (x, y), direction = queue.popleft()
            current_cost = self.visited_states[((x, y), direction)]
            dx, dy = self.directions[direction]
            prev_x, prev_y = x - dx, y - dy
            if 0 <= prev_x < self.height and 0 <= prev_y < self.width and self.grid[prev_x][prev_y] != '#':
                prev_cost = current_cost - 1
                prev_state = ((prev_x, prev_y), direction)
                if prev_cost == self.visited_states.get(prev_state, float('inf')) and prev_state not in shortest_path_tiles:
                    shortest_path_tiles.add(prev_state)
                    queue.append(prev_state)
            turn_cost = current_cost - 1000
            if turn_cost >= 0:
                for prev_direction in [(direction - 1) % 4, (direction + 1) % 4]:
                    prev_state = ((x, y), prev_direction)
                    if prev_state in self.visited_states and self.visited_states[prev_state] == turn_cost:
                        if prev_state not in shortest_path_tiles:
                            shortest_path_tiles.add(prev_state)
                            queue.append(prev_state)
        return len({(x, y) for ((x, y), d) in shortest_path_tiles})

with open('input.txt') as f:
    lines = f.read().splitlines()
    maze = Maze(lines)
    print("Part 2: number of tiles for the cheapest path", maze.find_shortest_path_tiles())


# p2 inspired from https://github.com/Lkeurentjes/Advent_of_code/