const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var input_file = try std.fs.cwd().openFile("input.txt", .{});
    defer input_file.close(); // make sure file closes when we're done

    var buffered = std.io.bufferedReader(input_file.reader());
    var bufreader = buffered.reader();

    var buffer: [1024]u8 = undefined; // temporary storage for reading each line
    var total_sum: i64 = 0; // running total of all wrapping paper needed

    while (try bufreader.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        var numbers: [3]i64 = undefined; // store the three numbers (length, width, height)
        var num_index: usize = 0; // tracks which number we're storing (0,1,2)
        var num: i64 = 0; // holds the current number while reading

        // loop through each character in the line
        for (line) |char| {
            switch (char) {
                '0'...'9' => {
                    // build the number (e.g., if we read '4' then '2', we get 42)
                    num = num * 10 + (char - '0');
                },
                'x' => {
                    // store the completed number into our array
                    if (num_index < 3) {
                        numbers[num_index] = num;
                        num_index += 1;
                    }
                    num = 0; // reset for the next number
                },
                else => {}, // ignore other characters
            }
        }
        // store the last number (since there's no 'x' after it)
        if (num_index < 3) {
            numbers[num_index] = num;
        }

        // extract length (l), width (w), and height (h)
        const l = numbers[0];
        const w = numbers[1];
        const h = numbers[2];

        // calculate surface area of the box (each side twice)
        const side1 = l * w;
        const side2 = w * h;
        const side3 = h * l;
        const surface_area = 2 * side1 + 2 * side2 + 2 * side3;

        // extra paper needed = smallest side's area
        const slack = @min(side1, @min(side2, side3));

        // total wrapping paper needed for this box
        const line_sum = surface_area + slack;
        total_sum += line_sum;

        // print per-box result
        try stdout.print("Box {}x{}x{} needs: {} sq ft\n----------\n", .{ l, w, h, line_sum });
    }

    // final total wrapping paper needed
    try stdout.print("Total wrapping paper needed: {} sq ft\n", .{total_sum});
}
