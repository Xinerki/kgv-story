
local startPos = vector3(-16.15, 241.45, 108.55)

-- gesture_bring_it_on
-- gesture_bye_hard
-- gesture_bye_soft
-- gesture_come_here_hard
-- gesture_come_here_soft
-- gesture_damn
-- gesture_displeased
-- gesture_easy_now
-- gesture_hand_down
-- gesture_hand_left
-- gesture_hand_right
-- gesture_head_no
-- gesture_hello
-- gesture_i_will
-- gesture_me
-- gesture_me_hard
-- gesture_no_way
-- gesture_nod_no_hard
-- gesture_nod_no_soft
-- gesture_nod_yes_hard
-- gesture_nod_yes_soft
-- gesture_pleased
-- gesture_point
-- gesture_shrug_hard
-- gesture_shrug_soft
-- gesture_what_hard
-- gesture_what_soft
-- gesture_why
-- gesture_why_left
-- gesture_you_hard
-- gesture_you_soft
-- getsure_its_mine

local function Gesture(ped, gesture)
	if gesture == "its_mine" then -- rockstar why
		TaskPlayAnim(ped, "gestures@m@sitting@generic@casual", "getsure_"..gesture, 4.0, 4.0, -1, 48, -1.0, false, false, false)
	else
		TaskPlayAnim(ped, "gestures@m@sitting@generic@casual", "gesture_"..gesture, 4.0, 4.0, -1, 48, -1.0, false, false, false)
	end
end

local tonyName = "Tony"
local nikoName = "Niko"

