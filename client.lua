seatbelttoggle = false
antiSpam = false
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
            local rpmMat = math.ceil(rpm * 10000 - 2001, 2) / 80
            local engineHp = GetVehicleEngineHealth(veh)
            local handbrake = GetVehicleHandbrake(veh)
            local _, lightsOne, lightsTwo = GetVehicleLightsState(veh)
            local lightsState
        
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
                seatbeltLevel = seatbelttoggle;
                lightsLevel = lightsState;
            })
        else
            SendNUIMessage({
                process = 'hide';
            })
        end
	end
end)

RegisterKeyMapping('seatbelt', 'Seat Belt', 'keyboard', 'K')

RegisterCommand('seatbelt', function()
    local ply = PlayerPedId()
    local veh = GetVehiclePedIsIn(player, false)
    local vehicleCategories = GetVehicleClass(veh)
    if IsPedInAnyVehicle(ply) then
        if antiSpam == false then
            if vehicleCategories ~= 13 and vehicleCategories ~= 8 then
                seatbelttoggle = not seatbelttoggle
                if seatbelttoggle == true then
                    antiSpam = true
                    Wait(2000)
                    antiSpam = false
                    SetFlyThroughWindscreenParams(10000.0, 10000.0, 17.0, 500.0);
                    while seatbelttoggle do
                        DisableControlAction(0,75)
                        Citizen.Wait(5)
                    end
                else
                    SetFlyThroughWindscreenParams(16.0, 19.0, 17.0, 2000.0)
                    SetPedConfigFlag(PlayerPedId(), 32, true)
                    seatbelttoggle = false
                    antiSpam = true
                    Wait(2000)
                    antiSpam = false
                end
            end
        end
    end
end, false)
