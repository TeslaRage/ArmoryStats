//---------------------------------------------------------------------------------------
//  CLASS:   XComDownloadableContentInfo_ArmouryCrit                       
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_ArmouryCrit extends X2DownloadableContentInfo;

var array<X2Action> ExecutingActions;
/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
//static event OnLoadedSavedGame()
//{

//}

/// <summary>
/// This method is run when the player loads a saved game directly into Strategy while this DLC is installed
/// </summary>
//static event OnLoadedSavedGameToStrategy()
//{

//}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed. When a new campaign is started the initial state of the world
/// is contained in a strategy start state. Never add additional history frames inside of InstallNewCampaign, add new state objects to the start state
/// or directly modify start state objects
/// </summary>
//static event InstallNewCampaign(XComGameState StartState)
//{

//}

/// <summary>
/// Called just before the player launches into a tactical a mission while this DLC / Mod is installed.
/// Allows dlcs/mods to modify the start state before launching into the mission
/// </summary>
//static event OnPreMission(XComGameState StartGameState, XComGameState_MissionSite MissionState)
//{

//}

/// <summary>
/// Called when the player completes a mission while this DLC / Mod is installed.
/// </summary>
//static event OnPostMission()
//{

//}

/// <summary>
/// Called when the player is doing a direct tactical->tactical mission transfer. Allows mods to modify the
/// start state of the new transfer mission if needed
/// </summary>
//static event ModifyTacticalTransferStartState(XComGameState TransferStartState)
//{

//}

/// <summary>
/// Called after the player exits the post-mission sequence while this DLC / Mod is installed.
/// </summary>
//static event OnExitPostMissionSequence()
//{

//}

/// <summary>
/// Called after the Templates have been created (but before they are validated) while this DLC / Mod is installed.
/// </summary>
//static event OnPostTemplatesCreated()
//{

//}

/// <summary>
/// Called when the difficulty changes and this DLC is active
/// </summary>
//static event OnDifficultyChanged()
//{

//}

/// <summary>
/// Called by the Geoscape tick
/// </summary>
//static event UpdateDLC()
//{

//}

/// <summary>
/// Called after HeadquartersAlien builds a Facility
/// </summary>
//static event OnPostAlienFacilityCreated(XComGameState NewGameState, StateObjectReference MissionRef)
//{

//}

/// <summary>
/// Called after a new Alien Facility's doom generation display is completed
/// </summary>
//static event OnPostFacilityDoomVisualization()
//{

//}

/// <summary>
/// Called when viewing mission blades with the Shadow Chamber panel, used primarily to modify tactical tags for spawning
/// Returns true when the mission's spawning info needs to be updated
/// </summary>
//static function bool UpdateShadowChamberMissionInfo(StateObjectReference MissionRef)
//{
//	return false;
//}

/// <summary>
/// A dialogue popup used for players to confirm or deny whether new gameplay content should be installed for this DLC / Mod.
/// </summary>
//static function EnableDLCContentPopup()
//{
//	local TDialogueBoxData kDialogData;

//	kDialogData.eType = eDialog_Normal;
//	kDialogData.strTitle = default.EnableContentLabel;
//	kDialogData.strText = default.EnableContentSummary;
//	kDialogData.strAccept = default.EnableContentAcceptLabel;
//	kDialogData.strCancel = default.EnableContentCancelLabel;

//	kDialogData.fnCallback = EnableDLCContentPopupCallback_Ex;
//	`HQPRES.UIRaiseDialog(kDialogData);
//}

//simulated function EnableDLCContentPopupCallback(eUIAction eAction)
//{
//}

//simulated function EnableDLCContentPopupCallback_Ex(Name eAction)
//{	
//	switch (eAction)
//	{
//	case 'eUIAction_Accept':
//		EnableDLCContentPopupCallback(eUIAction_Accept);
//		break;
//	case 'eUIAction_Cancel':
//		EnableDLCContentPopupCallback(eUIAction_Cancel);
//		break;
//	case 'eUIAction_Closed':
//		EnableDLCContentPopupCallback(eUIAction_Closed);
//		break;
//	}
//}

/// <summary>
/// Called when viewing mission blades, used primarily to modify tactical tags for spawning
/// Returns true when the mission's spawning info needs to be updated
/// </summary>
//static function bool ShouldUpdateMissionSpawningInfo(StateObjectReference MissionRef)
//{
//	return false;
//}

/// <summary>
/// Called when viewing mission blades, used primarily to modify tactical tags for spawning
/// Returns true when the mission's spawning info needs to be updated
/// </summary>
//static function bool UpdateMissionSpawningInfo(StateObjectReference MissionRef)
//{
//	return false;
//}

/// <summary>
/// Called when viewing mission blades, used to add any additional text to the mission description
/// </summary>
//static function string GetAdditionalMissionDesc(StateObjectReference MissionRef)
//{
//	return "";
//}

