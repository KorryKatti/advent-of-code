import matplotlib.pyplot as plt

robots = []
with open("input.txt", "r") as file:
    for line in file:
        parts = line.strip().split()
        p = tuple(map(int, parts[0][2:].strip(",").split(",")))
        v = tuple(map(int, parts[1][2:].split(",")))
        robots.append((p, v))

WIDTH = 101
HEIGHT = 103

def update_positions(robots):
    updated_positions = []
    for (x, y), (vx, vy) in robots:
        new_x = (x + vx) % WIDTH
        new_y = (y + vy) % HEIGHT
        updated_positions.append(((new_x, new_y), (vx, vy)))
    return updated_positions

def save_grid(robots, second):
    grid = [[0 for _ in range(WIDTH)] for _ in range(HEIGHT)]
    for (x, y), _ in robots:
        grid[y][x] += 1

    plt.figure(figsize=(WIDTH / 10, HEIGHT / 10))
    plt.imshow(grid, cmap="hot", interpolation="nearest")
    plt.axis('off')
    plt.savefig(f"data/second_{second}.png", bbox_inches='tight', pad_inches=0)
    plt.close()

def simulate():
    global robots
    second = 0
    while second < 10000:
        save_grid(robots, second)
        min_x = min(p[0] for p, _ in robots)
        max_x = max(p[0] for p, _ in robots)
        min_y = min(p[1] for p, _ in robots)
        max_y = max(p[1] for p, _ in robots)
        if max_x - min_x < 20 and max_y - min_y < 20:
            print(f"Potential pattern detected at second {second}")
            break
        robots = update_positions(robots)
        second += 1

if __name__ == "__main__":
    simulate()

# Documentation references:
# - Matplotlib Pyplot API: https://matplotlib.org/stable/api/pyplot_api.html
# - Matplotlib Colormap Reference: https://matplotlib.org/stable/tutorials/colors/colormaps.html
