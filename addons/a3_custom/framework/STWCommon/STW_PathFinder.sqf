#ifndef STW_PathFinder_Module_Loaded
#define STW_PathFinder_Loaded true
diag_log "STW_PathFinder_Module_Loaded";

// A graph is a [ [nodes] [edges] ]
// edge = [nodeIndexStart,NodeIndexEnd,cost]
// node = [identifier,data]
// nodes = [node1,..nodeN]
// neighbours = [ [neighbourcount,[neigbour01,neigbour02,...]]...]
// neighbour = [nodeendIndex,cost]

stwf_showGraphInLog= 
{ 
 params ["_name","_graph"]; 
 diag_log format ["%1=[",_name]; 
 diag_log format ["//NodeList"]; 
 diag_log format [" ["]; 
 _i=0;
 _nodes=_graph select 0; 
 _nNodes=count _nodes;
 { 
  _node=_x; 
  _i=_i+1;  
  if (_i!=_nNodes) then
  {
	diag_log format ["%1,",_node];
  } else
  {
    diag_log format ["%1",_node];
  };
 }forEach _nodes; 
 diag_log format [" ],"]; 
 diag_log format ["//EdgeList"]; 
 diag_log format [" ["];; 
 _i=0;
 _edges=_graph select 1; 
 _nEdges=count _edges;
 { 
  _edge=_x; 
  _i=_i+1;
  if (_i!=_nEdges) then
  {
	diag_log format ["%1,",_edge];
  } else
  {
    diag_log format ["%1",_edge];
  };
  
 }forEach _edges; 
 diag_log format [" ]"]; 
 diag_log format ["];"]; 
};


stwf_getGraphNodes=
{
 params ["_graph"];
 _return=_graph select 0;
 _return
};

stw_getGraphEdges=
{
 params ["_graph"];
 _return=_graph select 1;
 _return
};

stw_getEdgeStartNodeIndex=
{
  params ["_edge"];
  //diag_log format ["edge %1",_edge];
 _return=_edge select 0;
 _return
};

stw_getEdgeEndNodeIndex=
{
  params ["_edge"];
 _return=_edge select 1;
 _return
};

stw_getEdgeCost=
{
  params ["_edge"];
 _return=_edge select 2;
 _return
};


stwf_getEdgesStartingAtNodeIndex=
{
 params ["_graph","_nodeIndex"];
 _resultEdges=[];
 //diag_log "stwf_getEdgesStartingAtNodeIndex";
 _edges = ([_graph] call stw_getGraphEdges);
 //diag_log format ["edges %1",_edges];
 {
   _edge=_x;
    //diag_log format ["edge %1",_edge];
   _edgeStartNode=[_edge] call stw_getEdgeStartNodeIndex;
   if (_edgeStartNode==_nodeIndex) then
   {
    _resultEdges pushBack _edge;
   };
 } forEach _edges;

 _resultEdges
};


stwf_getNodeIdentifier=
{
 params ["_node"];
 _result=_node select 0;
 _result
};


stwf_getGraphNodeIndex=
{
 params ["_graph","_node"];
 _toFindId=[_node] call stwf_getNodeIdentifier; 
 _nodes=[_graph] call stwf_getGraphNodes;
 _nodeCount= count _nodes;
 _result=-1;
 for [{_i=0},{_i<_nodeCount},{_i=_i+1}] do
 {
  _node=_nodes select i;
  _nodeId=[_node] call stwf_getNodeIdentifier; 
  if (_nodeId==_toFindId) exitWith {_result=_i; _result};
 };
 _result
};



stwf_getGraphNodeIndexNeighboursIndexes=
{
 params ["_graph","_nodeIndex"];
  _edges=[_graph,_nodeIndex] call stwf_getEdgesStartingAtNodeIndex;
 _neighboursIndexes=[];
 {
  _edge=_x;
  _nodeEndIndex=[_edge] call stw_getEdgeEndNodeIndex;
  _neighboursIndexes pushBack _nodeEndIndex;
 } foreach _edges;
 
 _neighboursIndexes
};

stwf_getGraphNodeIndexNeighboursIndexesAndCosts=
{
 params ["_graph","_nodeIndex"];
  _edges=[_graph,_nodeIndex] call stwf_getEdgesStartingAtNodeIndex;
 _neighboursIndexes=[];
 {
  _edge=_x;
  _nodeEndIndex=[_edge] call stw_getEdgeEndNodeIndex;
  _edgeCost=[_edge] call stw_getEdgeCost;
  _neighboursIndexes pushBack [_nodeEndIndex,_edgeCost];
 } foreach _edges;
 
 _neighboursIndexes
};



