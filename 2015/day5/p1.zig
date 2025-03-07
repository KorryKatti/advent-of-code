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

    const forbidden = [_][]const u8{ "ab", "cd", "pq", "xy" };
    const vowels = [_]u8{ 'a', 'e', 'i', 'o', 'u' };
    const allow = [_][]const u8{ "aa", "bb", "cc", "dd", "ee", "ff", "gg", "hh", "ii", "jj", "kk", "ll", "mm", "nn", "oo", "pp", "qq", "rr", "ss", "tt", "uu", "vv", "ww", "xx", "yy", "zz" };

    var nice_count: usize = 0;

    for (lines.items) |line| {
        var is_naughty = false;
        var vowel_count: usize = 0;
        var has_double = false;

        // check for forbidden substrings
        for (forbidden) |bad_str| {
            if (std.mem.indexOf(u8, line, bad_str) != null) {
                is_naughty = true;
                break;
            }
        }
        if (is_naughty) continue;

        // count vowels
        for (line) |char| {
            if (std.mem.indexOfScalar(u8, &vowels, char) != null) {
                vowel_count += 1;
            }
        }
        if (vowel_count < 3) continue;

        // check for double letters
        for (allow) |pair| {
            if (std.mem.indexOf(u8, line, pair) != null) {
                has_double = true;
                break;
            }
        }
        if (!has_double) continue;

        // if all conditions are met, it's nice
        nice_count += 1;
    }

    std.debug.print("\nNice strings: {}\n", .{nice_count});
}