local function MainScript()
	if (mission1Passed == false) then
	
		------------------------------------------------------------------------------------------------------------------------------
		--													CREATE NIKO 															--
		------------------------------------------------------------------------------------------------------------------------------
		
		local nikoModel = `mp_m_niko_01`
		if not HasModelLoaded(nikoModel) then
			RequestModel(nikoModel)
			repeat Wait(0) until HasModelLoaded(nikoModel)
		end
		
		local niko = CreatePed(4, nikoModel, -4.9, 240.1, 109.05, 0.0, false, true)
		TaskStartScenarioAtPosition(niko, "PROP_HUMAN_SEAT_CHAIR_UPRIGHT", -4.9, 240.1, 109.05, 89.0, -1, true, true)
		SetBlockingOfNonTemporaryEvents(niko, true)
		SetEntityCollision(niko, false, true)
		SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(niko), false)
		
		SetPedComponentVariation(niko, 2, 3, 0, 0)
		SetPedComponentVariation(niko, 3, 41, 0, 0)
		SetPedComponentVariation(niko, 4, 22, 0, 0)
		SetPedComponentVariation(niko, 11, 3, 0, 0)
	
		------------------------------------------------------------------------------------------------------------------------------
		--													CREATE TONY																--
		------------------------------------------------------------------------------------------------------------------------------
		
		local tonyModel = `ig_tonyprince`
		if not HasModelLoaded(tonyModel) then
			RequestModel(tonyModel)
			repeat Wait(0) until HasModelLoaded(tonyModel)
		end
		
		local tony = CreatePed(4, tonyModel, -7.0, 240.35, 109.05, 0.0, false, true)
		SetPedPropIndex(tony, 1, 0, 0, true)
		TaskStartScenarioAtPosition(tony, "PROP_HUMAN_SEAT_CHAIR_UPRIGHT", -7.0, 240.35, 109.05, -96.65, -1, true, true)
		SetBlockingOfNonTemporaryEvents(tony, true)
		SetEntityCollision(tony, false, true)
		SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(tony), false)
		
		------------------------------------------------------------------------------------------------------------------------------
		--													MISSION BLIP															--
		------------------------------------------------------------------------------------------------------------------------------
		
		local missionBlip = AddBlipForCoord(startPos)
		SetBlipSprite(missionBlip, 79)	
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Tony")
		EndTextCommandSetBlipName(missionBlip)
		
		while GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), startPos) > 2.0 or IsPedInAnyVehicle(PlayerPedId(), true) do
			Wait(0)
			DrawMarker(1, startPos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.3, 255, 255, 100, 150, false, false, false, true)
			if onMission == true then
				SetBlipDisplay(missionBlip, 0)
				repeat Wait(0) until onMission == false
				SetBlipDisplay(missionBlip, 2)
			end
		end
		
		------------------------------------------------------------------------------------------------------------------------------
		--													MISSION START															--
		------------------------------------------------------------------------------------------------------------------------------
		
		SetPlayerControl(PlayerId(), false, 0)
		
		onMission = true
		DoScreenFadeOut(1000)
		Wait(1000)
		
		SetBlipDisplay(missionBlip, 0)
		
		HidePlayer(true)
		ShowHud(false)
		
		local playerClone = ClonePed(PlayerPedId(), 0.0, false, true)
		SetBlockingOfNonTemporaryEvents(playerClone, true)
		SetEntityCoords(playerClone, -1.55, 237.85, 109.55)
		SetEntityHeading(playerClone, 71.9)
		
		TaskStartScenarioAtPosition(PlayerPedId(), "WORLD_HUMAN_STAND_MOBILE", -25.45, 241.65, 108.55, 82.65, -1, false, false)
		
		local cutsceneCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
		
		SetCamCoord(cutsceneCam, -2.6, 241.05, 110.1)
		SetCamRot(cutsceneCam, -5.25, 0.0, 108.5, 2)
		SetCamFov(cutsceneCam, 45.0)
		RenderScriptCams(true, false, 0, true, true)
		
		if not HasAnimDictLoaded("gestures@m@sitting@generic@casual") then
			RequestAnimDict("gestures@m@sitting@generic@casual")
			repeat Wait(0) until HasAnimDictLoaded("gestures@m@sitting@generic@casual")
		end
		
		-- Gesture(tony, "damn")
		
		DoScreenFadeIn(1000)
		DisplayDebugText("TODO: Mission Name~n~- Rendering~n~- Fancy name (ask ng?)")
		Wait(500)
		
		------------------------------------------------------------------------------------------------------------------------------
		--													CUTSCENE START															--
		------------------------------------------------------------------------------------------------------------------------------
		
		TaskGoToCoordAnyMeansExtraParams(playerClone, -6.2, 239.0, 109.55, 1.0, 0, -14.2, 786603, 0, 0, 0, 0)
		
		TaskLookAtEntity(tony, niko, -1, 2048, 3)
		TaskLookAtEntity(niko, tony, -1, 2048, 3)
		
		------------------------------------------------------------------------------------------------------------------------------
		--												DIALOGUE WRIRTEN BY ROGUE													--
		------------------------------------------------------------------------------------------------------------------------------
		
		SetDialog(tonyName, "...Can't let this get out of hand!", 2500)
		Gesture(tony, "damn")
		Wait(2500)
		
		TaskLookAtEntity(tony, playerClone, -1, 2048, 3)
		TaskLookAtEntity(niko, playerClone, -1, 2048, 3)
		TaskLookAtEntity(playerClone, tony, -1, 2048, 3)
		
		SetPedDesiredHeading(playerClone, -14.2)
		SetDialog(tonyName, "There they are!", 2500)
		Gesture(tony, "hello")
		Wait(2500)
		
		SetPedDesiredHeading(playerClone, -14.2) -- double to make sure
		
		TaskLookAtEntity(playerClone, niko, -1, 2048, 3)
		TaskLookAtEntity(niko, tony, -1, 2048, 3)
		TaskLookAtEntity(tony, niko, -1, 2048, 3)
		
		SetDialog(nikoName, "Who is this?", 2500)
		Gesture(niko, "what_soft")
		Wait(2500)
		
		TaskLookAtEntity(playerClone, tony, -1, 2048, 3)
		
		SetDialog(tonyName, "Someone we can trust. We've done work together before.", 3500)
		Gesture(tony, "point")
		Wait(3500)
		
		TaskLookAtEntity(playerClone, niko, -1, 2048, 3)
		
		SetDialog(nikoName, "What? You don't trust me?", 2500)
		Gesture(niko, "why")
		Wait(2500)
		
		TaskLookAtEntity(playerClone, tony, -1, 2048, 3)
		
		DisplayDebugText("TODO: Dialogue~n~- ng wrote the new dialogue already~n~- might make it better?")
		
		SetDialog(tonyName, "I never said that. You have more important matters attend to, right?", 3500)
		Gesture(tony, "hand_right")
		Wait(3500)
		
		TaskLookAtEntity(playerClone, niko, -1, 2048, 3)
		
		SetDialog(nikoName, "I guess you're right.", 2500)
		Gesture(niko, "shrug_soft")
		Wait(2500)
		
		TaskLookAtEntity(tony, playerClone, -1, 2048, 3)
		TaskLookAtEntity(niko, playerClone, -1, 2048, 3)
		TaskLookAtEntity(playerClone, tony, -1, 2048, 3)
		
		SetDialog(tonyName, "Anyways, friend, there's something I need you to do.", 3500)
		Gesture(tony, "you_soft")
		Wait(3500)
		
		SetDialog(tonyName, "A little birdy told me a supply van will be arriving at Bahama Mama's soon.", 3500)
		Gesture(tony, "hand_left")
		Wait(3500)
		
		SetDialog(tonyName, "Should be loaded with lots of useful stuff, but Maisonette needs it more.", 3500)
		Gesture(tony, "i_will")
		Wait(3500)
		
		SetDialog(tonyName, "I think if it just happened to fall into our lap, it'd be a good thing for everyone involved.", 3500)
		Gesture(tony, "its_mine")
		Wait(3500)
		
		TaskLookAtEntity(playerClone, niko, -1, 2048, 3)
		TaskLookAtEntity(niko, tony, -1, 2048, 3)
		TaskLookAtEntity(tony, niko, -1, 2048, 3)
		
		TaskStartScenarioInPlace(playerClone, "PROP_HUMAN_STAND_IMPATIENT", 0, true)
		
		SetDialog(nikoName, "Doesn't Bonelli run that place? It'll be heavily guarded!", 3500)
		Gesture(niko, "no_way")
		Wait(3500)
		
		TaskLookAtEntity(playerClone, tony, -1, 2048, 3)
		
		SetDialog(tonyName, "Don't worry, I think our friend can handle the situation.", 3500)
		Gesture(tony, "nod_no_hard")
		Wait(3500)
		
		ClearPedTasks(PlayerPedId())
		TaskGoToCoordAnyMeansExtraParams(playerClone, -1.55, 237.85, 109.55, 1.0, 0, -14.2, 786603, 0, 0, 0, 0)
		
		TaskLookAtEntity(tony, playerClone, -1, 2048, 3)
		TaskLookAtEntity(niko, playerClone, -1, 2048, 3)
		TaskLookAtEntity(playerClone, tony, -1, 2048, 3)
		
		SetDialog(tonyName, "I see you're a bit excited! Alright, I won't hold you back any longer.", 3500)
		Gesture(tony, "easy_now")
		Wait(3500)
		
		TaskClearLookAt(playerClone)
		
		SetDialog(tonyName, "Just bring the van back to Maisonette in one piece.", 3500)
		Gesture(tony, "bye_soft")
		Wait(3500)
		
		TaskClearLookAt(niko)
		TaskClearLookAt(tony)
		
		DoScreenFadeOut(1000)
		Wait(1000)
		
		------------------------------------------------------------------------------------------------------------------------------
		--													CUTSCENE END															--
		------------------------------------------------------------------------------------------------------------------------------
		
		DeleteEntity(playerClone)
		
		RenderScriptCams(false, false, 0, true, true)
		DestroyCam(cutsceneCam, false)
		
		HidePlayer(false)
		ShowHud(true)
		
		SetEntityCoords(PlayerPedId(), -25.45, 241.65, 108.55)
		SetEntityHeading(PlayerPedId(), 81.65)
		
		local lastVehicle = GetPlayersLastVehicle()
		
		if GetDistanceBetweenCoords(-25.45, 241.65, 108.55, GetEntityCoords(lastVehicle)) < 80.0 then
			SetEntityCoords(lastVehicle, -32.5, 252.55, 106.35)
			SetEntityRotation(lastVehicle, -5.81, -1.21, 97.53)
			SetVehicleOnGroundProperly(lastVehicle)
		end
		
		SetGameplayCamRelativeHeading(0.0)
		
		StartMusicEvent("MP_MC_ASSAULT_ADV_START")
		
		DoScreenFadeIn(1000)
		Wait(1000)
		
		------------------------------------------------------------------------------------------------------------------------------
		--													GAMEPLAY START															--
		------------------------------------------------------------------------------------------------------------------------------
		
		SetPlayerControl(PlayerId(), true, 0)
		StartMusicEvent("MP_MC_ASSAULT_ADV_SUSPENSE")
		
		-- TODO: before doing enemy spawning, investigate AI blip stuff
		-- UPDATE: couldn't get it to work
		
		SetSubtitle("Go to ~y~Bahama Mamas.", 5000)
		local destinationBlip = AddBlipForCoord(-1403.35, -635.5, 27.85)
		SetBlipColour(destinationBlip, 5)
		SetBlipRoute(destinationBlip, true)
		
		while (GetDistanceBetweenCoords(-25.45, 241.65, 108.55, GetEntityCoords(PlayerPedId())) < 500.0) do
			Wait(0)
			if IsPedDeadOrDying(PlayerPedId(), 1) then
			
				RemoveBlip(destinationBlip)
				DeleteEntity(tony)
				DeleteEntity(niko)
				
				StartMusicEvent("MP_MC_ASSAULT_ADV_STOP")
				SetSubtitle("~r~MISSION FAILED\nYou died.", 5000)
				Wait(1000)
				onMission = false
				Citizen.CreateThread(MainScript)
				return
			end
		end
		
		DeleteEntity(niko)
		DeleteEntity(tony)
		
		SetModelAsNoLongerNeeded(`mp_m_niko_01`)
		SetModelAsNoLongerNeeded(`ig_tonyprince`)
		
		RequestModel(`mp_g_m_pros_01`)
		RequestModel(`rumpo3`)
		RequestModel(`xm_prop_rsply_crate04a`)
		
		while (GetDistanceBetweenCoords(-1403.35, -635.5, 27.85, GetEntityCoords(PlayerPedId())) > 100.0) do
			Wait(0)
			if IsPedDeadOrDying(PlayerPedId(), 1) then
				SetModelAsNoLongerNeeded(`mp_g_m_pros_01`)
				SetModelAsNoLongerNeeded(`rumpo3`)
				SetModelAsNoLongerNeeded(`xm_prop_rsply_crate04a`)
				
				RemoveBlip(destinationBlip)
				StartMusicEvent("MP_MC_ASSAULT_ADV_STOP")
				SetSubtitle("~r~MISSION FAILED\nYou died.", 5000)
				Wait(1000)
				onMission = false
				Citizen.CreateThread(MainScript)
				return
			end
		end
		
		RemoveBlip(destinationBlip)
		
		local rumpo = CreateVehicle(`rumpo3`, -1403.35, -635.5, 27.85, -162.5, true, false)
		local crate = CreateObjectNoOffset(`xm_prop_rsply_crate04a`, -1403.35, -635.5, 27.85, true, false, false)
		
		AttachEntityToEntity(crate, rumpo, 0, 0.0, -1.85, -0.49, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
		
		SetVehicleOnGroundProperly(rumpo)
		
		-- mp_g_m_pros_01
		
		local enemyPos = {
			vector4(-1400.3, -637.45, 28.56, -145.9),
			vector4(-1404.65, -638.6, 28.65, 162.65),
			vector4(-1406.75, -635.9, 28.65, 123.25),
			vector4(-1408.5, -645.3, 28.65, 124.55),
			vector4(-1410.6, -642.4, 28.65, 124.55),
			vector4(-1394.95, -644.6, 28.65, -106.35),
			vector4(-1395.55, -647.35, 28.65, -106.35),
			-- vector4(),
		}
		
		local weps = {
			"SPECIALCARBINE",
			"ASSAULTRIFLE",
			"SMG",
		}
		
		local spawnedPeds = {}
		
		for i,v in pairs(enemyPos) do
			local ped = CreatePed(26, `mp_g_m_pros_01`, v.x, v.y, v.z, v.w, true, false)
			
			local wep = GetHashKey("WEAPON_"..weps[math.random(1,#weps)])
			GiveWeaponToPed(ped, wep, 9999, false, true)
			SetCurrentPedWeapon(ped, wep, true)
			
			SetPedSeeingRange(ped, 20.0)
			SetPedHearingRange(ped, 5.0)
			
			-- SetDecisionMaker(ped, 'DEFAULT_RESPONSE_HATE')
			SetPedRelationshipGroupHash(ped, GetHashKey("ENEMY"))
			
			SetPedHasAiBlip(ped, true)
			
			table.insert(spawnedPeds, ped)
			Wait(0)
		end
		
		StartMusicEvent("MP_MC_ASSAULT_ADV_ACTION")
		
		SetSubtitle("Get in the ~b~van.", 5000)
		local carBlip = AddBlipForEntity(rumpo)
		SetBlipColour(carBlip, 3)
		
		local lastVehicle = GetVehiclePedIsIn(PlayerPedId(), 1)
		
		while (not IsPedInVehicle(PlayerPedId(), rumpo, false)) do
			Wait(0)
			if IsPedDeadOrDying(PlayerPedId(), 1) then
				for i,v in ipairs(spawnedPeds) do 
					SetEntityAsNoLongerNeeded(v)
				end
				
				SetEntityAsNoLongerNeeded(rumpo)
				SetEntityAsNoLongerNeeded(crate)
				
				SetModelAsNoLongerNeeded(`mp_g_m_pros_01`)
				SetModelAsNoLongerNeeded(`rumpo3`)
				SetModelAsNoLongerNeeded(`xm_prop_rsply_crate04a`)
				
				RemoveBlip(carBlip)
				StartMusicEvent("MP_MC_ASSAULT_ADV_STOP")
				SetSubtitle("~r~MISSION FAILED\nYou died.", 5000)
				Wait(1000)
				onMission = false
				Citizen.CreateThread(MainScript)
				return
			elseif IsEntityDead(rumpo) then
				for i,v in ipairs(spawnedPeds) do 
					SetEntityAsNoLongerNeeded(v)
				end
				
				SetEntityAsNoLongerNeeded(rumpo)
				SetEntityAsNoLongerNeeded(crate)
				
				SetModelAsNoLongerNeeded(`mp_g_m_pros_01`)
				SetModelAsNoLongerNeeded(`rumpo3`)
				SetModelAsNoLongerNeeded(`xm_prop_rsply_crate04a`)
				
				RemoveBlip(carBlip)
				StartMusicEvent("MP_MC_ASSAULT_ADV_STOP")
				SetSubtitle("~r~MISSION FAILED\nThe van was destroyed.", 5000)
				Wait(1000)
				onMission = false
				Citizen.CreateThread(MainScript)
				return
			end
			for i,v in ipairs(spawnedPeds) do
				if IsPedDeadOrDying(v, true) then
					SetEntityAsNoLongerNeeded(v)
					table.remove(spawnedPeds, i)
				end
			end
		end
		
		RemoveBlip(carBlip)
		
		SetSubtitle("Deliver the ~b~van ~w~to ~y~Maisonette.", 5000)
		local destinationBlip = AddBlipForCoord(-462.0, -51.95, 44.7)
		SetBlipColour(destinationBlip, 5)
		SetBlipRoute(destinationBlip, true)
		
		local movedVehicle = false
		
		while (GetDistanceBetweenCoords(-462.0, -51.95, 44.7, GetEntityCoords(rumpo)) > 5.0) do
			Wait(0)
			DrawMarker(1, -462.0, -51.95, 44.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.3, 255, 255, 100, 150, false, false, false, true)
			
			if movedVehicle == false and GetDistanceBetweenCoords(-1403.35, -635.5, 27.85, GetEntityCoords(rumpo)) > 100.0 then
				SetEntityCoords(lastVehicle, -471.3, -57.0, 43.8)
				SetEntityRotation(lastVehicle, 0.0, 0.0, 87.75)
				SetVehicleOnGroundProperly(lastVehicle)
				movedVehicle = true
			end
			
			if not IsPedInVehicle(PlayerPedId(), rumpo, false) then
				RemoveBlip(destinationBlip)
				SetSubtitle("Get back in the ~b~van.", 5000)
				local carBlip = AddBlipForEntity(rumpo)
				SetBlipColour(carBlip, 3)
				while (not IsPedInVehicle(PlayerPedId(), rumpo, false)) do
					Wait(0)
					if IsPedDeadOrDying(PlayerPedId(), 1) then
						for i,v in ipairs(spawnedPeds) do 
							SetEntityAsNoLongerNeeded(v)
						end
						
						SetEntityAsNoLongerNeeded(rumpo)
						SetEntityAsNoLongerNeeded(crate)
						
						SetModelAsNoLongerNeeded(`mp_g_m_pros_01`)
						SetModelAsNoLongerNeeded(`rumpo3`)
						SetModelAsNoLongerNeeded(`xm_prop_rsply_crate04a`)
						
						RemoveBlip(carBlip)
						StartMusicEvent("MP_MC_ASSAULT_ADV_STOP")
						SetSubtitle("~r~MISSION FAILED\nYou died.", 5000)
						Wait(1000)
						onMission = false
						Citizen.CreateThread(MainScript)
						return
					elseif IsEntityDead(rumpo) then
						for i,v in ipairs(spawnedPeds) do 
							SetEntityAsNoLongerNeeded(v)
						end
						
						SetEntityAsNoLongerNeeded(rumpo)
						SetEntityAsNoLongerNeeded(crate)
						
						SetModelAsNoLongerNeeded(`mp_g_m_pros_01`)
						SetModelAsNoLongerNeeded(`rumpo3`)
						SetModelAsNoLongerNeeded(`xm_prop_rsply_crate04a`)
						
						RemoveBlip(carBlip)
						StartMusicEvent("MP_MC_ASSAULT_ADV_STOP")
						SetSubtitle("~r~MISSION FAILED\nThe van was destroyed.", 5000)
						Wait(1000)
						onMission = false
						Citizen.CreateThread(MainScript)
						return
					elseif GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(rumpo)) > 100.0 then
						for i,v in ipairs(spawnedPeds) do 
							SetEntityAsNoLongerNeeded(v)
						end
						
						SetEntityAsNoLongerNeeded(rumpo)
						SetEntityAsNoLongerNeeded(crate)
						
						SetModelAsNoLongerNeeded(`mp_g_m_pros_01`)
						SetModelAsNoLongerNeeded(`rumpo3`)
						SetModelAsNoLongerNeeded(`xm_prop_rsply_crate04a`)
						
						RemoveBlip(carBlip)
						StartMusicEvent("MP_MC_ASSAULT_ADV_STOP")
						SetSubtitle("~r~MISSION FAILED\nThe van was abandoned", 5000)
						Wait(1000)
						onMission = false
						Citizen.CreateThread(MainScript)
						return
					end
				end
				SetSubtitle("Deliver the ~b~van ~w~to ~y~Maisonette.", 5000)
				local destinationBlip = AddBlipForCoord(-462.0, -51.95, 44.7)
				SetBlipColour(destinationBlip, 5)
				SetBlipRoute(destinationBlip, true)
			end
			
			if IsPedDeadOrDying(PlayerPedId(), 1) then
				for i,v in ipairs(spawnedPeds) do 
					SetEntityAsNoLongerNeeded(v)
				end
				SetEntityAsNoLongerNeeded(rumpo)
				SetEntityAsNoLongerNeeded(crate)
				
				SetModelAsNoLongerNeeded(`mp_g_m_pros_01`)
				SetModelAsNoLongerNeeded(`rumpo3`)
				SetModelAsNoLongerNeeded(`xm_prop_rsply_crate04a`)
				
				RemoveBlip(destinationBlip)
				
				StartMusicEvent("MP_MC_ASSAULT_ADV_STOP")
				SetSubtitle("~r~MISSION FAILED\nYou died.", 5000)
				Wait(1000)
				onMission = false
				Citizen.CreateThread(MainScript)
				return
			elseif IsEntityDead(rumpo) then
				for i,v in ipairs(spawnedPeds) do 
					SetEntityAsNoLongerNeeded(v)
				end
				SetEntityAsNoLongerNeeded(rumpo)
				SetEntityAsNoLongerNeeded(crate)
				
				SetModelAsNoLongerNeeded(`mp_g_m_pros_01`)
				SetModelAsNoLongerNeeded(`rumpo3`)
				SetModelAsNoLongerNeeded(`xm_prop_rsply_crate04a`)
				
				RemoveBlip(destinationBlip)
				
				StartMusicEvent("MP_MC_ASSAULT_ADV_STOP")
				SetSubtitle("~r~MISSION FAILED\nThe van was destroyed.", 5000)
				Wait(1000)
				onMission = false
				Citizen.CreateThread(MainScript)
				return
			end
		end
		
		------------------------------------------------------------------------------------------------------------------------------
		--													GAMEPLAY END															--
		------------------------------------------------------------------------------------------------------------------------------
		
		for i,v in ipairs(spawnedPeds) do 
			SetEntityAsNoLongerNeeded(v)
		end
		
		StartMusicEvent("MP_MC_ASSAULT_ADV_STOP")
		
		TaskLeaveVehicle(PlayerPedId(), rumpo, 0)
		-- SetVehicleIsConsideredByPlayer(rumpo, false)
		SetVehicleDoorsLocked(rumpo, 2)
		
		RemoveBlip(carBlip)
		
		SetEntityAsNoLongerNeeded(rumpo)
		SetEntityAsNoLongerNeeded(crate)
		
		SetModelAsNoLongerNeeded(`mp_g_m_pros_01`)
		SetModelAsNoLongerNeeded(`rumpo3`)
		SetModelAsNoLongerNeeded(`xm_prop_rsply_crate04a`)
		
		Wait(2000)
		onMission = false
		missionsPassed = missionsPassed + 1
		TriggerServerEvent("kgv:money:giveMoney", 1500)
		DisplayMissionPassed()
		
		------------------------------------------------------------------------------------------------------------------------------
		--													MISSION END																--
		------------------------------------------------------------------------------------------------------------------------------
		
	end
end

Citizen.CreateThread(MainScript)