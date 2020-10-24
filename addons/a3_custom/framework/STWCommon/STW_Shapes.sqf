#ifndef  STW_Shapes_Module_Loaded
#define STW_Shapes_Module_Loaded true
diag_log "STW_Shapes_Module Loaded";


/**
Get the n positions surrounding the position it receives in the given radius
Receives  [position,radius,nangularsteps];
Returns 2D Positions
**/
stwf_getCircularPositions2DAround= 
{
 params ["_position","_radius","_nangularsteps"];
 _results=[];
 _angleIncrement=360/_nangularsteps;
 _angle=0; 
 for [{_i=0}, {_i<_nangularsteps}, {_i=_i+1}] do
 {
	_x= (_position select 0)+ (_radius*sin _angle);
	_y= (_position select 1)+ (_radius*cos _angle);
	_results pushBack [_x,_y];
	_angle=_angle+_angleIncrement;
 };

 _results;
};

/**
 Obtains the circular path at ground level
 Receives  [position,radius,nangularsteps];
**/
stwf_getCircularGroundPath=
{
 params ["_position","_radius","_nangularsteps"];
 _shape=[_position,_radius,_nangularsteps] call stwf_getCircularPositions2DAround;
 _shape=_shape call stwf_getGroundLevelPositions;
 _shape;
};



/**************
RECTANGLES
***************/

/**
 Get center of rectangle area
**/
stwf_getCenterOfRectangle2D=
{
 params ["_zone"];
 _minCoords=_zone select 0;
 _maxCoords=_zone select 1;
 _topx=_minCoords select 0;
 _topy=_minCoords select 1;
 _w=(_maxCoords select 0)-_topx;
 _h=(_maxCoords select 1)-_topy;
 _x= _topx+_w/2;
 _y= _topy+_h/2;
 _result = [_x,_y];
 //diag_log format ["Rectangle %1, center=[%2,%3]",_zone,_x,_y];
 _result
};

/**
 Rectangle Width 
 **/
stw_getRectangleWidth=
{
 params ["_rectangle"];
  _w= abs (((_rectangle select 1) select 0)-((_rectangle select 0) select 0));
  _w
};

/**
 Rectangle Height 
 **/
stw_getRectangleHeight=
{
 params ["_rectangle"];
  _h= abs (((_rectangle select 1) select 1)-((_rectangle select 0) select 1));
  _h
};

/**
 Rectangle Area
**/
stw_getRectangleArea=
{
  params ["_rectangle"];
  _w=[_rectangle] call stw_getRectangleWidth;
  _h=[_rectangle] call stw_getRectangleHeight;
  _area=_w*_h;
  _area
};

/**
 Check if both rectangles are the same
 **/
 stwf_areSameRectangle=
 {
  params ["_rectangleA","_rectangleB"];
  _result=(_rectangleA isEqualTo _rectangleB);
  _result
 };
 
 
 /**
 Convert from rectangle in
 two-corners format [_ax,_ay][_bx,_by]
 to [minx,miny,maxx,maxy] format
**/
stwf_TwoPointsRectangleToMinMaxFormat=
{
 params ["_rectangle"];
 _A=_rectangle select 0;
 _B=_rectangle select 1;
 _ax=_A select 0;
 _ay=_A select 1;
 _bx=_B select 0;
 _by=_B select 1;
 _txs=[_ax,_bx];
 _minX=selectMin _txs;
 _maxX=selectMax _txs;
 _ys=[_ay,_by];
 _minY=selectMin _ys;
 _maxY=selectMax _ys;
 _result=[_minX,_minY,_maxX,_maxY];
  //diag_log format ["Minmax:%1",_result];
 _result
};
 
 /**
 Convert from [mincoor,maxcoord]
 to the four corner vertices of
 the rectangle
*/
stwf_getRectangleCorners=
{
 params ["_rectangle"];
 _rectangleAB=[_rectangle] call stwf_TwoPointsRectangleToMinMaxFormat;
 _rectangleMinX=(_rectangle select 0) select 0;
 _rectangleMinY=(_rectangle select 0) select 1;
 _rectangleMaxX=(_rectangle select 1) select 0;
 _rectangleMaxY=(_rectangle select 1) select 1;
 // Clockwise
 _vA=[_rectangleMinX,_rectangleMinY];
 _vB=[_rectangleMaxX,_rectangleMinY];
 _vC=[_rectangleMaxX,_rectangleMaxY];
 _vD=[_rectangleMinX,_rectangleMaxY];
 _result=[_vA,_vB,_vC,_vD];
 _result
};

