--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************
-- Ink Colours
--Black: 0.129,0.129,0.129
--Red: 0.65, 0.054, 0.054
--Blue: 0.156, 0.188, 0.49
--Green: 0.06, 0.39, 0.17

require "StashDescriptions/StashUtil";

-- food cache/survivor house
local stashMap = StashUtil.newStash("RiversideStashMap1", "Map", "Base.RiversideMap", "Stash_AnnotedMap")
stashMap.buildingX = 6801
stashMap.buildingY = 5487
stashMap:addStamp("Circle", nil, 6801, 5486, 0.65, 0.054, 0.054)
stashMap:addStamp(nil, "Stash_RiversideStashMap1_Text1", 6742, 5493, 0.65, 0.054, 0.054)
stashMap:addStamp(nil, "Stash_RiversideStashMap1_Text11", 6742, 5514, 0.65, 0.054, 0.054)
stashMap:addStamp(nil, "Stash_RiversideStashMap1_Text2", 6618, 5446, 0.65, 0.054, 0.054)
stashMap.barricades = 80
stashMap.spawnTable = "SurvivorCache1"

-- tool cache
-- Pat wants this in the second-floor room
local stashMap = StashUtil.newStash("RiversideStashMap2", "Map", "Base.RiversideMap", "Stash_AnnotedMap")
stashMap.buildingX = 6375
stashMap.buildingY = 5249
stashMap:addStamp("Heart", nil, 6374, 5247, 0.65, 0.054, 0.054)
stashMap:addStamp(nil, "Stash_RiversideStashMap2_Text1", 6387, 5233, 0.65, 0.054, 0.054)
stashMap:addStamp(nil, "Stash_RiversideStashMap2_Text11", 6386, 5257, 0.65, 0.054, 0.054)
stashMap:addStamp(nil, "Stash_RiversideStashMap2_Text12", 6387, 5282, 0.65, 0.054, 0.054)
stashMap.spawnTable = "ToolsCache1";
stashMap:addContainer("ToolsBox", nil, "Base.Bag_DuffelBagTINT", nil, 6375, 5243, 1)

-- location info
local stashMap = StashUtil.newStash("RiversideStashMap3", "Map", "Base.RiversideMap", "Stash_AnnotedMap")
stashMap.buildingX = 6207
stashMap.buildingY = 5346
stashMap:addStamp("Diamond", nil, 6206, 5342, 0.156, 0.188, 0.49)
stashMap:addStamp(nil, "Stash_RiversideStashMap3_Text1", 6214, 5333, 0.156, 0.188, 0.49)
stashMap:addStamp("KnifeFork", nil, 6194, 5339, 0.156, 0.188, 0.49)
stashMap:addStamp("Lightning", nil, 6187, 5353, 0.156, 0.188, 0.49)
stashMap:addStamp("Pill", nil, 6191, 5363, 0.156, 0.188, 0.49)
stashMap:addStamp("ArrowWest", nil, 6203, 5371, 0.156, 0.188, 0.49)
stashMap:addStamp(nil, "Stash_RiversideStashMap3_Text2", 6214, 5363, 0.156, 0.188, 0.49)

