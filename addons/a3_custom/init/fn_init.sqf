// Include shit in here

/*
include map content.
Call compile preprocess'ing them is MUCH better. 
Creating spawn/execvm's IS BAD unless the script is a long running one.
If you try call compile and it all goes to shit, use execvm =P
*/

diag_log "Starting ScienceTechWorks Custom Content PBO";
STWG_NO_ADDON_MODE=false;
STWG_REALDATE_BOOL=false;
STWG_UNITRADAR_INFO_BOOL=false;
STWG_EOS_CITIES_BOOL=false;
STWG_MARKSMEN_IN_HIGH_BUILDINGS_BOOL=false;
STWG_MARKSMEN_IN_WATCH_TOWERS_BOOL=false;
STWG_WEAR_ENEMY_NIGHT_STUFF_BOOL=true;

_script_handler =execvm "a3_custom\framework\STWCommon\STW_ScriptLauncher.sqf";
waitUntil { scriptDone _script_handler };

//to set local date
_str=format ["STWG_REALDATE_BOOL=%1",STWG_REALDATE_BOOL];
diag_log _str;
if (isDedicated && STWG_REALDATE_BOOL) then {
    setDate call compile ("real_date" callExtension "");
};
//or to set GMT date
/*if (isDedicated) then {
    setDate call compile ("real_date" callExtension "GMT");
};*/

//// Add all units to ZEUS
0 = [] spawn {
  while {true} do {
    {_unit = _x;
      if !(_unit getvariable ["edited",false]) then {
        { _x addCuratorEditableObjects [[_unit],true]} forEach AllCurators;
        _unit setvariable ["edited",true]};
    } foreach allUnits + vehicles;
  sleep 60;
  };
};

/////////////////////////////

//If STW__MAP_DATA is not launched, the terrain analyser will be effective.
[[],"a3_custom\framework\STWCommon\STW_MAP_DATA.sqf"] call stwf_execVmSynchronous;

[[], "a3_custom\framework\STWCommon\STW_GlobalConfigurationData.sqf"] call stwf_execVmSynchronous; 
[[], "a3_custom\framework\STWList\STW_List.sqf" ] call stwf_execVmSynchronous;
[[], "a3_custom\framework\STWCommon\STW_Geometry.sqf"] call stwf_execVmSynchronous;
[[], "a3_custom\framework\STWCommon\STW_Statistics.sqf"] call stwf_execVmSynchronous;
[[],"a3_custom\framework\STWCommon\STW_Common.sqf" ] call stwf_execVmSynchronous;
[[], "a3_custom\framework\STWCommon\STW_PrintHelpers.sqf"] call stwf_execVmSynchronous;
[[],"a3_custom\framework\STWCommon\STW_Queue.sqf" ] call stwf_execVmSynchronous;
[[], "a3_custom\framework\STWCommon\STW_PriorityQueue.sqf"] call stwf_execVmSynchronous;
[[],"a3_custom\framework\STWCommon\STW_HashMap.sqf" ] call stwf_execVmSynchronous;
[[], "a3_custom\framework\STWCommon\STW_Shapes.sqf" ] call stwf_execVmSynchronous;
[[], "a3_custom\framework\STWIntel\STW_Intel.sqf" ] call stwf_execVmSynchronous;
[[], "a3_custom\framework\STWCommon\STW_PathFinder.sqf" ] call stwf_execVmSynchronous;
[[],"a3_custom\framework\STWCommon\STW_Buildings.sqf" ] call stwf_execVmSynchronous;
[[],"a3_custom\framework\STWCommon\STW_Squads.sqf" ] call stwf_execVmSynchronous;
[[],"a3_custom\framework\STWPersistence\STW_Persistence.sqf" ] call stwf_execVmSynchronous;
[[],"a3_custom\framework\STWIntel\STW_TerrainAnalysisLauncher.sqf" ] call stwf_execVmSynchronous;
[[],"a3_custom\STWEOS\OpenMe.sqf" ] call stwf_execVmSynchronous;
[[],"a3_custom\STWLand\STW_Cities.sqf" ] call stwf_execVmSynchronous;



STW_TASKS_BRIEFING=[west];
STW_MISSION_TASKS_WEST=[west];

waitUntil{ STWG_WATER_AREAS_LIST_READY };


//[MarkerName,[MarkerSizeX,MarkerSizeY],position2D,color,alpha]
stwf_GenerateSpawnMarker=
{
    params["_markerName","_markerSize","_position2D","_color","_alpha"];
	diag_log format ["RESPAWN MARKER Name %1 Position %2",_markerName,_position2D];
	_mkr = createMarker[ _markerName,_position2D];
	_mkr setMarkerShape "ELLIPSE";
	_lw=(_markerSize select 0);
	_lh=(_markerSize select 1);
	_lradius=_lw;
	//if (_lw>_lh) then { _lradius=_lw} else {_lradius=_lh};
	_mkr setMarkerSize [_lw,_lh]; //[ _lradius, _lradius ];
	_mkr setMarkerColor _color;	
	_mkr setMarkerAlpha _alpha;
	_mkr;
};

