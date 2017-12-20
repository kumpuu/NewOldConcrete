function printTable(t, prefix)
  if not prefix then
    prefix = ""
  end

  for k,v in pairs(t) do
    local typ = "[" .. type(v) .. "] "
    local name = "'" .. k .. "' ="
    local val = " " .. tostring(v)

    if type(v) == "table" then
      log(prefix .. typ .. name)
      printTable(v, prefix .. "___")

    else
      log(prefix .. typ .. name .. val)
    end
  end
end

function patchTable(t1, t2)
	for k,v in pairs(t2) do
		t1[k] = v
	end
end

function recReplaceVal(t, oldVal, newVal)
  for k,v in pairs(t) do
    if v == oldVal then
      t[k] = newVal

    elseif type(v) == "table" then
      recReplaceVal(v, oldVal, newVal)
    end
  end
end

function recDeleteKey(t, key)
  for k,v in pairs(t) do
    if k == key then
      t[k] = nil

    elseif type(v) == "table" then
      recDeleteKey(v, key)
    end
  end
end

local prefix = "__NewOldConcrete__/"

local con = data.raw.tile["concrete"]

patchTable(con.variants, {
  inner_corner =
  {
    picture = prefix .. "graphics/concrete-inner-corner.png",
    count = 16,
  },
  inner_corner_mask =
  {
    picture = prefix .. "graphics/concrete-inner-corner-mask.png",
    count = 16,
  },

  outer_corner =
  {
    picture = prefix .. "graphics/concrete-outer-corner.png",
    count = 8,
  },
  outer_corner_mask =
  {
    picture = prefix .. "graphics/concrete-outer-corner-mask.png",
    count = 8,
  },

  side =
  {
    picture = prefix .. "graphics/concrete-side.png",
    count = 16,
  },
  side_mask =
  {
    picture = prefix .. "graphics/concrete-side-mask.png",
    count = 16,
  },

  u_transition =
  {
    picture = prefix .. "graphics/concrete-u.png",
    count = 8,
  },
  u_transition_mask =
  {
    picture = prefix .. "graphics/concrete-u-mask.png",
    count = 8,
  },

  o_transition =
  {
    picture = prefix .. "graphics/concrete-o.png",
    count = 1,
  },
  o_transition_mask =
  {
    picture = prefix .. "graphics/concrete-o-mask.png",
    count = 1,
  },

  material_background =
  {
    picture = prefix .. "graphics/concrete.png",
    count = 8,
  },
})

recReplaceVal(con.transitions, "__base__/graphics/terrain/water-transitions/concrete.png", "__base__/graphics/terrain/water-transitions/grass.png")
recReplaceVal(con.transitions_between_transitions, "__base__/graphics/terrain/water-transitions/concrete-transitions.png", prefix .. "graphics/transitions/grass-transition.png")

recDeleteKey(con.transitions, "hr_version")
recDeleteKey(con.transitions_between_transitions, "hr_version")


local hConLeft = data.raw.tile["hazard-concrete-left"]
local hConRight = data.raw.tile["hazard-concrete-right"]

patchTable(hConLeft.variants, {
  material_background =
  {
    picture = prefix .. "graphics/hazard/hazard-concrete-left.png",
    count = 8,
  },
})

patchTable(hConRight.variants, {
  material_background =
  {
    picture = prefix .. "graphics/hazard/hazard-concrete-right.png",
    count = 8,
  },
})