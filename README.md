# Solide Schlange

<img src="https://github.com/rhotertj/solide-schlange/blob/main/images/snek.jpg" width="350" height="350" align="right"></img>

A battlesnake written in Julia.
Uses alpha-beta search combined with iterative deepening. Leaf nodes are evaluated by a floodfill algorithm.

Arena mode is heuristic based.

Start server to host API:

```
$ julia src/server.jl
```

Note: Thanks to JIT compilation, solide schlange needs some warmup games ;)
