if (!isServer) exitWith{};

waitUntil {(count ([] call BIS_fnc_listPlayers))>0};

//[MissionName,vehicle]
stwf_launchBlowUpMission=
{
 _missionName=_this select 0;
 _vehicle=_this select 1;
 _position2D=getPos _vehicle;
 _missionTask =[_missionName,_missionName,_missionName,_cityName,_position2D,"Destroy"];
 diag_log format ["Destroy MISSION %1 has been created.",_missionName];
 
  //"C_IDAP_Truck_02_water_F"
  /*
 _vehclass="Land_Balloon_01_water_F";
 //_vehclass="SatchelCharge_Remote_Ammo_Scripted";
 _dummy=createVehicle [_vehclass,_position2D,[],0,"NONE"];
 _dummy setVehicleLock "LOCKED";
 _dummy allowDamage true;
 _dummy enableSimulationGlobal true; 
 _dummy enableSimulation true;
 _dummy enableDynamicSimulation true;
 //hideObject _dummy;
 //hideObjectGlobal _dummy;
 */
 
 [_missionTask,_vehicle,_dummy] spawn 
 {
 	_taskInfo=_this select 0;
	_vehicle=_this select 1;
	_dummy=_this select 2;
 	_taskName=_taskInfo select 0;
	_position=_taskInfo select 4;
		
	while {alive _vehicle} do
	{
	 if (!alive _vehicle) exitWith{true;};
 	 sleep 5;
	};
	
	for "_i" from 0 to (1+(random 2)) do
	{
		_bomb = createVehicle ["Bo_GBU12_LGB",getPos _vehicle,[],25,"NONE"];  
		sleep (random 5);
		_pos= getPos _vehicle;
		_vehicle setPos [_pos select 0,_pos select 1, (_pos select 2)-1]; 
	};
	[_taskName,"succeeded"] call FHQ_fnc_ttSetTaskState;
	for "_i" from 0 to 10 do
	{
		_pos= getPos _vehicle;
		_vehicle setPos [_pos select 0,_pos select 1, (_pos select 2)-1];
		sleep 1;
	};
	_bomb = createVehicle ["Bo_GBU12_LGB",getPos _vehicle,[],3,"NONE"];  
	_vehicle setDamage 1;
	_bomb = createVehicle ["Bo_GBU12_LGB",getPos _vehicle,[],3,"NONE"];  
	deleteVehicle _vehicle;		
 };
 _missionTask;
};

STW_NUMBER_OF_THINGS_TO_BLOW_UP=20;
STW_LAND_UNITS_TO_BLOW=[
"Land_ReservoirTower_F",
"Land_TTowerBig_1_F",
"Land_TTowerBig_2_F",
"Land_WaterTower_01_F",
"C_IDAP_Truck_02_transport_F",
"C_IDAP_Truck_02_water_F",

"Land_Missle_Trolley_02_F",
"Land_Bomb_Trolley_01_F",
"WaterPump_01_sand_F",
"Land_PowerGenerator_F",
"Land_Device_assembled_F",
"Land_Pallet_MilBoxes_F",
"Land_Communication_F",
"Box_FIA_Support_F",
"B_Slingload_01_Fuel_F",
"Land_PaperBox_open_full_F",
"rhs_weapons_crate_ak",
"Land_SatelliteAntenna_01_F",
"Land_WoodenCrate_01_stack_x5_F",
"Land_DieselGroundPowerUnit_01_F"
];

STW_WATER_UNITS_TO_BLOW=[
"UnderwaterMine",
"UnderwaterMineAB",
"C_Boat_Civil_01_F",
"C_Boat_Transport_02_F"
];

stwf_generateBlowUpMission={
	_position=_this select 0;
	_model=selectRandom STW_LAND_UNITS_TO_BLOW;
	if (surfaceIsWater _position) then
	{
		_model=selectRandom STW_WATER_UNITS_TO_BLOW;
	};
	
		//{
			_vehicle=createVehicle [_model, _position, [], 10, "NONE"];
			_vehicle setDamage 0.25;
			_vehicle allowDamage true;
			_vehicle enableSimulationGlobal true; 
			_vehicle enableSimulation true;
			_vehicle enableDynamicSimulation true;
			 
			//_grp=createGroup [EAST, true];
			//_unit=_grp createUnit [selectRandom STW_LAND_UNITS_TO_BLOW, _position, [], 1000, "NONE"];
			_missionName=format ["Blow up %1",mapGridPosition  _position];
			_task=[_missionName,_vehicle] call stwf_launchBlowUpMission;
			[_task] call FHQ_fnc_ttAddTasks;
		//};
};

//for "_i" from 0 to STW_NUMBER_OF_THINGS_TO_BLOW_UP do
//{
//	_position=[] call stwf_getRandomPosition;
//	
//	[_position] call stwf_generateBlowUpMission;
//};