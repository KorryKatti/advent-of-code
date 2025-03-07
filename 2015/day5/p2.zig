const std = @import("std");
const readit = @import("readit.zig");

pub fn main() !void {
    var gpa = std.heap.page_allocator;
    var lines = try readit.readLines(gpa, "input.txt");

    defer {
        for (lines.items) |line| {
            gpa.free(line);
        }
        lines.deinit();
    }

    var nice_count: usize = 0;

    for (lines.items) |line| {
        var has_repeating_pair = false;
        var has_sandwich_letter = false;

        var i: usize = 0;
        while (i + 1 < line.len) {
            const pair = line[i .. i + 2];
            if (std.mem.indexOfPos(u8, line, i + 2, pair) != null) {
                has_repeating_pair = true;
                break;
            }
            i += 1;
        }

        i = 0;
        while (i + 2 < line.len) {
            if (line[i] == line[i + 2]) {
                has_sandwich_letter = true;
                break;
            }
            i += 1;
        }

        if (has_repeating_pair and has_sandwich_letter) {
            nice_count += 1;
        }
    }

    std.debug.print("\nNice strings: {}\n", .{nice_count});
}
