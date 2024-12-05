const std = @import("std");

pub fn main() !void {
    // Open the input file
    var input_file = try std.fs.cwd().openFile("input.txt", .{});
    defer input_file.close();

    var buffered = std.io.bufferedReader(input_file.reader());
    var reader = buffered.reader();

    var buffer: [1024 * 4]u8 = undefined;
    const content = try reader.readUntilDelimiterOrEof(&buffer, '\n') orelse return;

    var total: i64 = 0;
    var i: usize = 0;

    while (i < content.len) : (i += 1) {
        // Look for potential mul instruction starting at position i
        if (findValidMul(content[i..])) |result| {
            const slice = getInstructionSlice(content[i..]);
            std.debug.print("Found mul: {s} = {d}\n", .{slice, result});
            total += result;
        }
    }

    std.debug.print("\nTotal sum of multiplications: {d}\n", .{total});
}

fn getInstructionSlice(text: []const u8) []const u8 {
    var i: usize = 4; // Skip "mul("
    while (i < text.len) : (i += 1) {
        if (text[i] == ')') {
            return text[0..i + 1];
        }
    }
    return text;
}

fn findValidMul(text: []const u8) ?i64 {
    // Need at least "mul(1,1)" (7 characters)
    if (text.len < 7) return null;
    
    // Look for "mul("
    if (!std.mem.startsWith(u8, text, "mul(")) return null;
    
    const first_num_start: usize = 4; // Position after "mul("
    var i: usize = first_num_start;
    var first_num_end: ?usize = null;
    var second_num_start: ?usize = null;
    var second_num_end: ?usize = null;
    
    // Find first number
    while (i < text.len) : (i += 1) {
        if (!isDigit(text[i])) {
            if (i == first_num_start) return null; // No digits found
            if (i - first_num_start > 3) return null; // More than 3 digits
            if (text[i] != ',') return null; // Must be followed by comma
            first_num_end = i;
            second_num_start = i + 1;
            break;
        }
    }
    if (first_num_end == null) return null;
    
    // Find second number
    i = second_num_start.?;
    while (i < text.len) : (i += 1) {
        if (!isDigit(text[i])) {
            if (i == second_num_start.?) return null; // No digits found
            if (i - second_num_start.? > 3) return null; // More than 3 digits
            if (text[i] != ')') return null; // Must be followed by closing paren
            second_num_end = i;
            break;
        }
    }
    if (second_num_end == null) return null;
    
    // Parse the numbers
    const first = std.fmt.parseInt(i64, text[first_num_start..first_num_end.?], 10) catch return null;
    const second = std.fmt.parseInt(i64, text[second_num_start.?..second_num_end.?], 10) catch return null;
    
    return first * second;
}

fn isDigit(c: u8) bool {
    return c >= '0' and c <= '9';
}