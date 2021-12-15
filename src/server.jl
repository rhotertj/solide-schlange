include("battlesnake.jl")
include("algorithms.jl")
include("minimax.jl")
include("agent.jl")
using Joseki, JSON, HTTP

### Create some endpoints


function index(req::HTTP.Request)
    response_dict = Dict("name" => "solide schlange", "color" => "#002b38", "head" => "shades", "tail" => "bold", "apiversion" => "1")
    json_responder(req, response_dict)
end

function move(req::HTTP.Request)
    j = try
        body_as_dict(req)
    catch err
        return error_responder(req, "I was expecting a json request body!")
    end
    has_all_required_keys(["n", "k"], j) || return error_responder(req, "You need to specify values for n and k!")
    json_responder(req, binomial(j["n"],j["k"]))
end

### Create and run the server

# Make a router and add routes for our endpoints.
endpoints = [
    (index, "GET", "/"),
    (index, "GET", "/index"),
    (start_game, "POST", "/start"),
    (move, "POST", "/move"),
    (end_game, "POST", "/end"),

]
r = Joseki.router(endpoints)

# Fire up the server
HTTP.serve(r, "127.0.0.1", 8000; verbose=true)