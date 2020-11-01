if (!isServer) exitWith {};

waitUntil {(count ([] call BIS_fnc_listPlayers))>0};

STW_MISSION_SITES=[];

stwf_GenerateSTW_MISSION_SITESArray={
  	/*{	
 		_lctype=_x;
 		{	
		    _tooNear=false;
			_locationPos=locationPosition _x;
			{
			 _site=_x;
			 _position=_site select 2;
			 if (_position distance2D _locationPos <2000 ) then
			 {
			  _tooNear=true;
			 };
			} forEach STW_MISSION_SITES;
			
			if (!_tooNear) then
			{
				STW_MISSION_SITES pushBack [_lctype,text _x, locationPosition _x, direction _x, size _x, rectangular _x];
			};
 		} forEach nearestLocations [getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition"), [_x], worldSize];	
 	} forEach ["NameLocal", "NameVillage", "NameCity", "NameCityCapital","AirPort","Hill","NameMarine","BorderCrossing","Strategic","StrongPointArea"];
	STW_MISSION_SITES=STW_MISSION_SITES call BIS_fnc_arrayShuffle;
 	diag_log format ["STW_MISSION_SITES=["];
 	{
 		diag_log format ["%1,",_x];
 	} forEach STW_MISSION_SITES;
 	diag_log format ["];"];*/
	_position=[] call stwf_getCenterOfMap; //getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition");
	STW_MISSION_SITES=[_position,worldSize] call stwf_getNearbyStrategicalPointsOfInterest;
	STW_MISSION_SITES_MODULE_READY=true;
};

//[MissionName,position2D]
stwf_launchMoveToMission=
{
  params ["_missionName","_position2D","_cityName"];
 _missionName=_this select 0;
 _position2D=_this select 1;
 _missionTask =[_missionName,"Move troops to this point in "+_cityName,_cityName+" Move to Strategic Point",_cityName,_position2D,"Move"];
 diag_log format ["MOVE MISSION %1 has been created.",_missionName];
 _missionTask spawn 
 {
 	_taskInfo=_this;
 	_taskName=_taskInfo select 0;
	_position=_taskInfo select 4;
 	_completed=false;
 	while {!_completed} do
 	{
 		{
 			_player=_x;			
 			if (_player distance2D _position < 10) then
 			{
 				[_taskName,"succeeded"] call FHQ_fnc_ttSetTaskState;
 				diag_log format ["Task %1 completed.",_taskName];
 				_completed=true;
 			};
			if (_completed) exitWith {true;};
 		} forEach allPlayers;
 	sleep 5;
 	};
 };
 _missionTask;
};

//[MissionName,unit]
stwf_launchDestroyUnitMission=
{
 _missionName=_this select 0;
 _unit=_this select 1;
 _unitName= name _unit;
 _position2D=getPos _unit;
 _missionTask =[_missionName,"Kill"+_unitName,_unitName+" Kill",_unitName,_unit,"Kill"];
 diag_log format ["Kill MISSION %1 has been created.",_missionName];
 
 [_missionTask,_unit] spawn 
 {
 	_taskInfo=_this select 0;
	_unit=_this select 1;
 	_taskName=_taskInfo select 0;
	_position=_taskInfo select 4;
		
	while {alive _unit} do
	{
 	 sleep 5;
	};
	[_taskName,"succeeded"] call FHQ_fnc_ttSetTaskState;
 };
 _missionTask;
};

