#ifndef  STW_UnitRadar_Module_Loaded
#define STW_UnitRadar_Module_Loaded true
diag_log "STW_UnitRadar_Module Loaded";
if (!isServer) exitWith{};

waitUntil {(count ([] call BIS_fnc_listPlayers))>0};


[] spawn
{
  while {true} do
  {
 	waitUntil {(count ([] call BIS_fnc_listPlayers))>0};
    _playerUnitsPositions=[];
	_eastUnitsPositions=[];
	_westUnitsPositions=[];
	_civilUnitsPositions=[];
	{
	  _unit=_x;
	  _position=getPos _unit;
	  _position2D=[_position select 0,_position select 1];
	  if (isPlayer _unit) then
	  {
		_playerUnitsPositions append _position2D;
	  } else
	  {
		  if (side _unit == west) then
		  {
			_westUnitsPositions append _position2D;
		  };
		  if (side _unit == east) then
		  {
			_eastUnitsPositions append _position2D;
		  };
		  if (side _unit == civilian) then
		  {
			_civilianUnitsPositions append _position2D;
		  };
	  };
	} forEach allUnits;
	
	_str=format ["<STW>",worldSize];
	diag_log _str;
	_str=format ["<WS>%1</WS>",worldSize]; //world size
	diag_log _str;
	
	_str=format ["<PU>%1</PU>",_playerUnitsPositions];
	diag_log _str;
	
	_str=format ["<WU>%1</WU>",_westUnitsPositions];
	diag_log _str;
	
	_str=format ["<EU>%1</EU>",_eastUnitsPositions];
	diag_log _str;

	_str=format ["<CU>%1</CU>",_eastUnitsPositions];
	diag_log _str;
	
	_str=format ["</STW>"];
	diag_log _str;
	sleep 5;
  };
};

#endif