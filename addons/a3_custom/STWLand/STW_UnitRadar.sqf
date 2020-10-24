// Generates unit information in real time as XML
// allowing the log to contain the positions of
// each unit as a RADAR to be loaded by a JAVA servlet

#ifndef  STW_UnitRadar_Module_Loaded
#define STW_UnitRadar_Module_Loaded true
diag_log "STW_UnitRadar_Module Loaded";
if (!isServer) exitWith{};

waitUntil {(count ([] call BIS_fnc_listPlayers))>0};


stwf_unitPositionInfo={
	params ["_unit"];
	_str="";
	
	_unitPositions=[];
	_unitSides=[];
	_unitPlayers=[];
	
	_side=side _unit;
	_position=getPos _unit;
	_position= [round (_position select 0),round (_position select 1)]; //,round (_position select 2)];
	_str=_str+"<STW_RADAR_UNIT>";
	//_str=_str+"<SCAN_TIME> </SCAN_TIME>"; //"<SCAN_TIME>"+(str time)+"</SCAN_TIME>";
	_str=_str+"<POSITION>"+(str _position)+"</POSITION>";
	_str=_str+"<SIDE>"+(str _side)+"</SIDE>";
	if (isPlayer _unit) then
	{
		_str=_str+"<PLAYER/>"; //+(str (isPlayer _unit))+"</IS_PLAYER>";
		_str=_str+"<NAME>"+name _unit+"</NAME>";
		_str=_str+"<HEADING>"+(str (getDir _unit))+"</HEADING>";
	};
	//_str=_str+"<NAME>"+name _unit+"</NAME>";
	//_str=_str+"<TYPE>"+(typeOf _unit)+"</TYPE>";
	_str=_str+"</STW_RADAR_UNIT>";
	
	_str;
};



[] spawn
{
	while {true} do
	{
		_scannedUnitsLog=[];
		_units=[];
		waitUntil {(count ([] call BIS_fnc_listPlayers))>0};
		{
			_unit=_x;
			if (alive _unit) then
			{
				_position= getPos _unit;
				_minDist=[_position] call stwf_getMinimumDistanceToPlayers;
				if (_minDist<800) then
				{
					_entry= [_unit] call stwf_unitPositionInfo;
					_scannedUnitsLog pushBack _entry;
				};
			};

		} forEach allUnits;
		_str=format ["<STW_SCAN>",worldSize];
		diag_log _str;
		_str=format ["<STW_WORLD_SIZE>%1</STW_WORLD_SIZE>",worldSize];
		diag_log _str;
		{
			diag_log _x;
		} forEach _scannedUnitsLog;
		_str=format ["</STW_SCAN>",worldSize];
		diag_log _str;
		sleep 5;
	};
};

#endif