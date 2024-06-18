const std = @import("std");
const H5 = @import("HDF.zig");

pub fn main() !void {
    try H5.open();
    const version = try H5.getLibVersion();
    std.log.info("{any}", .{version});
}
