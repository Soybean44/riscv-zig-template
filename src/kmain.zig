const std = @import("std");
const console = @import("console.zig");

pub export fn _start() linksection(".text.start") noreturn {
    // Initialize stack pointer
    asm volatile (
        \\ la sp, __stack_top
    );
    kmain() catch {};
    while (true) {}
}

fn kmain() !void {
    var w = console.writer(&.{});
    console.clear_screen();
    try w.print("Hello, {s}!\n", .{"RISC-V Kernel"});
}
