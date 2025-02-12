const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    // open the input file (same as before)
    var input_file = try std.fs.cwd().openFile("input.txt", .{});
    defer input_file.close(); // close file when we're done

    var buffered = std.io.bufferedReader(input_file.reader());
    var bufreader = buffered.reader();

    // buffer to hold file content
    var buffer: [17800]u8 = undefined;
    @memset(buffer[0..], 0); // clear out garbage data

    // read input into buffer
    _ = try bufreader.readUntilDelimiterOrEof(buffer[0..], '\n');

    // tracking variables
    var floor: i32 = 0; // current floor
    var position: usize = 0; // first basement entry position

    // loop through input, with index (0-based)
    for (buffer, 0..) |c, idx| {
        switch (c) {
            '(' => floor += 1, // up one floor
            ')' => floor -= 1, // down one floor
            else => {}, // ignore any weird chars
        }

        // if we hit the basement (-1) for the first time
        if (floor == -1) {
            position = idx + 1; // make it 1-based index
            break; // stop looping, we got what we need
        }
    }

    // print result
    try stdout.print("{}", .{position});
}
