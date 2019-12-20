
local posX, posY, posZ = 17.05, -11.35, 70.1


function DrawEntry()
	local localPlayer = PlayerPedId()
	Mission1Blip = AddBlipForCoord(posX, posY, posZ)
	SetBlipSprite(Mission1Blip,112)	
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Xin")
	EndTextCommandSetBlipName(Mission1Blip)
	-- SetBlipColour(blip,78)
	
	while mission1Passed == false do
		Citizen.Wait(0)
		
		if onMission == false and mission1Passed == false then
			SetBlipScale(Mission1Blip, 1.0)
			DrawMarker(1,posX, posY, posZ-0.95, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 0.5, 150,150,0 , 255, false, false, false, false)
			DrawLightWithRangeWithShadow(posX, posY, posZ, 255,255,0 , 1.5, 1.0, 5.0)
		else
			SetBlipScale(Mission1Blip, 0.0)
		end
		
		if onMission == false and not IsPedSittingInAnyVehicle(localPlayer) then
			
			local px,py,pz=table.unpack(GetEntityCoords(localPlayer))
			local dist = GetDistanceBetweenCoords(px,py,pz, posX, posY, posZ, 1)
			
			if dist < 1.75 and not onMission then
				if IsControlPressed(1, 51) and onMission == false then
					onMission = true
					Citizen.CreateThread(StartMission)
				end
				
				if onMission == false then
					-- DrawText(0.0, 0.0) -- apparently required?
					DisplayHelpText("Press ~INPUT_CONTEXT~ to enter this mission.")
				end
			end
		end
	end
end

Citizen.CreateThread(DrawEntry)

function StartMission()
	local view1=CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
	SetCamCoord(view1, 10.5, 13.6, 75.3)
	SetCamRot(view1, 0.0, 0.0, 180.0)
	SetCamFov(view1, 45.0)
	RenderScriptCams(1, 0, view1,  true,  true)
	FreezeEntityPosition(localPlayer, true)
	hidePlayer(5000)
	stopShowingHud(5000)	
	Citizen.Wait(5000)
	-- POST 'LOAD' --
	
	StartScreenEffect("SwitchShortTrevorMid", 500, false)
	PlaySound(-1, "slow", "SHORT_PLAYER_SWITCH_SOUND_SET", 0, 0, 1)
	Citizen.Wait(250)
	StopScreenEffect()
	
	FreezeEntityPosition(localPlayer, false)
	
	SetEntityCoordsNoOffset(localPlayer, 16.95, -4.05, 70.2, 0.0, 0.0, 0.0)
	SetEntityRotation(localPlayer, 0.0, 0.0, 0.0)
	
	RenderScriptCams(0, 0, view1,  true,  true)
	
	Wait(1000)
	DisplayMissionPassed()
	mission1Passed = true
	missionsPassed = missionsPassed + 1
	onMission = false
end