_grp=(_this select 0);
_skillArray=(_this select 1);					
					
					_skillset = server getvariable _skillArray;
		{
			_unit = _x;
			{
				_skillvalue = (_skillset select _forEachIndex) + (random 0.2) - (random 0.2);
				_unit setSkill [_x,_skillvalue];
			} forEach ['aimingAccuracy','aimingShake','aimingSpeed','spotDistance','spotTime','courage','reloadSpeed','commanding','general'];
				
			if (EOS_DAMAGE_MULTIPLIER != 1) then {_unit removeAllEventHandlers "HandleDamage";_unit addEventHandler ["HandleDamage",{_damage = (_this select 2)*EOS_DAMAGE_MULTIPLIER;_damage}];};
			if (EOS_KILLCOUNTER) then {_unit addEventHandler ["killed", "null=[] execVM ""a3_custom\STWEOS\functions\EOS_KillCounter.sqf"""]};
			// ADD CUSTOM SCRIPTS TO UNIT HERE
			_unit addMPEventHandler ["MPKilled", {if (!isServer) exitWith {}; null=_this execVM "a3_custom\STWEvents\STW_OnMPKillHandler.sqf";}];
			_unit setVariable ["STWMPKilledEventHandler", 1, true ];
			diag_log format ["EOS %1 receives a mpkilled handler",name _unit];
		} forEach (units _grp); 