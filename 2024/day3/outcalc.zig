const std = @import("std");

pub fn main() !void {
    // Open the input file
    var input_file = try std.fs.cwd().openFile("output.txt", .{});
    defer input_file.close();

    var buffered = std.io.bufferedReader(input_file.reader());
    var bufreader = buffered.reader();

    // Open the output file
    var output_file = try std.fs.cwd().createFile("output2.txt", .{});
    defer output_file.close();

    var output_writer = output_file.writer();

    var line_buffer: [1024]u8 = undefined;

    while (true) {
        const read_result = try bufreader.readUntilDelimiterOrEof(line_buffer[0..], '\n');

        if (read_result == null) {
            break; // End of file
        }

        const line = read_result.?; // safely unwrap the result

        // Trim leading/trailing spaces to make matching more flexible
        var trimmed_line = line;
        while (trimmed_line.len > 0 and (trimmed_line[0] == ' ' or trimmed_line[0] == '\t')) {
            trimmed_line = trimmed_line[1..]; // Remove leading spaces
        }
        while (trimmed_line.len > 0 and (trimmed_line[trimmed_line.len - 1] == ' ' or trimmed_line[trimmed_line.len - 1] == '\t')) {
            trimmed_line = trimmed_line[0..trimmed_line.len - 1]; // Remove trailing spaces
        }

        // Check if the line starts with "mul(" and ends with ")"
        if (trimmed_line.len > 4 and std.mem.eql(u8, trimmed_line[0..4], "mul(") and trimmed_line[trimmed_line.len - 1] == ')') {
            // Extract the content inside "mul()" by slicing the string
            const content = trimmed_line[4..trimmed_line.len - 1]; // Remove "mul(" and ")"
            try output_writer.print("{s}\n", .{content});
        }
    }
}
