if (!isServer) exitWith {};
waitUntil {(count ([] call BIS_fnc_listPlayers))>0};
sleep 30;

diag_log "================ STW ANIMALS =================";

_astwAnimalGroups=[];
_istwTargetAnimalsCountParam=2;
_istwMinDist=450;
_istwMaxDist=800;	
_REFRESH_TIME=20;

_TERRESTRIAL_ANIMALS=[
//"Rabbit_F",	
//"Snake_random_F",	
"Hen_random_F",
"Cock_random_F",
"Cock_white_F",		
"Fin_sand_F	Dog",		
"Fin_blackwhite_F",		
"Fin_ocherwhite_F",
"Fin_tricolour_F",
"Fin_random_F",
"Alsatian_Sand_F",		
"Alsatian_Black_F",		
"Alsatian_Sandblack_F",		
"Alsatian_Random_F",			
"Goat_random_F",			
//"Sheep_random_F",
""
];

_AQUATIC_ANIMALS=[
//"Salema_F",
//"Mackerel_F",
"Tuna_F",
"Mullet_F",
"CatShark_F",
"feint_Shark",
"feint_Shark2",
"Turtle_F",
//"Ornate_random_F",
""
];


	
	_STWFRandomNum = {
		_min=_this select 0;
		_max=_this select 1;
		
		_rnd= random (_max-_min);
		_rnd= _rnd+_min; 
	  
		floor _rnd
	};
	
	
	
	while {true} do {
		while {(count allPlayers) ==0} do {sleep _REFRESH_TIME;};
		_randomPlayer=selectRandom allPlayers;
	
		_position=getPos _randomPlayer;
		
		_ispawnedAnimalCount=count _astwAnimalGroups;
		_retries=0;
		while {(_ispawnedAnimalCount<_istwTargetAnimalsCountParam)&&(_retries<5)} do
		{
			// Spawn at a random angle in a mindist
			_rndAngle=[0,360] call _STWFRandomNum;
			_xof= (_position select 0)+ (_istwMinDist*sin _rndAngle);
			_yof= (_position select 1)+ (_istwMinDist*cos _rndAngle);
			
			
			// Set a destination at a random angle in a mindist
			_v2DAnimalSpawnPoint=[ 
				_xof  , 
				_yof ];

			_rndAngle=[0,360] call _STWFRandomNum;
			_xdof= (_position select 0)+ (_istwMinDist*sin _rndAngle);
			_ydof= (_position select 1)+ (_istwMinDist*cos _rndAngle);
			
			_v2DAnimalDestinationPoint=[ 
				_xdof  , 
				_ydof ];

			if (
				(!surfaceIsWater [_xof,_yof])&&(!surfaceIsWater [_xdof,_ydof])
			)then
			{
			
				_stwAnimalGrp= createGroup civilian;
				_astwAnimals=[];
				_randomAnimal = selectRandom _TERRESTRIAL_ANIMALS;
				for "_i" from 0 to (random 5) do {
					_stwAnimal=_stwAnimalGrp createUnit [_randomAnimal,
										_v2DAnimalSpawnPoint,
										[], //Markers
										1, //howmany
										"NONE" //The unit will be created at the first available free position nearest to given position
										];
										
					_astwAnimals set [
								count _astwAnimals,
								 _stwAnimal
								];
					
					alive _stwAnimal;	
					diag_log "Land animal spawned";
				};
				
				_wpoint=_stwAnimalGrp addWaypoint [_v2DAnimalDestinationPoint, 0];	
				[_stwAnimalGrp,1] setWaypointStatements ["true", "if (!isServer) exitWith{}; nul =[this,'Terrestrial'] execVm 'a3_custom\STWAnimals\STWAnimalReachedWayPoint.sqf'"];
				_astwAnimalGroups pushBack _stwAnimalGrp;
				//diag_log format ["Animal Group added:"+_randomAnimal];
			} else //WATER ANIMALS
			{
			  _stwAnimalGrp= createGroup civilian;
				_astwAnimals=[];
				_randomAnimal = selectRandom _AQUATIC_ANIMALS;
				for "_i" from 0 to (random 5) do {
					_stwAnimal=_stwAnimalGrp createUnit [_randomAnimal,
										_v2DAnimalSpawnPoint,
										[], //Markers
										1, //howmany
										"NONE" //The unit will be created at the first available free position nearest to given position
										];
										
					_astwAnimals set [
								count _astwAnimals,
								 _stwAnimal
								];
					
					alive _stwAnimal;
					diag_log "Water animal spawned";					
				};
				
				_wpoint=_stwAnimalGrp addWaypoint [_v2DAnimalDestinationPoint, 0];	
				[_stwAnimalGrp,1] setWaypointStatements ["true", "if (!isServer) exitWith{}; nul =[this,'Aquatic'] execVm 'a3_custom\STWAnimals\STWAnimalReachedWayPoint.sqf'"];
				_astwAnimalGroups pushBack _stwAnimalGrp;
			};
			_ispawnedAnimalCount=count _astwAnimalGroups;
			_retries=_retries+1;
		};

	
		
		{
			if (count units _x >0) then 
			{
				_grpLeader=((units _x) select 0);			
				_distanceToPlayer = 2*_istwMaxDist;
				{
					_dist=_grpLeader distance2D _x;
					if (_dist<_distanceToPlayer) then
					{
					 _distanceToPlayer=_dist;
					};
				} forEach allPlayers;
				if (_distanceToPlayer>_istwMaxDist) then
				{
				 {deleteVehicle _x} forEach (units _x); 
				};
			};
			
			if (count units _x==0) then 
			{
			  deleteGroup _x;
			  _astwAnimalGroups set [_forEachIndex, objnull];
			};
			
		} foreach _astwAnimalGroups;
		
		while {objnull in _astwAnimalGroups} do
		{
			_astwAnimalGroups = _astwAnimalGroups - [objnull];
		};
		
		sleep _REFRESH_TIME;
	}; 



