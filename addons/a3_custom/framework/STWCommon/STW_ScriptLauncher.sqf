/**
 Load a script, if STWG_NO_ADDON_MODE then it is loaded from the 
 root, else it is loaded from the a3_custom folder onwards.
**/
stwf_execVm=
{
 params ["_argumentsList","_scriptPath"];
 _prefix="";
 if (STWG_NO_ADDON_MODE) then
 {
	_prefix="@STWCustom\addons\";
 };
 _scriptPath=format ["%1%2",_prefix,_scriptPath];
 diag_log format ["launching %1 execvm %2",_argumentsList,_scriptPath];
 _script_handler =_argumentsList execvm _scriptPath;
 _script_handler;
};


/**
 Load a script synchronously, waiting until it finishes processing.
 if STWG_NO_ADDON_MODE then it is loaded from the 
 root, else it is loaded from the a3_custom folder onwards.
**/
stwf_execVmSynchronous=
{
 params ["_argumentsList","_scriptPath"];
 _prefix="";
 if (STWG_NO_ADDON_MODE) then
 {
	_prefix="@STWCustom\addons\";
 };
 _scriptPath=format ["%1%2",_prefix,_scriptPath];
 diag_log format ["launching %1 execvm %2",_argumentsList,_scriptPath];
 _script_handler =_argumentsList execvm _scriptPath;
 if (!isNil("_script_handler")) then
 {
	waitUntil { scriptDone _script_handler };
 };
 _script_handler
};