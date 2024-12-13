#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct Machine {
    int ax, ay;
    int bx, by;
    int px, py;
};

int read_machine(FILE *file, struct Machine *machine) {
    char line[100];
    if (fgets(line, sizeof(line), file) == NULL) {
        return 0;
    }
    sscanf(line, "Button A: X+%d, Y+%d", &machine->ax, &machine->ay);
    fgets(line, sizeof(line), file);
    sscanf(line, "Button B: X+%d, Y+%d", &machine->bx, &machine->by);
    fgets(line, sizeof(line), file);
    sscanf(line, "Prize: X=%d, Y=%d", &machine->px, &machine->py);
    fgets(line, sizeof(line), file);
    return 1;
}

int try_win_prize(struct Machine machine) {
    for (int a = 0; a <= 100; a++) {
        for (int b = 0; b <= 100; b++) {
            int x = a * machine.ax + b * machine.bx;
            int y = a * machine.ay + b * machine.by;
            if (x == machine.px && y == machine.py) {
                return (a * 3) + (b * 1);
            }
        }
    }
    return -1;
}

int main() {
    FILE *file = fopen("input.txt", "r");
    if (file == NULL) {
        printf("Error: Can't open input.txt\n");
        return 1;
    }
    
    struct Machine machine;
    int total_tokens = 0;
    int machines_won = 0;
    
    while (read_machine(file, &machine)) {
        int tokens_needed = try_win_prize(machine);
        if (tokens_needed != -1) {
            total_tokens += tokens_needed;
            machines_won++;
            printf("Found solution for machine %d: %d tokens\n", machines_won, tokens_needed);
        }
    }
    
    printf("\nResults:\n");
    printf("Machines won: %d\n", machines_won);
    printf("Total tokens needed: %d\n", total_tokens);
    
    fclose(file);
    return 0;
}
