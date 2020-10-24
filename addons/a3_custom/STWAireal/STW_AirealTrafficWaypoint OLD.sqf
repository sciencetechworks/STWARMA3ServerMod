STW_MAXDIST_PLAYERS_AIRT_WPTS=4000;

//Get the forbiddenaIRTrafficMarkers
stwf_getForbiddenTrafficMarkers=
{
	"NOAIRTraffic" call stwf_GetMarkersStartingWith;
};




_stwfRefresaIRTrafficWaypoint=
{
	_grp = _this;
	_leader = leader _grp;
	_veh = vehicle _leader;
	_retries=0;
	_destinationPosition=nil;
	while {(_retries<20)&&(isNil "_destinationPosition")} do
	{
		//_octoPos=[getPos _leader,STW_MAX_DISTANCE_FROM_PLAYERS_FOR_AIR_TRAFFIC] call stwf_getOctogonalPositionsSurroundingPlayer;
		//_position= selectRandom _octoPos;
		//_height = getTerrainHeightASL _position;
		//_position3D = [_position select 0,_position select 1, _height+200 ];
		_position= [] call stwf_getRandomPosition2D;
		_height = getTerrainHeightASL _position;
		_position3D = [_position select 0,_position select 1, (random 200)+(_height+50) ];
		
		_destinationPosition=_position3D;
		
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
			//_distanceFromPlayers=[_destinationPosition] call stwf_getMinimumDistanceToPlayers;
			//avoid getting too far
			//if (_distanceFromPlayers<STW_MAXDIST_PLAYERS_AIRT_WPTS) then
			//{
				_wpoint=_grp addWaypoint [_destinationPosition, 0];
				_wpoint setWaypointType "Move";
				_wpoint setWaypointStatements ["true", "if (!isServer) exitWith{}; nul = (group this) execVM ""a3_custom\STWAireal\STW_AirealTrafficWaypoint.sqf"""];
			//} else
			//{
			//	_destinationPosition=nil;
			//};
		};
		_retries=_retries+1;
		sleep 5;
	};
};

_this call _stwfRefresaIRTrafficWaypoint;