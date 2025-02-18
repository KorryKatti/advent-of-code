const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var input_file = try std.fs.cwd().openFile("input.txt", .{});
    defer input_file.close();

    var buffered = std.io.bufferedReader(input_file.reader());
    var bufreader = buffered.reader();

    var buffer: [18000]u8 = undefined;

    var visited_houses: [2000000000]bool = undefined;
    const offset: u64 = 1000;
    visited_houses[offset * offset] = true;

    var sx: u64 = 0;
    var sy: u64 = 0;
    var rx: u64 = 0;
    var ry: u64 = 0;

    var visit_count: i64 = 1;

    while (try bufreader.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        var turn: bool = true;

        for (line) |c| {
            if (turn) {
                switch (c) {
                    '^' => sy += 1,
                    'v' => sy -= 1,
                    '>' => sx += 1,
                    '<' => sx -= 1,
                    else => {},
                }
                if (!visited_houses[(sx + offset) * offset + (sy + offset)]) {
                    visited_houses[(sx + offset) * offset + (sy + offset)] = true;
                    visit_count += 1;
                }
            } else {
                switch (c) {
                    '^' => ry += 1,
                    'v' => ry -= 1,
                    '>' => rx += 1,
                    '<' => rx -= 1,
                    else => {},
                }
                if (!visited_houses[(rx + offset) * offset + (ry + offset)]) {
                    visited_houses[(rx + offset) * offset + (ry + offset)] = true;
                    visit_count += 1;
                }
            }
            turn = !turn;
        }
        //turn = !turn;
    }
    try stdout.print("{}\n", .{visit_count});
}
