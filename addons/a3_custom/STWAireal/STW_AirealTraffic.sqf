#ifndef  STW_AirealTraffic_Module_Loaded
#define STW_AirealTraffic_Module_Loaded true
diag_log "STW_AirealTraffic_Module_Loaded";

if (!isServer) exitWith{};

waitUntil {(count ([] call BIS_fnc_listPlayers))>0};


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
	//_veh lockDriver true;
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
		_stwfAirianDriverOutOfVehicle={
		  _pilot=_this;
		  _index =STW_AIR_TRAFFIC_ALIVE_AIRS find _pilot;
		  STW_AIR_TRAFFIC_ALIVE_AIRS deleteAt _index;
		  _pilot setDamage [1,true];
		  deleteVehicle _pilot;
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
		
/*
		 // Clean drivers with no vehicle
		  {
			_pilot=_x;
			if (vehicle _pilot == _pilot) then //Not into vehicle
			{
				_minDistToPlayers=[getPos _pilot] call stwf_getMinimumDistanceToPlayers;
				if (_minDistToPlayers>300) then
				{
					//diag_log format ["Killing driver with no vehicle"];
					_pilot call _stwfAirianDriverOutOfVehicle;
				};
				sleep 1;
			};
		  } forEach STW_AIR_TRAFFIC_ALIVE_AIRS;
*/		
	};
	_veh;
};

STW_AIR_TRAFFIC_ALIVE_VEHICLES=[];
//STW_AIR_TRAFFIC_ALIVE_AIRS=[];

//Get the forbiddenAirTrafficMarkers
stwf_getForbiddenTrafficMarkers=
{
	"NOAIRTraffic" call stwf_GetMarkersStartingWith;
};

		
stw_controlAirTraffic=
{
	while {true} do 
	{
	 waitUntil {count allPlayers>0};
	 _retries=0;
	 //while {(count STW_AIR_TRAFFIC_ALIVE_VEHICLES<STWG_NUM_AIR_TRAFFIC_VEHICLES)&& (_retries<9)} do
	 //{
	  //_playerPos=(getPos selectRandom allPlayers);
	  //_octoPos=[_playerPos,STW_MAX_DISTANCE_FROM_PLAYERS_FOR_AIR_TRAFFIC] call stwf_getOctogonalPositionsSurroundingPlayer;
	  //_position= selectRandom _octoPos;
	  //_position= [] call stwf_getRandomPosition2D;
	  _angle=floor random 360;
	  _position=[worldSize*sin _angle,worldSize*cos _angle];
	  diag_log format ["Random starting position for aircraft=%1",_position];
	  _height = getTerrainHeightASL _position;
	  _position3D = [_position select 0,_position select 1, (random 100)+(_height+300) ];
	  
	  /*_inForbiddenZone=false;
	  _forbiddenAirTrafficMarkers=[] call stwf_getForbiddenTrafficMarkers;
	  {
		_markerPos=getMarkerPos _x;
		if ((_position distance2D _markerPos)<500) exitWith{_inForbiddenZone=true;};
	  } forEach _forbiddenAirTrafficMarkers;
	  if (_inForbiddenZone) then
	  {
		_position=nil;
	  };
	  */
	  
	  if (!(isNil("_position"))) then
	  {
			_veh= [_position3D] call stwf_spawnAirTrafficVehicle;
			STW_AIR_TRAFFIC_ALIVE_VEHICLES pushBack _veh;
			//STW_AIR_TRAFFIC_ALIVE_AIRS pushBack (driver _veh);
	  };
	  //_retries=_retries+1;
	  //sleep 2;
	 //};
	  sleep 10;
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
	};
};
[] call stw_controlAirTraffic;

#endif