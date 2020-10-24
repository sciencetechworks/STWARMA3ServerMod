  params ["_killed","_killer","_instigator","_useEffects"];
  //diag_log format ["MPKILL INFO %1 by %2",_killed,_killer];
 
  _suicide=false;
  if ( _killed isEqualTo _killer) then 
  {
   _suicide=true;
  };
  
  if ((!_suicide)&&(isPlayer _killer)) then
  {
	  _requester=_killer;
	  _stwPersistenceDatabase = ["new", "inidbi"] call OO_PDW;
	  _dbName=format ["%1_%2","STWPERSISTENCE","KILLCOUNTER"];
	  ["setDbName", _dbName] call _stwPersistenceDatabase;
	  _label=format["%1",name _killer];
	  
	  _killcount = ["read", [_label,0]] call _stwPersistenceDatabase;
	  diag_log format ["DATABASE READ KILLCOUNT %1",_killcount];
	  _killcount=_killcount+1;
	  _save = [_label, _killcount];
	  _bool = ["write", _save] call _stwPersistenceDatabase;
	  //diag_log (format ["%1 all time kills: %2",_killer,_killcount]);
	  (format ["%1 all time kills: %2",name _killer,_killcount]) remoteExec ["hint", -2]; 
	  diag_log format ["<STW_KILL><KILLER>%1</KILLER><KILL_COUNT>%2</KILL_COUNT></STW_KILL>",name _killer,_killcount];  
  };

