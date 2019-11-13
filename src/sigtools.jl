#sigtools.jl - functions that help with working with the sigmoid numbers.

@generated function clz(x::Sigmoid{N, ES, mode}) where {N, ES, mode}
  if (mode == :ubit)
    :(min(leading_zeros(@u(x) & (~@signbit)), N - 1))
  else
    :(min(leading_zeros(@u(x) & (~@signbit)), N))
  end
end

@generated function clo(x::Sigmoid{N, ES, mode}) where {N, ES, mode}
  if (mode == :ubit)
    :(min(leading_ones(@u(x) | (@signbit)), N - 1))
  else
    :(min(leading_ones(@u(x) | (@signbit)), N))
  end
end

@generated function regimebits(x::Sigmoid{N, ES, mode}) where {N, ES, mode}
  if mode == :ubit
    quote
      bitcount = ((@u(x) & (@invertbit) != 0) ? clo(x) : clz(x))
      min(bitcount, N - 2)
    end
  else
    quote
      bitcount = ((@u(x) & (@invertbit) != 0) ? clo(x) : clz(x))
      min(bitcount, N - 1)
    end
  end
end
