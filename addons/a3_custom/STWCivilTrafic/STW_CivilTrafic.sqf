if (!isServer) exitWith{};

waitUntil {(count ([] call BIS_fnc_listPlayers))>0};

STW_NUM_CIVIL_TRAFIC_VEHICLES=6;
STW_MAX_CIVIL_VEHICLE_SPEED=75;
STW_MAX_DISTANCE_FROM_PLAYERS_FOR_CIVIL_TRAFFIC=1900;

//stwCivilCarsMap = ["new", []] call OO_HASHMAP;

//Select a random car
_stwf_getRandomCarClassName=
{
  _cars=[
    "C_Van_01_fuel_F",
	"C_Hatchback_01_F",
	"C_Offroad_02_unarmed_F_black",
	"C_Offroad_02_unarmed_F_blue",
	"C_Offroad_02_unarmed_F",
	"C_Offroad_02_unarmed_F_green",
	"C_Offroad_02_unarmed_F_orange",
	"C_Truck_02_fuel_F",
	"C_Truck_02_box_F",
	"C_Truck_02_transport_F",
	"C_Truck_02_covered_F",
	"C_Offroad_01_F",
	"C_Offroad_01_repair_F",
	"C_SUV_01_F",
	"C_Van_01_transport_F",
	"C_Van_01_box_F",
	"C_Van_02_medevac_F",
	"C_Van_02_vehicle_F",
	"C_Van_02_service_F",
	"C_Van_02_transport_F"
  ];
  selectRandom _cars
};


//Creates a random civil vehicle (with passenger) on the given position.
_stwf_generateCivilVehicleWithPassenger=
{
 _position = _this select 0;
 _vehClass = [] call _stwf_getRandomCarClassName;
 //diag_log format ["_stwf_generateCivilVehicleWithPassenger %1 %2",_position,_vehClass];
 _veh = createVehicle [_vehClass, _position, [], 0, "NONE"];
	
  createVehicleCrew _veh;
	{
		alive _x;
	} forEach crew _veh;
	
  _veh
};




STW_DEBUG=true;
dinfo={
 if (STW_DEBUG) then
 {
	diag_log _this;
 };
};

STWG_CIVILIAN_TO_PLAYER_MIN_DIST_TO_JOIN_PLAYER_GROUP=5;
STWG_CIVILIAN_TO_PLAYER_MIN_DIST_TO_LEAVE_PLAYER_GROUP=10;
stwf_CivilianBehaviour=
{
  _civil=_this;
  _civilInfo=[getPos _civil] call stwf_getNearestPlayerNotIntoVehicle;
  _civilToNearestPlayerDist=_civilInfo select 0;
  _nearestPlayer=_civilInfo select 1;
  //format ["Civil To Nearest Player Distance %1",_civilToNearestPlayerDist] call dinfo;
  
  _originalGroup= _civil getVariable "STWCivilOriginalGroup";
  if (isNil "_originalGroup") then
  {
	_civil setVariable ["STWCivilOriginalGroup",group _civil];
	_originalGroup= _civil getVariable "STWCivilOriginalGroup";
  };
  
  if (_civilToNearestPlayerDist<STWG_CIVILIAN_TO_PLAYER_MIN_DIST_TO_JOIN_PLAYER_GROUP) then
  {
	if (group _civil != group _nearestPlayer) then
	{
		if ([_nearestPlayer,_civil,80] call stwf_areLookingAtEachOther) then
		{
			[_civil] join (group _nearestPlayer);
		};
	};
  };
  
  if (_civilToNearestPlayerDist>STWG_CIVILIAN_TO_PLAYER_MIN_DIST_TO_LEAVE_PLAYER_GROUP) then
  {
	_originalGroup=_civil getVariable "STWCivilOriginalGroup";
	if (_originalGroup!=group _civil) then
	{
		_playerIsWatchingCivil=([_nearestPlayer,_civil,80] call stwf_isLookingAtAB);
		if (!_playerIsWatchingCivil) then
		{
			if (side _originalGroup!=civilian) then
			{
				_originalGroup = createGroup [civilian,true];
			};
			[_civil] join _originalGroup;
			_civil setVariable ["STWCivilOriginalGroup",group _civil];
			_originalGroup= _civil getVariable "STWCivilOriginalGroup";
			_civil setOwner -1;
			_originalGroup execVm "a3_custom\STWCivilTrafic\STW_RefreshCivilTraficWayPoint.sqf";
		};
	};
  };
   
};

stwf_assignCivilianBehaviour=
{
	//"AssignCivilianBehaviour" call dinfo;
	_civil=_this;
	_civil spawn {
		_civil=_this;
		while {alive _civil} do
		{
			_civil call stwf_CivilianBehaviour;
			sleep 1;
		};
	};
};


//////


