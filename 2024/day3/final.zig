const std = @import("std");

pub fn main() !void {
    // Open the input file
    var input_file = try std.fs.cwd().openFile("output2.txt", .{});
    defer input_file.close();

    var buffered = std.io.bufferedReader(input_file.reader());
    var bufreader = buffered.reader();

    var total: i64 = 0; // Accumulator for the total sum
    var line_buffer: [1024]u8 = undefined;

    while (true) {
        const read_result = try bufreader.readUntilDelimiterOrEof(line_buffer[0..], '\n');

        if (read_result == null) {
            break; // End of file
        }

        const line = read_result.?; // Get the line

        var first_number: i64 = 0;
        var second_number: i64 = 0;
        var is_second: bool = false;
        var temp_buffer: [32]u8 = undefined;
        var temp_index: usize = 0;

        var idx: usize = 0; // Explicit index variable
        while (idx < line.len) : (idx += 1) {
            const char = line[idx];
            if (char == ',') {
                // Comma encountered, parse the first number
                first_number = try std.fmt.parseInt(i64, temp_buffer[0..temp_index], 10);
                is_second = true;
                temp_index = 0; // Reset buffer for second number
            } else if (char != '\n') {
                // Accumulate the number into temp buffer
                temp_buffer[temp_index] = char;
                temp_index += 1;
            }
        }

        // Parse the second number after the loop ends
        second_number = try std.fmt.parseInt(i64, temp_buffer[0..temp_index], 10);

        // Multiply and add to total
        total += first_number * second_number;
    }

    // Print the final total
    std.debug.print("Total sum of multiplications: {d}\n", .{total});
}
