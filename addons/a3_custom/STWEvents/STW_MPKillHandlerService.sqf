if (!isServer) exitWith{};
//waitUntil {(count ([] call BIS_fnc_listPlayers))>0};


stwf_onMpKilleventTagFunction=
{

};


stwf_addMPKillHandlerToAllUnits=
{
	{
	 _unit=_x;
	 _hasHandler=_unit getVariable["STWMPKilledEventHandler",0];
		if (!isNil("_hasHandler")) then
		{
			if (_hasHandler!=1) then
			{
				_unit addMPEventHandler ["MPKilled", {if (!isServer) exitWith {}; null=_this execVM "a3_custom\STWEvents\STW_OnMPKillHandler.sqf";}];
				_unit setVariable ["STWMPKilledEventHandler", 1, true ];
				diag_log format ["%1 receives a mpkilled handler",name _unit];
			};
		};
		//sleep 0.25;
	} forEach allUnits;
};

stwf_addMPKillHandlerService=
{
 [] spawn
 {	
	while {true} do
	{
		diag_log "Adding kill handlers";
		[] call stwf_addMPKillHandlerToAllUnits;
		sleep 60;
	};
 };
};

[] call stwf_addMPKillHandlerService;