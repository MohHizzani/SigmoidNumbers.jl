
isless(lhs::Sigmoid{N, ES, mode}, rhs::Sigmoid{N, ES, mode}) where {N, ES, mode} = @s(lhs) < @s(rhs)

Base.:<(lhs::Sigmoid{N, ES, mode}, rhs::Sigmoid{N, ES, mode})  where {N, ES, mode} = (@u(rhs) == (@signbit)) | isless(lhs, rhs)
Base.:<=(lhs::Sigmoid{N, ES, mode}, rhs::Sigmoid{N, ES, mode}) where {N, ES, mode} = (@u(rhs) == (@signbit)) | (@s(lhs) <= @s(rhs))
