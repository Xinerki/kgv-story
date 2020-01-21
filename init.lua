
-- GLOBAL --
onMission = false
missionsPassed = 0
visibility = true
_DEBUG = false
-- spawnedPeds = {}

-- MISSION 1 --
mission1Passed = false

-- FUNCTIONS --

-- MAIN INIT --
Citizen.CreateThread(function() 
	AddRelationshipGroup("ENEMY")
	SetRelationshipBetweenGroups(5, GetHashKey("ENEMY"), GetHashKey("PLAYER"))
	SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("ENEMY"))
	-- while true do
		-- player = PlayerPedId()
		-- Wait(0)
		-- for i,ped in ipairs(spawnedPeds) do
			-- local blip = GetBlipFromEntity(ped)
			-- if blip then
				-- if IsPedDeadOrDying(ped, 1) then SetBlipAlpha(blip, 0) end
			-- end
		-- end
	-- end
end)

function CheckIfPedsHaveSurvivors(pedTable)
	for i,ped in ipairs(pedTable) do
		if not IsPedDeadOrDying(ped, 1) then
			return true
		end
	end
	return false
end

function StartMusicEvent(event)
	PrepareMusicEvent(event)
	return TriggerMusicEvent(event) == 1
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

showPlayerAgain = false

function playerLoop()
	while true do
		Wait(0)
		SetLocalPlayerInvisibleLocally(true)
		if showPlayerAgain then
			showPlayerAgain = false
			return
		end
	end
end

function HidePlayer(hide)
	if hide == true then
		Citizen.CreateThread(playerLoop)
	else
		showPlayerAgain = true
	end
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

function ShowHud(show)
	if show == false then
		Citizen.CreateThread(hudLoop)
	else
		showHudAgain = true
	end
end

function DisplayHelpText(helpText, time)
	BeginTextCommandDisplayHelp("STRING")
	AddTextComponentSubstringWebsite(helpText)
	EndTextCommandDisplayHelp(0, 0, 1, time or -1)
end

function DisplayDebugText(helpText, time)
	if _DEBUG == true then
		DisplayHelpText(helpText, time)
		print("DEBUG: "..helpText)
	end
end

function SetSubtitle(subtitle, duration)
    ClearPrints()
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringWebsite(subtitle)
	EndTextCommandPrint(duration, true)
	if _DEBUG == true then
		print("DEBUG: "..subtitle)
	end
end

function SetDialog(speaker, subtitle, duration)
    ClearPrints()
    BeginTextCommandPrint("THREESTRINGS")
    AddTextComponentSubstringWebsite("~b~<C><i>"..speaker.."</i></C>\n~w~"..subtitle:sub(1,74))
    AddTextComponentSubstringWebsite(subtitle:sub(75,148))
    AddTextComponentSubstringWebsite(subtitle:sub(149,222))
	EndTextCommandPrint(duration, true)
	if _DEBUG == true then
		print("DEBUG: "..speaker..": "..subtitle)
	end
end

function DisplayMissionPassed(text)
	str = text or "Mission Passed"
	displayDoneMission = true
end

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
			AddTextComponentSubstringWebsite(str)
			EndTextComponent()
			BeginTextComponent("STRING")
			AddTextComponentSubstringWebsite("Yea!")
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