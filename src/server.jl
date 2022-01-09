include("battlesnake.jl")
include("algorithms.jl")
include("minimax.jl")
include("maxn.jl")
include("agent.jl")
using Joseki, JSON, HTTP

### Create some endpoints


function index(req::HTTP.Request)
    response_dict = Dict("name" => "solide julia", "color" => "#cc00cc", "head" => "shades", "tail" => "bolt", "apiversion" => "1")
    simple_json_responder(req, response_dict)
end

function start_req(req::HTTP.Request)
    req.response.status = 200
    return req.response
end

function end_req(req::HTTP.Request)
    req.response.status = 200
    return req.response
end


function move_req(req::HTTP.Request)
    j = try
        body_as_dict(req)
    catch err
        return error_responder(req, "I was expecting a json request body!")
    end
    # get gamemode later when we have implemented maxN
    simulation_time = j["game"]["timeout"]
    board = j["board"]
    height = board["height"]
    width = board["width"]

    food_json = board["food"]
    food_pos = Position[]
    for f in food_json
        push!(food_pos, Position(f["x"] + 1, f["y"] + 1))
    end
    food = Food(food_pos)

    
    you = j["you"]
    snek_body = Position[]
    for part in you["body"]
        pos = Position(part["x"] + 1, part["y"] + 1)
        # if !(pos in snek_body)
        push!(snek_body, pos)
        # end
    end
    snek = Snake(snek_body, false, you["health"])

    snakes = Snake[]
    push!(snakes, snek)
    json_snakes = board["snakes"]
    for sn in json_snakes
        if sn["id"] == you["id"]
            continue
        end
        body = Position[]
        for part in sn["body"]
            pos = Position(part["x"] + 1, part["y"] + 1)
            #if !(pos in body)
            push!(body, pos)
            #end
        end
        snake = Snake(deepcopy(body), false, sn["health"])
        push!(snakes, snake)
    end

    board = Boardstate(snakes, food, height, width)
    action = move(board, 1, 0.6 * simulation_time)

    response_dict = Dict("move" => dir2str[action])
    simple_json_responder(req, response_dict)
end

dir2str = Dict(
    up => "up",
    down => "down",
    right => "right",
    left => "left"
)

### Create and run the server

# Make a router and add routes for our endpoints.
endpoints = [
    (index, "GET", "/"),
    (index, "GET", "/index"),
    (start_req, "POST", "/start"),
    (move_req, "POST", "/move"),
    (end_req, "POST", "/end"),

]
r = Joseki.router(endpoints)

# Fire up the server
HTTP.serve(r, "0.0.0.0", 8011, verbose=false)