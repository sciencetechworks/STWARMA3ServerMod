#ifndef  STW_Geometry_Module_Loaded
#define STW_Geometry_Module_Loaded true
diag_log "STW_Geometry_Module Loaded";
/**
Slope of a line:
m = (y2-y1)/(x2-x1)
**/
stwf_line2DSlope=
{
 params ["_point2DA","_point2DB"];
 _x1=_point2DA select 0;
 _y1=_point2DA select 1;
 _x2=_point2DB select 0;
 _y2=_point2DB select 1;
 _m = (_y2-_y1)/(_x2-_x1);
 _m
};

/**
 Returns the hypotenuse.
**/
stwf_hypot2D=
{
 params ["_v2D"];
 _v1 = _v2D select 0;
 _v2 = _v2D select 1;
 _sqsum= _v1*_v1 + _v2*_v2;
 _sqr = sqrt _sqsum;
 _sqr
};

/**
Segments intersect
**/
stwf_segmentsIntersect2D=
{
 params ["_segmentA","_segmentB"];
 _x11=(_segmentA select 0) select 0;
 _y11=(_segmentA select 0) select 1;
 _x12=(_segmentA select 1) select 0;
 _y12=(_segmentA select 1) select 1;
 
 _x21=(_segmentB select 0) select 0;
 _y21=(_segmentB select 0) select 1;
 _x22=(_segmentB select 1) select 0;
 _y22=(_segmentB select 1) select 1;
 
 _dx1= _x12 - _x11;
 _dy1= _y12 - _y11;
 _dx2= _x22 - _x21;
 _dy2= _y22 - _y21;

 _delta = (_dx2 * _dy1) - (_dy2 * _dx1);
 //Parallel check
 if (_delta < 0.001 ) exitWith {False}; 

 _s = (_dx1 * (_y21-_y11) + _dy1 * (_x11 - _x21)) / delta;
 _t = (_dx2 * (_y11-_y21) + _dy2 * (_x21 - _x11)) / (-delta);
 
 _result= (0 <= _s <= 1) && (0 <= _t <= 1);
 _result
};

/**
 Point segment distance
**/
stwf_point_segment_distance2D=
{
 params ["_point","_segment"];
 
 _px = _point select 0;
 _py = _point select 1;
 _x1=(_segment select 0) select 0;
 _y1=(_segment select 0) select 1;
 _x2=(_segment select 1) select 0;
 _y2=(_segment select 1) select 1;
 
  _dx = _x2 - _x1;
  _dy = _y2 - _y1;
  
  //check if the segment's just a point
  if (_dx == _dy == 0) exitWith 
  {
     _v2d=[_px-_x1,_py-_y1];
	_result= [_v2d] call stwf_hypot2D;
	_result
  };  
    
  //Calculate the t that minimizes the distance.
  _t = ((_px - _x1) * _dx + (_py - _y1) * _dy) / (_dx * _dx + _dy * _dy);

  // See if this represents one of the segment
  // end points or a point in the middle.
  if (t < 0) then
  {
    _dx = _px - _x1;
    _dy = _py - _y1;
  } else 
  {
	if (t > 1) then
	{
		_dx = _px - _x2;
		_dy = _py - _y2;
	}  else
	{
		_near_x = _x1 + _t * _dx;
		_near_y = _y1 + _t * _dy;
		_dx = _px - _near_x;
		_dy = _py - _near_y;
	};
  };
  
   _v2d=[_dx,__dy];
   _result= [_v2d] call stwf_hypot2D;
   _result
};

/**
The closest distance between two segments is either zero if they intersect or the distance from one of the lines' end points to the other line. DistBetweenSegments first calls SegmentsIntersect to see if the segments intersect. If they do, it returns zero. It returns the point of intersection returned by SegmentsIntersect for both of the closest points.
**/
stwf_segmentsDistance2D=
{
 params ["_segmentA","_segmentB"];
 _intersect=[_segmentA,_segmentB] call stwf_segmentsIntersect2D;
 
 if (_intersect) exitWith {0};
 
 //try each of the 4 vertices w/the other segment
  _distances = [];
  
  _point = _segmentA select 0;
  _segment=_segmentB;
  _d=[_point,_segment] call stwf_point_segment_distance2D;
  _distances pushBack _d;
  
  _point = _segmentA select 1;
  _segment=_segmentB;
  _d=[_point,_segment] call stwf_point_segment_distance2D;
  _distances pushBack _d;
  
  _point = _segmentB select 0;
  _segment=_segmentA;
  _d=[_point,_segment] call stwf_point_segment_distance2D;
  _distances pushBack _d;
  
  _point = _segmentB select 1;
  _segment=_segmentA;
  _d=[_point,_segment] call stwf_point_segment_distance2D;
  _distances pushBack _d;
  
  _result = selectMin distances;
  _result
};

