
startPos = {} -- NONE! It starts at random, for someone random
player = PlayerPedId()
spawnedPeds = {}

Citizen.CreateThread(function() 
	AddRelationshipGroup("ENEMY")
	SetRelationshipBetweenGroups(5, GetHashKey("ENEMY"), GetHashKey("PLAYER"))
	SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("ENEMY"))
	while true do
		player = PlayerPedId()
		Wait(0)
		for i,ped in ipairs(spawnedPeds) do
			local blip = GetBlipFromEntity(ped)
			if blip then
				if IsPedDeadOrDying(ped, 1) then SetBlipAlpha(blip, 0) end
			end
		end
	end
end)

local function SetSubtitle(subtitle, duration)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(subtitle)
	DrawSubtitleTimed(duration, 1)
end

showHudAgain = false

function hudLoop()
	while true do
		Wait(0)
		HideHudAndRadarThisFrame()
		if showHudAgain then
			showHudAgain = false
			return
		end
	end
end

function StopShowingHud(time)
Citizen.CreateThread(function()
	Citizen.CreateThread(hudLoop)
	Wait(time or 5000)
	showHudAgain = true
end)
end

function CheckIfPedsHaveSurvivors(pedTable)
	for i,ped in ipairs(pedTable) do
		if not IsPedDeadOrDying(ped, 1) then
			return true
		end
	end
	return false
end

