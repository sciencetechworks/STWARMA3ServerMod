"STW_PS_LOADOUT" addPublicVariableEventHandler {
	diag_log format ["STW_PS_LOADOUT %1",_this];
    _broadcastVarName = _this select 0;
    _broadcastVarValue = _this select 1;
	
    //do whatever you want with the data here...
	_values=_broadcastVarValue select 0;
	_unitName=_values select 0;
	_loadout=_values select 1;
	diag_log format ["%1 LOADOUT FOLLOWS: %2",_unitName,_loadout];
	[_loadout] call stwf_showCodeInLog;
	//diag_log format ["%1 LOADOUT: %2",_unitName,_loadout];
};

diag_log "server listening to STW_PS_LOADOUT public variable"; 