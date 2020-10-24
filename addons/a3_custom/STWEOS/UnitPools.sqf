private ["_tempArray","_InfPool","_MotPool","_ACHPool","_CHPool","_uavPool","_stPool","_shipPool","_diverPool","_crewPool","_heliCrew","_ArmPool"];
_faction=(_this select 0);
_type=(_this select 1);
_tempArray=[];

// EAST CSAT FACTION
	if (_faction==0) then {
	_InfPool=	["O_SoldierU_SL_F","O_soldierU_repair_F","O_soldierU_medic_F","O_sniper_F","O_Soldier_A_F","O_Soldier_AA_F","O_Soldier_AAA_F","O_Soldier_AAR_F","O_Soldier_AAT_F","O_Soldier_AR_F","O_Soldier_AT_F","O_soldier_exp_F","O_Soldier_F","O_engineer_F","O_engineer_U_F","O_medic_F","O_recon_exp_F","O_recon_F","O_recon_JTAC_F","O_recon_LAT_F","O_recon_M_F","O_recon_medic_F","O_recon_TL_F"];	
	_ArmPool=	["O_APC_Tracked_02_AA_F","O_APC_Tracked_02_cannon_F","O_APC_Wheeled_02_rcws_F","O_MBT_02_arty_F","O_MBT_02_cannon_F"];
	_MotPool=	["O_Truck_02_covered_F","O_Truck_02_transport_F","O_MRAP_02_F","O_MRAP_02_gmg_F","O_MRAP_02_hmg_F","O_Truck_02_medical_F"];
	_ACHPool=	["O_Heli_Attack_02_black_F","O_Heli_Attack_02_F"];
	_CHPool=	["O_Heli_Light_02_F","O_Heli_Light_02_unarmed_F"];
	_uavPool=	["O_UAV_01_F","O_UAV_02_CAS_F","O_UGV_01_rcws_F"];
	_stPool=	["O_Mortar_01_F","O_static_AT_F","O_static_AA_F"];
	_shipPool=	["O_Boat_Armed_01_hmg_F","O_Boat_Transport_01_F"];
	_diverPool=	["O_diver_exp_F","O_diver_F","O_diver_TL_F"];
	_crewPool=	["O_crew_F"];
	_heliCrew=	["O_helicrew_F","O_helipilot_F"];
};
// WEST NATO FACTION	
	if (_faction==1) then {
	_InfPool=	["B_sniper_F","B_Soldier_A_F","B_Soldier_AA_F","B_Soldier_AAA_F","B_Soldier_AAR_F","B_Soldier_AAT_F","B_Soldier_AR_F","B_Soldier_AT_F","B_soldier_exp_F","B_Soldier_F","B_engineer_F","B_medic_F","B_recon_exp_F","B_recon_F","B_recon_JTAC_F","B_recon_LAT_F","B_recon_M_F","B_recon_medic_F","B_recon_TL_F"];	
	_ArmPool=	["B_MBT_01_arty_F","B_MBT_01_cannon_F","B_MBT_01_mlrs_F","B_APC_Tracked_01_AA_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_rcws_F","B_APC_Wheeled_01_cannon_F","B_MBT_02_cannon_F"];
	_MotPool=	["B_Truck_01_covered_F","B_Truck_01_transport_F","B_MRAP_01_F","B_MRAP_01_gmg_F","B_MRAP_01_hmg_F","B_Truck_01_medical_F"];
	_ACHPool=	["B_Heli_Attack_01_F","B_Heli_Light_01_armed_F"];
	_CHPool=	["B_Heli_Light_01_F","B_Heli_Transport_01_camo_F","B_Heli_Transport_01_F"];
	_uavPool=	["B_UAV_01_F","B_UAV_01_CAS_F","B_UGV_01_rcws_F"];
	_stPool=	["B_Mortar_01_F","B_static_AT_F","B_static_AA_F"];
	_shipPool=	["B_Boat_Armed_01_minigun_F","B_Boat_Transport_01_F"];
	_diverPool=	["B_diver_exp_F","B_diver_F","B_diver_TL_F"];
	_crewPool=	["B_crew_F"];
	_heliCrew=	["B_helicrew_F","B_helipilot_F"];
};
// INDEPENDENT AAF FACTION	
	if (_faction==2) then {
	_InfPool=	["I_engineer_F","I_Soldier_A_F","I_Soldier_AA_F","I_Soldier_AAA_F","I_Soldier_AAR_F","I_Soldier_AAT_F","I_Soldier_AR_F","I_Soldier_AT_F","I_Soldier_exp_F","I_soldier_F","I_Soldier_GL_F","I_Soldier_repair_F"];	
	_ArmPool=	["I_APC_Wheeled_03_cannon_F"];
	_MotPool=	["I_MRAP_03_F","I_MRAP_03_gmg_F","I_MRAP_03_hmg_F","I_Truck_02_medical_F"];
	_ACHPool=	[];
	_CHPool=	["I_Heli_Transport_02_F","B_Heli_Light_02_unarmed_F"];
	_uavPool=	["I_UAV_01_F","I_UAV_02_CAS_F","I_UGV_01_rcws_F"];
	_stPool=	["I_Mortar_01_F"];
	_shipPool=	["I_Boat_Transport_01_F","I_G_Boat_Transport_01_F","I_Boat_Armed_01_minigun_F"];
	_diverPool=	["I_diver_exp_F","I_diver_F","I_diver_TL_F"];
	_crewPool=	["I_crew_F"];
	_heliCrew=	["I_helicrew_F","I_helipilot_F"];
};
// CIVILIAN	
	if (_faction==3) then {
	_InfPool=	["C_man_1","C_man_1_1_F","C_man_1_2_F","C_man_1_3_F","C_man_hunter_1_F","C_man_p_beggar_F","C_man_p_beggar_F_afro","C_man_p_fugitive_F","C_man_p_shorts_1_F","C_man_pilot_F","C_man_polo_1_F","C_man_polo_2_F","C_man_polo_3_F","C_man_polo_4_F","C_man_polo_5_F","C_man_polo_6_F","C_man_shorts_1_F","C_man_shorts_2_F","C_man_shorts_3_F","C_man_shorts_4_F","C_man_w_worker_F"];	
	_ArmPool=	[]; //"C_Hatchback_01_F","C_Hatchback_01_sport_F","C_Quadbike_01_F","C_SUV_01_F","C_Van_01_transport_F","C_Van_01_box_F"];
	_MotPool=	[]; //"C_Hatchback_01_F","C_Hatchback_01_sport_F","C_Quadbike_01_F","C_SUV_01_F","C_Van_01_transport_F","C_Van_01_box_F"];
	_ACHPool=	[];
	_CHPool=	[];
	_uavPool=	[];
	_stPool=	[];
	_shipPool=	["C_Boat_Civil_01_F","C_Boat_Civil_01_rescue_F","C_Boat_Civil_04_F","C_Rubberboat"];
	_diverPool=	[];
	_crewPool=	["C_man_1"];
	_heliCrew=	["C_man_1","C_man_1"];
};
// WEST FIA FACTION
	if (_faction==4) then {
	_InfPool=	["B_G_engineer_F","B_G_medic_F","B_G_officer_F","B_G_Soldier_A_F","B_G_Soldier_AR_F","B_G_Soldier_exp_F","B_G_Soldier_F","B_G_Soldier_GL_F","B_G_Soldier_LAT_F","B_G_Soldier_lite_F","B_G_Soldier_M_F","B_G_Soldier_SL_F","B_G_Soldier_TL_F"];	
	_ArmPool=	[];
	_MotPool=	["B_G_Offroad_01_F","B_G_Offroad_01_armed_F","B_G_Van_01_transport_F","B_G_Van_01_fuel_F"];
	_ACHPool=	[];
	_CHPool=	[];
	_uavPool=	[];
	_stPool=	["B_G_Mortar_01_F"];
	_shipPool=	["B_G_Boat_Transport_01_F"];
	_diverPool=	[];
	_crewPool=	[];
	_heliCrew=	[];
};
// ADD CLASSNAMES 
	if (_faction==5) then {// RHS - Armed Forces of the Russian Federation VDV-EMR-DESERT
	_InfPool=[
		"rhs_vdv_des_aa",
		"rhs_vdv_des_at",
		"rhs_vdv_des_arifleman",
		"rhs_vdv_des_crew",
		"rhs_vdv_des_armoredcrew",
		"rhs_vdv_des_combatcrew",
		"rhs_vdv_des_crew_commander",
		"rhs_vdv_des_driver",
		"rhs_vdv_des_driver_armored",
		"rhs_vdv_des_efreitor",
		"rhs_vdv_des_engineer",
		"rhs_vdv_des_grenadier_rpg",
		"rhs_vdv_des_strelok_rpg_assist",
		"rhs_vdv_des_junior_sergeant",
		"rhs_vdv_des_machinegunner",
		"rhs_vdv_des_machinegunner_assistant",
		"rhs_vdv_des_marksman",
		"rhs_vdv_des_marksman_asval",
		"rhs_vdv_des_medic",
		"rhs_vdv_des_officer",
		"rhs_vdv_des_officer_armored",
		"rhs_vdv_des_rifleman",
		"rhs_vdv_des_rifleman_asval",
		"rhs_vdv_des_grenadier",
		"rhs_vdv_des_rifleman_lite",
		"rhs_vdv_des_LAT",
		"rhs_vdv_des_RShG2",
		"rhs_vdv_des_sergeant"
	];
	
	_ArmPool=[
	"rhs_btr60_vdv",
	"rhs_btr70_vdv",
	"rhs_btr80_vdv",
	"rhs_btr80a_vdv",
	"rhs_sprut_vdv",
	"rhs_t72ba_tv",
	"rhs_t72bb_tv",
	"rhs_t72bc_tv",
	"rhs_t72bd_tv",
	"rhs_t80",
	"rhs_t80a",
	"rhs_t80b",
	"rhs_t80bk",
	"rhs_t80bv",
	"rhs_t80bvk",
	"rhs_t80u",
	"rhs_t80u45m",
	"rhs_t80ue1",
	"rhs_t80uk",
	"rhs_t80um",
	"rhs_t90_tv",
	"rhs_t90a_tv"
];

	_MotPool=	[
		"RHS_BM21_MSV_01",
		"rhs_gaz66_msv",
		"rhs_gaz66_ammo_msv",
		"rhs_gaz66_flat_msv",
		"rhs_gaz66o_msv",
		"rhs_gaz66o_flat_msv",
		"rhs_gaz66_r142_msv",
		"rhs_gaz66_zu23_msv",
		"rhs_gaz66_ap2_msv",
		"rhs_gaz66_repair_msv",
		"rhs_kamaz5350_msv",
		"rhs_kamaz5350_flatbed_cover_msv",
		"rhs_kamaz5350_open_msv",
		"rhs_kamaz5350_flatbed_msv",
		"RHS_Ural_MSV_01",
		"RHS_Ural_Flat_MSV_01",
		"RHS_Ural_Fuel_MSV_01",
		"RHS_Ural_Open_MSV_01",
		"RHS_Ural_Open_Flat_MSV_01",
		"RHS_Ural_Repair_MSV_01",
		"RHS_Ural_Zu23_MSV_01",
		"rhs_tigr_msv",
		"rhs_tigr_3camo_msv",
		"rhs_tigr_sts_msv",
		"rhs_tigr_sts_3camo_msv",
		"rhs_tigr_m_msv",
		"rhs_tigr_m_3camo_msv",
		"RHS_UAZ_MSV_01",
		"rhs_uaz_open_MSV_01",
		"rhs_zsu234_aa",
		"rhs_bmp1_msv",
		"rhs_bmp1d_msv",
		"rhs_bmp1k_msv",
		"rhs_bmp1p_msv",
		"rhs_bmp2e_msv",
		"rhs_bmp2_msv",
		"rhs_bmp2d_msv",
		"rhs_bmp2k_msv",
		"rhs_bmp3_msv",
		"rhs_bmp3_late_msv",
		"rhs_bmp3m_msv",
		"rhs_bmp3mera_msv",
		"rhs_brm1k_msv",
		"rhs_Ob_681_2",
		"rhs_prp3_msv"
		];
	_ACHPool=	[
		"RHS_Ka52_vvs",
		"rhs_ka60_grey",
		"RHS_Mi24P_vvs",
		"RHS_Mi24V_vvs",
		"RHS_Mi24Vt_vvs",
		"rhs_mi28n_vvs"
	];
	_CHPool=	["RHS_Mi8mt_Cargo_vvs","RHS_Mi8mtv3_Cargo_vvs"];
	_uavPool=	["rhs_pchela1t_vvs","O_UAV_01_F","O_UAV_02_CAS_F","O_UGV_01_rcws_F"];
	_stPool=	[ 
		"rhs_Metis_9k115_2_vmf",
		"rhs_Kornet_9M133_2_vmf",
		"rhs_Igla_AA_pod_vmf",
		"RHS_AGS30_TriPod_VMF",
		"rhs_KORD_VMF",
		"rhs_KORD_high_VMF",
		"RHS_NSV_TriPod_VMF",
		"rhs_SPG9M_VMF"
	];
	_shipPool=	["O_Boat_Armed_01_hmg_F","O_Boat_Transport_01_F"];
	_diverPool=	["O_diver_exp_F","O_diver_F","O_diver_TL_F"];
	_crewPool=	["rhs_msv_crew","rhs_vdv_des_machinegunner",
				"rhs_vdv_des_machinegunner_assistant",
				"rhs_vdv_des_marksman","rhs_vdv_des_marksman_asval","rhs_vdv_des_at"];
	_heliCrew=	["rhs_pilot_combat_heli","rhs_msv_grenadier","rhs_msv_machinegunner","rhs_msv_at","rhs_vdv_des_marksman"];
	};
	
