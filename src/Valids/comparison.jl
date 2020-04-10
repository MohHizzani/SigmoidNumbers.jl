#comparison.jl -- comparison operators for valids.

function Base.:(==)(x::Valid{N,ES}, y::Valid{N,ES}) where {N,ES}
    if (next(x.upper) == x.lower) & (next(y.upper) == y.lower)

        x_null = (x.upper == zero(Vnum{N,ES})) | (x.lower == zero(Vnum{N,ES}))
        y_null = (y.upper == zero(Vnum{N,ES})) | (y.lower == zero(Vnum{N,ES}))

        return x_null == y_null
    end
    return (x.upper == y.upper) && (x.lower == y.lower)
end

function Base.max(x::Sigmoid{N,ES,:exact}, y::Sigmoid{N,ES,:lower}) where {N,ES}
    x == Sigmoid{N,ES,:exact}(Inf) && return x
    (@s x) <= (@s y) ?  y : x
end
function Base.max(x::Sigmoid{N,ES,:exact}, y::Sigmoid{N,ES,:upper}) where {N,ES}
    x == Sigmoid{N,ES,:exact}(Inf) && return x
    (@s x) >= (@s y) ?  x : y
end
Base.max(x::Sigmoid{N,ES,:lower}, y::Sigmoid{N,ES,:exact}) where {N,ES} = max(y,x)
Base.max(x::Sigmoid{N,ES,:upper}, y::Sigmoid{N,ES,:exact}) where {N,ES} = max(y,x)

function Base.min(x::Sigmoid{N,ES,:exact}, y::Sigmoid{N,ES,:lower}) where {N,ES}
    x == Sigmoid{N,ES,:exact}(Inf) && return x
    (@s x) <= (@s y) ?  x : y
end
function Base.min(x::Sigmoid{N,ES,:exact}, y::Sigmoid{N,ES,:upper}) where {N,ES}
    x == Sigmoid{N,ES,:exact}(Inf) && return x
    (@u s) >= (@s y) ?  y : x
end
Base.min(x::Sigmoid{N,ES,:lower}, y::Sigmoid{N,ES,:exact}) where {N,ES} = min(y,x)
Base.min(x::Sigmoid{N,ES,:upper}, y::Sigmoid{N,ES,:exact}) where {N,ES} = min(y,x)

function Base.abs(x::Valid{N,ES}) where {N,ES}
    if roundsinf(x)
        return containszero(x) ? zero(Vnum{N,ES}) → Vnum{N,ES}(Inf) : min(x.lower, -x.upper) → Vnum{N,ES}(Inf)
    elseif containszero(x)
        return zero(Vnum{N,ES}) → max(-x.lower, x.upper)
    else
        return nonpositive(x) ? -x : x
    end
end

#in order to get lu factorization working we need to implement a very special
#form of the > function.

Base.isless(x::Valid{N,ES}, y::Valid{N,ES}) where {N,ES} = x.upper < y.upper
Base.:<(x::Valid{N,ES}, y::Valid{N,ES}) where {N,ES} = Base.isless(x,y)

#not-nowhere-equal
function nowhere_equal(a::Valid{N,ES}, b::Valid{N,ES}) where {N,ES}
    if roundsinf(a)
        roundsinf(b) && return false
        (a.lower > b.upper) && (a.upper < b.lower)
    elseif roundsinf(b)
        (a.lower > b.upper) && (a.upper < b.lower)
    else
        (a.lower > b.upper) || (b.lower > a.upper)
    end
end

≸(a::Valid{N,ES}, b::Valid{N,ES}) where {N,ES} = !nowhere_equal(a,b)
≹(a::Valid{N,ES}, b::Valid{N,ES}) where {N,ES} = ≸(a, b)
#≮(a::Valid{N,ES}, b::Valid{N,ES}) = !(a < b)
#≯(a::Valid{N,ES}, b::Valid{N,ES}) = !(a > b)

export ≸,≹,≯,≮
