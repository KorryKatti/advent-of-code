const std = @import("std");
const hash = std.crypto.hash;

pub fn main() !void {
    var num: i64 = 9;
    var buffer: [20]u8 = undefined;
    var md5_output: [16]u8 = undefined;

    const stdout = std.io.getStdOut().writer();
    const allocator = std.heap.page_allocator;

    const inpt: []const u8 = "iwrupvqb";

    while (true) {
        const num_str = std.fmt.bufPrint(&buffer, "{}", .{num}) catch unreachable;

        const new = try std.mem.concat(allocator, u8, &.{ inpt, num_str });
        defer allocator.free(new); // free memory after use

        hash.Md5.hash(new, &md5_output, .{});

        var hash_str: [32]u8 = undefined;
        _ = std.fmt.bufPrint(&hash_str, "{s}", .{std.fmt.fmtSliceHexLower(&md5_output)}) catch unreachable;

        if (std.mem.startsWith(u8, &hash_str, "000000")) {
            try stdout.print("Found number: {}\n", .{num});
            try stdout.print("MD5: {s}\n", .{&hash_str});
            break;
        }

        num += 1;
    }
}

// p1 is just fives zeroes , p2 is six hence no separate files
