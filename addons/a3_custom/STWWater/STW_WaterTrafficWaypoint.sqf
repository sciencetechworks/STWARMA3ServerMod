fstwGetRandomWaterZone=
{
 _result= selectRandom STWG_WATER_ZONES;
 _result
};

fstwGetZoneCenter=
{
 _zone=_this;
 _x0=(_zone select 0) select 0;
 _y0=(_zone select 0) select 1;
 
 _x1=(_zone select 1) select 0;
 _y1=(_zone select 1) select 1;
 
 _x=_x0+((_x1-_x0)/2);
 _y=_y0+((_y1-_y0)/2);
 
 [_x,_y]
};

_stwfRefreshWaterTrafficWaypoint=
{
 params ["_grp"];
 _grp=_this;
 _leader = leader _grp;
 _grp= group _leader;
 _veh=vehicle _leader;

 _zone=[] call fstwGetRandomWaterZone; 
 _position = _zone call fstwGetZoneCenter;
  //diag_log format ["Enemy ship new waypoint %1",_position];
 _wpoint=_grp addWaypoint [_position, 0];
 
 _script="";
 if (STWG_NO_ADDON_MODE) then
 {
 	_script="if (!isServer) exitWith{}; nul = this execVM '@STWCustom\addons\a3_custom\STWWater\STW_WaterTrafficWaypoint.sqf'";
 } else
 {	
		_script="if (!isServer) exitWith{}; nul = this execVM 'a3_custom\STWWater\STW_WaterTrafficWaypoint.sqf'";
 };
	
 
 [_grp,1] setWaypointStatements ["true",_script];
 sleep (floor random 10)+60;
};

_this call _stwfRefreshWaterTrafficWaypoint;