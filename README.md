This is an updated version of [SigmoidNumbers](https://github.com/interplanetary-robot/SigmoidNumbers.git) for Posits, Valids and Unum II Numbers for Julia by Mohammad Hizzani

Based on the Sigmoid Numbers Invented by John Gustafson

ML Applications & Implementation by Isaac Yonemoto


Two types of Sigmoid Numbers

1.  Universal Sigmoid Numbers

2.  Estimated Sigmoid Numbers (Posits)


## Add

In order to add SigmoidNumbers simply from a Julia REPL

```julia
julia> ] add SigmoidNumbers
```

To use it

```julia
julia> using SigmoidNumbers

julia> P1 = Posit{16,0}; #16 is number of bits, 0 is ES

julia> a = P1(0)
Posit{16,0}(0x0000)
```
