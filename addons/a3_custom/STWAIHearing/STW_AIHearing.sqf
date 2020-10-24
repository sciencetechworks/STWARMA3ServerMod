"STWBroadcastAIHearing" addPublicVariableEventHandler 
{
	_stwf_aiListening=
		{
			_player=_this;
			
			if (alive _player) then
			{
				_msg=format ["SERVER: %1 is making noises.", _player];
				diag_log _msg;
				_hearingProbability=10; //percent
				_maxHearingRange=40;
				_listeningEntities = _player nearEntities ["Man", _maxHearingRange];
				{
					_listener=_x;
					if (_listener != _player) then
					{
						_distance=_listener distance _player;
						//luck is inversely proportional to a distance of _maxHearingRange meters
						if (_distance<2) then
						{
							_hearingProbability=100;
						} else
						{
							//y=m+100; _maxHearingRange meters=0, 0 meters = 100;
							_m=-100/_maxHearingRange;
							_hearingProbability=(round (_m*_distance))+100;
						};
						_luck=random 100;
						//_msg = format ["distance: %1, probability: %2 ,luck: %3",_distance,_hearingProbability,_luck];
						diag_log _msg;
						if (_luck<=_hearingProbability) then
						{
						  _msg=format ["%1 heard %2",name _x ,_player];
						  diag_log _msg;
						  _x reveal _player;
						};
					};
				} forEach _listeningEntities;	
			};
		};

	_broadcastVarName = _this select 0;
    _broadcastVarValue = _this select 1;
	
    _talkingPlayer = _broadcastVarValue;
	diag_log format ["Server variable received: Player %1 is making Noises.", _talkingPlayer];
    _talkingPlayer call _stwf_aiListening;
};
diag_log "///////////////STW: THE SERVER IS LISTENING TO PLAYER NOISES!/////////////////////////";
