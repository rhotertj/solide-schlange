include("battlesnake.jl")
include("algorithms.jl")
include("minimax.jl")
include("agent.jl")
println("Import all done")

# Turn 7 https://play.battlesnake.com/g/73639a35-ade8-42ee-9584-72f2a44266ef/
snake1 = Snake(
    [
        Position(5,6),
        Position(5,5), 
        Position(5,4),
        Position(4,4)
    ],
    false,
    100
    )
snake2 = Snake(
    [
        Position(6,5), 
        Position(6,4), 
        Position(6,3),
        Position(7,3),
    ],
    false,
    100
    )

food = Food([Position(6,6)])

# Turn 73 https://play.battlesnake.com/g/15939765-2c43-4b3d-a42a-5c5810db4703/
# snake1 = Snake(
#     [
#         Position(5,4),
#         Position(4,4), 
#         Position(4,5),
#         Position(5,5),
#         Position(5,6),
#         Position(5,7),
#         Position(4,7),
#         Position(4,8),
#     ],
#     false,
#     100
#     )
# snake2 = Snake(
#     [
#         Position(2,5), 
#         Position(2,4), 
#         Position(3,4),
#         Position(3,3),
#         Position(4,3),
#         Position(5,3),
#         Position(5,2),
#     ],
#     false,
#     100
#     )

# food = Food(
#     [
#         Position(3,5),
#         Position(3,9), 
#         Position(1,11), 
#         Position(8,5), 
#         Position(9,7), 
#         Position(9,8), 
#     ]
#     )



### Play best move
height, width = 11, 11
board = Boardstate([snake1, snake2], food, height, width)

print_board(board)
# flood = floodfill([snake1, snake2], width, height, 1)
# println(flood)
a = iterative_deepening(board, 400.0, height, width, 1)
println(a)
move_snake!(snake1, food, a)
winner = check_winner([snake1, snake2], 1, height, width)
println("Winnner is $winner")
# print("-----------------")
print_board(board)