// ADD CLASSNAMES 	
	if (_faction==6) then { //FFAA
	_InfPool=	[
		"ffaa_et_moe_at","ffaa_et_moe_at_C90","ffaa_brilat_ingeniero",
		"ffaa_et_moe_sabot","ffaa_et_moe_lg","ffaa_et_moe_lider","ffaa_brilat_mg4","ffaa_brilat_mg42",
		"ffaa_brilat_tirador","ffaa_et_moe_tirador","ffaa_brilat_medico","ffaa_et_moe_mg","ffaa_brilat_nbq",
		"ffaa_brilat_oficial","ffaa_brilat_soldado","ffaa_brilat_tirador_ameli","ffaa_brilat_fusilero_mochila",
		"ffaa_brilat_alcotan","ffaa_brilat_c90","ffaa_brilat_granadero","ffaa_et_moe_fusilero_mochila",
		"ffaa_et_moe_medico","ffaa_et_moe_sl","ffaa_brilat_francotirador_accuracy",
		"ffaa_brilat_francotirador_barrett","ffaa_brilat_observador","ffaa_brilat_jefe_escuadra",
		"ffaa_brilat_proveedor_mg4","ffaa_brilat_proveedor_spike"
		];	
	_ArmPool=	[
		"ffaa_et_leopardo","ffaa_et_pizarro_mauser","ffaa_et_toa_m2","ffaa_et_toa_ambulancia",
		"ffaa_et_toa_zapador","ffaa_et_toa_spike","ffaa_et_toa_mando"
	];
	_MotPool=	[
		"ffaa_et_anibal",
		"ffaa_et_m250_municion_blin",
		"ffaa_et_m250_combustible_blin",
		"ffaa_et_m250_recuperacion_blin",
		"ffaa_et_m250_carga_blin",
		"ffaa_et_m250_repara_municion_blin",
		"ffaa_et_m250_carga_lona_blin",
		"ffaa_et_m250_sistema_nasams_blin",
		"ffaa_et_m250_estacion_nasams_blin",
		"ffaa_et_pegaso_municion",
		"ffaa_et_pegaso_combustible",
		"ffaa_et_pegaso_carga",
		"ffaa_et_pegaso_repara_municion",
		"ffaa_et_pegaso_carga_lona",
		"ffaa_et_rg31_samson",
		"ffaa_et_vamtac_lag40",
		"ffaa_et_vamtac_m2",
		"ffaa_et_vamtac_tow",
		"ffaa_et_vamtac_ume",
		"ffaa_et_vamtac_cardom",
		"ffaa_et_vamtac_crows",
		"ffaa_et_vamtac_mistral"
	];
	_ACHPool=	["ffaa_famet_tigre_aa","ffaa_famet_tigre_at","ffaa_famet_tigre_cas"];
	_CHPool=	["ffaa_famet_cougar_olive","ffaa_famet_cougar","ffaa_famet_ch47_mg","ffaa_famet_ch47_des_mg"];
	_uavPool=	["ffaa_et_searcherIII","ffaa_reaper_observador","ffaa_reaper_gbu","ffaa_reaper_maverick","ffaa_reaper_multirrol"];
	_stPool=	["B_Mortar_01_F","B_static_AT_F","B_static_AA_F"];
	_shipPool=	["ffaa_ar_supercat","ffaa_ar_zodiac_hurricane","ffaa_ar_zodiac_hurricane_long"];
	_diverPool=	["B_diver_exp_F","B_diver_F","B_diver_TL_F"];
	_crewPool=	["ffaa_brilat_carrista"];
	_heliCrew=	["ffaa_piloto_tigre_famet","ffaa_crew_famet","ffaa_piloto_famet"];
};
	
