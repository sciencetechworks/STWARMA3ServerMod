/*
	Name: Rooftop Static Weapons Script
	Author: MisterGoodson (aka Goodson)
	Version: 1.0
	
	Description:
		As the name suggests, this script will take a given area (defined by a marker) and spawn static weapons (such as DShKMs or KORDs) on rooftops.
		Taking inspiration from Insurgency for Arma 2, rooftop static weapons add much more variation to battles and make jobs harder for both infantry and air support.
	
	How it Works:
		When called, the script will first scan a given area for enterable buildings. Positions within each building will then be identified.
		Since there is no command for finding rooftops, this has to be done manually by checking for obstructions above each position and deciding whether or not it is a
		rooftop. A final check is then performed to ensure that there is enough room for the static weapon to spawn and that the rooftop
		position is not obstructed by any nearby walls or other solid objects that may prevent the weapon from manoeuvring properly
	
	How to Use:
		1. Within your mission, create an ellipse marker (this will define the area that you wish to place static weapons) and give it a name (e.g. "m1").
		2. Place down a "Game Logic" unit and put the following in the unit's init field:

		["m1", 1, 5, false, "CAF_AG_ME_T_RPK74", east] call gdsn_fnc_spawnRooftopStaticWeapons;
		
		Parameter 1: Name of marker (e.g. "m1").
		Parameter 2: Type of weapon placement. 1 = Light (Anti-infantry), 2 = Medium (AT), 3 = Heavy (AA).
		Parameter 3: Number of static weapons to spawn.
		Parameter 4: Delete marker after use.
		Parameter 5: Classname of gunner unit.
		Parameter 5: Side of gunner (east, west, resistance).
*/

// Run on server only
if (!isServer) exitWith {};

// Get arguments
_marker = _this select 0;
_type = _this select 1;
_amount = _this select 2;
_deleteMarker = _this select 3;
_unit = _this select 4;
_side = _this select 5;

// Assign variables
_area = getMarkerSize _marker; // Get area under marker
_legalRooftops = [];
_oca = 0; // Obstruction clear area
_debug = false;
if (isNil "gdsn_rooftopPositionsUsed") then {gdsn_rooftopPositionsUsed = []};

// Define weapon placement types
_justAnSniper=false;
_light = ["rhs_Metis_9k115_2_vmf",
		"rhs_Kornet_9M133_2_vmf","RHS_AGS30_TriPod_VMF",
		"rhs_KORD_VMF"];
_medium = ["rhs_KORD_high_VMF",
		"RHS_NSV_TriPod_VMF",
		"rhs_SPG9M_VMF"];
_heavy = ["rhs_Igla_AA_pod_vmf"];


// Identify which weapon type to use
switch (_type) do {
	case 0:
	{
		// RDT: Sniper
		_justAnSniper=true;
		_oca = 1.5; // Obstruction check area
	};
	case 1: // AP
	{
		_type = _light;
		_oca = 1.5; // Obstruction check area
	};
	case 2: // AT
	{
		_type = _medium;
		_oca = 1.5; // Obstruction check area
	};
	case 3: // AA
	{
		_type = _heavy;
		_oca = 2.5; // Obstruction check area
	};
};

_radius=(_area select 0)*8;
_buildings = nearestObjects [getMarkerPos _marker, ["house"], _radius];

if (_debug) then {
	systemChat format["Buildings found: %1", count(_buildings)];
} else {
	if (_deleteMarker) then {
		deleteMarker _marker;
	};
};

