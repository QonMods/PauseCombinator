local tint = {r = 1, g = 1, b = 0}
--make the entity
local PauseCombinatorEntity = util.table.deepcopy(data.raw["constant-combinator"]["constant-combinator"]);
PauseCombinatorEntity.name = "pause-combinator"
PauseCombinatorEntity.item_slot_count = 0
PauseCombinatorEntity.order = "a[MapPing]"
PauseCombinatorEntity.minable.result = "pause-combinator"
for k, direction in pairs(PauseCombinatorEntity.sprites) do
  for kk, vv in pairs(direction.layers) do
    vv.tint = tint
    vv.hr_version.tint = tint
  end
end
data:extend({PauseCombinatorEntity})

--make the item
local PauseCombinatorItem = util.table.deepcopy(data.raw["item"]["constant-combinator"])
PauseCombinatorItem.name = "pause-combinator"
PauseCombinatorItem.place_result = "pause-combinator"
PauseCombinatorItem.icons = {{icon = PauseCombinatorItem.icon, icon_size = PauseCombinatorItem.icon_size, tint = tint}}
PauseCombinatorItem.icon = nil
data:extend({PauseCombinatorItem})

--make the recipe
local PauseCombinatorRecipe = util.table.deepcopy(data.raw.recipe["constant-combinator"])
PauseCombinatorRecipe.name = "pause-combinator"
PauseCombinatorRecipe.result = "pause-combinator"
data:extend({PauseCombinatorRecipe})

--add the recepe to the "circuit network" technology
table.insert(data.raw.technology["circuit-network"].effects, {
  type = "unlock-recipe",
  recipe = "pause-combinator"
})

data:extend({
  {
    type = "custom-input",
    name = "pause-combinator-unpause",
    key_sequence = "PAUSE",
    consuming = "none"
  }
})