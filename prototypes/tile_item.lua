return {
  type = "item",
  name = "NewOldConcrete-cobblestone-path",
  icon_size = 32,
  flags = {"goes-to-main-inventory"},
  subgroup = "terrain",
  order = "b[stone-brick]",
  stack_size = 100,
  place_as_tile =
  {
    result = "NewOldConcrete-cobblestone-path",
    condition_size = 1,
    condition = { "water-tile" }
  }
}