stwf_launchRecoverVehicle=
{
  params ["_missionName","_position2D","_cityName"];
 _missionName=_this select 0;
 _position2D=_this select 1;
 
 _roads=_position2D nearRoads 100;
 if ( (count _roads)>0) then
 {
  _road=selectRandom _roads;
  _position2D=getPos _road;
 } else
 {
	_position2D=[_position2D,500] call stwf_isFlatEmptyLand ;
 };
 
 if (isNil("_position2D")||(count _position2D!=3)) 
	exitWith {diag_log "No flat position found"; nil};
 
 _missionTask =[_missionName,"Recover vehicle at "+_cityName,_cityName+" Recover vehicle",_cityName,_position2D,"Car"];
 diag_log format ["MISSION %1 has been created.",_missionName];
 _missionTask spawn 
 {
 	_taskInfo=_this;
 	_taskName=_taskInfo select 0;
	_position=_taskInfo select 4;
	
	_cars=STWG_CARS_TO_RECOVER_IN_MISSIONS;
	
	_vehicle=[_position,selectRandom _cars] call stwf_createEmptyVehicle;
 	_completed=false;
 	while {!_completed} do
 	{
 		{
 			_player=_x;			
 			if (vehicle _player == _vehicle) then
 			{
 				[_taskName,"succeeded"] call FHQ_fnc_ttSetTaskState;
 				diag_log format ["Task %1 completed.",_taskName];
 				_completed=true;
 			};
			
			if (_completed) exitWith {true;};
 		} forEach allPlayers;
		
		if ( !alive _vehicle) then 
		{
			[_taskName,"failed"] call FHQ_fnc_ttSetTaskState;
 			diag_log format ["Task %1 failed (The vehicle was destroyed).",_taskName];
 			_completed=true;
		};
		if (_completed) exitWith {true;};
 	sleep 5;
 	};
 };
 _missionTask;
};


stwf_launchRecoverHelicopter=
{
  params ["_missionName","_position2D","_cityName"];
 
  _position2D=[_position2D,2000] call stwf_isFlatEmptyLand ;
 
 if (isNil("_position2D")||(count _position2D!=3)) 
	exitWith {diag_log "No flat position found for helo"; nil};
 
 _missionTask =[_missionName,"Recover helicopter at "+_cityName,_cityName+" Recover helicopter",_cityName,_position2D,"Heli"];
 diag_log format ["MISSION %1 has been created.",_missionName];
 _missionTask spawn 
 {
 	_taskInfo=_this;
 	_taskName=_taskInfo select 0;
	_position=_taskInfo select 4;
	
	_helos=STWG_HELOS_TO_RECOVER_IN_MISSIONS;
	
	_vehicle=[_position,selectRandom _helos] call stwf_createEmptyVehicle;
 	_completed=false;
 	while {!_completed} do
 	{
 		{
 			_player=_x;			
 			if (vehicle _player == _vehicle) then
 			{
 				[_taskName,"succeeded"] call FHQ_fnc_ttSetTaskState;
 				diag_log format ["Task %1 completed.",_taskName];
 				_completed=true;
 			};
			
			if (_completed) exitWith {true;};
 		} forEach allPlayers;
		
		if ( !alive _vehicle) then 
		{
			[_taskName,"failed"] call FHQ_fnc_ttSetTaskState;
 			diag_log format ["Task %1 failed (The helicopter was destroyed).",_taskName];
 			_completed=true;
		};
		if (_completed) exitWith {true;};
 	sleep 5;
 	};
 };
 _missionTask;
};

