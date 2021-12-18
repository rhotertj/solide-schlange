include("battlesnake.jl")
include("algorithms.jl")
include("minimax.jl")
include("agent.jl")
println("Import all done")

# Turn 7 https://play.battlesnake.com/g/73639a35-ade8-42ee-9584-72f2a44266ef/
snake1 = Snake(
    [
        Position(6,5),
        Position(7,5), 
        Position(8,5),
        Position(8,4)
    ],
    false,
    100
    )
snake2 = Snake(
    [
        Position(7,6), 
        Position(8,6), 
        Position(9,6),
        Position(9,7),
    ],
    false,
    100
    )


time = 400 # ms
height, width = 11, 11
food = Food([Position(6,6)])

board = Boardstate([snake1, snake2], food, height, width)

# print_board(board)
# flood = floodfill([snake1, snake2], width, height, 1)
# println(flood)
a = iterative_deepening(board, 400.0, height, width, 1)
println(a)
# move_snake!(snake1, food, up)
# winner = check_winner([snake1, snake2], 1, height, width)
# println("Winnner is $winner")
# print("-----------------")
# print_board(board)