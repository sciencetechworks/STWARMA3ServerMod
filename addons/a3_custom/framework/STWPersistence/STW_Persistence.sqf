#ifndef  STW_Persistence_Module_Loaded
#define STW_Persistence_Module_Loaded true
diag_log "STW_Persistence_Module Loaded";
//call compilefinal preprocessFileLineNumbers "a3_custom\framework\STWPersistence\oo_pdw.sqf";
[[],"a3_custom\framework\STWPersistence\oo_pdw.sqf"] call stwf_execVmSynchronous;


"STWPERSISTSTATUSSAVE" addPublicVariableEventHandler 
{
	diag_log format ["PERSISTENCE SAVE REQUEST %1",_this];
	_requester=(_this select 1) select 0;
	diag_log format ["PLAYER NAME %1",_requester];
	_requestedUnit=[_requester] call stwf_PlayerUnitByName;
	diag_log format ["PLAYER UNIT %1",_requestedUnit];
	_isFlying=[_requestedUnit] call stwf_isFlying;
	diag_log format ["Is flying %1 %2",_requestedUnit,_isFlying];
	if (_isFlying) exitWith{ diag_log "Is flying, persistence denied"; false;};
	_isOnWater=[_requestedUnit] call stwf_isOnWater;
	diag_log format ["Is on water %1 %2",_requestedUnit,_isOnWater];
	if (_isOnWater) exitWith{diag_log "Is on water, persistence denied"; false;};
	
	_stwPersistenceDatabase = ["new", "inidbi"] call OO_PDW;
	_dbName=format ["%1_%2","STWPERSISTENCE",_requester];
	["setDbName", _dbName] call _stwPersistenceDatabase;
	{
		if ((name _x) isEqualTo _requester) then
		{
			_bool = ["savePlayer", _x] call _stwPersistenceDatabase;
			diag_log format ["Player %1, status persisted on server.",_x];
		};
	} foreach allplayers;	
};

diag_log "Listening to STWPERSISTSTATUSSAVE variable on server";
	
"STWPERSISTSTATUSLOAD" addPublicVariableEventHandler {
	diag_log format ["PERSISTENCE LOAD REQUEST %1",_this];
	_requester=(_this select 1) select 0;
	
	_stwPersistenceDatabase = ["new", "inidbi"] call OO_PDW;
	_dbName=format ["%1_%2","STWPERSISTENCE",_requester];
	["setDbName", _dbName] call _stwPersistenceDatabase;
					
	{
		if ((name _x) isEqualTo _requester) then
		{
			_bool = ["loadPlayer", _x] call _stwPersistenceDatabase;
			diag_log format ["Player %1, status restored from server.",_x];
		};
	} foreach allPlayers;	
};
diag_log "Listening to STWPERSISTSTATUSLOAD variable on server";

//INVENTORY PERSISTENCE IS HANDLED BY CLIENT SIDE DB
//"STWPERSIST_INVENTORY_LOAD_REQUEST" addPublicVariableEventHandler {
//	diag_log format ["PERSISTENCE REQUEST %1",_this];
//	_requester=(_this select 1) select 0;
//	_stwPersistenceDatabase = ["new", "inidbi"] call OO_PDW;
//	_dbName=format ["%1_%2","STWPERSISTENCE",_requester];
//	["setDbName", _dbName] call _stwPersistenceDatabase;
//			
//	{
//		_playerName= name _x;
//		if (_playerName isEqualTo _requester) then
//		{
//			_label="pdw_inventory_"+_playerName;
//			_array = ["read", _label] call _stwPersistenceDatabase;
//			STWPERSIST_INVENTORY_LOAD_RESPONSE=[_playerName,_array];
//			diag_log format ["Server responding with %1 inventory %2",_playerName,STWPERSIST_INVENTORY_LOAD_RESPONSE];
//			publicVariable "STWPERSIST_INVENTORY_LOAD_RESPONSE";
//		};
//	} foreach allPlayers;	
//};
//
//"STWPERSIST_INVENTORY_STORE_REQUEST" addPublicVariableEventHandler {
//	diag_log format ["PERSISTENCE REQUEST %1",_this];
//	_broadcastVarName = _this select 0;
//	_broadcastVarValue = _this select 1;
//	_requester=_broadcastVarValue select 0;
//	_inventory=_broadcastVarValue select 1;
//	_stwPersistenceDatabase = ["new", "inidbi"] call OO_PDW;
//	_dbName=format ["%1_%2","STWPERSISTENCE",_requester];
//	["setDbName", _dbName] call _stwPersistenceDatabase;
//			
//	{
//		_playerName= name _x;
//		if (_playerName isEqualTo _requester) then
//		{
//			_label="pdw_inventory_"+_playerName;
//			_save = [_label, _inventory];
//			_bool = ["write", _save] call _stwPersistenceDatabase;		
//			diag_log format ["Server STORED %1 inventory %2",_playerName,_inventory];
//		};
//	} foreach allPlayers;	
//};

#endif