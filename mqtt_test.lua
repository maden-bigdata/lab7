#!/usr/bin/env tarantool

local mqtt = require('mqtt')

connection = mqtt.new('maden_lab7', true)
connection:login_set('Hans', 'Test')
connection:connect({host='194.67.112.161', port=1883})

connection:on_message(function (message_id, topic, payload, gos, retain)
    print('New message', message_id, topic, payload, gos, retain)
  end)

connection:subscribe('v5')
