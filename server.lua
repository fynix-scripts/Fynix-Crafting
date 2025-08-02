local ESX, QBCore

CreateThread(function()
    if Config.Framework.name == "esx_ny" or Config.Framework.name == "esx_gammel" then
        ESX = exports['es_extended']:getSharedObject()
    elseif Config.Framework.name == "qb" or Config.Framework.name == "qbox" then
        QBCore = exports['qb-core']:GetCoreObject()
    end
end)

local function GetPlayerData(src)
    if Config.Framework.name == "esx_ny" or Config.Framework.name == "esx_gammel" then
        local xPlayer = ESX.GetPlayerFromId(src)
        if not xPlayer then return nil end
        return {
            job = xPlayer.job and xPlayer.job.name or nil,
            xPlayer = xPlayer
        }
    elseif Config.Framework.name == "qb" or Config.Framework.name == "qbox" then
        local Player = QBCore.Functions.GetPlayer(src)
        if not Player then return nil end
        return {
            job = Player.PlayerData.job and Player.PlayerData.job.name or nil,
            Player = Player
        }
    end
    return nil
end

local function HasItems(src, items)
    local playerData = GetPlayerData(src)
    if not playerData then return false end

    if Config.Framework.name == "esx_ny" or Config.Framework.name == "esx_gammel" then
        for _, mat in pairs(items) do
            local invItem = playerData.xPlayer.getInventoryItem(mat.item)
            if not invItem or invItem.count < mat.antal then
                return false
            end
        end
        return true
    elseif Config.Framework.name == "qb" or Config.Framework.name == "qbox" then
        for _, mat in pairs(items) do
            local count = playerData.Player.Functions.GetItemByName(mat.item)
            if not count or count.amount < mat.antal then
                return false
            end
        end
        return true
    end
    return false
end

local function RemoveItems(src, items)
    local playerData = GetPlayerData(src)
    if not playerData then return end

    if Config.Framework.name == "esx_ny" or Config.Framework.name == "esx_gammel" then
        for _, mat in pairs(items) do
            playerData.xPlayer.removeInventoryItem(mat.item, mat.antal)
        end
    elseif Config.Framework.name == "qb" or Config.Framework.name == "qbox" then
        for _, mat in pairs(items) do
            playerData.Player.Functions.RemoveItem(mat.item, mat.antal)
        end
    end
end

local function GiveItem(src, item, amount)
    local playerData = GetPlayerData(src)
    if not playerData then return end

    if Config.Framework.name == "esx_ny" or Config.Framework.name == "esx_gammel" then
        playerData.xPlayer.addInventoryItem(item, amount)
    elseif Config.Framework.name == "qb" or Config.Framework.name == "qbox" then
        playerData.Player.Functions.AddItem(item, amount)
    end
end

RegisterServerEvent('fynix_crafting:attemptCraft', function(category, itemName)
    local src = source
    local itemConfig

    for _, item in pairs(Config.Crafting[category]) do
        if item.item == itemName then
            itemConfig = item
            break
        end
    end
    if not itemConfig then return end

    if not HasItems(src, itemConfig.krav) then
        TriggerClientEvent('ox_lib:notify', src, {
            description = 'Du har ikke materialerne til at crafte dette!',
            type = 'error'
        })
        TriggerClientEvent('fynix_crafting:openCategory', src, category)
        return
    end

    TriggerClientEvent('fynix_crafting:startCraft', src, category, itemConfig)
end)

RegisterServerEvent('fynix_crafting:completeCraft', function(category, itemName)
    local src = source
    local itemConfig

    for _, item in pairs(Config.Crafting[category]) do
        if item.item == itemName then
            itemConfig = item
            break
        end
    end
    if not itemConfig then return end

    RemoveItems(src, itemConfig.krav)
    GiveItem(src, itemConfig.item, itemConfig.udbytte or 1)

    TriggerClientEvent('ox_lib:notify', src, {
        description = 'Du har lavet ' .. (itemConfig.udbytte or 1) .. 'x ' .. itemConfig.navn .. '!',
        type = 'success'
    })
end)

RegisterNetEvent('fynix_crafting:getJob', function()
    local src = source
    local playerData = GetPlayerData(src)
    if playerData then
        TriggerClientEvent('fynix_crafting:returnJob', src, playerData.job)
    else
        TriggerClientEvent('fynix_crafting:returnJob', src, nil)
    end
end)