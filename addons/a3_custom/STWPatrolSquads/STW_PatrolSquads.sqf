#ifndef  STW_PatrolSquads_Module_Loaded
#define STW_PatrolSquads_Module_Loaded true
diag_log "STW_PatrolSquads_Module_Loaded Loaded";

if (!isServer) exitWith{};
waitUntil {(count ([] call BIS_fnc_listPlayers))>0};

diag_log format ["STW_PATROL_SQUADS_MODULE STARTING"];


STW_ACTIVE_PATROLLING_SQUADS=[];
/*
STW_MAXDISTPLAYERSTOSQUADS=8000;
STW_MINDIST2PLAYERSONSPAWN=50;
STW_MAXDIST2PLAYERSONSPAWN=2000;
*/

/////
stwf_spawnPatrolSquad=
{
	diag_log format["stwf_spawnPatrolSquad called with:%1",_this];
	_side = selectRandom STWG_PATROL_SQUADS_SIDE_PROBABILITY;
	_squadPos=_this select 0;
	_grp=[_side,_squadPos] call stwf_generateSquad;
	_grp setBehaviour (selectRandom ["COMBAT","CARELESS","SAFE","AWARE","STEALTH"]);
	_grp deleteGroupWhenEmpty true;
	
	/*{
	 _unit=_x;
		{
			_zeus=_x;
			_zeus addCuratorEditableObjects [[_unit],true];
		} forEach allCurators;
	} forEach units _grp;*/
	
	_scriptPath="PATH";
	if (STWG_NO_ADDON_MODE) then
	{
		_scriptPath="@STWCustom\addons\a3_custom\STWPatrolSquads\STW_RefreshPatrolSquadsWayPoint.sqf";
	} else
	{	
		_scriptPath="a3_custom\STWPatrolSquads\STW_RefreshPatrolSquadsWayPoint.sqf";
	};
	
	_grp execVm _scriptPath;
	_grp spawn 
	{
		_grp=_this;
		_markerName = format ["GroupSpawn%1",_grp];
		
		while {(count units _grp)>0} do
		{	
			_leader= leader _grp;
			_oldPosition= getPos _leader;
			
			deleteMarker _markerName;
			createMarker [_markerName,_oldPosition];
			_markerName setMarkerShape "Icon";
			_markerName setMarkerType "mil_warning"; 
			
			if ((side _grp) == west) then
			{
			  _markerName setMarkerColor "colorBlue";
			} else
			{
			 _markerName setMarkerColor "colorRed";
			};
			
			sleep 60;
			_position= getPos _leader;
			_checkDistance=_position distance _oldPosition;
			
			
			
			//diag_log format ["Check distance:%1",_checkDistance];
//			if ( _checkDistance < 5) then
//			{
//				diag_log format ["Squad not moving, delete"];
//				_index =STW_ACTIVE_PATROLLING_SQUADS find _grp;
//				STW_ACTIVE_PATROLLING_SQUADS deleteAt _index;
//				{
//					deleteVehicle _x; 
//					_x setDamage [1,false];
//				} forEach units _grp;
//				deleteGroup _grp;
//			} else
//			{
//				diag_log format ["Squad is moving"];
//			};
	/*		_minDistToPlayers=[getPos (leader _grp)] call stwf_getMinimumDistanceToPlayers;
			if (_minDistToPlayers>STW_MAXDISTPLAYERSTOSQUADS) then
			{
				//diag_log format ["Squad too far from players, delete"];
				_index =STW_ACTIVE_PATROLLING_SQUADS find _grp;
				STW_ACTIVE_PATROLLING_SQUADS deleteAt _index;
				{
					deleteVehicle _x; 
					_x setDamage [1,false];
				} forEach units _grp;
				deleteGroup _grp;
			};
	*/
		};
		deleteMarker _markerName;
	};
	_grp;
};



		
stwf_controlPatrollingSquadsService=
{
	while {true} do 
	{
	 waitUntil {count allPlayers>0};
	 diag_log format["STW PATROLLING SQUADS CHECK. NUMBER OF SQUADS %1 , OF MAX %2",count STW_ACTIVE_PATROLLING_SQUADS,STWG_NUM_PATROLLING_SQUADS];
	 _retries=0;
	 while {(count STW_ACTIVE_PATROLLING_SQUADS<STWG_NUM_PATROLLING_SQUADS)&& (_retries<9)} do
	 {
	  _center = call stwf_getCenterOfMap;
	  _poi= selectRandom ([_center,8000] call stwf_getNearbyStrategicalPointsOfInterest);
	  
	  diag_log format["POI to attack %1",_poi];
	  _position = _poi select 2;
	  
				/*[
				STW_MINDIST2PLAYERSONSPAWN,
				STW_MAXDIST2PLAYERSONSPAWN
				] call stwf_getRandomPositionInRangeForAllPlayers;
				*/
	  
	  
	  /*
	  _playerPos=(getPos selectRandom allPlayers);
      _position= [_playerPos,
				STW_MINDIST2PLAYERSONSPAWN,
				STW_MAXDIST2PLAYERSONSPAWN
				] call stwf_getRandomPositionInRange;
	  
	  //_octoPos=[_playerPos,STW_MAXDISTPLAYERSTOSQUADS-random 250] call stwf_getOctogonalPositionsSurroundingPlayer;
	  //_position= getPos (selectRandom ((selectRandom _octoPos) nearRoads 500));
      _position= [] call stwf_getRandomPosition2D;
	  _cities=[_playerPos,10000] call stwf_getNearbyCitiesOrVillages;
	  _distanceToPlayer=0;
	  _posretries=0;
	  _cityPos=_position;
	  while {(_distanceToPlayer<STW_MAXDISTPLAYERSTOSQUADS)&&(_posretries<9)} do
	  {
		_city=selectRandom _cities;
		_cityPos=_city call stwf_getCityPosition;
		_distanceToPlayer=_cityPos distance _playerPos;
		_posretries=_posretries+1;
	  };
	  
	  if (_distanceToPlayer>STW_MAXDISTPLAYERSTOSQUADS) then
	  {
		_position=_cityPos;
	  };
	  _position= getPos (selectRandom (_position nearRoads 500));*/
	  if (!(isNil "_position")) then
	  {
	   if (!(surfaceIsWater _position)) then
	   {
		
			_grp= [_position] call stwf_spawnPatrolSquad;
			// Use parachutes:
			{
			  _height=getTerrainHeightASL _position;
			  _unitPos=[(_position select 0),(_position select 1),_height+300+10*(floor random 10)];
			   //diag_log format["SPAWN POSITION %1",_unitPos];
			  _x setPos _unitPos;
			  [objNull, _x] call BIS_fnc_curatorObjectEdited;
			} forEach units _grp;
			
			
			STW_ACTIVE_PATROLLING_SQUADS pushBack _grp;
		};
	  };
	  _retries=_retries+1;
	  //sleep 5;
	 };
	  sleep 30;
	  //Delete dead vehicles so that they are created in the next loop
	  /*{
		_grp=_x;
		if ((count units _grp)<1) then
		{
		 _index =STW_ACTIVE_PATROLLING_SQUADS find _grp;
		 STW_ACTIVE_PATROLLING_SQUADS deleteAt _index;
		 _minDistToPlayers=[getPos (leader _grp)] call stwf_getMinimumDistanceToPlayers;
		 if (_minDistToPlayers>STW_MAXDISTPLAYERSTOSQUADS) then
			{
				//diag_log format ["Squad too far from players, delete"];
				{
					deleteVehicle _x; 
					_x setDamage [1,false];
				} forEach units _grp;
				deleteGroup _grp;
			};
		};
	  } forEach STW_ACTIVE_PATROLLING_SQUADS; */
	};
	//sleep 60;
};

diag_log format ["STW_PATROL_SQUADS_MODULE LAUNCHING"];
[] call stwf_controlPatrollingSquadsService;

#endif