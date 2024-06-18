const std = @import("std");
const HDF = @import("../HDF.zig");
const c = HDF.c;
const H5Error = HDF.H5Error;

const call_lock = HDF.call_lock;

pub const H5Index = enum(u8) {
    IndexUnknown = c.H5_INDEX_UNKNOWN,
    IndexName = c.H5_INDEX_NAME,
    CreationOrder = c.H5_INDEX_CRT_ORDER,
    Indexes = c.H5_INDEX_N,
};

pub const H5IterOrder = enum(u8) {
    IterUnknown = c.H5_ITER_UNKNOWN,
    Increasing = c.H5_ITER_INC,
    Decreasing = c.H5_ITER_DEC,
    Native = c.H5_ITER_NATIVE,
    IterN = c.H5_ITER_N,
};

pub export fn open(obj_id: i64, attr_name: *const u8, aapl_id: i64) !i64 {
    call_lock.lock();
    const attr_id = c.H5Aopen(obj_id, attr_name, aapl_id);
    call_lock.unlock();
    if (attr_id < 0) {
        return H5Error.GenericError;
    }

    return attr_id;
}

pub export fn close(attr_id: i64) !void {

    call_lock.lock();
    const herr = c.H5Aclose(attr_id);
    call_lock.unlock();

    if (herr < 0) {
        return H5Error.GenericError;
    }
}

pub export fn create(loc_id: i64, attr_name: *const u8, type_id: i64, space_id: i64, acpl_id: i64, aapl_id: i64) !i64 {
    call_lock.lock();
    const hid = c.H5Acreate2(loc_id, attr_name, type_id, space_id, acpl_id, aapl_id);
    call_lock.unlock();
    if (hid < 0) {
        return H5Error.GenericError;
    }

    return hid;
}

pub export fn createByName(loc_id: i64, obj_name: *const u8, attr_name: *const u8, type_id: i64, space_id: i64, acpl_id: i64, aapl_id: i64, lapl_id: i64) !i64 {
    call_lock.lock();
    const hid = c.H5Acreate_by_name(loc_id, obj_name, attr_name, type_id, space_id, acpl_id, aapl_id, lapl_id);
    call_lock.unlock();
    if (hid < 0) {
        return H5Error.GenericError;
    }

    return hid;
}

pub export fn delete(loc_id: i64, attr_name: *const u8) !void {
    call_lock.lock();
    const herr = c.H5Adelete(loc_id, attr_name);
    call_lock.unlock();

    if (herr < 0) {
        return H5Error.GenericError;
    }
}

pub export fn deleteByIdx(loc_id: i64, obj_name: *const u8, index_type: H5Index, order: H5IterOrder, iterations: u64, lapl_id: i64) !void {
    const herr = c.H5Adelete_by_idx(loc_id, obj_name, index_type, order, iterations, lapl_id);

    if (herr < 0) {
        return H5Error.GenericError;
    }
}

pub export fn deleteByName(loc_id: i64, obj_name: *const u8, attr_name: *const u8, lapl_id: i64) !void {
    const herr = c.H5Adelete_by_name(loc_id, obj_name, attr_name, lapl_id);

    if (herr < 0) {
        return H5Error.GenericError;
    }

}
