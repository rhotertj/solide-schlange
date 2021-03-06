# module Battlesnake

# export Boardstate, Snake, Position, Direction, up, down, left, right, move_from

# ============== DIRECTION ==================# 
@enum Direction up down left right



# ============== POSITION ==================# 
struct Position
    x::Int
    y::Int
end

function get_neighbors(pos::Position)
    return [(dir, move_from(pos, dir)) for dir in [up, down, left, right]]
end

function move_from(pos::Position, dir::Direction)
    if dir == up
        return Position(pos.x, pos.y + 1)
    elseif dir == down
        return Position(pos.x, pos.y - 1)
    elseif dir == right
        return Position(pos.x + 1, pos.y)
    elseif dir == left
        return Position(pos.x - 1, pos.y)
    end
end


# ============== FOOD ==================# 
mutable struct Food
    positions::Vector{Position}
end

# ============== SNAKE ==================# 

mutable struct Snake
    body::Vector{Position}
    ate_food::Bool
    health::Int
end


function get_head(snake::Snake)
    return snake.body[1]
end

function get_body_no_head(snake::Snake)
    return snake.body[2:length(snake.body)]
end

function possible_actions(snake::Snake)
    head = snake.body[1]
    neck = snake.body[2]
    # coming from right
    if head.x < neck.x
        return [up, down, left]
    end
    # coming from left
    if head.x > neck.x
        return [up, down, right]
    end

    # coming from below
    if head.y > neck.y
        return [up, right, left]
    end

    # coming from above
    if head.y < neck.y
        return [down, right, left]
    end
    return [up, down, left, right]
end

function move_snake!(snake::Snake, food::Food, action::Direction)
    h = get_head(snake)
    new_head = move_from(h, action)
    insert!(snake.body, 1, new_head)
    if !snake.ate_food
        pop!(snake.body)
    end
    snake.ate_food = false
    snake.health -= 1
    food_eaten = -1
    for i in 1:length(food.positions)
        if new_head == food.positions[i]
            snake.ate_food = true
            food_eaten = i
            snake.health = 100
        end
    end
    if food_eaten > -1
        deleteat!(food.positions, food_eaten)
    end
end

function check_bounds(pos::Position, height::Int, width::Int)
    return pos.x >= 1 && pos.x < width + 1 && pos.y >= 1 && pos.y < height + 1
end

function check_dead(snakes::Vector{Snake}, height::Int, width::Int)
    dead = Set()
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
            
        end
    end
    return dead
end


# ============== BOARDSTATE ==================# 
mutable struct Boardstate
    snakes::Vector{Snake}
    food::Food
    height::Int
    width::Int
end

function is_occupied_by_snake(pos::Position, state::Boardstate)
    for snake in state.snakes
        if pos in snake.body
            return true
        end
    end
    return false
end


function print_board(state::Boardstate)
    board = fill(0, (state.height, state.width))
    for (i,snek) in enumerate(state.snakes)
        for p in snek.body
            board[p.y, p.x] = i
        end
    end
    for f in state.food.positions
        board[f.y, f.x] = 5
    end
    reverse!(board, dims = 1)
    for r in 1:size(board,1)
        println(board[r, :])
    end
end

function next_player(current_player, num_players)
    return (current_player % num_players) + 1
end

# end # module end