static cPage = [];
	

	

static gElement = [];
	

	

static cPoints = [];
	

	

constructor() {
	

	

for ( local i = 0; i < 21*3; i++ ) { cPage.push(-1); }
	

	

for ( local i = 0; i < 15; i++ ) { cPoints.push(-1); }
	

	

for ( local i = 0; i < 64; i++ ) { gElement.push(-1); }
	

	

}
	

	

function GetPageID();
	

	

function NewCompany();
	

	

function Init();
	

	

function StoryUpdate();
	

	

function StoryUpgrade();
	

	

}
	

	



	

	

function CompanyDuuude::GetPageID(cID, opt) {
	

	

if (cID > 21 || cID < 0) { GSLog.Error("Error: can't set pageID - Bad Value" + cID); return -1; }
	

	

local x = cID * 3;
	

	

if (cID == 15 || cID > 16) { opt = 0; }
	

	

return CompanyDuuude.cPage[x + opt];
	

	

}
	

	



	

	

function CompanyDuuude::NewCompany(cID) {
	

	

if (GSCompany.ResolveCompanyID == GSCompany.COMPANY_INVALID) return;
	

	

local x = cID * 3;
	

	

if (!GSStoryPage.IsValidStoryPage(CompanyDuuude.cPage[x+0])) {
	

	

CompanyDuuude.cPage[x+0] = GSStoryPage.New(cID, GSText(GSText.STR_PAGE_TITLE));
	

	

}
	

	

// if (!GSStoryPage.IsValidStoryPage(CompanyDuuude.cPage[x+1])) {
	

	

// CompanyDuuude.cPage[x+1] = GSStoryPage.New(cID, GSText(GSText.STR_PAGE_TITLE));
	

	

// }
	

	

// if (!GSStoryPage.IsValidStoryPage(CompanyDuuude.cPage[x+2])) {
	

	

// CompanyDuuude.cPage[x+2] = GSStoryPage.New(cID, GSText(GSText.STR_PAGE_TITLE));
	

	

// }
	

	

local logpage = " ";
	

	

for (local p = 0; p < 3; p++) { logpage+="-"+CompanyDuuude.cPage[x+p]+" "; }
	

	

GSLog.Info("Added company #"+cID+" "+GSCompany.GetName(cID)+" using pages "+logpage);
	

	

if (CacheDuuude.GetData("companyDate", cID) == 0) { CacheDuuude.SetData("companyDate", cID, GSDate.GetCurrentDate()); }
	

	

CacheDuuude.Monitoring();
	

	

}
	

	



	

	

function CompanyDuuude::Init() {
	

	

if (!GSStoryPage.IsValidStoryPage(CompanyDuuude.GetPageID(15, 0))) {
	

	

CompanyDuuude.cPage[15 * 3] = GSStoryPage.New(GSCompany.COMPANY_INVALID, GSText(GSText.STR_WELCOME_TITLE));
	

	

}
	

	

CompanyDuuude.cPage[15 *3 + 1] = CompanyDuuude.StoryUpdate(CompanyDuuude.GetPageID(15, 0), CompanyDuuude.cPage[15 * 3 +1], GSText(GSText.STR_WELCOME_WELCOME, GSText(GSText.STR_WELCOME_AWARE), GSText(GSText.STR_WELCOME_RULES)));
	

	

CompanyDuuude.cPage[15 *3 + 2] = CompanyDuuude.StoryUpdate(CompanyDuuude.GetPageID(15, 0), CompanyDuuude.cPage[15 * 3 +2], GSText(GSText.STR_WELCOME_TEXT1, GSText(GSText.STR_WELCOME_TEXT2), GSText(GSText.STR_WELCOME_TEXT3)));
	

	



	

	

if (!GSStoryPage.IsValidStoryPage(CompanyDuuude.GetPageID(16, 0))) {
	

	

CompanyDuuude.cPage[16 * 3] = GSStoryPage.New(GSCompany.COMPANY_INVALID, GSText(GSText.STR_RULES_TITLE));
	

	

}
	

	

CompanyDuuude.cPage[16 *3 + 1] = CompanyDuuude.StoryUpdate(CompanyDuuude.GetPageID(16, 0), CompanyDuuude.cPage[16 * 3 +1], GSText(GSText.STR_RULES_RULES, GSText(GSText.STR_RULES_STEALING), GSText(GSText.STR_RULES_TELEPORT)));
	

	

CompanyDuuude.cPage[16 *3 + 2] = CompanyDuuude.StoryUpdate(CompanyDuuude.GetPageID(16, 0), CompanyDuuude.cPage[16 * 3 +2], GSText(GSText.STR_RULES_GRIDS, GSText(GSText.STR_RULES_CENTRAL), GSText(GSText.STR_RULES_FORBIDS)));
	

	



	

	

if (!GSStoryPage.IsValidStoryPage(CompanyDuuude.GetPageID(17, 0))) {
	

	

CompanyDuuude.cPage[17 * 3] = GSStoryPage.New(GSCompany.COMPANY_INVALID, GSText(GSText.STR_SETTINGS_TITLE));
	

	

}
	

	

CompanyDuuude.cPage[17 *3 + 1] = CompanyDuuude.StoryUpdate(CompanyDuuude.GetPageID(17, 0), CompanyDuuude.cPage[17 * 3 +1], GSText(GSText.STR_SETTINGS_SET1, GSText(GSText.STR_SETTINGS_SET2), GSText(GSText.STR_SETTINGS_SET3)));
	

	

CompanyDuuude.cPage[17 *3 + 2] = CompanyDuuude.StoryUpdate(CompanyDuuude.GetPageID(17, 0), CompanyDuuude.cPage[17 * 3 +2], GSText(GSText.STR_SETTINGS_SET4, GSText(GSText.STR_SETTINGS_SET5), GSText(GSText.STR_SETTINGS_SET6)));
	

	



	

	

if (!GSStoryPage.IsValidStoryPage(CompanyDuuude.GetPageID(18, 0))) {
	

	

CompanyDuuude.cPage[18 * 3] = GSStoryPage.New(GSCompany.COMPANY_INVALID, GSText(GSText.STR_STUFF_TITLE));
	

	

}
	

	

CompanyDuuude.cPage[18 *3 + 1] = CompanyDuuude.StoryUpdate(CompanyDuuude.GetPageID(18, 0), CompanyDuuude.cPage[18 * 3 +1], GSText(GSText.STR_STUFF_SET1, GSText(GSText.STR_STUFF_SET2), GSText(GSText.STR_STUFF_SET3)));
	

	

CompanyDuuude.cPage[18 *3 + 2] = CompanyDuuude.StoryUpdate(CompanyDuuude.GetPageID(18, 0), CompanyDuuude.cPage[18 * 3 +2], GSText(GSText.STR_STUFF_SET4, GSText(GSText.STR_STUFF_SET5), GSText(GSText.STR_STUFF_SET6)));
	

	



	

	

if (!GSStoryPage.IsValidStoryPage(CompanyDuuude.GetPageID(19, 0))) {
	

	

CompanyDuuude.cPage[19 * 3] = GSStoryPage.New(GSCompany.COMPANY_INVALID, GSText(GSText.STR_LINKS_TITLE));
	

	

}
	

	

CompanyDuuude.cPage[19 *3 + 1] = CompanyDuuude.StoryUpdate(CompanyDuuude.GetPageID(19, 0), CompanyDuuude.cPage[19 * 3 +1], GSText(GSText.STR_LINK_PRE));
	

	

CompanyDuuude.cPage[19 *3 + 2] = CompanyDuuude.StoryUpdate(CompanyDuuude.GetPageID(19, 0), CompanyDuuude.cPage[19 * 3 +2], GSText(GSText.STR_LINK_TELEGRAM, GSText(GSText.STR_LINK_DISCORD), GSText(GSText.STR_LINK_WEB)));
	

	



	

	

CompanyDuuude.StoryUpgrade();
	

	

}
	

	



	

	

