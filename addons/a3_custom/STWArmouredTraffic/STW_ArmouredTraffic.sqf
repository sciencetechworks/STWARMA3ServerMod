if (!isServer) exitWith{};

waitUntil {(count ([] call BIS_fnc_listPlayers))>0};

diag_log "///////////////////////// STW ARMOURED VEHICLES /////////////////";

STW_NUM_ARMOUR_TRAFFIC_VEHICLES=8;
STW_MAX_ARMOUR_VEHICLE_SPEED=50;
STW_MAX_DISTANCE_FROM_PLAYERS_FOR_ARMOUR_TRAFFIC=25000;

//stwArmourCarsMap = ["new", []] call OO_HASHMAP;

//Select a random armouredVehicle
_stwf_getRandomArmouredVehicleClassName=
{
  _armouredVehicles=[
    //"RHS_Ural_MSV_01",
	//"RHS_Ural_Fuel_MSV_01",
	//"RHS_Ural_VDV_01",
	//"rhs_typhoon_vdv",
	//"rhs_gaz66_repair_vdv",
	//"RHS_Ural_Open_MSV_01",
	//"rhs_sprut_vdv",
	"rhs_bmp1p_msv",
	"rhs_brm1k_msv",
	"rhs_bmp2_msv",
	"rhs_bmp2e_msv",
	"rhs_bmp2d_msv",
	"rhs_bmp2k_msv",
	"rhs_prp3_msv",
	"rhs_bmd4_vdv",
	"rhs_bmd4ma_vdv",
	"rhs_t80u",
	"rhs_t80bv",
	"rhs_t80a",
	"rhs_t72bc_tv",
	"rhs_t72bb_tv",
	"rhs_zsu234_aa"
	
	//	"ffaa_et_anibal",
	//	"ffaa_et_m250_municion_blin",
	//	"ffaa_et_m250_combustible_blin",
	//	"ffaa_et_m250_recuperacion_blin",
	//	"ffaa_et_m250_carga_blin",
	//	"ffaa_et_m250_repara_municion_blin",
	//	"ffaa_et_m250_carga_lona_blin",
	//	"ffaa_et_m250_sistema_nasams_blin",
	//	"ffaa_et_m250_estacion_nasams_blin",
	//	"ffaa_et_pegaso_municion",
	//	"ffaa_et_pegaso_combustible",
	//	"ffaa_et_pegaso_carga",
	//	"ffaa_et_pegaso_repara_municion",
	//	"ffaa_et_pegaso_carga_lona",
	//	"ffaa_et_rg31_samson",
	//	"ffaa_et_vamtac_lag40",
	//	"ffaa_et_vamtac_m2",
	//	"ffaa_et_vamtac_tow",
	//	"ffaa_et_vamtac_ume",
	//	"ffaa_et_vamtac_cardom",
	//	"ffaa_et_vamtac_crows",
	//	"ffaa_et_vamtac_mistral",
	
	//"ffaa_et_leopardo","ffaa_et_pizarro_mauser","ffaa_et_toa_m2","ffaa_et_toa_ambulancia",
	//"ffaa_et_toa_zapador","ffaa_et_toa_spike","ffaa_et_toa_mando"
  ];
  _veh=selectRandom _armouredVehicles;
  diag_log format ["Selected Armoured Vehicle: %1",_veh];
  _veh
};


//Creates a random civil vehicle (with passenger) on the given position.
_stwf_generateArmourVehicleWithPassenger=
{
 _position = _this select 0;
 _vehClass = [] call _stwf_getRandomArmouredVehicleClassName;
 diag_log format ["_stwf_generateArmourVehicleWithPassenger %1 %2",_position,_vehClass];
 _veh = createVehicle [_vehClass, _position, [], 0, "NONE"];
	
  createVehicleCrew _veh;
	{
		alive _x;
	} forEach crew _veh;
	
  _veh
};




