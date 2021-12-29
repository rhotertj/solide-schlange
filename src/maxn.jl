
mutable struct MaxNNode
    snakes::Vector{Snake}
    food::Food
    height::Int
    width::Int
    depth::Int
    action::Union{Direction, Nothing}
    winner::Union{Int, Nothing}
    dead::Set{Int}
end

function iterative_deepening_maxn(board::Boardstate, simulation_time::Float64, height::Int, width::Int, you_index::Int)
        simulation_time = Millisecond(floor(Int,simulation_time))
        snakes = board.snakes
        food = board.food
        root = MaxNNode(snakes, food, height, width, 0, nothing, nothing, Set{Int}())
        action_nodes = possible_successors(root, you_index)
        best_action = nothing
        depth = 1
    
        start = now()
        last_time = Millisecond(0)
        values = Tuple{Vector{Float64}, MinimaxNode}[]
        while now() - start + last_time < simulation_time
            start_run = now()
            empty!(values)
    
            for a_node in action_nodes
                if now() - start < simulation_time
                    vector = maxn(a_node, depth, player, length(a_node.snakes), you_index)
                    push!(values, (vector, a_node))
                end
            end
            depth += 1
            if length(values) == length(action_nodes)
                sort!(values, by= x -> x[1][you_index], rev=true)
                best_action = values[1][2].action
                action_nodes = [v[2] for v in values]
            end
            last_time = now() - start_run
        end
        # println("$depth")
        # println([(v[1], v[2].action) for v in values])
        return best_action
end


function maxn(node::MaxNNode, depth::Int, player::Int, num_players::Int, you_index::Int)
    if depth == 0 || node.winner !== nothing
        return score(node)
    end
    next_p = next_player(player, num_players)
    max_vector = fill(-Inf, 4)
    next_nodes = possible_successors(node, player)
    while length(next_nodes) == 0
        player = next_player(player, num_players)
        next_nodes = possible_successors(node, next_p)
        next_p = next_player(player, num_players)
    end
    for successor in next_nodes
        vector = maxn(successor, depth - 1, player, length(node.snakes), you_index)
    end
    if vector[player] > max_vector[player]
        max_vector = vector
    end
    return max_vector
end

function possible_successors(node::MaxNNode, player::Int)
    if player in node.dead
        return []
    end
    successors = Vector{MaxNNode}[]
    snake = self.snakes[player]
    for a in possible_actions(snake)
        new_snek, new_food = move_snake(deepcopy(snake), deepcopy(node.food), a)
        if !check_bounds(get_head(new_snek), node.height, node.width)
            continue
        end
        snakes = deepcopy(node.snakes)
        snakes[player] = new_snek
        dead_for_a = deepcopy(node.dead)
        winner = enforce_rules(snakes, dead_for_a)
        n = MaxNNode(snakes, new_food, node.height, node.width, node.depth + 1, a, winner, dead_for_a)
        push!(successors, n)
    end
    return successors
end

function check_winner(node::MaxNNode, snakes::Vector{Snake}, dead::Vector{Int})
    
    for (p, snek) in enumerate(snakes)
        # starve
        if snek.health == 0
            push!(dead, p)
        end
        
        for (o, opponent) in enumerate(snakes)
            if o == p
                continue
            end

            if get_head(snek) in opponent.body
                # head2head
                if get_head(snek) == get_head(opponent)
                    # RAM
                    if length(snek.body) > length(opponent.body)
                        push!(dead, o)
                    # draw
                    elseif length(snek.body) == length(opponent.body)
                        push!(dead, o)
                        push!(dead, p)
                    else
                        # lost (head2head) collision with opponent
                        push!(dead, p)
                    end
                else
                    # ran into opponent
                    push!(dead, p)            
                end
            end

            # collision with self
            if get_head(snek) in get_body_no_head(snek)
                push!(dead, p)
            end
            if !check_bounds(get_head(snek), height, width)
                push!(dead, p)
            end
            
            if length(dead) == length(snakes) - 1
                winset = setdiff(Set(collect(1:length(snakes))), dead)
                return minimum(winset)
            end
        end
    end
end

function score(node::MaxNNode)

end