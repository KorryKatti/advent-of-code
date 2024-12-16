#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <limits.h>

#define MAX_ROWS 502  
#define MAX_COLS 502
#define TURN_COST 1000
#define MOVE_COST 1
#define INF INT_MAX

const int dx[] = {0, 1, 0, -1};
const int dy[] = {1, 0, -1, 0};

typedef struct {
    int row, col, dir, score;
} State;

typedef struct {
    State* states;
    int size, capacity;
} MinHeap;

MinHeap* create_min_heap(int capacity) {
    MinHeap* heap = (MinHeap*)malloc(sizeof(MinHeap));
    heap->states = (State*)malloc(capacity * sizeof(State));
    heap->size = 0;
    heap->capacity = capacity;
    return heap;
}

void free_min_heap(MinHeap* heap) {
    free(heap->states);
    free(heap);
}

void swap(State* a, State* b) {
    State temp = *a;
    *a = *b;
    *b = temp;
}

void heapify_up(MinHeap* heap, int idx) {
    if (idx && heap->states[idx].score < heap->states[(idx - 1) / 2].score) {
        swap(&heap->states[idx], &heap->states[(idx - 1) / 2]);
        heapify_up(heap, (idx - 1) / 2);
    }
}

void heapify_down(MinHeap* heap, int idx) {
    int smallest = idx;
    int left = 2 * idx + 1;
    int right = 2 * idx + 2;

    if (left < heap->size && heap->states[left].score < heap->states[smallest].score) {
        smallest = left;
    }
    if (right < heap->size && heap->states[right].score < heap->states[smallest].score) {
        smallest = right;
    }
    if (smallest != idx) {
        swap(&heap->states[idx], &heap->states[smallest]);
        heapify_down(heap, smallest);
    }
}

int is_empty(MinHeap* heap) {
    return heap->size == 0;
}

int find_lowest_score(char grid[MAX_ROWS][MAX_COLS], int rows, int cols, 
                      int start_row, int start_col, int end_row, int end_col) {
    int*** min_score = (int***)malloc(rows * sizeof(int**));
    for (int i = 0; i < rows; i++) {
        min_score[i] = (int**)malloc(cols * sizeof(int*));
        for (int j = 0; j < cols; j++) {
            min_score[i][j] = (int*)malloc(4 * sizeof(int));
            for (int d = 0; d < 4; d++) {
                min_score[i][j][d] = INF;
            }
        }
    }

    MinHeap* heap = create_min_heap(MAX_ROWS * MAX_COLS * 4);

    State start = {start_row, start_col, 0, 0};
    heap->states[heap->size++] = start;
    heapify_up(heap, heap->size - 1);
    min_score[start_row][start_col][0] = 0;

    while (!is_empty(heap)) {
        State current = heap->states[0];
        heap->states[0] = heap->states[--heap->size];
        heapify_down(heap, 0);

        if (current.row == end_row && current.col == end_col) {
            int result = current.score;
            free_min_heap(heap);
            for (int i = 0; i < rows; i++) {
                for (int j = 0; j < cols; j++) {
                    free(min_score[i][j]);
                }
                free(min_score[i]);
            }
            free(min_score);
            return result;
        }

        int new_dir = (current.dir + 3) % 4;
        if (current.score + TURN_COST < min_score[current.row][current.col][new_dir]) {
            min_score[current.row][current.col][new_dir] = current.score + TURN_COST;
            heap->states[heap->size++] = (State){current.row, current.col, new_dir, current.score + TURN_COST};
            heapify_up(heap, heap->size - 1);
        }

        new_dir = (current.dir + 1) % 4;
        if (current.score + TURN_COST < min_score[current.row][current.col][new_dir]) {
            min_score[current.row][current.col][new_dir] = current.score + TURN_COST;
            heap->states[heap->size++] = (State){current.row, current.col, new_dir, current.score + TURN_COST};
            heapify_up(heap, heap->size - 1);
        }

        int new_row = current.row + dx[current.dir];
        int new_col = current.col + dy[current.dir];
        if (new_row >= 0 && new_row < rows && new_col >= 0 && new_col < cols && 
            grid[new_row][new_col] != '#' && 
            current.score + MOVE_COST < min_score[new_row][new_col][current.dir]) {
            min_score[new_row][new_col][current.dir] = current.score + MOVE_COST;
            heap->states[heap->size++] = (State){new_row, new_col, current.dir, current.score + MOVE_COST};
            heapify_up(heap, heap->size - 1);
        }
    }

    free_min_heap(heap);
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            free(min_score[i][j]);
        }
        free(min_score[i]);
    }
    free(min_score);

    return -1;
}

int main() {
    FILE *file = fopen("input.txt", "r");
    if (file == NULL) {
        printf("Error: Could not open input.txt\n");
        return 1;
    }
    
    char grid[MAX_ROWS][MAX_COLS];
    int rows = 0, cols = 0;
    int start_row = -1, start_col = -1;
    int end_row = -1, end_col = -1;
    
    while (fgets(grid[rows], sizeof(grid[rows]), file) && rows < MAX_ROWS) {
        cols = strlen(grid[rows]) - 1;
        if (cols >= MAX_COLS) {
            printf("Input line too long!\n");
            fclose(file);
            return 1;
        }
        grid[rows][cols] = '\0';
        
        for (int j = 0; j < cols; j++) {
            if (grid[rows][j] == 'S') {
                start_row = rows;
                start_col = j;
            } else if (grid[rows][j] == 'E') {
                end_row = rows;
                end_col = j;
            }
        }
        rows++;
    }
    fclose(file);
    
    if (start_row == -1 || end_row == -1) {
        printf("Error: Start (S) or End (E) not found in maze\n");
        return 1;
    }
    
    int lowest_score = find_lowest_score(grid, rows, cols, start_row, start_col, end_row, end_col);
    
    if (lowest_score != -1) {
        printf("Lowest possible score: %d\n", lowest_score);
    } else {
        printf("No path found from S to E\n");
    }
    
    return 0;
}
