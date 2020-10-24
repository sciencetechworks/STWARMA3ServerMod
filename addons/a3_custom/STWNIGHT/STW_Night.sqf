if (!isServer) exitWith{};
waitUntil {(count ([] call BIS_fnc_listPlayers))>0};

diag_log "/////////////////////////////// STW NIGHT //////////////////////////////";


stwf_applyNightEquipmentToUnitsByGroups=
{
	//diag_log "stwf_applyNightEquipmentToUnitsByGroups";
 {
  _grp=_x;
  _mode= selectRandom [0,1,1,1,1,1,1,1,1,1,1,1,1,2,2];
  {
	_unit=_x;	
	_side= side _x;
	if ((!isplayer _unit)&&((_side==west)||(_side==east)))  then
	{
	 _hasNightEquipment=_unit getVariable "STW_NIGHT_EQUIPMENT_SET";
	 if (isNil "_hasNightEquipment") then
	 {
		if (_mode==0) then
		{
			diag_log "Night vision glasses given";
			_unit removePrimaryWeaponItem "acc_flashlight";    
			_unit addPrimaryWeaponItem "acc_pointer_IR";
			_unit additem "NVGoggles";
			_unit assignitem "NVGoggles";
			_unit action["NVGoggles", _unit];
		};
		if (_mode==1) then
		{
			diag_log "Flashlight given";
			if ("acc_pointer_IR" in primaryWeaponItems _unit) then {_unit removePrimaryWeaponItem "acc_pointer_IR"};
			//_unit removeWeapon (primaryWeapon _unit);
			//_unit addweapon 'rhs_weap_ak74m_camo';
			_unit addPrimaryWeaponItem 'rhs_acc_dtk3';
			_unit addPrimaryWeaponItem 'rhs_acc_2dpZenit'; //flashlight
			_unit addPrimaryWeaponItem 'rhs_acc_ekp1';
			/*_unit addItemToVest 'HandGrenade';
		    _unit addItemToVest 'HandGrenade';
			_unit addItemToVest '30Rnd_545x39_Mag_Tracer_Green_F';
			_unit addItemToVest '30Rnd_545x39_Mag_Tracer_Green_F';
			_unit addItemToVest '30Rnd_545x39_Mag_Tracer_Green_F';
			_unit addItemToBackpack '30Rnd_545x39_Mag_Tracer_Green_F';
			_unit addItemToBackpack '30Rnd_545x39_Mag_Tracer_Green_F';
			_unit addItemToBackpack '30Rnd_545x39_Mag_Tracer_Green_F';
			_unit addItemToBackpack '30Rnd_545x39_Mag_Tracer_Green_F';
			_unit addItemToBackpack 'medikit';
			_unit addItemToBackpack 'medikit';
			//"acc_flashlight";    // Add flashlight
			*/
			_nvgs = hmd _unit;
			_unit removeWeapon _nvgs;
			_unit unassignItem _nvgs;
			_unit removeItem _nvgs;
			//removeHeadGear _unit;
			_unit enablegunlights "forceOn";
		};
		//if mode is 2 no night equipment is given to the group
		_unit setVariable ["STW_NIGHT_EQUIPMENT_SET",true];
		diag_log format ["%1 night equipment set",_unit];
	 };
	};
  } forEach units _grp;
  if (_mode==1) then
  {
    _grp enableGunLights "forceon";
	//_grp setBehaviour "COMBAT";
  };
 } forEach AllGroups;
};

stwf_removeNightEquipmentToUnitsByGroups=
{
 {
  _grp=_x;
  _mode= selectRandom [0,0,1,1,2];
  {
	_unit=_x;
	if (!isplayer _unit) then
	{
		_unit removePrimaryWeaponItem "acc_flashlight";	
		_unit removePrimaryWeaponItem "acc_pointer_IR";
		_nvgs = hmd _unit;
		_unit removeWeapon _nvgs;
		_unit unassignItem _nvgs;
		_unit removeItem _nvgs;
		//removeHeadGear _unit;
	};
  } forEach units _grp;
 } forEach AllGroups;
};

stwf_manageNightEquipment=
{
 [] spawn
 {
	diag_log "/////////////////STW NIGHT SPAWNED";
	//_hour = floor daytime;
	//_minute = floor ((daytime - _hour) * 60);
	//_second = floor (((((daytime) - (_hour))*60) - _minute)*60);
	//_time24 = text format ["%1:%2:%3",_hour,_minute,_second];
	
	while {true} do
	{
		[] call stwf_applyNightEquipmentToUnitsByGroups;
		sleep 300;
	};
 };
};

[] call stwf_manageNightEquipment;