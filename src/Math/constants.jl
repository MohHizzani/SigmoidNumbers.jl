import Base: one, zero, eps, issubnormal, isnan, isfinite
import Base.convert

one(T::Type{Sigmoid{N, ES, mode}}) where {N, ES, mode} = reinterpret(T, @invertbit)
zero(T::Type{Sigmoid{N, ES, mode}}) where {N, ES, mode} = reinterpret(T, zero(@UInt))

@generated function maxpos(T::Type{Sigmoid{N, ES, mode}}) where {N, ES, mode}
  v = (@signbit) - increment(Sigmoid{N, ES, mode})
  :(reinterpret(T, $v))
end
realmax(T::Type{Sigmoid{N, ES, mode}}) where {N, ES, mode} = maxpos(T)

@generated function minpos(T::Type{Sigmoid{N, ES, mode}}) where {N, ES, mode}
  v = zero(@UInt) + increment(Sigmoid{N, ES, mode})
  :(reinterpret(T, $v))
end
realmin(T::Type{Sigmoid{N, ES, mode}}) where {N, ES, mode} = minpos(T)

@generated function maxneg(T::Type{Sigmoid{N, ES, mode}}) where {N, ES, mode}
  v = zero(@UInt) - increment(Sigmoid{N, ES, mode})
  :(reinterpret(T, $v))
end

@generated function minneg(T::Type{Sigmoid{N, ES, mode}}) where {N, ES, mode}
  v = (@signbit) + increment(Sigmoid{N, ES, mode})
  :(reinterpret(T, $v))
end

@generated function eps(T::Type{Sigmoid{N, ES, mode}}) where {N, ES, mode}
  if mode == :ubit
  else
  end
end

#no subnormals, no NaNs
issubnormal(x::Sigmoid{N, ES, mode}) where {N, ES, mode} = false
isnan(x::Sigmoid{N, ES, mode}) where {N, ES, mode} = false
isfinite(x::Sigmoid{N, ES, mode}) where {N, ES, mode} = (@u(x) != @signbit)
#isfinite{N,ES}(x::Sigmoid{N, ES, :upper}) = false
#isfinite{N,ES}(x::Sigmoid{N, ES, :lower}) = false
#isfinite{N,ES}(x::Sigmoid{N, ES, :cross}) = false

#iszeroinf
iszeroinf(x::Sigmoid) = reinterpret(@UInt, x) & (~@signbit) == 0

#special constant type symbols
struct ∞; end
struct ∞n; end

Base.:-(::Type{∞}) = ∞n
convert(T::Type{Sigmoid{N, ES, mode}}, ::Type{∞}) where {N, ES, mode} = T(Inf)
convert(T::Type{Sigmoid{N, ES, mode}}, ::Type{∞n}) where {N, ES, mode} = T(Inf)

export ∞


Base.typemin(p::Type{S}) where {S <: Sigmoid} = minneg(p)

Base.typemax(p::Type{S}) where {S <: Sigmoid} = maxpos(p)
