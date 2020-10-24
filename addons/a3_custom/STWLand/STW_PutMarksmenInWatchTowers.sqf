// Obtain the name of the building you are looking at
// execute in the debug console:
// hint str(typeOf cursortarget); copyToClipboard str(typeOf cursortarget);
// OK, the building we are looking for is: "Land_Posed" (A watching tower)

//Select all watching towers in the map:
// put a marksman 

mkrcount=0;

putMarksmenInWatchTowers = {
	_centerWorld =  getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition");
	_blds=nearestobjects [_centerWorld,["Land_Posed","Land_Vez","Land_Misc_deerstand"], 25000];
	_grp=createGroup EAST;
	{
		_building=_x;
		_buildingPosition = getPos _x;
		_unit = _grp createUnit ["rhs_msv_emr_marksman", _buildingPosition, [], 0, "NONE"] ;
		_unit forceSpeed 0;
		_unit enableDynamicSimulation true;
		[_unit] join _grp ;
	
		[_unit,_building] spawn 
			{
				_unit=_this select 0;
				_building=_this select 1;
				while {alive _unit} do
				{
					removeAllActions _unit;
					_unit setunitpos "up";
					_unit setPosATL (_building buildingPos 1);
					_unit setVehicleAmmo 1;
					sleep 10;
				};
			};
			
		/*if ([25] call stwf_probabilityCheck) then 
		{ 
			_squadGrp=[EAST,_buildingPosition] call stwf_generateSquad;
		};
		
		if ([25] call stwf_probabilityCheck) then 
		{ 
			_mkrName=format ["mkr_guardtower_%1",mkrcount];
			_mkr = createmarker [_mkrName, _buildingPosition];
			_mkr setMarkerShape "Icon";
			_mkr setMarkerType "hd_warning";
			_mkr setMarkerColor "ColorOpfor";
			mkrcount=mkrcount+1;
		}*/
	} forEach _blds;
};

[] call putMarksmenInWatchTowers;