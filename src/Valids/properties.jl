@generated function isulp(x::Vnum{N, ES}) where {N,ES}
  inc = increment(Vnum{N, ES})
  :( (@u(x) & $inc) != 0 )
end

@generated function Base.isempty(x::Valid{N,ES}) where {N,ES}
  inc = increment(Vnum{N,ES})
  quote
    ((x.lower == zero(Vnum{N,ES})) || (x.upper == zero(Vnum{N,ES}))) && (@u(x.lower) == @u(x.upper) + $inc)
  end
end

Base.isnan(x::Valid{N,ES}) where {N,ES} = isempty(x)

@generated function isallreals(x::Valid{N,ES}) where {N,ES}
  inc = increment(Vnum{N,ES})
  quote
    (x.lower != zero(Vnum{N,ES})) && (x.upper != zero(Vnum{N,ES})) && (@u(x.lower) == @u(x.upper) + $inc)
  end
end

istile(x::Valid{N,ES}) where {N,ES} = (x.lower == x.upper)

@doc """
    roundsinf(x::Valid)
    checks if the value "rounds infinity".  Table:

    ===================================
    [(+, 0])      |           true
    [(+, +])      |  lower > upper
    [(+, Inf)     |          false
    [(+, Inf]     |           true
    [(+, -])      |           true
    [Inf, 0])     |           true
    (Inf, 0])     |          false
    [Inf, +])     |           true
    (Inf, +])     |          false
    [Inf, -])     |           true
    (Inf, -])     |          false
    [Inf, Inf]    |           true
    (Inf, Inf]    |           true (ℝp)
    [Inf, Inf)    |           true (ℝp)
    (Inf, Inf)    |          false
    [(-, 0])      |          false
    [(-, +])      |          false
    [(-, Inf)     |          false
    [(-, Inf]     |           true
    [(-, -])      |  lower > upper
    [0, 0]        |          false
    [0, 0)        |          false (∅, may be mapped to noisy NaN in the future)
    (0, 0]        |          false (∅)
    (0, 0)        |           true
    [(0, +])      |          false
    [(0, Inf)     |          false
    [(0, Inf]     |           true
    [(0, -])      |           true
"""
function roundsinf(x::Valid{N,ES}) where {N,ES}
    (!isempty(x)) && ((@s(x.upper) < @s(x.lower)) || isinf(x.lower))
end

#amazing symmetrical structure to "roundsinf"
function containszero(x::Valid{N,ES}) where {N,ES}
    (!isempty(x)) && ((@u(x.upper) < @u(x.lower)) || x.lower == zero(Vnum{N,ES}))
end

function ispositive(x::Valid{N,ES}) where {N,ES}
  zero(@Int) < (@s x.lower) <= (@s x.upper)
end

function isnegative(x::Valid{N,ES}) where {N,ES}
  (@u Vnum{N,ES}(Inf))< (@u x.lower) <= (@u x.upper)
end


"""
  nonnegative(::Valid) is true if no values in x are negative.
"""
nonnegative(x::Valid{N,ES}) where {N,ES} = (x.lower <= zero(Vnum{N,ES})) && ((!isfinite(x.upper) || x.lower <= x.upper <= maxpos(Vnum{N,ES})))

"""
  nonpositive(::Valid) is true if no values in x are positive.
"""
nonpositive(x::Valid{N,ES}) where {N,ES} = (x.upper <= zero(Vnum{N,ES})) && ((!isfinite(x.lower) || minneg(Vnum{N,ES}) <= x.lower <= x.upper))

"""
  rounds_positive(::Valid) is true if x contains both zero, infinity, and passes through the positive numbers.
"""
rounds_positive(x::Valid{N,ES}) where {N,ES} = isfinite(x.lower) && (x.lower <= zero(Vnum{N,ES})) && (x.upper < x.lower)

"""
  rounds_negative(::Valid) is true if x contains both zero, infinity, and passes through the negative numbers.
"""
rounds_negative(x::Valid{N,ES}) where {N,ES} = isfinite(x.upper) && (x.upper >= zero(Vnum{N,ES})) && (x.lower > x.upper)
