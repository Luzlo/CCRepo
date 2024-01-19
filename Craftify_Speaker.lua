local modem = peripheral.find("modem")
local speaker = peripheral.find("speaker")

modem.open(333)

while true do
    local event, side, channel, replyChannel, message, distance
    repeat
        event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    until channel == 333

    speaker.play(message, 100)
end