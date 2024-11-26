import streamlit as st
import serial
import struct
import time
import numpy as np
import platform

# Detect operating system and set the COM port accordingly
if platform.system() == 'Windows':
    com_port = 'COM8'  # Update COM port to the correct one from Device Manager
else:
    com_port = '/dev/ttyUSB0'  # Update for Linux users if different

# Function to open the COM port
def open_serial_connection():
    return serial.Serial(com_port, baudrate=115200, bytesize=8, parity='N', stopbits=1)

# Initialize session state for matrices if not already initialized
if 'matrix1' not in st.session_state:
    st.session_state.matrix1 = np.zeros((4, 4), dtype=int)
if 'matrix2' not in st.session_state:
    st.session_state.matrix2 = np.zeros((4, 4), dtype=int)

# Streamlit UI setup
st.set_page_config(page_title="Matrix Multiplication", page_icon="🔢", layout="centered")

# Title and description
st.title("🔢 4x4 Matrix Multiplication with FPGA Communication")
st.write("Enter the elements of two 4x4 matrices, and this tool will send them for calculation.")

st.markdown("---")

# Random initialization button
if st.button("Randomize Matrices"):
    st.session_state.matrix1 = np.random.randint(0, 245, size=(4, 4), dtype=np.int32)
    st.session_state.matrix2 = np.random.randint(0, 245, size=(4, 4), dtype=np.int32)
    st.success("Matrices have been randomized!")

# Matrix 1 input
st.subheader("Matrix 1 (A)")
matrix1 = []
for i in range(4):
    row = st.columns(4)
    matrix1_row = []
    for j in range(4):
        matrix1_row.append(row[j].number_input(
            f"A[{i+1}][{j+1}]", 
            key=f"m1_{i}_{j}", 
            min_value=0, 
            max_value=245, 
            value=int(st.session_state.matrix1[i][j]), 
            step=1, 
            format="%d", 
            label_visibility="collapsed"
        ))
    matrix1.append(matrix1_row)

st.markdown("---")  # Separation line between Matrix 1 and Matrix 2

# Matrix 2 input
st.subheader("Matrix 2 (B)")
matrix2 = []
for i in range(4):
    row = st.columns(4)
    matrix2_row = []
    for j in range(4):
        matrix2_row.append(row[j].number_input(
            f"B[{i+1}][{j+1}]", 
            key=f"m2_{i}_{j}", 
            min_value=0, 
            max_value=245, 
            value=int(st.session_state.matrix2[i][j]), 
            step=1, 
            format="%d", 
            label_visibility="collapsed"
        ))
    matrix2.append(matrix2_row)

# Convert lists to numpy arrays for sending to FPGA
matrix1_np = np.array(matrix1)
matrix2_np = np.array(matrix2)

# Button to send matrices to FPGA
if st.button("Calculate and Send to FPGA"):
    try:
        # Open serial connection
        ComPort = open_serial_connection()

        # Function to send matrix data to FPGA
        def send_matrix_to_fpga(matrix, port):
            for i in range(4):
                col = -1 * i
                row = i
                send_array = [0]
                for j in range(9):
                    if 0 <= col + j <= 3 and 0 <= row <= 3:
                        send_array.append(matrix[row][col + j])
                    else:
                        send_array.append(0)

                for item in send_array:
                    port.write(struct.pack('>B', int(item)))  # Send data to FPGA
                    time.sleep(1)  # Adjust as needed

        # Send both matrices to FPGA
        st.info("Sending Matrix 1 to FPGA...")
        send_matrix_to_fpga(matrix1_np, ComPort)

        st.info("Sending Matrix 2 to FPGA...")
        send_matrix_to_fpga(matrix2_np, ComPort)

        st.success("Matrices successfully sent to FPGA!")

        # Close the serial connection
        ComPort.close()
        
    except serial.SerialException as e:
        st.error(f"Failed to connect to COM port: {e}")

# Footer
st.markdown("---")
st.markdown("Developed with ❤️ using Streamlit and Serial Communication", unsafe_allow_html=True)
