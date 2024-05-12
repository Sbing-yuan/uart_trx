# UART transceiver
## Description
- UART stands for Universal Asynchronous Receiver Transmitter.
- Baud: controller and target should have same Baud to correctly communicate. This design implement in 9600bps
- Idle: UART Idle state, stay high after stop bit done
- Start: Start bit indicate start of transmission, pull low from idle
- D0~D7: Data byte follow Start bit, LSB first
- Parity: Optional Parity bit is used for data correction check
- Stop: Stop bit indicate End of transmission, could be optionally set to 2 bit length
![image](https://github.com/Sbing-yuan/uart_trx/blob/main/image.png)
---
## Design Hierachy

## State machine
