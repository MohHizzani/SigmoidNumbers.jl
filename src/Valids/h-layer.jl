import Base.bitstring


function describe(x::Valid{N, ES}, f = println) where {N,ES}
  isempty(x)    && return string("Valid{$N,$ES}(∅)")                               |> f
  isallreals(x) && return string("Valid{$N,$ES}(ℝp)")                              |> f

  #handle special characters.
  if (x.upper == maxpos(Vnum{N,ES}))
    (x.lower == zero(Vnum{N,ES})) && return string("Valid{$N,$ES}(ℝ(+))")          |> f
    (x.lower == minpos(Vnum{N,ES})) && return string("Valid{$N,$ES}(ℝ(+*))") |> f
    (x.lower == -maxpos(Vnum{N,ES})) && return string("Valid{$N,$ES}(ℝ)")         |> f
  end

  if (x.lower == -maxpos(Vnum{N,ES}))
    (x.upper == zero(Vnum{N,ES})) && return string("Valid{$N,$ES}(ℝ(-))")          |> f
    (x.upper == maxneg(Vnum{N,ES})) && return string("Valid{$N,$ES}(ℝ(-*))") |> f
  end

  if N <= 32
    lower_u = isulp(x.lower)
    upper_u = isulp(x.upper)

    lvalue = Float64(glb(x.lower))
    rvalue = Float64(lub(x.upper))

    if (lvalue == rvalue)
      string("Valid{$N,$ES}(", lvalue, " ex)") |> f
    else
      string("Valid{$N,$ES}(", lvalue, lower_u ? " op" : " ex", " → ", rvalue, upper_u ? " op)" : " ex)") |> f
    end
  else
  end
end

function describe(x::Vnum{N,ES}, f = println) where {N,ES}
  lvalue = Float64(glb(x))
  rvalue = Float64(lub(x))

  if (lvalue == rvalue)
    string("Vnum{$N,$ES}(", lvalue, " ex)") |> f
  else
    string("Vnum{$N,$ES}(", lvalue, " op", " → ", rvalue, " op)") |> f
  end
end

function  bitstring(x::Valid{N,ES}) where {N,ES}
  string( bitstring(x.lower), bitstring(x.upper))
end

function  bitstring(x::Valid{N,ES}, separator::AbstractString) where {N,ES}
  string( bitstring(x.lower, separator),"|", bitstring(x.upper, separator))
end

function show(io::IO, x::Valid{N,ES}) where {N,ES}
  print(io, x.lower, " → " , x.upper)
end

export describe
