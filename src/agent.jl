function start_game()
    
end


function move(board::Boardstate, you_index::Int, simulation_time::Float64)
    # time stuff
    simulation_time -= 0.05
    
    if length(board.snakes) > 2

        snek = board.snakes[you_index]
        
        possible_as = [possible_actions(snake) for snake in board.snakes]
        dead_counts = Dict{Direction, Int}(a => 0 for a in possible_actions(snek))

        for actions in Iterators.product(possible_as...)
            new_board = deepcopy(board)
            for (i, dir) in enumerate(actions)
                move_snake!(new_board.snakes[i], new_board.food, dir)
            end
            dead = check_dead(new_board.snakes, new_board.height, new_board.width)
            if you_index in dead
                dead_counts[actions[you_index]] += 1
            end
        end
        food_action = nothing
        if snek.health < 50

            min_dist = nothing
            min_path = nothing

            for f in board.food.positions
                our_distance, our_path = a_star_search(get_head(snek), f, deepcopy(board))
                if our_distance === nothing
                    continue
                end
                opponent_distances = Vector{Int}()
                for (i, snake) in enumerate(board.snakes)
                    if i == you_index
                        continue
                    end
                    d = a_star_search(get_head(snake), f, deepcopy(board))[1]
                    if d === nothing
                        d = 2000
                    end
                    push!(opponent_distances, d)
                end
                if all([d === nothing for d in opponent_distances]) || all([our_distance < d for d in opponent_distances])
                    if min_dist === nothing || our_distance < min_dist
                        min_dist = our_distance
                        min_path = our_path
                    end
                elseif any([our_distance == d for d in opponent_distances]) && our_distance == minimum(opponent_distances)
                    opponent_idx = findfirst(d -> d == our_distance, opponent_distances)
                    if length(snek.body) > length(board.snakes[opponent_idx].body)
                        if min_dist === nothing || our_distance < min_dist
                            min_dist = our_distance
                            min_path = our_path
                        end
                    end
                end
            end
            
            if min_path !== nothing
                food_action = last(min_path)[1]
                return food_action
            else    
                food_action = nothing
            end

        end
        if food_action !== nothing && dead_counts[food_action] == 0
            return food_action
        end
        flood_values = Vector{Tuple{Direction, Int}}()
        for action in possible_actions(snek)
            new_board = deepcopy(board)
            move_snake!(new_board.snakes[you_index], new_board.food, action)
            
            floods = maxN_floodfill(new_board.snakes, board.width, board.height)
            push!(flood_values, (action, floods[you_index]))
        end
        flood_action = sort(flood_values, by=di -> di[2], rev=true)[1][1]
        if dead_counts[flood_action] != 0

            dead_list = sort(collect(pairs(dead_counts)), by=di -> di[2])
            return dead_list[1][1]

        end
        return flood_action

    else
        minimax_action = iterative_deepening(board, simulation_time, board.height, board.width, you_index)
    end
    return minimax_action
end

function end_game()
    
end
