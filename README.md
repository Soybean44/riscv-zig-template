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
