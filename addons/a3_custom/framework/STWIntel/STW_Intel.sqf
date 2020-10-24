#ifndef  STW_Intel_Module_Loaded
#define STW_Intel_Module_Loaded true
diag_log "STW_Intel_Module Loaded";

stwf_getGraphNodeIndexOfPosition=
{
 params ["_position2D","_graph"];
 _nodes=[_graph] call stwf_getGraphNodes;
 _i=0;
 _resultIndex=-1;
 {
  _node=_x;
  _isInto=[_position2D,_node] call stwf_isPositionIntoRectangle;
  if (_isInto==true) exitWith { _resultIndex=_i};
  _i=_i+1;
 } forEach _nodes;
 _resultIndex
};




#endif