/**
 Get the four sides of the rectangle
 as ranges [pointA,pointB]
**/
stwf_getRectangleSides=
{
 params ["_rectangle"];
 _vertices=[_rectangle] call stwf_getRectangleCorners;
 _vA=_vertices select 0;
 _vB=_vertices select 1;
 _vC=_vertices select 2;
 _vD=_vertices select 3;
 //Sides:
 _top=  [_vA,_vB];
 _right=[_vB,_vC];
 _down= [_vD,_vC];
 _left= [_vA,_vD];
 _result=[_top,_right,_down,_left];
 _result;
};

/**
 Check if a value is in the given range,
 extremes are accepted as valid, 
 numbers do not have to be ordered,
 min and max is detected inside
 (5,[2,6]) will result in the same as
 (5,[6,2])
*/
stwf_isValueInBetween=
{
 params ["_value","_range"];
 _A=_range select 0;
 _B=_range select 1;
 if (_A>_B) then
 {
  _t=_A;
  _A=_B;
  _B=_t;
 };
 _min= _A;
 _max= _B;
 _result=false;
 if ((_value>=_min)&&(_value<=_max)) then
 { 
  _result=true;
 };
 //diag_log format ["%1 in Range [%2] is %3",_value,[_min,_max],_result];
 _result
};

stwf_distanceFromHorizontalSegment=
{
  params ["_point2D","_segment2D"];
  _x1=(_segment2D select 0) select 0;
  _x2=(_segment2D select 1) select 0;
  _rangeX=[_x1,_x2];
  _x=_point2D select 0;
  _inRange=[_x,_rangeX] call stwf_isValueInBetween;
  _result=600000;
  if (_inRange) then
  {
	  _yp=_point2D select 1;
	  _ys=(_segment2D select 0) select 1;
	  _result= abs (_yp-_ys);
  };
  _result
};

stwf_distanceFromVerticalSegment=
{
  params ["_point2D","_segment2D"];
  _y1=(_segment2D select 0) select 1;
  _y2=(_segment2D select 1) select 1;
  _rangeY=[_y1,_y2];
  _y=_point2D select 1;
  _inRange=[_y,_rangeY] call stwf_isValueInBetween;
  _result=600000;
  if (_inRange) then
  {
	  _xp=_point2D select 0;
	  _xs=(_segment2D select 0) select 0;
	  _result= abs (_xp-_xs);
  };
  _result
};

stwf_areRectanglesTouching=
{
 params ["_rectangleA","_rectangleB"];
 _delta=1;
// diag_log format ["Rectangle A %1",_rectangleA];
// diag_log format ["Rectangle B %1",_rectangleB];
 _cornersB=[_rectangleB] call stwf_getRectangleCorners;
 _sidesA=[_rectangleA] call stwf_getRectangleSides;

 _AA=_sidesA select 0;
 _AB=_sidesA select 1;
 _AC=_sidesA select 2;
 _AD=_sidesA select 3; 
  
 
 _touching=false;
 //Check if any corners of B touch any sides of A
 {
  _corner=_x;
  //sides A and C are Horizontal
  _dA=[_corner,_AA] call stwf_distanceFromHorizontalSegment;
  //diag_log format ["DA=%1",_dA];
  if (_da<_delta) exitWith {_touching=true; true};
  _dC=[_corner,_AC] call stwf_distanceFromHorizontalSegment;
  //diag_log format ["DC=%1",_dA];
  if (_dC<_delta) exitWith {_touching=true; true};
  //sides B and D are Vertical
  _dB=[_corner,_AB] call stwf_distanceFromVerticalSegment;
  //diag_log format ["DB=%1",_dB];
  if (_dB<_delta) exitWith {_touching=true; true};
  _dD=[_corner,_AD] call stwf_distanceFromVerticalSegment;
  //diag_log format ["DD=%1",_dD];
  if (_dD<_delta) exitWith {_touching=true; true};
 } forEach _cornersB;

 if (!_touching) then
 {
      diag_log "Check AB";
	 _cornersA=[_rectangleA] call stwf_getRectangleCorners;
	 _sidesB=[_rectangleB] call stwf_getRectangleSides;
	  
	 _BA=_sidesB select 0;
	 _BB=_sidesB select 1;
	 _BC=_sidesB select 2;
	 _BD=_sidesB select 3;
	 
	 //Check if any corners of A touch any sides of B
	 {
	  _corner=_x;
	  //sides A and C are Horizontal
	  _dA=[_corner,_BA] call stwf_distanceFromHorizontalSegment;
	  //diag_log format ["DA=%1",_dA];
	  if (_da<_delta) exitWith {_touching=true; true};
	  _dC=[_corner,_BC] call stwf_distanceFromHorizontalSegment;
	  //diag_log format ["DC=%1",_dA];
	  if (_dC<_delta) exitWith {_touching=true; true};
	  //sides B and D are Vertical
	  _dB=[_corner,_BB] call stwf_distanceFromVerticalSegment;
	  //diag_log format ["DB=%1",_dB];
	  if (_dB<_delta) exitWith {_touching=true; true};
	  _dD=[_corner,_BD] call stwf_distanceFromVerticalSegment;
	  //diag_log format ["DD=%1",_dD];
	  if (_dD<_delta) exitWith {_touching=true; true};
	 } forEach _cornersA;
  };
 
 _result= _touching;
 if (_result) then {
	diag_log "Rectangles are touching!";
	diag_log format ["%1 <-> %2",_rectangleA,_rectangleB];
	};
 _result;
};

