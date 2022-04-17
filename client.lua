local seatbeltToggle = false
local antiSpam = false

local function convertToPercentage(value)
    return math.ceil(value * 10000 - 2001) / 80
end

local function Normalize(value, min, max)
    return (value - min) / (max - min)
end

local function GetVehicleTurboPressureNormalized(vehicle)
    local hasTurbo =  IsToggleModOn(vehicle,18)
    if not hasTurbo then return false end
    local normalizedTurboPressure = Normalize(GetVehicleTurboPressure(vehicle), -1, 1)
    return convertToPercentage(normalizedTurboPressure)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(70)
        local ply = PlayerPedId()
        if IsPauseMenuActive() then
            SendNUIMessage({
                process = 'hide';
            })
		elseif IsPedInAnyVehicle(ply) then
            local veh = GetVehiclePedIsUsing(ply)
            local fuel = GetVehicleFuelLevel(veh)
            local gear = GetVehicleCurrentGear(veh)
            local speedo = (GetEntitySpeed(veh)*3.6) --mph *2.236936
            local rpm = GetVehicleCurrentRpm(veh)
            local rpmMat = convertToPercentage(rpm)
            local turboPressure = GetVehicleTurboPressureNormalized(veh)
            local engineHp = GetVehicleEngineHealth(veh)
            local handbrake = GetVehicleHandbrake(veh)
            local _, lightsOne, lightsTwo = GetVehicleLightsState(veh)
            local lightsState
            local indicatorsState = GetVehicleIndicatorLights(veh)
            if indicatorsState == 0 then
                indicatorsState = 'off'
            elseif indicatorsState == 1 then
                indicatorsState = 'left'
            elseif indicatorsState == 2 then
                indicatorsState = 'right'
            elseif indicatorsState == 3 then
                indicatorsState = 'both'
            end
            if (lightsOne == 1 and lightsTwo == 0) then
                lightsState = 1;
            elseif (lightsOne == 1 and lightsTwo == 1) or (lightsOne == 0 and lightsTwo == 1) then
                lightsState = 2;
            else
                lightsState = 0;
            end

            SendNUIMessage({
                process = 'show';
                fuelLevel = fuel;
                gearLevel = gear;
                speedLevel = speedo;
                rpmLevel = rpmMat;
                engineLevel = engineHp;
                handbrakeLevel = handbrake;
                seatbeltLevel = seatbeltToggle;
                lightsLevel = lightsState;
                indicatorsState = indicatorsState;
                turboPressureLevel = turboPressure;
            })
        else
            SendNUIMessage({
                process = 'hide';
            })
        end
	end
end)


RegisterKeyMapping('leftIndicator', 'Vehicle left indicator', 'keyboard', 'LEFT')
RegisterKeyMapping('rightIndicator', 'Vehicle right indicator', 'keyboard', 'RIGHT')
RegisterKeyMapping('bothIndicators', 'Vehicle both indicators', 'keyboard', 'UP')

RegisterCommand('leftIndicator', function()
    if not IsPedInAnyVehicle(PlayerPedId()) then return end
    TriggerServerEvent('cs-carhud:syncIndicators', VehToNet(GetVehiclePedIsUsing(PlayerPedId())), 1)
end)

RegisterCommand('rightIndicator', function()
    if not IsPedInAnyVehicle(PlayerPedId()) then return end
    TriggerServerEvent('cs-carhud:syncIndicators', VehToNet(GetVehiclePedIsUsing(PlayerPedId())), 2)
end)

RegisterCommand('bothIndicators', function()
    if not IsPedInAnyVehicle(PlayerPedId()) then return end
    TriggerServerEvent('cs-carhud:syncIndicators', VehToNet(GetVehiclePedIsUsing(PlayerPedId())), 3)
end)

RegisterNetEvent("cs-carhud:syncIndicators", function(vehNetId, indicatorState)
    if not NetworkDoesEntityExistWithNetworkId(vehNetId) then return end
        local vehicle = NetToVeh(vehNetId)
        SetVehicleIndicators(vehicle, indicatorState)
end)

function SetVehicleIndicators(vehicle, indicator)
    local currentIndicator = GetVehicleIndicatorLights(vehicle)
    if currentIndicator == indicator then
        SetVehicleIndicatorLights(vehicle, 0, false)
        SetVehicleIndicatorLights(vehicle, 1, false)
        return
    end
    if vehicle and vehicle ~= 0 and vehicle ~= nil then
        local class = GetVehicleClass(vehicle)
        if class ~= 15 and class ~= 16 and class ~= 14 then
            if indicator == 1 then
                SetVehicleIndicatorLights(vehicle, 0, false)
                SetVehicleIndicatorLights(vehicle, 1, true)
            elseif indicator == 2 then
                SetVehicleIndicatorLights(vehicle, 0, true)
                SetVehicleIndicatorLights(vehicle, 1, false)
            elseif indicator == 3 then
                SetVehicleIndicatorLights(vehicle, 0, true)
                SetVehicleIndicatorLights(vehicle, 1, true)
            end
        end
    end
end

RegisterKeyMapping('seatbelt', 'Seat Belt', 'keyboard', 'K')

RegisterCommand('seatbelt', function()
    local ply = PlayerPedId()
    local veh = GetVehiclePedIsIn(player, false)
    local vehicleCategories = GetVehicleClass(veh)
    if IsPedInAnyVehicle(ply) then
        if antiSpam == false then
            if vehicleCategories ~= 13 and vehicleCategories ~= 8 then
                seatbeltToggle = not seatbeltToggle
                if seatbeltToggle == true then
                    antiSpam = true
                    Wait(2000)
                    antiSpam = false
                    SetFlyThroughWindscreenParams(10000.0, 10000.0, 17.0, 500.0);
                    while seatbeltToggle do
                        DisableControlAction(0,75)
                        Citizen.Wait(5)
                    end
                else
                    SetFlyThroughWindscreenParams(16.0, 19.0, 17.0, 2000.0)
                    SetPedConfigFlag(PlayerPedId(), 32, true)
                    seatbeltToggle = false
                    antiSpam = true
                    Wait(2000)
                    antiSpam = false
                end
            end
        end
    end
end, false)