/**
 Vector module 2D
**/
stwf_module2D=
{
 params ["_v2d"];
 _xv=_v2d select 0;
 _yv=_v2d select 1;
 _sqs=_xv*_xv+_yv*_yv;
 _sqr=sqrt _sqs;
 _sqr;
};

/**
Distance in ONE dimension
**/
stwf_distance1D=
{
 params ["_values"];
 _a=_values select 0;
 _b=_values select 1;
 _result = abs (_b-_a);
 _result
};

/**
 Distance between two 2D points
**/
stwf_distance2D=
{
 params ["_pointA","_pointB"];
 _vx=(_pointB select 0)-(_pointA select 0);
 _vy=(_pointB select 1)-(_pointA select 1);
 _v=[_vx,_vy];
 _result=[_v] call stwf_module2D;
 _result
};


/**
 Draw line on map
 warning: color=[r,g,b,a], eg. white: _color=[1,1,1,1];
 **/
 stwf_drawLine=
 {
  params ["_pointA","_pointB","_color"];
  _codestr="(_this select 0) drawLine ";
  _codestr=_codestr+format ["[%1,%2,%3];",_pointA,_pointB,_color];
  //diag_log _codestr;
  _handler=(findDisplay 12 displayCtrl 51) ctrlAddEventHandler ["Draw",_codestr];
  
  _handler
 };
 
 
 stwf_removeDrawingHandler=
 {
  params ["_handlerName"];
  _index=STWG_DRAWING_HANDLERS find _handlerName;
  if (_index!=-1) then
  {
	(findDisplay 12 displayCtrl 51) ctrlRemoveEventHandler ["Draw",_handlerId];
  };
 };
 
 stwf_newDrawLinesOnMapHandler=
 {
  params ["_stwHandlerName","_lines","_color"];
  _codestr=""; 
   {
    _line=_x;
    _codestr=_codestr+"(_this select 0) drawLine ";
	_pointA=_x select 0;
	_pointB=_x select 1;
	_codestr=_codestr+format ["[%1,%2,%3];",_pointA,_pointB,_color];
  } forEach _lines;
  diag_log _codestr;
  _result=[_stwHandlerName,_codestr,false,nil];
  STWG_DRAWING_HANDLERS pushBack _result;
  _result
 };
 
 stwf_findHandlerInfo=
 {
  params["_stwHandlerName"];
  diag_log "stwf_findHandlerInfo";
  _handlerInfo=nil;
  {
    _currentHandlerInfo=_x;
	_currentHandlerName=_x select 0;
	if (_currentHandlerName==_stwHandlerName) exitWith{_handlerInfo=_currentHandlerInfo};
   } forEach STWG_DRAWING_HANDLERS;
   _result=_handlerInfo;
   _result
 };
 
 stwf_activateDrawHandler=
 {
   params["_stwHandlerName"];
   _handlerInfo=[_stwHandlerName] call stwf_findHandlerInfo;
   if (!isNil("_handlerInfo")) then
   {
     _isOn=_handlerInfo select 2;
	 if (!_isOn) then
	 {
		_handlerCode=_handlerInfo select 1;
		_handlerId=(findDisplay 12 displayCtrl 51) ctrlAddEventHandler ["Draw",_handlerCode];
		_handlerInfo set [2,true];
		_handlerInfo set [3,_handlerId];
		diag_log format ["Drawing handler %1 activated.",_stwHandlerName];
	 }; 
   };
 };
 
 stwf_deActivateDrawHandler=
 {
   params["_stwHandlerName"];
   _handlerInfo=[_stwHandlerName] call stwf_findHandlerInfo;
   if (!isNil("_handlerInfo")) then
   {
     _isOn=_handlerInfo select 2;
	 if (_isOn) then
	 {
		_handlerId=_handlerInfo select 3;
		(findDisplay 12 displayCtrl 51) ctrlRemoveEventHandler ["Draw",_handlerId];
		_handlerInfo set [2,false];
		_handlerInfo set [3,nil];
		diag_log format ["Drawing handler %1 deactivated.",_stwHandlerName];
	 }; 
   };
 };
 
 

#endif