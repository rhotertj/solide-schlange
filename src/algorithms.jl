using DataStructures

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

function maxN_floodfill(snakes::Vector{Snake}, width::Int, height::Int)
    
    fields = zeros(length(snakes))
    visited = Set()
    for snek in snakes
        push!(visited, get_body_no_head(snek))
    end

    stack = Tuple{Position, Int}[]
    for (p, snek) in enumerate(snakes)
        push!(stack, (get_head(snek), p))
    end

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

    return fields
end

function a_star_search(start_field:: Position, search_field::Position, board::Boardstate)

    queue = PriorityQueue{Position, Int}()
    came_from = Dict{Position, Tuple{Position, Direction}}()
    cost_so_far = Dict{Position, Int}()
    cost_so_far[start_field] = 0
    queue[start_field] = 0

    while !isempty(queue)
        node = dequeue!(queue)
        if node == search_field
            break
        end
        for (dir, nb) in get_neighbors(node)
            s = Inf
            for snake in board.snakes
                if nb in snake.body
                    idx = findfirst(b -> b==nb, snake.body)
                    s = length(snake.body) - 1 - idx
                end
            end
            # next pos is / will be free, in bounds and no circles
            if (!is_occupied_by_snake(nb, board) || h(start_field, nb) > s) && check_bounds(nb, board.height, board.width) && get(came_from, nb, nothing) === nothing
                c = cost_so_far[node] + h(nb, search_field)
                cost_so_far[nb] = cost_so_far[node] + 1
                came_from[nb] = (node, dir)
                queue[nb] = c
            end
        end
    end

    prev = search_field
    direction = nothing
    path = Vector{Tuple{Union{Direction, Nothing}, Position}}()
    push!(path, (direction, prev))
    while true
        prev, direction = get(came_from, prev, (nothing, nothing))
        if prev === nothing
            return nothing, nothing
        end
        push!(path, (direction, prev))
        if prev == start_field
            break
        end
    end
    return cost_so_far[search_field], path
end

function h(x::Position, y::Position)
    dx = abs(x.x - y.x)
    dy = abs(x.y - y.y)
    return dx + dy
end