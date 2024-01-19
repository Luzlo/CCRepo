local dfpwm = require("cc.audio.dfpwm")
local modem = peripheral.find("modem")
local speaker = peripheral.find("speaker")

local URL = "http://82.212.142.228/music/"

local chunkSize = 16

local lines = {}
local songLineIndex = 1
local songPlaying = ""


local function fetchSongs()
    lines = {} --Reset the table
    local list, err = http.get(URL .. "list.txt") --Download song list from server
    while true do --Check each line in list
        local line = list.readLine() --Get line
        if not line then break end --Stop at the end of the list
        table.insert(lines, line) --Store song in the "lines" table
    end
end

local function playSong(song)
    if song ~= nil then
        local music = http.get("http://82.212.142.228/music/" .. song .. ".dfpwm", nil, true).readAll()
        local decoder = dfpwm.make_decoder()

        songPlaying = song

        for i=1, string.len(music) / chunkSize*1024, 1 do
            local buffer = decoder(string.sub(music, (i-1)*chunkSize*1024+1, i*chunkSize*1024))
            speaker.playAudio(buffer, 100)
            modem.transmit(333, 334, buffer)
            os.pullEvent('speaker_audio_empty')
        end

        --decoder({table.unpack(musicD, (i-1)*16*1024+1, i*16*1024)})  #Old Method#
    end
end

playSong("Antoine_Daniel-Fanta")