stwf_bfs=
{
 params ["_graph","_nodeIndexStart"];
 ["FrontierQueue"] call stwf_newQueue;
 //diag_log format ["Queue created:%1",FrontierQueue];
 ["FrontierQueue",_nodeIndexStart] call stwf_Enqueue;
 //diag_log format ["Equeue start node index %1 %2",_nodeIndexStart,FrontierQueue];
 _visited=[];
 _visited pushBack _nodeIndexStart;
 
 diag_log "Start queue processing";
 while {!(["FrontierQueue"] call stwf_isEmptyQueue)} do
 {
  _currentNodeIndex=["FrontierQueue"] call stwf_deQueue;
   diag_log format ["VISITED %1",_currentNodeIndex];//<-- Visit it
  //diag_log format ["Extracted %1 from queue: %2",_currentNodeIndex,FrontierQueue];
  _currentNodeNeighbours=[_graph,_currentNodeIndex] call stwf_getGraphNodeIndexNeighboursIndexes;
  //diag_log format ["Neighbours of %1 are: %2",_currentNodeIndex,_currentNodeNeighbours];
  {
   _currentNeighbourIndex=_x;
   if (!(_currentNeighbourIndex in _visited)) then
   {
	["FrontierQueue",_currentNeighbourIndex] call stwf_Enqueue;
	//diag_log format ["Equeue Neighbour %1 in queue:%2",_currentNeighbourIndex,FrontierQueue];
	_visited pushBack _currentNeighbourIndex; 
   };
  } forEach _currentNodeNeighbours;
 };
};

stwf_bfsWithParents=
{
 params ["_graph","_nodeIndexStart"];
 ["FrontierQueue"] call stwf_newQueue;
 ["FrontierQueue",_nodeIndexStart] call stwf_Enqueue;
 _cameFrom=[];
 _nNodes=count ([_graph] call stwf_getGraphNodes);
 for [{_i=0},{_i<_nNodes},{_i=_i+1}] do
 {
   _cameFrom pushBack -1;
 };

 while {!(["FrontierQueue"] call stwf_isEmptyQueue)} do
 {
  _currentNodeIndex=["FrontierQueue"] call stwf_deQueue;
  diag_log format ["VISITED %1",_currentNodeIndex];//<-- Visit it
  //diag_log _cameFrom;
  _currentNodeNeighboursIndexes=[_graph,_currentNodeIndex] call stwf_getGraphNodeIndexNeighboursIndexes;
  {
   _currentNeighbourIndex=_x;
   //diag_log format ["Current NI %1",_currentNeighbourIndex];
   _parent=_cameFrom select _currentNeighbourIndex;
   if (_parent==-1) then
   {
	["FrontierQueue",_currentNeighbourIndex] call stwf_Enqueue;
	_cameFrom set [_currentNeighbourIndex,_currentNodeIndex]; 
   };
  } forEach _currentNodeNeighboursIndexes;
 };
 
 _cameFrom
};

stwf_bfsWithParentsEarlyExit=
{
 params ["_graph","_nodeIndexStart","_nodeIndexGoal"];
 ["FrontierQueue"] call stwf_newQueue;
 ["FrontierQueue",_nodeIndexStart] call stwf_Enqueue;
 _cameFrom=[];
 _nNodes=count ([_graph] call stwf_getGraphNodes);
 for [{_i=0},{_i<_nNodes},{_i=_i+1}] do
 {
   _cameFrom pushBack -1;
 };

 while {!(["FrontierQueue"] call stwf_isEmptyQueue)} do
 {
  _currentNodeIndex=["FrontierQueue"] call stwf_deQueue;
  diag_log format ["VISITED %1",_currentNodeIndex];//<-- Visit it
  
  if (_currentNodeIndex==_nodeIndexGoal) exitWith{};
  
  //diag_log _cameFrom;
  _currentNodeNeighboursIndexes=[_graph,_currentNodeIndex] call stwf_getGraphNodeIndexNeighboursIndexes;
  {
   _currentNeighbourIndex=_x;
   //diag_log format ["Current NI %1",_currentNeighbourIndex];
   _parent=_cameFrom select _currentNeighbourIndex;
   if (_parent==-1) then
   {
	["FrontierQueue",_currentNeighbourIndex] call stwf_Enqueue;
	_cameFrom set [_currentNeighbourIndex,_currentNodeIndex]; 
   };
  } forEach _currentNodeNeighboursIndexes;
 };
 
 _cameFrom
};


