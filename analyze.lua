box.cfg{listen = 3301}
local space = box.schema.space.create('userlog', {if_not_exists=true})

function get_min_tick(day)
    return space.index.primary:min{day}['TickTime']
end

function get_max_tick(day)
    return space.index.primary:max{day}['TickTime']
end

print('Day', 'min TickTime', 'max TickTime', 'median Speed')
for day=1,7 do
    print(day, get_min_tick(day), get_max_tick(day))
end
