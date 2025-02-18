with open('input.txt') as f:
    directions = f.read().strip()


index_delta = {
    '^': (0, 1),
    'v': (0, -1),
    '>': (1, 0),
    '<': (-1, 0),
}

grid = [[0] * 1000 for _ in range(1000)]  # Create a 2D grid for house visits
santa_x = 500
santa_y = 500
robot_x = 500
robot_y = 500
grid[santa_x][santa_y] = 1

for i, direction in enumerate(directions):
    delta_x, delta_y = index_delta[direction]
    if (i % 2) == 0:
        santa_x += delta_x
        santa_y += delta_y
        grid[santa_x][santa_y] += 1
    else:
        robot_x += delta_x
        robot_y += delta_y
        grid[robot_x][robot_y] += 1


# Count unique houses by checking for non-zero entries
unique_houses = sum(1 for row in grid for house in row if house > 0)

print("Unique houses:", unique_houses)

