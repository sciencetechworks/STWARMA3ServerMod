#ifndef  STW_PutMarksmenInHighBuildings_Module_Loaded
#define  STW_PutMarksmenInHighBuildings_Module_Loaded true
diag_log "STW_PutMarksmenInHighBuildings Loaded";

if (!isServer) exitWith{};

waitUntil {(count ([] call BIS_fnc_listPlayers))>0};

_PROBABILITY_OF_A_TALL_BUILDING_BEING_OCCUPIED=50;
_MAX_OCCUPIED_BUILDINGS=10;

//[BuildingZPositions]
stwf_buildingPosOrderIndexMaxToMinHeight=
{
 _indexOrder=[];
 _buildingPositions=_this;
  _zs=[];
 {
  _pos=_x;
  _zs pushBack (_pos select 2);
 } forEach _buildingPositions;

 // diag_log format ["Building zs:%1",_zs];
 _len=count _zs;
 //diag_log format ["len %1,zs: %2",_len,_zs];
 for "_i" from 0 to (_len-1) do
 {
 // diag_log format ["i:%1",_i];
  _indexOrder pushBack [_zs select _i,_i];
 };
 //diag_log format ["Before ordering %1",_indexOrder];
 _indexOrder sort false;
 // diag_log format ["After ordering %1",_indexOrder];
 _result=[];
 {
	_elem=_x;
	//diag_log format ["elem %1",_elem];
	_index=_elem select 1;
	_result pushBack _index;
 } forEach _indexOrder;
 //diag_log format ["ordered zs index:%1",_result];
 _result;
};




//[BuildingInfo,[unittypes]]
stwf_PopulateBuildingWithTroops={
			_buildingInfo= _this select 0;
			_unitTypes=_this select 1;
			_building = _buildingInfo select _BBUILDING;
			_buildingPositions=_buildingInfo select _BPOSITIONS;
			_nBuildingPositions=_buildingInfo select _BNPOS;
			_bpos=0;
			_positionsToOccupy=4+_nBuildingPositions/4;
			_buildingPositionsBackHeightOrdered=_buildingPositions call stwf_buildingPosOrderIndexMaxToMinHeight;
			_grp=createGroup EAST;
			_grp enableDynamicSimulation true;
			_selectedBuildingPositionIndex=0;
			{
				_buildingPosition=_x;
				if (_bpos<_positionsToOccupy) then
				{
				_unit = _grp createUnit [selectRandom _unitTypes, _buildingPosition, [], 100, "NONE"] ;   
				[_unit] join _grp ;
				_unit forceSpeed 0;
				_unit enableDynamicSimulation true;
				//doStop _unit;
				//_unit disableAI "PATH";
				_unit setPos ((_building) buildingPos (_buildingPositionsBackHeightOrdered select _selectedBuildingPositionIndex));
				_selectedBuildingPositionIndex=_selectedBuildingPositionIndex+1;
				//if (random 100>95) then
				//{
				// _task=["Kill"+name _unit,_unit] call stwf_launchDestroyUnitMission;
				// [_task] call FHQ_fnc_ttAddTasks;
				//};
				
				// diag_log format ["Unit created."];
					/*{
						_zeus=_x;
						_zeus addCuratorEditableObjects [[_unit],true];
					} forEach allCurators;*/
				};
				
				_bpos=_bpos+1;
			} forEach _buildingPositions;
};




_nBuildings= [] call stwf_getAllBuildingsCount;
_buildings = [] call stwf_getAllBuildings;

diag_log format ["%1 Buildings found.", _nBuildings];
_nEnterableBuildings= [] call stwf_getAllEnterableBuildingsCount;
_enterableBuildings= [] call stwf_getAllEnterableBuildings;

_BBUILDING=0;
_BPOS=1;
_BNPOS=2;
_BPOSITIONS=3;
_BHEIGHT=4;
_BVOLUME=5;
_buildingsInfo=[]; 

{
 _building=_x;
 _buildingPosition=getPosATL _building;
 _buildingHeight=[_building] call stwf_getObjectHeight;
 _buildingVolume=[_building] call stwf_getObjectVolume;
 
  
 _innerBuildingPositions=[_building] call BIS_fnc_buildingPositions;
 _nInnerBuildingPositions=count _innerBuildingPositions;
 
 
//_innerPositionNumber=0;
//{
// _innerBuildigPosition=_x;
// diag_log format ["  Position in building:%1 = %2",_innerPositionNumber,_innerBuildigPosition];
// _innerPositionNumber=_innerPositionNumber+1;
//} forEach _innerBuildingPositions;
 
 _buildingInfo=[_building,_buildingPosition,_nInnerBuildingPositions,_innerBuildingPositions,_buildingHeight,_buildingVolume];
 _buildingsInfo pushBack _buildingInfo;
// diag_log format ["%1",_buildingInfo];
 
} forEach _enterableBuildings;


