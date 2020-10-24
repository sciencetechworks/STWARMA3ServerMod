////////////////////////////////////////
////////  [TOG] GARRISON SCRIP  ////////
////////         ver:1.0        ////////
////////   created by: Sushi    ////////
////////    www.armatog.com     ////////
////////////////////////////////////////
////////////////////////////////////////
// USAGE - BASIC:
// nul = [this] execVM "tog_garrison_script.sqf";
//
// USAGE - ADVANCED
// nul = [unit,radius,max units to garrison, max units per patrol,info] execVM "tog_garrison_script.sqf";
// EXAMPLE:
// nul = [Officer_1,100,5,4,true] execVM "tog_garrison_script.sqf";
///////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////

if (!isServer) exitWith {};
waituntil{time > 0.3};

//declarations
_ref = _this select 0;
_radius = 100;
_maxGarrisonNum = count units group _ref;
_maxPatrol = 3;
_info = true;

hint format["%1",count (_this)];
if(count (_this) == 0) exitWith { hint "[TOG] GARRISON SCRIPT ERROR: \nFIRST ARGUMENT NOT PROVIDED!"; };
if(count (_this) > 1) then {_radius = _this select 1; };
if(count (_this) > 2) then { _maxGarrisonNum = _this select 2; } ;
if(count (_this) > 3) then { _maxPatrol = _this select 3; };
if(count (_this) > 4) then { _info = _this select 4; };


_refGrp = group _ref;
_debug = false;


////INFO////
if (_info) then {
	_text1 = "<t color='#c48214' size='1.0' shadow='1' shadowColor='#333333' align='left'>[TOG] GARRISON SCRIPT</t><br/>";
	_text2 = "<t color='#ffffff' size='0.9' shadow='1' shadowColor='#666666' align='left'> is working ...</t><br/><br/>";
	_text3 = "<t color='#ffffff' size='0.9' shadow='1' shadowColor='#666666' align='left'> ver: 1.0 </t><br/>";
	_text4 = "<t color='#ffffff' size='0.9' shadow='1' shadowColor='#666666' align='left'> Created by: </t>";
	_text5 = "<t color='#c48214' size='1.0' shadow='1' shadowColor='#333333' align='left'>Sushi</t><br/><br/>";
	_text6 = "<t color='#c48214' size='1.0' shadow='1' shadowColor='#333333' align='left'>www.armatog.com</t>";
	_TOG_gsInitText = _text1 + _text2 + _text3 + _text4 + _text5 + _text6;
	hintSilent parseText _TOG_gsInitText;
};


//get all buildings
_blds = nearestObjects [_ref,["house"],_radius];

//get all positions of all buildings
_bldsPosArr = [];

{
	_building = _x;
	_posArr = [];
	_tempArr = [];

	//get this building positions
	_i = 0;
	while { format ["%1", _building buildingPos _i] != "[0,0,0]" } do {
		_posArr = _posArr + [_i];
		_i = _i + 1;
	};
	//if building have positions add to array
	if (_i > 0) then {
		// fix for last position;
		_i = count _posArr;
		_i = _i -1;
		_posArr =_posArr - [_i];

		//merge arrays
		_tempArr = _tempArr + [_building, _posArr];
		_bldsPosArr = _bldsPosArr + [_tempArr];
	};

	sleep 0.2;
} foreach _blds;

//Count buildings
_bldNum = count _bldsPosArr;

////DEBUG////
if (_debug) then {
	hint format ["BUILDINGS ARRAY: %1",_bldsPosArr];
};
_garrisonNum = 0;
//Start garrisoning
{
	//check for buildings in arra
	if (count _bldsPosArr < 1 || _garrisonNum > _maxGarrisonNum) exitWith{};

	//get random building and position
	_bldArr = _bldsPosArr call BIS_fnc_selectRandom;
	_bld = _bldArr select 0;
	_bldPosArr = _bldArr select 1;
	_pos = _bldPosArr call BIS_fnc_selectRandom;

	//remove position from array
	_bldPosArr = _bldPosArr - [_pos];
	_bldsPosArr = _bldsPosArr - [_bldArr];
	if (count _bldPosArr > 0) then {
		_bldArr = [_bld, _bldPosArr];
		_bldsPosArr = _bldsPosArr + [_bldArr];
	};

	//set unit in position
	[_x] joinSilent grpNull;
	_x setDir (random 360);
	_x setPosATL (_bld buildingPos _pos);
	_x setUnitPos "UP";
	

	_garrisonNum = _garrisonNum +1;
	sleep 0.2;
} foreach units _refGrp;

////DEBUG////
if (_debug) then {
	hint format ["UNITS LEFT: %1",count units _refGrp];
};

//Create patrol for others
_unitsLeftNum = count units _refGrp;
_unitsLeftArr = [];
_inPatrol = _maxPatrol;
_groupNum = 0;

if (_unitsLeftNum > 1) then {

	//create array of other units
	{
		[_x] joinSilent grpNull;
		_unitsLeftArr = _unitsLeftArr + [_x];
	} foreach units _refGrp;

	_unitsLeft = count _unitsLeftArr;
	while {_unitsLeft > 0} do {


		//If it less then maxPatrol
		if (_unitsLeft < _maxPatrol) then {
			_inPatrol = _unitsLeft;
		};

		//create group and add units
		_grp = createGroup (side _ref);
		_tempArr = [];
		_i = 0;
		while {_i < _inPatrol} do {
			_unit = _unitsLeftArr select 0;
			[_unit] joinSilent _grp;
			_unitsLeftArr = _unitsLeftArr - [_unit];
			_i = _i + 1;
		};
		[_grp, getPos _ref, _radius + (random 50)] call bis_fnc_taskPatrol;

		_unitsLeft = count _unitsLeftArr;
		_groupNum = _groupNum +1;
		sleep 0.2;
	};
};

////INFO////
if (_info) then {

	_text1 = "<t color='#c48214' size='1.0' shadow='1' shadowColor='#333333' align='left'>[TOG] GARRISON SCRIPT</t><br/>";
	_text2 = "<t color='#ffffff' size='0.9' shadow='1' shadowColor='#666666' align='left'>is done</t><br/><br/>";
	_text3 = format ["<t size='1.0' shadow='1' shadowColor='#333333' align='left'>BUILDINGS FOUND:</t> <t size='1.0'  color='#c48214' align='right'>%1</t><br/>", _bldNum];
	_text4 = format ["<t size='1.0' shadow='1' shadowColor='#333333' align='left'>GARRISONED UNITS:</t> <t size='1.0'  color='#c48214' align='right'>%1</t><br/>",_garrisonNum];
	_text5 = format ["<t size='1.0' shadow='1' shadowColor='#333333' align='left'>NOT GARRISONED UNITS:</t> <t size='1.0'  color='#c48214' align='right'>%1</t><br/>",_unitsLeftNum];
	_text6 = format ["<t size='1.0' shadow='1' shadowColor='#333333' align='left'>PATROL GROUPS:</t> <t size='1.0'  color='#c48214' align='right'>%1</t><br/><br/>",_groupNum];
	_text7 = "<t color='#c48214' size='1.0' shadow='1' shadowColor='#333333' align='left'>www.armatog.com</t>";
	
	_TOG_gsEndText = _text1 + _text2 + _text3 + _text4 + _text5 + _text6 + _text7;
	hintSilent parseText _TOG_gsEndText;
};






