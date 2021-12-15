include("battlesnake.jl")
include("algorithms.jl")
include("minimax.jl")
include("agent.jl")
println("Import all done")

snake1 = Snake([Position(1,1), Position(1,2), Position(1,3)], false, 100)
snake2 = Snake([Position(4,3), Position(5,3), Position(6,3)], false, 100)
time = 400 # ms
height, width = 11, 11
food = Food([Position(2,2)])

board = Boardstate([snake1, snake2], food, height, width)

# print_board(board)
# flood = floodfill([snake1, snake2], width, height, 1)
# println(flood)
a = iterative_deepening(board, 400, height, width, 1)
println(a)
# move_snake!(snake1, food, up)
# winner = check_winner([snake1, snake2], 1, height, width)
# println("Winnner is $winner")
# print("-----------------")
# print_board(board)