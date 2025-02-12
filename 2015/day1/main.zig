const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    // read the input file
    var input_file = try std.fs.cwd().openFile("input.txt", .{});
    defer input_file.close();

    var buffered = std.io.bufferedReader(input_file.reader());
    var bufreader = buffered.reader();

    var buffer: [17800]u8 = undefined;
    @memset(buffer[0..], 0);

    // read the entire input file into the buffer
    _ = try bufreader.readUntilDelimiterOrEof(buffer[0..], '\n');
    var floor: i32 = 0;
    for (buffer) |c| {
        switch (c) {
            '(' => floor += 1,
            ')' => floor -= 1,
            else => {},
            if (floor == -1) {
                break;
            }
        }
    }
    try stdout.print("{}", .{floor});
}
