//-----------------------------------------------------------
//	Class:	ArmouryCrit_MCMScreen
//	Author: Mr. Nice
//	
//-----------------------------------------------------------


class ArmouryCrit_MCMScreen extends Object config(ArmouryCrit);

var config int VERSION_CFG;

var localized string ModName;
var localized string PageTitle;
var localized string GroupHeader;

`include(ArmouryCrit\Src\ModConfigMenuAPI\MCM_API_Includes.uci)

/***************************************
Insert `MCM_API_Auto????Vars macros here
***************************************/
`MCM_API_AutoCheckBoxVars(SHREDDER_AS_BONUS);

`include(ArmouryCrit\Src\ModConfigMenuAPI\MCM_API_CfgHelpers.uci)

/********************************************************************
Insert `MCM_API_Auto????Fns and MCM_API_AutoButtonHandler macros here
********************************************************************/
`MCM_API_AutoCheckBoxFns(SHREDDER_AS_BONUS);

event OnInit(UIScreen Screen)
{
	`MCM_API_Register(Screen, ClientModCallback);
}

//Simple one group framework code
simulated function ClientModCallback(MCM_API_Instance ConfigAPI, int GameMode)
{
	local MCM_API_SettingsPage Page;
	local MCM_API_SettingsGroup Group;

	LoadSavedSettings();
	Page = ConfigAPI.NewSettingsPage(ModName);
	Page.SetPageTitle(PageTitle);
	Page.SetSaveHandler(SaveButtonClicked);
	
	//Uncomment to enable reset
	Page.EnableResetButton(ResetButtonClicked);

	Group = Page.AddGroup('Group', GroupHeader);
/********************************************************
	MCM_API_AutoAdd??????? Macro's go here
********************************************************/
	`MCM_API_AutoAddCheckBox(Group, SHREDDER_AS_BONUS);

	Page.ShowSettings();
}

simulated function LoadSavedSettings()
{
/************************************************************************
	Use GETMCMVAR macro to assign values to the config variables here
************************************************************************/
	SHREDDER_AS_BONUS=`GETMCMVAR(SHREDDER_AS_BONUS);
}

simulated function ResetButtonClicked(MCM_API_SettingsPage Page)
{
/********************************************************
	MCM_API_AutoReset macros go here
********************************************************/
	`MCM_API_AutoReset(SHREDDER_AS_BONUS);
}


simulated function SaveButtonClicked(MCM_API_SettingsPage Page)
{
	VERSION_CFG = `MCM_CH_GetCompositeVersion();
	SaveConfig();
}


