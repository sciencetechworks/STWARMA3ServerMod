_eosMarkers=server getvariable "EOSmarkers";

if (!isNil "_eosMarkers") then
{
	{_x setMarkerAlpha (MarkerAlpha _x);
	_x setMarkercolor (getMarkercolor _x);
	}foreach _eosMarkers;
};