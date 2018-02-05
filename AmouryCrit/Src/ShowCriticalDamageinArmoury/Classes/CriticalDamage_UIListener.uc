class CriticalDamage_UIListener extends UIScreenListener;

var delegate<UIArmory_LoadoutItemTooltip.OnRequestItem> OriginalRequestItem;

event OnInit(UIScreen Screen)
{
	local UIArmory_LoadoutItemTooltip ToolTip;
	local UIArmory_Loadout OverrideTestScreen;

	if (ScreenClass==none)
	{
		OverrideTestScreen = Screen.Spawn(class 'UIArmory_Loadout');
		ScreenClass=OverrideTestScreen.Class;
		OverrideTestScreen.Destroy();
		/*if (ScreenClass!=Screen.Class)*/ return;
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
	local XComGameState_Item	RealkItem;
	local XComGameState_ItemCrit FakekItem;
	RealkItem=OriginalRequestItem(currentPath);
	if (RealkItem==none)
		return RealkItem;
	FakekItem=new class 'XComGameState_ItemCrit';
	FakekItem.RealkItem=RealkItem;
	FakekItem.OnCreation(RealkItem.GetMyTemplate());
	return FakekItem;
}

defaultproperties
{
	ScreenClass=none;
}