#ifndef  STW_Buildings_Module_Loaded
#define STW_Buildings_Module_Loaded true
diag_log "STW_Buildings Module Loaded";
STW_BUILDING_TYPES=["Building","House"];
STW_BUILDINGS=nil;
STW_BUILDINGS_COUNT=nil;
STW_ENTBUILDINGS=nil;
STW_ENTBUILDINGS_COUNT=nil;

STW_BUILDINGS_HEIGHTS=nil;
STW_BUILDINGS_HEIGHTS_COUNT=nil;

STW_BUILDINGS_VOLUMES=nil;
STW_BUILDINGS_VOLUMES_COUNT=nil;

STW_ENTBUILDINGS_HEIGHTS=nil;
STW_ENTBUILDINGS_HEIGHTS_COUNT=nil;

STW_ENTBUILDINGS_VOLUMES=nil;
STW_ENTBUILDINGS_VOLUMES_COUNT=nil;

/**
 Get all buildings
**/
stwf_getAllBuildings=
{
 params [];
 
 if (!isNil("STW_BUILDINGS")) exitWith {
			//["stf_getAllBuildings","(CACHED) Buildings got"] call stw_dbg;
			STW_BUILDINGS
			}; 
 STW_BUILDINGS=nearestObjects [
		getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition")
		, STW_BUILDING_TYPES,  
		worldSize/2
		];
 STW_BUILDINGS
};

/**
 Get all buildings count
**/
stwf_getAllBuildingsCount=
{
 params [];
 
 if (!isNil("STW_BUILDINGS_COUNT")) exitWith {
			//["stf_getAllBuildingsCount","(CACHED) Buildings count got"] call stw_dbg;
			STW_BUILDINGS_COUNT
			}; 
 [] call stwf_getAllBuildings;
 STW_BUILDINGS_COUNT= count STW_BUILDINGS;
 STW_BUILDINGS_COUNT
};

/**
 Get building position
 At Terrain Level
**/
stwf_getBuildingPosition=
{
 params ["_building"];
 getPosATL _building;
};

/**
 Get building height
**/
stwf_getBuildingHeight=
{
 params ["_building"];
 [_building] call stwf_getObjectHeight;
};

/**
 Get building volume
**/
stwf_getBuildingVolume=
{
 params ["_building"];
 [_building] call stwf_getObjectVolume;
};

/**
 Get building inner places 
 **/
stwf_getBuildingInnerPlaces=
{
 params ["_building"];
 [_building] call BIS_fnc_buildingPositions;
};

/**
 Is building enterable
**/
stwf_isBuildingEnterable=
{
 params ["_building"];
 _isEnterable=[_building] call BIS_fnc_isBuildingEnterable;
 _isEnterable
};


/**
 Get all enterable buildings
**/
stwf_getAllEnterableBuildings=
{
	params [];
	if (!isNil("STW_ENTBUILDINGS")) exitWith {
			//["stf_getAllEnterableBuildings","(CACHED) Enterable Buildings got"] call stw_dbg;
			STW_ENTBUILDINGS
			}; 
    
	_allBuildings=[] call stwf_getAllBuildings;
	_result= [];  
	{
		_building=_x;
		_isEnterable=[_building] call stwf_isBuildingEnterable;
		if (_isEnterable) then
		{
			_result pushBack _building;
		};
	} forEach _allBuildings;
	STW_ENTBUILDINGS=_result;
	STW_ENTBUILDINGS;
};

/**
 Get all buildings count
**/
stwf_getAllEnterableBuildingsCount=
{
	 params [];
	 
	 if (!isNil("STW_ENTBUILDINGS_COUNT")) exitWith {
				//["stf_getAllEnterableBuildingsCount","(CACHED) Enterable Buildings count got"] call stw_dbg;
				STW_ENTBUILDINGS_COUNT
				}; 
	 [] call stwf_getAllEnterableBuildings;
	 STW_ENTBUILDINGS_COUNT= count STW_ENTBUILDINGS;
	 STW_ENTBUILDINGS_COUNT
};

/**
 Get all buildings heights (normally for statistics)
**/
stwf_getAllBuildingsHeights=
{
 params [];
 
 if (!isNil("STW_BUILDINGS_HEIGHTS")) exitWith {
			//["stf_getAllBuildingsHeights","(CACHED) Buildings Heights got"] call stw_dbg;
			STW_BUILDINGS_HEIGHTS
			}; 
 _result= [];  
	{
		_building=_x;
		_h=[_building] call stwf_getObjectHeight;
		_result pushBack _h;
	} forEach ([] call stwf_getAllBuildings);
	STW_BUILDINGS_HEIGHTS=_result;
	STW_BUILDINGS_HEIGHTS;
};

/**
 Get all buildings heights count
**/
stwf_getAllBuildingsHeightsCount=
{
	 params [];
	 
	 if (!isNil("STW_BUILDINGS_HEIGHTS_COUNT")) exitWith {
				//["stf_getAllBuildingsHeightsCount","(CACHED) Enterable Buildings heights count got"] call stw_dbg;
				STW_BUILDINGS_HEIGHTS_COUNT
				}; 
	 [] call stwf_getAllBuildingsHeights;
	 
	 STW_BUILDINGS_HEIGHTS_COUNT= count STW_BUILDINGS_HEIGHTS;
	 STW_BUILDINGS_HEIGHTS_COUNT
};