//[MissionName,position2D]
stwf_launchAttackBuildingMission=
{
 params ["_missionName","_position2D","_cityName"];
 _missionTask =[_missionName,"Clear Buildings in "+_cityName,_cityName+" Clear Building",_cityName,_position2D,"Attack"];
 diag_log format ["Attack MISSION %1 has been created.",_missionName];
 _missionTask spawn 
 {
 	_taskInfo=_this;
 	_taskName=_taskInfo select 0;
	_position=_taskInfo select 4;
	_started=false;
	_grp=nil;	
	_position= (nearestBuilding _position) buildingPos 0;
					//////// GENERATE GROUP
				_grp=[EAST,_position] call stwf_generateSquad;
				/*for "_i" from 1 to 1 do 
				{
				 _grp2=[EAST,_position] call stwf_generateSquad;
				 (units _grp2) join _grp;
				};*/
				(leader _grp) setPosATL _position;
				_WP001 = _grp addWaypoint [_position, 0];
				_WP001 setWaypointType "HOLD";
				sleep 10;
				///////////////////////
				/*
				CBA_fnc_taskDefend;
				_group	the group <GROUP, OBJECT>
				_position	centre of area to defend <ARRAY, OBJECT, LOCATION, GROUP> (Default: _group)
				_radius	radius of area to defend <NUMBER> (Default: 50)
				_threshold	minimum building positions required to be considered for garrison <NUMBER> (Default: 3)
				_patrol	chance for each unit to patrol instead of garrison, true for default, false for 0% <NUMBER, BOOLEAN> (Default: 0.1)
				_hold	chance for each unit to hold their garrison in combat, true for 100%, false for 0% <NUMBER, BOOLEAN> (Default: 0)
				*/
				[ _grp, _position, 50, 4, 0.1, 0.7] call CBA_fnc_taskDefend;
				//nul = [unit,radius,max units to garrison, max units per patrol,info] execVM "tog_garrison_script.sqf";
				//[leader _grp]  execVM "a3_custom\STWGarrison\tog_garrison_script.sqf";
				//[leader _grp,250,20,4,true]  execVM "a3_custom\STWGarrison\tog_garrison_script.sqf";
				//_grp2=[EAST,_position] call stwf_generateSquad;
				//[leader _grp2, getPos leader _grp2, 250] call bis_fnc_taskPatrol;
				diag_log "Ungarrison mission launched";
				_started=true;
			
 	_completed=false;
	//[_taskName,"assigned"] call FHQ_fnc_ttSetTaskState;
	[west, "HQ"] sideChat "Attack building.";
 	while {!_completed} do
 	{
		sleep 5;
		if (isNil "_grp") exitWith {[_taskName,"cancelled"] call FHQ_fnc_ttSetTaskState;_completed=true;};
		_groupIsDead=[_grp] call stwf_GroupIsDead;
		if (_groupIsDead) then
		{
			[_taskName,"succeeded"] call FHQ_fnc_ttSetTaskState;
			[west, "HQ"] sideChat "The building is now yours.";
			_completed=true;
		};
 	};
 };
 _missionTask;
};

//[MissionName,position2D]
stwf_launchDefendBuildingMission=
{
 params ["_missionName","_position2D","_cityName"];
 _missionTask =[_missionName,"Defend Buildings at "+_cityName,_cityName+" Defend Building",_cityName,_position2D,"Defend"];
 diag_log format ["Defend MISSION %1 has been created.",_missionName];
 _missionTask spawn 
 {
 	_taskInfo=_this;
 	_taskName=_taskInfo select 0;
	_position=_taskInfo select 4;
	_started=false;
	_grp=nil;	
	_grps=[];
	
	while {!_started} do
	{
		_nonFlyingPlayers=[] call stwf_AllPlayersNotFlying;
		{
		_player=_x;
			if (_player distance2D _position < 10) then
			{
				[_taskName,"assigned"] call FHQ_fnc_ttSetTaskState;
				[west, "HQ"] sideChat "Groups approaching. Defend position";
				_grpPositions=[getPos _player,300] call stwf_getOctogonalPositionsSurroundingPlayer;
				for "_i" from 1 to 1 do
				{				
					_grpPosition=selectRandom _grpPositions;
					_grp=[EAST,_grpPosition] call stwf_generateSquad;
					// Use parachutes:
					{
					  _height=getTerrainHeightASL _grpPosition;
					  _unitPos=[(_grpPosition select 0),(_grpPosition select 1),_height+300+10*(floor random 10)];
					  _x setPos _unitPos;
					  [objNull, _x] call BIS_fnc_curatorObjectEdited;
					} forEach units _grp;
					
					_grps pushBack _grp;
					_wpoint=_grp addWaypoint [_position, 10];
					_wpoint setWaypointType "SAD";
					sleep (240+(floor random 120));
				};
				diag_log "Defend mission launched";
				_started=true;
			};
			if (_started) exitWith {true;};
		} forEach _nonFlyingPlayers;
		sleep 5;
	};
 	_completed=false;
	
	
 	while {!_completed} do
 	{
		//sleep 5;
		//if (isNil "_grps") exitWith {[_taskName,"cancelled"] call FHQ_fnc_ttSetTaskState;_completed=true;};
		//if (count _grps==0) exitWith {[_taskName,"cancelled"] call FHQ_fnc_ttSetTaskState;_completed=true;};
		//if ( (_grps call stwf_AliveGroups)==0 ) then
		//{
		//	_completed=true;
		//};
		sleep 5;
		if (isNil "_grp") exitWith {[_taskName,"cancelled"] call FHQ_fnc_ttSetTaskState;_completed=true;};
		_groupIsDead=[_grp] call stwf_GroupIsDead;
		if (_groupIsDead) then
		{
			[_taskName,"succeeded"] call FHQ_fnc_ttSetTaskState;
			[west, "HQ"] sideChat "The building is now yours.";
			_completed=true;
		};
 	};
	diag_log format ["Mission completed %1",_taskName];
	[west, "HQ"] sideChat "The position is now yours.";
	[_taskName,"succeeded"] call FHQ_fnc_ttSetTaskState;
 };
 _missionTask;
};


