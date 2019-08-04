# Basys-3 Peripheral Development
### What are we talking about here
This is simply an open ended repository as I develop and test different interfaces for peripherals compatible with the Basys-3 FPGA development board. Should be some interesting stuff hopefully, but mostly used as refereces for myself and others trying to use different peripherals integrated into a larger project.

## Peripherals of Interest
I have some peripherals in mind, with some that I already have bought connectors for that can be immediately integrated into the Bsays-3 board via PMOD connectors. The current list of peripherals and/or respective components of interest are listed below:

* VGA In/Out/Signal Generation
* Serial NOR Flash
* ESP32 Dual-Mode Bluetooth/WiFi Controller
* USB Hub for Keyboard, Mouse, Etc.
* Mini-USB Hub for Data Transfer between other devices


## Projects in Mind
* VGA signal generation, purpose of which is "top secret" :)
* VGA signal pass-through and modification. Can be used for a real-time image processing unit, video filter, video overlay,  and more
* Interfacing with quick memory for a number of potential and existing projects
* Interfacing flash acting as "main memory" for a MIPS CPU; Block RAM can be used for caching if implemented.
* Network connection with ESP32; Attempt to fetch information from a web-page, text based information at first
* With a robust operating system an attempt to interface VGA out and a graphics-based web-page in harmony can be attempted


## Language of Interest
For the time being I will be doing HDL development in VHDL. It is the language I am most confortable in, although Verilog may eventually make its way into this repository.
