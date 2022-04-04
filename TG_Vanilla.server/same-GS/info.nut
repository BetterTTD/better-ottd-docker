class TeamDuude extends GSInfo {
	function GetAuthor()		{ return "same-f"; }
	function GetName() 		{ return "TeamDuude"; }
	function GetDescription() 	{ return ""; }
	function GetVersion()		{ return 1; }
	function MinVersionToLoad() 	{ return 1; }	
	function GetDate() 		{ return "2022-04-01"; }
	function CreateInstance() 	{ return "TeamDuude"; }
	function GetShortName()		{ return "DUUD"; }
	function GetAPIVersion()	{ return "12"; }
}
RegisterGS(TeamDuude());
