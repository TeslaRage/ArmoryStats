class XComGameState_ItemCrit extends XComGameState_Item;

var XComGameState_Item RealkItem;

var string StatsSuffix[ECharStatType.EnumCount];
var int iArmourStats[ECharStatType.EnumCount];

simulated function X2ItemTemplate GetMyTemplate()
{
	local X2CritItemTemplate FakeTemplate;
	FakeTemplate=new class'X2CritItemTemplate';
	FakeTemplate.RealTemplate= m_ItemTemplate;
	FakeTemplate.ObjectID=RealkItem.ObjectID;
	return FakeTemplate;
}
simulated function array<UISummary_TacaticalText> GetUISummary_TacticalText()
{
	return RealkItem.GetUISummary_TacticalText();
}

simulated function array<UISummary_TacaticalText> GetUISummary_TacticalTextUpgrades()
{
	return RealkItem.GetUISummary_TacticalTextUpgrades();
}
simulated function array<UISummary_TacaticalText> GetUISummary_TacticalTextAbilities()
{
	return RealkItem.GetUISummary_TacticalTextAbilities();
}

simulated function array<UISummary_ItemStat> GetUISummary_DefaultStats()
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Tech BreakthroughTech;
	local X2AbilityTemplateManager AbilityTemplateMan;
	local StateObjectReference ObjectRef;
	local X2TechTemplate TechTemplate;
	local X2AbilityTemplate AbilityTemplate;
	local X2Effect TargetEffect;
	local X2Effect_PersistentStatChange StatChangeEffect;
	local array <StatChange> StatChanges;
	local StatChange Change, EmptyChange;
	local UIStatMarkup StatMarkup;
	local array<UISummary_ItemStat> Stats; 
	local UISummary_ItemStat Item; 
	local int i;
	local X2EquipmentTemplate EquipmentTemplate;
	local delegate<X2StrategyGameRulesetDataStructures.SpecialRequirementsDelegate> ShouldStatDisplayFn;
	local array<string> BonusLabels;

	EquipmentTemplate = X2EquipmentTemplate(m_ItemTemplate);

	if( EquipmentTemplate != None )
	{
		// Search XComHQ for any breakthrough techs which modify the stats on this item, and store those stat changes
		XComHQ = `XCOMHQ;
		if (XComHQ != none)
		{
			AbilityTemplateMan = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

			foreach XComHQ.TacticalTechBreakthroughs(ObjectRef)
			{
				BreakthroughTech = XComGameState_Tech(`XCOMHISTORY.GetGameStateForObjectID(ObjectRef.ObjectID));
				TechTemplate = BreakthroughTech.GetMyTemplate();

				if (TechTemplate.BreakthroughCondition != none && TechTemplate.BreakthroughCondition.MeetsCondition(RealkItem))
				{
					AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate(TechTemplate.RewardName);
					foreach AbilityTemplate.AbilityTargetEffects(TargetEffect)
					{
						StatChangeEffect = X2Effect_PersistentStatChange(TargetEffect);
						foreach StatChangeEffect.m_aStatChanges(Change)
						{
							if (Change.ModOp!=MODOP_Addition) continue;
							i=StatChanges.Find('StatType', Change.StatType);
							if (i!=INDEX_NONE)
								StatChanges[i].StatAmount += Change.StatAmount;
							else StatChanges.AddItem(Change);
						}
					}
				}
			}
		}
	
		BonusLabels.AddItem(class'XLocalizedData'.default.CriticalDamageLabel);
		BonusLabels.AddItem(class'XLocalizedData'.default.GrenadeRangeBonusLabel);
		BonusLabels.AddItem(class'XLocalizedData'.default.GrenadeRadiusBonusLabel);

		foreach   EquipmentTemplate.UIStatMarkups(StatMarkUp)
		{
			ShouldStatDisplayFn = StatMarkUp.ShouldStatDisplayFn;
			if (ShouldStatDisplayFn != None && !ShouldStatDisplayFn())
			{
				continue;
			}
			
			// Start with the value from the stat markup
			Item.Label = StatMarkup.StatLabel;
			Item.Value=StatMarkup.StatUnit;
			i=StatChanges.Find('StatType', StatMarkup.StatType);
			if (i!=INDEX_NONE) Change=StatChanges[i];
			else Change=EmptyChange;
			If (Item.Value=="") Item.Value=StatsSuffix[StatMarkup.StatType];
			if ( 
					BonusLabels.Find(Item.Label)!=INDEX_NONE
					|| m_ItemTemplate.IsA('X2AmmoTemplate')
					|| StatMarkup.StatType!=eStat_Invalid
					&& !(m_ItemTemplate.IsA('X2ArmorTemplate') && bool(iArmourStats[StatMarkup.StatType]))
				)
				Item.ValueState=eUIState_Good;
			// Then check all of the stat change effects from techs and add any appropriate modifiers
			if (PopulateWeaponStat(StatMarkup.StatModifier, Change.StatAmount>0, Change.StatAmount, Item) || StatMarkup.bForceShow)
				Stats.AddItem(Item);
		}
	}

	return Stats; 
}