/////
stw_spawnCivilTraficVehicle=
{
	_vehPos=_this select 0;
	_veh=[_vehPos] call _stwf_generateCivilVehicleWithPassenger;
	//_veh lockDriver true;
	_veh limitSpeed STW_MAX_CIVIL_VEHICLE_SPEED;
	_driver= driver _veh;
	_driver setVariable ["DriverOf",_veh];
	_veh setVariable ["DrivenBy",_driver];
	_driver setskill ["general",0.8];
	_driver call stwf_assignCivilianBehaviour;
	_grp= group _driver;
	_grp setBehaviour (selectRandom ["AWARE"]);
	_grp deleteGroupWhenEmpty true;
	
	_grp execVm "a3_custom\STWCivilTrafic\STW_RefreshCivilTraficWayPoint.sqf";
	// SPAWN SPEED LIMITER
	_veh spawn 
	{		
		_veh=_this;
		
		//Get the forbiddenCivilTrafficMarkers
		_stwf_getForbiddenTrafficMarkers=
		{
			_zoneMarkers = [];
			{
			  _marker=_x;
			  _arr = toArray _marker;
			  _markerName=toString _arr;
			  //diag_log format ["Checking %1",_markerName];
				if(_markerName find "NOCIVTraffic">=0) then {
					_zoneMarkers pushBack _marker;
					//diag_log format ["added %1!",_markerName]
				};
			} foreach allMapMarkers;
			_zoneMarkers;
		};

		while {alive _veh} do
		{
			_info=[getPos _veh] call stwf_getNearestPlayerNotIntoVehicle;
			_minDistToPlayers=_info select 0;
			_nearestPlayer=_info select 1;
			_spd=STW_MAX_CIVIL_VEHICLE_SPEED;
			_driver = driver _veh;
			
			_inForbiddenZone=false;
			_forbiddenCivilTrafficMarkers=[] call _stwf_getForbiddenTrafficMarkers;
			{
				_markerPos=getMarkerPos _x;
				if (((getPos _veh) distance2D _markerPos)<500) exitWith{_inForbiddenZone=true;};
			} forEach _forbiddenCivilTrafficMarkers;
			
			if (_inForbiddenZone) then
			{
				_veh forceSpeed 0;
				//_grp=group _veh;
				//{
				// deleteVehicle _x; 
				// _x setDamage [1,false];
				//} forEach units _grp;
				//deleteGroup _grp;
				//deleteVehicle _veh;
			} else
			{
				if  (_nearestPlayer!=objNull) then
				{
					//format ["Min dist to player:%1",_minDistToPlayers] call dinfo;
					if ([_veh,_nearestPlayer,120] call stwf_isLookingAtAB) then
					{
						if (_minDistToPlayers<30) then
						{
							_spd=20;
						};
						if (_minDistToPlayers<20) then
						{
							_spd= 10;
						};
						if (_minDistToPlayers<10) then
						{
							_veh forceSpeed 5;
							_spd= 5;
						};
						if (_minDistToPlayers<5) then
						{
							_spd= 0;
							_veh forceSpeed 0;
							sleep 2;
							_veh forceSpeed -1;
							_spd=STW_MAX_CIVIL_VEHICLE_SPEED;
						} else
						{
							_veh forceSpeed -1;
						};
					} else
					{
						_veh forceSpeed -1;
					};
				} else
				{
					_veh forceSpeed -1;
					_spd=STW_MAX_CIVIL_VEHICLE_SPEED;
				};
			};
			
			if (_spd==STW_MAX_CIVIL_VEHICLE_SPEED) then
			{
				_roadType=_veh call stwf_getRoadType;
				switch (_roadType) do {
					case "no road": {_spd=10;};
					case "gravel road": {_spd=20;};
					case "sealed road": {_spd=30;};
					case "highway": {_spd=STW_MAX_CIVIL_VEHICLE_SPEED;};
					default {_spd=50};
				};
			};
			
			// format ["Nearest Player:%1 speed: %2",_nearestPlayer,_spd] call dinfo;
			_veh limitSpeed _spd;
			sleep 2;
		};
	};
	
	
	_veh spawn 
	{
		_stwfDeleteVehicleGroupWithCrew={
		  _veh=_this;
		  _index =STW_CIVIL_TRAFIC_ALIVE_VEHICLES find _veh;
		  STW_CIVIL_TRAFIC_ALIVE_VEHICLES deleteAt _index;
		  _grp=group _veh;
		  {
			deleteVehicle _x; 
			_x setDamage [1,false];
		  } forEach units _grp;
		  deleteGroup _grp;
		  deleteVehicle _veh;
		};
		_stwfCivilianDriverOutOfVehicle={
		  _civilian=_this;
		  _index =STW_CIVIL_TRAFFIC_ALIVE_CIVILIANS find _civilian;
		  STW_CIVIL_TRAFFIC_ALIVE_CIVILIANS deleteAt _index;
		  _civilian setDamage [1,true];
		  deleteVehicle _civilian;
		};
		_veh=_this;
		while {alive _veh} do
		{	
			_veh setFuel 0.75;
			_driver =_veh getVariable "DrivenBy";
			_driver assignAsDriver _veh;
			[_driver] orderGetIn true;
			_oldPosition= getPos _veh;
			sleep 60;
			_position= getPos _veh;
			_checkDistance=_position distance _oldPosition;
			_minDistToPlayers=[getPos _veh] call stwf_getMinimumDistanceToPlayers;

			if (( _checkDistance < 5)&&(_minDistToPlayers>1000)) then
			{
				//diag_log format ["Vehicle not moving, delete"];
				_veh call _stwfDeleteVehicleGroupWithCrew;
				sleep 20;
			}; 
			_minDistToPlayers=[getPos _veh] call stwf_getMinimumDistanceToPlayers;
			if (_minDistToPlayers>STW_MAX_DISTANCE_FROM_PLAYERS_FOR_CIVIL_TRAFFIC) then
			{
				diag_log format ["Vehicle too far from players, delete"];
				_veh call _stwfDeleteVehicleGroupWithCrew;
				sleep 20;
			};
		};
		sleep 300; //5 minutes after the death of the vehicle, it dissapears
		while {! isNull _veh} do
		{	
			_minDistToPlayers=[getPos _veh] call stwf_getMinimumDistanceToPlayers;
			if (_minDistToPlayers>STW_MAX_DISTANCE_FROM_PLAYERS_FOR_CIVIL_TRAFFIC) then
			{
				//diag_log format ["Dead Vehicle too far from players, delete"];
				_veh call _stwfDeleteVehicleGroupWithCrew;
				sleep 20;
			};
		};
		
		 // Clean drivers with no vehicle
		  {
			_civilian=_x;
			if (vehicle _civilian == _civilian) then //Not into vehicle
			{
				_minDistToPlayers=[getPos _civilian] call stwf_getMinimumDistanceToPlayers;
				if (_minDistToPlayers>400) then
				{
					diag_log format ["Killing driver with no vehicle"];
					_civilian call _stwfCivilianDriverOutOfVehicle;
				};
				sleep 20;
			};
		  } forEach STW_CIVIL_TRAFFIC_ALIVE_CIVILIANS;
		
	};
	_veh;
};