stwf_areRectanglesTouchingCircleRangeMethod=
{
 params ["_rectangleA","_rectangleB"];
 _delta=1;
// diag_log format ["Rectangle A %1",_rectangleA];
// diag_log format ["Rectangle B %1",_rectangleB];
 _cornerA=(_rectangleA select 0);
 _centerA=[_rectangleA] call stwf_getCenterOfRectangle2D;
 //diag_log format ["before distance: cornerA %1 centerA %2",_cornerA,_centerA];
 _radiusA=[_cornerA,_centerA] call stwf_distance2D; 
 _cornersB=[_rectangleB] call stwf_getRectangleCorners;
 
 _touching=false;
 //Check if any corners of B  are inside reach of A
 {
  _cornerB=_x;
  diag_log format ["corner %1 center %2",_cornerB,_centerA];
  _d=[_cornerB,_centerA]  call stwf_distance2D; 
  if (_d<=_radiusA+5) exitWith {_touching=true; true};
 } forEach _cornersB;

 
 if (!_touching) then
 {
  diag_log("BA check");
  _cornerB=(_rectangleB select 0);
  _centerB=[_rectangleB] call stwf_getCenterOfRectangle2D;
  _radiusB=[_cornerB,_centerB] call stwf_distance2D; 
  _cornersA=[_rectangleA] call stwf_getRectangleCorners;
   //Check if any corners of A  are inside reach of B
	 {
	  _cornerA=_x;
	  _d=[_cornerA,_centerB]  call stwf_distance2D; 
	  if (_d<=_radiusB+5) exitWith {_touching=true; true};
	 } forEach _cornersA;
 };
 
 _result= _touching;
 if (_result) then {
	diag_log "Rectangles are touching!";
	diag_log format ["%1 <-> %2",_rectangleA,_rectangleB];
	} else
	{
	 diag_log format ["%1 <-//-> %2",_rectangleA,_rectangleB];
	};
 _result;
};

stwf_areRectanglesTouchingCircleRangeMethod2=
{
 params ["_rectangleA","_rectangleB"];
 _delta=1;
 _cornerA=(_rectangleA select 0);
 _centerA=[_rectangleA] call stwf_getCenterOfRectangle2D;
 _radiusA=[_cornerA,_centerA] call stwf_distance2D; 
 
 _cornerB=(_rectangleB select 0);
 _centerB=[_rectangleB] call stwf_getCenterOfRectangle2D;
 _radiusB=[_cornerB,_centerB] call stwf_distance2D; 
 _touching=false;
 
 //[_cornerA,_centerA,[1,0,0,1]] call stwf_drawLine;
 //[_cornerB,_centerB,[1,0,0,1]] call stwf_drawLine;
 _centerDistance=[_centerA,_centerB] call stwf_distance2D;
 _sumRadius=_radiusA+_radiusB;
 //diag_log format ["Distance inter centers:%1, Sum radius:%2",_centerDistance,_sumRadius];
 
 if (_centerDistance<=(_sumRadius)) then
 {
  _touching=true;
 };

 _result= _touching;
 /*if (_result) then {
	diag_log "Rectangles are touching!";
	diag_log format ["%1 <-> %2",_rectangleA,_rectangleB];
	};
 */
 _result;
};

/**
Check if a position2D  is into a rectangle in
[ltop,rbottom] coord format
*/
stwf_isPositionIntoRectangle=
{
 params ["_position2D","_rectangle"];
 _px=_position2D select 0;
 _py=_position2D select 1;
 _rT=_rectangle select 0;
 _rB= rectangle select 1;
 _mix=_rT select 0;
 _miny=_rT select 1;
 _maxX=_rb select 0;
 _maxY=_rb select 1;
 _result=false;
  if ( 
	((_px>=_minx)&&(_py>=_miny)) &&
	((_px<=_maxx)&&(_py<=_maxy)) 
	) then
	{
	  result=true;
	};
  _result;
};

/**
 Generate Strategical Point of Interest
**/
stwf_generateCircularStrategicalPointOfInterestForRectangularZone=
{
 params ["_type","_name","_rectangle"];
 _center=[_rectangle] call stwf_getCenterOfRectangle2D;
 _size=[[_rectangle] call stw_getRectangleWidth,[_rectangle] call stw_getRectangleHeight];
 _direction=[0,0];
 _result=[_type,_name,_center,_direction,_size,true];
 _result;
};
#endif