/**
 Dijsktra algorithm
*/
stwf_shortestPathUniformCost=
{
 params ["_graph","_nodeIndexStart","_nodeIndexGoal"];
 ["FrontierPQueue"] call stwf_newPriorityQueue;
 ["FrontierPQueue",_nodeIndexStart,0] call stwf_PriorityEnqueue;
 _cameFrom=[];
 _costSoFar=[];
 _nNodes=count ([_graph] call stwf_getGraphNodes);
 for [{_i=0},{_i<_nNodes},{_i=_i+1}] do
 {
   _cameFrom pushBack -1;
   _costSoFar pushBack -1;
 };
 _costSoFar set [_nodeIndexStart,0];
 
 while {!(["FrontierPQueue"] call stwf_isEmptyPriorityQueue)} do
 {
  _pqExtract=["FrontierPQueue"] call stwf_priorityDeQueue;
  _currentEdgeCost=_pqExtract select 0;
  _currentNodeIndex=_pqExtract select 1;
  diag_log format ["VISITED %1 (priority %2)",_currentNodeIndex,_currentEdgeCost];//<-- Visit it
  diag_log format ["[current %1, goal %2]",_currentNodeIndex,_nodeIndexGoal];
  if (_currentNodeIndex==_nodeIndexGoal) exitWith{diag_log format ["Goal Found %1",_cameFrom]; [_cameFrom,_costSoFar]};
  
  //diag_log _cameFrom;
  _currentNeighboursAndCostsInfo=[_graph,_currentNodeIndex] call stwf_getGraphNodeIndexNeighboursIndexesAndCosts;
  diag_log format ["nodeIndex %1 :neighbourS index and cost :%2",_currentNodeIndex,_currentNeighboursAndCostsInfo];
  //_currentNodeNeighboursIndexes= _currentNeighboursAndCostsInfo select 0;
  //_currentNodeNeighboursCosts= _currentNeighboursAndCostsInfo select 1;
  {
   _currentNeighbourInfo=_x; // this is next 
   diag_log format ["Selected Neighbour index and cost %1",_currentNeighbourInfo];
   _currentNeighbourIndex= _currentNeighbourInfo select 0;
   _currentNeighbourCost= _currentNeighbourInfo select 1;
   _edgeCost=(_costSoFar select _currentNeighbourIndex);
   _nextIsNotPresent=(_edgeCost==-1);
   if (_nextIsNotPresent) then
   {
    _edgeCost=_currentEdgeCost;
   };
   _newCost=_currentNeighbourCost+ _edgeCost;
   //diag_log format ["Current NI %1",_currentNeighbourIndex];
   _parent=_cameFrom select _currentNeighbourIndex;
   if ((_nextIsNotPresent)||(_newCost<_currentNeighbourCost)) then
   {
	_costSoFar set [_currentNeighbourIndex,_newCost];
	_priority=_newCost;
	diag_log format ["Adding node index,cost [%1,%2] to queue.",_currentNeighbourIndex,_priority];
	["FrontierPQueue",_currentNeighbourIndex,_priority] call stwf_PriorityEnqueue;
	diag_log format ["Queue=%1",FrontierPQueue];
	_cameFrom set [_currentNeighbourIndex,_currentNodeIndex]; 
   };
  } forEach _currentNeighboursAndCostsInfo;
 };
 
 [_cameFrom,_costSoFar];
};

stwf_parsePathTo=
{
 params ["_startIndex","_goalIndex","_cameFromArray"];
 _currentIndex=_goalIndex;
 _path=[];
 while {_currentIndex!=_startIndex} do
 {
  _path pushBack _currentIndex;
  _currentIndex = _cameFromArray select _currentIndex;
 };
 
 _path pushBack _startIndex;
 reverse _path;
 _path
};


// A graph is a [ [nodes] [edges] ]
// edge = [nodeIndexStart,NodeIndexEnd,cost]
// node = [identifier,data]
// nodes = [node1,..nodeN]
// neighbours = [ [neighbourcount,[neigbour01,neigbour02,...]]...]
// neighbour = [nodeendIndex,cost]
_sampleNodes=[["NodeZero",["DATAA"]],["NodeOne",["DATAB"]],["NodeTwo",["DATAC"]],["NodeThree",["DATAD"]],["NodeFour",["DATAE"]]];
_sampleEdges=[[0,1,2],[0,3,4],[1,2,3],[2,4,2],[3,1,3],[3,2,2],[3,4,1]];
_sampleGraph=[_sampleNodes,_sampleEdges];

//_neighboursOf3=[_sampleGraph,3] call stwf_getEdgesStartingAtNodeIndex;
//diag_log _neighboursOf3;
diag_log ">>>>>>>>>>>>>>>>> SAMPLE START <<<<<<<<<<<<<<<<<<<<<";
//[_sampleGraph,0] call stwf_bfs;
/*_visitPath=[_sampleGraph,0] call stwf_bfsWithParents;
_pathOrder=[0,4,_visitPath] call stwf_parsePathTo;
diag_log format ["Visit path order is:%1",_pathOrder];
_pathOrder=[0,2,_visitPath] call stwf_parsePathTo;
diag_log format ["Visit path order is:%1",_pathOrder];
*/
_visitPathAndCost=[_sampleGraph,0,4] call stwf_shortestPathUniformCost;
diag_log format ["Dijstra results=%1",_visitPathAndCost];
_pathOrder=[0,4,_visitPathAndCost select 0] call stwf_parsePathTo;
diag_log format ["Visit path order is:%1",_pathOrder];
#endif