STW_CIVIL_TRAFIC_ALIVE_VEHICLES=[];
STW_CIVIL_TRAFFIC_ALIVE_CIVILIANS=[];

//Get the forbiddenCivilTrafficMarkers
stwf_getForbiddenTrafficMarkers=
{
	"NOCIVTraffic" call stwf_GetMarkersStartingWith;
};

		
stw_controlCivilTrafic=
{
	while {true} do 
	{
	 waitUntil {count allPlayers>0};
	 _retries=0;
	 while {(count STW_CIVIL_TRAFIC_ALIVE_VEHICLES<STW_NUM_CIVIL_TRAFIC_VEHICLES)&& (_retries<9)} do
	 {
	  _playerPos=(getPos selectRandom allPlayers);
	  _octoPos=[_playerPos,STW_MAX_DISTANCE_FROM_PLAYERS_FOR_CIVIL_TRAFFIC] call stwf_getOctogonalPositionsSurroundingPlayer;
	  _position= getPos (selectRandom ((selectRandom _octoPos) nearRoads 200));
	  
	  if (!isNil "_position") then
	  {
		  _aminDistToPlayers=[_position] call stwf_getMinimumDistanceToPlayers;
		  if (_aminDistToPlayers<700) then {
		   _position=nil;
		  };
	  };
	  
	  _inForbiddenZone=false;
	  if (!isNil "_position") then
	  {
		  _forbiddenCivilTrafficMarkers=[] call stwf_getForbiddenTrafficMarkers;
		  {
			_markerPos=getMarkerPos _x;
			if ((_position distance2D _markerPos)<500) exitWith{_inForbiddenZone=true;};
		  } forEach _forbiddenCivilTrafficMarkers;
	  };
	  if (_inForbiddenZone) then
	  {
		_position=nil;
	  };
	  
	  if (!(isNil("_position"))) then
	  {
		  if (!(surfaceIsWater _position)) then
		  {
			_veh= [_position] call stw_spawnCivilTraficVehicle;
			STW_CIVIL_TRAFIC_ALIVE_VEHICLES pushBack _veh;
			STW_CIVIL_TRAFFIC_ALIVE_CIVILIANS pushBack (driver _veh);
		  };
	  };
	  _retries=_retries+1;
	  sleep 2;
	 };
	  sleep 10;
	  //Delete dead vehicles so that they are created in the next loop
	  {
		_veh=_x;
		if (!alive _veh) then
		{
		 _index =STW_CIVIL_TRAFIC_ALIVE_VEHICLES find _veh;
		 STW_CIVIL_TRAFIC_ALIVE_VEHICLES deleteAt _index;
		 _minDistToPlayers=[getPos _veh] call stwf_getMinimumDistanceToPlayers;
		 if (_minDistToPlayers>STW_MAX_DISTANCE_FROM_PLAYERS_FOR_CIVIL_TRAFFIC) then
			{
				diag_log format ["Vehicle too far from players, delete"];
				_grp=group _veh;
				{
					deleteVehicle _x; 
					_x setDamage [1,false];
				} forEach units _grp;
				deleteGroup _grp;
			};
		};
		sleep 2;
	  } forEach STW_CIVIL_TRAFIC_ALIVE_VEHICLES;
	};
};
[] call stw_controlCivilTrafic;