const std = @import("std");

pub fn main() !void {
    var input_file = try std.fs.cwd().openFile("input.txt", .{});
    defer input_file.close();

    var reader = input_file.reader();
    var buffer: [1024]u8 = undefined;
    var multiplication_sum: i64 = 0;
    var enable_multiplication = true;

    while (try reader.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        if (std.mem.eql(u8, line, "do()")) {
            enable_multiplication = true;
        } else if (std.mem.eql(u8, line, "don't()")) {
            enable_multiplication = false;
        } else if (std.mem.indexOf(u8, line, "mul(")) and enable_multiplication {
            var start_index = std.mem.indexOf(u8, line, "mul(").? + 4;
            var end_index = std.mem.indexOf(u8, line[start_index..], ")").?;
            var nums = line[start_index..start_index + end_index];
            var comma_index = std.mem.indexOf(u8, nums, ",").?;
            var num1 = try std.fmt.parseInt(i64, nums[0..comma_index], 10);
            var num2 = try std.fmt.parseInt(i64, nums[comma_index + 1 ..], 10);
            multiplication_sum += num1 * num2;
        }
    }

    std.debug.print("The sum of the results of the enabled multiplications is: {d}\n", .{multiplication_sum});
}

// fuck this