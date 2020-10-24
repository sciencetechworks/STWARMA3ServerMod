STW_MAXDIST_PLAYERS_ARMT_WPTS=2500;

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



_stwfRefresArmouredTrafficWaypoint=
{
	//diag_log "_stwfRefresArmouredTrafficWaypoint called";
	_grp = _this;
	_leader = leader _grp;
	_veh = vehicle _leader;
	_retries=0;
	_destinationPosition=nil;
	while {(_retries<20)&&(isNil "_destinationPosition")} do
	{
		_position = selectRandom ([getPos _leader,50+random STW_MAXDIST_PLAYERS_ARMT_WPTS] call stwf_getOctogonalPositionsSurroundingPlayer);
		_nearRoads= _position nearRoads 1000;
		if ((!isNil "_nearRoads")&&(count _nearRoads>0)) then
		{
			_destinationRoad=selectRandom _nearRoads;
			_destinationPosition=getPos _destinationRoad;
		}else
		{
			_destinationPosition=_position;
		};
		
		if (surfaceIsWater _position) then
		{
			_destinationPosition=nil;
		};
		
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
		
		if (!isNil "_destinationPosition") then
		{
			_distanceFromPlayers=[_destinationPosition] call stwf_getMinimumDistanceToPlayers;
			//avoid getting too far
			if (_distanceFromPlayers<STW_MAXDIST_PLAYERS_ARMT_WPTS) then
			{
				_wpoint=_grp addWaypoint [_destinationPosition, 0];
				_wpoint setWaypointType "SAD";
				_wpoint setWaypointStatements ["true", "if (!isServer) exitWith{}; nul = (group this) execVM ""a3_custom\STWArmouredTraffic\STW_RefreshArmouredTrafficWaypoint.sqf"""];
			} else
			{
				_destinationPosition=nil;
			};
		};
		_retries=_retries+1;
		sleep 5;
	};
};

_this call _stwfRefresArmouredTrafficWaypoint;