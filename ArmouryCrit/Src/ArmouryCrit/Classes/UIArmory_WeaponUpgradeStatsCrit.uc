//-----------------------------------------------------------
//	Class:	UIArmory_WeaponUpgradeStatsCrit
//	Author: Mr. Nice
//	
//-----------------------------------------------------------


class UIArmory_WeaponUpgradeStatsCrit extends UIArmory_WeaponUpgradeStats;

simulated function PopulateData(XComGameState_Item Weapon, optional X2WeaponUpgradeTemplate UpgradeTemplate)
{
	Super.PopulateData(class'XComGameState_ItemCrit'.static.CreateProxy(Weapon), UpgradeTemplate);
}


