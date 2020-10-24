#ifndef  STW_DetectWaterAreasInit_Module_Loaded
#define STW_DetectWaterAreasInit_Module_Loaded true
//diag_log "STW_DetectWaterAreasInit_Module_Loaded";

if (!isServer) exitWith{};


STW_WATERZONES_MODULE_READY=true;
if (!isNil "STWG_WATER_AREAS_PATH_GRAPH") exitWith{STWG_WATER_AREAS_LIST_READY=true};





_fstwSizeOfArea=
{
	_zone=_this;
	//diag_log format ["_fstwSizeOfArea zone=%1",_zone];
	_x0=(_zone select 0) select 0;
	_y0=(_zone select 0) select 1;
	_x1=(_zone select 1) select 0;
	_y1=(_zone select 1) select 1;
	_base=(_x1-_x0)/1000;
	_height=(_y1-_y0)/1000;
	_area=_base*_height;
	//diag_log format ["<area>%1</area>",_area];
	_area
};


_fstwDivideZoneIn4=
{
  _zone=_this;
  _up2Dcoord=_zone select 0;
  _down2Dcoord=_zone select 1;
  _x0=_up2Dcoord select 0;
  _y0=_up2Dcoord select 1;
  _x1=_down2Dcoord select 0;
  _y1=_down2Dcoord select 1;
  _xn=_x0+((_x1-_x0)/2);
  _yn=_y0+((_y1-_y0)/2);
  _zA=[[_x0,_y0],[_xn,_yn]];
  _zB=[[_xn,_y0],[_x1,_yn]];
  _zC=[[_x0,_yn],[_xn,_y1]];
  _zD=[[_xn,_yn],[_x1,_y1]];
  _zones =[_zA,_zB,_zC,_zD];
  
  //{
  // _x call markZoneAsWaterSquare;
  //} foreach _zones;
  _zones
};

_fstwIsAllZoneWater=
{
	//diag_log format ["<_fstwIsAllZoneWater zone=%1>",_zone];
	_areaUpCorner2D=_this select 0;
	_areaDownCorner2D=_this select 1;
	_x0=_areaUpCorner2D select 0;
	_y0=_areaUpCorner2D select 1;
	_x1=_areaDownCorner2D select 0;
	_y1=_areaDownCorner2D select 1;
	_step=(_x1-_x0)/10;
	
	//diag_log format ["_fstwIsAllZoneWater [%1,%2],[%3,%4]",_x0,_y0,_x1,_y1];
	_breakLoop=false;
	_result=true;
	for [ {private "_x"; _x=_x0;},{((_x<_x1)&&(!_breakLoop))},{_x=_x+_step}] do
	{
		for [ {private "_y"; _y=_y0;},{((_y<_y1)&&(!_breakLoop))},{_y=_y+_step}] do
		{
			_isWater=surfaceIsWater [_x,_y];
			if (!_isWater) then
			{
				//diag_log format ["Found LAND"];
				//[_x,_y] call markLANDWithDot;
				_result=false;
				_breakLoop=true;
			};
		};
	};
	
	//if (_result) then
	//{
	//  diag_log format ["_fstwIsAllZoneWater zone=%1 IS ALL WATER",_zone];
	//};
	//diag_log format ["</_fstwIsAllZoneWater>"];
	_result
};



_fstwDetectWaterAreas=
{
	params ["_zones","_depth"];
	//if (!isNil("STWG_WATER_ZONES")) exitWith {STWG_WATER_AREAS_LIST_READY=true;};
	//diag_log format ["<_fstwDetectWaterAreas [%1] %2>",_depth,_zones];
	_counter=1;	
		
	{
		//diag_log format ["zone: %1",_x];
		_zone=_x;
		_counter=1;
		_areaSize=(_zone call _fstwSizeOfArea);
		if (_areaSize>STWG_WATER_AREAS_SCAN_RESOLUTION_FACTOR) then
		{
			_zoneIsAllWater=_zone call _fstwIsAllZoneWater;
			if (!_zoneIsAllWater) then 
			{ 
				_childrenZones=_zone call _fstwDivideZoneIn4;
				_scriptPath="PATH";
				if (STWG_NO_ADDON_MODE) then
				{
					_scriptPath="@STWCustom\addons\a3_custom\STWWater\STW_DetectWaterAreasInit.sqf";
				} else
				{	
					_scriptPath="a3_custom\STWWater\STW_DetectWaterAreasInit.sqf";
				};
	
				_script_handler =[_childrenZones,_depth+1] execvm _scriptPath;
				//==>STANDALONE WAS: [_childrenZones,_depth+1]  execVm "water\STW_DetectWaterAreasInit.sqf";
				
				waitUntil { scriptDone _script_handler };
			} else
			{
				_zone call markZoneAsWaterSquare;
				STWG_WATER_ZONES pushBack _zone;
			};
		};
		sleep 0.02;
	}foreach _zones;
	
	//diag_log format ["DEPTH:%1",_depth];
	if (_depth==0) then
	{
	 ["STW_WATER_ZONES",STWG_WATER_ZONES] call stwf_copyArrayToClipBoard;
	 diag_log "Detect Water Areas Finished, areas were copied to clipboard.";
	 STWG_WATER_AREAS_LIST_READY=true;
	};
	
	//_zonesFound=count STWG_WATER_ZONES;
};
//diag_log format ["_________DETECT WATER AREAS_____________________________ "];
_this call _fstwDetectWaterAreas; 
#endif