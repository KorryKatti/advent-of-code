def simulate_guard_movement(grid, start_pos, start_dir):
    rows, cols = len(grid), len(grid[0])
    dir_map = {'^': (-1, 0), 'v': (1, 0), '>': (0, 1), '<': (0, -1)}
    turn_map = {'^': '>', 'v': '<', '<': 'v', '>': '^'}
    
    pos = start_pos
    dir = start_dir
    
    visited = set()
    
    while True:
        if pos in visited:
            return False
        
        visited.add(pos)
        
        next_row = pos[0] + dir_map[dir][0]
        next_col = pos[1] + dir_map[dir][1]
        
        if next_row < 0 or next_row >= rows or next_col < 0 or next_col >= cols or grid[next_row][next_col] == '#':
            dir = turn_map[dir]
        else:
            pos = (next_row, next_col)
    
    return True

def count_valid_obstructions(grid, guard_pos, guard_dir):
    valid_count = 0
    rows, cols = len(grid), len(grid[0])
    
    for row in range(rows):
        for col in range(cols):
            if abs(row - guard_pos[0]) + abs(col - guard_pos[1]) != 1:
                continue
            
            if grid[row][col] == '#':
                continue
            
            grid[row][col] = '#'
            
            if simulate_guard_movement(grid, guard_pos, guard_dir):
                valid_count += 1
            
            grid[row][col] = '.'
    
    return valid_count

# Read the grid from map.txt
with open("map.txt", "r") as file:
    grid = [list(line.strip()) for line in file]

# Find the guard's position and direction
guard_pos = None
guard_dir = None
for i in range(len(grid)):
    for j in range(len(grid[i])):
        if grid[i][j] in ['^', 'v', '<', '>']:
            guard_pos = (i, j)
            guard_dir = grid[i][j]
            break
    if guard_pos:
        break

# Count the valid obstruction placements
valid_obstructions = count_valid_obstructions(grid, guard_pos, guard_dir)
print("Number of valid obstruction placements:", valid_obstructions)