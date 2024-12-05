const fs = require('fs');

fs.readFile('input.txt', 'utf8', (err, data) => {
  if (err) {
    console.error('Error reading file:', err);
    return;
  }

  const rows = data.split('\n').map(row => row.trim().split(''));
  const rowsCount = rows.length;
  const colsCount = rows[0].length;
  let totalCount = 0;

  function checkDirection(startRow, startCol, rowDelta, colDelta) {
    let word = '';
    for (let k = 0; k < 4; k++) {
      const newRow = startRow + k * rowDelta;
      const newCol = startCol + k * colDelta;
      if (newRow < 0 || newRow >= rowsCount || newCol < 0 || newCol >= colsCount) {
        return false;
      }
      word += rows[newRow][newCol];
    }
    return word === 'XMAS';
  }

  // Function to check all directions for a starting point
  function checkAllDirections(row, col) {
    const directions = [
      { rowDelta: 0, colDelta: 1 },  // Horizontal (forward)
      { rowDelta: 0, colDelta: -1 }, // Horizontal (reverse)
      { rowDelta: 1, colDelta: 0 },  // Vertical (downward)
      { rowDelta: -1, colDelta: 0 }, // Vertical (upward)
      { rowDelta: 1, colDelta: 1 },  // Diagonal (forward)
      { rowDelta: 1, colDelta: -1 }, // Diagonal (backward)
      { rowDelta: -1, colDelta: 1 }, // Diagonal (reverse upward)
      { rowDelta: -1, colDelta: -1 } // Diagonal (reverse backward)
    ];

    for (const { rowDelta, colDelta } of directions) {
      if (checkDirection(row, col, rowDelta, colDelta)) {
        console.log(
          `Found XMAS ${describeDirection(rowDelta, colDelta)} at row ${row}, col ${col}`
        );
        totalCount++;
      }
    }
  }


  function describeDirection(rowDelta, colDelta) {
    if (rowDelta === 0 && colDelta === 1) return 'horizontally (forward)';
    if (rowDelta === 0 && colDelta === -1) return 'horizontally (reverse)';
    if (rowDelta === 1 && colDelta === 0) return 'vertically (downward)';
    if (rowDelta === -1 && colDelta === 0) return 'vertically (upward)';
    if (rowDelta === 1 && colDelta === 1) return 'diagonally (forward)';
    if (rowDelta === 1 && colDelta === -1) return 'diagonally (backward)';
    if (rowDelta === -1 && colDelta === 1) return 'diagonally (reverse upward)';
    if (rowDelta === -1 && colDelta === -1) return 'diagonally (reverse backward)';
    return 'in an unknown direction';
  }

  //check each cell as a potential start
  for (let i = 0; i < rowsCount; i++) {
    for (let j = 0; j < colsCount; j++) {
      checkAllDirections(i, j);
    }
  }

  console.log(`Total occurrences of XMAS: ${totalCount}`);
});

// thanks stackoverflow , my brain and some of chatgpt
// turns out javascript looks a lot like cell
// i think i like js now  