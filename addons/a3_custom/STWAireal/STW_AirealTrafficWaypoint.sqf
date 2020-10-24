STW_MAXDIST_PLAYERS_AIRT_WPTS=4000;

//Get the forbiddenaIRTrafficMarkers
stwf_getForbiddenTrafficMarkers=
{
	"NOAIRTraffic" call stwf_GetMarkersStartingWith;
};




_stwfRefreshAirTrafficWaypoint=
{
	params ["_grp"];

	_leader = leader _grp;
	_selectedPositions=[];
	_previousPosition= getPos _leader;
	_firstPosition=_previousPosition;
	for [{_i=0}, {_i<8}, {_i=_i+1}] do
	{
	  waitUntil {(count allPlayers) > 0};
	  _nearbyCities=[_previousPosition,10000] call stwf_getNearbyStrategicalPointsOfInterest;
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
	  	  
	  /*if (!isNil("_destinationPosition")) then
	  {
		_distanceFromPlayers=[_destinationPosition] call stwf_getMinimumDistanceToPlayers;
		if (_distanceFromPlayers>STW_MAXDIST_PLAYERS_FOR_SQUADS_WPTS) then
		{
			_destinationPosition=nil;
		};
	  };*/
	  
	  if (!isNil "_destinationPosition") then
		{
			_posA=getPos _leader;
			_posB=_destinationPosition;
			_line=[[_posA select 0,_posA select 1],[_posB select 0,_posB select 1]];
			
			_forbiddenZones=[] call stwf_getForbiddenTrafficMarkers;
			{
				_marker=_x;
				_markerPos= getMarkerPos _marker;
				_circumPos=[_markerPos select 0,_markerPos select 1];
				_circumRadius=500;
				if (_circumPos distance2D (_line select 0)<_circumRadius ) exitWith{_destinationPosition=nil};
				if (_circumPos distance2D (_line select 1)<_circumRadius ) exitWith{_destinationPosition=nil};
				_info=[_line,[_circumPos,_circumRadius]];
				//diag_log format ["INFO %1",_info];
				_intersects=_info call stwf_CircleLineIntersection;
				if (_intersects ) exitWith{_destinationPosition=nil};
			} foreach _forbiddenZones;
		};

	  if (!isNil("_destinationPosition")) then
	  {
	   //diag_log format ["WP Destination %1",_destinationPosition];
	    _height = getTerrainHeightASL _destinationPosition;
		_flyHeight = (random 200)+(_height+50);
		_position3D = [_destinationPosition select 0,_destinationPosition select 1, _flyHeight ];
		_destinationPosition=_position3D;
	    _selectedPositions pushBack _destinationPosition;
	    _previousPosition=_destinationPosition;
	  };
	};
	
	_selectedPositions=[_selectedPositions] call stwf_orderPointsByDistancesToFirst;
	// close the circular path:
	_selectedPositions pushBack _firstPosition;
	
	_index=0;
	_wpoint=nil;
	{
	  _wpPosition=_x;
	  _wpoint=_grp addWaypoint [_wpPosition, _index];
      _wpoint setWaypointType "Move";
	  _index=_index+1;
	  //diag_log format ["WP Added %1",_wpPosition];
	} forEach _selectedPositions;
	
	//Add script to the last waypoint
	if (!isNil("_wpoint")) then
	{
	 _execScript=
		"if (!isServer) exitWith{}; nul = (group this) execVM ""a3_custom\STWAireal\STW_AirealTrafficWaypoint.sqf""";
	 if (STWG_NO_ADDON_MODE) then
	 {
		_execScript="if (!isServer) exitWith{}; nul = (group this) execVM ""@STWCustom\addons\a3_custom\STWAireal\STW_AirealTrafficWaypoint.sqf""";
	 };
	 _wpoint setWaypointStatements ["true", _execScript];
	};
	
};

_this call _stwfRefreshAirTrafficWaypoint;