stwf_markPossibleWaterRewspawnAreas=
{
 _possibleNodeIndexes=[];
 //Search water positions indexes between 100 and 300 m from the land
// STWG_WATER_TO_LAND_DISTANCES YES
 _nodeIndex=0;
 {
  _dist=_x;
  if ((_dist>150)&&(_dist<400)) then
  {
   _possibleNodeIndexes pushBack _nodeIndex;
  };
  _nodeIndex=_nodeIndex+1;
 } forEach STWG_WATER_TO_LAND_DISTANCES;
 
 // Get the centers of those indexes
 _centers=[];
 {
  _index=_x;
  _centers pushBack (STWG_WATER_AREAS_CENTERS select _index);
 } forEach _possibleNodeIndexes;

  // Filter _centers so that are not too close one from another
 _disperseCenters=[];
 {
  _center=_x;
  _addToList=true;
  {
   _ncenter=_x;
    if ((_center distance2D _ncenter)<2000) exitWith {_addToList=false};
  } forEach _disperseCenters;
  if (_addToList) then
  {
   _disperseCenters pushBack _center;
  };
 } forEach _centers;
 _centers=_disperseCenters;
 
 //Place a respawn mark on each centers
 _markIndex=1;
 _numMarks=0;
 {
   _center=_x;
   _markerName=format ["respawn_west_%1",_markIndex];
   [_markerName,[10,10],_center,"ColorBlue",0.0] call stwf_GenerateSpawnMarker;
   _markIndex=_markIndex+1;
   _numMarks=_numMarks+1;
   if (_numMarks>20) exitWith{true}; //max respawn marks
 } forEach (_centers call BIS_fnc_arrayShuffle);
 
};

diag_log "CREATING RESPAWN MARKERS";
[] call stwf_markPossibleWaterRewspawnAreas;


//[100,30] execvm "a3_custom\STWFurniture\STW_Furniture.sqf";



//call compilefinal preprocessFileLineNumbers "a3_custom\framework\STWList\STW_List.sqf";
//call compilefinal preprocessFileLineNumbers "a3_custom\framework\STWCommon\STW_Common.sqf";
//[50,10] call compilefinal preprocessFileLineNumbers "a3_custom\STWFurniture\STW_Furniture.sqf";
//call compilefinal preprocessFileLineNumbers "a3_custom\framework\HashMap\oo_hashmap.sqf";

_str=format ["STWG_MARKSMEN_IN_HIGH_BUILDINGS_BOOL=%1",STWG_MARKSMEN_IN_HIGH_BUILDINGS_BOOL];
diag_log _str;
if (STWG_MARKSMEN_IN_HIGH_BUILDINGS_BOOL) then
{
	[[], "a3_custom\STWLand\STW_PutMarksmenInHighBuildings.sqf" ] call stwf_execVm;
};

_str=format ["STWG_MARKSMEN_IN_WATCH_TOWERS_BOOL=%1",STWG_MARKSMEN_IN_WATCH_TOWERS_BOOL];
diag_log _str;
if (STWG_MARKSMEN_IN_WATCH_TOWERS_BOOL) then
{
	[[], "a3_custom\STWLand\STW_PutMarksmenInWatchTowers.sqf" ] call stwf_execVm;
};


[[], "a3_custom\STWPatrolSquads\STW_PatrolSquads.sqf" ] call stwf_execVm;

//[[], "a3_custom\STWArmouredTraffic\STW_ArmouredTraffic.sqf" ] call stwf_execVm;
//[] execvm  "a3_custom\STWAnimals\STWAnimals.sqf";
//[] execVM "a3_custom\STWCivilTrafic\STW_CivilTrafic.sqf";
//[] execvm "a3_custom\STWLand\STW_ThingsToBlowUp.sqf";


[[], "a3_custom\STWAireal\STW_AirealTraffic.sqf" ] call stwf_execVm;
//[[], "a3_custom\STWAIHearing\STW_AIHearing.sqf"] call stwf_execVm;
if (STWG_WEAR_ENEMY_NIGHT_STUFF_BOOL) then
{
	[[], "a3_custom\STWNIGHT\STW_Night.sqf"] call stwf_execVm;
};

[[], "a3_custom\STWEvents\STW_MPKillHandlerService.sqf"] call stwf_execVm;

//compile preprocessFile ("a3_custom\STWwater\STW_WaterUtils.sqf");
[[], "a3_custom\STWwater\STW_WaterUtils.sqf"] call stwf_execVm;
//[] execVm "a3_custom\STWwater\STW_WaterUtils.sqf";

diag_log "Launching boats";
for [{_i=0},{_i<STWG_NUMBER_OF_COMBAT_BOATS},{_i=_i+1}] do
{
	[[], "a3_custom\STWwater\STWSpawnEnemyShip.sqf"] call stwf_execVm;
};


_str=format ["STWG_UNITRADAR_INFO_BOOL=%1",STWG_UNITRADAR_INFO_BOOL];
diag_log _str;
if (STWG_UNITRADAR_INFO_BOOL) then 
{
	[[], "a3_custom\STWLand\STW_UnitRadar.sqf" ] call stwf_execVm;
};

[[],"a3_custom\STWEvents\STW_OnServerVariableReceived.sqf" ] call stwf_execVm;

sleep 60;
diag_log "Launching Task Manager";
[[], "a3_custom\STWLand\STW_MissionTasksManager.sqf" ] call stwf_execVm;