#ifndef  STW_UnitRadar_Module_Loaded
#define STW_UnitRadar_Module_Loaded true
diag_log "STW_UnitRadar_Module Loaded";
if (!isServer) exitWith{};

waitUntil {(count ([] call BIS_fnc_listPlayers))>0};


stwf_logUnitPosition={
	params ["_unit"];
	_str="";
		
	_unitPositions=[];
	_unitSides=[];
	_unitPlayers=[];
	
	_side=side _unit;
	_position=getPos _unit;
	_position= [round (_position select 0),round (_position select 1),round (_position select 2)];
	_str=_str+"<STW_RADAR_UNIT>";
	_str=_str+"<SCAN_TIME>"+(str time)+"</SCAN_TIME>";
	_str=_str+"<POSITION>"+(str _position)+"</POSITION>";
	_str=_str+"<SIDE>"+(str _side)+"</SIDE>";
	_str=_str+"<IS_PLAYER>"+(str (isPlayer _unit))+"</IS_PLAYER>";
	_str=_str+"<NAME>"+name _unit+"</NAME>";
	_str=_str+"<TYPE>"+(typeOf _unit)+"</TYPE>";
	
	_str=_str+"</STW_RADAR_UNIT>";
	
	diag_log _str;
};



[] spawn
{
  while {true} do
  {
	_units=[];
	waitUntil {(count ([] call BIS_fnc_listPlayers))>0};
	_str=format ["<STW_SCAN>",worldSize];
	diag_log _str;
	_str=format ["<STW_WORLD_SIZE>%1</STW_WORLD_SIZE>",worldSize];
	diag_log _str;
	{
		_unit=_x;
		if (alive _unit) then
		{
		  [_unit] call stwf_logUnitPosition;
		};
		sleep 1;
	} forEach allUnits;
	_str=format ["</STW_SCAN>",worldSize];
	diag_log _str;
  };
};

#endif