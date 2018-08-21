//-----------------------------------------------------------
//	Class:	CriticalDamage_UIListenerUpgrade
//	Author: Mr. Nice
//	
//-----------------------------------------------------------

  
class CriticalDamage_UIListenerUpgrade extends UIScreenListener;

event OnInit(UIScreen Screen)
{
	local UIArmory_WeaponUpgrade UpgradeScreen;

	if (ScreenClass==none)
	{
		//UpgradeScreen = Screen.Spawn(class 'UIArmory_WeaponUpgrade');
		//ScreenClass=UpgradeScreen.Class;
		//UpgradeScreen.Destroy();
		ScreenClass=class'UIArmory_WeaponUpgrade';
		/*if (ScreenClass!=Screen.Class)*/ return;
	}
	UpgradeScreen=UIArmory_WeaponUpgrade(Screen);
	UpgradeScreen.WeaponStats.Remove();
	UpgradeScreen.WeaponStats = UpgradeScreen.Spawn(class'UIArmory_WeaponUpgradeStatsCrit', UpgradeScreen).InitStats('weaponStatsMC', UpgradeScreen.WeaponRef);
	UpgradeScreen.WeaponStats.DisableNavigation(); 
}

defaultproperties
{
	ScreenClass=none;
}
