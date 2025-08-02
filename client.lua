local ESX, QBCore, PlayerData = nil, nil, nil
local lib = exports.ox_lib

if Config.Framework.name == "esx_gammel" then
    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(0)
        end
        PlayerData = ESX.GetPlayerData()
    end)

    RegisterNetEvent('esx:playerLoaded', function(xPlayer)
        PlayerData = xPlayer
    end)

    RegisterNetEvent('esx:setJob', function(job)
        if PlayerData then
            PlayerData.job = job
        end
    end)
elseif Config.Framework.name == "esx_ny" then
    ESX = exports['es_extended']:getSharedObject()
    PlayerData = ESX.GetPlayerData()

    RegisterNetEvent('esx:setJob', function(job)
        PlayerData.job = job
    end)

    RegisterNetEvent('esx:playerLoaded', function(xPlayer)
        PlayerData = xPlayer
    end)
elseif Config.Framework.name == "qb" or Config.Framework.name == "qbox" then
    QBCore = exports['qb-core']:GetCoreObject()
    PlayerData = QBCore.Functions.GetPlayerData()

    RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
        PlayerData.job = job
    end)

    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function(player)
        PlayerData = player
    end)
end

local function GetPlayerJob()
    if Config.Framework.name == "esx_gammel" or Config.Framework.name == "esx_ny" then
        PlayerData = PlayerData or (ESX and ESX.GetPlayerData() or nil)
        return PlayerData and PlayerData.job and PlayerData.job.name or nil
    elseif Config.Framework.name == "qb" or Config.Framework.name == "qbox" then
        PlayerData = PlayerData or (QBCore and QBCore.Functions.GetPlayerData() or nil)
        return PlayerData and PlayerData.job and PlayerData.job.name or nil
    end
    return nil
end

local function openMainMenu()
    lib:registerContext({
        id = 'fynix_main_craft',
        title = 'Vælg kategori',
        options = {
            {
                title = 'Våben',
                onSelect = function()
                    TriggerEvent('fynix_crafting:openCategory', 'vaaben')
                end
            },
            {
                title = 'Tilbehør',
                onSelect = function()
                    TriggerEvent('fynix_crafting:openCategory', 'tilbehoer')
                end
            }
        }
    })

    lib:showContext('fynix_main_craft')
end

local function openCraftingMenu(category)
    local menuId = 'fynix_' .. category
    local options = {}

    table.insert(options, {
        title = 'Tilbage',
        onSelect = function()
            openMainMenu()
        end
    })

    for _, item in pairs(Config.Crafting[category]) do
        table.insert(options, {
            title = item.navn,
            onSelect = function()
                TriggerServerEvent('fynix_crafting:attemptCraft', category, item.item)
            end
        })
    end

    lib:registerContext({
        id = menuId,
        title = category == "vaaben" and "Våben" or "Tilbehør",
        options = options
    })

    Wait(100)
    lib:showContext(menuId)
end

RegisterNetEvent('fynix_crafting:openCategory', function(category)
    openCraftingMenu(category)
end)

CreateThread(function()
    RequestModel(Config.Ped.model)
    while not HasModelLoaded(Config.Ped.model) do Wait(0) end

    local ped = CreatePed(0, Config.Ped.model, Config.Ped.position.x, Config.Ped.position.y, Config.Ped.position.z - 1.0, Config.Ped.position.w, false, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)

    exports.ox_target:addLocalEntity(ped, {
        {
            label = 'Crafting',
            icon = 'fa-solid fa-wrench',
onSelect = function()
    if Config.Adgang.kunBestemteJobs then
        local job = GetPlayerJob()
        local tilladt = false
        for _, allowedJob in pairs(Config.Adgang.tilladteJobs) do
            if job == allowedJob then
                tilladt = true
                break
            end
        end

        if not tilladt then
            lib:notify({
                description = 'Du har ikke adgang til denne crafting station.',
                type = 'error'
            })
            return
        end
    end
    openMainMenu()
end
        }
    })
end)

RegisterNetEvent('fynix_crafting:startCraft', function(category, itemConfig)
    local success = lib:progressCircle({
        duration = 10000,
        label = 'Crafte ' .. itemConfig.navn .. '...',
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = false,
            car = true,
            combat = true
        }
    })

    if success then
        TriggerServerEvent('fynix_crafting:completeCraft', category, itemConfig.item)
    end
end)