/// <summary>
/// Called from X2AbilityTag:ExpandHandler after processing the base game tags. Return true (and fill OutString correctly)
/// to indicate the tag has been expanded properly and no further processing is needed.
/// </summary>
//static function bool AbilityTagExpandHandler(string InString, out string OutString)
//{
//	return false;
//}

/// <summary>
/// Called from XComGameState_Unit:GatherUnitAbilitiesForInit after the game has built what it believes is the full list of
/// abilities for the unit based on character, class, equipment, et cetera. You can add or remove abilities in SetupData.
/// </summary>
//static function FinalizeUnitAbilitiesForInit(XComGameState_Unit UnitState, out array<AbilitySetupData> SetupData, optional XComGameState StartState, optional XComGameState_Player PlayerState, optional bool bMultiplayerDisplay)
//{
//
//}

/// <summary>
/// Calls DLC specific popup handlers to route messages to correct display functions
/// </summary>
//static function bool DisplayQueuedDynamicPopup(DynamicPropertySet PropertySet)
//{

//}

exec function CompleteAllActions()
{
	local XComGameStateVisualizationMgr VisMgr;
	local X2Action Action;

	ExecutingActions.Length=0;
	VisMgr=`XCOMVISUALIZATIONMGR;
	foreach VisMgr.AllActors(class'X2Action', Action)
			Action.ForceComplete();
}

exec function CompleteExecutingActions()
{
	local XComGameStateVisualizationMgr VisMgr;
	local X2Action Action;
	local int pass;
	local Console PlayerConsole;

	PlayerConsole=LocalPlayer(`LOCALPLAYERCONTROLLER.Player).ViewportClient.ViewportConsole;
	VisMgr=`XCOMVISUALIZATIONMGR;
	for(pass=0;ExecutingActions.Length==0 || pass==0;pass++)
	{
		PlayerConsole.OutputTextLine(`showvar(pass));
		//`log(`showvar(pass));
 		foreach ExecutingActions(Action)
		{
			PlayerConsole.OutputTextLine(`showvar(Action));
			//`log(`showvar(Action));
			Action.ForceComplete();
		}
		ExecutingActions.Length=0;
		foreach VisMgr.AllActors(class'X2Action', Action)
			if(Action.GetStateName()=='Executing')
			{
				PlayerConsole.OutputTextLine(`showvar(Action));
				//`log(`showvar(Action));
				ExecutingActions.AddItem(Action);
			}
	}
}

exec function LogExecutingActions()
{
	local XComGameStateVisualizationMgr VisMgr;
	local X2Action Action;
	local int pass;
	local Console PlayerConsole;

	PlayerConsole=LocalPlayer(`LOCALPLAYERCONTROLLER.Player).ViewportClient.ViewportConsole;
	VisMgr=`XCOMVISUALIZATIONMGR;
	ExecutingActions.Length=0;
	foreach VisMgr.AllActors(class'X2Action', Action)
		if(Action.GetStateName()=='Executing')
		{
			//`log(ExecutingActions.Length @ `showvar(Action));
			PlayerConsole.OutputTextLine(ExecutingActions.Length $ ": " $ Action);
			ExecutingActions.AddItem(Action);
		}
		If (ExecutingActions.Length==0)
			PlayerConsole.OutputTextLine("No Executing Actions!");
}

exec function ClearExecutingActionsList()
{
	ExecutingActions.Length=0;
}

exec function ExecutingActionsList()
{
	local int i;
	local Console PlayerConsole;

	PlayerConsole=LocalPlayer(`LOCALPLAYERCONTROLLER.Player).ViewportClient.ViewportConsole;
	for(i=0;i<ExecutingActions.Length;i++)
		PlayerConsole.OutputTextLine(i $ ": " $ ExecutingActions[i]);
	
}

exec function CompleteAction(optional int i=0)
{
	ExecutingActions[i].ForceComplete();
	ExecutingActions.Remove(i, 1);
	ExecutingActionsList();
}

exec function HealUnit()
{
	local XComGameState_Effect EffectState;
	local X2Effect_Persistent PersistentEffect;
	local XComGameState_Unit Unit;
	local XComGameState NewGameState;
	
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Heal Unit");

	Unit = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', `CHEATMGR.Outer.GetActiveUnitStateRef().ObjectID));
	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Effect', EffectState)
	{
		if ((EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID == Unit.ObjectID))
		{
			PersistentEffect = EffectState.GetX2Effect();
			if (ShouldRemoveEffect(EffectState, PersistentEffect))
			{
				EffectState.RemoveEffect(NewGameState, NewGameState, true);
			}
		}
	}
	`TACTICALRULES.SubmitGameState(NewGameState);
}

simulated function bool ShouldRemoveEffect(XComGameState_Effect EffectState, X2Effect_Persistent PersistentEffect)
{
	local name DamageType;

	foreach PersistentEffect.DamageTypes(DamageType)
	{
		if (class'X2Ability_DefaultAbilitySet'.default.MedikitHealEffectTypes.Find(DamageType) != INDEX_NONE)
			return true;
	}
	return false;
}