# using .Battlesnake

function floodfill(snakes::Vector{Snake}, width::Int, height::Int, player::Int)
    snek = snakes[player]
    opponent = (player % 2) + 1
    opponent_snake = snakes[opponent]
    fields = zeros(2)
    fields[player] = length(snek.body) - 1 
    fields[opponent] = length(opponent_snake.body) - 1

    visited = Set(get_body_no_head(snek))
    for b in get_body_no_head(opponent_snake)
        push!(visited, b)
    end

    stack = Tuple{Position, Int}[]
    push!(stack, (get_head(snek), player))
    push!(stack, (get_head(opponent_snake), opponent))
    while !isempty(stack)
        pos, p = popfirst!(stack)
        if !(pos in visited)
            push!(visited, pos)
            fields[p] += 1
            for d in (up, down, left, right)
                next_pos = move_from(pos, d)
                if !(next_pos in visited) && check_bounds(next_pos, height, width)
                    push!(stack, (next_pos, p))
                end
            end
        end
    end

    return fields[player] - fields[opponent]
end

