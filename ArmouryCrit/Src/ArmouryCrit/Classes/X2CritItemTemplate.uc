class X2CritItemTemplate extends X2ItemTemplate;

var X2ItemTemplate RealTemplate;

var int ObjectID;

function string GetItemFriendlyName(optional int ItemID = 0, optional bool bShowSquadUpgrade)
{
	if(ItemID==0) ItemID=ObjectID;

	return RealTemplate.GetItemFriendlyName(ItemID, bShowSquadUpgrade);
}