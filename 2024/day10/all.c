#include <stdio.h>
#include <string.h>

// Make array really big just to be safe
#define SIZE 999

// Global variables so we don't have to pass them around
int grid[SIZE][SIZE];
int width;
int height;
int visited[SIZE][SIZE];

// Function to check if we already visited this spot
int was_visited(int x, int y) {
    return visited[x][y];
}

// Mark a spot as visited
void mark_visited(int x, int y) {
    visited[x][y] = 1;
}

// Reset visited array
void clear_visited() {
    // Loop through every spot and set to 0
    for(int i = 0; i < SIZE; i++) {
        for(int j = 0; j < SIZE; j++) {
            visited[i][j] = 0;
        }
    }
}

// Count how many spots we visited
int count_visited() {
    int total = 0;
    // Add up all the 1's in visited array
    for(int i = 0; i < SIZE; i++) {
        for(int j = 0; j < SIZE; j++) {
            total = total + visited[i][j];
        }
    }
    return total;
}

// Check if spot is inside grid
int is_valid_spot(int x, int y) {
    if(x < 0) return 0;
    if(y < 0) return 0; 
    if(x >= width) return 0;
    if(y >= height) return 0;
    return 1;
}

// Part 1 recursive function
void find_path1(int x, int y, int current_height) {
    // Base case
    if(current_height == 9) {
        mark_visited(x, y);
        return;
    }
    
    // Try going left
    if(is_valid_spot(x-1, y)) {
        if(grid[y][x-1] == current_height + 1) {
            find_path1(x-1, y, current_height + 1);
        }
    }
    
    // Try going right
    if(is_valid_spot(x+1, y)) {
        if(grid[y][x+1] == current_height + 1) {
            find_path1(x+1, y, current_height + 1);
        }
    }
    
    // Try going up
    if(is_valid_spot(x, y-1)) {
        if(grid[y-1][x] == current_height + 1) {
            find_path1(x, y-1, current_height + 1);
        }
    }
    
    // Try going down
    if(is_valid_spot(x, y+1)) {
        if(grid[y+1][x] == current_height + 1) {
            find_path1(x, y+1, current_height + 1);
        }
    }
}

// Part 2 recursive function
int find_path2(int x, int y, int current_height) {
    // Base case
    if(current_height == 9) {
        return 1;
    }
    
    int answer = 0;
    
    // Try going left
    if(is_valid_spot(x-1, y)) {
        if(grid[y][x-1] == current_height + 1) {
            answer = answer + find_path2(x-1, y, current_height + 1);
        }
    }
    
    // Try going right 
    if(is_valid_spot(x+1, y)) {
        if(grid[y][x+1] == current_height + 1) {
            answer = answer + find_path2(x+1, y, current_height + 1);
        }
    }
    
    // Try going up
    if(is_valid_spot(x, y-1)) {
        if(grid[y-1][x] == current_height + 1) {
            answer = answer + find_path2(x, y-1, current_height + 1);
        }
    }
    
    // Try going down
    if(is_valid_spot(x, y+1)) {
        if(grid[y+1][x] == current_height + 1) {
            answer = answer + find_path2(x, y+1, current_height + 1);
        }
    }
    
    return answer;
}

int main() {
    // Open the input file
    FILE* file = fopen("input.txt", "r");
    if(file == NULL) {
        printf("Couldn't open file :(\n");
        return 1;
    }

    // Read the grid
    char line[1000];  // Make buffer big enough
    int row = 0;
    
    // Read file line by line
    while(fgets(line, sizeof(line), file)) {
        int len = strlen(line);
        if(line[len-1] == '\n') {
            line[len-1] = '\0';  // Remove newline
            len--;
        }
        
        // Save width of first line
        if(row == 0) {
            width = len;
        }
        
        // Convert characters to numbers and save in grid
        for(int i = 0; i < len; i++) {
            grid[row][i] = line[i] - '0';
        }
        
        row++;
    }
    height = row;
    
    fclose(file);

    // Part 1
    int part1_answer = 0;
    
    // Look for zeros
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            if(grid[y][x] == 0) {
                clear_visited();
                find_path1(x, y, 0);
                part1_answer = part1_answer + count_visited();
            }
        }
    }
    
    printf("Part 1: %d\n", part1_answer);

    // Part 2 
    int part2_answer = 0;
    
    // Look for zeros again
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            if(grid[y][x] == 0) {
                part2_answer = part2_answer + find_path2(x, y, 0);
            }
        }
    }
    
    printf("Part 2: %d\n", part2_answer);

    return 0;
}