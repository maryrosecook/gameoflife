Node = Origin mimic do(
  initialize = method(x, y, alive, world,
    self x = x
    self y = y
    self alive = alive
    self world = world
  )

  step = method(world,
    new_alive = self alive
    active_neighbours = self neighbours map(c, c alive) select length
    if(active_neighbours < 2 || active_neighbours > 3, new_alive = false)
    if(!(self alive) && active_neighbours == 3, new_alive = true)
    Node mimic(self x, self y, new_alive, world)
  )

  show = method(if(self alive, "[]", "  ") print)

  out_of_bounds = method(n, n < 0 || n >= world nodes first length)
  neighbour_vectors = [{x: -1, y: -1}, {x: 0, y: -1}, {x: 1, y: -1},
    {x: -1, y: 0}, {x: 1, y: 0},
    {x: -1, y: 1}, {x: 0, y: 1}, {x: 1, y: 1}]

  neighbours = method(vectors: self neighbour_vectors,
    v = vectors[0]

    if(v == nil, return [])
    node = if(self out_of_bounds(self x + v[:x]) || self out_of_bounds(self y + v[:y]),
      [],
      [self world nodes[self y + v[:y]][self x + v[:x]]])

    node + self neighbours(vectors: vectors rest)
  )
)

World = Origin mimic do(
  setup_nodes = method(nodes, self nodes = nodes. self)

  setup_randomise = method(dimension,
    self nodes = []
    dimension times(y,
      self nodes[y] = []
      dimension times(x,
        self nodes[y][x] = Node mimic(x, y, System randomNumber() < 0.1, self)
      )
    )
    self
  )

  step = method(
    new_world = World mimic
    new_world setup_nodes(self nodes map(r, r map(n, n step(new_world))))
  )

  show = method(
    (self nodes first length * 2) times("-" print). "" println
    self nodes map(r, r map(c, c show). "|" println)
  )
)

world = World mimic setup_randomise(30)
loop(
  world show
  world = world step
)
