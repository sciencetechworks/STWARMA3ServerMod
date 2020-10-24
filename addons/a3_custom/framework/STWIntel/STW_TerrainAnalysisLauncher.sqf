#ifndef  STW_TerrainAnalysisLauncher_Module_Loaded
#define STW_TerrainAnalysisLauncher_Module_Loaded true
diag_log "STW_TerrainAnalysisLauncher_Module Loaded";




// Detect areas that touch each other

stwf_createAreasGraph=
{
 params ["_zonesList"];
 
 if (!isNil("STWG_WATER_AREAS_PATH_GRAPH")) exitWith 
 {
  diag_log "Do not scan map data, it was preloaded.";
 };
 
 diag_log "CREATING AREAS GRAPH";
 
 _edges=[];
 _i=0;
 //_zoneA=_zonesList select 0;
 {
  _zoneA=_x;
  _j=0;
	 {
	  _zoneB=_x;
	  if  (! (_zoneA isEqualTo _zoneB)) then
	  {
		  _areTouching=[_zoneA,_zoneB] call stwf_areRectanglesTouchingCircleRangeMethod2; //stwf_areRectanglesTouching; 
		  if (_areTouching) then
		  {
		    _centerA=[_zoneA] call stwf_getCenterOfRectangle2D;
			_centerB=[_zoneB] call stwf_getCenterOfRectangle2D;
			_distance=[_centerA,_centerB] call stwf_distance2D;
			[_centerA,_centerB,[1,1,1,1]] call stwf_drawLine;
			//diag_log format ["%1 is touched by %2",_zoneA,_zoneB];
			_edge=[_i,_j,_distance];
			_edges pushBack _edge;
		  }; 
	  };
   _j=_j+1;
	 } forEach _zonesList;
  _i=_i+1; 
   _zoneA call markZoneAsInspected;
 } forEach _zonesList;
 
 STWG_WATER_AREAS_PATH_GRAPH=[STWG_WATER_ZONES,_edges];
 //["STWG_WATER_AREAS_PATH_GRAPH",STWG_WATER_AREAS_PATH_GRAPH] call stwf_copyArrayToClipBoard;
 //diag_log format ["GRAPH DATA COPIED TO CLIPBOARD"];
 ["STWG_WATER_AREAS_PATH_GRAPH",
	STWG_WATER_AREAS_PATH_GRAPH] call stwf_showGraphInLog;
 diag_log format ["GRAPH DATA COPIED TO LOG"];
};

stwf_createLandAreasGraph=
{
 params ["_zonesList"];
 
 if (!isNil("STWG_LAND_AREAS_PATH_GRAPH")) exitWith 
 {
  diag_log "Do not scan map data, it was preloaded.";
 };
 
 diag_log "CREATING AREAS GRAPH";
 
 _edges=[];
 _i=0;
 //_zoneA=_zonesList select 0;
 {
  _zoneA=_x;
  _j=0;
	 {
	  _zoneB=_x;
	  if  (! (_zoneA isEqualTo _zoneB)) then
	  {
		  _areTouching=[_zoneA,_zoneB] call stwf_areRectanglesTouchingCircleRangeMethod2; //stwf_areRectanglesTouching; 
		  if (_areTouching) then
		  {
		    _centerA=[_zoneA] call stwf_getCenterOfRectangle2D;
			_centerB=[_zoneB] call stwf_getCenterOfRectangle2D;
			_distance=[_centerA,_centerB] call stwf_distance2D;
			[_centerA,_centerB,[1,1,1,1]] call stwf_drawLine;
			//diag_log format ["%1 is touched by %2",_zoneA,_zoneB];
			_edge=[_i,_j,_distance];
			_edges pushBack _edge;
		  }; 
	  };
   _j=_j+1;
	 } forEach _zonesList;
  _i=_i+1; 
   _zoneA call markZoneAsInspected;
 } forEach _zonesList;
 
 STWG_LAND_AREAS_PATH_GRAPH=[_zonesList,_edges];
  diag_log format ["LAND GRAPH DATA IS BEING COPIED TO LOG"];
 ["STWG_LAND_AREAS_PATH_GRAPH",
	STWG_LAND_AREAS_PATH_GRAPH] call stwf_showGraphInLog;
 diag_log format ["LAND GRAPH DATA WAS COPIED INTO LOG"];
};



