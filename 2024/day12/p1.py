def get_neighbors(x, y, grid):
    neighbors = []
    directions = [(-1, 0), (1, 0), (0, -1), (0, 1)]
    for dx, dy in directions:
        nx, ny = x + dx, y + dy
        if 0 <= nx < len(grid) and 0 <= ny < len(grid[0]):
            neighbors.append((nx, ny))
    return neighbors

def calculate_perimeter(points, grid):
    perimeter = 0
    for x, y in points:
        # Check all four sides of current cell
        for dx, dy in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
            nx, ny = x + dx, y + dy
            # If neighbor is outside grid or different type, this edge counts
            if (nx < 0 or nx >= len(grid) or 
                ny < 0 or ny >= len(grid[0]) or 
                grid[nx][ny] != grid[x][y]):
                perimeter += 1
    return perimeter

def bfs(x, y, grid, visited):
    plant_type = grid[x][y]
    queue = [(x, y)]
    visited[x][y] = True
    region_points = set([(x, y)])  # Keep track of all points in region

    while queue:
        cx, cy = queue.pop(0)
        for nx, ny in get_neighbors(cx, cy, grid):
            if not visited[nx][ny] and grid[nx][ny] == plant_type:
                visited[nx][ny] = True
                queue.append((nx, ny))
                region_points.add((nx, ny))

    area = len(region_points)
    perimeter = calculate_perimeter(region_points, grid)
    return area, perimeter, plant_type

def solve_garden_plots(grid):
    rows, cols = len(grid), len(grid[0])
    visited = [[False for _ in range(cols)] for _ in range(rows)]
    total_price = 0
    regions = []

    for x in range(rows):
        for y in range(cols):
            if not visited[x][y]:
                area, perimeter, plant_type = bfs(x, y, grid, visited)
                price = area * perimeter
                regions.append((plant_type, area, perimeter, price))
                total_price += price

    # Print detailed information about each region
    for i, (plant_type, area, perimeter, price) in enumerate(regions):
        print(f"Region {i}: Type={plant_type}, Area={area}, Perimeter={perimeter}, Price={price}")

    return total_price

def main():
    # Read input from file
    with open('input.txt', 'r') as file:
        grid = [list(line.strip()) for line in file.readlines()]

    total_price = solve_garden_plots(grid)
    print(f"\nTotal price: {total_price}")

if __name__ == '__main__':
    main()