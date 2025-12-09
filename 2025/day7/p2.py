# also took a lot of help ofc on this too 

def count_timelines():
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
    
    def trace(row, col):
        if row >= rows:
            return 1
        
        if (row, col) in memo:
            return memo[(row, col)]
        
        total = 0
        if grid[row][col] == '^':
            total += trace(row + 1, col - 1)
            total += trace(row + 1, col + 1)
        else:
            total += trace(row + 1, col)
        
        memo[(row, col)] = total
        return total
    
    return trace(start_row + 1, start_col)

result = count_timelines()
print(result)
