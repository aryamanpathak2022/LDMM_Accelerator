import serial           # import the module
import struct
import time

# For linux users
# dmesg | grep tty
# ComPort = serial.Serial('/dev/ttyUSB1') # for linux users
# sudo chmod a+rw /dev/ttyUSB1
ComPort = serial.Serial('COM8')  # for windows users - check from device manager

ComPort.baudrate = 115200  # set Baud rate to 115200
ComPort.bytesize = 8       # Number of data bits = 8
ComPort.parity   = 'N'     # No parity
ComPort.stopbits = 1       # Number of Stop bits = 1

def send_256bit_number(numbers):
    # Create a single byte array to hold all 32 bits for the 8 numbers
    byte_array = bytearray()

    # Convert each number into 32-bit and pack into the byte array
    for number in numbers:
        for i in range(4):  # 4 bytes for 32 bits
            byte = (number >> (8 * (3 - i))) & 0xFF  # Get the i-th byte
            byte_array.append(byte)  # Add byte to the array

    # Now send each byte in the byte array as 8 bits
    for index, byte in enumerate(byte_array):
        # Format the byte as an 8-bit binary string
        bit_representation = format(byte, '08b')  # Full 8-bit representation
        print(f"Sending byte {index + 1}/{len(byte_array)}: {bit_representation}")  # Print as 8-bit binary
        ComPort.write(struct.pack('>B', byte))  # Send each 8-bit value
        time.sleep(0.1)  # Small delay to ensure proper timing

print("Enter 8 numbers (0-255) as a comma-separated string. Type 'q' to exit.")

while True:
    input_string = input("Enter the numbers: ")
    if input_string.lower() == 'q':
        break
    else:
        # Split the string by commas and strip any whitespace
        try:
            numbers = [int(num.strip()) for num in input_string.split(',')]
            if len(numbers) != 8 or any(num < 0 or num > 255 for num in numbers):
                print("Please enter exactly 8 numbers, each between 0 and 255.")
                continue

            # Send the numbers as 256 bits (32 bits for each of the 8 numbers)
            print("Sending the following 32-bit numbers (as 8 bits one by one):")
            for num in numbers:
                print(f"32-bit representation of {num}: {num:#010x}")  # Print in hex format for reference

            send_256bit_number(numbers)  # Send the complete byte array

        except ValueError:
            print("Invalid input. Please enter numbers only.")

ComPort.close()  # Close the Com port
