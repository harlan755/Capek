--// WEBHOOK RESMI - CRAFT A WORLD [BETA]
-- LOCALSCRIPT DI StarterPlayerScripts ATAU StarterGui

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local StatsService = game:GetService("Stats")

-- Tunggu pemain lokal dimuat
local player = Players.LocalPlayer
while not player do
    Players.PlayerAdded:Wait()
    player = Players.LocalPlayer
end

-- GANTI DENGAN WEBHOOK URL KAMU
local WEBHOOK_URL = "https://discord.com/api/webhooks/1476004191058264168/ZwalmFfACOQntKSceu4nqnu7lR7JH-BKRVVp1C4sXvU6yLbx6AKp2g-XzI5ELRsxklfz"

-- Cegah script berjalan lebih dari sekali
if player:FindFirstChild("ScriptAlreadyRan") then return end
local flag = Instance.new("BoolValue")
flag.Name = "ScriptAlreadyRan"
flag.Parent = player

-- Fungsi ambil data Gems
local function getPlayerGems()
    local gemsValue = nil
    
    -- Cari di leaderstats
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        gemsValue = leaderstats:FindFirstChild("Gems") or leaderstats:FindFirstChild("Gem")
    end
    
    -- Cari di PlayerData
    if not gemsValue then
        local playerData = player:FindFirstChild("PlayerData") or player:FindFirstChild("Data")
        if playerData then
            gemsValue = playerData:FindFirstChild("Gems") or playerData:FindFirstChild("Gem")
        end
    end
    
    if gemsValue and (gemsValue:IsA("IntValue") or gemsValue:IsA("NumberValue")) then
        return gemsValue.Value
    else
        return "Data tidak ditemukan"
    end
end

-- Fungsi ambil data pemain
local function getPlayerData()
    local data = {}
    
    data.playerName = player.Name
    data.displayName = player.DisplayName
    data.userId = player.UserId
    data.jobId = game.JobId ~= "" and game.JobId or "Tidak ada Job ID"
    data.placeId = game.PlaceId
    
    -- Ambil ping
    local pingValue = StatsService.Network:FindFirstChild("ServerStatsItem") and StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()
    data.ping = pingValue and math.floor(pingValue) or "Tidak dapat diukur"
    
    -- Ganti status dengan yang valid: jika pemain ada di dalam game berarti aktif
    data.playerStatus = "Aktif di dalam game"
    
    data.gems = getPlayerGems()
    
    -- Waktu eksekusi WIB
    local executeTime = os.date("%d/%m/%Y %H:%M:%S", os.time() + 25200)
    data.executeTime = executeTime
    
    return data
end

-- Fungsi kirim ke webhook
local function sendToWebhook()
    if WEBHOOK_URL == "ISI_WEBHOOK_KAMU_DISINI" then
        warn("URL webhook belum diatur!")
        return
    end
    
    local playerData = getPlayerData()
    
    local content = string.format([[
- <a:stat:1449444004801286268> `Status : Data Diperbarui`
- <:Bot:1283696244165836812> `Player Name : %s`
- <a:checkm:1181101683082797076> `Display Name : %s`
- <:stable_ping:1408556059496546384> `Player Ping : %sms`
- <:gems:1465657925770154086> `Jumlah Gems : %s`
- <:treegt:1174568853091659827> `User ID : %s`
- <a:online:1234567890> `Status Pemain : %s`
- <:Bot:1283696244165836812> `Waktu Pembaruan (WIB) : %s`
]], 
playerData.playerName,
playerData.displayName,
playerData.ping,
playerData.gems,
playerData.userId,
playerData.playerStatus,
playerData.executeTime
)
    
    local payload = {
        content = content,
        username = "Craft a World [Beta] - Sistem Pembaruan Data"
    }
    
    local success, err = pcall(function()
        HttpService:PostAsync(
            WEBHOOK_URL,
            HttpService:JSONEncode(payload),
            Enum.HttpContentType.ApplicationJson
        )
        print("Data berhasil dikirim pada:", playerData.executeTime)
    end)
    
    if not success then
        warn("Gagal mengirim data:", err)
    end
end

-- Jalankan pertama kali saat script dimulai
sendToWebhook()

-- Atur pengulangan setiap 20 detik
while true do
    task.wait(20)
    sendToWebhook()
end
