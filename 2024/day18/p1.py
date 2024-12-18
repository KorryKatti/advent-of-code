from collections import deque

def read_input(file_path):
    with open(file_path, "r") as file:
        coords = []
        for line in file:
            if line.strip():
                x, y = map(int, line.strip().split(','))
                coords.append((x, y))
                if len(coords) >= 1024:
                    break
    return coords

def create_grid(size):
    return [['.' for _ in range(size)] for _ in range(size)]

def mark_corrupted(grid, coords):
    size = len(grid)
    for x, y in coords:
        if 0 <= x < size and 0 <= y < size:
            grid[y][x] = '#'

def bfs(grid, start, end):
    size = len(grid)
    directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]
    queue = deque([(start, 0)])
    visited = {start}
    
    while queue:
        (x, y), steps = queue.popleft()
        
        if (x, y) == end:
            return steps
        
        for dx, dy in directions:
            nx, ny = x + dx, y + dy
            if (0 <= nx < size and 0 <= ny < size and 
                (nx, ny) not in visited and 
                grid[ny][nx] != '#'):
                queue.append(((nx, ny), steps + 1))
                visited.add((nx, ny))
    
    return -1

def main():
    size = 71
    start = (0, 0)
    end = (70, 70)
    input_file = "input.txt"
    coords = read_input(input_file)
    grid = create_grid(size)
    mark_corrupted(grid, coords)
    result = bfs(grid, start, end)
    if result == -1:
        print("check again dude")
    else:
        print(f"min: {result}")

if __name__ == "__main__":
    main()