// ADD CLASSNAMES 	
	if (_faction==7) then {
	_InfPool=	[
		"Haji_Matin",
		"TBan_Fighter2",
		"TBan_Fighter2NH",
		"TBan_Fighter3",
		"TBan_Fighter3NH",
		"TBan_Fighter4",
		"TBan_Fighter5",
		"TBan_Fighter6",
		"TBan_Fighter6NH",
		"TBan_Fighter1",
		"TBan_Fighter1NH",
		"TBan_Recruit",
		"TBan_Recruit1NH",
		"TBan_Recruit2",
		"TBan_Recruit2NH",
		"TBan_Recruit5",
		"TBan_Recruit6",
		"TBan_Recruit6NH",
		"TBan_Sniper",
		"TBan_Recruit3",
		"TBan_Recruit3NH",
		"TBan_Recruit4",
		"TBan_Warlord"
		];	
	_ArmPool=["rhs_sprut_vdv","rhs_bmp1p_msv","rhs_brm1k_msv","rhs_bmp2_msv","rhs_bmp2e_msv","rhs_bmp2d_msv",
		"rhs_bmp2k_msv","rhs_prp3_msv","rhs_bmd4_vdv","rhs_bmd4ma_vdv","rhs_t80u","rhs_t80bv","rhs_t80a","rhs_t72bc_tv",
		"rhs_t72bb_tv","rhs_zsu234_aa"];

	_MotPool=	["Tban_O_Offroad_01_F","RHS_Ural_MSV_01","RHS_Ural_Fuel_MSV_01","RHS_Ural_VDV_01","rhs_typhoon_vdv","rhs_gaz66_repair_vdv",
	"RHS_Ural_Open_MSV_01"];
	_ACHPool=	["RHS_Mi24P_vvsc","RHS_Mi24V_vvsc","RHS_Ka52_vvs","RHS_Ka52_UPK23_vvs","rhs_mi28n_vvs","rhs_mi28n_s13_vvs"];
	_CHPool=	["Cha_Mi24_P","Cha_Mi24_V","O_Heli_Light_02_F","O_Heli_Light_02_unarmed_F"];
	_uavPool=	["O_UAV_01_F","O_UAV_02_CAS_F","O_UGV_01_rcws_F"];
	_stPool=	["O_Mortar_01_F","O_HMG_01_high_F","O_static_AT_F","O_static_AA_F"];
	_shipPool=	["O_Boat_Armed_01_hmg_F","O_Boat_Transport_01_F"];
	_diverPool=	["O_diver_exp_F","O_diver_F","O_diver_TL_F"];
	_crewPool=	["rhs_msv_crew"];
	_heliCrew=	["rhs_msv_grenadier","rhs_msv_machinegunner","rhs_msv_at"];
};

