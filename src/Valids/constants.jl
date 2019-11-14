
Base.one(T::Type{Valid{N,ES}}) where {N,ES} = Valid(one(Vnum{N,ES}), one(Vnum{N,ES}))
Base.zero(T::Type{Valid{N,ES}}) where {N,ES} = Valid(zero(Vnum{N,ES}), zero(Vnum{N,ES}))

abstract type ∅; end
abstract type ℝ; end
abstract type ℝp; end

convert(T::Type{Valid{N, ES}}, ::Type{∅}) where {N,ES}  = Valid(zero(     Vnum{N,ES}), maxneg( Vnum{N,ES}))
convert(T::Type{Valid{N, ES}}, ::Type{ℝ}) where {N,ES}  = Valid(-maxpos( Vnum{N,ES}), maxpos(      Vnum{N,ES}))
convert(T::Type{Valid{N, ES}}, ::Type{ℝp}) where {N,ES} = Valid(Vnum{N,ES}(Inf),       maxpos(      Vnum{N,ES}))

abstract type __plusstar; end
Base.:+(::typeof(Base.:*)) = __plusstar
abstract type __minusstar; end
Base.:-(::typeof(Base.:*)) = __minusstar
abstract type __positives; end
abstract type __negatives; end

ℝ(::Type{__plusstar}) =      __plusstar
ℝ(::Type{__minusstar}) =     __minusstar
ℝ(::typeof(+)) =             __positives
ℝ(::typeof(-)) =             __negatives

convert(T::Type{Valid{N,ES}}, ::Type{__plusstar}) where {N,ES} =  Valid(minpos(Vnum{N, ES}),  maxpos(Vnum{N, ES}))
convert(T::Type{Valid{N,ES}}, ::Type{__minusstar}) where {N,ES} = Valid(-maxpos(Vnum{N, ES}), maxneg(Vnum{N, ES}))
convert(T::Type{Valid{N,ES}}, ::Type{__positives}) where {N,ES} = Valid(zero(Vnum{N, ES}),          maxpos(Vnum{N, ES}))
convert(T::Type{Valid{N,ES}}, ::Type{__negatives}) where {N,ES} = Valid(-maxpos(Vnum{N, ES}),         zero(Vnum{N, ES}))

export ∅, ℝ, ℝp
