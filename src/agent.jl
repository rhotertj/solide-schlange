function start_game()
    
end

function move(board::Boardstate, you_index::Int, simulation_time::Float64)
    # time stuff
    if length(board.snakes) > 2
        simulation_time -= 0.05
        minimax_action = iterative_deepening_maxn(board, simulation_time, board.height, board.width, you_index)
    else
        minimax_action = iterative_deepening(board, simulation_time, board.height, board.width, you_index)
    end
    return minimax_action
end

function end_game()
    
end