//[MissionName,building]
stwf_launchRearmMission=
{
 params ["_missionName","_building","_cityName"];
 _innerBuildingPositions=[_building] call BIS_fnc_buildingPositions;
 _nInnerBuildingPositions=count _innerBuildingPositions;
 _position2D=getPos _building;
 _missionTask =[_missionName,"Rearm at "+_cityName,_cityName+" Rearm",_cityName,_position2D,"Box"];
 diag_log format ["Rearm MISSION %1 has been created.",_missionName];
 _box = createVehicle ["Box_NATO_Equip_F", selectRandom _innerBuildingPositions, [], 0, "NONE"];
 0 = ["AmmoboxInit",[_box,true]] spawn BIS_fnc_arsenal; 
 _missionTask spawn 
 {
 	_taskInfo=_this;
 	_taskName=_taskInfo select 0;
	_position=_taskInfo select 4;
	//// GENERATE GROUP
	_grp=[EAST,_position] call stwf_generateSquad;
	/*for "_i" from 1 to 4 do 
	{
		 _grp2=[EAST,_position] call stwf_generateSquad;
		 (units _grp2) join _grp;
	};*/
	
	_completed=false;
	
 	while {!_completed} do
	{
		_nonFlyingPlayers=[] call stwf_AllPlayersNotFlying;
		{
		_player=_x;
			if (_player distance2D _position < 5) then
			{
				[_taskName,"succeeded"] call FHQ_fnc_ttSetTaskState;
				_completed=true;
			};
		} forEach _nonFlyingPlayers;
		if (_completed) exitWith {true;};
		sleep 5;
	};
 };
 _missionTask;
};



stwf_selectTargetBuildingPosition=
{
    params ["_position2D","_radius"];
	_position2D=_this select 0;
	_radius=_this select 1;
	_enterableBuildings=[_position2D,_radius] call stwf_getAreaEnterableBuildings;
	_nearestBuilding=nearestBuilding _position2D;
	
	if (!isNil("_nearestBuilding")) then
	{
		if (_nearestBuilding distance _position2D < _radius) then 
		{
			_buildingSize=_nearestBuilding call stwf_size_of_building;
			if (_buildingSize>8) then
			{
				diag_log format ["Building size %1", _buildingSize];
				_enterableBuildings pushBack _nearestBuilding;
			};
		};
	};
	diag_log format ["Enterable buildings are: %1",_enterableBuildings];
	_selectedBuilding=selectRandom _enterableBuildings;
	if (!isNil("_selectedBuilding")) then
	{
		_position2D=getPos _selectedBuilding;
		diag_log format ["Enterable building selected %1",_position2D];
		
	} else
	{
		_buildings = nearestObjects [player, ["Building","House"], _radius];
		diag_log format ["Buildings are: %1",_buildings];
		_selectedBuilding=selectRandom _buildings;
		if (!isNil("_selectedBuilding")) then
		{
			_position2D=getPos _selectedBuilding;
			diag_log format ["Building selected %1",_position2D];
		
		} else
		{
		_randomPos=[(_position2D select 0)-(random _radius/2)+(random _radius/2),(_position2D select 1)-(random _radius/2)+(random _radius/2)];
		_position2D=_randomPos;
		diag_log format ["Random Position selected %1",_position2D];
		};
	};
	_position2D;
};

