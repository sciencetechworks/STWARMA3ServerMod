//STW_DetectWaterAreasInit  BEFORE MAKING USE OF THIS FUNCTIONS
if (!isServer) exitWith{};

fstwCoordsContainedIntoBox=
{
	_coords=_this select 0;
	_x=_coords select 0;
	_y=_coords select 1;
	_box=_this select 1;
	_up2Dcoord=_box select 0;
	_down2Dcoord=_box select 1;
	_x0=_up2Dcoord select 0;
	_y0=_up2Dcoord select 1;
	_x1=_down2Dcoord select 0;
	_y1=_down2Dcoord select 1;
	_result=false;
	if (
		((_x>=_x0)&&(_x<=_x1))&&
		((_y>=_y0)&&(_y<=_y1))
		)then
		{
		 _result=true;
		};
	_result
};

fstwIsInWaterZone=
{
	_coords=_this select 0;
	_breakLoop=false;
	_result=false;
	for [ {private "_i"; _i=0;},
	{(_i<(count STWG_WATER_ZONES))&&(_breakLoop==false)},
	{_i=_i+1}] do
	{
	  _zone=STWG_WATER_ZONES select _i;
	  _result=[_coords,_zone] call _fstwCoordsContainedIntoBox;
	  if (_result) then
	  {
	   _breakLoop=true;
	  };
	};
	_result
};

fstwGetRandomWaterZone=
{
 _result= selectRandom STWG_WATER_ZONES;
 _result
};

fstwGetZoneCenter=
{
 _zone=_this;
 _x0=(_zone select 0) select 0;
 _y0=(_zone select 0) select 1;
 
 _x1=(_zone select 1) select 0;
 _y1=(_zone select 1) select 1;
 
 _x=_x0+((_x1-_x0)/2);
 _y=_y0+((_y1-_y0)/2);
 
 [_x,_y]
};
