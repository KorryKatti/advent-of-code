const std = @import("std");

pub fn main() !void {
    // Open the input file
    var input_file = try std.fs.cwd().openFile("input.txt", .{});
    defer input_file.close();

    var buffered = std.io.bufferedReader(input_file.reader());
    var bufreader = buffered.reader();

    // Create the output file
    var output_file = try std.fs.cwd().createFile("output.txt", .{});
    defer output_file.close();
    var output_writer = output_file.writer();

    var buffer: [17799+1]u8 = undefined;
    @memset(buffer[0..], 0);

    // Read the entire input into the buffer
    _ = try bufreader.readUntilDelimiterOrEof(buffer[0..], '\n');

    const value = "mul(";
    var i: usize = 0;

    // Loop through the buffer to find all valid "mul(X,Y)" instructions
    while (i + value.len <= buffer.len) {
        if (std.mem.eql(u8, buffer[i..i + value.len], value)) {
            var j: usize = i + value.len;
            var paren_count: usize = 1;
            var is_valid: bool = false;

            // Look for the closing parenthesis to balance
            while (j < buffer.len) {
                if (buffer[j] == '(') {
                    paren_count += 1;
                } else if (buffer[j] == ')') {
                    paren_count -= 1;
                }

                // If balanced, mark as valid and stop searching
                if (paren_count == 0) {
                    is_valid = true;
                    break;
                }
                j += 1;
            }

            // If a valid "mul(X,Y)" is found, write it to the output
            if (is_valid) {
                const instance = buffer[i..j + 1]; // Include the closing parenthesis
                try output_writer.print("{s}\n", .{instance});
                i = j + 1; // Move past the current "mul(X,Y)"
            } else {
                // Skip the invalid "mul(" and continue searching
                i += value.len;
            }
        } else {
            // Move to the next character if no "mul(" is found
            i += 1;
        }
    }

    // Open the output file (renamed from input_file to output_file2)
    var output_file2 = try std.fs.cwd().openFile("output.txt", .{});
    defer output_file2.close();

    var buffered2 = std.io.bufferedReader(output_file2.reader());
    var bufreader2 = buffered2.reader();

    // Open the final output file for the second write
    var final_output_file = try std.fs.cwd().createFile("output2.txt", .{});
    defer final_output_file.close();

    var output_writer2 = final_output_file.writer();

    var line_buffer: [1024]u8 = undefined;

    while (true) {
        const read_result = try bufreader2.readUntilDelimiterOrEof(line_buffer[0..], '\n');

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
            try output_writer2.print("{s}\n", .{content});
        }
    }

    // Open the output file for the final parsing
    var output_file3 = try std.fs.cwd().openFile("output2.txt", .{});
    defer output_file3.close();

    var buffered3 = std.io.bufferedReader(output_file3.reader());
    var bufreader3 = buffered3.reader();

    var total: i64 = 0; // Accumulator for the total sum
    var line_buffer3: [1024]u8 = undefined;

    while (true) {
        const read_result = try bufreader3.readUntilDelimiterOrEof(line_buffer3[0..], '\n');

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
                // Parse the first number
                first_number = try parse_number(temp_buffer[0..temp_index]);
                is_second = true;
                temp_index = 0; // Reset buffer for second number
            } else if (char != '\n' and is_digit(char)) {
                // Only accumulate valid digits into the temp buffer
                temp_buffer[temp_index] = char;
                temp_index += 1;
            }
        }

        // Parse the second number after the loop ends
        second_number = try parse_number(temp_buffer[0..temp_index]);

        // Multiply and add to total
        total += first_number * second_number;
    }

    // Print the final total
    std.debug.print("Total sum of multiplications: {d}\n", .{total});
}

// Function to check if the character is a valid digit
fn is_digit(c: u8) bool {
    return c >= '0' and c <= '9';
}

// Function to parse the number from the buffer
fn parse_number(buffer: []u8) !i64 {
    var result: i64 = 0;
    for (buffer) |c| {
        result *= 10;
        result += c - '0';
    }
    return result;
}
