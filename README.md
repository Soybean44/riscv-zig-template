# RISC-V Zig Template
This template provides a basic setup for developing RISC-V applications using the Zig programming language. It includes a simple "Hello, World!" program and console.zig file for OpenSBI console support. It is fairly minimal and a good starting point for a RISC-V Zig Kernel.

## Building/Running the Project
To build the project, ensure you have Zig installed on your system. Then, run the following command in the project directory:

```bash
zig build
```

This will compile the source code and generate the output binary `kernel`. 

If you want to run the project using QEMU, you can use the following script:

```bash
./run_qemu.sh
```

Or you can run it directly with Zig using:

```bash
zig build run
```

## Editing the Run Script
The `run_qemu.sh` script is set up to run the compiled kernel in QEMU with RISC-V architecture. You can modify the script to change QEMU options, such as memory size, CPU type, or additional devices. This script is run when you execute `zig build run`, so it makes it easy to test your kernel in a custom environment.