-- Survivor House
local stashMap = StashUtil.newStash("RiversideStashMap4", "Map", "Base.RiversideMap", "Stash_AnnotedMap")
stashMap.buildingX = 6784
stashMap.buildingY = 5328
stashMap:addStamp(nil, "Stash_RiversideStashMap4_Text1", 6697, 5274, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_RiversideStashMap4_Text11", 6623, 5298, 0.129,0.129,0.129)
stashMap:addStamp("X", nil, 6783, 5327, 0.129,0.129,0.129)
stashMap:addStamp("Cross", nil, 6570, 5375, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_RiversideStashMap4_Text2", 6528, 5384, 0.129,0.129,0.129)
stashMap.barricades = 80
stashMap.spawnTable = "SurvivorCache1"

-- Survivor House
local stashMap = StashUtil.newStash("RiversideStashMap5", "Map", "Base.RiversideMap", "Stash_AnnotedMap")
stashMap.buildingX = 6306
stashMap.buildingY = 5310
stashMap:addStamp("House", nil, 6304, 5309, 0.65, 0.054, 0.054)
stashMap:addStamp("X", nil, 6306, 5311, 0.65, 0.054, 0.054)
stashMap:addStamp(nil, "Stash_RiversideStashMap5_Text1", 6319, 5291, 0.65, 0.054, 0.054)
stashMap:addStamp(nil, "Stash_RiversideStashMap5_Text2", 6319, 5316, 0.65, 0.054, 0.054)
stashMap.barricades = 80
stashMap.spawnTable = "SurvivorCache1"

-- gun cache in floorboards
local stashMap = StashUtil.newStash("RiversideStashMap6", "Map", "Base.RiversideMap", "Stash_AnnotedMap")
stashMap.buildingX = 6201
stashMap.buildingY = 5471
stashMap:addStamp("DollarSign", nil, 6200, 5470, 0.156, 0.188, 0.49)
stashMap:addStamp(nil, "Stash_RiversideStashMap6_Text1", 6124, 5478, 0.156, 0.188, 0.49)
stashMap:addStamp(nil, "Stash_RiversideStashMap6_Text11", 6122, 5503, 0.156, 0.188, 0.49)
stashMap:addStamp(nil, "Stash_RiversideStashMap6_Text12", 6123, 5527, 0.156, 0.188, 0.49)
stashMap.spawnTable = "GunCache1"
stashMap:addContainer("GunBox", "floors_interior_tilesandwood_01_62", nil, "livingroom", nil, nil, nil)

-- survivor house
local stashMap = StashUtil.newStash("RiversideStashMap7", "Map", "Base.RiversideMap", "Stash_AnnotedMap")
stashMap.buildingX = 6629
stashMap.buildingY = 5330
stashMap:addStamp("Circle", nil, 6629, 5329, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_RiversideStashMap7_Text1", 6581, 5300, 0.129,0.129,0.129)
stashMap:addStamp("X", nil, 6507, 5348, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_RiversideStashMap7_Text2", 6447, 5363, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_RiversideStashMap7_Text21", 6447, 5387, 0.129,0.129,0.129)
stashMap.barricades = 80
stashMap.spawnTable = "SurvivorCache1"

-- food cache
local stashMap = StashUtil.newStash("RiversideStashMap8", "Map", "Base.RiversideMap", "Stash_AnnotedMap")
stashMap.buildingX = 6502
stashMap.buildingY = 5584
stashMap:addStamp("Apple", nil, 6502, 5584, 0.156, 0.188, 0.49)
stashMap:addStamp(nil, "Stash_RiversideStashMap8_Text1", 6517, 5558, 0.156, 0.188, 0.49)
stashMap:addStamp(nil, "Stash_RiversideStashMap8_Text11", 6517, 5582, 0.156, 0.188, 0.49)
stashMap:addStamp(nil, "Stash_RiversideStashMap8_Text2", 6690, 5524, 0.156, 0.188, 0.49)
stashMap:addStamp("Circle", nil, 6683, 5512, 0.156, 0.188, 0.49)
stashMap:addStamp(nil, "Stash_RiversideStashMap8_Text3", 6690, 5512, 0.156, 0.188, 0.49)
stashMap.spawnTable = "FoodCache1"
stashMap:addContainer("FoodBox", "carpentry_01_16", nil, nil, 6500, 5584, 0)

-- survivor house
local stashMap = StashUtil.newStash("RiversideStashMap9", "Map", "Base.RiversideMap", "Stash_AnnotedMap")
stashMap.buildingX = 6057
stashMap.buildingY = 5347
stashMap:addStamp("Asterisk", nil, 6057, 5348, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_RiversideStashMap9_Text1", 6065, 5338, 0.129,0.129,0.129)
stashMap:addStamp("Circle", nil, 6061, 5304, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_RiversideStashMap9_Text2", 6071, 5292, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_RiversideStashMap9_Text3", 6051, 5382, 0.129,0.129,0.129)
stashMap.barricades = 80
stashMap.spawnTable = "SurvivorCache1"

-- location info
local stashMap = StashUtil.newStash("RiversideStashMap10", "Map", "Base.RiversideMap", "Stash_AnnotedMap")
stashMap.buildingX = 6495
stashMap.buildingY = 5265
stashMap:addStamp("KnifeFork", nil, 6495, 5264, 0.129,0.129,0.129)
stashMap:addStamp("Pill", nil, 6473, 5265, 0.129,0.129,0.129)
stashMap:addStamp("ArrowSouth", nil, 6510, 5285, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_RiversideStashMap10_Text1", 6495, 5292, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_RiversideStashMap10_Text21", 6493, 5316, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_RiversideStashMap10_Text3", 6494, 5340, 0.129,0.129,0.129)

