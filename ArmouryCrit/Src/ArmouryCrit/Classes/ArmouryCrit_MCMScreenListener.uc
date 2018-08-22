//-----------------------------------------------------------
//	Class:	ArmouryCrit_MCMScreenListener
//	Author: Mr. Nice
//	
//-----------------------------------------------------------

class ArmouryCrit_MCMScreenListener extends UIScreenListener;

event OnInit(UIScreen Screen)
{
	local ArmouryCrit_MCMScreen MCMScreen;

	if (ScreenClass==none)
	{
		if (MCM_API(Screen) != none)
			ScreenClass=Screen.Class;
		else return;
	}

	MCMScreen = new class'ArmouryCrit_MCMScreen';
	MCMScreen.OnInit(Screen);
}

defaultproperties
{
    ScreenClass = none;
}
