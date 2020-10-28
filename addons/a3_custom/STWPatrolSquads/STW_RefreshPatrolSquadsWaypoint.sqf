STW_MAXDIST_PLAYERS_FOR_SQUADS_WPTS=10000;


_stwfRefreshPatrolSquadWaypoint=
{
	params ["_grp"];

	_leader = leader _grp;
	_selectedPositions=[];
	_previousPosition= getPos _leader; //(selectRandom allPlayers);
	for [{_i=0}, {_i<1}, {_i=_i+1}] do
	{
	  waitUntil {(count allPlayers) > 0};
	  _nearbyCities=[_previousPosition,1000] call stwf_getNearbyStrategicalPointsOfInterest;
	  _destinationCity=selectRandom _nearbyCities;
	  _destinationPosition=nil;
	  _nearRoads=nil;
	  if (!isNil("_destinationCity")) then
	  {
		_destinationPosition= _destinationCity call stwf_getCityPosition;
		_nearRoads= _destinationPosition nearRoads 200;
	  };
	  
	  if (!isNil "_nearRoads") then
	  {
	   if (count _nearRoads>0) then
	   {
	  	 _destinationRoad=selectRandom _nearRoads;
	  	 _destinationPosition=getPos _destinationRoad;
		};
	  };
	  
	  if (!isNil("_destinationPosition")) then
	  {
	   if (surfaceIsWater _destinationPosition) then
	   {
	  	 _destinationPosition=nil;
	   };
	  };
	  
	  /*if (!isNil("_destinationPosition")) then
	  {
		_distanceFromPlayers=[_destinationPosition] call stwf_getMinimumDistanceToPlayers;
		if (_distanceFromPlayers>STW_MAXDIST_PLAYERS_FOR_SQUADS_WPTS) then
		{
			_destinationPosition=nil;
		};
	  };*/

	  if (!isNil("_destinationPosition")) then
	  {
	   //diag_log format ["WP Destination %1",_destinationPosition];
	   _selectedPositions pushBack _destinationPosition;
	   _previousPosition=_destinationPosition;
	  };
	};
	
	_selectedPositions=[_selectedPositions] call stwf_orderPointsByDistancesToFirst;
	_index=0;
	_wpoint=nil;
	{
	  _wpPosition=_x;
	  _wpoint=_grp addWaypoint [_wpPosition, _index];
      _wpoint setWaypointType "Loiter";
	  _wpoint setWaypointLoiterRadius (floor random 300)+50;
	  _index=_index+1;
	  //diag_log format ["WP Added %1",_wpPosition];
	} forEach _selectedPositions;
	
	//Add script to the last waypoint
	if (!isNil("_wpoint")) then
	{
	 _execScript=
		"if (!isServer) exitWith{}; nul = (group this) execVM ""a3_custom\STWPatrolSquads\STW_RefreshPatrolSquadsWaypoint.sqf""";
	 if (STWG_NO_ADDON_MODE) then
	 {
		_execScript="if (!isServer) exitWith{}; nul = (group this) execVM ""@STWCustom\addons\a3_custom\STWPatrolSquads\STW_RefreshPatrolSquadsWaypoint.sqf""";
	 };
	 _wpoint setWaypointStatements ["true", _execScript];
	};
	sleep (floor random 300)+120;
};

[_this] call _stwfRefreshPatrolSquadWaypoint;