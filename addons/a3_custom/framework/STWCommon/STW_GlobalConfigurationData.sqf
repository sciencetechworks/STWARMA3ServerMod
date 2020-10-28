#ifndef  STW_GlobalConfigurationData_Module_Loaded
#define STW_GlobalConfigurationData_Module_Loaded true
diag_log "STW_GlobalConfigurationData_Module_Loaded";

STWG_MARKER_COUNT=0;
STWG_DRAWING_HANDLERS=[];
/**
PROBABILITY OF A ZONE TO BE OF CONFLICT, THE HIGHER THE MORE RED ZONES ON MAP
**/
STWG_PROBABILITY_OF_A_POI_TO_BE_CONFICT_ZONE=75;

/**
 Maximum number of patrolling squads on map.
**/
STWG_NUM_PATROLLING_SQUADS=8;
/**
 Patrolling squads generation probability matrix
**/
STWG_PATROL_SQUADS_SIDE_PROBABILITY=[EAST,EAST,EAST,WEST];

/**
 Maximum number of combat air vehicles patrolling on map
**/
STWG_NUM_AIR_TRAFFIC_VEHICLES=5;

/**
Maximum number of combat boats patrolling on map
**/
STWG_NUM_WATER_TRAFFIC_VEHICLES=5;

/**
 Water Areas becomes ready once the water zones algorithm has finished
**/
STWG_WATER_AREAS_LIST_READY=false;
// Resolution factor to scan for water areas
STWG_WATER_AREAS_SCAN_RESOLUTION_FACTOR=0.01;
STWG_WATER_ZONES=[];
if (!isNil("STWG_WATER_AREAS_PATH_GRAPH")) then
{
    diag_log "WATER MAP DATA LOADED";
	STWG_WATER_ZONES=STWG_WATER_AREAS_PATH_GRAPH select 0; //Loaded from STW_MAP_DATA.sqf
	STWG_WATER_AREAS_LIST_READY=true;
};

/**
 Land Areas becomes ready once the water zones algorithm has finished
**/
STWG_LAND_AREAS_LIST_READY=false;
// Resolution factor to scan for water areas
STWG_LAND_AREAS_SCAN_RESOLUTION_FACTOR=0.01; //0.005;
STWG_LAND_ZONES=[];
if (!isNil("STWG_LAND_AREAS_PATH_GRAPH")) then
{
    diag_log "LAND MAP DATA LOADED";
	STWG_LAND_ZONES=STWG_LAND_AREAS_PATH_GRAPH select 0; //Loaded from STW_MAP_DATA.sqf
	STWG_LAND_AREAS_LIST_READY=true;
};

