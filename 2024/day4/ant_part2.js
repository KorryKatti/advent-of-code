const fs = require('fs');

// Read the input from input.txt
const input = fs.readFileSync('input.txt', 'utf8').split('\n').map(line => line.split(''));

// Size of the grid
const rows = input.length;
const cols = input[0].length;

// Function to check if a valid "X-MAS" pattern exists at a given center (i, j)
function checkXMas(i, j) {
    // Only need to check if centered on 'A'
    if (input[i][j] !== 'A') return false;
    
    // Ensure the indices are within bounds
    if (i - 1 >= 0 && i + 1 < rows && j - 1 >= 0 && j + 1 < cols) {
        // Check top-left to bottom-right diagonal MAS
        const topLeftToBottomRight = (
            (
                // Forward MAS
                input[i - 1][j - 1] === 'M' &&
                input[i][j] === 'A' &&
                input[i + 1][j + 1] === 'S'
            ) ||
            (
                // Backward SAM
                input[i - 1][j - 1] === 'S' &&
                input[i][j] === 'A' &&
                input[i + 1][j + 1] === 'M'
            )
        );

        // Check top-right to bottom-left diagonal MAS
        const topRightToBottomLeft = (
            (
                // Forward MAS
                input[i - 1][j + 1] === 'M' &&
                input[i][j] === 'A' &&
                input[i + 1][j - 1] === 'S'
            ) ||
            (
                // Backward SAM
                input[i - 1][j + 1] === 'S' &&
                input[i][j] === 'A' &&
                input[i + 1][j - 1] === 'M'
            )
        );

        // For a valid X-MAS, we need one MAS (or SAM) in each diagonal
        return topLeftToBottomRight && topRightToBottomLeft;
    }
    return false;
}

// Variable to count the number of "X-MAS" patterns
let xmasCount = 0;

// Loop through all possible centers for "X-MAS" pattern
for (let i = 1; i < rows - 1; i++) {
    for (let j = 1; j < cols - 1; j++) {
        if (checkXMas(i, j)) {
            xmasCount++;
        }
    }
}

console.log('Total X-MAS Count:', xmasCount);


// thanks claude , while i could code it myself i wasnt too confident about my knowledge of file characters looping in js