stwf_generateGraphLinesOnMapHandler=
{
 params ["_graph","_handlerName","_rgbaColor"];
_zones=_graph select 0; 
_edges=_graph select 1; 
_waterIALines=[];
	{
	 _edge=_x;
	 _zoneAIndex=_edge select 0;
	 _zoneBIndex=_edge select 1;
	 //diag_log format ["Zone indexes:%1 %2",_zoneAIndex,_zoneBIndex];
	 _zoneA=_zones select _zoneAIndex;
	 _zoneB=_zones select _zoneBIndex;
	 _centerA=[_zoneA] call stwf_getCenterOfRectangle2D;
	 _centerB=[_zoneB] call stwf_getCenterOfRectangle2D;
	 _line=[_centerA,_centerB];
	 _waterIALines pushBack _line;
	 //diag_log format ["new edge: %1",_line];
	} forEach _edges;
	[_handlerName,_waterIALines,_rgbaColor] call stwf_newDrawLinesOnMapHandler;
};

/**
Generates an array containing all centers for the nodes of a graph
**/
stwf_generateGraphNodeCentersMapInfo=
{
  params ["_globalName","_graph"];
  _nodes=_graph select 0;
  _centers=[];
  {
   _node=_x;
   _center=[_node] call stwf_getCenterOfRectangle2D;
   _centers pushBack _center;
  } forEach _nodes;
  [_globalName,_centers] call stwf_setGlobalVariable;
  _centers
};

stwf_generateWaterToLandDistanceMapInfo=
{
  params ["_globalName","_landcenters","_watercenters"];
  _distancesToLand=[];
  {
	_waterCenter=_x;
    _minDistanceToLand=600000;
	{
	  _landCenter=_x;
	  _distance=_waterCenter distance2D _landCenter;
	  if (_distance<_minDistanceToLand) then
	  {
	    _minDistanceToLand=_distance;
	  };
	} forEach _landCenters;
	_distancesToLand pushBack _minDistanceToLand;
  } forEach _waterCenters;
  [_globalName,_distancesToLand] call stwf_setGlobalVariable;
  _distancesToLand
};

// DETECT WATER AREAS
_scriptPath="PATH";
if (STWG_NO_ADDON_MODE) then
{
	_scriptPath="@STWCustom\addons\a3_custom\STWWater\STW_DetectWaterAreasInit.sqf";
} else
{	
	_scriptPath="a3_custom\STWWater\STW_DetectWaterAreasInit.sqf";
};

_script_handler =[[[[0,0],[worldSize,worldSize]]],0] execvm _scriptPath;

waitUntil{ STWG_WATER_AREAS_LIST_READY };
[STWG_WATER_ZONES] call stwf_createAreasGraph;
[STWG_WATER_AREAS_PATH_GRAPH,"STW_AI_WATER_PATHS_DRAWING_HANDLER",[0,0,1,1]] call stwf_generateGraphLinesOnMapHandler;
["STW_AI_WATER_PATHS_DRAWING_HANDLER"] call  stwf_activateDrawHandler;


// DETECT LAND AREAS
diag_log "DETECT LAND AREAS:";
_scriptPath="PATH";
if (STWG_NO_ADDON_MODE) then
{
	_scriptPath="@STWCustom\addons\a3_custom\framework\STWIntel\STW_DetectLandAreasInit.sqf";
} else
{	
	_scriptPath="a3_custom\framework\STWIntel\STW_DetectLandAreasInit.sqf";
};
diag_log format ["Launching: %1",_scriptPath];
_script_handler =[[[[0,0],[worldSize,worldSize]]],0] execvm _scriptPath;

