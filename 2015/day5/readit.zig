const std = @import("std");

pub fn readFile(allocator: std.mem.Allocator, path: []const u8) ![]u8 {
    var file = try std.fs.cwd().openFile(path, .{ .mode = .read_only });
    defer file.close();

    const stat = try file.stat();
    const buffer = try allocator.alloc(u8, stat.size);
    _ = try file.readAll(buffer);

    return buffer;
}

pub fn readFileSimple(path: []const u8) ![1024]u8 {
    var file = try std.fs.cwd().openFile(path, .{ .mode = .read_only });
    defer file.close();

    var buffer: [1024]u8 = undefined;
    _ = try file.readAll(&buffer);

    return buffer;
}

pub fn readLines(allocator: std.mem.Allocator, path: []const u8) !std.ArrayList([]const u8) {
    var file = try std.fs.cwd().openFile(path, .{ .mode = .read_only });
    defer file.close();

    var reader = std.io.bufferedReader(file.reader());
    var buf_reader = reader.reader();
    var lines = std.ArrayList([]const u8).init(allocator);

    var line_buffer: [1024]u8 = undefined;
    while (try buf_reader.readUntilDelimiterOrEof(&line_buffer, '\n')) |line| {
        try lines.append(try allocator.dupe(u8, line));
    }

    return lines;
}
