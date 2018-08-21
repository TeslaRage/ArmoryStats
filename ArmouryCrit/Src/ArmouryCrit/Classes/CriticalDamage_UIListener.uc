class CriticalDamage_UIListener extends UIScreenListener;

var delegate<UIArmory_LoadoutItemTooltip.OnRequestItem> OriginalRequestItem;

event OnInit(UIScreen Screen)
{
	local UIArmory_LoadoutItemTooltip ToolTip;

	if (ScreenClass==none)
	{
		ScreenClass=class'UIArmory_Loadout';
		return;
	}
	ToolTip=UIArmory_Loadout(Screen).InfoTooltip;
	OriginalRequestItem=ToolTip.RequestItem;
	ToolTip.RequestItem=TooltipRequestSwitch;
}

event OnRemoved(UIScreen Screen)
{
	OriginalRequestItem=none;
}

simulated function XComGameState_Item TooltipRequestSwitch( string currentPath )
{
	return class'XComGameState_ItemCrit'.static.CreateProxy(OriginalRequestItem(currentPath));
}

defaultproperties
{
	ScreenClass=none;
}