{
	_buildingPositions = [_x] call BIS_fnc_buildingPositions;
	if ((count _buildingPositions) > 0) then {
		
		// Find highest point in building (z-axis)
		/*
		_highestPoint = (_buildingPositions select 0) select 2;
		_highestPointXYZ = (_buildingPositions select 0);
		{
			if ((_x select 2) > _highestPoint) then {
				_highestPoint = (_x select 2);
				_highestPointXYZ = _x;
			};
		} forEach _buildingPositions;
		*/
		
		{
			// Check if building pos is high enough to be a weapon position (also filters out ground-floor positions such as doorways)
			_isHighPoint = ((_x select 2) > 4); //RDT: IT WAS 3
			
			if (_isHighPoint) then {
				// Check if building pos is a rooftop
				_buildingPositionASL = ATLtoASL(_x);
				_isObstructedZ = lineIntersects [_buildingPositionASL, [(_buildingPositionASL select 0), (_buildingPositionASL select 1), (_buildingPositionASL select 2) + 20]];
				
				if (!_isObstructedZ) then {
					// Check if area is free from obstruction in X & Y space
					_isObstructedX = lineIntersects [[(_buildingPositionASL select 0) - _oca, (_buildingPositionASL select 1), (_buildingPositionASL select 2)], [(_buildingPositionASL select 0) + _oca, (_buildingPositionASL select 1), (_buildingPositionASL select 2)]];
					_isObstructedY = lineIntersects [[(_buildingPositionASL select 0), (_buildingPositionASL select 1) - _oca, (_buildingPositionASL select 2)], [(_buildingPositionASL select 0), (_buildingPositionASL select 1) + _oca, (_buildingPositionASL select 2)]];
					
					if (!_isObstructedX && !_isObstructedY) then {
						// Perform final check that makes sure the surrounding area has a surface below it (i.e. not a very small point on top of the building)
						// Checks area below obstruction checkers to ensure they have a surface below them
						_hasSurfaceBelowXa = lineIntersects [[(_buildingPositionASL select 0) - _oca, (_buildingPositionASL select 1), (_buildingPositionASL select 2)], [(_buildingPositionASL select 0) - _oca, (_buildingPositionASL select 1), (_buildingPositionASL select 2) - 0.5]];
						_hasSurfaceBelowXb = lineIntersects [[(_buildingPositionASL select 0) + _oca, (_buildingPositionASL select 1), (_buildingPositionASL select 2)], [(_buildingPositionASL select 0) + _oca, (_buildingPositionASL select 1), (_buildingPositionASL select 2) - 0.5]];
						_hasSurfaceBelowYa = lineIntersects [[(_buildingPositionASL select 0), (_buildingPositionASL select 1) - _oca, (_buildingPositionASL select 2)], [(_buildingPositionASL select 0), (_buildingPositionASL select 1) - _oca, (_buildingPositionASL select 2) - 0.5]];
						_hasSurfaceBelowYb = lineIntersects [[(_buildingPositionASL select 0), (_buildingPositionASL select 1) + _oca, (_buildingPositionASL select 2)], [(_buildingPositionASL select 0), (_buildingPositionASL select 1) + _oca, (_buildingPositionASL select 2) - 0.5]];
						
						if ((_hasSurfaceBelowXa && _hasSurfaceBelowXb) && (_hasSurfaceBelowYa && _hasSurfaceBelowYb)) then {
							_legalRooftops = _legalRooftops + [_x];
							
							if (_debug) then {
								// Create marker of possible weapon placement
								_dummy = createVehicle ["Sign_Sphere25cm_F", _x, [], 0, "NONE"];
								_dummy setPosATL _x;
								
								// Create markers that show obstruction check area
								_dummyX = createVehicle ["Sign_Sphere10cm_F", [0,0,0], [], 0, "NONE"];
								_dummyX setPosATL [(_x select 0) - _oca, (_x select 1), (_x select 2)];
								_dummyX = createVehicle ["Sign_Sphere10cm_F", [0,0,0], [], 0, "NONE"];
								_dummyX setPosATL [(_x select 0) + _oca, (_x select 1), (_x select 2)];
								_dummyY = createVehicle ["Sign_Sphere10cm_F", [0,0,0], [], 0, "NONE"];
								_dummyY setPosATL [(_x select 0), (_x select 1) - _oca, (_x select 2)];
								_dummyY = createVehicle ["Sign_Sphere10cm_F", [0,0,0], [], 0, "NONE"];
								_dummyY setPosATL [(_x select 0), (_x select 1) + _oca, (_x select 2)];
							
								_debugMarker = createMarker [str(_x), _x];
								_debugMarker setMarkerShape "ICON";
								_debugMarker setMarkerType "mil_dot";
								_debugMarker setMarkerColor "ColorRed";
							};
						};
					};
				};
			};
		} forEach _buildingPositions;
	};
} forEach _buildings;

// Exit if no legal rooftops found
if ((count _legalRooftops) < 1) exitWith {};

// If requested number of weapon placements is higher than positions available, set _amount to the max available
if (_amount > (count _legalRooftops)) then {
	_amount = (count _legalRooftops);
};

if (_debug) then {
	systemChat format["Viable rooftops founds: %1", count(_legalRooftops)];
};

for "_x" from 1 to _amount do {
	// Select a legal rooftop at random
	_rooftopPos = _legalRooftops call BIS_fnc_selectRandom;
	
	if (_rooftopPos in gdsn_rooftopPositionsUsed) then {
		// Keep selecting rooftop positions at until an unused one has been found
		// If no unused positions can be found, skip creating the weapon
		for "_x" from 0 to ((count _legalRooftops) - 1) do {
			_rooftopPos = _legalRooftops select _x;
			if !(_rooftopPos in gdsn_rooftopPositionsUsed) exitWith {};
		};
	};
	
	if !(_rooftopPos in gdsn_rooftopPositionsUsed) then {
		gdsn_rooftopPositionsUsed = gdsn_rooftopPositionsUsed + [_rooftopPos];

		_gunnerPos= _rooftopPos;
		// Create gunner
		_group = createGroup _side;
		_gunner = _group createUnit [_unit, _gunnerPos, [], 0, "NONE"];
		
		if (!_justAnSniper) then
		{
			// Create weapon
			_staticWeapon = createVehicle [(_type call BIS_fnc_selectRandom), _rooftopPos, [], 0, "NONE"];
			_staticWeapon setPosATL _rooftopPos;
			_staticWeapon setVectorUp [0,0,1];
			_gunner moveInGunner _staticWeapon;
		} else
		{
			_gunner forceSpeed 0;
		};
		
		if (_debug) then {
			_debugMarker = createMarker [str(_staticWeapon), (getPosATL _staticWeapon)];
			_debugMarker setMarkerShape "ICON";
			_debugMarker setMarkerType "mil_dot";
			_debugMarker setMarkerColor "ColorGreen";
		};
	};
};

if (_debug) then {
	systemChat "Done";
};