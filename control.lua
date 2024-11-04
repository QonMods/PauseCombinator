local SHORTCUT_NAME = 'pause-combinator-unpause'

script.on_init(function()
    global.EntityActivity = {}
    global.EntityListID = {}
    global.EntityListUN = {}
    global.entity_id_counter = 0

    global.last_pause_tick = 0
end)

--function to add entity to list
function EntityCreate(event)
    local entity = event.created_entity or event.entity
    if entity.name == "pause-combinator" then
        global.entity_id_counter = global.entity_id_counter + 1
        global.EntityListID[global.entity_id_counter] = {un = entity.unit_number, entity = entity}
        global.EntityListUN[entity.unit_number] = {id = global.entity_id_counter, entity = entity}
    end
end

--function to remove entity from list
function EntityRemove(event)
    local entity = event.created_entity or event.entity
    if entity.name == "pause-combinator" then
        local id = global.EntityListUN[entity.unit_number].id
        global.EntityListID[id] = nil
        global.EntityActivity[entity.unit_number] = nil
        global.EntityListUN[entity.unit_number] = nil
    end
end

--function that pings map for each "pause-combinator" entity
function runthrough()
    for k,entity in pairs(global.EntityListID) do
        entity = entity.entity
        --check validity of entity and remove it if it isn't valid
        if entity.valid == false then
            local un = global.EntityListID[k].un
            global.EntityListID[k] = nil
            global.EntityActivity[un] = nil
            global.EntityListUN[un] = nil
            goto skip
        end

        --set up info for entity
        entity.get_or_create_control_behavior()
        local netGreen = entity.get_circuit_network(defines.wire_type.green)
        local netRed   = entity.get_circuit_network(defines.wire_type.red)
        local netGreenP = 0
        local netRedP = 0
        if netGreen ~= nil then
            netGreenP = netGreen.get_signal({["type"] = "virtual", ["name"] = "signal-P"})
        end
        if netRed ~= nil then
            netRedP = netRed.get_signal({["type"] = "virtual", ["name"] = "signal-P"})
        end
        local p = netGreenP + netRedP
        if (p ~= 0 and game.tick ~= global.last_pause_tick) then
            game.print("Game paused at tick "..game.tick.." with pause combinator at [gps="..entity.position.x..","..entity.position.y.."]")
            game.tick_paused = true
            global.last_pause_tick = game.tick
        end
        ::skip::
    end
end

script.on_event(defines.events.on_built_entity, EntityCreate)
script.on_event(defines.events.on_robot_built_entity, EntityCreate)
script.on_event(defines.events.script_raised_revive, EntityCreate)

script.on_event(defines.events.on_pre_player_mined_item, EntityRemove)
script.on_event(defines.events.on_robot_pre_mined, EntityRemove)
script.on_event(defines.events.on_entity_died, EntityRemove)
script.on_event(defines.events.script_raised_destroy, EntityRemove)

script.on_event(defines.events.on_tick, runthrough)

script.on_event('pause-combinator-unpause', function(event)
    if event.input_name ~= SHORTCUT_NAME and event.prototype_name ~=  SHORTCUT_NAME then return end
    local player = game.players[event.player_index]
    game.tick_paused = false
    player.print('You are at: '..game.table_to_json(player.position))
end)