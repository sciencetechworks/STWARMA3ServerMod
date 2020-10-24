#ifndef STW_HashMap_Module_Loaded
#define STW_HashMap_Module_Loaded true
diag_log "STW_HashMap_Module_Loaded";

stwf_charV=
{
	param ["_v"];
    if (_v == "q") then {_return = 1;}; 
    if (_v == "w") then {_return = 2;}; 
    if (_v == "e") then {_return = 3;}; 
    if (_v == "r") then {_return = 4;};
    if (_v == "t") then {_return = 5;};
    if (_v == "y") then {_return = 6;}; 
    if (_v == "u") then {_return = 7;}; 
    if (_v == "i") then {_return = 8;}; 
    if (_v == "o") then {_return = 9;}; 
    if (_v == "p") then {_return = 10;}; 
    if (_v == "a") then {_return = 11;}; 
    if (_v == "s") then {_return = 12;}; 
    if (_v == "d") then {_return = 13;};
    if (_v == "f") then {_return = 14;};
    if (_v == "g") then {_return = 15;};
    if (_v == "h") then {_return = 16;};
    if (_v == "j") then {_return = 17;};
    if (_v == "k") then {_return = 18;};
    if (_v == "l") then {_return = 19;};
    if (_v == "z") then {_return = 20;};
    if (_v == "x") then {_return = 21;};
    if (_v == "c") then {_return = 22;};
    if (_v == "v") then {_return = 23;};
    if (_v == "b") then {_return = 24;};
    if (_v == "n") then {_return = 25;};
    if (_v == "m") then {_return = 26;};
 _return
};

/*
    Author pAxton
 check out https://www.youtube.com/channel/UCwiq0V-6VG6SPsHnf0Ou4sw

    Hash.sqf
****this is for internal use****

    PARAMS: 
        0 String - Global name 
        1 String  - Key
       
    RETURN:
        hashed index
*/
stwf_hashFunction=
{
	params["_mp", "_key"];
    
    
	private _arrKey = _key splitString "";
    
	private _cnt = count _arrKey;
    
	private _hashStr = "";
	{
		_num = parseNumber _x;
		if(_num isEqualTo 0) then {
			_num = [_x] call stwf_hashFunction;
			_strNum = str _num;
			_hashStr = _hashStr + _strNum;
		} else {
			_hashStr = _hashStr +  _x;
		};
	}forEach _arrKey;
    
	if((count _hashStr) > 6) then {
		_hashStr = ToArray _hashStr;
	_newStr = (_hashStr select (count _hashStr) - 6);
	_newStr = _newStr + (_hashStr select (count _hashStr) - 5);
	_newStr = _newStr + (_hashStr select (count _hashStr) - 4);
	_newStr = _newStr + (_hashStr select (count _hashStr) - 3);
	_newStr = _newStr + (_hashStr select (count _hashStr) - 2);
	_newStr = _newStr + (_hashStr select (count _hashStr) - 1);
	_hashStr = str _newStr;
	};
    
	private _hash = parseNumber _hashStr;
	private _index = _hash mod (count _mp);
    
	_index
};

/*
    Author pAxton
 check out https://www.youtube.com/channel/UCwiq0V-6VG6SPsHnf0Ou4sw
    HashMap

    PARAMS: 
        0 String - Global name 
        1 Number - Size of array
    RETURN:
        true when done
*/

stwf_newHashMap=
{
	params["_MAP", "_size"];

	missionNamespace setVariable [_MAP, []];
	_temp = missionNamespace getVariable _MAP;

	for "_i" from 1 to _size do {
		_temp pushBack [];
	};

	missionNamespace setVariable [_MAP, _temp];

	true;
};

/*
    Author pAxton
 check out https://www.youtube.com/channel/UCwiq0V-6VG6SPsHnf0Ou4sw

    HashMap_get

    PARAMS: 
        0 String - Global name 
        1 String  - Key
    
    RETURN:
        value
*/

stwf_getFromHashMap=
{
	params["_MAP", "_key"];

	private _mp = missionNamespace getVariable [_MAP, []];

	private _index = [_mp, _key] call stwf_hashFunction;

	private _bucket = _mp select _index;

	private _return = "";
	if !(_bucket select 0 select 2) exitWith { (_bucket select 0 select 1) };

	{
		if ((_x select 0) isEqualTo _key) then { _return = _x select 1; };
	} forEach _bucket;

	_return
};

/*
    Author pAxton
 check out https://www.youtube.com/channel/UCwiq0V-6VG6SPsHnf0Ou4sw

    HashMap_put

    PARAMS: 
        0 String - Global name 
        1 String  - Key
        2 Anything  - value to store
    RETURN:
        true if successfull
*/

stwf_putIntoHashMap=
{
	params["_MAP", "_key", "_value"];


	if (isNil "_MAP") then {  false  };
	if !(typeName _MAP isEqualTo "STRING") exitWith {diag_log format ["Map function expected String for global name but received: %1", (typeName _MAP)]; false};

	private _mp = missionNamespace getVariable _MAP;
	private _dup = false;
	private _index = [_mp, _key] call stwf_hashFunction;
	private _bucket = _mp select _index;
	private _curKey = _bucket select 0 select 0;
	if (isNil "_curKey") then {
		private _nbucket = [_key, _value, false];
		_mp set [_index, [_nbucket]];
	} else {
		{
			 if ((_x select 0) isEqualTo _key) exitWith {
				 _x set [1, _value];  
				 _dup = true;      
			 };
		}forEach _bucket;
	  
	  if !(_dup) then {
		  _bucket pushBack [_key, _value, false];
		 {
			if (_forEachIndex < ((count _bucket) - 1)) then {
				_x set [2, true];
			};
		 }forEach _bucket;
		  
	  };
	};

	missionNamespace setVariable [_MAP, _mp];
	true
};

//["STW_TEST_HASHMAP",10] call stwf_newHashMap;
//["STW_TEST_HASHMAP","AAA","HELLO"] call stwf_putIntoHashMap;
//["STW_TEST_HASHMAP","BBB","HELLO2"] call stwf_putIntoHashMap;
//["STW_TEST_HASHMAP","XY2Z","HELLO SILVER"] call stwf_putIntoHashMap;
//
//_value=["STW_TEST_HASHMAP","XY2Z"] call stwf_getFromHashMap;
//diag_log _value;
//
//diag_log STW_TEST_HASHMAP;
#endif