simulated function array<UISummary_ItemStat> GetUISummary_WeaponStats(optional X2WeaponUpgradeTemplate PreviewUpgradeStats)
{
	//local XComGameState_Item RealkItem;
	local array<UISummary_ItemStat> Stats; 
	local UISummary_ItemStat		Item;
	local UIStatMarkup				StatMarkup;
	local WeaponDamageValue         DamageValue;
	local EUISummary_WeaponStats    UpgradeStats;
	local X2WeaponTemplate WeaponTemplate;
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityTemplateManager AbilityManager;
	local name AbilityName;
	local XComGameState_Ability AbilityTestState;
	local EffectAppliedData TestEffectParams;
	local X2Effect Effect;
	local X2Effect_Persistent PersistentEffect;

	local delegate<X2StrategyGameRulesetDataStructures.SpecialRequirementsDelegate> ShouldStatDisplayFn;
	local int Index, UpgradeCritDamage;

	// Safety check: you need to be a weapon to use this. 
	WeaponTemplate = X2WeaponTemplate(m_ItemTemplate);
	if( WeaponTemplate == none ) 
		return Stats; 

	if(PreviewUpgradeStats != none) 
		UpgradeStats = RealkItem.GetUpgradeModifiersForUI(PreviewUpgradeStats);
	else
		UpgradeStats = RealkItem.GetUpgradeModifiersForUI(X2WeaponUpgradeTemplate(m_ItemTemplate));

	// Damage-----------------------------------------------------------------------
	if (!WeaponTemplate.bHideDamageStat)
	{
		// NormalDamage-----------------------------------------------------------------------
		Item.Label = class'XLocalizedData'.default.DamageLabel;
		RealkItem.GetBaseWeaponDamageValue(none, DamageValue);
		if (DamageValue.Damage == 0 && UpgradeStats.bIsDamageModified)
		{
			Item.Value = AddStatModifier(false, "", UpgradeStats.Damage, eUIState_Good);
			Stats.AddItem(Item);
		}
		else if (DamageValue.Damage > 0)
		{
			if (DamageValue.Spread > 0 || DamageValue.PlusOne > 0)
				Item.Value = string(DamageValue.Damage - DamageValue.Spread) $ "-" $ string(DamageValue.Damage + DamageValue.Spread + (DamageValue.PlusOne > 0) ? 1 : 0);
			else
				Item.Value = string(DamageValue.Damage);

			if (UpgradeStats.bIsDamageModified)
				Item.Value $= AddStatModifier(false, "", UpgradeStats.Damage, eUIState_Good);
			Stats.AddItem(Item);
		}
		// CritDamage-----------------------------------------------------------------------
		AbilityTestState=new class'XComGameState_Ability';
		AbilityTestState.SourceWeapon = RealkItem.GetReference();
		TestEffectParams.ItemStateObjectRef = AbilityTestState.SourceWeapon;
		TestEffectParams.AbilityInputContext.ItemObject= AbilityTestState.SourceWeapon;

		AbilityManager=class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

		foreach WeaponTemplate.Abilities(AbilityName)
		{
			AbilityTemplate=AbilityManager.FindAbilityTemplate(AbilityName);
			if ( X2AbilityTrigger_UnitPostBeginPlay(AbilityTemplate.AbilityTriggers[0])!=none
				&& X2AbilityTarget_Self(AbilityTemplate.AbilityTargetStyle)!=none )
			{
				AbilityTestState.OnCreation(AbilityTemplate);	
				TestEffectParams.AbilityInputContext.AbilityTemplateName = AbilityName;
				foreach AbilityTemplate.AbilityShooterEffects(Effect)
				{
					PersistentEffect = X2Effect_Persistent(Effect);
					TestEffectParams.AbilityResultContext.HitResult = eHit_Crit;
					UpgradeCritDamage += PersistentEffect.GetAttackingDamageModifier(none, none, none, AbilityTestState, TestEffectParams, DamageValue.Damage);
					TestEffectParams.AbilityResultContext.HitResult = eHit_Success;
					UpgradeCritDamage -= PersistentEffect.GetAttackingDamageModifier(none, none, none, AbilityTestState, TestEffectParams, DamageValue.Damage);
				}
				foreach AbilityTemplate.AbilityTargetEffects(Effect)
				{
					PersistentEffect = X2Effect_Persistent(Effect);
					TestEffectParams.AbilityResultContext.HitResult = eHit_Crit;
					UpgradeCritDamage += PersistentEffect.GetAttackingDamageModifier(none, none, none, AbilityTestState, TestEffectParams, DamageValue.Damage + DamageValue.Crit);
					TestEffectParams.AbilityResultContext.HitResult = eHit_Success;
					UpgradeCritDamage -= PersistentEffect.GetAttackingDamageModifier(none, none, none, AbilityTestState, TestEffectParams, DamageValue.Damage);
				}
			}
		}
		Item.Label = "Critical Damage";
		Item.ValueState=eUIState_Good;
		Item.Value="";
		if (PopulateWeaponStat(DamageValue.Crit, UpgradeCritDamage>0, UpgradeCritDamage, Item))
			Stats.AddItem(Item);
	}
	//TODO: Item.ValueState = bIsDamageModified ? eUIState_Good : eUIState_Normal;
			
	// Clip Size --------------------------------------------------------------------
	if (m_ItemTemplate.ItemCat == 'weapon' && !WeaponTemplate.bHideClipSizeStat)
	{
		Item.Label = class'XLocalizedData'.default.ClipSizeLabel;
		Item.Value="";
		if (PopulateWeaponStat(RealkItem.GetItemClipSize(), UpgradeStats.bIsClipSizeModified, UpgradeStats.ClipSize, Item))
			Stats.AddItem(Item);
	}

	// Crit -------------------------------------------------------------------------
	Item.Label = class'XLocalizedData'.default.CriticalChanceLabel;
	Item.Value="";
	if (PopulateWeaponStat(RealkItem.GetItemCritChance(), UpgradeStats.bIsCritModified, UpgradeStats.Crit, Item, true))
		Stats.AddItem(Item);

	// Ensure that any items which are excluded from stat boosts show values that show up in the Soldier Header
	if (class'UISoldierHeader'.default.EquipmentExcludedFromStatBoosts.Find(m_ItemTemplate.DataName) == INDEX_NONE)
	{
		// Aim -------------------------------------------------------------------------
		Item.Label = class'XLocalizedData'.default.AimLabel;
		Item.ValueState=eUIState_Good;
		Item.Value="";
		if (PopulateWeaponStat(RealkItem.GetItemAimModifier(), UpgradeStats.bIsAimModified, UpgradeStats.Aim, Item, true))
			Stats.AddItem(Item);
	}

	// Free Fire
	Item.Label = class'XLocalizedData'.default.FreeFireLabel;
	Item.Value="";
	if (PopulateWeaponStat(0, UpgradeStats.bIsFreeFirePctModified, UpgradeStats.FreeFirePct, Item, true))
		Stats.AddItem(Item);

	// Free Reloads
	Item.Label = class'XLocalizedData'.default.FreeReloadLabel;
	Item.Value="";
	if (PopulateWeaponStat(0, UpgradeStats.bIsFreeReloadsModified, UpgradeStats.FreeReloads, Item))
		Stats.AddItem(Item);

	// Miss Damage
	Item.Label = class'XLocalizedData'.default.MissDamageLabel;
	Item.Value="";
	if (PopulateWeaponStat(0, UpgradeStats.bIsMissDamageModified, UpgradeStats.MissDamage, Item))
		Stats.AddItem(Item);

	// Free Kill
	Item.Label = class'XLocalizedData'.default.FreeKillLabel;
	Item.Value="";
	if (PopulateWeaponStat(0, UpgradeStats.bIsFreeKillPctModified, UpgradeStats.FreeKillPct, Item, true))
		Stats.AddItem(Item);

	// Add any extra stats and benefits
	for (Index = 0; Index < WeaponTemplate.UIStatMarkups.Length; ++Index)
	{
		StatMarkup = WeaponTemplate.UIStatMarkups[Index];
		ShouldStatDisplayFn = StatMarkup.ShouldStatDisplayFn;
		if (ShouldStatDisplayFn != None && !ShouldStatDisplayFn())
		{
			continue;
		}

		if (StatMarkup.StatModifier != 0 || StatMarkup.bForceShow)
		{
			Item.Label = StatMarkup.StatLabel;
			Item.Value = string(StatMarkup.StatModifier) $ StatMarkup.StatUnit;
			Stats.AddItem(Item);
		}
	}

	return Stats;
}

