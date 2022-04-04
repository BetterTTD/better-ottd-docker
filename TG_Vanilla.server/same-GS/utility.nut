class CacheDuuude {
    static cargo = GSList();
    static vehicle = array(17, -1);
    static snowtown = GSList();
    static powerplant = GSList();
    static cargo_handle = GSList();
    static cargo_town = GSList();
    static cargo_industry = GSList();
    static cargo_tracker = ["WOOD", "OIL_", "TOYS", "WATR", "GOOD", "DIAM"];
    static bigarray = [];
    static indexer = {};
	    id	= null;
    	index = null;
            constructor(strid, defvalue = 0) {
                this.id = strid;
                if (this.id in CacheDuuude.indexer)	{ GSLog.Info(strid+" is already index"); return; }
                this.index = CacheDuuude.bigarray.len();
                for (local i = 0; i < 15; i++)	{ CacheDuuude.bigarray.push(defvalue); }
                GSLog.Info("New entry "+this.id+" at index "+this.index);
                CacheDuuude.indexer[this.id] <- this;
            }
            function Resolver();
}

function CacheDuuude::Resolver() {
    local comp = [];
    for (local r = 0; r < 15; r++) {
        local rc = GSCompany.ResolveCompanyID(r);
        if (rc != GSCompany.COMPANY_INVALID)    { comp.push(rc); }
    }
    return comp;
}

function CacheDuuude::Vehicle_Helper_Counter(v_str)
{
	local vlist = CacheDuuude.Vehicle_Helper();
	local company = CacheDuuude.Company_Helper();
	local retvalue = GSList();
	for (local j = 0; j < 15; j++)	{ retvalue.AddItem(j, 0); }
	local v_type = null;
	foreach (comp in company)
		{
		local tl = GSList();
		tl.AddList(vlist[comp]);
		tl.Valuate(GSVehicle.GetVehicleType);
		if (v_str == "train" || v_str == "boat")
				{
				if (v_str == "train")	{ tl.KeepValue(GSVehicle.VT_RAIL); }
								else	{ tl.KeepValue(GSVehicle.VT_WATER); }
				}
		else	{ // air & road
				if (v_str == "bus" || v_str == "truck")
						{
						tl.KeepValue(GSVehicle.VT_ROAD);
						local pass = CacheDuuude.GetPassengerCargo();
						local filter = GSList();
						foreach (veh, _ in tl)
							{
							filter.AddItem(veh, 0); // add as truck
							foreach (pcargo, _ in pass)
								{
								if (GSVehicle.GetCapacity(veh, pcargo) > 0)	{ filter.SetValue(veh, 1); }
								}
							}
						if (v_str == "bus")	{ filter.KeepValue(1); }
									else	{ filter.KeepValue(0); }
						tl.Clear();
						tl.AddList(filter);
						}
				else	{
						tl.KeepValue(GSVehicle.VT_AIR);
						local filter = GSList();
						foreach (veh, _ in tl)
							{
							filter.AddItem(veh, 0); // plane are 0
							local eng = GSVehicle.GetEngineType(veh);
							if (GSEngine.GetPlaneType(eng) == GSAirport.PT_HELICOPTER)	{ filter.SetValue(veh, 1); }
							}
						if (v_str == "aircraft")	{ filter.KeepValue(0); }
											else	{ filter.KeepValue(1); }
						tl.Clear();
						tl.AddList(filter);
						}
				}
		retvalue.SetValue(comp, tl.Count());
		}
	return retvalue;
}

function CacheDuuude::GetPassengerCargo() {
	if (!CacheDuuude.cargo.IsEmpty())	{ return CacheDuuude.cargo; }
	local cargolist = GSCargoList();
	foreach (cargo, dummy in cargolist)
			{
			if (GSCargo.GetTownEffect(cargo) == GSCargo.TE_PASSENGERS) { CacheDuuude.cargo.AddItem(cargo, 0); }
			}
	return CacheDuuude.cargo;
}

function CacheDuuude::GetSnowTown(addnew = false) {
	if (!CacheDuuude.snowtown.IsEmpty() && !addnew)	{ return CacheDuuude.snowtown; }
	local town_list = GSTownList();
	town_list.RemoveList(CacheDuuude.snowtown);
	local terrain = GSTileList();
	foreach (town, _ in town_list)
		{
		terrain.Clear();
		local location = GSTown.GetLocation(town);
	    terrain.AddRectangle(location + GSMap.GetTileIndex(-8, -8), location + GSMap.GetTileIndex(8, 8));
		terrain.Valuate(GSTile.GetTerrainType);
		terrain.KeepValue(GSTile.TERRAIN_SNOW);
		if (!terrain.IsEmpty())	{
								CacheDuuude.snowtown.AddItem(town, 0);
								}
		}
	return CacheDuuude.snowtown;
}

