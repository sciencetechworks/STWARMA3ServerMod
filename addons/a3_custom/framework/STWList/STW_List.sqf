// list is a [array,length] pair 
 
stwfList_construct = { 
 [[],0]; 
}; 
 
// [list]
stwfList_isEmpty = {
 _lc= _this select 0; 
 (_lc select 1) == 0; 
}; 
 
// [list]
stwfList_size= { 
 _lc = _this select 0; 
 //diag_log format ["SIZE OF:%1",_lc];
 _lc select 1; 
}; 
 
// [list,index] 
stwfList_get = { 
 _l=(_this select 0) select 0; 
 _indx= _this select 1; 
 _l select _indx;  
}; 
 
// [list,index,value] 
stwfList_set = { 
 _l=(_this select 0) select 0; 
 _indx= _this select 1; 
 _val= _this select 2; 
 _l set [_indx,_val]; 
 0; 
}; 
 
// [list,val] 
stwfList_add = { 
 _l=(_this select 0) select 0; 
 _counter=(_this select 0) select 1; 
 _val= _this select 1; 
 _l pushBack _val; 
 (_this select 0) set [1,_counter+1]; 
 0;  
}; 
 
// [list,val] 
stwfList_removeFirst = { 
 _l=(_this select 0) select 0; 
 _counter=(_this select 0) select 1; 
 _val= _this select 1; 
 _indx=_l find _val; 
 if (_indx<0) exitWith {-1}; 
 _l deleteAt _indx;
 (_this select 0) set [1,_counter-1]; 
  0; 
}; 
 
// [list,val] 
stwfList_removeAll = { 
 _l=(_this select 0) select 0; 
 _counter=(_this select 0) select 1; 
 _val= _this select 1; 
 _indx=1;
 _newCount=_counter;
 while {_indx>=0} do
 {
   _indx=_l find _val;
    if (_indx>=0) then
	{
		_l deleteAt _indx;
		_newCount=_newCount-1;
	};
 }; 
   
 (_this select 0) set [1,_newCount]; 
 0; 
}; 
 
// [list] 
stwfList_copy = { 
 _l=(_this select 0) select 0; 
 _counter=(_this select 0) select 1; 
 _l2 = +l; 
 [_l2,_counter]; 
}; 
 
// [list] 
stwfList_clear = { 
 _l=(_this select 0); 
 _l set [0,[]];
 _l set [1,0];
 0;
};

//[]
stwfList_debug = {
 diag_log format ["%1",_this];
};

//[list]
stwfList_getArray = {
	_l=(_this select 0) select 0; 
	_l;
};

stwfList_test={
 _lA= [] call stwfList_construct;
 diag_log format ["Is empty:%1",[_lA] call stwfList_isEmpty];
 _lA call stwfList_debug;
 [_lA,"Hello"] call stwfList_add;
 _lA call stwfList_debug;
 [_lA,"Hello"] call stwfList_add;
 _lA call stwfList_debug;
 [_lA,1,"Silver"] call stwfList_set;
 _lA call stwfList_debug;
 [_lA,0,"Gold"] call stwfList_set;
 _lA call stwfList_debug;
 [_lA,"Copper"] call stwfList_add;
 diag_log format ["Is empty:%1",[_lA] call stwfList_isEmpty];
 _lA call stwfList_debug;
 [_lA,"Silver"] call stwfList_removeFirst;
 _lA call stwfList_debug;
 [_lA] call stwfList_clear;
  _lA call stwfList_debug;
  diag_log format ["Is empty:%1",[_lA] call stwfList_isEmpty];
  [_lA,"A"] call stwfList_add;
  [_lA,"B"] call stwfList_add;
  [_lA,["A","X","Y"]] call stwfList_add;
  [_lA,"C"] call stwfList_add;
  _lA call stwfList_debug;
  [_lA,["A","X","Y"]] call stwfList_removeFirst;
  _lA call stwfList_debug;
  [_lA,["A","X","Y"]] call stwfList_add;
  [_lA,"P"] call stwfList_add;
  [_lA,["A","X","Y"]] call stwfList_add;
  [_lA,"Q"] call stwfList_add;
  [_lA,["A","X","Y"]] call stwfList_add;
  [_lA,"R"] call stwfList_add;
  [_lA,"A"] call stwfList_add;
  _lA call stwfList_debug;
  [_lA,["A","X","Y"]] call stwfList_removeAll;
  _lA call stwfList_debug;
  [_lA,"A"] call stwfList_removeAll;
  _lA call stwfList_debug;
};

//[] call stwfList_test;