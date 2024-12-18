from collections import deque

def read_input(file_path):
    with open(file_path, "r") as file:
        coords = []
        for line in file:
            if line.strip():
                x, y = map(int, line.strip().split(','))
                coords.append((x, y))
    return coords

def create_grid(size):
    return [['.' for _ in range(size)] for _ in range(size)]

def has_path(grid, start, end):
    size = len(grid)
    directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]
    queue = deque([start])
    visited = {start}
    
    while queue:
        x, y = queue.popleft()
        
        if (x, y) == end:
            return True
        
        for dx, dy in directions:
            nx, ny = x + dx, y + dy
            if (0 <= nx < size and 0 <= ny < size and 
                (nx, ny) not in visited and 
                grid[ny][nx] != '#'):
                queue.append((nx, ny))
                visited.add((nx, ny))
    
    return False

def find_blocking_byte(coords, size, start, end):
    grid = create_grid(size)
    for i, (x, y) in enumerate(coords):
        blocking_coord = (x, y)
        grid[y][x] = '#'
        if not has_path(grid, start, end):
            return blocking_coord
    return None

def main():
    size = 71
    start = (0, 0)
    end = (70, 70)
    input_file = "input.txt"
    coords = read_input(input_file)
    blocking_coord = find_blocking_byte(coords, size, start, end)
    if blocking_coord:
        print(f"{blocking_coord[0]},{blocking_coord[1]}")

if __name__ == "__main__":
    main()
