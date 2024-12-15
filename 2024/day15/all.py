import sys
import re
from collections import deque
import pyperclip as pc

def print_and_copy(s):
    print(s)
    pc.copy(s)

sys.setrecursionlimit(10**6)
dirs = [(-1, 0), (0, 1), (1, 0), (0, -1)]  # up right down left

def get_numbers(s):
    return [int(x) for x in re.findall('-?\d+', s)]

input_file = 'input.txt'

# Read the input from the file
file_data = open(input_file).read().strip()

grid_data, instructions = file_data.split('\n\n')
grid = grid_data.split('\n')

def solve(grid, part2):
    rows = len(grid)
    cols = len(grid[0])
    grid = [[grid[r][c] for c in range(cols)] for r in range(rows)]
    
    if part2:
        new_grid = []
        for r in range(rows):
            new_row = []
            for c in range(cols):
                if grid[r][c] == '#':
                    new_row.append('#')
                    new_row.append('#')
                elif grid[r][c] == 'O':
                    new_row.append('[')
                    new_row.append(']')
                elif grid[r][c] == '.':
                    new_row.append('.')
                    new_row.append('.')
                elif grid[r][c] == '@':
                    new_row.append('@')
                    new_row.append('.')
            new_grid.append(new_row)
        grid = new_grid
        cols *= 2

    start_row, start_col = None, None
    for r in range(rows):
        for c in range(cols):
            if grid[r][c] == '@':
                start_row, start_col = r, c
                grid[r][c] = '.'

    row, col = start_row, start_col
    for instruction in instructions:
        if instruction == '\n':
            continue
        d_row, d_col = {'^': (-1, 0), '>': (0, 1), 'v': (1, 0), '<': (0, -1)}[instruction]
        new_row, new_col = row + d_row, col + d_col
        
        if grid[new_row][new_col] == '#':
            continue
        elif grid[new_row][new_col] == '.':
            row, col = new_row, new_col
        elif grid[new_row][new_col] in ['[', ']', 'O']:
            queue = deque([(row, col)])
            seen = set()
            ok = True
            
            while queue:
                r, c = queue.popleft()
                if (r, c) in seen:
                    continue
                seen.add((r, c))
                new_r, new_c = r + d_row, c + d_col
                if grid[new_r][new_c] == '#':
                    ok = False
                    break
                if grid[new_r][new_c] == 'O':
                    queue.append((new_r, new_c))
                if grid[new_r][new_c] == '[':
                    queue.append((new_r, new_c))
                    assert grid[new_r][new_c + 1] == ']'
                    queue.append((new_r, new_c + 1))
                if grid[new_r][new_c] == ']':
                    queue.append((new_r, new_c))
                    assert grid[new_r][new_c - 1] == '['
                    queue.append((new_r, new_c - 1))
            if not ok:
                continue
            while seen:
                for r, c in sorted(seen):
                    new_r, new_c = r + d_row, c + d_col
                    if (new_r, new_c) not in seen:
                        assert grid[new_r][new_c] == '.'
                        grid[new_r][new_c] = grid[r][c]
                        grid[r][c] = '.'
                        seen.remove((r, c))
            row = row + d_row
            col = col + d_col

    result = 0
    for r in range(rows):
        for c in range(cols):
            if grid[r][c] in ['[', 'O']:
                result += 100 * r + c
    return result

print_and_copy(solve(grid, False))
print_and_copy(solve(grid, True))
