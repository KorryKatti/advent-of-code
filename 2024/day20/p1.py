from collections import deque
from typing import List, Tuple, Dict

def read_map_from_file(filename: str) -> List[List[str]]:
    with open(filename, 'r') as f:
        return [list(line.strip()) for line in f]

def find_start_end(grid: List[List[str]]) -> Tuple[Tuple[int, int], Tuple[int, int]]:
    start = end = None
    for i, row in enumerate(grid):
        for j, cell in enumerate(row):
            if cell == 'S':
                start = (i, j)
            elif cell == 'E':
                end = (i, j)
            if start and end:
                return start, end
    return start, end

def find_distances(grid: List[List[str]], start: Tuple[int, int]) -> Dict[Tuple[int, int], int]:
    distances = {start: 0}
    queue = deque([start])
    directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]
    while queue:
        r, c = queue.popleft()
        curr_dist = distances[(r, c)]
        for dr, dc in directions:
            nr, nc = r + dr, c + dc
            if (0 <= nr < len(grid) and 0 <= nc < len(grid[0]) and 
                grid[nr][nc] != '#' and (nr, nc) not in distances):
                distances[(nr, nc)] = curr_dist + 1
                queue.append((nr, nc))
    return distances

def count_good_cheats(grid: List[List[str]], start: Tuple[int, int], end: Tuple[int, int]) -> int:
    forward_distances = find_distances(grid, start)
    backward_distances = find_distances(grid, end)
    
    if end not in forward_distances:
        return 0
    
    normal_path_length = forward_distances[end]
    rows, cols = len(grid), len(grid[0])
    directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]
    good_cheats = set()
    
    for r in range(rows):
        for c in range(cols):
            if (r, c) not in forward_distances:
                continue
            
            dist_to_start = forward_distances[(r, c)]
            
            for end_r in range(rows):
                for end_c in range(cols):
                    if (end_r, end_c) not in backward_distances:
                        continue
                        
                    dist_from_end = backward_distances[(end_r, end_c)]
                    
                    cheat_distance = abs(end_r - r) + abs(end_c - c)
                    if cheat_distance > 2:
                        continue
                    
                    cheat_path_length = dist_to_start + cheat_distance + dist_from_end
                    time_saved = normal_path_length - cheat_path_length
                    
                    if time_saved >= 100:
                        good_cheats.add((r, c, end_r, end_c))
    
    return len(good_cheats)

def solve(filename: str) -> int:
    grid = read_map_from_file(filename)
    start, end = find_start_end(grid)
    return count_good_cheats(grid, start, end)

if __name__ == "__main__":
    result = solve("input.txt")
    print(f"Number of cheats saving at least 100 picoseconds: {result}")