STWG_ARMOURIAN_TO_PLAYER_MIN_DIST_TO_JOIN_PLAYER_GROUP=5;
STWG_ARMOURIAN_TO_PLAYER_MIN_DIST_TO_LEAVE_PLAYER_GROUP=10;
stwf_ArmourianBehaviour=
{
  _person=_this;
  _personInfo=[getPos _person] call stwf_getNearestPlayerNotIntoVehicle;
  _personToNearestPlayerDist=_personInfo select 0;
  _nearestPlayer=_personInfo select 1;
  //format ["Armour To Nearest Player Distance %1",_personToNearestPlayerDist] call dinfo;
  if (side _nearestPlayer == side _person) then 
  {
	  _originalGroup= _person getVariable "STWArmourOriginalGroup";
	  if (isNil "_originalGroup") then
	  {
		_person setVariable ["STWArmourOriginalGroup",group _person];
		_originalGroup= _person getVariable "STWArmourOriginalGroup";
	  };
	  
	  if (_personToNearestPlayerDist<STWG_ARMOURIAN_TO_PLAYER_MIN_DIST_TO_JOIN_PLAYER_GROUP) then
	  {
		if (group _person != group _nearestPlayer) then
		{
			if ([_nearestPlayer,_person,80] call stwf_areLookingAtEachOther) then
			{
				[_person] join (group _nearestPlayer);
			};
		};
	  };
  };
  
  if (_personToNearestPlayerDist>STWG_ARMOURIAN_TO_PLAYER_MIN_DIST_TO_LEAVE_PLAYER_GROUP) then
  {
	_originalGroup=_person getVariable "STWArmourOriginalGroup";
	if (!isNil "_originalGroup") then
	{
		if (_originalGroup!=group _person) then
		{
			_playerIsWatchingArmour=([_nearestPlayer,_person,80] call stwf_isLookingAtAB);
			if (!_playerIsWatchingArmour) then
			{
				if (side _originalGroup!=civilian) then
				{
					_originalGroup = createGroup [civilian,true];
				};
				[_person] join _originalGroup;
				_person setVariable ["STWArmourOriginalGroup",group _person];
				_originalGroup= _person getVariable "STWArmourOriginalGroup";
				_person setOwner -1;
				_originalGroup execVm "a3_custom\STWArmouredTraffic\STW_RefreshArmouredTrafficWayPoint.sqf";
			};
		};
	}; 
  };
   
};

stwf_assignArmourianBehaviour=
{
	//"AssignArmourianBehaviour" call dinfo;
	_person=_this;
	_person spawn {
		_person=_this;
		while {alive _person} do
		{
			_person call stwf_ArmourianBehaviour;
			sleep 1;
		};
	};
};


/////
stw_spawnArmouredTrafficVehicle=
{
	_vehPos=_this select 0;
	_veh=[_vehPos] call _stwf_generateArmourVehicleWithPassenger;
	//_veh lockDriver true;
	_veh limitSpeed STW_MAX_ARMOUR_VEHICLE_SPEED;
	_driver= driver _veh;
	_driver setVariable ["DriverOf",_veh];
	_veh setVariable ["DrivenBy",_driver];
	_driver setskill ["general",0.8];
	_driver call stwf_assignArmourianBehaviour;
	_grp= group _driver;
	_grp setBehaviour (selectRandom ["AWARE","COMBAT","COMBAT","STEALTH","STEALTH"]);
	_grp deleteGroupWhenEmpty true;
	
	_grp execVm "a3_custom\STWArmouredTraffic\STW_RefreshArmouredTrafficWayPoint.sqf";
	// SPAWN SPEED LIMITER
	_veh spawn 
	{		
		_veh=_this;
		
		//Get the forbiddenArmouredTrafficMarkers
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
			_spd=STW_MAX_ARMOUR_VEHICLE_SPEED;
			_driver = driver _veh;
			
			_inForbiddenZone=false;
			_forbiddenArmouredTrafficMarkers=[] call _stwf_getForbiddenTrafficMarkers;
			{
				_markerPos=getMarkerPos _x;
				if (((getPos _veh) distance2D _markerPos)<500) exitWith{_inForbiddenZone=true;};
			} forEach _forbiddenArmouredTrafficMarkers;
			
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
							_spd=15;
						};
						if (_minDistToPlayers<20) then
						{
							_spd= 5;
						};
						if (_minDistToPlayers<10) then
						{
							_veh forceSpeed 2;
							_spd= 2;
						};
						if (_minDistToPlayers<5) then
						{
							_spd= 0;
							_veh forceSpeed 0;
							sleep 2;
							_veh forceSpeed -1;
							_spd=STW_MAX_ARMOUR_VEHICLE_SPEED;
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
					_spd=STW_MAX_ARMOUR_VEHICLE_SPEED;
				};
			};
			
			if (_spd==STW_MAX_ARMOUR_VEHICLE_SPEED) then
			{
				_roadType=_veh call stwf_getRoadType;
				switch (_roadType) do {
					case "no road": {_spd=5;};
					case "gravel road": {_spd=10;};
					case "sealed road": {_spd=20;};
					case "highway": {_spd=STW_MAX_ARMOUR_VEHICLE_SPEED;};
					default {_spd=30};
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
		  _index =STW_ARMOUR_TRAFFIC_ALIVE_VEHICLES find _veh;
		  STW_ARMOUR_TRAFFIC_ALIVE_VEHICLES deleteAt _index;
		  _grp=group _veh;
		  {
			deleteVehicle _x; 
			_x setDamage [1,false];
		  } forEach units _grp;
		  deleteGroup _grp;
		  deleteVehicle _veh;
		};
		
		_stwfArmourianDriverOutOfVehicle={
		  _person=_this;
		  _index =STW_ARMOUR_TRAFFIC_ALIVE_ARMOURIANS find _person;
		  STW_ARMOUR_TRAFFIC_ALIVE_ARMOURIANS deleteAt _index;
		  _person setDamage [1,true];
		  deleteVehicle _person;
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

			if (( _checkDistance < 5)&&(_minDistToPlayers>800)) then
			{
				//diag_log format ["Vehicle not moving, delete"];
				_veh call _stwfDeleteVehicleGroupWithCrew;
				sleep 20;
			}; 
			_minDistToPlayers=[getPos _veh] call stwf_getMinimumDistanceToPlayers;
			if (_minDistToPlayers>STW_MAX_DISTANCE_FROM_PLAYERS_FOR_ARMOUR_TRAFFIC) then
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
			if (_minDistToPlayers>STW_MAX_DISTANCE_FROM_PLAYERS_FOR_ARMOUR_TRAFFIC) then
			{
				//diag_log format ["Dead Vehicle too far from players, delete"];
				_veh call _stwfDeleteVehicleGroupWithCrew;
				sleep 20;
			};
		};
		
		 // Clean drivers with no vehicle
		  {
			_person=_x;
			if (vehicle _person == _person) then //Not into vehicle
			{
				_minDistToPlayers=[getPos _person] call stwf_getMinimumDistanceToPlayers;
				if (_minDistToPlayers>STW_MAX_DISTANCE_FROM_PLAYERS_FOR_ARMOUR_TRAFFIC) then
				{
					diag_log format ["Killing driver with no vehicle"];
					_person call _stwfArmourianDriverOutOfVehicle;
				};
				sleep 20;
			};
		  } forEach STW_ARMOUR_TRAFFIC_ALIVE_ARMOURIANS;
		
	};
	_veh;
};

