class CriticalDamage_UIListener extends UIScreenListener;

var delegate<UIArmory_LoadoutItemTooltip.OnRequestItem> OriginalRequestItem;
var UIArmory_Loadout LoadOutScreen;

event OnInit(UIScreen Screen)
{
	local UIArmory_LoadoutItemTooltip ToolTip;

	LoadOutScreen=UIArmory_Loadout(Screen);
	ToolTip=LoadOutScreen.InfoTooltip;
	OriginalRequestItem=ToolTip.RequestItem;
	ToolTip.RequestItem=TooltipRequestSwitch;
}

event OnRemoved(UIScreen Screen)
{
	OriginalRequestItem=none;
	LoadOutScreen=none;
}

simulated function XComGameState_Item TooltipRequestSwitch( string currentPath )
{
	return class'XComGameState_ItemCrit'.static.CreateProxy(OriginalRequestItem(currentPath), LoadOutScreen.GetUnitRef());
}

defaultproperties
{
	//Mr Nice: ScreenClass set at runtime over in OPTC!
	ScreenClass=none;
}