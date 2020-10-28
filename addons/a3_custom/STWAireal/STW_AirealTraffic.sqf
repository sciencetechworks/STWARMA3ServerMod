#ifndef  STW_AirealTraffic_Module_Loaded
#define STW_AirealTraffic_Module_Loaded true
diag_log "STW_AirealTraffic_Module_Loaded";

if (!isServer) exitWith{};

//waitUntil {(count ([] call BIS_fnc_listPlayers))>0};


//Select a random aircraft
stwf_getRandomAircraftClassName=
{
  selectRandom STWG_PossibleAirVehicles;
};



// Spawn a random aircraft at the given position
stwf_spawnAirTrafficVehicle=
{
    params ["_vehPos"];
	
	_vehClass = [] call stwf_getRandomAircraftClassName;
	_veh=[_vehClass,_vehPos] call stwf_generateVehicleWithPassengers;
	_veh setVelocity [(sin (direction _veh) * 150),(cos (direction _veh) * 150),200];
	_driver= driver _veh;
	_driver setVariable ["DriverOf",_veh];
	_veh setVariable ["DrivenBy",_driver];
	_driver setskill ["general",0.8];
	
	_grp= group _driver;
	_grp setBehaviour (selectRandom ["AWARE","COMBAT"]);
	_grp deleteGroupWhenEmpty true;
	
	_scriptPath="PATH";
	if (STWG_NO_ADDON_MODE) then
	{
		_scriptPath="@STWCustom\addons\a3_custom\STWAireal\STW_AirealTrafficWaypoint.sqf";
	} else
	{	
		_scriptPath="a3_custom\STWAireal\STW_AirealTrafficWaypoint.sqf";
	};
	_grp execVm _scriptPath;
	
		
	_veh spawn 
	{
		_stwfDeleteVehicleGroupWithCrew={
		  _veh=_this;
		  _index =STW_AIR_TRAFFIC_ALIVE_VEHICLES find _veh;
		  STW_AIR_TRAFFIC_ALIVE_VEHICLES deleteAt _index;
		  _grp=group _veh;
		  {
			deleteVehicle _x; 
			_x setDamage [1,false];
		  } forEach units _grp;
		  deleteGroup _grp;
		  deleteVehicle _veh;
		};
		_veh=_this;
		_veh setFuel 0.25; //make it live less
		while {alive _veh} do
		{	
			//_veh setFuel 0.75;
			_driver =_veh getVariable "DrivenBy";
			_driver assignAsDriver _veh;
			[_driver] orderGetIn true;
		
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

STW_AIR_TRAFFIC_ALIVE_VEHICLES=[];


stw_controlAirTraffic=
{
	while {true} do 
	{
	 diag_log format ["STW PATROLLING PLANES CHECK. NUMBER OF PLANES %1 , OF MAX %2",count STW_AIR_TRAFFIC_ALIVE_VEHICLES,STWG_NUM_AIR_TRAFFIC_VEHICLES];
	 while {(count STW_AIR_TRAFFIC_ALIVE_VEHICLES<STWG_NUM_AIR_TRAFFIC_VEHICLES)} do
	 {
	  _angle=floor random 360;
	  _position=[worldSize/2+worldSize/2*sin _angle,worldSize/2+worldSize/2*cos _angle];
	  diag_log format ["Random starting position for aircraft=%1",_position];
	  _height = getTerrainHeightASL _position;
	  _position3D = [_position select 0,_position select 1, (random 100)+(_height+300) ];
	  
	  if (!(isNil("_position"))) then
	  {
			_veh= [_position3D] call stwf_spawnAirTrafficVehicle;
			STW_AIR_TRAFFIC_ALIVE_VEHICLES pushBack _veh;
	  };
	
	  sleep 2;
	  };
	  
	  //Delete dead vehicles so that they are created in the next loop
	  {
		_veh=_x;
		if (!alive _veh) then
		{
			_index =STW_AIR_TRAFFIC_ALIVE_VEHICLES find _veh;
			STW_AIR_TRAFFIC_ALIVE_VEHICLES deleteAt _index;
			_grp=group _veh;
			{
				deleteVehicle _x; 
				_x setDamage [1,false];
			} forEach units _grp;
			deleteGroup _grp;
		};
		sleep 2;
	  } forEach STW_AIR_TRAFFIC_ALIVE_VEHICLES;
	  sleep 50;
	};
};
[] call stw_controlAirTraffic;

#endif