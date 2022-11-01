![UDELAR Logo](./readme/Logo_Fing%2BUdelar_horizontal_RGB.png)

# Computer Architecture Project - Assembly 8086

Assembly 8086 RPN Calculator, RPN stands for Reverse Polish Notation. Learn more about this notation visiting this [link](https://en.wikipedia.org/wiki/Reverse_Polish_notation).

To carry out this task, the problem was modeled in a high-level programming language C, this "pseudocode" serve as a guide. Finally, the program was implemented in Assembler 8086 "manually compiled" from the C model.

See the official documentation [here](https://drive.google.com/file/d/1ylendosX9Bx8Kyw6MezueZzrbqj37PNQ/view).

## Features

- Receive the `input stream` according to the format specified below in the Input Format subsection
- Handle a work `stack of up to 31 16-bit integer operands` represented in 2's complement
- Evaluate the following binary arithmetic operations: `+, -, *, /, %`
- Evaluate the following binary Boolean operations: `&, |, <<, >>`
- Evaluate the following unary arithmetic operations: `NEG, FACT`
- Expose the top of the stack on a selected port: `Top`
- Perform a stack dump on a selected port: `Dump`
- Duplicate top of stack: `DUP`
- Swap the top of the stack with the element below it: `SWAP`
- Sum all the elements of the stack: `SUM`

## Execution Log

The calculator must keep an execution log as it processes each command. The user-definable output port will be used for such purposes, which should work as follows:

Before processing a command, code 0 must be sent followed by the command to be processed (including the parameters, one word for each data).

After processing the command, you must send:

- `Code 16` if the operation was successful
- `Code 8` if the operation failed due to missing operands on the stack
- `Code 4` if the operation failed due to stack overflow (there are already 31 operands)
- `Code 2` if the command is not recognized (invalid command)

## Input Format

| Command | Parameter | Code | Description |
| ------- | --------- | :--: | ----------- |
| Num     | Number    | 1    | Add a number into the stack |
| Port    | Port      | 2    | Set the output port |
| Log     | Port      | 3    | Set the log port |
| Top     |           | 4    | Show the top of the stack in the output port |
| Dump    |           | 5    | Dump the stack in the output port |
| DUP     |           | 6    | Duplicate the top of the stack |
| SWAP    |           | 7    | Swap the top of the stack with the number below |
| Neg     |           | 8    | Calculates the opposite |
| Fact    |           | 9    | Calculates the factorial |
| Sum     |           | 10   | Sum all elements in the stack leaving the result as the only element |
| +,-,*,/,%,&,\|,<<,>> | | 11-19 | Binary operations |
| Clear   |           | 254  | Empty the stack |
| Halt    |           | 255  | Halt the program |

## General Information

`Project of the Computer Architecture Course - University of the Republic UDELAR`

- Developed by **Mathias Ramilo**.

### **Personal Data**

- Visit my [**GitHub**](https://github.com/mathiramilo) profile to see more amazing projects.
- If you are interested, contact me on [**Linkedin**](https://www.linkedin.com/in/mathias-ramilo/).
