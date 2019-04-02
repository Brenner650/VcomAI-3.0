
/*
	Author: Genesis

	Description:
		This function will determine if an group is low on ammo and needs to re-arm.

	Parameter(s):
		0: GROUP - Group to check ammo

	Returns:
		NOTHING
*/

private _magLimit = VCM_MAGLIMIT;

{
	private _orgUnit = _x;
	if !(isNull objectParent _x) exitWith {};

	//The first thing we want to do. Is figure out what ammo this unit is using.
	private _curMag = currentMagazine _x;

	//Now, we want to compare this classname to all the other ammo classnames this unit may have and count the number.
	private _mags = magazines _x;

	//Count the total number of mags.
	private _magCount = {_x isEqualTo _curMag}count _mags;

	//If unit has less than the wanted limit, then make the unit find ammo!
	if (_magCount < _magLimit) then {
		//Find closest men!
		_potRearm = _x nearEntities [["WeaponHolderSimulated", "Man", "Air", "Car", "Motorcycle", "Tank"], 50];
		_potRearm = _potRearm - [_x];
		{
			if (alive _x && {_x isKindOf "Man"}) then 
			{
				_potRearm = _potRearm - [_x];
			};
		} forEach _potRearm;
		
		//If men are around see if we can take ammo from them first.
		_stop = false;
		if (count _potRearm > 0) then {
			{
				_mags = [];
				_unit = _x;
				
				if (_unit isKindOf "Man") then {
					_mags = magazines _unit;
				}
				else
				{
					_mags = magazineCargo _unit;
				};
				
				if (isNil "_mags") then {_mags = [];};
				
				{
					if (_x isEqualTo _curMag) exitwith {
						[_orgUnit,_unit] spawn VCM_fnc_ActRearm; 
						_stop = true;
					};
				} forEach _mags;
				
				if (_stop) exitwith {};
				
			} forEach _potRearm;
		};
	};
} forEach (units _this);