/**
 List of possible military groups for the WEST side
 [[grouptype,probability_of_creation],...]
**/
STWG_PossibleWESTGroups=[

	//[configfile >> "CfgGroups" >> "West" >> "ffaa" >> "Infantry" >> "ffaa_brilat_E_TIR",100],
	//[configfile >> "CfgGroups" >> "West" >> "ffaa" >> "Infantry" >> "ffaa_brilat_P_fusiles",100],
	//[configfile >> "CfgGroups" >> "West" >> "ffaa" >> "Infantry" >> "ffaa_InfTeam_AT",100],
	//[configfile >> "CfgGroups" >> "West" >> "ffaa" >> "Infantry" >> "ffaa_ReconPatrol",100],
	//[configfile >> "CfgGroups" >> "West" >> "ffaa" >> "Infantry" >> "ffaa_ReconTeam",100],
	//[configfile >> "CfgGroups" >> "West" >> "ffaa" >> "SpecOps" >> "ffaa_MOE_SpecialTeam",100],
	//[configfile >> "CfgGroups" >> "West" >> "ffaa" >> "Support" >> "ffaa_Support_ENG",100],
	//[configfile >> "CfgGroups" >> "West" >> "ffaa" >> "Mechanized" >> "ffaa_MechInfSquad",20],
	//[configfile >> "CfgGroups" >> "West" >> "ffaa" >> "Motorized" >> "ffaa_MotInf_Team",20],
	//[configfile >> "CfgGroups" >> "West" >> "ffaa" >> "Armored" >> "ffaa_TankPlatoon_Leopard",10],
	//[configfile >> "CfgGroups" >> "West" >> "ffaa" >> "Armored" >> "ffaa_TankPlatoon_pizarro",10],
	//[configfile >> "CfgGroups" >> "West" >> "ffaa" >> "Armored" >> "ffaa_TankPlatoon_TOA",20],

	[configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_infantry" >> "rhs_group_nato_usmc_wd_infantry_squad",100],
	[configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_infantry" >> "rhs_group_nato_usmc_wd_infantry_weaponsquad",100],
	[configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_infantry" >> "rhs_group_nato_usmc_wd_infantry_squad_sniper",100],
	[configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_infantry" >> "rhs_group_nato_usmc_wd_infantry_team",100],
	[configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_infantry" >> "rhs_group_nato_usmc_wd_infantry_team_MG",100],
	[configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_infantry" >> "rhs_group_nato_usmc_wd_infantry_team_AA",100],
	[configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_infantry" >> "rhs_group_nato_usmc_wd_infantry_team_support",100],
	[configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_infantry" >> "rhs_group_nato_usmc_wd_infantry_team_heavy_AT",100],
	[configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_fr_infantry" >> "rhs_group_nato_usmc_fr_infantry_squad",100],
	[configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_HMMWV" >> "BUS_MotInf_Team_GMG",40],
	[configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_HMMWV" >> "BUS_MotInf_Team_HMG : BUS_MotInf_Team_GMG",60],
	[configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_HMMWV" >> "BUS_MotInf_AT : BUS_MotInf_Team_GMG",80],
	[configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_HMMWV" >> "BUS_MotInf_AA : BUS_MotInf_Team_GMG",40],
	[configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_RG33" >> "rhs_group_nato_usmc_wd_RG33_squad",60],
	[configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_RG33" >> "rhs_group_nato_usmc_wd_RG33_squad_2mg",70],
	[configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_RG33" >> "rhs_group_nato_usmc_wd_RG33_squad_sniper",40],
	[configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_RG33" >> "rhs_group_nato_usmc_wd_RG33_squad_mg_sniper",60],
	[configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_RG33" >> "rhs_group_nato_usmc_wd_RG33_m2_squad",60],
	[configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_RG33" >> "rhs_group_nato_usmc_wd_RG33_m2_squad_sniper",60],
	[configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_RG33" >> "rhs_group_nato_usmc_wd_RG33_m2_squad_mg_sniper",60],
	[configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_m1a1" >> "RHS_M1A1AIM_wd_Platoon",50],
	[configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_m1a1" >> "RHS_M1A1FEP_wd_Section",40]	
	];
	
/**
 List of possible military groups for the EAST side
 [[grouptype,probability_of_creation],...]
**/	
STWG_PossibleEASTGroups=[
    [configfile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_mi24" >> "rhs_group_rus_vdv_mi24_squad_mg_sniper",0],
	[configfile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_mi8" >> "rhs_group_rus_vdv_mi8_squad",0],
	[configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry" >> "rhs_group_rus_msv_infantry_chq",100],
	[configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry" >> "rhs_group_rus_msv_infantry_fireteam",100],
	[configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry" >> "rhs_group_rus_msv_infantry_MANEUVER",100],
	[configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry" >> "rhs_group_rus_msv_infantry_section_AA",100],
	[configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry" >> "rhs_group_rus_msv_infantry_section_AT",100],
	[configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry" >> "rhs_group_rus_msv_infantry_section_marksman",100],
	[configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry" >> "rhs_group_rus_msv_infantry_section_mg",100],
	[configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry" >> "rhs_group_rus_msv_infantry_squad",100],
	[configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_bmp1" >> "rhs_group_rus_msv_bmp1_squad",80],
	[configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_bmp2" >> "rhs_group_rus_msv_bmp2_squad_mg_sniper",80],
	[configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_bmp2" >> "rhs_group_rus_msv_bmp2_squad_aa",80],
	[configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_MSV_BMP3" >> "rhs_group_rus_MSV_BMP3_squad_sniper",80],
	[configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_MSV_bmp3m" >> "rhs_group_rus_MSV_bmp3m_squad_2mg",80],
	[configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_btr70" >> "rhs_group_rus_msv_btr70_squad",70],
	[configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_BTR80" >> "rhs_group_rus_msv_BTR80_squad",60],
	[configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_Ural" >> "rhs_group_rus_msv_Ural_squad",40],
	[configfile >> "CfgGroups" >> "East" >> "rhs_faction_tv" >> "rhs_group_rus_tv_72" >> "RHS_T72BDSection",60]
	];

/**
 List of possible air vehicles
**/
STWG_PossibleAirVehicles=[
	//"rhs_mig29s_vmf",
	"RHS_C130J",
	"RHS_A10",
	"RHS_A10",
	"RHS_Su25SM_vvsc",
	//"RHS_Su25SM_vvsc",
	//"RHS_Su25SM_vvsc",
	//"RHS_Su25SM_vvsc",
	
	//"rhsusf_f22",
	/*
	"C_Heli_Light_01_civil_F",
	"C_IDAP_Heli_Transport_02_F",
	"RHS_Mi8amt_civilian",
	"C_Heli_Light_01_civil_F",
	"C_IDAP_Heli_Transport_02_F",
	"RHS_Mi8amt_civilian",
	"C_Heli_Light_01_civil_F",
	"C_IDAP_Heli_Transport_02_F",
	"RHS_Mi8amt_civilian",*/
	
	"RHS_AH64D_wd",
	"RHS_AH64D_wd",
	"RHS_AH1Z",
	"RHS_AH1Z",
	
	"O_Heli_Light_02_dynamicLoadout_F",
	"RHS_Mi24P_vdv",
	"RHS_Mi24V_vdv",
	"RHS_Ka52_vvsc",
	"rhs_ka60_c",
	"rhs_mi28n_vvsc",
	"O_Heli_Light_02_dynamicLoadout_F",
	"RHS_Mi24P_vdv",
	"RHS_Mi24V_vdv",
	"RHS_Ka52_vvsc",
	"rhs_ka60_c",
	"rhs_mi28n_vvsc",
	"O_Heli_Light_02_dynamicLoadout_F",
	"RHS_Mi24P_vdv",
	"RHS_Mi24V_vdv",
	"RHS_Ka52_vvsc",
	"rhs_ka60_c",
	"rhs_mi28n_vvsc",
	"RHS_Mi24P_vdv",
	"RHS_Mi24V_vdv",
	"RHS_Ka52_vvsc",
	"rhs_ka60_c",
	"rhs_mi28n_vvsc",
	"RHS_Mi24P_vdv",
	"RHS_Mi24V_vdv",
	"RHS_Ka52_vvsc",
	"rhs_ka60_c",
	"rhs_mi28n_vvsc"
	];
	
STWG_CARS_TO_RECOVER_IN_MISSIONS=["rhs_uaz_open_MSV_01",
		"rhsusf_m998_w_2dr_fulltop",
		"rhsusf_m998_w_2dr_halftop",
		"rhsusf_mrzr4_d",
		"rhs_tigr_3camo_vdv",
		"rhs_tigr_m_3camo_vdv"];

STWG_HELOS_TO_RECOVER_IN_MISSIONS=[
"RHS_UH60M2",
"RHS_UH60M",
"RHS_MELB_AH6M",
"RHS_MELB_MH6M",
"RHS_MELB_H6M",
"RHS_AH1Z_wd",
"RHS_UH1Y_FFAR",
"C_Heli_Light_01_civil_F",
"RHS_Mi8amt_civilian",
"RHS_AH64D_wd",
"RHS_CH_47F"
];

STWG_COMBAT_BOATS=["B_Boat_Armed_01_minigun_F","O_Boat_Armed_01_hmg_F"];
STWG_NUMBER_OF_COMBAT_BOATS=3;

STWG_ADDITIONAL_STRATEGICAL_RECTANGULAR_AREAS=[
 [[[2149.18,8132.7,0], [2873.51,7283.76,0]] , "Selva1"],
 [[[3056.53,7937.99,0],[4240.38,6968.33,0]], "Selva2"],
 [[[4563.6,6473.76,0],[5622.83,5671.55,0]], "Selva3"]
];

STWG_UNITRADAR_INFO_BOOL = false;

#endif