function CacheDuuude::GetPowerPlant(addnew = false)
{
	if (!CacheDuuude.powerplant.IsEmpty() && !addnew && CacheDuuude.powerplant.GetValue(0) != -1)	{ return CacheDuuude.powerplant; }
	local cargolabel = ["COAL"];
	local cargo_list = GSCargoList();
	local energy_list = GSList();
	if (CacheDuuude.powerplant.HasItem(0))	{ CacheDuuude.powerplant.RemoveItem(0); }
	foreach (cargoid, _ in cargo_list)
		{
		local t_list = GSList();
		if (Utils.INArray(GSCargo.GetCargoLabel(cargoid), cargolabel) != -1)
			{
			t_list = GSIndustryList_CargoAccepting(cargoid);
			foreach (indID, _ in t_list)
				{
				CacheDuuude.powerplant.AddItem(indID, cargoid);
				}
			}
		}
	if (CacheDuuude.powerplant.IsEmpty())	{ CacheDuuude.powerplant.AddItem(0, -1); }
	return CacheDuuude.powerplant;
}

function CacheDuuude::GetCompetitorStationAround(IndustryID)
{
	local comp_list = GSList();
	local counter=0;
	local place = GSIndustry.GetLocation(IndustryID);
	local radius = GSStation.GetCoverageRadius(GSStation.STATION_TRAIN);
	local tiles = GSTileList();
	local produce = GSTileList_IndustryAccepting(IndustryID, radius);
	local accept = GSTileList_IndustryProducing(IndustryID, radius);
	tiles.AddList(produce);
	tiles.AddList(accept);
	tiles.Valuate(GSTile.IsStationTile); // force keeping only station tile
	tiles.KeepValue(1);
	tiles.Valuate(GSStation.GetStationID);
	foreach (tile, stationID in tiles)
		{ // remove duplicate id
		if (!comp_list.HasItem(stationID))	{ comp_list.AddItem(stationID, GSStation.GetOwner(stationID)); }
		}
	return comp_list;
}

function CacheDuuude::Infrastructure_helper(inftype)
{
	local comp_list = CacheDuuude.Company_Helper();
	local ret = GSList();
	foreach (comp in comp_list)
		{
		local k = GSInfrastructure.GetInfrastructurePieceCount(comp, inftype);
		ret.AddItem(comp, k);
		}
	return ret;
}

function CacheDuuude::FindCargoUsage()
{
	if (!CacheDuuude.cargo_town.IsEmpty())	{ return; }
	local indtype_list = GSIndustryTypeList();
	foreach (item, value in indtype_list)
		{
        local cargolist = GSIndustryType.GetAcceptedCargo(item);
		foreach (cargo, _ in cargolist)
			{
			if (!CacheDuuude.cargo_industry.HasItem(cargo))	{ CacheDuuude.cargo_industry.AddItem(cargo, item); }
			}
		}
	local cargo_list = GSCargoList();
	CacheDuuude.cargo_town.AddList(cargo_list);
	foreach (cargo, _ in cargo_list)
		{
		if (GSCargo.GetTownEffect(cargo) == GSCargo.TE_NONE)	{ CacheDuuude.cargo_town.RemoveItem(cargo); }
		local label = GSCargo.GetCargoLabel(cargo);
		if (Utils.INArray(label, CacheDuuude.cargo_tracker) != -1)	{ local entry = CacheDuuude(label, 0); }
		}
	local o_str = [];
	foreach (cargo, _ in CacheDuuude.cargo_town)	{ o_str.push(GSCargo.GetCargoLabel(cargo)); }
    //	GSLog.Info("Towns accept cargo : "+Utils.ArrayListToString(CacheDuuude.cargo_town));
    GSLog.Info("Towns accept cargo : "+Utils.ArrayListToString(o_str));
	//GSLog.Info("Industries accept cargo : "+Utils.ArrayListToString(CacheDuuude.cargo_industry));
	o_str = [];
	foreach (cargo, _ in CacheDuuude.cargo_industry)	{ o_str.push(GSCargo.GetCargoLabel(cargo)); }
	GSLog.Info("Industries accept cargo : "+Utils.ArrayListToString(o_str));
}

