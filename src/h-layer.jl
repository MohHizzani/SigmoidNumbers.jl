
import Base: show, bitstring, hex
import Base.hex
# import Base.bitstring

bitstring(x::Sigmoid{N, ES, mode}) where {N, ES, mode} =  bitstring(reinterpret(@UInt, x))[1:N]

function bitstring(x::Sigmoid{N, ES, mode}, separator::AbstractString) where {N, ES, mode}
  #we're going to create this as a string array, then join() it at the end.
  stringarray = Vector{String}()

  bits =  bitstring(x)

  push!(stringarray, bits[1:1])
  seek_idx = 2
  term_idx = N - (mode == :ubit) #store the index of termination.

  #calculate how many regime bits there are
  r_length = regimebits(x)

  push!(stringarray, bits[seek_idx:(seek_idx + r_length - 1)])
  seek_idx += r_length

  (seek_idx > term_idx) && @goto finish

  if (ES > 0)
    if ((seek_idx + ES) < term_idx)
      push!(stringarray, bits[seek_idx:seek_idx + ES - 1])
      seek_idx += ES
    else
      push!(stringarray, bits[seek_idx:term_idx])
      @goto finish
    end
  end

  push!(stringarray, bits[seek_idx:term_idx])

  @label finish

  if mode == :ubit
    push!(stringarray, bits[end:end])
  end

  return join(stringarray, separator)
end

function Base.show(io::IO, x::Sigmoid{N, ES, mode}) where {N, ES, mode}

  if mode == :ubit
    #cast to Exact or ULP, depending on what the number looks like.
    if (reinterpret((@UInt), x) & increment(Sigmoid{N, ES, mode})) != 0
      print(io, "ULP{$N,$ES}")
    else
      print(io, "Exact{$N,$ES}")
    end
  else
    show(io, typeof(x))
  end

  innerval = reinterpret((@UInt), x)

  if N == 16
    print(io, "(0x", Base.hex(innerval,16, false)[1:4], ")")
  elseif N == 32
    print(io, "(0x", Base.hex(innerval,16, false)[1:8], ")")
  elseif N == 64
    print(io, "(0x", Base.hex(innerval,16, false)[1:16], ")")
  else
    print(io, "(0b",  bitstring(innerval)[1:N], ")")
  end
end

@generated function Base.show(io::IO, ::Type{Sigmoid{N, ES, mode}}) where {N, ES, mode}
  if (mode == :guess)
    sig = "{$N,$ES}"
    :(print(io, "Posit", $sig))
  else
    sig = "{$N,$ES,$mode}"
    :(print(io, "Sigmoid", $sig))
  end
end
