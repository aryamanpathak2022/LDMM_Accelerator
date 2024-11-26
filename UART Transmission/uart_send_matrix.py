import serial           # import the module
import struct
import time
import platform

# Detect operating system and set the COM port accordingly
if platform.system() == 'Windows':
    ComPort = serial.Serial('COM8')  # Update COM port to the correct one from Device Manager
else:
    ComPort = serial.Serial('/dev/COM8')  # For Linux users

ComPort.baudrate = 115200  # Set Baud rate to 115200
ComPort.bytesize = 8       # Number of data bits = 8
ComPort.parity = 'N'       # No parity
ComPort.stopbits = 1       # Number of Stop bits = 1

# Matrix input
mat = [[1,2,3,4], [5,6,7,8], [9,10,11,12], [13,14,15,16]]
print(mat)

def isValid(x, y):
    return 0 <= x <= 3 and 0 <= y <= 3

# Transferring matrix into BRAM
for i in range(4):
    col = -1 * i
    row = i
    send_array = [0]
    for j in range(9):
        if isValid(col + j, row):
            send_array.append(mat[row][col + j])
        else:
            send_array.append(0)

    for item in send_array:
        ComPort.write(struct.pack('>B', int(item)))  # Send data to FPGA
        print(f"{item}", end=" ")
        time.sleep(1)
    
    print(f"Data in the BRAM {i + 1}")

# Close the COM port
ComPort.close()
