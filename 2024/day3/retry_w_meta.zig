const std = @import("std");

pub fn main() !void {
    var input_file = try std.fs.cwd().openFile("input.txt", .{});
    defer input_file.close();

    var buffer: [1024 * 1024]u8 = undefined;
    const content = try input_file.reader().readAll(&buffer);
    var text = buffer[0..content]; // Create a slice from the buffer

    var total: i64 = 0;
    var i: usize = 0;

    while (i < text.len) : (i += 1) {
        if (i + 4 <= text.len and std.mem.eql(u8, text[i..i + 4], "mul(")) {
            var j: usize = i + 4;
            while (j < text.len) : (j += 1) {
                if (text[j] == ')') {
                    var instruction = text[i..j + 1];
                    var comma_pos: usize = 0;
                    for (instruction, 0..) |c, k| {
                        if (c == ',') {
                            comma_pos = k;
                            break;
                        }
                    }

                    var first_num_str = instruction[4..comma_pos];
                    var second_num_str = instruction[comma_pos + 1 .. instruction.len - 1];

                    // Remove any non-digit characters from the strings
                    first_num_str = std.mem.trim(u8, first_num_str, &[_]u8{ ' ', '\t', '\r', '\n' });
                    second_num_str = std.mem.trim(u8, second_num_str, &[_]u8{ ' ', '\t', '\r', '\n' });

                    if (first_num_str.len == 0 or second_num_str.len == 0) {
                        // Skip this instruction if either number is empty
                        continue;
                    }

                    const first_num = std.fmt.parseInt(i64, first_num_str, 10) catch continue;
                    const second_num = std.fmt.parseInt(i64, second_num_str, 10) catch continue;

                    total += first_num * second_num;
                    i = j; // Skip the rest of the instruction
                    break;
                }
            }
        }
    }

    std.debug.print("Total sum of multiplications: {d}\n", .{total});
}