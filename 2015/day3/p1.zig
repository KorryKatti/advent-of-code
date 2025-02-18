const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var input_file = try std.fs.cwd().openFile("input.txt", .{});
    defer input_file.close();

    var buffered = std.io.bufferedReader(input_file.reader());
    var bufreader = buffered.reader();

    var x: i32 = 0; // santa's x position
    var y: i32 = 0; // santa's y position

    var visited = std.ArrayList(struct { i32, i32 }).init(std.heap.page_allocator);
    defer visited.deinit(); // clean up memory

    try visited.append(.{ x, y }); // start at (0,0)

    while (try bufreader.readUntilDelimiterOrEofAlloc(std.heap.page_allocator, '\n', 10240)) |line| {
        defer std.heap.page_allocator.free(line); // free line memory after use

        for (line) |c| {
            switch (c) {
                '^' => y += 1, // move north
                'v' => y -= 1, // move south
                '>' => x += 1, // move east
                '<' => x -= 1, // move west
                else => {},
            }

            var already_visited = false;
            for (visited.items) |house| {
                if (house[0] == x and house[1] == y) {
                    already_visited = true;
                    break;
                }
            }

            if (!already_visited) {
                try visited.append(.{ x, y });
            }
        }
    }

    try stdout.print("{}\n", .{visited.items.len});
}