simulated function FormatStats(out  array<UISummary_ItemStat> Stats)
{
	local int i;

	local array<string> PercentLabels;
	local array<string> BonusLabels;

	PercentLabels.AddItem(class'XLocalizedData'.default.DodgeLabel);
	PercentLabels.AddItem(class'XLocalizedData'.default.AimLabel);
	PercentLabels.AddItem(class'XLocalizedData'.default.CriticalChanceBonusLabel);
	PercentLabels.AddItem(class'XLocalizedData'.default.CriticalChanceLabel);
	PercentLabels.AddItem(class'XLocalizedData'.default.CritChanceLabel);
	
	if (!m_ItemTemplate.IsA('X2AmmoTemplate'))
	{
		BonusLabels.AddItem(class'XLocalizedData'.default.HealthLabel);
		BonusLabels.AddItem(class'XLocalizedData'.default.MobilityLabel);
		BonusLabels.AddItem(class'XLocalizedData'.default.TechBonusLabel);
		BonusLabels.AddItem(class'XLocalizedData'.default.PsiOffenseBonusLabel);
		BonusLabels.AddItem(class'XLocalizedData'.default.CriticalDamageLabel);
		BonusLabels.AddItem(class'XLocalizedData'.default.GrenadeRangeBonusLabel);
		BonusLabels.AddItem(class'XLocalizedData'.default.GrenadeRadiusBonusLabel);
		if (!m_ItemTemplate.IsA('X2ArmorTemplate'))
		{
			BonusLabels.AddItem(class'XLocalizedData'.default.ArmorLabel);
			BonusLabels.AddItem(class'XLocalizedData'.default.DodgeLabel);
		}
	}

	for (i=0; i<Stats.Length; i++)
	{
		if (BonusLabels.Length==0 || BonusLabels.Find(Stats[i].Label)!=INDEX_NONE)
			Stats[i].Value="+" $ Stats[i].Value;
		if (PercentLabels.Find(Stats[i].Label)!=INDEX_NONE)
			Stats[i].Value $= "%";
	}
}


simulated function bool PopulateWeaponStat(int Value, bool bIsStatModified, int UpgradeValue, out UISummary_ItemStat Item, optional bool bIsPercent)
{
	local string Suffix;

	if (bIsPercent) Suffix="%";
	else Suffix=Item.Value;

	if (Item.ValueState==eUIState_Good)
	{
		Item.Value="+";
		Item.ValueState=eUIState_Normal;
	}
	else Item.Value="";

	if (Value<=0)
	{
		Item.Value = "0";
		return false;
	}

	if (Value > 0) Item.Value $= Value $ Suffix;

	if (bIsStatModified) Item.Value $= AddStatModifier(false, "", UpgradeValue, eUIState_Good, Suffix);

	return true;
}

defaultproperties
{
	StatsSuffix[eStat_Dodge]="%";
	StatsSuffix[eStat_Offense]="%";
	StatsSuffix[eStat_Defense]="%";
	StatsSuffix[eStat_CritChance]="%";
	StatsSuffix[eStat_FlankingCritChance]="%";
	StatsSuffix[eStat_FlankingAimBonus]="%";

	iArmourStats[eStat_Dodge]=1;
	iArmourStats[eStat_ArmorMitigation]=1;
}