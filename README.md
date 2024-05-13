# UART transceiver
## Description
- UART stands for Universal Asynchronous Receiver Transmitter.
- Baud: controller and target should have same Baud to correctly communicate. This design implement in 9600bps
- Idle: UART Idle state, stay high after stop bit done
- Start: Start bit indicate start of transmission, pull low from idle
- D0~D7: Data byte follow Start bit, LSB first
- Parity: Optional Parity bit is used for data correction check
- Stop: Stop bit indicate End of transmission, could be optionally set to 2 bit length
![image](https://github.com/Sbing-yuan/uart_trx/blob/main/image1.png)
---
## Design Hierachy
![image](https://github.com/Sbing-yuan/uart_trx/blob/main/image2.png)
- speed_select : module that generate pulse signal according to Baud, triggered after start condition
- uart_rx : UART receiver
- uart_tx : UART transmitter
- regbank_ctrl : controller for uart_trx, transceiver system should respond according to received byte
- Uregbank : register array, can be writed to, read from using designated address
---
## State machine
![image](https://github.com/Sbing-yuan/uart_trx/blob/main/image3.png)
- write flow: target received 2 bytes. First byte is 7bit address + MSB:1. Second byte is data byte, data of this address will change according to these bytes.
- read flow: target received 1 byte containing 7bit address + MSB:0. Transmitter will be triggered to output data byte of according address.