waitUntil{ STWG_LAND_AREAS_LIST_READY };
diag_log "//Generating land graph";
[STWG_LAND_ZONES] call stwf_createLandAreasGraph;
diag_log "//creating land graph lines";
[STWG_LAND_AREAS_PATH_GRAPH,"STW_AI_LAND_PATHS_DRAWING_HANDLER",[1,1,0,1]] call stwf_generateGraphLinesOnMapHandler;
["STW_AI_LAND_PATHS_DRAWING_HANDLER"] call  stwf_activateDrawHandler;

if (isNil ("STWG_WATER_AREAS_CENTERS") ) then
{
	diag_log "//Calculating water areas centers";
	_centers=["STWG_WATER_AREAS_CENTERS",STWG_WATER_AREAS_PATH_GRAPH] call stwf_generateGraphNodeCentersMapInfo;
	["STWG_WATER_AREAS_CENTERS",_centers] call stwf_showListInLog;
};

if (isNil ("STWG_LAND_AREAS_CENTERS") ) then
{
	diag_log "//Calculating land areas centers";
	_centers=["STWG_LAND_AREAS_CENTERS",STWG_LAND_AREAS_PATH_GRAPH] call stwf_generateGraphNodeCentersMapInfo;
	["STWG_LAND_AREAS_CENTERS",_centers] call stwf_showListInLog;
};

if (isNil ("STWG_WATER_TO_LAND_DISTANCES") ) then
{
	diag_log "//Calculating STWG_WATER_TO_LAND_DISTANCES";
	_values=["STWG_WATER_TO_LAND_DISTANCES",STWG_LAND_AREAS_CENTERS,STWG_WATER_AREAS_CENTERS] call stwf_generateWaterToLandDistanceMapInfo;
	["STWG_WATER_TO_LAND_DISTANCES",_values] call stwf_showListInLog;
	_minDistanceToLand=selectMin _values;
	diag_log format ["STWG_WATER_TO_LAND_MIN_DISTANCE=%1;",_minDistanceToLand];
	_avg=[_values] call stwf_average;
	_std=[_values,_avg] call stwf_standardDeviation;
	diag_log format ["STWG_WATER_TO_LAND_AVG_DISTANCE=%1;",_avg];
	diag_log format ["STWG_WATER_TO_LAND_STDDEV_DISTANCE=%1;",_std];
};

///////////////////// ANALYSE BUILDINGS //////////////////////////
STWG_ENTERABLE_BUILDINGS=[] call stwf_getAllEnterableBuildings;
STWG_ENTERABLE_BUILDINGS_COUNT=[] call stwf_getAllEnterableBuildingsCount;
STWG_ENTERABLE_BUILDINGS_HEIGHTS=[] call stwf_getAllEnterableBuildingsHeights;
STWG_ENTERABLE_BUILDINGS_VOLUMES=[] call stwf_getAllEnterableBuildingsVolumes;
STWG_ENTERABLE_BUILDINGS_NROOMS=[] call stwf_getAllEnterableBuildingsNumberOfRooms;

STWG_ENTERABLE_BUILDINGS_MIN_HEIGHT=selectMin STWG_ENTERABLE_BUILDINGS_HEIGHTS;
STWG_ENTERABLE_BUILDINGS_MAX_HEIGHT=selectMax STWG_ENTERABLE_BUILDINGS_HEIGHTS;
STWG_ENTERABLE_BUILDINGS_AVERAGE_HEIGHT=[STWG_ENTERABLE_BUILDINGS_HEIGHTS] call stwf_average;
STWG_ENTERABLE_BUILDINGS_STDDEV_HEIGHT=[STWG_ENTERABLE_BUILDINGS_HEIGHTS,STWG_ENTERABLE_BUILDINGS_AVERAGE_HEIGHT] call stwf_standardDeviation;
STWG_ENTERABLE_BUILDINGS_MEDIAN_HEIGHT=[STWG_ENTERABLE_BUILDINGS_HEIGHTS] call stwf_median;
STWG_ENTERABLE_BUILDINGS_HEIGHTS_QUARTILES=[STWG_ENTERABLE_BUILDINGS_HEIGHTS] call stwf_quartiles;

