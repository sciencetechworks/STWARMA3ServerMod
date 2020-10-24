// Include shit in here

/*
include map content.
Call compile preprocess'ing them is MUCH better. 
Creating spawn/execvm's IS BAD unless the script is a long running one.
If you try call compile and it all goes to shit, use execvm =P
*/

STWG_NO_ADDON_MODE=true;
diag_log "Starting ScienceTechWorks Custom Content PBO in LOCAL DEBUG MODE";

_script_handler =execvm "@STWCustom\addons\a3_custom\framework\STWCommon\STW_ScriptLauncher.sqf";
waitUntil { scriptDone _script_handler };

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
//[[],"a3_custom\STWEOS\OpenMe.sqf" ] call stwf_execVmSynchronous;
//[[],"a3_custom\STWLand\STW_Cities.sqf" ] call stwf_execVmSynchronous;

//_script_handler = [] execVM "@STWCustom\addons\a3_custom\STWLand\STW_Cities.sqf";
//waitUntil { scriptDone _script_handler };
//[]execVM "a3_custom\STWEOS\OpenMe.sqf";

//[] execVM "@STWCustom\addons\a3_custom\STWPatrolSquads\STW_PatrolSquads.sqf";
//[] execvm "@STWCustom\addons\a3_custom\STWNIGHT\STW_Night.sqf";
//[] execvm "@STWCustom\addons\a3_custom\STWAIHearing\STW_AIHearing.sqf";

STW_TASKS_BRIEFING=[west];
STW_MISSION_TASKS_WEST=[west];
//[] execVM "@STWCustom\addons\a3_custom\STWLand\STW_MissionTasksManager.sqf";


//
//STW_TASKS_BRIEFING=[west];
//STW_MISSION_TASKS_WEST=[west];
//
////[100,30] execvm "a3_custom\STWFurniture\STW_Furniture.sqf";
//
//

//
////call compilefinal preprocessFileLineNumbers "a3_custom\framework\STWList\STW_List.sqf";
////call compilefinal preprocessFileLineNumbers "a3_custom\framework\STWCommon\STW_Common.sqf";
////[50,10] call compilefinal preprocessFileLineNumbers "a3_custom\STWFurniture\STW_Furniture.sqf";
////call compilefinal preprocessFileLineNumbers "a3_custom\framework\HashMap\oo_hashmap.sqf";
//
//


////nul = [] execVM "a3_custom\STWLand\STW_UnitRadar.sqf";
//[] execvm "@STWCustom\addons\a3_custom\STWAireal\STW_AirealTraffic.sqf";
//[] execVM "a3_custom\STWArmouredTraffic\STW_ArmouredTraffic.sqf";
//[] execvm  "a3_custom\STWAnimals\STWAnimals.sqf";
//
//
//[] execVM "a3_custom\STWCivilTrafic\STW_CivilTrafic.sqf";
//
//[] execvm "@STWCustom\addons\a3_custom\STWLand\STW_PutMarksmenInHighBuildings.sqf";
////[] execvm "a3_custom\STWLand\STW_ThingsToBlowUp.sqf";


//[] execvm "@STWCustom\addons\a3_custom\STWLand\STW_PutMarksmenInWatchTowers.sqf";


/*
waitUntil{ STWG_WATER_AREAS_LIST_READY };
diag_log "Launching boats";
//compile preprocessFile ("a3_custom\STWwater\STW_WaterUtils.sqf");
[] execVm "@STWCustom\addons\a3_custom\STWwater\STW_WaterUtils.sqf";
[] execVM "@STWCustom\addons\a3_custom\STWwater\STWSpawnEnemyShip.sqf";
[] execVM "@STWCustom\addons\a3_custom\STWwater\STWSpawnEnemyShip.sqf";
[] execVM "@STWCustom\addons\a3_custom\STWwater\STWSpawnEnemyShip.sqf";
*/


//[MarkerName,[MarkerSizeX,MarkerSizeY],position2D,color,alpha]
//stwf_GenerateSpawnMarker=
//{
//    params["_markerName","_markerSize","_position2D","_color","_alpha"];
//	diag_log format ["Name %1 Position %2",_markerName,_position2D];
//	_mkr = createMarker[ _markerName,_position2D];
//	_mkr setMarkerShape "ELLIPSE";
//	_lw=(_markerSize select 0);
//	_lh=(_markerSize select 1);
//	_lradius=_lw;
//	//if (_lw>_lh) then { _lradius=_lw} else {_lradius=_lh};
//	_mkr setMarkerSize [_lw,_lh]; //[ _lradius, _lradius ];
//	_mkr setMarkerColor _color;	
//	_mkr setMarkerAlpha _alpha;
//	_mkr;
//};
//
//stwf_markPossibleWaterRewspawnAreas=
//{
// _possibleNodeIndexes=[];
// //Search water positions indexes between 100 and 300 m from the land
//// STWG_WATER_TO_LAND_DISTANCES YES
// _nodeIndex=0;
// {
//  _dist=_x;
//  if ((_dist>150)&&(_dist<400)) then
//  {
//   _possibleNodeIndexes pushBack _nodeIndex;
//  };
//  _nodeIndex=_nodeIndex+1;
// } forEach STWG_WATER_TO_LAND_DISTANCES;
// 
// // Get the centers of those indexes
// _centers=[];
// {
//  _index=_x;
//  _centers pushBack (STWG_WATER_AREAS_CENTERS select _index);
// } forEach _possibleNodeIndexes;
//
// //Place a respawn mark on each centers
// _markIndex=1;
// _numMarks=0;
// _num=count _centers;
// {
//   _center=_x;
//   _markerName=format ["respawn_west_%1",_markIndex];
//   [_markerName,[10,10],_center,"ColorBlue",1.0] call stwf_GenerateSpawnMarker;
//   _markIndex=(_markIndex+10)%_num;
//   _numMarks=_numMarks+1;
//   if (_numMarks>20) exitWith{true}; //max respawn marks
// } forEach (_centers call BIS_fnc_arrayShuffle);
// 
//};
//
//[] call stwf_markPossibleWaterRewspawnAreas;
