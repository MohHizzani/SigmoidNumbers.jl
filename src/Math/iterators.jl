#iterators.jl - creating iterator convenience types for SigmoidNumbers.

import Base: size, nextfloat, prevfloat, sizeof

increment(::Type{Sigmoid{N, ES, mode}}) where {N, ES, mode} = (@signbit) >> (N - 1)

@generated function next(x::Sigmoid{N, ES, mode}) where {N, ES, mode}
  inc = increment(Sigmoid{N, ES, mode})
  :(reinterpret(Sigmoid{N, ES, mode}, @u(x) + $inc))
end

@generated function prev(x::Sigmoid{N, ES, mode}) where {N, ES, mode}
  inc = increment(Sigmoid{N, ES, mode})
  :(reinterpret(Sigmoid{N, ES, mode}, @u(x) - $inc))
end

start(T::Type{Sigmoid{N, ES, mode}})  where {N, ES, mode} = T(Inf)
next(T::Type{Sigmoid{N, ES, mode}}, state) where {N, ES, mode} = (state, next(state))

@generated function done(T::Type{Sigmoid{N, ES, mode}}, state) where {N, ES, mode}
  last_element = reinterpret(Sigmoid{N, ES, mode}, (@signbit) - increment(Sigmoid{N, ES, mode}))
  :(state == $last_element)
end

size(T::Type{Sigmoid{N, ES, mode}}) where {N, ES, mode} = 1 << N
sizeof(T::Type{Sigmoid{N, ES, mode}}) where {N, ES, mode} = __BITS ÷ 8

nextfloat(x::Sigmoid{N, ES, mode}) where {N, ES, mode} = next(x)
prevfloat(x::Sigmoid{N, ES, mode}) where {N, ES, mode} = prev(x)


export prev, next, start, done, increment, size
