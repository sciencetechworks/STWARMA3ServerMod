#ifndef STW_PriorityQueue_Module_Loaded
#define STW_PriorityQueue_Module_Loaded true
diag_log "STW_PriorityQueue_Module_Loaded";
/**
 Create new priority queue of name
**/
stwf_newPriorityQueue=
{
 params ["_queueGlobalName"];
 _result=[0,[]];
 [_queueGlobalName,_result] call stwf_setGlobalVariable;
 _result
};

/**
 Clear the priority queue
**/
stwf_clearPriorityQueue=
{
 params ["_pqName"];
 [_pqName,[0,[]]] call stwf_setGlobalVariable;
};

/**
 Free the priority queue
**/
stwf_freePriorityQueue=
{
 params ["_pqName"];
 [_pqName] call stwf_clearPriorityQueue;
};

/**
Enqueue element
**/
stwf_priorityEnqueue=
{
 params["_pqName","_element","_priority"];
 _q=[_pqName] call stwf_getGlobalVariable;
 _size=_q select 0;
 (_q select 1) pushBack [_priority,_element];
 _q set [0,_size+1];
 (_q select 1) sort true;
 _q
};

/**
Dequeue
**/
stwf_priorityDequeue=
{
 params["_pqName"];
  _q=[_pqName] call stwf_getGlobalVariable;
 _size=_q select 0;
 if (_size==0) exitWith {nil};
 _head = (_q select 1) deleteAt 0;
 _q set [0,_size-1];
 _head
};

/**
Peek head of queue
**/
stwf_peekPriorityQueue=
{
  params["_pqName"];
  _q=[_pqName] call stwf_getGlobalVariable;
  _head = +((_q select 1) select 0);
  _head
};

/**
Get the size (number of elements) of the priority queue
**/
stwf_sizePriorityQueue=
{
 params["_pqName"];
  _q=[_pqName] call stwf_getGlobalVariable;
  diag_log _q;
  _s=_q select 0;
  _s
};

/**
 Empty Check
**/
stwf_isEmptyPriorityQueue=
{
 params ["_pqName"];
 _size=[_pqName] call stwf_sizePriorityQueue;
 if (_size==0) exitWith {true};
 false
};

//["PQueueA"] call stwf_newPriorityQueue;
//["PQueueA","AAA",5] call stwf_priorityEnqueue;
//["PQueueA","BBB",3] call stwf_priorityEnqueue;
//["PQueueA","CCC",9] call stwf_priorityEnqueue;
//["PQueueA","DDD",1] call stwf_priorityEnqueue;
//diag_log PQueueA;
//_elem=["PQueueA"] call stwf_priorityDequeue;
//diag_log _elem;
//diag_log PQueueA;
//_elem=["PQueueA"] call stwf_priorityDequeue;
//diag_log _elem;
//diag_log PQueueA;
//["PQueueA","EEE",14] call stwf_priorityEnqueue;
//diag_log PQueueA;
//diag_log (["PQueueA"] call stwf_sizePriorityQueue);
//diag_log "PEEK";
//diag_log PQueueA;
//_elem=["PQueueA"] call stwf_peekPriorityQueue;
//diag_log _elem;
//diag_log PQueueA;
//["PQueueA"] call stwf_freePriorityQueue;
//diag_log (["PQueueA"] call stwf_sizePriorityQueue);
#endif