STWG_ENTERABLE_BUILDINGS_MIN_VOLUME=selectMin STWG_ENTERABLE_BUILDINGS_VOLUMES;
STWG_ENTERABLE_BUILDINGS_MAX_VOLUME=selectMax STWG_ENTERABLE_BUILDINGS_VOLUMES;
STWG_ENTERABLE_BUILDINGS_AVERAGE_VOLUME=[STWG_ENTERABLE_BUILDINGS_VOLUMES] call stwf_average;
STWG_ENTERABLE_BUILDINGS_STDDEV_VOLUME=[STWG_ENTERABLE_BUILDINGS_VOLUMES,STWG_ENTERABLE_BUILDINGS_AVERAGE_VOLUME] call stwf_standardDeviation;
STWG_ENTERABLE_BUILDINGS_MEDIAN_VOLUME=[STWG_ENTERABLE_BUILDINGS_VOLUMES] call stwf_median;
STWG_ENTERABLE_BUILDINGS_VOLUMES_QUARTILES=[STWG_ENTERABLE_BUILDINGS_VOLUMES] call stwf_quartiles;

STWG_ENTERABLE_BUILDINGS_MIN_NROOMS=selectMin STWG_ENTERABLE_BUILDINGS_NROOMS;
STWG_ENTERABLE_BUILDINGS_MAX_NROOMS=selectMax STWG_ENTERABLE_BUILDINGS_NROOMS;
STWG_ENTERABLE_BUILDINGS_AVERAGE_NROOMS=[STWG_ENTERABLE_BUILDINGS_NROOMS] call stwf_average;
STWG_ENTERABLE_BUILDINGS_STDDEV_NROOMS=[STWG_ENTERABLE_BUILDINGS_NROOMS,STWG_ENTERABLE_BUILDINGS_AVERAGE_NROOMS] call stwf_standardDeviation;
STWG_ENTERABLE_BUILDINGS_MEDIAN_NROOMS=[STWG_ENTERABLE_BUILDINGS_NROOMS] call stwf_median;
STWG_ENTERABLE_BUILDINGS_NROOMS_QUARTILES=[STWG_ENTERABLE_BUILDINGS_NROOMS] call stwf_quartiles;


diag_log format ["Number of enterable buildings: %1",STWG_ENTERABLE_BUILDINGS_COUNT];
diag_log format ["Min height %1, Max height: %2",STWG_ENTERABLE_BUILDINGS_MIN_HEIGHT,STWG_ENTERABLE_BUILDINGS_MAX_HEIGHT];
diag_log format ["Average height %1 , stdev height %2, median height %3",
	STWG_ENTERABLE_BUILDINGS_AVERAGE_HEIGHT,
	STWG_ENTERABLE_BUILDINGS_STDDEV_HEIGHT,
	STWG_ENTERABLE_BUILDINGS_MEDIAN_HEIGHT
	];
diag_log format ["Height quartiles:%1",STWG_ENTERABLE_BUILDINGS_HEIGHTS_QUARTILES];

diag_log format ["Min volume %1, Max volume: %2",STWG_ENTERABLE_BUILDINGS_MIN_VOLUME,STWG_ENTERABLE_BUILDINGS_MAX_VOLUME];
diag_log format ["Average volume %1 , stdev volume %2, median volume %3",
	STWG_ENTERABLE_BUILDINGS_AVERAGE_VOLUME,
	STWG_ENTERABLE_BUILDINGS_STDDEV_VOLUME,
	STWG_ENTERABLE_BUILDINGS_MEDIAN_VOLUME
	];
diag_log format ["Volume quartiles:%1",STWG_ENTERABLE_BUILDINGS_VOLUMES_QUARTILES];