// ADD CLASSNAMES 	RHS WEST
	if (_faction==8) then {
	_InfPool=	[
		"rhsusf_army_ucp_rifleman_101st",
"rhsusf_army_ucp_rifleman_10th",
"rhsusf_army_ucp_rifleman_1stcav",
"rhsusf_army_ucp_rifleman_82nd",
"rhsusf_army_ucp_aa",
"rhsusf_army_ucp_javelin_assistant",
"rhsusf_army_ucp_javelin",
"rhsusf_army_ucp_maaws",
"rhsusf_army_ucp_autorifleman",
"rhsusf_army_ucp_autoriflemana",
"rhsusf_army_ucp_rifleman_m590",
"rhsusf_army_ucp_medic",
"rhsusf_army_ucp_fso",
"rhsusf_army_ucp_grenadier",
"rhsusf_army_ucp_engineer",
"rhsusf_army_ucp_machinegunner",
"rhsusf_army_ucp_machinegunnera",
"rhsusf_army_ucp_marksman",
"rhsusf_army_ucp_officer",
"rhsusf_army_ucp_rifleman",
"rhsusf_army_ucp_riflemanl",
"rhsusf_army_ucp_riflemanat",
"rhsusf_army_ucp_rifleman_m16",
"rhsusf_army_ucp_rifleman_m4",
"rhsusf_army_ucp_sniper",
"rhsusf_army_ucp_sniper_m107",
"rhsusf_army_ucp_sniper_m24sws",
"rhsusf_army_ucp_squadleader",
"rhsusf_army_ucp_teamleader",
"rhsusf_army_ucp_uav"
		];	
	_ArmPool=[
"rhsusf_m113_usarmy_supply",
"rhsusf_m113_usarmy",
"rhsusf_m113_usarmy",
"rhsusf_m113_usarmy_M2_90",
"rhsusf_m113_usarmy_M240",
"rhsusf_m113_usarmy_medical",
"rhsusf_m113_usarmy_MK19",
"rhsusf_m113_usarmy_MK19_90",
"rhsusf_m113_usarmy_unarmed",
"rhsusf_m1a1aimwd_usarmy",
"rhsusf_m1a1aim_tuski_wd",
"rhsusf_m1a2sep1wd_usarmy",
"rhsusf_m1a2sep1tuskiwd_usarmy",
"rhsusf_m1a2sep1tuskiiwd_usarmy"
];

	_MotPool=	[
	"rhsusf_M1117_W",
"rhsusf_M1220_usarmy_wd",
"rhsusf_M1220_M153_M2_usarmy_wd",
"rhsusf_M1220_M2_usarmy_wd",
"rhsusf_M1220_MK19_usarmy_wd",
"rhsusf_M1230_M2_usarmy_wd",
"rhsusf_M1230_MK19_usarmy_wd",
"rhsusf_M1230a1_usarmy_wd",
"rhsusf_M1232_usarmy_wd",
"rhsusf_M1232_M2_usarmy_wd",
"rhsusf_M1232_MK19_usarmy_wd",
"rhsusf_M1237_M2_usarmy_wd",
"rhsusf_M1237_MK19_usarmy_wd",
"rhsusf_M1078A1P2_WD_fmtv_usarmy",
"rhsusf_M1078A1P2_WD_flatbed_fmtv_usarmy",
"rhsusf_M1078A1P2_B_WD_fmtv_usarmy",
"rhsusf_M1078A1P2_B_WD_flatbed_fmtv_usarmy",
"rhsusf_M1078A1P2_B_M2_WD_fmtv_usarmy",
"rhsusf_M1078A1P2_B_M2_WD_flatbed_fmtv_usarmy",
"rhsusf_M1078A1P2_B_WD_CP_fmtv_usarmy",
"rhsusf_M1083A1P2_WD_fmtv_usarmy",
"rhsusf_M1083A1P2_B_WD_fmtv_usarmy",
"rhsusf_M1083A1P2_B_M2_WD_fmtv_usarmy",
"rhsusf_M1084A1P2_WD_fmtv_usarmy",
"rhsusf_M1084A1P2_B_M2_WD_fmtv_usarmy",
"rhsusf_M977A4_usarmy_wd",
"rhsusf_M977A4_AMMO_usarmy_wd",
"rhsusf_M977A4_REPAIR_usarmy_wd"
	];
	_ACHPool=	[
"RHS_AH64D_wd",
"RHS_AH1Z",
"RHS_UH1Y_FFAR_d",
"RHS_UH1Y_d"
	];
	_CHPool=	[
"RHS_CH_47F",
"RHS_UH60M",
"RHS_UH60M_ESSS",
"RHS_UH60M_MEV"	
	];
	_uavPool=	[
	"B_UAV_01_F",
	"B_UAV_01_CAS_F",
	"B_UGV_01_rcws_F"
	];
	_stPool=	[
"RHS_Stinger_AA_pod_WD",
"RHS_M2StaticMG_WD",
"RHS_M2StaticMG_MiniTripod_WD",
"RHS_TOW_TriPod_WD",
"RHS_MK19_TriPod_WD"	
	];
	_shipPool=	[
	"rhsusf_mkvsoc",
	"B_Boat_Armed_01_minigun_F",
	"B_Boat_Transport_01_F"
	];

	_diverPool=	["B_diver_exp_F","B_diver_F","B_diver_TL_F"];
	
	_crewPool=	["rhsusf_army_ucp_machinegunner",
				"rhsusf_army_ucp_machinegunnera",
				"rhsusf_army_ucp_marksman"
	];
	_heliCrew=	[
	"rhsusf_army_ucp_machinegunner",
	"rhsusf_army_ucp_machinegunnera",
	"rhsusf_army_ucp_marksman"
	];
};

	
////////////////////////////////////////////////////////////////////////////////////////
if (_type==0) then {
		for "_i" from 0 to 5 do{
		_unit=_InfPool select (floor(random(count _InfPool)));
		_tempArray set [count _tempArray,_unit];};
						};
						
