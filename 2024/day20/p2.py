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

def find_cheat_distances(grid: List[List[str]], start: Tuple[int, int], max_cheat: int = 20) -> Dict[Tuple[int, int], int]:
    distances = {start: 0}
    queue = deque([(start, 0)])
    directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]
    rows, cols = len(grid), len(grid[0])
    while queue:
        (r, c), cheat_steps = queue.popleft()
        curr_dist = distances[(r, c)]
        for dr, dc in directions:
            nr, nc = r + dr, c + dc
            if not (0 <= nr < rows and 0 <= nc < cols):
                continue
            if grid[nr][nc] == '#':
                if cheat_steps >= max_cheat:
                    continue
                new_cheat_steps = cheat_steps + 1
            else:
                new_cheat_steps = cheat_steps
            if (nr, nc) not in distances or distances[(nr, nc)] > curr_dist + 1:
                distances[(nr, nc)] = curr_dist + 1
                queue.append(((nr, nc), new_cheat_steps))
    return distances

def count_good_cheats(grid: List[List[str]], start: Tuple[int, int], end: Tuple[int, int]) -> int:
    normal_forward = find_distances(grid, start)
    normal_backward = find_distances(grid, end)
    if end not in normal_forward:
        return 0
    normal_path_length = normal_forward[end]
    good_cheats = set()
    rows, cols = len(grid), len(grid[0])
    for r in range(rows):
        for c in range(cols):
            if (r, c) not in normal_forward:
                continue
            cheat_distances = find_cheat_distances(grid, (r, c))
            for end_r in range(rows):
                for end_c in range(cols):
                    if (end_r, end_c) not in normal_backward or (end_r, end_c) not in cheat_distances:
                        continue
                    dist_to_cheat = normal_forward[(r, c)]
                    cheat_length = cheat_distances[(end_r, end_c)]
                    dist_after_cheat = normal_backward[(end_r, end_c)]
                    cheat_path_length = dist_to_cheat + cheat_length + dist_after_cheat
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
