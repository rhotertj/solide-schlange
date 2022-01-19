function start_game()
    
end

function move(board::Boardstate, you_index::Int, simulation_time::Float64)
    # time stuff
    simulation_time -= 0.05
    if length(board.snakes) > 2
        
        # for all possible action combinations
        #   move snakes accordingly
        #   check dead
        #   count dead for action
        #  
        # if health < 50
        #   check path to nearest food
        #   if path is dangerous, go for floodfill
        # for all possible actions
        #   compute floodfill
        # if best flood is dangerous
        #   use least dangerous action
        # play flood action
    else
        minimax_action = iterative_deepening(board, simulation_time, board.height, board.width, you_index)
    end
    return minimax_action
end

function end_game()
    
end
