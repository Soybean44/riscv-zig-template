const std = @import("std");
const Feature = @import("std").Target.Cpu.Feature;
const Target = @import("std").Target;

pub fn build(b: *std.Build) void {

    const features = Target.riscv.Feature;
    var disabled_features = Feature.Set.empty;
    var enabled_features = Feature.Set.empty;

    // disable all CPU extensions
    disabled_features.addFeature(@intFromEnum(features.a));
    disabled_features.addFeature(@intFromEnum(features.c));
    disabled_features.addFeature(@intFromEnum(features.d));
    disabled_features.addFeature(@intFromEnum(features.e));
    disabled_features.addFeature(@intFromEnum(features.f));
    // except multiply
    enabled_features.addFeature(@intFromEnum(features.m));

    const target = b.resolveTargetQuery(.{
        .cpu_arch = .riscv64,
        .cpu_model = .baseline,
        .os_tag = .freestanding,
        .abi = .none,
        .cpu_features_add = enabled_features,
        .cpu_features_sub = disabled_features,
    });

    const optimize = b.standardOptimizeOption(.{ .preferred_optimize_mode = .ReleaseSmall });

    const exe = b.addExecutable(.{
        .name = "kernel",
        .root_module = b.createModule(.{
            // For a bare-metal kernel we usually don't want position-independent code.
            .pic = false,
            .link_libc = false,
            .root_source_file = b.path("src/kmain.zig"),
            .target = target,
            .optimize = optimize,
            .strip = false,
            .code_model = .medium,
        }),
    });

    const install_step = b.addInstallArtifact(exe, .{});

    exe.entry = .{ .symbol_name = "_start" };
    exe.setLinkerScript(b.path("src/link.ld"));

    const bin_path = exe.installed_path orelse "zig-out/bin/kernel";

    const run_cmd = b.addSystemCommand(&.{
        "sh", 
        "run-qemu.sh",
        bin_path,
    });

    run_cmd.step.dependOn(&install_step.step);

    const run_step = b.step("run", "Run the kernel in QEMU");
    run_step.dependOn(&run_cmd.step);
}

