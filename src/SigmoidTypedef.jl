#sigmoid typedef - type definition for sigmoid-valued numbers.
#environment bits parameter.

#for now, put this here
__sigmoid_settings = Dict{Symbol, Any}()
getsetting(k) = haskey(__sigmoid_settings, k) ? __sigmoid_settings[k] : nothing

if (Int == Int32) || getsetting(:basebits) == 32
  const __BITS = 32
elseif getsetting(:basebits) == 16
  const __BITS = 16
elseif getsetting(:basebits) == 8
  const __BITS = 8
else #default to a 64-bit environment.
  const __BITS = 64
end

bitstype __BITS Sigmoid{N, mode} <: AbstractFloat

#these are deliberately made incompatible with the standard rounding modes types
#found in the julia std library.

const roundingmodes = [:guess,
  :ubit,
  :roundup,
  :rounddn,
  :roundin,
  :roundout]

#uses the rounding mode types:
typealias Posit{N} Sigmoid{N, :guess}
typealias Valid{N} Sigmoid{N, :ubit}

type VBound{N} <: AbstractFloat
  lower::Valid{N}
  upper::Valid{N}
end

export Posit
export Valid
export VBound