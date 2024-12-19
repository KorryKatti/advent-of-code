#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define MAX_PATTERNS 10000
#define MAX_DESIGNS 10000
#define MAX_LENGTH 10000

char patterns[MAX_PATTERNS][MAX_LENGTH];
int num_patterns = 0;
char designs[MAX_DESIGNS][MAX_LENGTH];
int num_designs = 0;
bool memo[MAX_DESIGNS][MAX_LENGTH];
bool computed[MAX_DESIGNS][MAX_LENGTH];

void trim(char* str) {
    int len = strlen(str);
    while (len > 0 && (str[len-1] == '\n' || str[len-1] == ' ' || str[len-1] == '\r')) {
        str[--len] = '\0';
    }
}

void read_input(const char* filename) {
    FILE* file = fopen(filename, "r");
    if (!file) {
        printf("Error opening file\n");
        exit(1);
    }

    char line[MAX_LENGTH];

    if (fgets(line, sizeof(line), file)) {
        trim(line);
        char* token = strtok(line, ", ");
        while (token) {
            strcpy(patterns[num_patterns++], token);
            token = strtok(NULL, ", ");
        }
    }

    fgets(line, sizeof(line), file);

    while (fgets(line, sizeof(line), file)) {
        trim(line);
        if (strlen(line) > 0) {
            strcpy(designs[num_designs++], line);
        }
    }

    fclose(file);
}

bool can_make_design(int design_index, int start_pos) {
    if (start_pos >= strlen(designs[design_index])) {
        return true;
    }

    if (computed[design_index][start_pos]) {
        return memo[design_index][start_pos];
    }

    for (int i = 0; i < num_patterns; i++) {
        int pattern_len = strlen(patterns[i]);
        if (strlen(designs[design_index]) - start_pos >= pattern_len) {
            bool matches = true;
            for (int j = 0; j < pattern_len; j++) {
                if (designs[design_index][start_pos + j] != patterns[i][j]) {
                    matches = false;
                    break;
                }
            }
            if (matches && can_make_design(design_index, start_pos + pattern_len)) {
                memo[design_index][start_pos] = true;
                computed[design_index][start_pos] = true;
                return true;
            }
        }
    }

    memo[design_index][start_pos] = false;
    computed[design_index][start_pos] = true;
    return false;
}

int main() {
    read_input("input.txt");

    memset(computed, 0, sizeof(computed));

    int possible_count = 0;

    for (int i = 0; i < num_designs; i++) {
        if (can_make_design(i, 0)) {
            possible_count++;
        }
    }

    printf("Number of possible designs: %d\n", possible_count);
    return 0;
}
