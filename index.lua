--// WEBHOOK RESMI - CRAFT A WORLD [BETA]
-- HANYA DIGUNAKAN DENGAN IZIN PEMBUAT PERMAINAN DAN SESUAI KETENTUAN ROBLOX

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local StatsService = game:GetService("Stats")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
assert(player, "Script hanya dapat dijalankan pada pemain lokal yang valid")

-- GANTI DENGAN WEBHOOK RESMI YANG TERDAFTAR
local WEBHOOK_URL = "https://discord.com/api/webhooks/1476004191058264168/ZwalmFfACOQntKSceu4nqnu7lR7JH-BKRVVp1C4sXvU6yLbx6AKp2g-XzI5ELRsxklfz"
assert(WEBHOOK_URL ~= ("https://discord.com/api/webhooks/1476004191058264168/ZwalmFfACOQntKSceu4nqnu7lR7JH-BKRVVp1C4sXvU6yLbx6AKp2g-XzI5ELRsxklfz")

-- Validasi lingkungan
local isAuthorizedEnvironment = RunService:IsStudio() or game.PlaceId == 71237783490251
assert(isAuthorizedEnvironment, "Script hanya dapat dijalankan pada lingkungan yang diizinkan")

-- Fungsi untuk mengambil data Gems dengan akurat
local function getPlayerGems()
    -- Cari sumber data Gems yang umum digunakan di permainan Roblox:
    local gemsValue = nil
    
    -- Opsi 1: Cek di Player leaderstats
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        gemsValue = leaderstats:FindFirstChild("Gems") or leaderstats:FindFirstChild("Gem")
    end
    
    -- Opsi 2: Cek di Player Data atau folder khusus permainan
    if not gemsValue then
        local playerData = player:FindFirstChild("PlayerData") or player:FindFirstChild("Data")
        if playerData then
            gemsValue = playerData:FindFirstChild("Gems") or playerData:FindFirstChild("Gem")
        end
    end
    
    -- Validasi tipe data
    if gemsValue and gemsValue:IsA("IntValue") or gemsValue:IsA("NumberValue") then
        return gemsValue.Value
    else
        return "Tidak dapat ditemukan"
    end
end

-- Fungsi untuk mengambil data pemain lengkap
local function getPlayerData()
    local data = {}
    
    -- Data dasar pemain
    data.playerName = player.Name
    data.displayName = player.DisplayName
    data.userId = player.UserId
    data.jobId = game.JobId ~= "" and game.JobId or "Tidak ada Job ID"
    data.placeId = game.PlaceId
    
    -- Ping akurat
    local pingValue = StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()
    data.ping = pingValue and math.floor(pingValue) or "Tidak dapat diukur"
    
    -- Status pemain
    data.playerStatus = player:IsOnline() and "Online" or "Offline"
    
    -- Jumlah Gems
    data.gems = getPlayerGems()
    
    -- Waktu eksekusi WIB
    local executeTime = os.date("%d/%m/%Y %H:%M:%S", os.time() + 3600*7)
    data.executeTime = executeTime
    
    return data
end

-- Format pesan
local playerData = getPlayerData()
local content = string.format([[
- <a:stat:1449444004801286268> `Status : Script Dijalankan Secara Resmi`
- <:Bot:1283696244165836812> `Player Name : %s`
- <a:checkm:1181101683082797076> `Display Name : %s`
- <:stable_ping:1408556059496546384> `Player Ping : %sms`
- <:gems:1465657925770154086> `Jumlah Gems : %s`
- <:treegt:1174568853091659827> `User ID : %s`
- <:black_mystery_block:1304140534255718442> `Job ID : %s`
- <:packcrate:1156971687062032394> `Place ID : %s`
- <:Bot:1283696244165836812> `Waktu Eksekusi (WIB) : %s`
]], 
playerData.playerName,
playerData.playerName,
playerData.ping,
playerData.gems,
playerData.userId,
playerData.jobId,
playerData.placeId,
playerData.executeTime
)

-- Kirim data dengan aman
local function sendToWebhook()
    local payload = {
        content = content,
        username = "Craft a World [Beta] - Sistem Data Resmi"
    }
    
    local success, err = pcall(function()
        local response = HttpService:PostAsync(
            WEBHOOK_URL,
            HttpService:JSONEncode(payload),
            Enum.HttpContentType.ApplicationJson
        )
        print("Data berhasil dikirim:", response)
    end)
    
    if not success then
        warn("Gagal mengirim data:", err)
    end
end

-- Jalankan proses
sendToWebhook()
