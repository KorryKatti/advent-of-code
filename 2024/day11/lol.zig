const std = @import("std");
const ArrayList = std.ArrayList;
const math = std.math;

pub fn main() !void {
    // Get allocator for memory management
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Initial stones
    const initial_stones = [_]u64{ 1750884, 193, 866395, 7, 1158, 31, 35216, 0 };
    const blinks: u32 = 75;
    
    const result = try evolveStones(allocator, &initial_stones, blinks);
    std.debug.print("Number of stones after {d} blinks: {d}\n", .{ blinks, result });
}

fn evolveStones(allocator: std.mem.Allocator, initial_stones: []const u64, blinks: u32) !usize {
    // Create dynamic arrays for stones
    var stones = ArrayList(u64).init(allocator);
    defer stones.deinit();
    var new_stones = ArrayList(u64).init(allocator);
    defer new_stones.deinit();

    // Initialize with initial stones
    try stones.appendSlice(initial_stones);

    // Create output file
    const file = try std.fs.cwd().createFile("output.txt", .{});
    defer file.close();
    const writer = file.writer();

    // Buffer for string conversion
    var number_buffer: [128]u8 = undefined;

    const start_time = std.time.milliTimestamp();

    var blink: u32 = 0;
    while (blink < blinks) : (blink += 1) {
        new_stones.clearRetainingCapacity();

        for (stones.items) |stone| {
            if (stone == 0) {
                try new_stones.append(1);
            } else {
                // Convert number to string to check length
                const stone_str = try std.fmt.bufPrint(&number_buffer, "{d}", .{stone});
                
                if (stone_str.len % 2 == 0) {
                    const half = stone_str.len / 2;
                    const left = try std.fmt.parseInt(u64, stone_str[0..half], 10);
                    const right = try std.fmt.parseInt(u64, stone_str[half..], 10);
                    try new_stones.append(left);
                    try new_stones.append(right);
                } else {
                    try new_stones.append(stone * 2024);
                }
            }
        }

        // Write to file
        try writer.print("{d}\n", .{new_stones.items.len});
        for (new_stones.items, 0..) |stone, i| {
            if (i > 0) try writer.writeByte(' ');
            try writer.print("{d}", .{stone});
        }
        try writer.writeByte('\n');

        // Only print every 10th blink
        if (blink % 10 == 0) {
            std.debug.print("Blink {d}/{d}: {d} stones\n", .{ blink + 1, blinks, new_stones.items.len });
        }

        // Swap arrays
        const temp = stones;
        stones = new_stones;
        new_stones = temp;
    }

    const end_time = std.time.milliTimestamp();
    const total_time = @as(f64, @floatFromInt(end_time - start_time)) / 1000.0;
    std.debug.print("Total time taken: {d:.2} seconds\n", .{total_time});

    return stones.items.len;
}