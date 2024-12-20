from collections import deque, defaultdict
from typing import List, Tuple, Dict, Set

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

def find_distances_and_cheats(grid: List[List[str]], start: Tuple[int, int], end: Tuple[int, int], target_saving: int = 100) -> int:
    rows, cols = len(grid), len(grid[0])
    directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]
    forward_dist = {start: 0}
    queue = deque([start])
    while queue:
        pos = queue.popleft()
        r, c = pos
        for dr, dc in directions:
            nr, nc = r + dr, c + dc
            if (0 <= nr < rows and 0 <= nc < cols and grid[nr][nc] != '#' and (nr, nc) not in forward_dist):
                forward_dist[(nr, nc)] = forward_dist[pos] + 1
                queue.append((nr, nc))
    if end not in forward_dist:
        return 0
    normal_dist = forward_dist[end]
    backward_dist = {end: 0}
    queue = deque([end])
    while queue:
        pos = queue.popleft()
        r, c = pos
        for dr, dc in directions:
            nr, nc = r + dr, c + dc
            if (0 <= nr < rows and 0 <= nc < cols and grid[nr][nc] != '#' and (nr, nc) not in backward_dist):
                backward_dist[(nr, nc)] = backward_dist[pos] + 1
                queue.append((nr, nc))
    good_cheats = set()
    for start_pos in forward_dist:
        sr, sc = start_pos
        dist_to_start = forward_dist[start_pos]
        min_possible_saving = normal_dist - dist_to_start - 1
        if min_possible_saving < target_saving:
            continue
        visited = {(start_pos, 0): dist_to_start}
        queue = deque([(start_pos, 0)])
        while queue:
            (r, c), cheat_steps = queue.popleft()
            curr_dist = visited[(r, c), cheat_steps]
            if grid[r][c] != '#' and (r, c) in backward_dist:
                total_dist = curr_dist + backward_dist[(r, c)]
                if normal_dist - total_dist >= target_saving:
                    good_cheats.add((start_pos, (r, c)))
            if cheat_steps >= 20:
                continue
            for dr, dc in directions:
                nr, nc = r + dr, c + dc
                if not (0 <= nr < rows and 0 <= nc < cols):
                    continue
                new_pos = (nr, nc)
                new_state = (new_pos, cheat_steps + 1)
                new_dist = curr_dist + 1
                if new_state not in visited or visited[new_state] > new_dist:
                    visited[new_state] = new_dist
                    queue.append((new_pos, cheat_steps + 1))
    return len(good_cheats)

def solve(filename: str) -> int:
    grid = read_map_from_file(filename)
    start, end = find_start_end(grid)
    return find_distances_and_cheats(grid, start, end)

if __name__ == "__main__":
    result = solve("input.txt")
    print(f"Yo: {result}")
