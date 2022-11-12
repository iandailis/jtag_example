import jtag_uart

def write(ju, writearray):
    writedata = bytes()
    index = 0
    while (index < len(writearray)):
        writedata = bytes()
        for i in range(0, 16 * 2**10):
            writedata += bytes([writearray[index]])
            index += 1
            if (index == len(writearray)):
                break
        ju.write(writedata)

def main():
    ju = jtag_uart.intel_jtag_uart()
    while True:
        a = [ord(c) for c in input("> ")]
        write(ju, a)
        for i in a:
            print(f"{i:02x} ", end="")
        print("")

if (__name__ == "__main__"):
    main()