diag_log format ["Min nrooms %1, Max nrooms: %2",STWG_ENTERABLE_BUILDINGS_MIN_NROOMS,STWG_ENTERABLE_BUILDINGS_MAX_NROOMS];
diag_log format ["Average nrooms %1 , stdev nrooms %2, median nrooms %3",
	STWG_ENTERABLE_BUILDINGS_AVERAGE_NROOMS,
	STWG_ENTERABLE_BUILDINGS_STDDEV_NROOMS,
	STWG_ENTERABLE_BUILDINGS_MEDIAN_NROOMS
	];
diag_log format ["Nrooms quartiles:%1",STWG_ENTERABLE_BUILDINGS_NROOMS_QUARTILES];

STWG_ENTERABLE_BIG_BUILDINGS=[];
STWG_ENTERABLE_BIG_BUILDINGS_ORIGINAL_INDEXES=[];
STWG_ENTERABLE_BIG_BUILDINGS_NROOMS=[];
_i=0;
{
 _building=_x;
 _n=STWG_ENTERABLE_BUILDINGS_NROOMS select _i;
  _quartiles=STWG_ENTERABLE_BUILDINGS_NROOMS_QUARTILES;
 _nroomsclassification=[_n,_quartiles] call stwf_getStatisticalQuartileBasedClassification;
 if (_nroomsclassification=="BIG") then
 {
	//diag_log format ["Value=%1, classification=%2",_n,_nroomsclassification];
	STWG_ENTERABLE_BIG_BUILDINGS pushBack _building;
	STWG_ENTERABLE_BIG_BUILDINGS_NROOMS pushBack _n;
	STWG_ENTERABLE_BIG_BUILDINGS_ORIGINAL_INDEXES pushBack _i;
 };
 _i=_i+1;
} forEach STWG_ENTERABLE_BUILDINGS;

STWG_ENTERABLE_BIG_BUILDINGS_COUNT= count STWG_ENTERABLE_BIG_BUILDINGS;

STWG_ENTERABLE_BIG_BUILDINGS_MIN_NROOMS=selectMin STWG_ENTERABLE_BIG_BUILDINGS_NROOMS;
STWG_ENTERABLE_BIG_BUILDINGS_MAX_NROOMS=selectMax STWG_ENTERABLE_BIG_BUILDINGS_NROOMS;
STWG_ENTERABLE_BIG_BUILDINGS_AVERAGE_NROOMS=[STWG_ENTERABLE_BIG_BUILDINGS_NROOMS] call stwf_average;
STWG_ENTERABLE_BIG_BUILDINGS_STDDEV_NROOMS=[STWG_ENTERABLE_BIG_BUILDINGS_NROOMS,STWG_ENTERABLE_BIG_BUILDINGS_AVERAGE_NROOMS] call stwf_standardDeviation;
STWG_ENTERABLE_BIG_BUILDINGS_MEDIAN_NROOMS=[STWG_ENTERABLE_BIG_BUILDINGS_NROOMS] call stwf_median;
STWG_ENTERABLE_BIG_BUILDINGS_NROOMS_QUARTILES=[STWG_ENTERABLE_BIG_BUILDINGS_NROOMS] call stwf_quartiles;

diag_log format ["%1 Big buildings",STWG_ENTERABLE_BIG_BUILDINGS_COUNT];
diag_log format ["Min nrooms big buildings %1, Max nrooms  big buildings: %2",STWG_ENTERABLE_BIG_BUILDINGS_MIN_NROOMS,STWG_ENTERABLE_BIG_BUILDINGS_MAX_NROOMS];
diag_log format ["Average nrooms big buildings %1 , stdev nrooms  big buildings %2, median nrooms big buildings %3",
	STWG_ENTERABLE_BIG_BUILDINGS_AVERAGE_NROOMS,
	STWG_ENTERABLE_BIG_BUILDINGS_STDDEV_NROOMS,
	STWG_ENTERABLE_BIG_BUILDINGS_MEDIAN_NROOMS
	];
