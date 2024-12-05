const fs = require('fs');

// Read the input from input.txt
const input = fs.readFileSync('input.txt', 'utf8').split('\n').map(line => line.split(''));

// Size of the grid
const rows = input.length;
const cols = input[0].length;

// Function to check if a valid "X-MAS" pattern exists at a given center (i, j)
function checkXMas(i, j) {
    // Ensure the indices are within bounds
    if (i - 1 >= 0 && i + 1 < rows && j - 1 >= 0 && j + 1 < cols) {
        // Forward check (M.S, .A., M.S)
        if (
            input[i - 1][j - 1] === 'M' && input[i][j] === 'A' && input[i + 1][j + 1] === 'S' &&
            input[i + 1][j - 1] === 'M' && input[i][j + 1] === 'S' && input[i - 1][j + 1] === 'S'
        ) {
            return true;
        }
        
        // Reverse check (S.M, .A., S.M)
        if (
            input[i - 1][j + 1] === 'M' && input[i][j] === 'A' && input[i + 1][j - 1] === 'S' &&
            input[i + 1][j + 1] === 'M' && input[i][j - 1] === 'S' && input[i - 1][j - 1] === 'S'
        ) {
            return true;
        }
    }
    return false;
}

// Variable to count the number of "X-MAS" patterns
let xmasCount = 0;

// Loop through all possible centers for "X-MAS" pattern
for (let i = 1; i < rows - 1; i++) {
    for (let j = 1; j < cols - 1; j++) {
        // Check if the center character is 'A' and if a valid "X-MAS" exists
        if (input[i][j] === 'A' && checkXMas(i, j)) {
            xmasCount++;
        }
    }
}

console.log('Total X-MAS Count:', xmasCount);