function MakePedEnemy(ped)
	local wep = GetHashKey("WEAPON_"..weps[math.random(1,#weps)])
	SetPedRelationshipGroupHash(ped, GetHashKey("ENEMY"))
	-- GiveWeaponToPed(ped, GetHashKey("WEAPON_"..weps[math.random(1,#weps)]), 9999, 0, true)
	GiveWeaponToPed(ped, wep, 9999, 0, true)
	-- TaskSetBlockingOfNonTemporaryEvents(ped, true)
	-- SetPedAsEnemy(ped, true)
	-- SetPedFleeAttributes(ped, 0, 0)
   	-- SetPedCombatAttributes(ped, 17, 1)
   	-- SetPedCombatAttributes(ped, 16, 1)
   	-- SetPedCombatAttributes(ped, 46, 1)
	SetPedCombatRange(ped, 1)
	SetPedCombatMovement(ped, 1)
	-- SetPedSeeingRange(ped, 20.0)
	-- SetPedHearingRange(ped, 5.0)
	-- TaskCombatPed(ped, player, 0, 16)
end

displayDoneMission = false

str = "Mission Passed"
local rt = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")

Citizen.CreateThread(function()
	while true do
		if displayDoneMission then
			StartScreenEffect("SuccessTrevor",  2500,  false)
			curMsg = "SHOW_MISSION_PASSED_MESSAGE"
			SetAudioFlag("AvoidMissionCompleteDelay", true)
			PlayMissionCompleteAudio("FRANKLIN_BIG_01")
			Citizen.Wait(3000)
			StopScreenEffect()
			curMsg = "TRANSITION_OUT"
			PushScaleformMovieFunction(rt, "TRANSITION_OUT")
			PopScaleformMovieFunction()
			Citizen.Wait(2000)
			displayDoneMission = false
		end

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()

	while true do
		Citizen.Wait(0)
		if(HasScaleformMovieLoaded(rt) and displayDoneMission)then
			HideHudComponentThisFrame(7)
			HideHudComponentThisFrame(8)
			HideHudComponentThisFrame(9)
			HideHudComponentThisFrame(6)
			HideHudComponentThisFrame(19)
			HideHudAndRadarThisFrame()

			if (curMsg == "SHOW_MISSION_PASSED_MESSAGE") then
			
			PushScaleformMovieFunction(rt, curMsg)
 
			BeginTextComponent("STRING")
			AddTextComponentString(str)
			EndTextComponent()
			BeginTextComponent("STRING")
			AddTextComponentString("Yea!")
			EndTextComponent()

			PushScaleformMovieFunctionParameterInt(145)
			PushScaleformMovieFunctionParameterBool(false)
			PushScaleformMovieFunctionParameterInt(1)
			PushScaleformMovieFunctionParameterBool(true)
			PushScaleformMovieFunctionParameterInt(69)

			PopScaleformMovieFunctionVoid()

			Citizen.InvokeNative(0x61bb1d9b3a95d802, 1)
			end
			
			DrawScaleformMovieFullscreen(rt, 255, 255, 255, 255)
		end
    end
end)

function MainScript() -- MAIN SCRIPT
	Wait(500)
	player = PlayerPedId()
	    
	SetNotificationTextEntry("THREESTRINGS")
	AddTextComponentString("You're new in this city? Great, that must mean you need a job or two. I've got something.")
	AddTextComponentString("Tasks will get updated on your phone as you go.")
	SetNotificationMessage("CHAR_LESTER", "CHAR_LESTER", true, 2, "Unknown", "Opportunity")
	
	Wait(5000)
	local carSpawn = vector3(135.45, -1050.35, 28.65)
	local carRot = 160.05
	
	local model = GetHashKey('COG55')
	RequestModel(model)
	while not HasModelLoaded(model) do Wait(0) end
	local car = CreateVehicle(model, carSpawn, carRot, true, true)
	
	SetSubtitle("Get the ~b~sabotage vehicle.", 5000)
	local carBlip = AddBlipForEntity(car)
	SetBlipColour(carBlip, 3)
	SetBlipRoute(carBlip, true)
	
	while not IsPedInVehicle(player, car, false) do
		Wait(1)
		if IsPedDeadOrDying(player, 1) then
			str = "~r~Mission Failed"
			displayDoneMission = true
			SetSubtitle("~r~YOU DIED", 5000)
			SetEntityAsNoLongerNeeded(car)
			RemoveBlip(carBlip)
			Wait (1000)
			return
		elseif IsEntityDead(car) then
			str = "~r~Mission Failed"
			displayDoneMission = true
			SetSubtitle("~r~THE VEHICLE WAS DESTROYED", 5000)
			SetEntityAsNoLongerNeeded(car)
			RemoveBlip(carBlip)
			Wait (1000)
			return
		end
	end
	
	RemoveBlip(carBlip)
	SetSubtitle("Drive to ~y~Bahama Mamas ~w~and wait for the ~r~target.", 5000)
	
	areaBlip = AddBlipForCoord(-1389.35, -585.3, 30.2)
	SetBlipColour(areaBlip, 5)
	SetBlipRoute(areaBlip, true)
	SetBlipRouteColour(areaBlip, 5)
	
	model = 815693290
	RequestModel(model)
	while not HasModelLoaded(model) do Wait(0) end
	
	while GetDistanceBetweenCoords(-1389.35, -585.3, 30.2, GetEntityCoords(player)) > 100.0 do
		Wait(1)
		if IsPedDeadOrDying(player, 1) then
			str = "~r~Mission Failed"
			displayDoneMission = true
			SetSubtitle("~r~YOU DIED", 5000)
			SetEntityAsNoLongerNeeded(car)
			RemoveBlip(areaBlip)
			Wait (1000)
			return
		elseif IsEntityDead(car) then
			str = "~r~Mission Failed"
			displayDoneMission = true
			SetSubtitle("~r~THE VEHICLE WAS DESTROYED", 5000)
			SetEntityAsNoLongerNeeded(car)
			RemoveBlip(areaBlip)
			Wait (1000)
			return
		end
		if not IsPedInVehicle(player, car, false) then
			RemoveBlip(areaBlip)
			local carBlip = AddBlipForEntity(car)
			SetBlipColour(carBlip, 3)
			while not IsPedInVehicle(player, car, false) do
				Wait(1)
				SetSubtitle("Get back in the ~b~vehicle.", 2)
				if IsPedDeadOrDying(player, 1) then
					str = "~r~Mission Failed"
					displayDoneMission = true
					SetSubtitle("~r~YOU DIED", 5000)
					SetEntityAsNoLongerNeeded(car)
					RemoveBlip(carBlip)
					Wait (1000)
					return
				elseif IsEntityDead(car) then
					str = "~r~Mission Failed"
					displayDoneMission = true
					SetSubtitle("~r~THE VEHICLE WAS DESTROYED", 5000)
					SetEntityAsNoLongerNeeded(car)
					RemoveBlip(carBlip)
					Wait (1000)
					return
				end
			end
			RemoveBlip(carBlip)
			areaBlip = AddBlipForCoord(-1389.35, -585.3, 30.2)
			SetBlipColour(areaBlip, 5)
			SetBlipRoute(areaBlip, true)
			SetSubtitle("Drive to the ~y~the location ~w~and wait for the ~r~target.", 5000)
		end
	end
	RemoveBlip(areaBlip)
	local target = CreatePed(4, model, -1389.35, -585.3, 30.2, 13.8, true, true)
	TaskWanderStandard(target, 10.0, 10)
	local targetBlip = AddBlipForEntity(target)
	SetBlipColour(carBlip, 1)
	SetBlipRoute(carBlip, true)
	Wait(2000)
	
	SetSubtitle("Kill the ~r~target ~w~while inside the ~b~vehicle", 5000)
	while not IsPedDeadOrDying(target, 1) do
		Wait(1)
		if IsPedDeadOrDying(player, 1) then
			str = "~r~Mission Failed"
			displayDoneMission = true
			SetSubtitle("~r~YOU DIED", 5000)
			SetEntityAsNoLongerNeeded(car)
			SetEntityAsNoLongerNeeded(targetBlip)
			RemoveBlip(targetBlip)
			Wait (1000)
			return
		elseif IsEntityDead(car) then
			str = "~r~Mission Failed"
			displayDoneMission = true
			SetSubtitle("~r~THE VEHICLE WAS DESTROYED", 5000)
			SetEntityAsNoLongerNeeded(car)
			SetEntityAsNoLongerNeeded(targetBlip)
			RemoveBlip(targetBlip)
			Wait (1000)
			return
		elseif not IsPedInVehicle(player, car, false) then
			str = "~r~Mission Failed"
			displayDoneMission = true
			SetSubtitle("~r~YOU LEFT THE VEHICLE", 5000)
			SetEntityAsNoLongerNeeded(car)
			SetEntityAsNoLongerNeeded(targetBlip)
			RemoveBlip(targetBlip)
			Wait (1000)
			return
		end
	end
	
	str = "Mission Passed"
	displayDoneMission = true
	SetEntityAsNoLongerNeeded(car)
	SetEntityAsNoLongerNeeded(targetBlip)
	RemoveBlip(targetBlip)
	Wait (10000)
	
	return
end

Citizen.CreateThread(MainScript)