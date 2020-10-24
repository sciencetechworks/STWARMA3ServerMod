STW_MAXDIST_PLAYERS_FOR_SQUADS_WPTS=60000;


_stwfRefresPatrolSquadWaypoint=
{
	//diag_log "_stwfRefresCivilTraficWaypoint called";
	_grp = _this;
	_leader = leader _grp;
	_veh = vehicle _leader;
	_retries=0;
	_destinationPosition=nil;
	while {(_retries<20)&&(isNil "_destinationPosition")} do
	{
		//_position = selectRandom ([getPos _leader,STW_MAXDIST_PLAYERS_FOR_SQUADS_WPTS-random 250] call stwf_getOctogonalPositionsSurroundingPlayer);
		waitUntil {(count allPlayers) > 0};
		_position= getPos (selectRandom allPlayers); //getPos _leader; //[] call stwf_getRandomPosition2D;
		_nearbyCities=[_position,5000] call stwf_getNearbyCitiesOrVillages;
		_destinationCity=selectRandom _nearbyCities;
		_position= _destinationCity call stwf_getCityPosition;
		_nearRoads= _position nearRoads 2500;
		
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
			_distanceFromPlayers=[_destinationPosition] call stwf_getMinimumDistanceToPlayers;
			//avoid getting too far
			if (_distanceFromPlayers<STW_MAXDIST_PLAYERS_FOR_SQUADS_WPTS) then
			{
				_wpoint=_grp addWaypoint [_destinationPosition, 0];
				_wpoint setWaypointType "Move";
				
				_execScript=
					"if (!isServer) exitWith{}; nul = (group this) execVM ""a3_custom\STWPatrolSquads\STW_RefreshPatrolSquadsWaypoint.sqf""";
				if (STWG_NO_ADDON_MODE) then
				{
					_execScript="if (!isServer) exitWith{}; nul = (group this) execVM ""@STWCustom\addons\a3_custom\STWPatrolSquads\STW_RefreshPatrolSquadsWaypoint.sqf""";
				};
				
				_wpoint setWaypointStatements ["true", _execScript];
			} else
			{
				destinationPosition=nil;
			}
		};
		_retries=_retries+1;
		sleep 5;
	};
};

_this call _stwfRefresPatrolSquadWaypoint;