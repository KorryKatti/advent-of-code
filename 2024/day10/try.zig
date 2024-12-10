// Learned about std imports from docs
const std = @import("std");
// Found out about these in the allocator chapter
const print = std.debug.print;
const ArrayList = std.ArrayList;

// Making const because the docs say it's good practice
const Grid = struct {
    // Not sure if these numbers are big enough but worked in examples
    data: [999][999]u8 = undefined,
    width: usize = 0,
    height: usize = 0,
};

// Read in chapter about error handling that we should make custom errors
const GridError = error{
    FileTooLarge,
    InvalidCharacter,
};

// Saw this pattern in the docs for tracking visited spots
const Visited = struct {
    // Initialize with false as learned from arrays chapter
    spots: [999][999]bool = [_][999]bool{[_]bool{false} ** 999} ** 999,
    
    // Making methods because the book said it's more "Ziggy"
    fn markVisited(self: *Visited, x: usize, y: usize) void {
        self.spots[y][x] = true;
    }

    fn wasVisited(self: *Visited, x: usize, y: usize) bool {
        return self.spots[y][x];
    }

    // Reset everything - probably not efficient but it works
    fn clearAll(self: *Visited) void {
        for (0..999) |y| {
            for (0..999) |x| {
                self.spots[y][x] = false;
            }
        }
    }

    // Count visited spots - there's probably a better way
    fn countVisited(self: *Visited) usize {
        var count: usize = 0;
        for (0..999) |y| {
            for (0..999) |x| {
                if (self.spots[y][x]) count += 1;
            }
        }
        return count;
    }
};

// Helper function I made after reading about optionals
fn isValidSpot(grid: *Grid, x: isize, y: isize) bool {
    if (x < 0) return false;
    if (y < 0) return false;
    // Need to cast because learned about type safety
    if (x >= @as(isize, @intCast(grid.width))) return false;
    if (y >= @as(isize, @intCast(grid.height))) return false;
    return true;
}

// Part 1 recursive function - using pointers because the book said they're important
fn findPath1(grid: *Grid, visited: *Visited, x: isize, y: isize, current_height: u8) void {
    if (current_height == 9) {
        visited.markVisited(@intCast(x), @intCast(y));
        return;
    }

    // Check all directions - probably could use a loop but this works
    // Using if-else chains because still learning switch syntax
    if (isValidSpot(grid, x - 1, y)) {
        if (grid.data[@intCast(y)][@intCast(x - 1)] == current_height + 1) {
            findPath1(grid, visited, x - 1, y, current_height + 1);
        }
    }

    if (isValidSpot(grid, x + 1, y)) {
        if (grid.data[@intCast(y)][@intCast(x + 1)] == current_height + 1) {
            findPath1(grid, visited, x + 1, y, current_height + 1);
        }
    }

    if (isValidSpot(grid, x, y - 1)) {
        if (grid.data[@intCast(y - 1)][@intCast(x)] == current_height + 1) {
            findPath1(grid, visited, x, y - 1, current_height + 1);
        }
    }

    if (isValidSpot(grid, x, y + 1)) {
        if (grid.data[@intCast(y + 1)][@intCast(x)] == current_height + 1) {
            findPath1(grid, visited, x, y + 1, current_height + 1);
        }
    }
}

// Part 2 recursive function - similar to part 1 but returns a number
fn findPath2(grid: *Grid, x: isize, y: isize, current_height: u8) usize {
    if (current_height == 9) {
        return 1;
    }

    var total: usize = 0;

    // Same direction checking as part 1
    if (isValidSpot(grid, x - 1, y)) {
        if (grid.data[@intCast(y)][@intCast(x - 1)] == current_height + 1) {
            total += findPath2(grid, x - 1, y, current_height + 1);
        }
    }

    if (isValidSpot(grid, x + 1, y)) {
        if (grid.data[@intCast(y)][@intCast(x + 1)] == current_height + 1) {
            total += findPath2(grid, x + 1, y, current_height + 1);
        }
    }

    if (isValidSpot(grid, x, y - 1)) {
        if (grid.data[@intCast(y - 1)][@intCast(x)] == current_height + 1) {
            total += findPath2(grid, x, y - 1, current_height + 1);
        }
    }

    if (isValidSpot(grid, x, y + 1)) {
        if (grid.data[@intCast(y + 1)][@intCast(x)] == current_height + 1) {
            total += findPath2(grid, x, y + 1, current_height + 1);
        }
    }

    return total;
}

pub fn main() !void {
    // Got this from file examples in docs
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    // Read the file - copied from documentation
    const file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();

    var grid = Grid{};
    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    // Read line by line - saw this pattern in examples
    var buf: [1024]u8 = undefined;
    var row: usize = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        // Save width from first line
        if (row == 0) {
            grid.width = line.len;
        }

        // Copy characters to grid
        for (line, 0..) |char, col| {
            // Check if it's a number - learned about number parsing
            if (char >= '0' and char <= '9') {
                grid.data[row][col] = char - '0';
            } else {
                return GridError.InvalidCharacter;
            }
        }
        row += 1;
    }
    grid.height = row;

    // Part 1 - find all paths starting from 0
    var visited = Visited{};
    var part1_answer: usize = 0;

    // Nested loops like in C
    var y: usize = 0;
    while (y < grid.height) : (y += 1) {
        var x: usize = 0;
        while (x < grid.width) : (x += 1) {
            if (grid.data[y][x] == 0) {
                visited.clearAll();
                findPath1(&grid, &visited, @intCast(x), @intCast(y), 0);
                part1_answer += visited.countVisited();
            }
        }
    }

    // Part 2 - similar but different function
    var part2_answer: usize = 0;
    y = 0;
    while (y < grid.height) : (y += 1) {
        var x: usize = 0;
        while (x < grid.width) : (x += 1) {
            if (grid.data[y][x] == 0) {
                part2_answer += findPath2(&grid, @intCast(x), @intCast(y), 0);
            }
        }
    }

    // Print answers - learned about formatting strings
    print("Part 1: {d}\n", .{part1_answer});
    print("Part 2: {d}\n", .{part2_answer});
}