STW_ARMOUR_TRAFFIC_ALIVE_VEHICLES=[];
STW_ARMOUR_TRAFFIC_ALIVE_ARMOURIANS=[];

//Get the forbiddenArmouredTrafficMarkers
stwf_getForbiddenTrafficMarkers=
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

		
stwf_controlArmouredTraffic=
{
	diag_log "/////////////stwf_controlArmouredTraffic";
	while {true} do 
	{
	 waitUntil {count allPlayers>0};
	 _retries=0;
	 while {(count STW_ARMOUR_TRAFFIC_ALIVE_VEHICLES<STW_NUM_ARMOUR_TRAFFIC_VEHICLES)&& (_retries<9)} do
	 {
	  _playerPos=(getPos selectRandom allPlayers);
	  _octoPos=[_playerPos,STW_MAX_DISTANCE_FROM_PLAYERS_FOR_ARMOUR_TRAFFIC] call stwf_getOctogonalPositionsSurroundingPlayer;
	  _position= getPos (selectRandom ((selectRandom _octoPos) nearRoads 1000));
	  
	  _inForbiddenZone=false;
	  _forbiddenArmouredTrafficMarkers=[] call stwf_getForbiddenTrafficMarkers;
	  {
		_markerPos=getMarkerPos _x;
		if ((_position distance2D _markerPos)<500) exitWith{_inForbiddenZone=true;};
	  } forEach _forbiddenArmouredTrafficMarkers;
	  if (_inForbiddenZone) then
	  {
		_position=nil;
	  };
	  
	  if (!(isNil("_position"))) then
	  {
		  if (!(surfaceIsWater _position)) then
		  {
			_veh= [_position] call stw_spawnArmouredTrafficVehicle;
			STW_ARMOUR_TRAFFIC_ALIVE_VEHICLES pushBack _veh;
			STW_ARMOUR_TRAFFIC_ALIVE_ARMOURIANS pushBack (driver _veh);
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
		 _index =STW_ARMOUR_TRAFFIC_ALIVE_VEHICLES find _veh;
		 STW_ARMOUR_TRAFFIC_ALIVE_VEHICLES deleteAt _index;
		 _minDistToPlayers=[getPos _veh] call stwf_getMinimumDistanceToPlayers;
		 if (_minDistToPlayers>STW_MAX_DISTANCE_FROM_PLAYERS_FOR_ARMOUR_TRAFFIC) then
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
	  } forEach STW_ARMOUR_TRAFFIC_ALIVE_VEHICLES;
	};
};
[] call stwf_controlArmouredTraffic;