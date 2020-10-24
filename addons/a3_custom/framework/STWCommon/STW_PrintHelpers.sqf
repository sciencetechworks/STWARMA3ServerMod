markLANDWithDot=
{
 _position2D=_this;
 _markerName= format ["Dot %1",random 10001];
 _marker = createMarker [_markername, _position2D];
 _marker setMarkerShape "ELLIPSE";
 _marker setMarkerSize [ 50, 50 ];
 //_marker setMarkerShape "ICON";
 _marker setMarkerColor "colorBlack";
 //_marker setMarkerType "hd_dot";
  sleep 0.01;
};

markWithDot=
{
 _position2D=_this select 0;
 _color=_this select 1;
 _markerName= format ["Dot %1",random 10001];
 _marker = createMarker [_markername, _position2D];
 _marker setMarkerShape "ELLIPSE";
 _marker setMarkerSize [ 200, 200 ];
 //_marker setMarkerShape "ICON";
 _marker setMarkerColor _color;
 //_marker setMarkerType "hd_dot";
};


markZoneWithDot=
{
 params ["_zone","_color"];
 _position2D=[_zone] call stwf_getCenterOfRectangle2D;
 _color=_this select 1;
 
 _markerName= format ["MKR_WATERZONEDOT%1",STWG_MARKER_COUNT];
 STWG_MARKER_COUNT=STWG_MARKER_COUNT+1;
 _marker = createMarker [_markername, _position2D];
 _marker setMarkerColor _color;
 //sleep 0.1;
 _marker setMarkerShape "ELLIPSE";
 _marker setMarkerSize [ 10, 10 ];
 //_marker setMarkerShape "ICON";
 //_marker setMarkerType "hd_dot";
};

markZoneAsWaterSquare=
{
  _zone=_this;
  //diag_log format ["_markZoneAsWaterSquare %1",_zone];
  
  _up2Dcoord=_zone select 0;
  _down2Dcoord=_zone select 1;
  _x0=_up2Dcoord select 0;
  _y0=_up2Dcoord select 1;
  _x1=_down2Dcoord select 0;
  _y1=_down2Dcoord select 1;
  //[[_x0,_y0],"colorBlack"] call _markWithDot;
  //[[_x1,_y0],"colorYellow"] call _markWithDot;
  //[[_x0,_y1],"colorGreen"] call _markWithDot;
  //[[_x1,_y1],"colorBrown"] call _markWithDot;
  
  _markerName= format ["MKR_WATER_ZONE%1",STWG_MARKER_COUNT];
  STWG_MARKER_COUNT=STWG_MARKER_COUNT+1;
  _markerstr = createMarker [_markerName, [_x0+((_x1-_x0)/2),_y0+((_y1-_y0)/2)]];
  _markerstr setMarkerShape "RECTANGLE";
  _markerstr setMarkerSize [(_x1-_x0)/2,(_y1-_y0)/2];
  _markerstr setMarkerColor "colorBlue";
  //[_zone,"colorRed"] call _markZoneWithDot;  
};

markZoneAsLandSquare=
{
  _zone=_this;
  //diag_log format ["_markZoneAsWaterSquare %1",_zone];
  
  _up2Dcoord=_zone select 0;
  _down2Dcoord=_zone select 1;
  _x0=_up2Dcoord select 0;
  _y0=_up2Dcoord select 1;
  _x1=_down2Dcoord select 0;
  _y1=_down2Dcoord select 1;
  //[[_x0,_y0],"colorBlack"] call _markWithDot;
  //[[_x1,_y0],"colorYellow"] call _markWithDot;
  //[[_x0,_y1],"colorGreen"] call _markWithDot;
  //[[_x1,_y1],"colorBrown"] call _markWithDot;
  
  _markerName= format ["MKR_LAND_ZONE%1",STWG_MARKER_COUNT];
  STWG_MARKER_COUNT=STWG_MARKER_COUNT+1;
  _markerstr = createMarker [_markerName, [_x0+((_x1-_x0)/2),_y0+((_y1-_y0)/2)]];
  _markerstr setMarkerShape "RECTANGLE";
  _markerstr setMarkerSize [(_x1-_x0)/2,(_y1-_y0)/2];
  _markerstr setMarkerColor "colorBrown";
  //[_zone,"colorRed"] call _markZoneWithDot;  
};

markZoneAsInspected=
{
  _zone=_this;
  
  _up2Dcoord=_zone select 0;
  _down2Dcoord=_zone select 1;
  _x0=_up2Dcoord select 0;
  _y0=_up2Dcoord select 1;
  _x1=_down2Dcoord select 0;
  _y1=_down2Dcoord select 1;
  
  _markerName= format ["MKR_INSPECTED_ZONE%1",STWG_MARKER_COUNT];
  STWG_MARKER_COUNT=STWG_MARKER_COUNT+1;
  _markerstr = createMarker [_markerName, [_x0+((_x1-_x0)/2),_y0+((_y1-_y0)/2)]];
  _markerstr setMarkerShape "RECTANGLE";
  _markerstr setMarkerSize [(_x1-_x0)/2,(_y1-_y0)/2];
  _markerstr setMarkerColor "colorYellow";
  //[_zone,"colorRed"] call _markZoneWithDot;  
};