/**
 Get all buildings volumes (normally for statistics)
**/
stwf_getAllBuildingsVolumes=
{
 params [];
 
 if (!isNil("STW_BUILDINGS_VOLUMES")) exitWith {
			//["stf_getAllBuildingsVolumes","(CACHED) Buildings Volumes got"] call stw_dbg;
			STW_BUILDINGS_VOLUMES
			}; 
 _result= [];  
	{
		_building=_x;
		_h=[_building] call stwf_getObjectVolume;
		_result pushBack _h;
	} forEach ([] call stwf_getAllBuildings);
	STW_BUILDINGS_VOLUMES=_result;
	STW_BUILDINGS_VOLUMES;
};

/**
 Get all buildings volumes count
**/
stwf_getAllBuildingsVolumesCount=
{
	 params [];
	 
	 if (!isNil("STW_BUILDINGS_VOLUMES_COUNT")) exitWith {
				//["stf_getAllBuildingsVolumesCount","(CACHED) Enterable Buildings volumes count got"] call stw_dbg;
				STW_BUILDINGS_VOLUMES_COUNT
				}; 
	 [] call stwf_getAllBuildingsVolumes;
	 STW_BUILDINGS_VOLUMES_COUNT= count STW_BUILDINGS_VOLUMES;
	 STW_BUILDINGS_VOLUMES_COUNT
};



/**
 Get all buildings heights (normally for statistics)
**/
stwf_getAllEnterableBuildingsHeights=
{
 params [];
 
 if (!isNil("STW_ENTBUILDINGS_HEIGHTS")) exitWith {
			//["stf_getAllEnterableBuildingsHeights","(CACHED) Buildings Heights got"] call stw_dbg;
			STW_ENTBUILDINGS_HEIGHTS
			}; 
  _resultArray= [];  
  _buildings=[] call stwf_getAllEnterableBuildings;
  diag_log format ["Inspecting %1 buildings",(count _buildings)];
  
	{
		_building=_x;
		_bheight=[_building] call stwf_getBuildingHeight;
		_resultArray pushBack _bheight;
	} forEach _buildings;
	STW_ENTBUILDINGS_HEIGHTS=_resultArray;
	_resultArray
};

/**
 Get all buildings heights count
**/
stwf_getAllEnterableBuildingsHeightsCount=
{
	 params [];
	 
	 if (!isNil("STW_ENTBUILDINGS_HEIGHTS_COUNT")) exitWith {
				//["stf_getAllEnterableBuildingsHeightsCount","(CACHED) Enterable Buildings heights count got"] call stw_dbg;
				STW_ENTBUILDINGS_HEIGHTS_COUNT
				}; 
	 _buildings=[] call stwf_getAllEnterableBuildingsHeights;
	 _total=count _buildings;
	 STW_ENTBUILDINGS_HEIGHTS_COUNT= _total; 
	 STW_ENTBUILDINGS_HEIGHTS_COUNT
};

/**
 Get all buildings volumes (normally for statistics)
**/
stwf_getAllEnterableBuildingsVolumes=
{
 params [];
 
 if (!isNil("STW_ENTBUILDINGS_VOLUMES")) exitWith {
			//["stf_getAllEnterableBuildingsVolumes","(CACHED) Buildings Volumes got"] call stw_dbg;
			STW_ENTBUILDINGS_VOLUMES
			}; 
  _resultArray= [];  
  _buildings=[] call stwf_getAllEnterableBuildings;
  //diag_log format ["Inspecting %1 buildings",(count _buildings)];
  
	{
		_building=_x;
		_bvolume=[_building] call stwf_getBuildingVolume;
		_resultArray pushBack _bvolume;
	} forEach _buildings;
	STW_ENTBUILDINGS_VOLUMES=_resultArray;
	_resultArray
};

/**
 Get all buildings volumes count
**/
stwf_getAllEnterableBuildingsVolumesCount=
{
	 params [];
	 
	 if (!isNil("STW_ENTBUILDINGS_VOLUMES_COUNT")) exitWith {
				//["stf_getAllEnterableBuildingsVolumesCount","(CACHED) Enterable Buildings volumes count got"] call stw_dbg;
				STW_ENTBUILDINGS_VOLUMES_COUNT
				}; 
	 _buildings=[] call stwf_getAllEnterableBuildingsVolumes;
	 _total=count _buildings;
	 STW_ENTBUILDINGS_VOLUMES_COUNT= _total; 
	 STW_ENTBUILDINGS_VOLUMES_COUNT
};

/**
 Get size of building in rooms (places for infantry)
**/
stwf_buildingRoomsCount={
 params ["_building"];
 _innerBuildingPositions=[_building] call BIS_fnc_buildingPositions;
 _nInnerBuildingPositions=count _innerBuildingPositions;
 _nInnerBuildingPositions
};

/**
 Get size of building in rooms (places for infantry)
**/
stwf_getAllEnterableBuildingsNumberOfRooms=
{
 params [];
 
 if (!isNil("STW_ENTBUILDINGS_NUMBER_OF_ROOMS")) exitWith {
			//["stf_getAllEnterableBuildingsVolumes","(CACHED) Buildings NRooms got"] call stw_dbg;
			STW_ENTBUILDINGS_NUMBER_OF_ROOMS
			}; 
  _resultArray= [];  
  _buildings=[] call stwf_getAllEnterableBuildings;
  //diag_log format ["Inspecting %1 buildings",(count _buildings)];
  
	{
		_building=_x;
		_bvolume=[_building] call stwf_buildingRoomsCount;
		_resultArray pushBack _bvolume;
	} forEach _buildings;
	STW_ENTBUILDINGS_NUMBER_OF_ROOMS=_resultArray;
	_resultArray
};



#endif