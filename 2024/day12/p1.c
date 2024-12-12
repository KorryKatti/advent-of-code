#include <stdio.h>
#include <string.h>
#define MAX_ROWS 100
#define MAX_COLS 100

// Function to read the grid from a file
void read_grid(char grid[MAX_ROWS][MAX_COLS], int *rows, int *cols) {
    FILE *file = fopen("input.txt", "r");
    if (!file) {
        printf("Error opening file\n");
        return;
    }

    char line[MAX_COLS + 2]; // Extra space for newline and null terminator
    *rows = 0;
    while (fgets(line, sizeof(line), file)) {
        int len = strlen(line);
        if (line[len - 1] == '\n') line[len - 1] = '\0'; // Remove newline
        strcpy(grid[*rows], line);
        *cols = len - 1; // Update cols (same for all rows)
        (*rows)++;
    }
    fclose(file);

    // Debug: Print the grid dimensions and contents
    printf("Grid loaded: Rows = %d, Cols = %d\n", *rows, *cols);
    for (int i = 0; i < *rows; i++) {
        printf("%s\n", grid[i]);
    }
}

// Get valid neighbors for a cell
void get_neighbors(int x, int y, int rows, int cols, int directions[4][2], int neighbors[4][2], int *count) {
    *count = 0;
    for (int i = 0; i < 4; i++) {
        int nx = x + directions[i][0];
        int ny = y + directions[i][1];
        if (nx >= 0 && nx < rows && ny >= 0 && ny < cols) {
            neighbors[*count][0] = nx;
            neighbors[*count][1] = ny;
            (*count)++;
        }
    }
}

// BFS to find a connected region
char bfs(int x, int y, char grid[MAX_ROWS][MAX_COLS], int visited[MAX_ROWS][MAX_COLS], int rows, int cols, int *area, int *perimeter) {
    char plant_type = grid[x][y];
    int directions[4][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};
    int queue[MAX_ROWS * MAX_COLS][2];
    int front = 0, back = 0;

    queue[back][0] = x;
    queue[back][1] = y;
    back++;
    visited[x][y] = 1;

    *area = 0;
    *perimeter = 0;

    while (front < back) {
        int cx = queue[front][0];
        int cy = queue[front][1];
        front++;

        (*area)++;
        for (int i = 0; i < 4; i++) {
            int nx = cx + directions[i][0];
            int ny = cy + directions[i][1];
            if (nx >= 0 && nx < rows && ny >= 0 && ny < cols) {
                if (grid[nx][ny] == plant_type && !visited[nx][ny]) {
                    visited[nx][ny] = 1;
                    queue[back][0] = nx;
                    queue[back][1] = ny;
                    back++;
                } else if (grid[nx][ny] != plant_type) {
                    (*perimeter)++;
                }
            } else {
                (*perimeter)++;
            }
        }
    }

    return plant_type;
}

// Solve the garden plots and calculate total price
int solve_garden_plots(char grid[MAX_ROWS][MAX_COLS], int rows, int cols) {
    int visited[MAX_ROWS][MAX_COLS] = {0};
    int total_price = 0;

    for (int x = 0; x < rows; x++) {
        for (int y = 0; y < cols; y++) {
            if (!visited[x][y]) {
                int area = 0, perimeter = 0;
                char plant_type = bfs(x, y, grid, visited, rows, cols, &area, &perimeter);
                int price = area * perimeter;
                printf("Region: Type=%c, Area=%d, Perimeter=%d, Price=%d\n", plant_type, area, perimeter, price);
                total_price += price;
            }
        }
    }

    return total_price;
}

// Main function
int main() {
    char grid[MAX_ROWS][MAX_COLS];
    int rows, cols;

    // Read the grid from the file
    read_grid(grid, &rows, &cols);

    // Ensure the grid was successfully loaded
    if (rows == 0 || cols == 0) {
        printf("Failed to load grid. Exiting.\n");
        return 1;
    }

    // Solve and calculate the total price
    int total_price = solve_garden_plots(grid, rows, cols);
    printf("\nTotal price: %d\n", total_price);

    return 0;
}
