/* part 1
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE_LENGTH 1024  
#define MAX_NUMBERS 100    


int is_valid_line(const int *numbers, int length) {
    int direction = 0;  

    for (int i = 0; i < length - 1; i++) {
        int step = numbers[i + 1] - numbers[i];

        if (step < -3 || step > 3 || step == 0) {
            return 0;  

        if (direction == 0) {
            direction = (step > 0) ? 1 : -1;
        } else if ((direction == 1 && step < 0) || (direction == -1 && step > 0)) {
            return 0; 
        }
    }
    return 1;  
}


void process_line(const char *line, int *valid_count) {
    int numbers[MAX_NUMBERS];
    int count = 0;

    const char *token = strtok((char *)line, " ");
    while (token != NULL) {
        numbers[count++] = atoi(token);
        token = strtok(NULL, " ");
    }

    if (is_valid_line(numbers, count)) {
        (*valid_count)++;
    } else {
        printf("Line is invalid: %s\n", line);
    }
}

int main() {
    FILE *file_ptr;
    char buffer[MAX_LINE_LENGTH];
    int valid_count = 0;

    file_ptr = fopen("input.txt", "r");

    if (file_ptr == NULL) {
        printf("File cannot be opened\n");
        return 1;
    }

    while (fgets(buffer, MAX_LINE_LENGTH, file_ptr)) {
        buffer[strcspn(buffer, "\n")] = '\0';  // Remove newline character
        process_line(buffer, &valid_count);
    }

    fclose(file_ptr);

    printf("Total valid lines: %d\n", valid_count);
    return 0;
}
*/

// part 2

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE_LENGTH 1024
#define MAX_NUMBERS 100

int is_valid_line(const int *numbers, int length) {
    int direction = 0;
    for (int i = 0; i < length - 1; i++) {
        int step = numbers[i + 1] - numbers[i];
        if (step < -3 || step > 3 || step == 0) {
            return 0;
        }
        if (direction == 0) {
            direction = (step > 0) ? 1 : -1;
        } else if ((direction == 1 && step < 0) || (direction == -1 && step > 0)) {
            return 0;
        }
    }
    return 1;
}

int can_become_valid(const int *numbers, int length) {
    for (int i = 0; i < length; i++) {
        int temp[MAX_NUMBERS];
        int idx = 0;
        for (int j = 0; j < length; j++) {
            if (j != i) {
                temp[idx++] = numbers[j];
            }
        }
        if (is_valid_line(temp, length - 1)) {
            return 1;
        }
    }
    return 0;
}

void process_line(const char *line, int *valid_count) {
    int numbers[MAX_NUMBERS];
    int count = 0;
    const char *token = strtok((char *)line, " ");
    while (token != NULL) {
        numbers[count++] = atoi(token);
        token = strtok(NULL, " ");
    }
    if (is_valid_line(numbers, count) || can_become_valid(numbers, count)) {
        (*valid_count)++;
    } else {
        printf("Line is invalid even after removal: %s\n", line);
    }
}

int main() {
    FILE *file_ptr;
    char ch;
    char buffer[MAX_LINE_LENGTH];
    int valid_count = 0;

    file_ptr = fopen("input.txt", "r");
    if (file_ptr == NULL) {
        printf("File cannot be opened\n");
        return 1;
    }

    while (fgets(buffer, MAX_LINE_LENGTH, file_ptr)) {
        buffer[strcspn(buffer, "\n")] = '\0';
        process_line(buffer, &valid_count);
    }

    fclose(file_ptr);
    printf("Total valid lines after checking removals: %d\n", valid_count);
    return 0;
}