stwf_NumberOfPendingTasks=
{
//"succeeded", "failed", "canceled", "created", "assigned"
  _pending=[];
 {
  _taskName=(_x select 1) select 0;
  _taskState=[_taskName] call FHQ_fnc_ttGetTaskState;
  
  diag_log format ["TASK NAME %1 STATE %2",_taskName,_taskState];
  if (
	(_taskState!="succeeded") &&
	(_taskState!="failed") &&
	(_taskState!="canceled")  ) then
	{
		_pending pushBack _taskName;
	};
  
 } forEach FHQ_TTI_TaskList;
 diag_log format ["PENDING %1",_pending];
 
 (count _pending);
};

// Select all units of side X at a range from position.
stwf_selectAllUnitsOfSideInRange={
 params ["_side","_position","_distance"];
 _result=[];
  
 {
  _unit=_x;
   if ((side _unit == _side) AND (_unit distance _position < _distance)) then 
  {
	_result pushBack _unit;
  };
 } foreach AllUnits;
 
 _result
};

stwf_GenerateCitiesMissionsTasks=
{
	[] spawn {
		_count=0;

		{
			_position2D = [(_x select 2) select 0,(_x select 2) select 1];
			_cityName= _x select 1;
			_citySize= _x select 4;
			
			if ((STW_CONQUERED_CITIES find _cityName)<0) then
			{
				_newMissions=[west];
				_missionName="";
				//STW_TASKS_BRIEFING pushBack [_cityName,_cityName];
				_missiontype=selectRandom [1,2,3,4,5,6,7,8];
				
				if (_missiontype==1) then
				{ 
					_missionName="Move To "+str _count;
					_count=_count+1;
					_randomPos=[(_position2D select 0)-(random 500)+(random 500),(_position2D select 1)-(random 500)+(random 500)];
					_missionTask=[_missionName,_randomPos,_cityName] call stwf_launchMoveToMission;
					_position= _position2D;
					//////// GENERATE GROUP
					_grp=[EAST,_position] call stwf_generateSquad;
					/*for "_i" from 1 to 4 do 
					{
					 _grp2=[EAST,_position] call stwf_generateSquad;
					 (units _grp2) join _grp;
					};*/
					///////////////////////
					_newMissions pushBack _missionTask;
				}; 
				
				if (_missiontype==2) then
				{ 
					//for "_i" from 1 to 5 do 
					//{
					_missionName="ClearBuilding"+str _count;
					_count=_count+1;
					//_position2D=[_position2D,2000] call stwf_selectTargetBuildingPosition;
					_building=selectRandom STWG_HUGE_OR_TALL_BUILDINGS_OF_STRATEGICAL_INTEREST;
					_position2D=getPos _building;
					_missionTask=[_missionName,_position2D,_cityName] call stwf_launchAttackBuildingMission;
					//STW_MISSION_TASKS_WEST pushBack _missionTask;
					_newMissions pushBack _missionTask;
					//};
				}; 
				
				//for "_i" from 1 to 1 do 
				if (_missiontype==3) then
				{ 
					_missionName="DefendPosition"+str _count;
					_count=_count+1;
					//_position2D=[_position2D,5000] call stwf_selectTargetBuildingPosition;
					_building=selectRandom STWG_HUGE_OR_TALL_BUILDINGS_OF_STRATEGICAL_INTEREST;
					_position2D=getPos _building;
					_missionTask=[_missionName,_position2D,_cityName] call stwf_launchDefendBuildingMission;
					//STW_MISSION_TASKS_WEST pushBack _missionTask;
					_newMissions pushBack _missionTask;
				}; 
				
				if (_missiontype==4) then
				{ 
					_missionName="Rearm at "+str _count;
					_count=_count+1;
					_building=selectRandom ([_position2D,500]  call stwf_getAreaEnterableBuildings);
					if (!isNil "_building") then
					{
						_missionTask=[_missionName,_building,_cityName] call stwf_launchRearmMission;
						
						_position=getPos _building;
						//////// GENERATE GROUP
						_grp=[EAST,_position] call stwf_generateSquad;
						/*for "_i" from 1 to 4 do 
						{
						 _grp2=[EAST,_position] call stwf_generateSquad;
						 (units _grp2) join _grp;
						};*/
						///////////////////////
						//STW_MISSION_TASKS_WEST pushBack _missionTask;
						_newMissions pushBack _missionTask;
						//This is NOT a pending task, ream missions never end.
					};
				};
				
				if (_missiontype==5) then
				{ 
					_position=[] call stwf_getRandomPosition;
					_retries=0;
					while {(surfaceIsWater _position)&&(retries<25)} do
					{
					 _position=[] call stwf_getRandomPosition;
					 _retries=_retries+1;
					};
					[_position] call stwf_generateBlowUpMission;
				};
				
				
				if (_missiontype==6) then
				{
					_missionName="Recover vehicle at "+str _count;
					_count=_count+1;
					_position=[] call stwf_getRandomPosition;
					_retries=0;
					while {(surfaceIsWater _position)&&(_retries<25)} do
					{
					 _position=[] call stwf_getRandomPosition;
					 _retries=_retries+1;
					};
					if (!isNil "_position") then
					{
						_missionTask=[_missionName,_position,_cityName] call stwf_launchRecoverVehicle;
						if (!isNil("_missionTask")) then
						{
							_newMissions pushBack _missionTask;
						};
						//////// GENERATE GROUP
						_grp=[EAST,_position] call stwf_generateSquad;
						/*for "_i" from 1 to 4 do 
						{
						 _grp2=[EAST,_position] call stwf_generateSquad;
						 (units _grp2) join _grp;
						};*/
						///////////////////////
					};
				};
				
				if (_missiontype==7) then
				{
					_missionName="Recover helicopter at "+str _count;
					_count=_count+1;
					_position=[] call stwf_getRandomPosition;
					_retries=0;
					while {(surfaceIsWater _position)&&(_retries<25)} do
					{
					 _position=[] call stwf_getRandomPosition;
					 _retries=_retries+1;
					};
					if (!isNil "_position") then
					{
						_missionTask=[_missionName,_position,_cityName] call stwf_launchRecoverHelicopter;
						//////// GENERATE GROUP
						_grp=[EAST,_position] call stwf_generateSquad;
						/*for "_i" from 1 to 4 do 
						{
						 _grp2=[EAST,_position] call stwf_generateSquad;
						 (units _grp2) join _grp;
						};*/
						///////////////////////

						if (!isNil("_missionTask")) then
						{
							_newMissions pushBack _missionTask;
						};
					};
				};
				
				if (_missiontype==8) then
				{
				    _position=[] call stwf_getRandomPosition;					
					_retries=0;
					while {(surfaceIsWater _position)&&(_retries<25)} do
					{
					 _position=[] call stwf_getRandomPosition;
					 _retries=_retries+1;
					};
					if (!isNil "_position") then
					{
						_eastUnits=[EAST,_position,2500] call stwf_selectAllUnitsOfSideInRange;
						if (count _eastUnits > 0) then
						{
							_unit=selectRandom _eastUnits;
							_missionName="Kill"+(name _unit)+str _count;
							_count=_count+1;
							_missionTask=[_missionName,_unit] call stwf_launchDestroyUnitMission;
							if (!isNil("_missionTask")) then
							{
								_newMissions pushBack _missionTask;
							};
						};
					};
				};
					
				diag_log  format ["====Adding new missions==="];
				if ((count _newMissions)>1) then {
					diag_log format ["NEW TASK==>%1",_newMissions];
					_newMissions call FHQ_fnc_ttAddTasks;
					
					[_missionName,"created"] call FHQ_fnc_ttSetTaskState;
					
				};
				
			} else
			{
						//DO NOTHING WITH CONQUERED CITIES
			};

			_pendingTasks=[] call stwf_NumberOfPendingTasks;
			while {_pendingTasks>STWG_NUMBER_OF_TASKS} do
			{
				sleep 120;
				_pendingTasks=[] call stwf_NumberOfPendingTasks;
				//diag_log format ["Pending tasks: %1",_pendingTasks];
			};
	

		} forEach STW_MISSION_SITES;
	};
};

[] call stwf_GenerateSTW_MISSION_SITESArray;
[] call stwf_GenerateCitiesMissionsTasks;