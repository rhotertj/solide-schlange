
mutable struct MaxNNode
    snakes::Vector{Snake}
    food::Food
    height::Int
    width::Int
    depth::Int
    action::Union{Direction, Nothing}
    winner::Union{Int, Nothing}
    dead::Vector{Int}
end

function iterative_deepening_maxn()

end

function maxn()

end

function possible_successors()

end

function check_winner()

end

function score()

end