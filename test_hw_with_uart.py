import os
import sys

this_file_path = os.path.dirname(os.path.realpath(__file__))
sys.path.append(this_file_path + '/source/fpga_communication/fpga_uart_pc_software/')
comport = sys.argv[1]

from uart_communication_functions import *

uart = uart_link(comport, 128e6/24)
print("test data is : ", uart.request_data_from_address(100))
