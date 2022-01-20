include("battlesnake.jl")
include("algorithms.jl")
include("minimax.jl")
include("agent.jl")
include("maxn.jl")
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
snake3 = Snake(
    [
        Position(1,1), 
        Position(1,2), 
        Position(1,3),
        Position(1,4),
    ],
    false,
    100
    )

food = Food([Position(6,6)])


# Weird head2head
# Looks like "working as intended" since we don't move simultaneously in minimax
# Why is this no problem in python though?
# Would't the opponent win in the next step?
# Turn 11 https://play.battlesnake.com/g/1a6794ac-9da9-4e32-a74b-b246797dbb16/
snake1 = Snake(
    [
        Position(7,4),
        Position(8,4), 
        Position(8,3),
        Position(7,3)
    ],
    false,
    49
    )
snake2 = Snake(
    [
        Position(6,5), 
        Position(6,6), 
        Position(6,7),
        Position(5,7),
        Position(4,7),
    ],
    false,
    100
    )
snake4 = Snake(
        [
            Position(9,5), 
            Position(9,6)
        ],
        false,
        100
    )
food = Food([Position(11,5), Position(9,2)])
### Play best move
height, width = 11, 11
snakes = [snake1, snake2, snake3, snake4]
board = Boardstate(snakes, food, height, width)
print_board(board)
move(board, 1, 0.4)
# println(a_star_search(Position(1,1), Position(5,5), board))
# flood = floodfill([snake1, snake2], width, height, 1)
# println(flood)
# for x in 1:10
#     for i in 1:length(snakes)
#         a = iterative_deepening_maxn(board, 400.0, height, width, 3)
#         move_snake!(snakes[3], food, a)
#         # winner = check_winner(snakes, 1, height, width)
#         # println("Winnner is $winner")
#     end
#     print_board(board)
# end
# print("-----------------")
# print_board(board)
# a = iterative_deepening(board, 400.0, height, width, 2)
# println(a)
# move_snake!(snake2, food, a)
# winner = check_winner([snake1, snake2], 2, height, width)
# println("Winnner is $winner")
# # print("-----------------")
# print_board(board)