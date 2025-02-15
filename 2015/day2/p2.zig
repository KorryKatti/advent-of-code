const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var input_file = try std.fs.cwd().openFile("input.txt", .{});
    defer input_file.close();

    var buffered = std.io.bufferedReader(input_file.reader());
    var bufreader = buffered.reader();

    var buffer: [1024]u8 = undefined;
    var total_paper: i64 = 0;
    var total_ribbon: i64 = 0;

    while (try bufreader.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        var numbers: [3]i64 = undefined;
        var num_index: usize = 0;
        var num: i64 = 0;

        for (line) |char| {
            switch (char) {
                '0'...'9' => {
                    num = num * 10 + (char - '0');
                },
                'x' => {
                    if (num_index < 3) {
                        numbers[num_index] = num;
                        num_index += 1;
                    }
                    num = 0;
                },
                else => {},
            }
        }
        if (num_index < 3) {
            numbers[num_index] = num;
        }

        const l = numbers[0];
        const w = numbers[1];
        const h = numbers[2];

        const side1 = l * w;
        const side2 = w * h;
        const side3 = h * l;
        const surface_area = 2 * side1 + 2 * side2 + 2 * side3;
        const slack = @min(side1, @min(side2, side3));
        total_paper += surface_area + slack;

        const perim1 = 2 * (l + w);
        const perim2 = 2 * (w + h);
        const perim3 = 2 * (h + l);
        const min_perim = @min(perim1, @min(perim2, perim3));
        total_ribbon += min_perim + (l * w * h);
    }

    try stdout.print("{}\n{}\n", .{ total_paper, total_ribbon });
}
