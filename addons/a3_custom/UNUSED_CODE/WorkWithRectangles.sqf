
/**
 Convert from rectangle in
 two-corners format [_ax,_ay][_bx,_by]
 to [minx,miny,maxx,maxy] format
**/
stwf_TwoPointsRectangleToMinMaxFormat=
{
 params ["_rectangleAB"];
 _A=_rectangleAB select 0;
 _B=_rectangleAB select 1;
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
  diag_log format ["Minmax:%1",_result];
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
 if ((_value>=_min-5)&&(_value<=_max+5)) then
 { 
  _result=true;
 };
 _result
};

/**
 Check if point lies in whichever side of
 the rectangle.
*/
stwf_isPointPartOfAnyRectangleSides=
{
 params ["_point","_rectangle"];
 //diag_log format ["-->Rectangle: %1",_rectangle];
 _sides=[_rectangle] call stwf_getRectangleSides;
  //diag_log format ["-->Rectangle sides: %1",_sides];
 _result = false;
 _A=_sides select 0;
 _B=_sides select 1;
 _C=_sides select 2;
 _D=_sides select 3;

 _pointX=_point select 0;
 _pointY=_point select 1;
 
  //Check if point has top side equal Y
  _topX=(_A select 0) select 0;
  _topY=(_A select 0) select 1;
  
  _rightX=(_B select 0) select 0;
  _rightY=(_B select 0) select 1;
  
  _bottomX=(_C select 0) select 0;
  _bottomY=(_C select 0) select 1;
  
  _leftX=(_D select 0) select 0;
  _leftY=(_D select 0) select 1;

  _isPartOf=false;
  if ((_pointY==_topY)||(_pointY==_bottomY)) then
  {
    _range=[_leftX,_rightX];
    _isPartOf=[_pointX,_range] call stwf_isValueInBetween;
  };
  
  if (!_isPartOf) then
  {
	  if ((_pointX==_leftX)||(_pointX==_rightX)) then
	  {
		_range=[_topY,_bottomY];
		_isPartOf=[_pointY,_range] call stwf_isValueInBetween;
	  };
  };
  
  _result=_isPartOf;
 _result
};

/** 
 Check if rectangles are touching
**/
stwf_areRectanglesTouching=
{
 params ["_rectangleA","_rectangleB"];
// Two rectangles are touching if whatever vertex o
// both rectangles is in whatever side of the other
// rectangle.
  _rectangleACorners=[_rectangleA] call stwf_getRectangleCorners;
  _touching=false;
  {
    _point=_x;
	_partOfAnySide=[_point,_rectangleB] call stwf_isPointPartOfAnyRectangleSides;
	if (_partOfAnySide) exitWith {_touching=true; true};
  } forEach _rectangleACorners;
  
  if (!_touching) then
  {
    _rectangleBCorners=[_rectangleB] call stwf_getRectangleCorners;
	{
		_point=_x;
		_partOfAnySide=[_point,_rectangleA] call stwf_isPointPartOfAnyRectangleSides;
		if (_partOfAnySide) exitWith {_touching=true; true};
	} forEach _rectangleBCorners;
  };  
  _result=_touching;
  
  _result
};
