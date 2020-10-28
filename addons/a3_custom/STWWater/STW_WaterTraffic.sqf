#ifndef  STW_WaterTraffic_Module_Loaded
#define STW_WaterTraffic_Module_Loaded true
diag_log "STW_WaterTraffic_Module_Loaded";

if (!isServer) exitWith{};

//waitUntil {(count ([] call BIS_fnc_listPlayers))>0};


//Select a random  boat
stwf_getRandomBoatClassName=
{
  selectRandom STWG_COMBAT_BOATS;
};

fstwGetRandomWaterZone=
{
 _result= selectRandom STWG_WATER_ZONES;
 _result
};

fstwGetZoneCenter=
{
 _zone=_this;
 _x0=(_zone select 0) select 0;
 _y0=(_zone select 0) select 1;
 
 _x1=(_zone select 1) select 0;
 _y1=(_zone select 1) select 1;
 
 _x=_x0+((_x1-_x0)/2);
 _y=_y0+((_y1-_y0)/2);
 
 [_x,_y]
};

// Spawn a random aircraft at the given position
stwf_spawnWaterTrafficVehicle=
{
    params ["_vehPos"];
	
	_vehClass = [] call stwf_getRandomBoatClassName;
	//_veh=[_vehClass,_vehPos] call stwf_generateVehicleWithPassengers;
	_boats=STWG_COMBAT_BOATS;
	
	_veh = createVehicle [selectRandom _boats, _position, [], 0, "NONE"];
	createVehicleCrew _veh;
		
	createVehicleCrew _veh;
	{
		//diag_log [_x, faction _x, side _x, side group _x];
		alive _x;
	} forEach crew _veh;
	//sleep 10;
	[objNull, _veh] call BIS_fnc_curatorObjectEdited;
	//_veh setVelocity [(sin (direction _veh) * 150),(cos (direction _veh) * 150),200];
	_driver= driver _veh;
	/*_driver setVariable ["DriverOf",_veh];
	_veh setVariable ["DrivenBy",_driver];
	_driver setskill ["general",0.8];
	*/
	_grp= group _driver;
	//_grp setBehaviour (selectRandom ["AWARE","COMBAT"]);
	_grp deleteGroupWhenEmpty true;
	
	_scriptPath="PATH";
	if (STWG_NO_ADDON_MODE) then
	{
		_scriptPath="@STWCustom\addons\a3_custom\STWWater\STW_WaterTrafficWaypoint.sqf";
	} else
	{	
		_scriptPath="a3_custom\STWWater\STW_WaterTrafficWaypoint.sqf";
	};
	_grp execVm _scriptPath;
	
		
	_veh spawn 
	{
		_stwfDeleteVehicleGroupWithCrew={
		  _veh=_this;
		  _index =STW_WATER_TRAFFIC_ALIVE_VEHICLES find _veh;
		  STW_WATER_TRAFFIC_ALIVE_VEHICLES deleteAt _index;
		  _grp=group _veh;
		  {
			deleteVehicle _x; 
			_x setDamage [1,false];
		  } forEach units _grp;
		  deleteGroup _grp;
		  deleteVehicle _veh;
		};
		_veh=_this;
		//_veh setFuel 0.25; //make it live less
		while {alive _veh} do
		{	
			if (fuel _veh<=0) then
			{
				sleep 240;
				_veh call _stwfDeleteVehicleGroupWithCrew;
			};
			sleep 60;
		};
		sleep 30; //after the death of the vehicle, it dissapears
		_veh call _stwfDeleteVehicleGroupWithCrew;
		sleep 5;
	};
	_veh;
};

STW_WATER_TRAFFIC_ALIVE_VEHICLES=[];


stw_controlWaterTraffic=
{
	while {true} do 
	{
	  diag_log format ["STW PATROLLING BOATS CHECK. NUMBER OF BOATS %1 , OF MAX %2", count STW_WATER_TRAFFIC_ALIVE_VEHICLES,STWG_NUM_WATER_TRAFFIC_VEHICLES];
	 while {(count STW_WATER_TRAFFIC_ALIVE_VEHICLES<STWG_NUM_WATER_TRAFFIC_VEHICLES)} do
	 {
	  //_zone=[] call fstwGetRandomWaterZone;
	  //_position = _zone call fstwGetZoneCenter; 
	  _angle=floor random 360;
	  _position=[worldSize/2+worldSize/2*sin _angle,worldSize/2+worldSize/2*cos _angle];
	  diag_log format ["Random starting position for boat=%1",_position];
	  if (!(isNil("_position"))) then
	  {
	  _boats=STWG_COMBAT_BOATS;
	  _veh = createVehicle [selectRandom _boats, _position, [], 0, "NONE"];
	  createVehicleCrew _veh;
	  {
			//diag_log [_x, faction _x, side _x, side group _x];
			alive _x;
	  } forEach crew _veh;
	  
		//_veh= [_position3D] call stwf_spawnWaterTrafficVehicle;
		STW_WATER_TRAFFIC_ALIVE_VEHICLES pushBack _veh;
		sleep 10;
		_driver= driver _veh;
		_grp= group _driver;
		_grp deleteGroupWhenEmpty true;
	
		_scriptPath="PATH";
		if (STWG_NO_ADDON_MODE) then
		{
			_scriptPath="@STWCustom\addons\a3_custom\STWWater\STW_WaterTrafficWaypoint.sqf";
		} else
		{	
			_scriptPath="a3_custom\STWWater\STW_WaterTrafficWaypoint.sqf";
		};
		_grp execVm _scriptPath;
	  };
	
	  //sleep 2;
	  };
	  sleep 45;
	  //Delete dead vehicles so that they are created in the next loop
	  {
		_veh=_x;
		if (!alive _veh) then
		{
			_index =STW_WATER_TRAFFIC_ALIVE_VEHICLES find _veh;
			STW_WATER_TRAFFIC_ALIVE_VEHICLES deleteAt _index;
			_grp=group _veh;
			{
				deleteVehicle _x; 
				_x setDamage [1,false];
			} forEach units _grp;
			deleteGroup _grp;
		} else
		{
		 _veh setFuel 0.75;
		};
		sleep 2;
	  } forEach STW_WATER_TRAFFIC_ALIVE_VEHICLES;
	};
};
[] call stw_controlWaterTraffic;

#endif