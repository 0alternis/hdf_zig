const std = @import("std");

const current_version: std.SemanticVersion = .{.major = 1, .minor = 14, .patch = 4};

const HDF = @This();

const c = @cImport({
    @cInclude("hdf5.h");
});

pub const H5Limits = struct { regular_limit_global: i32, regular_limit_list: i32, arr_limit_global: i32, arr_limit_list: i32, block_limit_global: i32, block_limit_list: i32 };

pub const H5Error = error{
    InitializationError,
    DestructionError,
    GrabageCollectionError,
    GenericError,
};

pub fn open() !void {
    const herr = c.H5open();

    if (herr < 0) {
        return H5Error.InitializationError;
    }
}

pub fn close() !void {
    const herr = c.H5close();

    if (herr < 0) {
        return H5Error.DestructionError;
    }
}

pub fn garbageCollect() !void {
    const herr = c.H5garbage_collect();

    if (herr < 0) {
        return H5Error.GarbageCollectionError;
    }
}

pub fn getLibVersion() !std.SemanticVersion {
    var major: c_uint = undefined;
    var minor: c_uint = undefined;
    var patch: c_uint = undefined;
    const herr = c.H5get_libversion(&major, &minor, &patch);

    if (herr < 0) {
        return H5Error.GenericError;
    }

    const lib_version: std.SemanticVersion = std.SemanticVersion{ .major = major, .minor = minor, .patch = patch };

    return lib_version;
}

pub fn freeMemory(buf: *anyopaque) !void {
    const herr = c.H5free_memory(buf);

    if (herr < 0) {
        return H5Error.GenericError;
    }
}

pub fn isLibraryThreadSafe() !bool {
    var is_safe: bool = undefined;
    const herr = c.H5is_library_threadsafe(&is_safe);

    if (herr < 0) {
        return H5Error.GenericError;
    }

    return is_safe;
}

pub fn setFreeLimits(lims: H5Limits) !void {
    const herr = c.H5set_free_list_limits(lims.regular_limit_global, lims.regular_limit_list, lims.arr_limit_global, lims.arr_limit_list, lims.block_limit_global, lims.block_limit_list);

    if (herr < 0) {
        return H5Error.GenericError;
    }
}

test "getLibVersion" {
    try open();
    const version = try getLibVersion();
    try std.testing.expect(current_version.major == version.major);
    try std.testing.expect(current_version.minor == version.minor);
    try std.testing.expect(current_version.patch == version.patch);
    try close();
}

