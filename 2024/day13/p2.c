#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Make a structure to store machine info
struct Machine {
    int ax, ay;  // button A moves
    int bx, by;  // button B moves
    int px, py;  // prize location
};

// Function to read one machine from file
// Return 1 if successful, 0 if end of file
int read_machine(FILE *file, struct Machine *machine) {
    char line[100];  // buffer for reading lines
    
    // Try to read first line (Button A)
    if (fgets(line, sizeof(line), file) == NULL) {
        return 0;  // end of file
    }
    
    // Read Button A movements
    sscanf(line, "Button A: X+%d, Y+%d", &machine->ax, &machine->ay);
    
    // Read Button B movements
    fgets(line, sizeof(line), file);
    sscanf(line, "Button B: X+%d, Y+%d", &machine->bx, &machine->by);
    
    // Read Prize location
    fgets(line, sizeof(line), file);
    sscanf(line, "Prize: X=%d, Y=%d", &machine->px, &machine->py);
    
    // Skip empty line if it exists
    fgets(line, sizeof(line), file);
    
    return 1;
}

// Function to check if we can win prize with given button presses
// Return minimum tokens needed, or -1 if impossible
int try_win_prize(struct Machine machine) {
    // Add a print statement to show the program is working
    printf("Checking prize location: X=%d, Y=%d\n", machine.px, machine.py);

    // Try all combinations of button presses, increasing range as necessary
    int max_steps = 1000000; // Increasing the max steps
    for (int a = 0; a <= max_steps; a++) { 
        for (int b = 0; b <= max_steps; b++) {
            // Calculate where claw will end up
            int x = a * machine.ax + b * machine.bx;
            int y = a * machine.ay + b * machine.by;
            
            // Check if we reached the prize
            if (x == machine.px && y == machine.py) {
                // Calculate tokens needed (A costs 3, B costs 1)
                return (a * 3) + (b * 1);
            }
        }
        
        // Print progress at intervals
        if (a % 500 == 0) {
            printf("Checked %d button A steps\n", a);
        }
    }
    
    // If we get here, no solution found
    return -1;
}

int main() {
    FILE *file = fopen("output.txt", "r");
    if (file == NULL) {
        printf("Error: Can't open output.txt\n");
        return 1;
    }
    
    struct Machine machine;
    int total_tokens = 0;
    int machines_won = 0;
    
    // Read and process each machine
    while (read_machine(file, &machine)) {
        int tokens_needed = try_win_prize(machine);
        
        if (tokens_needed != -1) {
            total_tokens += tokens_needed;
            machines_won++;
            printf("Found solution for machine %d: %d tokens\n", 
                   machines_won, tokens_needed);
        } else {
            printf("No solution for machine %d\n", machines_won + 1);
        }
    }
    
    printf("\nResults:\n");
    printf("Machines won: %d\n", machines_won);
    printf("Total tokens needed: %d\n", total_tokens);
    
    fclose(file);
    return 0;
}
