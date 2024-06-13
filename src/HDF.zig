const std = @import("std");

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

pub fn H5Open() !void {
    const herr = c.H5open();

    if (herr < 0) {
        return H5Error.InitializationError;
    }

}

pub fn H5Close() !void {
    const herr = c.H5close();

    if (herr < 0) {
        return H5Error.DestructionError;
    }

}

pub fn H5GarbageCollect() !void {
    const herr = c.H5garbage_collect();

    if (herr < 0) {
        return H5Error.GarbageCollectionError;
    }

}

pub fn H5GetLibVersion() !std.SemanticVersion {
    var majnum: c_uint = undefined;
    var minornum: c_uint = undefined;
    var patchnum:c_uint = undefined;
    const herr = c.H5get_libversion(&majnum, &minornum, &patchnum);

    if (herr < 0) {
        return H5Error.GenericError;
    }


    const lib_version: std.SemanticVersion = std.SemanticVersion{.major = majnum, .minor = minornum, .patch = patchnum};

    return lib_version;
}

pub fn H5FreeMemory(buf: *anyopaque) !void {
    const herr = c.H5free_memory(buf);

    if (herr < 0) {
        return H5Error.GenericError;
    }
}

pub fn H5IsLibraryThreadSafe() !bool {
    var is_safe: bool = undefined;
    const herr = c.H5is_library_threadsafe(&is_safe);

    if (herr < 0) {
        return H5Error.GenericError;
    }

    return is_safe;
}

pub fn H5SetFreeListLimits(lims: H5Limits) !void {
    const herr = c.H5set_free_list_limits(lims.regular_limit_global, lims.regular_limit_list, lims.arr_limit_global, lims.arr_limit_list, lims.block_limit_global, lims.block_limit_list);

    if (herr < 0) {
        return H5Error.GenericError;
    }
}
