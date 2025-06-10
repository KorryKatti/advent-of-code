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
    for (lines.items) |line| {
        std.debug.print("{s}\n", .{line});
    }
}
