#ifndef  STW_Common_Module_Loaded
#define STW_Common_Module_Loaded true
diag_log "STW_Common_Module Loaded";
// Avoid library reloading by defining it:
//if (!isNil("STW_COMMON_LIBRARY_DEFINED")) exitWith {};
//STW_COMMON_LIBRARY_DEFINED=true;

/***
<DEBUGGING FRAMEWORK>
***/
//Debug activation
STW_DBG_ACTIVE=true;

/**
Shows a list into the log
**/
stwf_showListInLog= {
	params ["_name","_theList"];
	diag_log format ["%1=[",_name];
	_i=0;
	_nelem=count _theList;
	{
		_elem=_x;
		_i=_i+1;
		if (_i!=_nelem) then {
			diag_log format ["%1,",_elem];
		} else {
			diag_log format ["%1",_elem];
		};
	}
	forEach _theList;
	diag_log format ["];"];
};

/**
Shows code into the log
**/
stwf_showCodeInLog= {
	params ["_theCode"];
	_strList= _theCode splitString ";";
	{
		diag_log format ["%1;",_x];
	}
	forEach _strList;
};

/**
Output debug
**/
stw_dbg= {
	params ["_functionName","_message"];
	if (!(isNil "STW_DBG_ACTIVE")) then
	{
		diag_log format ["STW_DEBUG::"+_functionName+"::"+_message];
	};
};

/**
Activate debugging
**/
stw_activate_dbg= {
	STW_DBG_ACTIVE=true;
};

/**
Deactivate debugging
**/
stw_deactivate_dbg= {
	STW_DBG_ACTIVE=nil;
};

/***
</DEBUGGING FRAMEWORK>
***/


/**
Get location Type
**/
stwf_getLocationType={
	params ["_location"];
	_location select 0;
};

/**
Get location Name
**/
stwf_getLocationName={
	params ["_location"];
	_location select 1;
};

/**
Get location Center
**/
stwf_getLocationCenter={
	params ["_location"];
	_location select 2;
};

/**
Get location SizeDim
**/
stwf_getLocationSizeDim={
	params ["_location"];
	_location select 4;
};

/**
Get location Size
**/
stwf_getLocationSize={
	params ["_location"];
	_locationDim= [_location] call stwf_getLocationSizeDim;
	(_locationDim select 0)*(_locationDim select 1);
};

/**
Get location Height
**/
stwf_getLocationHeight={
	params ["_location"];
	_locationPos= [_location] call stwf_getLocationCenter;
	_locationPos select 2;
};


