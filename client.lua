ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local coords = {x = -1470.0, y = -2815.0, z = 13.5}
local Cars = {}

RegisterCommand('colors', function()
    for i = 1, 255/4 do
        ESX.Game.SpawnVehicle('blista', vector3(coords.x, coords.y+i*2, coords.z), 100.0, function(vehicle)
            SetVehicleExtraColours(vehcicle, 0, 0)
            local rnd = math.random(1, 255)
            SetVehicleCustomPrimaryColour(vehicle, 255, 255-(rnd), 255-(rnd))
            Cars[i] = {veh = vehicle, rnd = rnd}
            Citizen.Wait(50)
            ExplodeVehicle(vehicle, true, false)
        end)
        Citizen.Wait(10)
    end
end, false)

RegisterCommand('sort', function()
    bubbleSort(Cars)
end, false)

function bubbleSort(array)
    local n = #array
    local swapped = false
    repeat
        swapped = false
        for i=2,n do
            if array[i-1].rnd > array[i].rnd then
                array[i-1],array[i] = array[i],array[i-1]
                swapped = true

                local a, b = i, i-1
                local coordsA, coordsB = GetEntityCoords(Cars[a].veh), GetEntityCoords(Cars[b].veh)
                SetEntityCoords(Cars[a].veh, coordsB)
                SetEntityCoords(Cars[b].veh, coordsA)
                
            end
            Citizen.Wait(3)
        end
    until not swapped
end
