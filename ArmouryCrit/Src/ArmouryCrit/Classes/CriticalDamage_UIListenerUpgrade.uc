//-----------------------------------------------------------
//	Class:	CriticalDamage_UIListenerUpgrade
//	Author: Mr. Nice
//	
//-----------------------------------------------------------

  
class CriticalDamage_UIListenerUpgrade extends UIScreenListener;

event OnInit(UIScreen Screen)
{
	local UIArmory_WeaponUpgrade UpgradeScreen;

	UpgradeScreen=UIArmory_WeaponUpgrade(Screen);
	UpgradeScreen.WeaponStats.Remove();
	UpgradeScreen.WeaponStats = UpgradeScreen.Spawn(class'UIArmory_WeaponUpgradeStatsCrit', UpgradeScreen).InitStats('weaponStatsMC', UpgradeScreen.WeaponRef);
	UpgradeScreen.WeaponStats.DisableNavigation(); 
}

defaultproperties
{
	//Mr Nice: ScreenClass set at runtime over in OPTC!
	ScreenClass=none;
}
