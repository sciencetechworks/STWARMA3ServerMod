if (!isServer) exitWith {};


_STWFRandomNum = {
						_min=_this select 0;
						_max=_this select 1;
						_rnd= random (_max-_min);
						_rnd= _rnd+_min; 
	  
						floor _rnd
					};
_istwMinDist=500;  
_pos=[];
_dir = getDir player; 


_nearestDist=-1;

while {(count allPlayers) ==0} do {sleep 10;};

_grp=group (_this select 0);
_grpLeader=((units _grp) select 0);
_nearestPlayer=selectRandom allPlayers;

{
	_dist=_grpLeader distance2D _x;
	if ((_nearestDist==-1)||(_dist<_nearestDist)) then
	{
	 _nearestPlayer=_x;
	 _nearestDist=_dist;
	};
	
} foreach allPlayers;

_onLand=false;
_onWater=false;

_typeOfAnimal=_this select 1;
//diag_log format ["Animal type %1", _typeOfAnimal];

if (_typeOfAnimal=="Terrestrial") then 
{
 _retries=0;
 while {(!_onLand)&&(_retries<10)} do
 {
	_pos=getPos _nearestPlayer;
	_rndAngle=[0,360] call _STWFRandomNum; 
	_x= (_pos select 0)+ (_istwMinDist*sin _rndAngle); 
	_y= (_pos select 1)+ (_istwMinDist*cos _rndAngle);
	
	if (!surfaceIsWater [_x,_y]) then
	{
		_onLand=true;
	};
	_retries=_retries+1;
 };
} else
{
  _retries=0;
 while {(!_onWater)&&(_retries<10)} do
 {
	_pos=getPos _nearestPlayer;
	_rndAngle=[0,360] call _STWFRandomNum; 
	_x= (_pos select 0)+ (_istwMinDist*sin _rndAngle); 
	_y= (_pos select 1)+ (_istwMinDist*cos _rndAngle);
	
	if (surfaceIsWater [_x,_y]) then
	{
		_onWater=true;
	};
	_retries=_retries+1;
 };

};

	_pos=getPos _nearestPlayer;
	_rndAngle=[0,360] call _STWFRandomNum; 
	_x= (_pos select 0)+ (_istwMinDist*sin _rndAngle); 
	_y= (_pos select 1)+ (_istwMinDist*cos _rndAngle);
	
	if (_onLand) then
	{
		_grp = group (_this select 0);
		_wpoint=_grp addWaypoint [[_x,_y], 0];
		[_grp,1] setWaypointStatements ["true", "if (!isServer) exitWith{}; nul =[this,'Terrestrial'] execVm 'a3_custom\STWAnimals\STWAnimalReachedWayPoint.sqf'"];
		_onLand=true;
	} else {
		_grp = group (_this select 0);
		_wpoint=_grp addWaypoint [[_x,_y], 0];
		[_grp,1] setWaypointStatements ["true", "if (!isServer) exitWith{}; nul =[this,'Aquatic'] execVm 'a3_custom\STWAnimals\STWAnimalReachedWayPoint.sqf'"];
		_onLand=true;
	};