diag_log format ["Nrooms big building quartiles:%1",STWG_ENTERABLE_BIG_BUILDINGS_NROOMS_QUARTILES];

STWG_ENTERABLE_BIG_BUILDINGS_NROOMS_CLASSIFICATION=[];

_i=0;
_big=0;
_very_big=0;
_huge=0;
{
 _building=_x;
 _n=STWG_ENTERABLE_BIG_BUILDINGS_NROOMS select _i;
 _quartiles=STWG_ENTERABLE_BIG_BUILDINGS_NROOMS_QUARTILES;
 _nroomsclassification=[_n,_quartiles] call stwf_getStatisticalQuartileBasedClassification;
 
 _classification="UNKNOWN";
 if (_nroomsclassification=="SMALL") then
 {
  _classification="BIG";
  _big=_big+1;
 };
 if (_nroomsclassification=="NORMAL") then
 {
  _classification="VERY BIG"; 
  _very_big=_very_big+1;
 };
 if (_nroomsclassification=="BIG") then
 {
  _classification="HUGE";
  _huge=_huge+1;
 };
 
 STWG_ENTERABLE_BIG_BUILDINGS_NROOMS_CLASSIFICATION pushBack _classification;
 //diag_log format ["Nrooms:%1 classification=%2",_n,_classification];
 _i=_i+1;
} forEach STWG_ENTERABLE_BIG_BUILDINGS;

diag_log format ["Big:%1 Very Big: %2 Huge:%3",_big,_very_big,_huge];
//["STWG_ENTERABLE_BIG_BUILDINGS_NROOMS_CLASSIFICATION",
//	STWG_ENTERABLE_BIG_BUILDINGS_NROOMS_CLASSIFICATION] call stwf_showListInLog;



STWG_HUGE_OR_TALL_BUILDINGS_OF_STRATEGICAL_INTEREST=[];
//Locate all huge buildings whose height is over the 
// STWG_ENTERABLE_BUILDINGS_AVERAGE_VOLUME and STWG_ENTERABLE_BUILDINGS_AVERAGE_HEIGHT
_i=0;
_mkrcount=0;
_ntallHugeBuildins=0;
{
 _classification=_x;
 if ((_classification=="HUGE"||_classification=="VERY_BIG")) then
 {
  _original_index=STWG_ENTERABLE_BIG_BUILDINGS_ORIGINAL_INDEXES select _i;
  _height=STWG_ENTERABLE_BUILDINGS_HEIGHTS select _original_index;
  _volume=STWG_ENTERABLE_BUILDINGS_VOLUMES select _original_index;
  if ((_height>1.5*STWG_ENTERABLE_BUILDINGS_AVERAGE_HEIGHT)||(_volume>1.5*STWG_ENTERABLE_BUILDINGS_AVERAGE_VOLUME)) then
  {
    //diag_log format ["Building %1 is huge and its height is %2",_original_index,_height];
	_building=(STWG_ENTERABLE_BUILDINGS select _original_index);
	_buildingPosition=getPos _building; 
	STWG_HUGE_OR_TALL_BUILDINGS_OF_STRATEGICAL_INTEREST pushBack _building; 
	_ntallHugeBuildins=_ntallHugeBuildins+1;
	//_mkrName=format ["mkr_HUGEBUILDING_%1",_mkrcount];
	//_mkr = createmarker [_mkrName, _buildingPosition];
	//_mkr setMarkerShape "Icon";
	//_mkr setMarkerType "hd_warning";
	//_mkr setMarkerColor "ColorOpfor";
	//_mkrcount=_mkrcount+1;
  };
 };
 _i=_i+1;
}  forEach STWG_ENTERABLE_BIG_BUILDINGS_NROOMS_CLASSIFICATION;

diag_log format ["Found %1 tall huge buildings",_ntallHugeBuildins];

#endif