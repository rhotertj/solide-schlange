
using Dates


struct MinimaxNode
    snakes::Vector{Snake}
    food::Food
    height::Int
    width::Int
    depth::Int
    action::Union{Direction, Nothing}
    winner::Union{Int, Nothing}
end

function iterative_deepening(board::Boardstate, simulation_time::Float64, height::Int, width::Int, you_index::Int)
    simulation_time = Millisecond(floor(Int,simulation_time))
    snakes = board.snakes
    food = board.food
    root = MinimaxNode(snakes, food, height, width, 0, nothing, nothing)
    action_nodes = possible_successors(root, you_index)
    best_action = nothing
    depth = 1

    start = now()
    last_time = Millisecond(0)
    values = Tuple{Float64, MinimaxNode}[]
    while now() - start + last_time < simulation_time
        start_run = now()
        empty!(values)

        for a_node in action_nodes
            if now() - start < simulation_time
                score = minimax(a_node, depth, -Inf, Inf, (you_index % 2) + 1, you_index)
                push!(values, (score, a_node))
            end
        end
        depth += 1
        if length(values) == length(action_nodes)
            sort!(values, by= x -> x[1], rev=true)
            best_action = values[1][2].action
            action_nodes = [v[2] for v in values]
        end
        last_time = now() - start_run
    end
    # println("$depth")
    # println([(v[1], v[2].action) for v in values])
    return best_action
end

function minimax(node::MinimaxNode, depth::Int, alpha::Float64, beta::Float64, player::Int, you_index::Int)
    if depth == 0 || node.winner !== nothing
        return score(node, you_index) # metric or win/lose
    end

    next_player = (player % 2) + 1
    if player == 1
        value = -Inf
        for successor in possible_successors(node, player)
            value = max(value, minimax(successor, depth - 1, alpha, beta, next_player, you_index))
            if value >= beta
                break # beta cutoff
            end
            alpha = max(alpha, value)
        end
        return value
    else
        value = Inf
        for successor in possible_successors(node, player)
            value = min(value, minimax(successor, depth - 1, alpha, beta, next_player, you_index))
            if value <= alpha
                break # alpha cutoff
            end
            beta = min(beta, value)
        end
        return value
    end
end

function possible_successors(node::MinimaxNode, player::Int)
    successors = MinimaxNode[]
    snek = node.snakes[player]
    for a in possible_actions(snek)
        new_snek, new_food = deepcopy(snek), deepcopy(node.food)
        move_snake!(new_snek, new_food, a)
        snakes = deepcopy(node.snakes)
        snakes[player] = new_snek
        winner = check_winner(snakes, player, node.height, node.width)
        n = MinimaxNode(snakes, new_food, node.height, node.width, node.depth + 1, a, winner)
        push!(successors, n)
    end

    return successors
end

function check_winner(snakes, player, height, width)
    opponent = (player % 2) + 1
    snek = snakes[player]
    opponent_snake = snakes[opponent]
    # starve
    if snek.health == 0
        return opponent
    end

    if get_head(snek) in opponent_snake.body
        # head2head
        if get_head(snek) == get_head(opponent_snake)
            # RAM
            if length(snek.body) > length(opponent_snake.body)
                return player
            end
            # draw
            if length(snek.body) == length(opponent_snake.body)
                return -1
            end            
        end

        # lost (head2head) collision with opponent_snake
        return opponent
    end
    # collision with self
    if get_head(snek) in get_body_no_head(snek)
        return opponent
    end
    if !check_bounds(get_head(snek), height, width)
        return opponent
    end
end

function score(node::MinimaxNode, player::Int)
    discount = 0.99 ^ node.depth
    h_factor = 1
    l_factor = 4
    f_factor = 1
    if node.winner == player
        return 200 * discount
    end
    if node.winner == (player % 2) + 1
        return -200 * discount
    end
    # draw
    if node.winner == -1
        return 0
    end
    snek = node.snakes[player]
    health_diff = 2 * snek.health - sum([s.health for s in node.snakes])
    len_diff = 2 * length(node.snakes[player].body) - sum([length(s.body) for s in node.snakes])
    flood = floodfill(node.snakes, node.width, node.height, player)

    return h_factor * health_diff + l_factor * len_diff + f_factor * flood * discount
end

