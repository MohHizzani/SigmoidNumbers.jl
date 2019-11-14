#Posit have a special conversion mode where you can convert a value to [0,1]

import Base.convert

Base.convert(::Type{Posit{N,0}}, bval::Bool) where {N} = reinterpret(Posit{N,0}, bval * (@invertbit))
function Base.convert(::Type{Bool}, pval::Posit{N,0}) where {N}
  (@s(pval) < 0) && throw(InexactError())
  (@u(pval) > 0x4000_0000_0000_0000) && throw(InexactError())
  return @u(pval) > 0x2000_0000_0000_0000
end
