diag_log "STW CITIES!!!";
if (!isServer) exitWith {};

waitUntil {(count ([] call BIS_fnc_listPlayers))>0};

STW_TOWNS=[];


STW_CONQUERED_CITIES=[];

STW_CITY_RADIUS_MULTIPLIER=0.5;


// RESET CONQUERED CITIES CODE:
//_stwPersistenceDatabase = ["new", "inidbi"] call OO_PDW;
// _dbName="STWPERSISTENCE_EOS";
// ["setDbName", _dbName] call _stwPersistenceDatabase;
//_bool = ["write",["STW_CONQUERED_CITIES", []]] call _stwPersistenceDatabase;			
//diag_log format["STW CONQUERED CITIES RESET %1",_bool];

//RECOVER STW_CONQUERED_CITIES from Database
_stwPersistenceDatabase = ["new", "inidbi"] call OO_PDW;
_dbName="STWPERSISTENCE_EOS";
["setDbName", _dbName] call _stwPersistenceDatabase;
STW_CONQUERED_CITIES = ["read",["STW_CONQUERED_CITIES", STW_CONQUERED_CITIES]] call _stwPersistenceDatabase;			
diag_log format["STW CONQUERED CITY READ FROM DATABASE %1",STW_CONQUERED_CITIES];

if (isNil "STW_CONQUERED_CITIES") then
{
 STW_CONQUERED_CITIES=[];
};


fstwFindTownDetails ={
  _cityName=_this;
  //diag_log format ["Searching for city:%1",_cityName]; 
  _ntowns=count STW_TOWNS;	
  _found=false;
  _result=[];
  for [ {private "_i"; _i=0;},{(_i<_ntowns)&&(!_found)},{_i=_i+1}] do
  {
   _city=STW_TOWNS select _i;
   _compareCityName= _city select 1;
   //diag_log ["Compare city:%1",_compareCityName];
   //diag_log format ["Comparing %1 to %2",_cityName,_compareCityName];
   if (_compareCityName == _cityName) then
   {
	_found=true;
	_result=_city;
   };
  };
 _result
};


stwf_GenerateCitiesArray={
  	/*{	
 		_lctype=_x;
 		{	
 			STW_TOWNS pushBack [_lctype,text _x, locationPosition _x, direction _x, size _x, rectangular _x];
 		} forEach nearestLocations [getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition"), [_x], worldSize];	
 	} forEach [
	"NameLocal", 
	"NameVillage", 
	//"NameCity", 
	//"NameCityCapital",
	//"AirPort",
	"Hill",
	//"NameMarine",
	//"BorderCrossing",
	"Strategic",
	"StrongPointArea"];*/
	
	_center=[] call stwf_getCenterOfMap;
	STW_TOWNS=[_center,worldSize] call stwf_getNearbyStrategicalPointsOfInterest;
 	
	{
	  _zone=_x;
	  _name= _zone select 1;
	  _poi=["NameLocal",_name,_zone select 0] call stwf_generateCircularStrategicalPointOfInterestForRectangularZone;
	  STW_TOWNS pushBack _poi;
	  diag_log format ["Additional POI %1 added",_name];
	} forEach STWG_ADDITIONAL_STRATEGICAL_RECTANGULAR_AREAS;
	
 	/*diag_log format ["STW_TOWNS=["];
 	{
 		diag_log format ["%1,",_x];
 	} forEach STW_TOWNS;
 	diag_log format ["];"];*/
	STW_CITIES_MODULE_READY=true;
};

//[position2D,radius]
stwf_getAreaEnterableBuildings=
{
 _position2D=_this select 0;
 _radius=_this select 1;
 
 _buildings = nearestObjects [_position2D, ["Building","House"], _radius];
 _enterableBuildings=[];
 {
  _building=_x;
  _isEnterable=_building call BIS_fnc_isBuildingEnterable;
  if (_isEnterable) then 
  {
	_enterableBuildings pushBack _building;
  };
 } forEach _buildings;
 _enterableBuildings;
};


//[MarkerName,[MarkerSizeX,MarkerSizeY],position2D,color,alpha]
stwfGenerateMarkerForEOS=
{
	_markerName=_this select 0;
	_markerSize=_this select 1;
	_position2D=_this select 2;
	_color=_this select 3;
	_alpha=_this select 4;
	_mkr = createMarker[ _markerName,_position2D];
	_mkr setMarkerShape "ELLIPSE";
	_lw=(_markerSize select 0);
	_lh=(_markerSize select 1);
	_lradius=_lw;
	if (_lw>_lh) then { _lradius=_lw} else {_lradius=_lh};
	_lradius=STW_CITY_RADIUS_MULTIPLIER*_lradius;
	if (_lradius<100) then
	{
	 _lradius=100;
	 diag_log "STWEOS Area marker size forced to 100";
	};
	_mkr setMarkerSize [ _lradius, _lradius ];
	_mkr setMarkerColor _color;	
	_mkr setMarkerAlpha _alpha;
	_mkr;
};


