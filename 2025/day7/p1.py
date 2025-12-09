# took a lot of help on this

def count_splits_fast():
    with open('input.txt', 'r') as f:
        grid = [list(line.rstrip()) for line in f]
    
    rows = len(grid)
    cols = len(grid[0])
    
    start_row, start_col = -1, -1
    for r in range(rows):
        for c in range(cols):
            if grid[r][c] == 'S':
                start_row, start_col = r, c
                break
        if start_row != -1:
            break
    
    memo = {}
    
    def beam_reaches(row, col):
        if (row, col) in memo:
            return memo[(row, col)]
        
        if row <= start_row and col == start_col:
            memo[(row, col)] = True
            return True
        
        if row > 0 and grid[row-1][col] != '^':
            if beam_reaches(row-1, col):
                memo[(row, col)] = True
                return True
        
        if col > 0 and row > 0 and grid[row][col-1] == '^':
            if beam_reaches(row, col-1):
                memo[(row, col)] = True
                return True
        
        if col + 1 < cols and row > 0 and grid[row][col+1] == '^':
            if beam_reaches(row, col+1):
                memo[(row, col)] = True
                return True
        
        memo[(row, col)] = False
        return False
    
    total_splits = 0
    for r in range(rows):
        for c in range(cols):
            if grid[r][c] == '^' and beam_reaches(r, c):
                total_splits += 1
    
    return total_splits


result = count_splits_fast()
print(result)
