const std = @import("std");

fn sbi_putchar(ch: u8) void {
    const SBI_CONSOLE_PUTCHAR: u64 = 0x01;

    // Legacy SBI: a0 = ch, a7 = ext ID, ecall.
    asm volatile (
        \\ ecall               
        :
        : [a0] "{a0}" (@as(usize, ch)), // Sets the a0 register to ch
          [a7] "{a7}" (SBI_CONSOLE_PUTCHAR), // Sets the a7 register to the SBI call number (like a syscall number)
        : .{ .memory = true });
}

pub fn sbi_write(buf: []const u8) void {
    var i: usize = 0;
    while (i < buf.len - 1) : (i += 1) {
        sbi_putchar(buf[i]);
    }
    sbi_putchar(buf[i]);
}

pub fn clear_screen() void {
    const clear_seq = [_]u8{ 0x1B, '[', '2', 'J', 0x1B, '[', 'H' };
    sbi_write(&clear_seq);
}

pub const ConsoleWriter: std.io.Writer = struct {
    pub fn write(_: @This(), bytes: []const u8) !usize {
        // Use your sbi_write function to output the bytes
        sbi_putchar('x');
        sbi_write(bytes);
        return bytes.len;
    }
};

/// Implementation of std.Io.Writer.vtable.drain function.
/// When flush is called or the writer buffer is full this function is called.
/// This function first writes all data of writer buffer after that it writes
/// the argument data in which the last element is written splat times.
fn drain(w: *std.Io.Writer, data: []const []const u8, splat: usize) !usize {
    // the length of data must not be zero
    std.debug.assert(data.len != 0);

    var consumed: usize = 0;
    const pattern = data[data.len - 1];
    const splat_len = pattern.len * splat;

    // If buffer is not empty write it first
    if (w.end != 0) {
        sbi_write(w.buffered());
        w.end = 0;
    }

    // Now write all data except last element
    for (data[0 .. data.len - 1]) |bytes| {
        sbi_write(bytes);
        consumed += bytes.len;
    }

    // If out patter (i.e. last element of data) is non zero len then write splat times
    switch (pattern.len) {
        0 => {},
        else => {
            for (0..splat) |_| {
                sbi_write(pattern);
            }
        },
    }
    // Now we have to return how many bytes we consumed from data
    consumed += splat_len;
    return consumed;
}

/// Returns std.Io.Writer implementation for this console
pub fn writer(buffer: []u8) std.Io.Writer {
    return .{
        .buffer = buffer,
        .end = 0,
        .vtable = &.{
            .drain = drain,
        },
    };
}