stwf_GenerateCitiesEOSMarkers=
{
	//////////////////////// EOS ///////////////////
	_count=0;
	{
		_rnd=random 100;
		if (_rnd<STWG_PROBABILITY_OF_A_POI_TO_BE_CONFICT_ZONE) then
		{
		 
			_position2D = [(_x select 2) select 0,(_x select 2) select 1];
			_cityName= _x select 1;
			_citySize= (_x select 4);
			_zoneSide=EAST;
			_zoneColor="colorRed";
			_sideIdentifier=5; //5= Russian troops
			// fix city size for airports
			if  (
				(((toupper _cityName) find "AEROPUERTO")!=-1)||
				(((toupper _cityName) find "AIRPORT"   )!=-1)
				) then
			{
			  if ((_citySize select 0)<500) then
			  {
				diag_log "Patching airport size";
				_citySize=[1500,1500];
			  };
			};
			
			if ((STW_CONQUERED_CITIES find _cityName)>-1) then
			{
			 _zoneSide=WEST;
			 _zoneColor="colorGreen";
			 _sideIdentifier=8; // 6= Spanish Troops //8 NATO RHS
			};
			_markerName=format ["STWEOSCityMarker@%1@%2",_count,_cityName];
			_marker=[_markerName,_citySize,_position2D,_zoneColor,0.2] call stwfGenerateMarkerForEOS;
			_count=_count+1;
			_enterableBuildings=[_position2D,(_citySize select 0)*STW_CITY_RADIUS_MULTIPLIER] call stwf_getAreaEnterableBuildings;
			_nEnterableBuildings= count _enterableBuildings;
			diag_log format ["Enterable buildings count : %1",_nEnterableBuildings];
			_oneMan =0; _tinyGroup= 1;	_normalGroup=2;	_bigGroup=3; _largeGroup=4;	_hugeGroup=5;
			_lowProbability=20;	_medProbability=50;	_highProbability=80;
				
			_nHouseInspection=selectRandom [0,1,2,3]; //=ceil (_nEnterableBuildings);
			_nPatrols= 3;
			_nMotorized=1;
			_nArmoured=1;
			_nStaticWeapons=4;
			_nHelos=0;
			
			if (_zoneSide==EAST) then //RUSSIANS
			{
			 _nHouseInspection=selectRandom [2,2,2,3,4]; //ceil (_nEnterableBuildings/4);
			 _nPatrols=selectRandom [2,2,2,3,4];
			 _nMotorized=selectRandom [0,0,1,2];
			 _nArmoured=selectRandom [0,0,0,1,2];
			 _nStaticWeapons=selectRandom [0,1,2];
			 _nHelos=0;
			};
			
			if (_zoneSide==WEST) then //AMERICANS
			{
			 _nHouseInspection=selectRandom [1,2,3,4,5]; //ceil (_nEnterableBuildings/8);
			 _nPatrols=selectRandom [1,2,3,4,5];
			 _nMotorized=selectRandom [0,0,1,2];
			 _nArmoured=selectRandom [0,0,0,1,2];
			 _nStaticWeapons=selectRandom [0,1,2];
			 _nHelos=0;
			};
			
			/*
			if (_nHouseInspection<2) then
			{
			  _nHouseInspection=2;
			};
			if (_nHouseInspection>6) then
			{
			  _nHouseInspection=6;
			};
			
			*/
			//RUSSIAN TROOPS (5)
			// SPANISH TROOPS (6)
			// RHS NATO (8)
			//if (_zoneSide==EAST) then
			//{
			null = [[_markerName],
					/* house inspection */ [_nHouseInspection,_tinyGroup],
					/* patrols */ [_nPatrols,_tinyGroup],
					/* motorized */ [_nMotorized,_tinyGroup,_medProbability],
					/* armoured */ [_nArmoured,_oneMan,_lowProbability],
					/* static weapons */ [_nStaticWeapons,_tinyGroup],
					/* helicopters */ [_nHelos,_normalGroup,_lowProbability],
					/* Faction, marker type, distance, side, notactivated by fight,debug */ [_sideIdentifier,0,500,_zoneSide,FALSE,FALSE]] call EOS_Spawn;
			//};
			
			_roofTopSoldierType="rhsusf_army_ucp_sniper_m24sws"; //"ffaa_brilat_tirador";
			if (_zoneSide==EAST) then
			{
				_roofTopSoldierType="rhs_msv_marksman"
			};
			
			/*
			if (random 100>90) then
			{
				[_markerName, selectRandom [1,1,1,1,2,2,3], 1 , false, _roofTopSoldierType, _zoneSide] call gdsn_fnc_spawnRooftopStaticWeapons; //antiinfantry,antitank,antiair
			};
			*/
			if ((random 100)>80) then
			{
				[_markerName, 0, 3, false, _roofTopSoldierType, _zoneSide] call gdsn_fnc_spawnRooftopStaticWeapons; //snipers
			};
		}; //end of rnd 25	
	} forEach STW_TOWNS;
	//////////////////////////////////////////////
};



if ((isNil "STW_TOWNS")||((count STW_TOWNS)==0) ) then
{
	[] call stwf_GenerateCitiesArray;
	diag_log format ["STWG_EOS_CITIES_BOOL=%1",STWG_EOS_CITIES_BOOL];
	if (STWG_EOS_CITIES_BOOL) then
	{
		[] call stwf_GenerateCitiesEOSMarkers;
	};
};