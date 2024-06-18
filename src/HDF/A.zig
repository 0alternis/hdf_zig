const std = @import("std");
const c = @import("../HDF.zig").c;
const H5Error = @import("../HDF.zig").H5Error;

pub export fn open(obj_id: i64, attr_name: *const u8, aapl_id: i64) !i64 {
    const attr_id = c.H5Aopen(obj_id, attr_name, aapl_id);

    if (attr_id < 0) {
        return H5Error.GenericError;
    }

    return attr_id;
}

pub export fn close(attr_id: i64) !void {
    const herr = c.H5Aclose(attr_id);

    if (herr < 0) {
        return H5Error.GenericError;
    }
}

pub export fn create(loc_id: i64, attr_name: *const u8, type_id: i64, space_id: i64, acpl_id: i64, aapl_id: i64) !i64 {
    const hid = c.H5Acreate2(loc_id, attr_name, type_id, space_id, acpl_id, aapl_id);

    if (hid < 0) {
        return H5Error.GenericError;
    }

    return hid;
}

pub export fn createByName(loc_id: i64, obj_name: *const u8, attr_name: *const u8, type_id: i64, space_id: i64, acpl_id: i64, aapl_id: i64, lapl_id: i64) !i64 {
    const hid = c.H5Acreate_by_name(loc_id, obj_name, attr_name, type_id, space_id, acpl_id, aapl_id, lapl_id);

    if (hid < 0) {
        return H5Error.GenericError;
    }

    return hid;
}

pub export fn delete() !void {}
