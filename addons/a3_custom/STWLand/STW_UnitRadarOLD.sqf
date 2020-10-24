
if (!isServer) exitWith{};

STW_AWAC_RADAR_REFRESH_SECONDS=60;
waitUntil {(count ([] call BIS_fnc_listPlayers))>0};

//unit_list
stwf_persistUnitPosition={
	_unitList=_this;
	diag_log format ["///////////////////////STW RADAR DATA CREATION."];
	
	
	_unitPositions=[];
	_unitSides=[];
	_unitPlayers=[];
	
	_count=0;
	{
		_unit=_x;
			_side=side _unit;
			if ((_side==WEST)||(_side==EAST)) then
			{
				_position=getPos _unit;
				_position= [round (_position select 0),round (_position select 1),round (_position select 2)];
				_unitPositions pushBack (str _position);
				_unitSides pushBack (str _side);
				_unitPlayers pushBack (str (isPlayer _unit));
				_count=_count+1;
				//_unitInfo= str [_position,_side,isPlayer _unit,name _unit,typeOf _unit];
			};
	} forEach _unitList;	
	_nunits=_count;
	_dbName="STWPERSISTENCE_UNITRADAR";
	_stwPersistenceDatabase = ["new", "inidbi"] call OO_PDW;
	["setDbName", _dbName] call _stwPersistenceDatabase;
	_bool = ["write",["BLOCKED", "TRUE"]] call _stwPersistenceDatabase;
	_bool = ["write",["N_", _nunits]] call _stwPersistenceDatabase;
	_bool = ["write",["W_", worldSize]] call _stwPersistenceDatabase;	
	_bool = ["write",["POSITIONS", _unitPositions]] call _stwPersistenceDatabase;
	_bool = ["write",["SIDES", _unitSides]] call _stwPersistenceDatabase;	
	_bool = ["write",["PLAYER", _unitPlayers]] call _stwPersistenceDatabase;
	_bool = ["write",["BLOCKED", "FALSE"]] call _stwPersistenceDatabase;
	diag_log format ["///////RADAR INFO PERSISTED"];
};

[] spawn
{
  while {true} do
  {
	_units=[];
	waitUntil {(count ([] call BIS_fnc_listPlayers))>0};
	{
		_unit=_x;
		if (alive _unit) then
		{
			_units pushBack _unit;
		};
	} forEach allUnits;
	_units call stwf_persistUnitPosition;
	sleep 60; //STW_AWAC_RADAR_REFRESH_SECONDS;
  };
};