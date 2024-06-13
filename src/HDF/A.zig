const std = @import("std");
const c = @import("../HDF.zig").c;
const H5Error = @import("../HDF.zig").H5Error;

pub fn open(obj_id: i64, attr_name: *const u8, aapl_id: i64 ) !i64 {

    const attr_id = c.H5Aopen(obj_id, attr_name, aapl_id);

    if (attr_id < 0) {
        return H5Error.GenericError;
    }

    return attr_id;
}


