//-----------------------------------------------------------
//	Class:	XComGameState_AbilityCrit
//	Author: Mr. Nice
//	
//-----------------------------------------------------------


class XComGameState_AbilityCrit extends XComGameState_Ability;

var XComGameState_ItemCrit ProxyWeapon;

simulated function XComGameState_Item GetSourceWeapon()
{
	if(SourceWeapon.ObjectID>0)
		return Super.GetSourceWeapon();
	return ProxyWeapon;
}