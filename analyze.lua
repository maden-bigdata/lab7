box.cfg{listen = 3301}
local space = box.schema.space.create('userlog', {if_not_exists=true})

function get_min_tick(day)
    return space.index.primary:min{day}['TickTime']
end

function get_max_tick(day)
    return space.index.primary:max{day}['TickTime']
end

function get_median_speed(day)
    local rows_count = space.index.speed:count{day}
    local rows_even = math.fmod(rows_count, 2)
    if (rows_even) then
        -- count mean of middle values
        local speed_vals = space.index.speed:select({day}, {limit=2, offset=math.floor(rows_count/2)})
        return (speed_vals[1]['Speed'] + speed_vals[2]['Speed'])/2
    else
        --return middle value
        return space.index.speed:select({day}, {limit=1, offset=rows_count})[1]['Speed']
    end
end


print('Day', 'min TickTime', 'max TickTime', 'median Speed')
for day=1,7 do
    print(day, get_min_tick(day), '\t', get_max_tick(day), '\t',get_median_speed(day))
end
