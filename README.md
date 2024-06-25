# Vector Processor
This is an implementation of a vector processor in Verilog.

## How to run
To run the testbench, you'll need to have either ModelSim or `iverilog` installed on your computer. You can run the testbench with `iverilog` on macOS using the following command:

```sh
cd code
iverilog TB.v CPU.v ALU.v Dmem.v Imem.v RF.v && ./a.out
```

## Technical details
More details on the specification of this system and how it works are available in the `docs` folder.

## Related links
- [Vector processor](https://en.wikipedia.org/wiki/Vector_processor)
- [iverilog](https://www.google.com/url?sa=t&source=web&rct=j&opi=89978449&url=https://github.com/steveicarus/iverilog&ved=2ahUKEwjd2JT9xPeGAxXc_AIHHaZ7IxkQFnoECAYQAQ&usg=AOvVaw116L78gjNPqKDYJEAkm0HM)

## Author
- [Hosein Khansari](https://github.com/heokhe)