function CacheDuuude::Monitoring()
{
	local companies = CacheDuuude.Company_Helper();
	local town_list = GSTownList();
	foreach (company in companies) // Insane loops !
		{
		local stown = CacheDuuude.GetData("supply_town", company);
		if (stown < 1000000)
			{
			foreach (town, _ in town_list)
				{
				if (GSTown.GetRating(town, company) != 0)
					{
					foreach (cargo, _ in CacheDuuude.cargo_town)
						{
						local z = GSCargoMonitor.GetTownDeliveryAmount(company, cargo, town, true);
						if (z > 0)	{
									local k = CacheDuuude.cargo_handle.GetValue(company);
									k = (k | (1 << cargo));
									CacheDuuude.cargo_handle.SetValue(company, k);
									}
						if (GSCargo.GetCargoLabel(cargo) == "GOOD") // special monitoring of good
							{
							local h = CacheDuuude.GetData("GOOD", company);
							h += z;
							CacheDuuude.SetData("GOOD", company, h);
							}
						stown += z;
						if (stown > 1000000)	{ GSCargoMonitor.GetTownDeliveryAmount(company, cargo, town, false); }
						CacheDuuude.SetData("supply_town", company, stown);
						}
					}
				}
			}
		local sind = CacheDuuude.GetData("supply_industry", company);
		if (sind < 1000000)
			{
			foreach (cargo, _ in CacheDuuude.cargo_industry)
				{
				local ind_list = GSIndustryList_CargoAccepting(cargo);
				foreach (industry, iii in ind_list)
					{
					local z = GSCargoMonitor.GetIndustryDeliveryAmount(company, cargo, industry, true);
					if (z > 0)	{
								local k = CacheDuuude.cargo_handle.GetValue(company);
								k = (k | (1 << cargo));
								CacheDuuude.cargo_handle.SetValue(company, k);
								}
					local hh = GSCargo.GetCargoLabel(cargo);
					if (Utils.INArray(hh, CacheDuuude.cargo_tracker) != -1)  // special monitoring of specific cargos
						{
						local h = CacheDuuude.GetData(hh, company);
						h += z;
						CacheDuuude.SetData(hh, company, h);
						}
					sind += z;
					if (sind > 1000000)	{ GSCargoMonitor.GetIndustryDeliveryAmount(company, cargo, industry, false); }
					CacheDuuude.SetData("supply_industry", company, sind);
					}
				}
			}
		}
}

function CacheDuuude::DeliveryAwardGeneric(number, comp)
{
	if (Awards.HaveAward(number, comp))	{ return; }
	local awd = Awards.Get(number);
	if (awd == false)	{ return; }
	local everyone = [];
	everyone.extend(awd.Own_By_Company);
	everyone.push(comp);
	Awards.GrantAward(number, everyone);
}

function CacheDuuude::SetData(strID, companyID, data)
{
	if (!(strID in CacheDuuude.indexer))	{ return -1; }
	local goal = CacheDuuude.indexer[strID];
	CacheDuuude.bigarray[goal.index + companyID] = data;
}

function CacheDuuude::GetData(strID, companyID)
{
	if (!(strID in CacheDuuude.indexer))	{ return -1; }
	local goal = CacheDuuude.indexer[strID];
	return (CacheDuuude.bigarray[goal.index + companyID]);
}

function CacheDuuude::GetIndex(strID)
{
	if (!(strID in CacheDuuude.indexer))	{ return -1; }
	local goal = CacheDuuude.indexer[strID];
	return goal.index;
}

function CacheDuuude::CalcCompanyValue(companyID)
{
	local cmode = GSCompanyMode(companyID);
	local value = GSCompany.GetBankBalance(companyID);
	value -= GSCompany.GetLoanAmount();
	local vlist = CacheDuuude.Vehicle_Helper();
	vlist[companyID].Valuate(GSVehicle.GetCurrentValue);
	foreach (veh, price in vlist[companyID])	{ value += price; }
	return value;
}

function CacheDuuude::Company_Helper()
{
	local company = [];
	for (local j = 0; j < 15; j++)
		{
		local c_idx = GSCompany.ResolveCompanyID(j);
		if (c_idx != GSCompany.COMPANY_INVALID)	{ company.push(c_idx); }
		}
	return company;
}

function CacheDuuude::Vehicle_Helper()
{
	local d = CacheDuuude.vehicle[16];
	local now = GSDate.GetCurrentDate();
	if ((now - d) < 10)	{ return CacheDuuude.vehicle; }
	local vlist = GSVehicleList();
	vlist.Valuate(GSVehicle.GetOwner);
	CacheDuuude.vehicle[15].Clear();
	CacheDuuude.vehicle[15].AddList(vlist);
	for (local i = 0; i < 15; i++)
		{
		CacheDuuude.vehicle[i].Clear();
		CacheDuuude.vehicle[i].AddList(vlist);
		CacheDuuude.vehicle[i].KeepValue(i);
		}
	CacheDuuude.vehicle[16] = GSDate.GetCurrentDate();
	return CacheDuuude.vehicle;
}

class Utils
{
	constructor()
	{
	}
}

function Utils::ArrayListToString(list)
{
	local ret = "[";
	local check = false;
	if (typeof(list) == "array")	{ check = (list.len() == 0); }
							else	{ check = list.IsEmpty(); }
	if (!check)
			{
			local contents = "";
			foreach (a, b in list)
				{
				if (contents != "") contents += ", ";
				if (b != -1)	contents += a + " = " + b;
				}
			ret += contents;
			}
	ret += "]";
	return ret;
}

function Utils::GSListToArray(list)
{
	local ar = [];
	foreach (item, value in list)	{ ar.push(item); ar.push(value); }
	return ar;
}

function Utils::ArrayToGSList(ar)
{
	local list = GSList();
	for (local i = 0; i < ar.len(); i++)
		{
		list.AddItem(i, i+1);
		i++;
		}
	return list;
}

function Utils::INArray(seek, data)
{
	foreach (item, value in data)	{ if (value == seek)	{ return item; } }
	return -1;
}
