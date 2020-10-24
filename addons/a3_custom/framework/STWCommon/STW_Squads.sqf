#ifndef  STW_Squads_Module_Loaded
#define STW_Squads_Module_Loaded true
diag_log "STW_Squads Module Loaded";
/**
Generates a random squad class type
Receives the [SIDE]
Returns [squad type,desired_probability]
**/
stwf_getRandomSquadClassName=
{
	params ["_side"];
	_selectedClass=nil;
	
	if (_side==WEST) then
	{
		_selectedClass=selectRandom STWG_PossibleWESTGroups;
	} else
	{
		_selectedClass=selectRandom STWG_PossibleEASTGroups;
	};
	_selectedClass
};

/**
 Creates a random squad type on the given position.
 Receives the [SIDE,POSITION] of the squad
 It does have in mind the probability of appearance
 Returns the generated group.
**/
stwf_generateSquad=
{
 params ["_side","_position"];
 //check if probability is valid, if not, create new squad type
 _generate_again=true;
 _className=nil;
 while {_generate_again} do 
 {  
	_selected=[_side] call stwf_getRandomSquadClassName;
	_className=_selected select 0;
	_probability=_selected select 1;
	//Generate again if probability is out of range.
	_generate_again=!([_probability] call stwf_probabilityCheck);
 };
 //diag_log format ["STW_PatrolSquads spawning: %1",_className];
 //_position=_position findEmptyPosition [0,200];
 _radius = 100; 
 _options = "-trees -forest +5*meadow+10*houses"; 
 _result = selectBestPlaces [_position, _radius, _options, 50, 10]; 
 _position = _result select 0 select 0;  
 
 _grp = [_position, _side,_className] call BIS_fnc_spawnGroup;
  
 /** Replace vest of all units (To lower the defense values of RHS vests */
 diag_log format ["Substituting squad vest to %1","V_TacVest_camo"];
 {
  [_x,"V_TacVest_camo"] call stwf_substituteVest;
 } forEach (units _grp);

_grp 
};

/*
//Creates a random squad on the given position.
//Receives the [SIDE,POSITION] of the squad
stwf_generateSquad=
{
 _side=_this select 0;
 _position = _this select 1;
 //check if probability is valid, if not, create new squad type
 _luck=100;
 _probability=0;
 _className=nil;
 while {_luck>_probability} do 
 {  
	_luck=random 100;
	_selected=[_side] call stwf_getRandomSquadClassName;
	_className=_selected select 0;
	_probability=_selected select 1;
	sleep 1;
 };
 _grp = [_position, _side,_className] call BIS_fnc_spawnGroup;
 _grp
};
*/

#endif