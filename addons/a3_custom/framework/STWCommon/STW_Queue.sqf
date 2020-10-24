#ifndef STW_Queue_Module_Loaded
#define STW_Queue_Module_Loaded true
diag_log "STW_Queue_Module_Loaded";
/**
 Create new  queue of name
**/
stwf_newQueue=
{
 params ["_queueGlobalName"];
 _result=[0,[]];
 [_queueGlobalName,_result] call stwf_setGlobalVariable;
 _result
};

/**
 Clear the  queue
**/
stwf_clearQueue=
{
 params ["_pqName"];
 [_pqName,[0,[]]] call stwf_setGlobalVariable;
};

/**
 Free the  queue
**/
stwf_freeQueue=
{
 params ["_pqName"];
 [_pqName] call stwf_clearQueue;
};

/**
Enqueue element
**/
stwf_Enqueue=
{
 params["_pqName","_element"];
 //diag_log format ["stwf_Enqueue %1 %2",_pqName,_element];
 _gq=[_pqName] call stwf_getGlobalVariable;
 _size=_gq select 0;
 //diag_log format ["QUEUE: %1",_gq];
 _q= (_gq select 1);
 _q pushBack _element;
 _gq set [0,_size+1];
};

/**
Dequeue
**/
stwf_Dequeue=
{
 params["_pqName"];
  _q=[_pqName] call stwf_getGlobalVariable;
 _size=_q select 0;
 _head=nil;
 if (_size==0) exitWith {nil};
 _head = (_q select 1) deleteAt 0;
 _q set [0,_size-1];
 _head
};

/**
Peek head of queue
**/
stwf_peekQueue=
{
  params["_qName"];
  _q=[_qName] call stwf_getGlobalVariable;
  _head = (_q select 1) select 0;
  _head
};

/**
Get the size (number of elements) of the  queue
**/
stwf_sizeQueue=
{
 params["_pqName"];
  _q=[_pqName] call stwf_getGlobalVariable;
  _s=_q select 0;
  _s
};

/**
 Check if queue is empty
**/
stwf_isEmptyQueue=
{
 params["_qName"];
  _q=[_qName] call stwf_getGlobalVariable;
  _s=_q select 0;
  _result=(_s==0);
  _result
};
/*
["QueueA"] call stwf_newQueue;
["QueueA","AAA"] call stwf_Enqueue;
["QueueA","BBB"] call stwf_Enqueue;
["QueueA","CCC"] call stwf_Enqueue;
["QueueA","DDD"] call stwf_Enqueue;
diag_log QueueA;
_elem=["QueueA"] call stwf_Dequeue;
diag_log _elem;
diag_log QueueA;
_elem=["QueueA"] call stwf_Dequeue;
diag_log _elem;
diag_log QueueA;
["QueueA","EEE"] call stwf_Enqueue;
diag_log QueueA;
diag_log (["QueueA"] call stwf_sizeQueue);
diag_log "PEEK";
diag_log QueueA;
_elem=["QueueA"] call stwf_peekQueue;
diag_log format ["PEEK RESULT %1",_elem];
diag_log QueueA;
["QueueA"] call stwf_freeQueue;
diag_log (["QueueA"] call stwf_sizeQueue);
*/
#endif