function CompanyDuuude::StoryUpdate(pID, eID, txt, type = GSStoryPage.SPET_TEXT, ref = 0) {
	

	

if (!GSStoryPage.IsValidStoryPageElement(eID)) {
	

	

eID = GSStoryPage.NewElement(pID, type, 0, "TEXT");
	

	

if (eID == GSStoryPage.STORY_PAGE_ELEMENT_INVALID) { return -1; }
	

	

}
	

	

GSStoryPage.UpdateElement(eID, ref, txt);
	

	

return eID;
	

	

}
	

	



	

	

function CompanyDuuude::StoryUpgrade() {
	

	

        local rank = GSList();
	

	

        for (local i = 0; i < 15; i++)
	

	

                {
	

	

                rank.AddItem(i, CompanyDuuude.cPoints[i]);
	

	

                }
	

	

        rank.Sort(GSList.SORT_BY_VALUE, GSList.SORT_DESCENDING);
	

	

        local counter = 0;
	

	

        local draw = -1;
	

	

        local result = [];
	

	

        local points = -1;
	

	

        foreach (comp, top in rank) {
	

	

                if (GSCompany.ResolveCompanyID(comp) == GSCompany.COMPANY_INVALID) {
	

	

                        points = -1;
	

	

                        CompanyDuuude.cPoints[comp] = -1;
	

	

                } else {
	

	

                        if (top == -1) {
	

	

                                points = 0;
	

	

                                CompanyDuuude.cPoints[comp] = 0;
	

	

                                CompanyDuuude.NewCompany(comp);
	

	

                } else { points = top; }
	

	

                }
	

	

if (points != draw && points != -1)        { counter++; draw = points; }
	

	

local res = null;
	

	

switch (counter) {
	

	

                case        1 :
	

	

                        res = GSText(GSText.STR_GREEN);
	

	

                        break;
	

	

                case        2:
	

	

                        res = GSText(GSText.STR_YELLOW);
	

	

                        break;
	

	

                case        3:
	

	

                        res = GSText(GSText.STR_ORANGE);
	

	

                        break;
	

	

                default:
	

	

                        res = GSText(GSText.STR_RED);
	

	

        }
	

	

        if (points == -1) {
	

	

                res = " "; }
	

	

        else {
	

	

                res.AddParam(GSText(GSText.STR_RANK));
	

	

                res.AddParam(counter);
	

	

                res.AddParam(comp);
	

	

                res.AddParam(points);
	

	

        }
	

	

result.push(res);
	

	

        }
	

	

        for (local i = 0; i < result.len(); i++) {
	

	

                GSStoryPage.UpdateElement(CompanyDuuude.gElement[i], 0, result[i]);
	

	

                }
	

	}
class CompanyDuuude {