if (_type==1) then {_tempArray=_diverPool};
	
				
// CREATE ARMOUR & CREW			
if (_type==2) then {
				_tempUnit=_ArmPool select (floor(random(count _ArmPool)));
				_temparray set [count _temparray,_tempUnit];
				_crew=_crewPool select (floor(random(count _crewPool)));
				_temparray set [count _temparray,_crew];
};

// CREATE ATTACK CHOPPER & CREW	
if (_type==3) then {
				_tempUnit=_ACHPool select (floor(random(count _ACHPool)));
				_temparray set [count _temparray,_tempUnit];
				_crew=_heliCrew select (floor(random(count _heliCrew)));
				_temparray set [count _temparray,_crew];
};

// CREATE TRANSPORT CHOPPER & CREW		
if (_type==4) then {
				_tempUnit=_CHPool select (floor(random(count _CHPool)));
				_temparray set [count _temparray,_tempUnit];
				_crew=_heliCrew select (floor(random(count _heliCrew)));
				_temparray set [count _temparray,_crew];
						};
						
// CREATE STATIC & CREW						
if (_type==5) then {
				_tempUnit=_stPool select (floor(random(count _stPool)));
				_temparray set [count _temparray,_tempUnit];
				_crew=_crewPool select (floor(random(count _crewPool)));
				_temparray set [count _temparray,_crew];

};
if (_type==6) then {_tempArray=_uavPool select (floor(random(count _uavPool)));};

// CREATE TRANSPORT & CREW
if (_type==7) then {
				_tempUnit=_MotPool select (floor(random(count _MotPool)));
				_temparray set [count _temparray,_tempUnit];
				_crew=_crewPool select (floor(random(count _crewPool)));
				_temparray set [count _temparray,_crew];
				};

// CREATE BOAT & DIVER CREW
if (_type==8) then {
				_tempUnit=_shipPool select (floor(random(count _shipPool)));
				_temparray set [count _temparray,_tempUnit];
				_crew=_diverPool select (floor(random(count _diverPool)));
				_temparray set [count _temparray,_crew];
				};
				
// CREATE CARGO
if (_type==9) then {
		for "_i" from 0 to 4 do{
			_unit=_InfPool select (floor(random(count _InfPool)));
			_temparray set [count _temparray,_unit];
							};
};

// CREATE DIVER CARGO
if (_type==10) then {
		for "_i" from 0 to 4 do{
			_unit=_diverPool select (floor(random(count _diverPool)));
			_temparray set [count _temparray,_unit];
							};			
};

//hint format ["%1",_tempArray];
_tempArray