/**
Get locations of the given types
**/
stwf_getLocationsOfTypes= {
	params ["_locationTypesList"];
	["stwf_getLocationsOfTypes","Function start"] call stw_dbg;
	_result=[];
	{
		_lctype=_x;
		{
			_result pushBack [_lctype,text _x, locationPosition _x, direction _x, size _x, rectangular _x];
		}
		forEach nearestLocations [getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition"), [_x], worldSize];
	}
	forEach _locationTypesList;

	["stwf_getLocationsOfTypes","Function end"] call stw_dbg;
	_result;
};


/**
Return all cities surrounding a position.
// Finds the locations that surround a position in a given radius.
// Receives: [position,radius]
**/
stwf_getNearbyCitiesOrVillages= {
	params ["_position","_radius"];
	//diag_log format ["stwf_getNearbyCitiesOrVillages %1 %2",_position,_radius];
	_lcTypes=["NameVillage", "NameCity", "NameCityCapital"];
	//, "NameLocal", "NameCityCapital","AirPort","Hill", "BorderCrossing","Strategic","StrongPointArea"];
	_nearbyCities=[];
	{
		_lctype=_x;
		//diag_log format ["nearestLocations [%1, [%2], %3]",_position,_lctype,_radius];
		_foundLocations=  nearestLocations [_position, [_lctype], _radius];
		{
			_location=_x;
			_nearbyCities pushBack [
			_lctype,text _location,
			locationPosition _location,
			direction _location,
			size _location,
			rectangular _location
			];
		}
		forEach _foundLocations;
	}
	forEach _lcTypes;
	_nearbyCities
};

/**
Get the strategical points of interest.
**/
stwf_getNearbyStrategicalPointsOfInterest= {
	params ["_position","_radius"];
	_lcTypes=["NameVillage", "NameCity", "NameCityCapital","NameLocal", "NameCityCapital","AirPort","Hill", "BorderCrossing","Strategic","StrongPointArea","NameMarine"];
	_nearbyPOIs=[];
	{
		_lctype=_x;
		//diag_log format ["nearestLocations [%1, [%2], %3]",_position,_lctype,_radius];
		_foundLocations=  nearestLocations [_position, [_lctype], _radius];
		{
			_location=_x;
			_nearbyPOIs pushBack [
			_lctype,text _location,
			locationPosition _location,
			direction _location,
			size _location,
			rectangular _location
			];
		}
		forEach _foundLocations;
	}
	forEach _lcTypes;
	_nearbyPOIs
};


/**
Get All Cities, including capital cities.
**/
stwf_getAllCities={
	params [];
	["stwf_getAllCities","Function start"] call stw_dbg;

	if (!(isNil "STW_LOCATION_TOWNS")) exitWith
	{
		["stwf_getAllCities","(CACHED) Cities got"] call stw_dbg;
		["stwf_getAllCities","Function end"] call stw_dbg;
		STW_LOCATION_TOWNS;
	};

	STW_LOCATION_TOWNS=[["NameCity", "NameCityCapital"]] call stwf_getLocationsOfTypes;


	["stwf_getAllCities","Function end"] call stw_dbg;
	STW_LOCATION_TOWNS;
};

/**
Get All Possible Location Type Names
**/
stwf_getLocationTypeNames= {
	_return=[//Armed Assault
	//"Mount",
	//"Name",
	//"NameMarine",
	//"NameCityCapital",
	//"NameCity",
	//"NameVillage",
	//"NameLocal",
	//"Hill",
	//"ViewPoint",
	//"RockArea",
	//"BorderCrossing",
	//"VegetationBroadleaf",
	//"VegetationFir",
	//"VegetationPalm",
	//"VegetationVineyard",
	//Arma 2
	"Name",
	"Strategic",
	"StrongpointArea",
	//"FlatArea",
	"FlatAreaCity",
	"FlatAreaCitySmall",
	"CityCenter",
	"Airport",
	//"NameMarine",
	//"NameCityCapital",
	//"NameCity",
	//"NameVillage",
	//"NameLocal",
	//"Hill",
	//"ViewPoint",
	//"RockArea",
	//"BorderCrossing",
	//"VegetationBroadleaf",
	//"VegetationFir",
	//"VegetationPalm",
	//"VegetationVineyard",
	//Arma 3
	"NameCity",
	"NameCityCapital",
	"NameMarine",
	"NameVillage",
	"NameLocal",
	//"Hill",
	//"Mount",
	"Airport"];
	_return;
};

/**
Order locations by size
Note: returns [[size,location]...]
Example
_locations=[] call stwf_getAllLocations;
_locationsBySize=[_locations] call stw_orderLocationsBySize;
**/
stw_orderLocationsBySize= {
	params ["_locations"];
	["stw_orderLocationsBySize","Function start"] call stw_dbg;
	_locationsWithSize=[];
	{
		_location=_x;
		_size=[_location] call stwf_getLocationSize;
		_locationsWithSize pushBack [_size,_location];
	}
	foreach _locations;
	_locationsWithSize sort true;
	//["stw_orderLocationsBySize",format ["%1",_locationsWithSize]] call stw_dbg;
	["stw_orderLocationsBySize","Function end"] call stw_dbg;
	_locationsWithSize;
};

/**
Order locations by height
Note: returns [[height,location]...]
Example
_locations=[] call stwf_getAllLocations;
_locationsBySize=[_locations] call stw_orderLocationsByHeight;
**/
stw_orderLocationsByHeight= {
	params ["_locations"];
	["stw_orderLocationsByHeight","Function start"] call stw_dbg;
	_locationsWithHeight=[];
	{
		_location=_x;
		_h=[_location] call stwf_getLocationHeight;
		_locationsWithHeight pushBack [_h,_location];
	}
	foreach _locations;
	_locationsWithHeight sort true;
	//["stw_orderLocationsByHeight",format ["%1",_locationsWithHeight]] call stw_dbg;
	["stw_orderLocationsByHeight","Function end"] call stw_dbg;
	_locationsWithHeight;
};

/**
Get All Locations
**/
stwf_getAllLocations={
	params [];
	["stwf_getAllLocations","Function start"] call stw_dbg;

	if (!(isNil "STW_ALL_LOCATIONS")) exitWith
	{
		["stwf_getAllLocations","(CACHED) Locations got"] call stw_dbg;
		["stwf_getAllLocations","Function end"] call stw_dbg;
		STW_ALL_LOCATIONS;
	};

	_locationTypes=[] call  stwf_getLocationTypeNames;
	_locations=[_locationTypes] call stwf_getLocationsOfTypes;

	STW_ALL_LOCATIONS=_locations;
	//["stwf_getAllLocations",format ["%1",STW_ALL_LOCATION]] call stw_dbg;
	["stwf_getAllLocations","Function end"] call stw_dbg;
	STW_ALL_LOCATIONS;
};

/**
Get All Airports Identifiers
**/
stwf_getAllAirportsIdentifiers={
	_allAirports=allAirports;
	_allAirports;
};

/**
Get All Static Airports Identifiers
**/
stwf_getAllStaticAirportsIdentifiers={
	_allAirports=[] call stwf_getAllAirportsIdentifiers;
	_allAirports select 0;
};

/**
Get All Dynamic Airports Identifiers
**/
stwf_getAllDynamicAirportsIdentifiers={
	_allAirports=[] call stwf_getAllAirportsIdentifiers;
	_allAirports select 1;
};

///////////////////////////////////////////////////////////////
/**
Get the center coordinates of the map. Z is zero.
**/
stwf_getCenterOfMap= {
	_centerposition = [worldSize / 2, worldsize / 2, 0];
	_centerposition;
};

/**
Get the size of the map.
**/
stwf_getWorldSize= {
	worldSize;
};

/**
Get a random position in the map. Z is zero.
**/
stwf_getRandomPosition= {
	_x=random worldSize;
	_y=random worldSize;
	_z=0; //getTerrainHeightASL [_x,_y];
	[_x,_y,_z];
};


/**
Check if player is into vehicle.
**/
stwf_isInVehicle= {
	_player=_this;
	_isInVehicle= (vehicle _player != _player);
	_isInVehicle;
};

/**
Check that the player is not into a vehicle
**/
stwf_isNotInVehicle= {
	_player=_this;
	_isNotInVehicle= (vehicle _player == _player);
	_isNotInVehicle;
};

/**
Get the minimum distance of a position to allPlayers
[position]
**/
stwf_getMinimumDistanceToPlayers= {
	_position= _this select 0;
	_minDistance=600000;
	if (!isNil "_position") then
	{
		{
			_player=_x;
			_theDistance=(_player distance _position);
			if (_theDistance<_minDistance) then
			{
				_minDistance=_theDistance;
			};
		} forEach allPlayers;
	};
	_minDistance;
};

/**
Get the minimum distance of a position to allPlayers THAT ARE NOT INTO VEHICLES
**/
stwf_getNearestPlayerNotIntoVehicle= {
	_position= _this select 0;
	_minDistance=60000;
	_nearestPlayer=objNull;
	{
		_player=_x;
		if (_player call stwf_isNotInVehicle) then {
			_theDistance=(_player distance _position);
			if (_theDistance<_minDistance) then
			{
				_minDistance=_theDistance;
				_nearestPlayer=_player;
			};
		};
	}
	forEach allPlayers;
	[_minDistance,_nearestPlayer]
};


/**
Check if the unit is onto water
[unit]
**/
stwf_isOnWater={
	_unit=_this select 0;
	_pos= getPos _unit;
	_result=false;
	if (surfaceIsWater _pos) then
	{
		_result=true;
	};
	_result;
};

/**
Check if the unit is flying
[unit]
**/
stwf_isFlying={
	_unit=_this select 0;
	_pos= getPosATL _unit;
	_h=_pos select 2;
	if (isNil("_h")) exitWith {false};
	if (_h>10) exitWith {true;
	};
	false;
};

/**
Return the list of players that are not flying.
[]
**/
stwf_AllPlayersNotFlying={
	_result=[];
	{
		_player=_x;
		_isFlying=[_player] call stwf_isFlying;
		if (!_isFlying) then {
			_result pushBack _player;
		};
	}
	forEach allPlayers;
	_result;
};

/**
Check if all members of a group are dead
**/
//[group]
stwf_GroupIsDead={
	_group=_this select 0;
	_result=false;
	if (isNil "_group") exitWith {true};
	if (count units _group == 0) then
	{
		_result=true;
	};
	_result;
};

/**
Return a list of all groups that are alive
// [groups]
**/
stwf_AliveGroups={
	_aliveGroups=0;
	{
		_grp=_x;
		if (([_grp] call stwf_GroupIsDead)==false) then {
			_aliveGroups=_aliveGroups+1;
		};
	}
	forEach _grps;
	_aliveGroups;
};

/**
get Random 2D position in world
**/
stwf_getRandomPosition2D={
	_wsize= worldSize;
	[random _wsize,random _wsize]
};

/**
Check if a line trayectory intersects a circular area.
// Receives a line [[lx0,ly0],[lx1,ly1]] and a circunference [[cx,cy],cr]
// returns true if the line intersect the circle, false if it does not.
//http://mathworld.wolfram.com/Circle-LineIntersection.html
**/
stwf_CircleLineIntersection= {
	_line=_this select 0;
	_circum=_this select 1;
	_pointA=_line select 0;
	_pointB=_line select 1;
	_x1= _pointA select 0;
	_y1= _pointA select 1;
	_x2= _pointB select 0;
	_y2= _pointB select 1;
	_ccenter= _circum select 0;
	_cr=_circum select 1;
	_cx=_ccenter select 0;
	_cy=_ccenter select 1;


	_x1=_x1-_cx;
	_y1=_y1-_cy;
	_x2=_x2-_cx;
	_y2=_y2-_cy;

	_dx= _x2-_x1;
	_dy= _y2-_y1;
	_dr2= _dx*_dx + _dy*_dy;
	_D= _x1*_y2 - _x2*_y1;
	_cr2=_cr*_cr;
	_D2= _D*_D;
	_result= (_cr2*_dr2)> (_D2);
	_result
};

/**
Get all markers starting with pattern
arg: pattern (string)
**/
stwf_GetMarkersStartingWith= {
	_pattern=_this;
	_zoneMarkers = [];
	{
		_marker=_x;
		_arr = toArray _marker;
		_markerName=toString _arr;
		if (_markerName find _pattern>=0) then {
			_zoneMarkers pushBack _marker;
			//diag_log format ["added %1!",_markerName]
		};
	}
	foreach allMapMarkers;
	_zoneMarkers;
};

/**
Get the 8 positions surrounding the position it receives in the given radius
Receives  [position,radius];
**/
stwf_getOctogonalPositionsSurroundingPlayer= {
	_results=[];
	_position=_this select 0;
	_radius=_this select 1;
	//diag_log format ["stwf_getOctogonalPositionsSurroundinPlayer %1 %2",_position,_radius];
	_angleIncrement=360/8;
	_angle=0;
	for [{_i=0}, {_i<8}, {_i=_i+1}] do {
		_x= (_position select 0)+ (_radius*sin _angle);
		_y= (_position select 1)+ (_radius*cos _angle);
		_results pushBack [_x,_y];
		_angle=_angle+_angleIncrement;
	};

	//diag_log format ["stwf_getOctogonalPositionsSurroundinPlayer result %1",_results];
	_results;
};

/**
Check if two units are looking at each other
//[unitA,unitB,degrees]
**/
stwf_isLookingAtBA= {
	_unitA=_this select 0;
	_unitB=_this select 1;
	_degrees=_this select 2;
	_isInView = [getPosATL _unitB, getdir _unitB, _degrees, getPosATL _unitA] call BIS_fnc_inAngleSector;
	_isInView
};

/**
Check is a unit A is looking at a unit B in a view angle of degrees
//[unitA,unitB,degrees]
**/
stwf_isLookingAtAB= {
	_unitA=_this select 0;
	_unitB=_this select 1;
	_degrees=_this select 2;
	_isInView = [getPosATL _unitA, getdir _unitA, _degrees, getPosATL _unitB] call BIS_fnc_inAngleSector;
	_isInView
};

/**
Check if two units are looking at each other (both ways) using a view angle.
//[unitA,unitB,degrees]
**/
stwf_areLookingAtEachOther= {
	_unitA=_this select 0;
	_unitB=_this select 1;
	_degrees=_this select 2;
	_result= ([_unitA,_unitB,_degrees] call stwf_isLookingAtAB)&&([_unitB,_unitA,_degrees] call stwf_isLookingAtAB);
	_result;
};

/**
Get the road type a vehicle is on
//vehicle
**/
stwf_getRoadType={
	_veh=_this;
	_radii = [0, 3, 4.2, 5.75];
	_types = ["no road", "gravel road", "sealed road", "highway"];


	_type = (_types select 0);
	_currentTest = 1;
	while {(_currentTest < count _radii)}do {

		_nearestRoad = (_veh nearRoads (_radii select (count _radii - 1))*2.5) select 0;
		if (isNil "_nearestRoad")ExitWith {_type="no road"};

		_left = isOnRoad (_nearestRoad getRelPos [(_radii select _currentTest), 270]);
		_right = isOnRoad (_nearestRoad getRelPos [(_radii select _currentTest), 90]);
		_behind = isOnRoad (_nearestRoad getRelPos [(_radii select _currentTest), 180]);
		_front = isOnRoad (_nearestRoad getRelPos [(_radii select _currentTest), 0]);

		if (_left && _right && _behind && _front) then {
			_type = _types select _currentTest;
		};
		_currentTest = _currentTest + 1;
	};

	//diag_log format ["vehicle is on %1", _type];
	_type;
};

/**
Get player by unit name
*/
//[unitName]
stwf_PlayerUnitByName={
	_unitName= _this select 0;
	//diag_log format ["Requesting unit for player %1",_unitName];
	_requestedUnit=nil;
	{
		if ((name _x)==_unitName) exitWith {_requestedUnit= _x;
		};
	}
	forEach AllPlayers;
	_requestedUnit;
};

/**
Get the height (ATL) a unit it at
//[unit]
***/
stwf_getUnitZ={
	_unit= (_this select 0);
	(getPosATL _unit) select 2;
};

/**
Select a random road near some (random) player
//distance radius
**/
stwf_selectRoadNearSomePlayer= {
	_radius=_this;
	_retries=0;
	_destinationPosition=nil;
	while {(isNil "_destinationPosition")&&(_retries<8)} do {
		_destinationPosition=selectRandom ([getPos (selectRandom allPlayers),25] call stwf_getOctogonalPositionsSurroundingPlayer);
		_nearRoads= _destinationPosition nearRoads _radius;
		if (count _nearRoads>0) then {
			_destinationPosition=selectRandom _nearRoads;
		} else {
			_destinationPosition=nil;
		};
		_retries=_retries+1;
	};
	_destinationPosition
};

/**
Get the radius of the city as from the location information
//Extracts the radius of the city
// Receives: [_lctype,text _x, locationPosition _x, direction _x, size _x, rectangular _x]
**/
stwf_getCityRadius= {
	_dims=_this select 4;
	_w=_dims select 0;
	_h=_dims select 1;
	_result=_w;
	if (_h>_w) then
	{
		_result=_h;
	};
	_result
};


/**
CHECK THIS: Seems redundant
//Extracts the position of the city
// Receives: [_lctype,text _x, locationPosition _x, direction _x, size _x, rectangular _x]
**/
stwf_getCityPosition= {
	_this select 2
};

/**
get Nearest marker to player
//[player]
**/
stwf_getNearestMarker= {
	_obj=_this select 0;
	_nearestMarker = [allMapMarkers, _obj] call BIS_fnc_nearestPosition;
};

/**
Returns true if a random probability from 0 to 100 is
below the threshold
[threshold]
**/
stwf_probabilityCheck= {
	_threshold=_this select 0;
	//diag_log format ["_threshold is %1",_threshold];
	_random0100=random 101;
	_result=(_random0100<=_threshold);
	_result;
};

/**
Get Object height
**/
stwf_getObjectHeight= {
	params ["_obj"];
	_bbox = boundingBox _obj;
	_z1= (_bbox select 0) select 2;
	_z2= (_bbox select 1) select 2;
	_height = abs (_z2-_z1);
	_height;
};

/**
Get Object Volume
**/
stwf_getObjectVolume= {
	params ["_obj"];
	//_obj=_this;
	_bbox = boundingBox _obj;

	_x1= (_bbox select 0) select 0;
	_x2= (_bbox select 1) select 0;

	_y1= (_bbox select 0) select 1;
	_y2= (_bbox select 1) select 1;

	_z1= (_bbox select 0) select 2;
	_z2= (_bbox select 1) select 2;

	_x=abs (_x2-_x1);
	_y=abs (_y2-_y1);
	_z=abs (_z2-_z1);
	_x*_y*_z;
};

/**
Generate random number in min,max range
**/
stwf_getRandomNumberInRange = {
	params ["_min","_max"];
	_rnd= random (_max-_min);
	_rnd= _rnd+_min;
	floor _rnd
};

/**
Generate a position between minimun and maximum ranges from the center
params ["_center","_minRange",_maxRange"];
**/
stwf_getRandomPositionInRange= {
	params ["_poscenter","_minRange","_maxRange"];
	_range=[_minRange,_maxRange] call stwf_getRandomNumberInRange;
	_rangle=[0,360] call stwf_getRandomNumberInRange;
	_rposition=_poscenter getPos [_range,_rangle];
	_rposition
};

/**
Generate a position between minimun and maximum ranges from all players
params ["_minRange",_maxRange"];
Warning: may return nil if no valid position is found.
returns nil if the position is in minrange of whichever player.
**/
stwf_getRandomPositionInRangeForAllPlayers= {
	params ["_minRange","_maxRange"];
	_generatedPosition = nil;
	_valid=false;
	{
		if (!_valid) then {
			_player=_x;
			_pPos= getPos _player;
			_generatedPosition=[_pPos,_minRange,_maxRange] call stwf_getRandomPositionInRange;
			// get the distance to all other players from the generated position.
			_distanceToOtherPlayers=[];
			{
				_otherPlayer=_x;
				if (_player!=_otherPlayer) then {
					_opPos= getPos _otherPlayer;
					_distance2D=_pPos distance2D _opPos;
					_distanceToOtherPlayers pushBack _distance2D;
				};
			}
			forEach AllPlayers;
			// check if the any of the distances falls sort.
			_valid=true;
			{
				_dist=_x;
				if (_dist<=_minRange) then {
					_valid=false;
					_generatedPosition=nil;
				};
			}
			forEach _distanceToOtherPlayers;
		};
	}
	forEach AllPlayers;
	_generatedPosition
};

/**
Convert 2D Positions to their corresponding
At Ground Level 3D Positions
PositionAGLS. Z value is height over the surface underneath.
**/
stwf_getGroundLevelPositions= {
	params ["_2DPositions"];
	_result=[];
	{
		_2DPosition=_x;
		_3DPosition=getPosATL _2DPosition;
		_result pushBack _3DPosition;
	}
	forEach _2DPositions;
	_result;
};

/**
Creates a random vehicle (with passenger) on the given position.
**/
stwf_generateVehicleWithPassengers= {
	params ["_vehClass","_position"];
	_veh = createVehicle [_vehClass, _position, [], 0, "NONE"];
	createVehicleCrew _veh;
	{
		alive _x;
	}
	forEach crew _veh;

	_veh
};

/**
Return the list with no nulls
**/
stwf_noNulls={
	params ["_list"];
	if (ObjNull in _list) then
	{
		{
			_list = _list - [objNull];
		} forEach _list;
	};
	_list
};

/**
Return the rest of the array (the list without first element)
**/
stwf_rest={
	params ["_list"];
	_result=_list select [1,count _list];
	_result;
};

/**
Returns the [point,index] of the nearest point in the received array of points.
Same point result is avoided by checking zero distance.
params [_point,_points].
**/
stwf_findNearest2DPoint= {
	params ["_point","_points"];
	_minDistance=60000;
	//_points=[_points] call stwf_noNulls;
	//diag_log format ["Nearest2DPoint Params:%1 %2",_point,_points];
	_n=count _points;
	_index=-1;
	_nearestPoint=nil;
	for [{_i=0}, {_i<_n}, {_i=_i+1}] do {
		_otherPoint=_points select _i;
		_distance2D=_point distance2D _otherPoint;
		if ((_distance2D>0)&&(_distance2D<_minDistance)) then {
			_nearestPoint=_otherPoint;
			_index=_i;
			_minDistance=_distance2D;
		};
	};
	_resultInfo=[nil,_index];
	if (_index!=-1) then
	{
		_resultInfo=[_nearestPoint,_index];
	};
	//diag_log format ["Nearest2DPoint result=%1",_result];
	_resultInfo
};

/**
Order a list of positions by the distance among them
**/
stwf_orderPointsByDistancesToFirst= {
	params ["_points"];
	//diag_log format ["original %1",_points];
	// _points=[_points] call stwf_noNulls;
	_resultPoints=[];
	if (count _points ==0) exitWith {[]};
	_firstPoint= _points select 0;
	_resultPoints pushBack _firstPoint;
	//make a copy of the points list
	_closestPoints=+([_points] call stwf_rest);
	{
		_point=_x;
		_info=[_firstPoint,_closestPoints] call stwf_findNearest2DPoint;
		_closestPoint=_info select 0;
		_closestPointIndex=_info select 1;
		if (_closestPointIndex!=-1) then {
			_resultPoints pushBack _closestPoint;
			_closestPoints deleteAt _closestPointIndex;
		};
	}
	forEach _points;
	//diag_log format ["result %1",_resultPoints];
	_resultPoints
};

/**
Copy to clipboard
**/
stwf_copyToClipBoard= {
	params ["_content"];
	_contentStr=format ["%1",_content];
	copyToClipboard _contentStr;
};

/**
Copy to clipboard with newlines
**/
stwf_copyToClipBoardWithNL= {
	params ["_content"];
	_br = toString [13,10];//(carriage return & line feed)
	_str="";
	{
		_line=(format ["%1",_x]);
		_line=_line+_br;
		_str=_str+_line;
	}
	forEach _content;
	copyToClipboard _str;
};

/**
Copy array to clipboard with newlines
for debug:
example: ["stwWaterZonesList",stwWaterZonesList] call stwf_copyArrayToClipBoard;
**/
stwf_copyArrayToClipBoard= {
	params ["_arrayName","_content"];
	_br = toString [13,10];//(carriage return & line feed)
	_str=_arrayName+"=["+_br;
	_n=count _content;
	for [{_i=0}, {_i<_n}, {_i=_i+1}] do {
		_line=(format ["%1",_content select _i]);
		if (_i!=(_n-1)) then {
			_line=_line+","+_br;
		} else {
			_line=_line+_br;
		};
		_str=_str+_line;
	}
	forEach _content;
	_str=_str+"];";
	copyToClipboard _str;
};

/**
Create/Set a Global Variable of a given name
and initial value
**/
stwf_setGlobalVariable= {
	params ["_globalName","_value"];
	missionNamespace setVariable [_globalName,_value];
};

/**
Get the value of a given global variable
**/
stwf_getGlobalVariable= {
	params ["_globalName"];
	_ret=missionNamespace getVariable _globalName;
	_ret
};

/**
Get the size of a building in positions
**/
stwf_size_of_building= {
	_allpositions = _this buildingPos -1;
	count _allpositions;
};

/**
Create an empty vehicle at position
**/
stwf_createEmptyVehicle={
	params ["_position","_classType"];
	_veh = _classType createVehicle _position;
	[_veh, true, true, true] call bis_fnc_initVehicle;
	_veh setDir random 360;
	_veh
};

/**
[minDistance, -1,
maxGradient default -1,
maxGradientRadius default 1,
overLandOrWater 0: position cannot be over water; 2: position cannot be over land. -1 to ignore. Default: 0,
shoreLine  Boolean - true: position is over shoreline (< ~25 m from water). false to ignore. ,
ignoreObject Object to ignore in proximity checks. objNull to ignore. Default: objNull]
**/
stwf_isFlatEmpty = {
	params ["_pos", "_params"];
	_pos = _pos findEmptyPosition [0, _params select 0];
	if (_pos isEqualTo []) exitWith {[]};
	_params =+ _params;
	_params set [0, -1];
	_pos = _pos isFlatEmpty _params;
	if (_pos isEqualTo []) exitWith {[]};
	_pos
};

stwf_isFlatEmptyLand ={
	params ["_pos","_radius"];
	_result=[_pos,[_radius, -1 /*forced -1*/,
	0.1 /* max gradient */,
	2 /* max gradient radius */,
	0 /* not on water */,
	false /*can or cannot be shoreline */,
	objNull]] call stwf_isFlatEmpty;
	_result
};


/*
	Author: Terra

	Description:
	Substitute a certain part of a string with another string.

	Parameters:
	1: STRING - Source string
	2: STRING - Part to edit
		* ARRAY OF STRINGS - Multiple parts to edit
	3: STRING - Substitution
	4: (Optional) NUMBER - maximum substitutions
		* Default: 10
	5: (Optional) CASE - Enable maximum limit of substitutions (WARNING: Substituting an expression with the same expression will lead to infinite loops)
		* Default: true

	Returns: STRING

	Example 1:
		["12345 123456", "123", "abc"] call TER_fnc_editString;
		Returns: "abc45 abc456"

	Example 2:
		["123456 123456 TEST", ["12", "56", "TEST"], "abc"] call TER_fnc_editString;
		Returns: "abc34abc abc34abc abc"

	Example 3:
		["123 123", "123", " 123"] call TER_fnc_editString;
		Returns: "          123 123" // 10 substitutions

		["123 123", "123", " 123", 20] call TER_fnc_editString;
		Returns: "                    123 123" // 20 substitutions

		["123 123", "123", " 123", 10, false] call TER_fnc_editString;
		! Infinite loop and crash !
*/
stwf_StringReplace = {
	params ["_str", "_toFind", "_subsitution", ["_numLimit",10,[1]], ["_limit",true,[true]]];
	if (typeName _toFind != typeName []) then {_toFind = [_toFind]};
	{
		_char = count _x;
		_no = _str find _x;
		private _loop = 0;
		while {-1 != _str find _x && _loop < _numLimit} do {
			_no = _str find _x;
			_splitStr = _str splitString "";
			_splitStr deleteRange [(_no +1), _char -1];
			_splitStr set [_no, _subsitution];
			_str = _splitStr joinString "";
			if (_limit) then {_loop = _loop +1;
			};
		};
	}
	forEach (_toFind);
	_str
};

/* Substitute vest, returns the original vest name*/
stwf_substituteVest={
 params ["_unit", "_newVestName"];
 _items=vestItems _unit;
 _vest=vest _unit;
 removeVest _unit;
 _unit addVest _newVestName;
 {
  _unit addItemToVest _x;
 } forEach (_items);
 _vest;
};
#endif