const std = @import("std");
const H5 = @import("HDF.zig");

pub fn main() !void {

    try H5.H5Open();
    const version = try H5.H5GetLibVersion();
    std.log.info("{any}", .{version});



}
