if (!isServer) exitWith{};



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



//Do not call too quickly, wait until there are areas into stwWaterZonesList
_fstwGenerateEnemyShip=
{
	diag_log format ["Generating enemy ship."];
	_zone=[] call fstwGetRandomWaterZone;
	_position = _zone call fstwGetZoneCenter; 
	diag_log format ["Enemy ship position %1",_position];
	_boats=STWG_COMBAT_BOATS;
	
	_veh = createVehicle [selectRandom _boats, _position, [], 0, "NONE"];
	createVehicleCrew _veh;
		
	createVehicleCrew _veh;
	{
		//diag_log [_x, faction _x, side _x, side group _x];
		alive _x;
	} forEach crew _veh;
	
	_id = _veh addEventHandler ["killed", {[] execVM "a3_custom\STWWater\STWSpawnEnemyShip.sqf";}];
	
	_driver= driver _veh;
	_grp= group _driver;
	_grp deleteGroupWhenEmpty true;
	
	 _scriptPath="";
	 if (STWG_NO_ADDON_MODE) then
	 {
		_scriptPath="@STWCustom\addons\a3_custom\STWWater\STWRefreshShipWaypoint.sqf";
	 } else
	 {	
		 _scriptPath="a3_custom\STWWater\STWRefreshShipWaypoint.sqf";
	 };
	
	nul = _driver execVM _scriptPath;
	_null = _veh spawn 
	{
		while {alive _this} do {_this setFuel 0.75; sleep 300;};
	};
};

[] call _fstwGenerateEnemyShip;