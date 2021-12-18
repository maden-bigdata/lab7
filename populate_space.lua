
-- space:insert{nil, 1, 84857.03922542007, 6657230.2275387915}

local mqtt = require('mqtt')
local json = require('json')

local mqtt_topic = 'v5'
local mqtt_connect_data = {host='194.67.112.161', port=1883}
local mqtt_user = 'Hans'
local mqtt_password = 'Test'

function init_space()
    box.cfg{listen = 3301}
    local space = box.schema.space.create('userlog', {if_not_exists=true})
    space:format({
        { name = 'Day', type = 'number'},
        { name = 'TickTime', type = 'number' },
        { name = 'Speed', type = 'number' }
    })
    -- sort by TickTime
    space:create_index('primary', { parts={'Day','TickTime','Speed'}, if_not_exists=true})
    -- sort by Speed
    space:create_index('speed', {parts={'Day', 'Speed', 'TickTime'}, if_not_exists=true})
    print('Created space')
    return space
end

function init_mqtt()
    connection = mqtt.new('madenisova_lab7', true)
    connection:login_set(mqtt_user, mqtt_password)
    connection:connect(mqtt_connect_data)
    print('Connected to MQTT broker')
    connection:on_message(function (message_id, topic, payload, gos, retain)
        print('New message', message_id, topic, payload, gos, retain)
        put_data_to_space(parse_mqtt_payload(payload))
    end)
    connection:subscribe(mqtt_topic, 1)
    print('Subscribed to', mqtt_topic)
end

function parse_mqtt_payload(payload)
    decoded = json.decode(payload)
    return {decoded["Day"], decoded["TickTime"], decoded["Speed"]}
end

function put_data_to_space(data)
    space:insert(data)
end


space = init_space()
init_mqtt()
