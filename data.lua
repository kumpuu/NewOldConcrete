require("util")

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
    if type(v) == "table" then
      t1[k] = table.deepcopy(v)
    else
		  t1[k] = v
    end
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

function patchNewConcrete()
  patchTable(concrete.variants, require("prototypes.oldConcrete"))

  recReplaceVal(concrete.transitions, "__base__/graphics/terrain/water-transitions/concrete.png", "__base__/graphics/terrain/water-transitions/grass.png")
  recReplaceVal(concrete.transitions_between_transitions, "__base__/graphics/terrain/water-transitions/concrete-transitions.png", prefix .. "graphics/transitions/grass-transition.png")

  recDeleteKey(concrete.transitions, "hr_version")
  recDeleteKey(concrete.transitions_between_transitions, "hr_version")
end

function patchNewHazardConcrete()
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
end

function replaceStonePathWithNewConcrete()
  patchTable(stonePath, {
    variants = concrete.variants,
    transitions = concrete.transitions,
    transitions_between_transitions = concrete.transitions_between_transitions,
    transition_overlay_layer_offset = concrete.transition_overlay_layer_offset,
  })
end

function addUnderNewName(t, name, iconPath, patches)
  local tile = table.deepcopy(t)

  tile.name = name
  if patches then
    patchTable(tc, patches)
  end

  local item = require("prototypes.tile_item")
  item.icon = iconPath

  local recipe = require("prototypes.tile_recipe")

  data:extend({tile, item, recipe})
end

function getStrSettingInt(setting)
  local str = settings.startup[setting].value
  return tonumber(str:match("^%d+"))
end


----------------------------------------------------------------------


prefix = "__NewOldConcrete__/"
concrete = data.raw.tile["concrete"]
stonePath = data.raw.tile["stone-path"]

local newConOptn = getStrSettingInt("NewOldConcrete-new-concrete-graphics")

if newConOptn == 2 then
  replaceStonePathWithNewConcrete()

elseif newConOptn == 3 then
  addUnderNewName(stonePath, "NewOldConcrete-cobblestone-path", prefix .. "graphics/icons/newStone.png")
  replaceStonePathWithNewConcrete()

elseif newConOptn == 4 then
  addUnderNewName(concrete, "NewOldConcrete-cobblestone-path", prefix .. "graphics/icons/newConcrete.png")
end

patchNewConcrete()
patchNewHazardConcrete()