_buildingHeightsSample=[] call stwf_getAllBuildingsHeights;


_buildingVolumeSample=[] call stwf_getAllBuildingsVolumes;

_buildingNPositionsSample=[];
{
 _buildingInfo=_x;
 _npos=_buildingInfo select _BNPOS;
 _buildingNPositionsSample pushBack _npos;
} forEach _buildingsInfo;


_averageHeight=[_buildingHeightsSample] call stwf_average;
_heightStandardDeviation=[_buildingHeightsSample,_averageHeight] call stwf_standardDeviation;
diag_log format ["Average Building Height: %1",_averageHeight];
diag_log format ["Building height standard deviation: %1",_heightStandardDeviation];


_averageVolume=[_buildingVolumeSample] call stwf_average;
_volumeStandardDeviation=[_buildingVolumeSample,_averageVolume] call stwf_standardDeviation;
diag_log format ["Average Building Volume: %1",_averageVolume];
diag_log format ["Building volume standard deviation: %1",_volumeStandardDeviation];

_averageNPositions=[_buildingNPositionsSample] call stwf_average;
_nPositionsStandardDeviation=[_buildingNPositionsSample,_averageNPositions] call stwf_standardDeviation;
diag_log format ["Average Positions per Building: %1",_averageNPositions];
diag_log format ["Building number of positions standard deviation: %1",_nPositionsStandardDeviation];


_grp = nil;
_nTallBuildings=0;
_nOccupiedBuildings=0;
_mkrcount=0;
{
  _buildingInfo=_x;
  _building=_buildingInfo select _BBUILDING;
  _occupied=random 100;
  _distanceToPlayers=[(getPos _building)] call stwf_getMinimumDistanceToPlayers;
   if (_nOccupiedBuildings<_MAX_OCCUPIED_BUILDINGS) then
   {
     if (_distanceToPlayers>2000)  then 
	 {
	  if (_occupied<=_PROBABILITY_OF_A_TALL_BUILDING_BEING_OCCUPIED) then
	  { 							//some MAGIC NUMBERS
		  if (
		  (_buildingInfo select _BHEIGHT > _averageHeight+5*_heightStandardDeviation)||	
		  (_buildingInfo select _BVOLUME > _averageVolume+4*_volumeStandardDeviation)
		  )	  then
		  {
			diag_log  format ["Tall building:%1",_buildingInfo];
			[_buildingInfo,[
			"rhs_msv_emr_marksman","rhs_msv_emr_rifleman","rhs_msv_emr_efreitor","rhs_msv_emr_machinegunner",
			"rhs_msv_emr_marksman","rhs_msv_emr_rifleman","rhs_msv_emr_efreitor","rhs_msv_emr_machinegunner",
			"rhs_msv_emr_marksman","rhs_msv_emr_rifleman","rhs_msv_emr_efreitor","rhs_msv_emr_machinegunner",
			"rhs_msv_emr_marksman","rhs_msv_emr_rifleman","rhs_msv_emr_efreitor","rhs_msv_emr_machinegunner",
			"rhs_msv_emr_marksman","rhs_msv_emr_rifleman","rhs_msv_emr_efreitor","rhs_msv_emr_machinegunner",
			"rhs_msv_emr_aa","rhs_msv_emr_at","rhs_msv_emr_machinegunner","rhs_msv_emr_medic","rhs_msv_emr_sergeant",
			"rhs_msv_emr_officer","rhs_msv_emr_engineer"]] call stwf_PopulateBuildingWithTroops;
			
			if ([75] call stwf_probabilityCheck) then 
			{ 
				_mkrName=format ["mkr_occupiedBuilding_%1",_mkrcount];
				_mkr = createmarker [_mkrName, getPos _building];
				_mkr setMarkerShape "Icon";
				_mkr setMarkerType "hd_warning";
				_mkr setMarkerColor "ColorOpfor";
				_mkrcount=_mkrcount+1;
			};
			
			_nOccupiedBuildings=_nOccupiedBuildings+1;
		};
		_nTallBuildings=_nTallBuildings+1;
	  };
	 };
    };
} forEach _buildingsInfo call BIS_fnc_arrayShuffle;

diag_log  format ["%1 Tall Buildings Located",_nTallBuildings];
diag_log format ["%1 Occupied tall buildings",_nOccupiedBuildings];

#endif