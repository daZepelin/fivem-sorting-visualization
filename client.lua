ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local coords = {x = -1470.0, y = -2815.0, z = 13.5}
local Cars = {}


-- Citizen.CreateThread(function()
--     for i = 1, 159 do

--     end
-- end)

RegisterCommand('colors', function()
    -- local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    for i = 1, 255/4 do
        ESX.Game.SpawnVehicle('blista', vector3(coords.x, coords.y+i*2, coords.z), 100.0, function(vehicle)
            SetVehicleExtraColours(vehcicle, 0, 0)
            -- ESX.Game.SetVehicleProperties(vehicle, {pearlescentColor = 0})
            local rnd = math.random(1, 255)
            print(rnd)
            SetVehicleCustomPrimaryColour(vehicle, 255, 255-(rnd), 255-(rnd))
            Cars[i] = {veh = vehicle, rnd = rnd}
            Citizen.Wait(50)
            ExplodeVehicle(vehicle, true, false)
            -- SetVehicleCustomSecondaryColour(vehicle, i, 0, 0)
        end)
        Citizen.Wait(10)
    end
    -- Citizen.CreateThread(function() --Rainbow Vehicle Trailer
    --     while true do
    --         Citizen.Wait(0)
    --         local rgb = RGBRainbow(2.0)
    --         if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
    --             SetVehicleCustomPrimaryColour(veh, rgb.r, rgb.g, rgb.b)
    --             SetVehicleCustomSecondaryColour(veh, rgb.r, rgb.g, rgb.b)
    --         end
    --     end
    -- end)
end, false)

RegisterCommand('swap', function(source, args)
    local a, b = tonumber(args[1]), tonumber(args[1])+1
    local coordsA, coordsB = GetEntityCoords(Cars[a].veh), GetEntityCoords(Cars[b].veh)
    SetEntityCoords(Cars[a].veh, coordsB)
    SetEntityCoords(Cars[b].veh, coordsA)
end, false)

function RGBRainbow(frequency) --Rainbow Function (Thanks To ash [forum.FiveM.net])
    local result = {}

    result.r = math.floor(math.sin((GetGameTimer() / 1000) * frequency + 0) * 127 + 128)
    result.g = math.floor(math.sin((GetGameTimer() / 1000) * frequency + 2) * 127 + 128)
    result.b = math.floor(math.sin((GetGameTimer() / 1000) * frequency + 4) * 127 + 128)

    print(result.r, result.g, result.b)
    return result
end

RegisterCommand('sort', function()
    bubbleSort(Cars)
end, false)

RegisterCommand('mergesort', function()
    mergeSort(Cars, 1, #Cars)
    print(json.encode(Cars))
end, false)

function bubbleSort(array)
    local n = #array
    local swapped = false
    repeat
        swapped = false
        for i=2,n do   -- 0 based is for i=1,n-1 do
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
    print('Players sorted by combo')
end

RegisterCommand('boom', function()
    AddExplosion(coords.x, coords.y, coords.z, 'EXPLOSION_GRENADE', 100, true, false, 1)
    for i = 1, #Cars do
        print(Cars[i].veh)
        ExplodeVehicle(Cars[i].veh, false, false)
        SetVehicleEngineHealth(Cars[i].veh, 0)
        SetVehiclePetrolTankHealth(Cars[i].veh, 0)
    end
end, false)

function mergeSort(A, p, r)
    print(r)
    print('mergeSort')
	if p < r then
        local q = math.floor((p + r)/2)
        print(q)
		mergeSort(A, p, q)
		mergeSort(A, q+1, r)
		merge(A, p, q, r)
	end
end

-- merge an array split from p-q, q-r
function merge(A, p, q, r)
	local n1 = q-p+1
	local n2 = r-q
	local left = {}
	local right = {}
	-- print(n1, n2)
	for i=1, n1 do
		left[i] = A[p+i-1]
	end
	for i=1, n2 do
        right[i] = A[q+i]
	end
     
	left[n1+1] = {}
	right[n2+1] = {}
	left[n1+1].rnd = 1000
	right[n2+1].rnd = 1000
	
	local i=1
	local j=1
	
    for k=p, r do
        print(json.encode(left[i]), json.encode(right[j]))
		if left[i].rnd <= right[j].rnd then
            A[k] = left[i]
            -- local a, b = k, i
            swap(k, i)
            -- local coordsA, coordsB = GetEntityCoords(Cars[a].veh), GetEntityCoords(Cars[b].veh)
            -- Citizen.CreateThread(function()
            --     for i = 1, 10 do
            --         Citizen.Wait(1)
            --         DrawText3D(vector3(coordsA.x, coordsA.y, coordsA.z+2.0), '\\/', 5.0, 1, 'green')
            --         DrawText3D(vector3(coordsB.x, coordsB.y, coordsB.z+2.0), '\\/', 5.0, 1, 'red')
            --     end
            -- end)
            -- SetEntityCoords(Cars[a].veh, coordsB)
            -- SetEntityCoords(Cars[b].veh, coordsA)
			i=i+1
		else
            A[k] = right[j]
            -- local a, b = k, j
            swap(k,j)
            -- local coordsA, coordsB = GetEntityCoords(Cars[a].veh), GetEntityCoords(Cars[b].veh)
            -- Citizen.CreateThread(function()
            --     for i = 1, 10 do
            --         Citizen.Wait(1)
            --         DrawText3D(vector3(coordsA.x, coordsA.y, coordsA.z+2.0), '\\/', 5.0, 1, 'green')
            --         DrawText3D(vector3(coordsB.x, coordsB.y, coordsB.z+2.0), '\\/', 5.0, 1, 'red')
            --     end
            -- end)
            -- SetEntityCoords(Cars[a].veh, coordsB)
            -- SetEntityCoords(Cars[b].veh, coordsA)
			j=j+1
        end
        Citizen.Wait(100)
	end
end

function swap(a, b)
    local coordsA, coordsB = GetEntityCoords(Cars[a].veh), GetEntityCoords(Cars[b].veh)
            Citizen.CreateThread(function()
                for i = 1, 10 do
                    Citizen.Wait(1)
                    DrawText3D(vector3(coordsA.x, coordsA.y, coordsA.z+2.0), '\\/', 5.0, 1, 'green')
                    DrawText3D(vector3(coordsB.x, coordsB.y, coordsB.z+2.0), '\\/', 5.0, 1, 'red')
                end
            end)
            SetEntityCoords(Cars[a].veh, coordsB)
            SetEntityCoords(Cars[b].veh, coordsA)
end

DrawText3D = function(coords, text, size, font, color)
	coords = vector3(coords.x, coords.y, coords.z)

	local camCoords = GetGameplayCamCoords()
	local distance = #(coords - camCoords)

	if not size then size = 1 end
	if not font then font = 0 end

	local scale = (size / distance) * 2
	local fov = (1 / GetGameplayCamFov()) * 100
	scale = scale * fov

	SetTextScale(0.0 * scale, 0.55 * scale)
    SetTextFont(fontId)
    if color == 'green' then
        SetTextColour(0, 255, 0, 255)
    elseif color == 'red' then
        SetTextColour(255, 0, 0, 255)
    else
        SetTextColour(255, 255, 255, 255)
    end
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)

	SetDrawOrigin(coords, 0)
	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.0, 0.0)
	ClearDrawOrigin()
end