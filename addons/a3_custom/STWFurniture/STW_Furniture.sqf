/*
STW FURNITURE - Ambient furniture

To use: 
1 - Save this script into your mission directory as e.g. tpw_furniture.sqf
2 - Call it with 0 = [50,5] execvm "STW_furniture.sqf";  where the numbers represent (in order):

50 = radius (m) around player to scan for houses to furnish
5 = time (sec) in between house scans
*/

if (!isServer) exitWith{};
waitUntil {(count ([] call BIS_fnc_listPlayers))>0};

diag_log "////////////////////// FURNITURE ///////////////////////";
//if (!((name player)=="Cpt Horny")) exitWith {};
//if (!isDedicated) exitWith {};
//if ((count _this) < 2) exitWith {hint "TPW FURNITURE incorrect/no config, exiting."};
//WaitUntil {!isNull FindDisplay 46};
 
// VARIABLES
tpw_furniture_radius = _this select 0; // radius (m) around player to scan for houses to spawn furniture 
tpw_furniture_scantime = _this select 1; // time (sec) in between house scans

stw_furniture_houses = [] call stwfList_construct; // houses with furniture
tpw_furniture_lastpos = [0,0,0]; // last position of player

// FURNISH HOUSE
tpw_furniture_fnc_populate =
	{
	private ["_bld","_type","_items","_item","_offset","_angle","_bld","_pos","_spawned","_templates"];
	_bld = _this select 0;
	_type = typeof _bld;
	
	// Skip previously identified non houses
	if (_bld getvariable ["tpw_furnished",0] == -1) exitwith {};
	
	// Assign appropriate furnishing template for house			
	if (_bld getvariable ["tpw_furnished",0] == 0) then
		{
		switch _type do
			{
			// TANOA
			case "Land_House_Small_01_F":
				{
				_templates = [[["Land_TablePlastic_01_F",[-4.39307,1.2832,-0.699362],88.2366],["Land_ChairPlastic_F",[-5.41113,1.27539,-0.699363],4.16151],["Land_ChairPlastic_F",[-3.12256,0.893555,-0.699363],176.193],["Land_ChairPlastic_F",[-4.40723,3.01758,-0.699363],251.962],["Land_ChairPlastic_F",[-4.42139,-0.375977,-0.699363],79.3795],["Land_WoodenTable_large_F",[-4.95117,-3.03711,-0.699362],90.9798],["Land_WoodenCounter_01_F",[0.318848,2.27832,-0.699363],90.7001],["Land_WoodenTable_small_F",[1.84277,3.00781,-0.699362],181.198],["Land_ShelvesWooden_F",[1.47559,-1.9873,-0.699363],1.68573],["Land_Metal_rack_Tall_F",[6.17578,2.85449,-0.699363],-90.9498],["Land_ChairWood_F",[2.92529,3.0498,-0.699362],-9.95035],["Land_ChairWood_F",[1.91602,1.67285,-0.699362],144.447],["Fridge_01_closed_F",[5.9502,-3.23047,-0.699363],178.229],["Land_Basket_F",[1.72754,-3.37402,-0.699362],132.784],["Land_Sack_F",[5.79102,-1.53223,-0.699362],-54.0081],["Land_Sack_F",[5.9165,0.0205078,-0.699362],-4.26343],["Land_CratesShabby_F",[5.82422,1.44629,-0.699363],0.10672],["Land_PlasticCase_01_large_F",[0.361816,-1.42383,-0.699363],-0.384552]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	
			case "Land_House_Small_02_F":
				{
				_templates = [[["Land_PlasticCase_01_large_F",[-3.80566,0.600586,-0.714201],270.116],["Land_BarrelWater_F",[-4.06494,1.47998,-0.714201],212.719],["Land_BarrelWater_F",[-3.91357,4.53906,-0.714201],206.741],["Land_Sacks_heap_F",[-3.75098,5.45117,-0.714201],173.155],["Fridge_01_closed_F",[-0.367188,0.784668,-0.714201],178.862],["Land_Microwave_01_F",[0.33252,0.619141,-0.714201],191.194],["Land_ShelvesWooden_F",[-4.18115,3.19238,-0.714201],-0.175385],["Land_WoodenCounter_01_F",[-3.90479,-3.41016,-0.714201],268.449],["Land_WoodenTable_small_F",[-0.106934,-5.19629,-0.714201],179.695],["Land_RattanChair_01_F",[-1.24609,-5.4043,-0.714201],104.568],["Land_CampingChair_V1_F",[-0.227539,-3.08984,-0.714201],16.8977],["Land_ChairPlastic_F",[-1.15967,-4.07422,-0.714201],344.842]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};			
			case "Land_House_Small_03_F":
				{
				_templates = [[["Land_WoodenTable_large_F",[-3.04688,-1.09473,-1.32258],-177.826],["Land_ChairWood_F",[-4.02051,-1.66113,-1.32258],102.879],["Land_ChairWood_F",[-3.95264,-0.40918,-1.32258],72.8789],["Land_ChairWood_F",[-2.96143,0.394531,-1.32258],1.36459],["Land_ShelvesWooden_F",[-2.70898,3.6416,-1.32258],-180.168],["Land_ShelvesWooden_F",[-3.58252,5.09668,-1.32258],-89.0166],["Fridge_01_closed_F",[-6.14307,5.00391,-1.32258],0.283615],["Land_BarrelWater_F",[-5.05859,4.875,-1.32258],-12.9616],["Land_PlasticCase_01_small_F",[-2.63818,2.64941,-1.32258],-0.86998],["Land_Sacks_goods_F",[-5.83984,2.27734,-1.32258],146.318],["Land_Sack_F",[-5.77539,0.879883,-1.32258],-183.514],["Land_Sack_F",[-5.87988,-1.62305,-1.32258],-74.1766],["Land_Sacks_heap_F",[2.4209,-1.18457,-1.32258],79.303],["Land_CanisterPlastic_F",[2.64453,0.347656,-1.32258],2.86423],["Land_GasTank_01_blue_F",[2.66113,1.92578,-1.32258],2.86423],["Land_Basket_F",[0.0766602,-1.71875,-1.32258],-7.47496],["Land_Basket_F",[-1.5332,2.85645,-1.32258],-140.148],["Land_Metal_rack_Tall_F",[-1.91113,4.40332,-1.32258],91.9407],["Land_Metal_rack_Tall_F",[0.318359,4.99023,-1.32258],-1.69688]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
			case "Land_House_Small_04_F":
				{
				_templates = [[["Land_WoodenTable_large_F",[-1.66309,-3.93457,-0.864875],-180.002],["Land_RattanChair_01_F",[-0.495117,-4.66602,-0.86476],-185.523],["Land_RattanChair_01_F",[-0.614258,-3.41992,-0.864752],-95.9327],["Land_RattanChair_01_F",[-1.5791,-2.18408,-0.86497],-10.4366],["Land_WoodenCounter_01_F",[3.91211,-2.41406,-0.86588],91.3104],["Land_ShelvesWooden_F",[0.543945,1.9248,-0.865171],-174.964],["Land_Sacks_goods_F",[0.27002,3.65137,-0.86414],-63.6292],["Land_Basket_F",[0.648438,0.700684,-0.865187],-115.737]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	
			case "Land_House_Small_06_F":
				{
				_templates = [[["Land_TablePlastic_01_F",[-1.41699,-4.63379,-1.00068],-178.977],["Land_ChairPlastic_F",[0.0175781,-3.98975,-1.00068],-132.682],["Land_ChairPlastic_F",[-2.93457,-3.97656,-1.00068],-32.8382],["Land_ChairPlastic_F",[-1.40234,-3.51807,-1.00068],-84.6655],["Land_WoodenTable_large_F",[-2.25391,1.56348,-1.00068],-88.8574],["Land_WoodenCounter_01_F",[1.86621,-3.7085,-1.00068],91.8469],["Land_Metal_rack_F",[2.27832,0.189453,-1.00068],-90.243],["Land_Basket_F",[-4.02246,1.79492,-1.00068],45.8277],["Land_Sack_F",[-3.87305,0.850586,-1.00068],77.0597],["Land_Sack_F",[-4.0918,-0.185547,-1.00068],-177.337],["Land_PlasticCase_01_small_F",[-3.97559,-5.03857,-1.00068],-89.3508],["Land_CanisterFuel_F",[-3.97266,-4.03271,-1.00068],-53.4766]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
			case "Land_House_Big_01_F":
				{
				_templates = [[["Land_WoodenTable_large_F",[2.51563,1.57227,-1.01143],-180.482],["Land_ChairWood_F",[1.22559,1.70557,-1.01143],93.6551],["Land_ChairWood_F",[2.63184,2.96729,-1.01143],10.7773],["Land_ChairWood_F",[3.37012,1.15137,-1.01143],-79.5892],["Land_WoodenCounter_01_F",[7.20313,2.05859,-1.01143],87.9852],["Land_ShelvesWooden_F",[4.16992,5.7085,-1.01143],-92.8692],["Fridge_01_closed_F",[0.169922,5.68506,-1.01143],1.6033],["Land_Basket_F",[7.26465,-1.00049,-1.01143],-172.424],["Land_CratesShabby_F",[5.89941,-0.901855,-1.01143],-0.59993],["Land_Sack_F",[5.00977,-1.01514,-1.01143],-40.0437],["Land_BarrelWater_F",[7.30469,3.63818,-1.01143],77.9324],["Land_PlasticCase_01_large_F",[0.0273438,2.56982,-1.01143],-182.23]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};			
			case "Land_House_Big_02_F":
				{
				_templates = [[["Land_PlasticCase_01_large_F",[-5.98486,8.17578,-1.44058],180.522],["Land_CanisterFuel_F",[-6.03906,9.34473,-1.44053],136.607],["Land_ShelvesMetal_F",[-3.99219,9.05273,-1.44107],88.2645],["Land_Metal_rack_F",[-4.9082,0.816406,-1.44189],-88.5925],["OfficeTable_01_new_F",[-8.08594,3.51758,-1.4409],-5.07813],["Land_OfficeChair_01_F",[-8.14063,2.46973,-1.44077],-114.886],["Land_OfficeCabinet_01_F",[-9.00439,-0.982422,-1.44071],180.356],["Land_OfficeCabinet_01_F",[-0.245117,1.78418,-1.44048],89.8227],["Land_ChairWood_F",[3.25244,3.43164,-1.44094],6.48524],["Land_ChairWood_F",[4.23975,3.52734,-1.44171],-40.5042],["Land_GasTank_01_blue_F",[-1.80469,8.89453,-1.44106],-1.05878],["Land_CanisterPlastic_F",[-1.02783,9.1543,-1.44078],18.5195]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};			
			case "Land_House_Big_03_F":
				{
				_templates = [[["Land_BarrelWater_F",[2.34912,-5.07373,-3.17353],-206.69],["Land_PlasticCase_01_large_F",[2.0957,-3.8335,-3.17353],-179.769],["Land_CanisterFuel_F",[2.41699,-2.58105,-3.17353],-197.168],["Land_CanisterFuel_F",[2.44434,-1.86084,-3.17353],-167.169],["Land_Metal_rack_Tall_F",[3.46826,-0.779785,-3.17353],2.39783],["Land_Metal_rack_Tall_F",[4.4751,-0.949707,-3.17353],-0.0993805],["Land_TablePlastic_01_F",[9.5,0.535156,-3.17353],-181.059],["Land_ChairPlastic_F",[10,1.60742,-3.17353],-123.364],["Land_ChairPlastic_F",[8.32559,0.975098,-3.17353],-9.52327],["Land_ShelvesWooden_F",[1.60938,3.69238,-3.17353],-90.8741],["Land_OfficeCabinet_01_F",[3.71582,3.78906,-0.0890994],-2.41085],["Land_RattanChair_01_F",[3.49951,-2.45996,-0.0890989],-230.299],["Land_RattanChair_01_F",[5.23145,-2.48486,-0.0890989],-185.076],["Land_Sleeping_bag_folded_F",[7.32861,3.19482,-0.0890989],-308.796],["Land_Ground_sheet_folded_blue_F",[7.83594,2.91748,-0.0890994],39.2727],["Land_LuggageHeap_02_F",[6.19922,3.49609,-0.0890989],-288.367],["Land_LuggageHeap_03_F",[7.05762,-2.4668,-0.0890994],-141.923]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};			
			case "Land_House_Big_04_F":
				{
				_templates = [[["Land_Sleeping_bag_blue_F",[-5.67578,2.2915,0.301346],1.78235],["Land_Pillow_old_F",[-5.51465,4.83984,0.302036],27.523],["Land_ShelvesWooden_F",[-2.45117,4.20264,0.301067],-91.9971],["Land_Sleeping_bag_blue_folded_F",[-5.65039,4.24902,0.301777],-11.0885],["Land_Sleeping_bag_F",[3.95215,3.87979,0.303612],179.422],["Land_Pillow_grey_F",[4.00977,2.03955,0.302792],204.04],["Land_Pillow_grey_F",[3.92871,2.64697,0.303185],192.524],["Land_Sleeping_bag_folded_F",[4.23535,2.05908,0.303478],183.55],["Land_Ground_sheet_folded_blue_F",[2.24512,4.5376,0.302521],212.019],["Land_CampingChair_V1_F",[2.73438,2.56836,0.303806],173.04],["Land_CampingChair_V1_F",[3.13574,3.7959,0.302563],-74.2686],["Land_CampingTable_small_F",[-2.37109,2.02344,0.304775],176.863],["Land_TablePlastic_01_F",[3.61816,-2.25684,-2.94675],-94.3656],["Land_ChairPlastic_F",[2.48047,-1.13037,-2.94786],-61.4986],["Land_ChairPlastic_F",[2.13477,-2.30713,-2.94786],-16.4986],["Land_ChairPlastic_F",[2.44922,-3.58545,-2.94786],43.5013],["Land_WoodenTable_large_F",[-3.94727,-4.12549,-2.94534],-89.8305],["Land_WoodenCounter_01_F",[-0.922852,-0.937988,-2.94878],183.926]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
			case "Land_Slum_01_F":
				{
				_templates = [[["Land_WoodenTable_large_F",[5.16748,0.111328,0.670929],-0.11588],["Land_WoodenCounter_01_F",[1.82422,2.00293,0.669987],-180.655],["Land_ChairWood_F",[4.75977,-1.7666,0.670929],-219.372],["Land_ChairWood_F",[4.27051,-0.113281,0.670929],-265.684],["Land_CampingChair_V1_F",[5.18213,1.84082,0.670895],-312.999],["Land_Basket_F",[3.20801,-1.6582,0.670658],-12.1951],["Land_Basket_F",[2.38818,-1.66504,0.670658],-327.195],["Land_CratesShabby_F",[-0.475195,0.363281,0.668991],-93.0426]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	
			case "Land_Slum_02_F":
				{
				_templates = [[["Land_Basket_F",[-2.24756,4.38965,0.18475],194.435],["Land_CratesShabby_F",[-0.16084,4.42344,0.18454],182.289],["Land_Sack_F",[0.816406,4.2041,0.184204],161.705],["Land_Sack_F",[1.7666,4.26563,0.183887],92.0912],["Land_Sacks_goods_F",[1.93262,1.24023,0.183758],59.8842],["Land_BarrelWater_F",[-1.23413,4.33203,0.184875],187.171],["Land_Sacks_heap_F",[-2.12378,-3.71875,0.185604],-83.6961],["Land_WoodenTable_large_F",[1.89355,-3.18945,0.184761],2.58131],["Land_RattanChair_01_F",[0.328125,-2.64746,0.184475],19.4736]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
			case "Land_Slum_03_F":
				{
				_templates = [[["Land_TablePlastic_01_F",[-2.72852,5.0791,-0.648022],-89.7099],["Land_ChairPlastic_F",[-1.53516,5.33008,-0.648022],-178.257],["Land_ChairPlastic_F",[-4.05469,5.4873,-0.648018],-40.9423],["Land_ShelvesWooden_F",[0.0556641,3.10107,-0.648018],-181.728],["Land_ShelvesWooden_F",[0.93457,3.46484,-0.648018],0.227974],["Land_WoodenCounter_01_F",[5.0625,4.6123,-0.648018],-91.0826],["Land_WoodenCounter_01_F",[5.21387,1.49121,-0.648022],89.7324],["Land_ChairWood_F",[1.37012,2.55762,-0.648022],53.3668],["Land_Metal_rack_F",[-4.97949,1.00342,-0.648018],91.9733],["Fridge_01_closed_F",[-4.80371,-0.822266,-0.648018],90.3232],["Land_Basket_F",[-0.386719,1.2207,-0.648014],-71.3866],["Land_Basket_F",[0.227539,-1.51172,-0.648018],-105.558],["Land_Sack_F",[-1.11328,-1.46484,-0.648018],-117.807],["Land_CanisterPlastic_F",[-4.8623,0.0283203,-0.648018],-223.503]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
			case "Land_Shop_Town_01_F":
				{
				_templates =[[["Land_Icebox_F",[-4.02148,-2.92139,-3.24347],92.0958],["Land_Icebox_F",[-4.01514,-0.605957,-3.24347],91.9758],["Land_CashDesk_F",[-3.63477,1.08691,-3.2425],1.15862],["Land_Metal_rack_F",[-0.268555,1.41748,-3.2439],-88.9577],["Land_Metal_rack_F",[-0.209473,0.241211,-3.2439],-88.9535],["Land_ShelvesMetal_F",[1.79053,-2.99609,-3.24393],-90.3454],["Land_ShelvesMetal_F",[-1.69922,-1.50049,-3.24249],2.89784],["Land_TableDesk_F",[-3.65967,3.18359,-3.24315],1.18808],["Land_OfficeChair_01_F",[-3.87695,3.93604,-3.24315],1.18808],["Land_OfficeCabinet_01_F",[-4.13379,5.90625,-3.2425],-6.17105],["Land_OfficeCabinet_01_F",[-4.12402,5.80615,-3.2425],-6.57448]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	
			case "Land_Shop_Town_03_F":
				{
				_templates = [[["Land_CashDesk_F",[-4.51416,-0.11377,-3.35822],88.245],["Land_CashDesk_F",[-5.7417,-2.50293,-3.35822],2.76701],["Land_ShelvesMetal_F",[-4.13916,-3.99219,-3.35822],-90.0966],["Land_ShelvesMetal_F",[1.99072,-2.77979,-3.35822],-91.7501],["Land_Metal_rack_Tall_F",[1.14795,0.425293,-3.35822],-181.658],["Land_Metal_rack_Tall_F",[1.99951,0.310547,-3.35822],-181.658],["Land_Metal_rack_Tall_F",[3.08252,-0.0102539,-3.35822],-181.658],["Land_Metal_rack_Tall_F",[3.34668,0.628418,-3.35822],-180.214],["Land_WoodenTable_large_F",[3.18701,7.49609,-3.35822],-92.3368],["Land_RattanChair_01_F",[4.92383,7.3877,-3.35822],-125.48],["Land_RattanChair_01_F",[3.53467,6.17627,-3.35822],-170.404],["Land_RattanChair_01_F",[1.50439,7.26758,-3.35822],128.518],["Land_TableDesk_F",[-5.30029,5.56934,-3.35822],1.22641],["Land_OfficeChair_01_F",[-5.50342,6.6001,-3.35822],8.76091],["Land_OfficeCabinet_01_F",[-5.7002,7.90625,-3.35822],-2.53249],["OfficeTable_01_old_F",[6.34082,5.22998,-3.35822],-93.0884],["OfficeTable_01_new_F",[3.23145,1.646,-3.35822],-184.151],["Land_Metal_rack_F",[0.870605,5.06982,-3.35822],-178.752],["Land_Icebox_F",[-2.07568,5.62793,-3.35822],-178.809],["Land_Icebox_F",[-0.550293,-5.00488,-3.35822],89.9525],["Land_Icebox_F",[-0.522461,-2.87158,-3.35822],90.7582]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};		
			case "Land_Addon_04_F":
				{
				_templates =[[["Land_WoodenTable_large_F",[-3.38135,-5.85889,0.33478],-181.111],["Land_RattanChair_01_F",[-1.97217,-4.83008,0.334781],-102.221],["Land_RattanChair_01_F",[-3.24219,-4.17725,0.334781],-12.221],["Land_RattanChair_01_F",[-2.04248,-6.18262,0.334781],-70.9686],["Land_Metal_rack_F",[-1.40381,-1.99,0.33478],-0.606853],["Land_Metal_rack_F",[-0.146973,-3.12207,0.33478],-91.441],["Land_ShelvesWooden_F",[-0.491211,-0.6875,0.334781],-271.279],["Land_ShelvesWooden_F",[-2.59473,-0.38623,0.33478],-269.897],["Land_TableDesk_F",[-0.905762,2.18145,0.33478],-184.208],["Land_OfficeChair_01_F",[-1.00391,1.38105,0.334781],-180.406],["Land_OfficeCabinet_01_F",[-3.23145,2.68457,0.33478],0.135162],["Fridge_01_closed_F",[3.08838,-6.56494,0.33478],-180.871],["Land_LuggageHeap_01_F",[3.38721,-1.77637,0.33478],-73.5685],["Land_Sack_F",[3.28857,-2.854,0.33478],-113.351],["Land_Sack_F",[3.44336,-0.586426,0.33478],-38.3514]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];	
				};
			case "Land_Shed_02_F":
				{
				_templates =[[["Land_WoodenCounter_01_F",[-0.00976563,1.8501,-0.842734],-177.057],["Land_CratesShabby_F",[-1.3418,-0.608398,-0.842641],-90.3033],["Land_Sack_F",[-1.20801,0.197266,-0.844222],-90.3033],["Land_Sacks_goods_F",[1.09668,0.0151367,-0.84166],93.0307],["Land_BarrelWater_F",[-0.342773,0.876953,-0.840778],169.975]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];	
				};
			case "Land_Shed_05_F":
				{
				_templates =[[["Land_BarrelWater_F",[2.3125,0.800049,-0.889773],109.25],["Land_BarrelWater_F",[1.51172,0.887695,-0.889514],128.637],["Land_BarrelWater_F",[2.22656,-0.11377,-0.889867],100.362],["Land_Sacks_heap_F",[1.88867,-2.00049,-0.889935],-3.34731],["Land_Sacks_goods_F",[-0.396484,-1.62842,-0.889215],-13.3177],["Land_Sack_F",[-2.1875,-1.99268,-0.889215],16.6823],["Land_Sack_F",[-2.22559,-0.733398,-0.889215],61.6823],["Land_CratesShabby_F",[-2.09863,0.696289,-0.888219],-6.40511]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];		
				};				
			case "Land_House_Native_01_F":
				{
				_templates =[[["Land_WoodenTable_large_F",[0.0751953,-2.52881,-3.10103],269.414],["Land_WoodenTable_large_F",[1.85938,2.69238,-3.10103],91.0994],["Land_WoodenCounter_01_F",[-2.38672,2.80322,-3.10103],181.892],["Land_ShelvesWooden_F",[4.54688,-2.36328,-3.10103],1.38248],["Land_Basket_F",[-4.11133,-2.5498,-3.10104],271.682],["Land_Basket_F",[-4.18555,-1.62793,-3.10104],215.249],["Land_Basket_F",[-4.15918,2.49072,-3.10103],129.287],["Land_Basket_F",[-3.19238,-2.20068,-3.10104],175.117],["Land_Sack_F",[3.98926,2.81201,-3.10103],85.6202],["Land_Sack_F",[4.28418,1.74951,-3.10103],91.3261]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];	
				};						
				
			case "Land_House_Native_02_F":
				{
				_templates =[[["Land_Sack_F",[-3.24023,-1.93457,-2.41429],-100.074],["Land_Sack_F",[-3.48877,-0.839844,-2.41426],-55.0739],["Land_Sack_F",[-2.48633,-2.27539,-2.41417],-28.9239],["Land_Sacks_goods_F",[-3.24463,1.97168,-2.41522],171.087],["Land_BarrelWater_F",[-3.35498,0.00195313,-2.41447],236.356],["Land_BarrelWater_F",[-3.36182,0.755859,-2.41472],214.608],["Land_PlasticCase_01_small_F",[2.17871,-2.04199,-2.41458],-1.12192],["Land_PlasticCase_01_large_F",[2.01074,2.2832,-2.41551],89.1053],["Land_Sacks_heap_F",[-2.15967,-0.821289,-2.41423],-93.3029],["Land_ShelvesWooden_F",[0.0366211,-2.35352,-2.41423],-90.927],["Land_ShelvesWooden_F",[0.385742,2.13867,-2.41515],-92.6277]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];		
				};
			case "Land_Temple_Native_01_F":
				{
				_templates =[[["Land_WoodenTable_large_F",[-0.677246,1.06348,-6.03026],-93.4569],["Land_WoodenTable_large_F",[2.14404,4.15039,-6.03032],-89.1357],["Land_ChairWood_F",[-0.0981445,2.31152,-6.03183],-327.626],["Land_ChairWood_F",[0.677734,3.97559,-6.0314],-22.2716],["Land_ChairWood_F",[-2.41064,4.08398,-6.03172],-350.186],["Land_PlasticCase_01_large_F",[3.31055,0.351563,-6.02989],-0.0747254],["Land_PlasticCase_01_large_F",[-0.475586,4.74121,-6.03105],-269.639],["Land_BarrelWater_F",[-3.13477,-0.28418,-6.03091],-104.991]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];	
				};				
							
			case "Land_GarageShelter_01_F":
				{
				_templates =[[["Land_GasTank_01_blue_F",[3,3.36523,-1.25335],-1.62805],["Land_GasTank_01_blue_F",[3.74707,3.41357,-1.25335],-110.703],["Land_CanisterPlastic_F",[4.40186,3.12451,-1.25335],92.5223],["Land_CanisterFuel_F",[4.37354,1.35156,-1.25335],182.435],["Land_CanisterFuel_F",[4.17676,0.217773,-1.25335],12.169],["Land_PlasticCase_01_small_F",[-3.58887,3.38428,-1.25334],90.1638],["Land_PlasticCase_01_large_F",[-2.2583,3.2334,-1.25334],90.1638],["Land_BarrelWater_F",[-4.08887,-1.05713,-1.25334],160.904],["Land_BarrelWater_F",[-4.01514,-0.212891,-1.25334],160.606],["Land_BarrelWater_F",[-3.50928,-0.770508,-1.25334],197.629],["Land_Sacks_heap_F",[-0.942383,-1.95947,-1.25335],-86.1983],["Land_Sacks_goods_F",[-3.62988,1.28564,-1.25335],165.204],["Land_ShelvesMetal_F",[-0.811035,0.334473,-1.25335],1.38748]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];	
				};					
			case "Land_FuelStation_02_workshop_F":
				{
				_templates =[[["Land_Icebox_F",[0.836914,1.66797,-1.25639],-269.88],["Land_CashDesk_F",[4.02637,5.42383,-1.25439],-3.15121],["Land_Metal_rack_F",[4.57813,3.23926,-1.25583],-92.1851],["Land_Metal_rack_F",[4.53906,1.61719,-1.25578],-90.1576],["Land_Metal_rack_F",[4.53906,0.0371094,-1.25577],-90.1576],["Land_ShelvesMetal_F",[2.86035,0.87207,-1.25439],-0.543427]]];	
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];		
				};	
			case "Land_i_Shed_Ind_F":
				{
				_templates = [[["Land_OfficeCabinet_01_F",[-5.13623,-1.49902,-1.42244],-183.967],["Land_TableDesk_F",[-5.35254,0.597656,-1.42244],-269.581],["Land_OfficeChair_01_F",[-6.17578,0.612305,-1.42244],-252.334],["OfficeTable_01_new_F",[-8.49023,-0.0800781,-1.42244],-269.036]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	
			case "Land_GuardHouse_01_F":
				{
				_templates = [[["Land_OfficeCabinet_01_F",[-2.27686,-4.56543,-1.00598],-269.898],["Land_TableDesk_F",[-2.13184,-2.45313,-1.00598],-88.4501],["Land_TableDesk_F",[-0.00292969,-4.55957,-1.00598],0.826236],["Land_OfficeChair_01_F",[-1.5332,-0.740234,-1.00598],-116.413],["Land_OfficeChair_01_F",[0.844238,-1.08984,-1.00598],-219.285],["Land_OfficeChair_01_F",[-0.0820313,-3.50684,-1.00598],-343.258]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_Barracks_01_grey_F":
				{_templates = [[["Land_PlasticCase_01_large_F",[14.1396,2.37695,0.566253],2.57306],["Land_Sleeping_bag_folded_F",[13.1426,3.86133,0.566253],28.3914],["Land_Metal_rack_Tall_F",[12.1328,1.48096,0.566253],181.716],["OfficeTable_01_old_F",[10.0918,-1.46875,0.566253],-5.54492],["Land_OfficeChair_01_F",[10.5244,-2.92969,0.566253],10.1174],["Land_TableDesk_F",[13.5361,-4.01025,0.566253],0.194275],["Land_TableDesk_F",[2.55664,2.83203,0.566253],267.674],["Land_ChairPlastic_F",[4.00098,2.71094,0.566253],238.062],["Land_OfficeCabinet_01_F",[8.01758,4.13379,0.566253],270.076],["Land_OfficeCabinet_01_F",[7.74609,-4.13037,0.566253],181.687],["Land_OfficeChair_01_F",[4.47656,-3.59814,0.566253],69.8496],["Land_OfficeChair_01_F",[6.21094,-3.42041,0.566253],101.107],["Land_WoodenTable_small_F",[6.90625,-2.19238,0.566253],-2.83917],["Land_WoodenTable_small_F",[-5.43359,2.65625,0.566253],89.8059],["Land_CampingChair_V2_F",[-5.43359,3.69189,0.566253],14.806],["Land_CampingChair_V2_F",[-3.68359,3.02295,0.566253],270.092],["Land_CampingChair_V2_F",[-5.31152,1.66504,0.566253],180.092],["Fridge_01_closed_F",[1.04883,3.96191,0.566253],276.423],["Land_Metal_rack_Tall_F",[-2.27539,1.53711,0.566253],181.603],["Land_Metal_rack_Tall_F",[-12.6836,3.94092,0.566253],79.5004],["Land_Metal_rack_Tall_F",[-13.3008,2.00195,0.566253],96.2514],["Land_ShelvesMetal_F",[-9.37109,3.91162,0.566253],89.8557],["Land_CratesShabby_F",[-7.91797,-1.64355,0.566253],-1.69263],["Land_CratesShabby_F",[-7.6123,-2.94775,0.566253],88.3074],["Land_CratesShabby_F",[-7.72559,-4.04785,0.566253],88.4689],["Land_BarrelWater_F",[-12.8037,-3.69629,0.566253],286.315],["Land_BarrelWater_F",[-12.8506,-2.76904,0.566253],259.459],["Land_BarrelWater_F",[-12.7031,-1.95361,0.566253],259.459],["Land_ChairWood_F",[-3.59668,-4.47559,3.87029],30.2855],["Land_ChairWood_F",[-5.30469,-4.16016,3.87028],-21.2055],["Land_ShelvesWooden_F",[-7.8457,-2.65625,3.87107],175.843],["Land_Sleeping_bag_blue_F",[-9.25195,-3.02051,3.87107],155.795],["Land_Sleeping_bag_blue_folded_F",[-12.7354,-2.44189,3.87107],-11.4088],["Land_Sleeping_bag_folded_F",[-12.6484,-3.53613,3.87107],20.4237],["Land_Ground_sheet_folded_F",[-12.8057,-3.1084,3.87107],20.4237],["Land_LuggageHeap_01_F",[-8.24512,-3.90723,3.87107],227.432],["Land_LuggageHeap_02_F",[-12.3672,2.13721,3.87107],80.9485],["Land_BottlePlastic_V2_F",[-12.1328,3.30273,3.87107],46.3791],["Land_BottlePlastic_V2_F",[-12.2695,2.99365,3.87107],56.0586],["Land_FMradio_F",[-11.9551,3.57324,3.87107],187.099],["Land_Ground_sheet_folded_blue_F",[0.939453,3.67676,3.87107],146.441],["Land_Ground_sheet_F",[-0.390625,4.05029,3.87107],272.62],["Land_Sleeping_bag_folded_F",[1.01367,4.25195,3.87107],209.855],["Land_Metal_rack_Tall_F",[-5.87109,2.68311,3.87107],91.8763],["Land_Metal_rack_Tall_F",[7.48828,-1.77441,3.87107],275.188],["Land_Metal_rack_Tall_F",[7.7334,-3.15918,3.87107],275.188],["Land_OfficeCabinet_01_F",[2.09766,-3.86426,3.87107],84.9336],["Land_OfficeCabinet_01_F",[2.20801,-2.62793,3.87107],84.9336],["Land_OfficeCabinet_01_F",[5.13867,-4.18018,3.87107],182.16],["Land_OfficeCabinet_01_F",[2.28418,2.90674,3.87107],91.6397],["Land_TableDesk_F",[3.81152,1.67285,3.87107],3.4325],["Land_OfficeChair_01_F",[7.7002,4.05859,3.87107],208.865],["Land_OfficeChair_01_F",[13.7344,3.68018,3.87107],196.257],["Land_OfficeChair_01_F",[13.6543,2.05615,3.87107],145.207],["OfficeTable_01_new_F",[12.0547,1.64893,3.87107],175.217],["OfficeTable_01_new_F",[9.27344,2.76123,3.87107],90.9937],["Land_Icebox_F",[9.23828,-2.76123,3.87107],91.8418],["Land_CampingTable_F",[12.3633,-3.86914,3.87107],184.702],["Land_GasTank_01_blue_F",[10.6504,-3.6499,3.87107],135.195],["Land_GasTank_01_blue_F",[14.2354,-3.99609,3.87107],225.833],["Land_CanisterPlastic_F",[9.96094,-1.40039,3.87107],78.9671],["Land_PlasticCase_01_small_F",[10.1924,-2.7832,3.87107],120.011],["Land_CampingChair_V1_F",[11.498,-3.18994,3.87107],59.9792],["Land_CampingChair_V1_F",[12.7686,-3.19824,3.87107],14.9792]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	
			case "Land_School_01_F":
				{
				_templates = [[["Land_TableDesk_F",[8.02246,0.0634766,-1.24323],85.6087],["Land_OfficeChair_01_F",[6.32031,0.25293,-1.24827],-189.728],["Land_ChairPlastic_F",[13.4248,-0.392578,-1.2474],-172.069],["Land_ChairPlastic_F",[13.2373,2.23633,-1.25234],-158.296],["Land_ChairPlastic_F",[10.5254,3.76465,-1.25233],-140.533],["Land_ChairPlastic_F",[11.2363,2.31543,-1.25187],-98.5027],["Land_ChairPlastic_F",[0.831055,-2.52539,-1.24418],-262.466],["Land_ChairPlastic_F",[-0.798828,-2.25977,-1.2458],-247.466],["Land_ChairPlastic_F",[-2.97461,-2.19922,-1.25034],-252.319],["Land_TableDesk_F",[-2.35254,0.37793,-1.24661],86.4042],["Land_OfficeChair_01_F",[-3.52344,0.262695,-1.25138],-219.542],["OfficeTable_01_new_F",[-9.24707,1.51953,-1.25342],-89.8762],["OfficeTable_01_new_F",[-9.23926,-0.501953,-1.25001],-90.7625],["OfficeTable_01_new_F",[-12.4561,1.54102,-1.25342],-91.0319],["OfficeTable_01_new_F",[-12.458,-0.568359,-1.25342],-91.1843],["Land_CampingChair_V2_F",[-13.4111,-0.480469,-1.25342],-270.234],["Land_CampingChair_V2_F",[-10.2705,1.78906,-1.25342],-236.235],["Land_CampingChair_V2_F",[-10.1357,-0.556641,-1.25342],78.3527]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	
			case "Land_Warehouse_03_F":
				{
				_templates = [[["Land_CanisterFuel_F",[-9.63574,-0.923828,-2.36032],-10.1525],["Land_CanisterFuel_F",[-9.69824,0.227539,-2.36032],-43.6402],["Land_CanisterFuel_F",[-9.95605,1.28809,-2.36066],-64.8455],["Land_CanisterPlastic_F",[-9.18262,2.39453,-2.3616],-64.8455],["Land_CanisterPlastic_F",[-9.63281,3.83887,-2.36251],-123.787],["Land_CanisterPlastic_F",[-10.3145,2.38867,-2.36251],-76.5574],["Land_PlasticCase_01_large_F",[1.82031,5.12402,-2.3637],-271.073],["Land_PlasticCase_01_large_F",[-0.753906,4.41504,-2.36271],-247.296],["Land_BarrelWater_F",[-0.105469,3.91699,-2.36344],59.483]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
			case "Land_FuelStation_01_shop_F":
				{
				_templates =[[["Land_TableDesk_F",[1.66089,-1.79199,-2.01157],-271.251],["Land_TableDesk_F",[-0.0561523,-4.26611,-2.01157],-1.30554],["Land_OfficeChair_01_F",[0.815186,-1.7373,-2.01157],-280.488],["Land_OfficeChair_01_F",[-0.323486,-3.09229,-2.01157],-332.793],["Land_OfficeCabinet_01_F",[-5.30908,-4.23926,-2.01157],-270.782],["Land_TablePlastic_01_F",[-1.5708,1.55518,-2.01158],-183.059],["Land_ChairPlastic_F",[0.366455,2.13818,-2.01157],-183.214],["Land_ChairPlastic_F",[-1.14429,2.78125,-2.01157],-122.271],["Land_ChairPlastic_F",[-2.40649,2.625,-2.01157],-122.271],["Land_ShelvesWooden_F",[-3.7085,4.646,-2.01157],-267.555],["Fridge_01_closed_F",[-5.13794,3.00684,-2.01157],-267.17]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	
			case "Land_Shop_City_01_F":
				{
				_templates = [[["Land_CashDesk_F",[2.75879,2.78125,-4.96122],48.3944],["Land_OfficeChair_01_F",[2.05078,3.65527,-4.94825],-229.361],["Land_ShelvesMetal_F",[5.75879,1.72363,-4.96344],1.34766],["Land_ShelvesMetal_F",[3.00586,-0.259766,-4.96907],-272.178],["Land_Metal_rack_F",[6.72559,5.47363,-4.94542],-2.63683]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};			
			case "Land_Shop_City_02_F":
				{
				_templates = [[["Land_Metal_rack_F",[0.516602,-6.31055,-4.36143],89.531],["Land_Metal_rack_F",[7.80469,-5.55273,-4.36095],-89.5549],["Land_Icebox_F",[6.77148,-1.83984,-4.36108],0.197617],["Land_Icebox_F",[4.58105,-1.84863,-4.3615],0.197617],["Land_CashDesk_F",[2.55664,-2.2207,-4.36165],90.7803],["Land_ChairWood_F",[1.7793,-3.21582,-4.36164],74.6861],["Land_ShelvesMetal_F",[3.21191,-6.29688,-4.3611],-3.59962],["Land_ShelvesMetal_F",[-9.69238,-2.39844,-4.34926],-270.216],["Land_CratesShabby_F",[-9.15137,-6.04492,-4.34926],-345.232],["Land_Sacks_goods_F",[-2.34131,-6.03906,-4.3608],-348.557],["Land_Sacks_heap_F",[-1.46191,-7.57031,-4.36013],-38.4277],["Land_Sacks_heap_F",[1.82715,1.10254,-4.36266],-273.467],["Land_ShelvesMetal_F",[4.87646,1.36816,-4.36162],-272.688],["Land_GasTank_01_blue_F",[4.67529,-0.417969,-4.36185],-161.058]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	
			case "Land_Hotel_02_F":
				{
				_templates =[[["Land_OfficeChair_01_F",[7.44043,-0.131348,-3.38684],-214.856],["Land_OfficeChair_01_F",[5.86523,0.0187988,-3.38684],-128.924],["Land_LuggageHeap_01_F",[-1.30566,14.6733,-3.38684],-158.902],["Land_LuggageHeap_02_F",[-2.04688,7.19946,-3.38684],15.7998],["Land_LuggageHeap_02_F",[-2.2959,-5.81836,-3.38684],99.4852],["Land_LuggageHeap_02_F",[-7.60156,3.4729,0.109365],-4.95287],["Land_LuggageHeap_01_F",[-7.85352,-0.414063,0.109364],85.9007],["Land_LuggageHeap_03_F",[3.59863,0.740234,0.109367],-135.265],["Land_LuggageHeap_01_F",[2.17871,3.6687,-3.38684],11.8903]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	
				
			// ALTIS
			case "Land_i_House_Small_01_V1_F":
				{
				_templates = [[["Land_CanisterPlastic_F",[2.08398,4.49023,-1.03958],46.0271],["Land_ChairPlastic_F",[3.7832,4.11719,-1.07374],-119.167],["Land_ChairPlastic_F",[-4.08203,-3.82422,-1.02398],35.2988],["Land_TablePlastic_01_F",[-3.9375,-0.464844,-1.0852],88.3407],["Land_ChairPlastic_F",[-2.68652,-0.84375,-1.07325],157.217],["Land_ChairPlastic_F",[-2.85938,0.480469,-1.02343],187.217],["Land_WoodenTable_large_F",[0.878906,-2.44531,-1.02346],1.58008],["Land_RattanChair_01_F",[0.158203,-2.23047,-1.04972],46.5948],["Land_PlasticCase_01_small_F",[0.764648,-2.24219,-0.147858],23.7305],["Land_Sack_F",[-0.423828,4.31641,-1.03956],45.0582],["Land_Sack_F",[-1.82422,4.45703,-1.03967],150.058],["Land_Basket_F",[-1.30469,0.972656,-1.18567],-106.466],["Fridge_01_closed_F",[-1.40723,-3.88477,-1.15955],176.421]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};			
			case "Land_i_House_Small_01_V2_F":
				{
				_templates = [[["Land_WoodenCounter_01_F",[-3.94727,-0.629395,-1.04163],-88.6504],["Land_TableDesk_F",[-1.0791,-3.8916,-1.04021],-0.807007],["Land_OfficeChair_01_F",[-1.05762,-2.85791,-1.04028],-0.807007],["Land_OfficeCabinet_01_F",[1.14355,-2.00879,-1.04108],268.761],["Land_ChairWood_F",[-3.81641,2.36621,-1.04156],118.562],["Land_ChairWood_F",[-1.44238,2.45801,-1.04136],188.964],["Land_CanisterPlastic_F",[4.05176,4.40332,-1.04253],-55.2585],["Land_CanisterPlastic_F",[3.48438,4.48047,-1.04271],-0.525421],["Land_CanisterFuel_F",[2.29492,4.27539,-1.04265],-0.525421],["Land_CanisterFuel_F",[3.02734,4.26514,-1.04264],-30.5254],["Land_PlasticCase_01_large_F",[2.23242,1.74854,-1.04189],178.524],["Land_Sack_F",[-3.99805,-3.52539,-1.04111],-48.8213],["Land_Sack_F",[-3.72363,-2.43848,-1.04109],236.179],["Fridge_01_closed_F",[1.11035,-1.12256,-1.04033],-87.9361],["Land_CampingChair_V2_F",[-2.62305,0.669922,-1.0419],111.699],["Land_CampingChair_V2_F",[-2.8252,-0.407227,-1.04189],216.699],["Land_Metal_rack_Tall_F",[-0.736328,4.28418,-1.04265],0.549286]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	

			case "Land_i_House_Small_01_V3_F":
				{
				_templates = [[["Land_TablePlastic_01_F",[-2.52344,0.897461,-1.04125],175.246],["Land_ChairPlastic_F",[-1.15039,0.199219,-1.04091],144.503],["Land_ChairPlastic_F",[-2.3418,-0.149414,-1.04186],109.023],["Land_ChairPlastic_F",[-3.81641,0.560547,-1.04204],38.8209],["Land_WoodenCounter_01_F",[-4.10352,-2.83887,-1.04187],88.2375],["Land_OfficeCabinet_01_F",[1.26758,-1.85059,-1.0407],269.757],["Land_Metal_rack_F",[-1.22266,-4.13379,-1.04176],178.711],["Land_ShelvesMetal_F",[3.03516,4.24902,-1.04174],271.221],["Land_CratesShabby_F",[-3.98633,2.41309,-1.04206],53.4946],["Land_Sack_F",[-0.853516,2.50586,-1.04223],174.282],["Land_Sacks_goods_F",[-2.35156,2.59766,-1.04239],167.574],["Fridge_01_closed_F",[1.08594,-3.24316,-1.04097],265.582],["Land_BarrelWater_F",[4.18555,1.45508,-1.04093],-6.30811],["Land_PlasticCase_01_large_F",[3.92969,-0.375,-1.04038],-6.30811]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
				 
			case "Land_i_House_Small_02_V1_F":
				{
				_templates = [[["Land_RattanChair_01_F",[6.42578,1.75977,-0.703516],-40.6828],["Land_RattanChair_01_F",[6.61719,-0.146484,-0.704597],-97.9207],["Land_WoodenTable_large_F",[5.45898,0.337891,-0.706083],7.07932],["Land_ChairPlastic_F",[5.92578,-1.48438,-0.705217],42.2576],["Land_TableDesk_F",[1.62305,-1.47656,-0.703932],-97.0282],["Land_Metal_rack_F",[2.97266,-3.06641,-0.70537],-179.503],["Land_ShelvesWooden_F",[-0.0429688,2.57129,-0.705944],-92.9552],["Fridge_01_closed_F",[-2.51563,2.50586,-0.699205],-0.87532],["Land_Metal_rack_Tall_F",[-0.542969,-3.0918,-0.713911],-181.833],["Land_Basket_F",[0.226563,-0.222656,-0.711535],-131.186],["Land_Basket_F",[0.203125,-1.21582,-0.711565],-71.186],["Land_Sack_F",[0.359375,-2.125,-0.71229],-89.8174],["Land_BarrelWater_F",[-3.10547,0.206055,-0.710192],-0.944931]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	

			case "Land_i_House_Small_02_V2_F":
				{
				_templates = [[["Land_PlasticCase_01_large_F",[6.0708,2.58203,-0.701662],92.9396],["Land_BarrelWater_F",[7.09326,2.21875,-0.70167],83.0936],["Land_Sacks_heap_F",[7.11572,0.486328,-0.701641],83.0936],["Land_Sacks_goods_F",[6.79785,-1.58203,-0.701864],96.8073],["Land_CanisterPlastic_F",[1.41162,-3.12891,-0.704269],-27.081],["Land_CanisterPlastic_F",[1.77051,-2.03125,-0.703808],17.9189],["Land_CanisterFuel_F",[2.50732,-2.69922,-0.702868],48.3204],["Land_Suitcase_F",[3.59961,-2.79492,-0.70146],123.32],["Land_CampingTable_small_F",[1.89111,-0.714844,-0.703241],88.4045],["Land_CampingChair_V2_F",[2.6167,-1.76953,-0.702749],55.9598],["Land_ChairPlastic_F",[3.04785,-0.546875,-0.701822],103.461],["Land_ShelvesMetal_F",[-0.654297,-2.89844,-0.711678],-92.2556],["Land_Metal_rack_F",[0.423828,-0.792969,-0.710293],-89.5467],["Fridge_01_closed_F",[-3.17139,0.222656,-0.707691],89.3282],["Land_LuggageHeap_02_F",[-3.02344,2.27344,-0.706264],34.2025],["Land_Sack_F",[-0.199219,2.39844,-0.706984],-6.20187],["Land_ChairWood_F",[-2.74365,-0.472656,-0.709225],95.4369]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
				
			case "Land_i_House_Small_02_V3_F":
				{
				_templates =  [[["Land_RattanChair_01_F",[-3.01172,2.03223,-0.707756],22.4005],["Land_RattanChair_01_F",[-1.91211,2.00195,-0.708279],9.44495],["Land_WoodenTable_small_F",[-3.03906,-0.266602,-0.711452],181.163],["Land_ChairWood_F",[-0.34375,-2.41797,-0.710602],212.497],["Land_TableDesk_F",[0.230469,-0.685547,-0.705902],270.367],["Land_WoodenCounter_01_F",[6.96484,-0.484375,-0.701199],273.363],["Land_ShelvesWooden_F",[1.375,-1.1123,-0.704674],180.593],["Fridge_01_closed_F",[7.10352,1.27393,-0.699352],272.033],["Land_Microwave_01_F",[7.2207,-2.125,-0.700901],274.273],["Land_Basket_F",[6.79297,-2.84326,-0.702038],304.924],["Land_Basket_F",[5.81641,-2.78564,-0.7033],-10.0759],["Land_CratesShabby_F",[3.10156,-2.71191,-0.704041],265.261],["Land_Sacks_goods_F",[1.80664,-2.50195,-0.705379],257.841],["Land_BarrelWater_F",[7.12891,2.44092,-0.701103],37.9677],["Land_Sacks_heap_F",[3.27539,-0.260254,-0.706429],338.064]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
				
			case "Land_i_House_Small_03_V1_F":
				{
				_templates =  [[["Land_WoodenCounter_01_F",[2.42383,-3.29297,0.00672913],268.216],["Land_LuggageHeap_02_F",[2.71875,-5.5498,0.00656128],264.002],["Land_Basket_F",[4.93164,-5.55176,0.00733948],285.582],["Land_Basket_F",[4.92383,-4.46973,0.00733948],-29.4184],["Land_CratesShabby_F",[4.91602,-3.2334,0.00733948],15.5816],["Land_ShelvesWooden_F",[5.11719,1.33594,0.00758362],179.364],["Land_WoodenTable_large_F",[-4.69141,0.995117,0.00389862],-1.52823],["Land_RattanChair_01_F",[-4.76758,2.58691,0.00377655],-6.65387],["Land_RattanChair_01_F",[-3.74805,1.44922,0.0042572],267.956],["Land_RattanChair_01_F",[-4.67773,-0.50293,0.00337982],221.346],["Land_OfficeCabinet_01_F",[-1.8418,-2.10938,0.0055542],179.052],["Land_TableDesk_F",[-4.42773,4.35645,0.0038147],-1.80762],["Fridge_01_closed_F",[-1.58789,4.31348,0.00712585],269.185],["Land_Sack_F",[4.87305,-1.90234,0.0076828],250.357],["Land_BarrelWater_F",[4.94727,-1.01172,0.0076828],250.357],["Land_BarrelWater_F",[2.33789,4.31152,0.00382233],-2.01752],["Land_PlasticCase_01_large_F",[0.537109,4.32813,0.00534821],88.8865],["Land_CanisterPlastic_F",[1.17969,1.09375,0.00809479],0.828156],["Land_GasTank_01_blue_F",[0.603516,1.07617,0.00797272],-32.615],["Land_GasTank_01_blue_F",[-0.0332031,1.05176,0.00758362],309.013],["Land_Sleeping_bag_blue_F",[0.248047,2.80664,0.00714111],43.8263]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_i_House_Big_01_V1_F":
				{
				_templates =  [[["Land_TablePlastic_01_F",[-0.279297,6.46289,-2.56494],-1.34801],["Land_ChairPlastic_F",[-1.7832,6.5752,-2.56494],-2.40092],["Land_ChairPlastic_F",[-0.296875,5.48828,-2.56494],83.7812],["Land_ChairPlastic_F",[1.53516,5.89844,-2.56494],158.718],["Land_WoodenTable_small_F",[-3.31641,3.84277,-2.56494],-87.8386],["Land_OfficeCabinet_01_F",[-3.44141,6.89551,-2.56494],0.909653],["OfficeTable_01_new_F",[3.79883,3.84375,-2.56494],0.0835114],["Land_CampingChair_V1_F",[2.08691,3.57324,-2.56494],-179.825],["Fridge_01_closed_F",[-3.81738,1.63281,-2.56494],96.9639],["Land_BarrelWater_F",[-3.84668,2.35742,-2.56494],64.9382],["Land_WoodenTable_large_F",[1.39258,-0.125977,-2.56494],0.560516],["Land_ChairWood_F",[0.290039,-0.0556641,-2.56494],146.572],["Land_ChairWood_F",[1.24316,-1.74121,-2.56494],-188.069],["Land_ChairWood_F",[2.2627,-0.65918,-2.56494],-98.0686],["Land_WoodenCounter_01_F",[-1.12305,-2.81348,-2.56494],-90.0677],["Land_Metal_rack_F",[1.48145,-6.75977,-2.56494],-179.451],["Land_Metal_rack_Tall_F",[4.22559,-3.98535,-2.56494],-92.7952],["Land_LuggageHeap_01_F",[3.68945,-3.7207,0.855064],-58.1014],["Land_PlasticCase_01_large_F",[1.82031,-6.79102,0.855064],-90.0129],["Land_Suitcase_F",[4.0957,-6.70996,0.855064],19.5407],["Land_Sleeping_bag_F",[2.91797,-5.13184,0.855064],56.2859],["Land_Sleeping_bag_blue_folded_F",[3.84668,-4.60449,0.855064],65.0301],["Land_Ground_sheet_folded_F",[1.4502,-3.76074,0.855064],81.098],["Land_FMradio_F",[2.75195,-6.65527,0.855064],32.7554],["Land_CampingTable_small_F",[-1.75977,-6.37012,0.855064],-0.760391],["Land_CampingChair_V1_F",[-1.91211,-5.57031,0.855064],3.5764],["Land_CampingChair_V1_F",[-2.87891,-6.31641,0.855064],63.5764],["Land_ShelvesWooden_F",[4.18848,-1.94336,0.855064],-179.129],["Land_Sack_F",[2.32324,0.673828,0.855064],-141.559],["Land_Sack_F",[2.17188,-0.499023,0.855064],-105.913],["Land_Sacks_goods_F",[1.00977,-1.98047,0.855064],-177.147],["Land_CanisterPlastic_F",[-3.76758,2.36816,0.855066],-5.05688],["Land_CanisterPlastic_F",[-3.91016,-1.09863,0.855064],39.9431],["Land_GasTank_01_blue_F",[0.870117,0.0986328,0.855064],-61.4245]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_i_House_Big_01_V2_F":
				{
				_templates =  [[["Land_GasTank_01_blue_F",[-3.97656,6.99414,-2.56544],-339.829],["Land_CanisterPlastic_F",[-3.84961,6.2832,-2.56587],-298.129],["Land_Basket_F",[-3.70801,3.83984,-2.56564],-237.191],["Land_Basket_F",[-2.70508,3.87695,-2.56539],-158.334],["Fridge_01_closed_F",[-2.49023,6.81348,-2.56538],1.14147],["Land_ShelvesMetal_F",[1.62988,6.62207,-2.56441],-88.5974],["Land_Metal_rack_F",[4.29883,4.12012,-2.56396],-90.1885],["Land_ChairWood_F",[3.5752,6.30859,-2.56417],-2.6498],["Land_WoodenTable_large_F",[1.15625,-3.80664,-2.56453],-91.2149],["Land_RattanChair_01_F",[2.77637,-3.62598,-2.5647],-101.663],["Land_RattanChair_01_F",[1.11816,-2.82715,-2.5647],-11.6628],["Land_OfficeCabinet_01_F",[1.03125,-6.8291,-2.56452],-180.518],["Land_ShelvesWooden_F",[-4.0332,1.73145,-2.5659],-180.466],["Land_LuggageHeap_02_F",[-2.6748,1.9707,-2.5659],-180.466],["Land_LuggageHeap_03_F",[-0.320313,-6.33008,0.854517],-134.863],["Land_PlasticCase_01_small_F",[1.9043,-3.76172,0.85601],-251.395],["Land_Pillow_old_F",[3.50391,-3.72852,0.855972],-244.07],["Land_Pillow_grey_F",[3.70313,-4.12793,0.855972],-289.07],["Land_Sleeping_bag_blue_F",[3.05176,-6.43652,0.855974],-92.3485],["Land_Sleeping_bag_blue_folded_F",[4.28125,-6.4668,0.855841],-108.329],["Land_CampingTable_F",[-3.80859,-5.6084,0.854322],-270.271],["Land_CampingChair_V1_F",[-2.85156,-6.06152,0.854322],-270.271],["Land_CampingChair_V1_F",[-1.74316,-6.62793,0.854843],-233.983],["Land_WoodenCounter_01_F",[2.01074,3.61426,0.856039],-0.116877],["Land_Metal_rack_Tall_F",[4.17676,4.43848,0.855709],-89.6306],["Land_Basket_F",[4.125,6.65625,0.855988],-6.62606],["Land_Basket_F",[3.87988,5.59668,0.856043],-28.2966],["Land_CratesShabby_F",[-3.71582,3.78516,0.854149],-185.246],["Land_Sacks_goods_F",[-3.18359,5.29297,0.854149],-185.246],["Land_Sack_F",[2.88965,-1.64941,0.856028],-35.4691],["Land_Sacks_heap_F",[1.42285,-0.176758,0.856005],-10.1893],["Land_Sacks_heap_F",[0.845703,-1.94824,0.856024],-171.842],["Land_BarrelWater_F",[-3.83496,2.29688,0.854204],-9.32506],["Land_BarrelWater_F",[-3.76367,-1.33594,0.854492],-286.741]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};				

			case "Land_i_House_Big_01_V3_F":
				{
				_templates =  [[["Land_PlasticCase_01_large_F",[-3.8125,3.8291,-2.56395],-181.536],["Land_BarrelWater_F",[-3.76953,5.23145,-2.56395],-181.536],["Land_BarrelWater_F",[-3.88867,6.90137,-2.56383],-189.304],["Land_Sacks_heap_F",[-1.10156,6.55664,-2.56397],-180.161],["Land_Sacks_heap_F",[3.84766,3.97461,-2.56601],-6.99484],["Land_Sacks_goods_F",[0.599609,6.4248,-2.56445],64.4381],["Fridge_01_closed_F",[-3.49023,1.62207,-2.5642],86.9775],["Land_GasTank_01_blue_F",[-3.43164,2.39355,-2.56376],15.2075],["Land_ShelvesWooden_F",[1.53711,0.620117,-2.56392],-88.5952],["Land_ShelvesWooden_F",[-1.14844,-1.96973,-2.56396],-0.732254],["OfficeTable_01_old_F",[1.40234,-6.64063,-2.56627],-181.624],["Land_ChairWood_F",[1.78125,-5.625,-2.56628],-30.225],["Land_RattanChair_01_F",[4.17969,-3.00586,-2.56602],-112.441],["Land_RattanChair_01_F",[4.19336,-6.48633,-2.5663],-160.444],["Land_Metal_rack_Tall_F",[0.925781,6.84863,0.854462],3.26672],["Land_LuggageHeap_01_F",[3.97266,6.64258,0.854347],-2.1586],["Land_LuggageHeap_02_F",[-3.44531,4.17578,0.855583],-172.972],["Land_LuggageHeap_02_F",[-3.44531,4.17578,0.855583],-172.972],["Land_PlasticCase_01_small_F",[-0.207031,6.54395,0.85638],101.1],["Land_Sleeping_bag_F",[-2.20313,6.70313,0.856274],87.8726],["Land_Sleeping_bag_blue_F",[3.44531,3.78711,0.853817],-95.5269],["Land_Sleeping_bag_blue_folded_F",[4.08203,4.5625,0.853947],-85.0467],["Land_Sleeping_bag_folded_F",[-3.66797,6.54199,0.856266],88.2953],["Land_TablePlastic_01_F",[0.707031,-3.99805,0.853783],-174.027],["Land_ChairPlastic_F",[2.16797,-4.01367,0.855034],-107.125],["Land_ChairPlastic_F",[0.621094,-5.05176,0.85479],77.511],["Land_CratesShabby_F",[3.53906,-2.07129,0.85392],33.035],["Land_Sack_F",[1.09375,-2.10938,0.853767],19.419],["Land_Sacks_goods_F",[1.40625,0.0214844,0.854351],58.0305],["Land_CanisterPlastic_F",[1.24414,-1.20898,0.853928],33.5679],["Land_CanisterPlastic_F",[-0.0742188,-2.2959,0.853771],-21.6828],["Land_GasTank_01_blue_F",[-3.91406,-1.65039,0.854927],-85.2979],["Land_Suitcase_F",[-3.83984,-6.66309,0.854279],-56.4489]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_i_House_Big_02_V1_F":
				{
				_templates = [[["Fridge_01_closed_F",[2.12891,-1.1084,-2.62491],-94.3556],["Land_Basket_F",[1.83203,-1.92969,-2.62556],-106.438],["Land_ShelvesWooden_F",[-3.38086,-1.18848,-2.6199],90.0902],["Land_ShelvesMetal_F",[1.80664,0.173828,-2.6269],-89.9523],["Land_ShelvesWooden_F",[4.19531,0.828125,-2.62674],-4.50794],["Land_TableDesk_F",[4.08984,3.54492,-2.62547],90.2152],["Land_OfficeChair_01_F",[2.99219,3.5459,-2.62547],90.2152],["Land_OfficeChair_01_F",[4.18359,1.91211,-2.62514],-203.348],["Land_WoodenCounter_01_F",[-4.02344,2.15625,-2.6219],90.2379],["Land_ChairWood_F",[-3.32422,4.33008,-2.62135],35.4309],["Land_CanisterPlastic_F",[-3.94336,0.236328,-2.6234],69.1718],["Land_CanisterPlastic_F",[-3.85547,-1.22266,0.787415],0.607124],["Land_CanisterPlastic_F",[-3.81055,-1.83594,0.787415],30.6071],["Land_CanisterPlastic_F",[-3.80469,-2.80664,0.787415],75.6071],["Land_GasTank_01_blue_F",[-3.82422,-3.73633,0.786346],103.539],["Land_PlasticCase_01_large_F",[2.38477,0.078125,0.780411],-97.4489],["Land_BarrelWater_F",[4.38086,0.0273438,0.780487],-85.2888],["Land_Sacks_heap_F",[3.78906,1.19043,0.780487],-85.2888],["Land_Sacks_heap_F",[3.85352,3.10742,0.781708],87.4758],["Land_Sleeping_bag_blue_folded_F",[1.67969,4.63672,0.784164],-231.154],["Land_Sleeping_bag_blue_folded_F",[2.46094,4.43945,0.784164],-201.154],["Land_LuggageHeap_02_F",[-0.681641,4.61914,0.787247],-142.198],["Land_CratesShabby_F",[-3.80078,0.439453,0.784561],-30.6144],["Land_Sack_F",[-3.97266,1.52148,0.784927],-51.4324],["Land_ChairWood_F",[1.04102,0.108398,0.780457],-193.077],["Land_WoodenTable_small_F",[-1.17578,-3.37305,0.782806],87.3334]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
 
			case "Land_i_House_Big_02_V2_F":
				{
				_templates = [[["Land_WoodenTable_small_F",[1.56738,-1.625,-2.62328],271.141],["Land_WoodenTable_large_F",[-3.33984,-1.33789,-2.62328],90.0771],["Land_CampingTable_F",[2.08398,0.425781,-2.62327],181.147],["Land_CampingChair_V2_F",[2.17773,1.20703,-2.62327],-22.5533],["Land_CampingChair_V2_F",[1.29492,1.27344,-2.62328],-43.1543],["Land_WoodenCounter_01_F",[4.19727,3.00977,-2.62327],89.469],["Land_TableDesk_F",[-3.73633,1.13477,-2.62328],269.018],["OfficeTable_01_new_F",[-3.78809,3.66797,-2.62328],89.018],["Land_OfficeChair_01_F",[-2.83887,0.837891,-2.62328],254.018],["Land_OfficeChair_01_F",[-3.08398,3.41797,-2.62328],254.018],["Land_OfficeCabinet_01_F",[-3.32227,-0.974609,0.784061],-2.43185],["Land_ChairWood_F",[-4.03516,-3.76172,0.784061],79.9433],["Land_WoodenTable_small_F",[-1.21094,-3.40234,0.784058],88.4992],["Land_ShelvesMetal_F",[4.31152,3.40234,0.784065],179.607],["Fridge_01_closed_F",[4.21387,1.67578,0.784065],267.967],["Land_CratesShabby_F",[4.24414,0.425781,0.784065],263.903],["Land_Sacks_goods_F",[-3.46875,1.21094,0.784061],114.213],["Land_CanisterFuel_F",[-3.3418,2.83984,0.784061],53.7771],["Land_CanisterPlastic_F",[-3.9541,4.7832,0.784061],17.3919],["Land_PlasticCase_01_large_F",[1.37695,0.195313,0.784065],267.892],["Land_Sleeping_bag_folded_F",[1.25684,4.35742,0.784061],1.91339],["Land_Sleeping_bag_folded_F",[1.90039,4.49805,0.784061],76.9134],["Land_Ground_sheet_folded_blue_F",[0.378906,4.64648,0.784061],121.854],["Land_Ground_sheet_folded_F",[1.07617,4.85938,0.784061],166.999]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_i_House_Big_02_V3_F":
				{
				_templates = [[["Land_PlasticCase_01_large_F",[2.16797,-1.61328,-2.62327],4.28305],["Land_LuggageHeap_02_F",[1.16113,-1.52539,-2.62327],7.3073],["Land_Basket_F",[4.0415,0.283203,-2.62327],-43.5342],["Land_Basket_F",[2.98145,0.339844,-2.62327],-32.6877],["Land_CratesShabby_F",[2.09668,0.601563,-2.62327],-32.6877],["Land_Sack_F",[0.81543,0.669922,-2.62327],-32.6877],["Land_Sack_F",[-3.6875,0.335938,-2.62327],-118.477],["Land_Sacks_goods_F",[-3.61523,3.21289,-2.62327],153.458],["Land_ShelvesWooden_F",[4.26025,4.01953,-2.62327],-2.47742],["Land_ShelvesWooden_F",[-4.05713,-1.65625,-2.62327],177.668],["Fridge_01_closed_F",[2.19189,0.357422,0.784061],180.299],["Land_Metal_rack_Tall_F",[3.50244,0.240234,0.784061],184.706],["Land_Metal_rack_Tall_F",[4.46191,4.50195,0.784061],-88.365],["Land_Basket_F",[1.53516,4.4375,0.78406],-26.3235],["Land_Sacks_heap_F",[-3.37256,0.869141,0.784061],89.7987],["Land_BarrelWater_F",[-3.46045,2.41992,0.784061],80.7871],["Land_BarrelWater_F",[-3.62842,3.46094,0.784061],155.787],["Land_ChairWood_F",[4.03125,1.1875,0.784061],-95.0855],["Land_ChairWood_F",[3.9458,3.54297,0.784061],-87.795],["Land_OfficeCabinet_01_F",[-3.20947,-1.03125,0.784061],-1.02269],["Land_Sleeping_bag_folded_F",[-3.87842,-1.26758,0.784061],98.4081],["Land_Ground_sheet_folded_blue_F",[-4.07178,-2.48438,0.784061],98.4081]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
		
			case "Land_i_Shop_01_V1_F":
				{
				_templates =  [[["Land_ShelvesMetal_F",[-1.84546,0.521484,-2.76157],-0.0969238],["Land_ShelvesMetal_F",[1.35376,1.49023,-2.76157],177.141],["Land_CashDesk_F",[-2.81934,4.38867,-2.76157],-1.98949],["Land_OfficeChair_01_F",[-2.66797,5.48828,-2.76158],52.5127],["Fridge_01_closed_F",[3.04639,4.69727,-2.76157],182.912],["Land_ShelvesWooden_F",[-3.10693,6.19922,1.10981],182.241],["Land_WoodenCounter_01_F",[1.44971,0.595703,1.10873],-91.404],["Land_WoodenTable_large_F",[-2.93579,2.07227,1.10927],179.546],["Land_CampingChair_V2_F",[-1.72656,2.06836,1.1089],-120.454],["Land_CampingChair_V2_F",[-2.604,0.347656,1.1095],145.662],["Land_LuggageHeap_02_F",[-2.92627,3.92969,1.10938],103.453]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};		


			case "Land_i_Shop_01_V2_F":
				{
				_templates =  [[["Fridge_01_closed_F",[3.08594,4.21289,-2.76229],-181.554],["Land_Icebox_F",[1.42578,-0.0380859,-2.76224],-90.5887],["Land_Icebox_F",[-2.77344,-1.99707,-2.76136],-1.16144],["Land_CashDesk_F",[-2.74219,3.81445,-2.76084],0.985016],["Land_CampingChair_V2_F",[-2.19922,4.92676,-2.76065],22.5552],["Land_Metal_rack_F",[-3.54297,0.237305,-2.76093],90.077],["Land_Metal_rack_F",[-3.54688,1.55664,-2.76093],90.077],["Land_Metal_rack_Tall_F",[-1.0625,6.21387,-2.76087],-2.05241],["Land_Metal_rack_Tall_F",[-3.41016,5.37988,1.11005],92.3272],["Land_TableDesk_F",[-3.14844,2.06934,1.1102],-90.9453],["Land_OfficeChair_01_F",[-2.01953,2.09473,1.10979],-90.9453],["Land_OfficeCabinet_01_F",[-3.44531,-1.08301,1.11004],91.1442],["Land_OfficeCabinet_01_F",[-3.48438,-0.046875,1.10991],91.3931],["Land_WoodenCounter_01_F",[1.38672,0.825195,1.10851],89.1256],["Land_ChairWood_F",[0.234375,-0.736328,1.10896],-137.889],["Land_ChairWood_F",[0.318359,0.873047,1.10843],97.9613]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};					
			
			case "Land_i_Shop_01_V3_F":
				{
				_templates =  [[["Land_CashDesk_F",[-2.51563,4.05078,-2.75946],-3.08531],["Land_Icebox_F",[-3.05566,0.322266,-2.76091],92.9996],["Land_ShelvesMetal_F",[0.887695,0.810547,-2.75928],94.3427],["Land_OfficeChair_01_F",[-3.1377,5.73413,-2.76177],-170.402],["Land_LuggageHeap_01_F",[3.18652,4.79297,-2.76347],-119.654],["Land_CratesShabby_F",[-3.02246,4.10352,1.11193],103.7],["Land_Sack_F",[-2.87305,2.44775,1.11145],-237.117],["Land_Sack_F",[-2.78223,0.779541,1.11123],-221.076],["Land_Sacks_heap_F",[1.03027,1.40894,1.10914],1.2091],["Land_Sacks_heap_F",[0.969727,-0.264404,1.10968],91.2091]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_i_Shop_02_V2_F":
				{
				_templates =  [[["Land_Sacks_heap_F",[-1.2666,-3.29004,-2.66902],-58.4311],["Land_Sacks_heap_F",[-0.532227,-0.748779,-2.67464],1.56894],["Land_Sacks_goods_F",[2.1123,-2.18286,-2.67087],24.3402],["Land_Sacks_goods_F",[-3.8877,3.24756,-2.6676],-10.5067],["Land_Sack_F",[-3.05078,-3.62305,-2.68017],-184.254],["Land_WoodenCounter_01_F",[-2.94922,-3.90747,1.23761],-179.59],["Land_CampingChair_V2_F",[-1.03711,0.518066,1.23843],-36.8381],["Land_CampingChair_V2_F",[-0.660156,-2.07642,1.23843],38.1618],["Land_CampingTable_small_F",[-2.09277,-1.02124,1.23843],98.1618]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_i_Stone_Shed_V3_F":
				{
				_templates =  [[["Land_CratesShabby_F",[-2.58691,0.46875,-0.101868],-276.332],["Land_CratesShabby_F",[-2.9707,3.1582,-0.101288],-323.032],["Land_Sacks_heap_F",[0.973633,3.09668,-0.0992355],-64.1389]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_i_Addon_02_V1_F":
				{
				_templates = [[["Land_CanisterPlastic_F",[-2.63477,0.432861,0.112274],118.33],["Land_CanisterPlastic_F",[-2.64453,1.48047,0.112267],151.097],["Land_GasTank_01_blue_F",[-2.83203,2.32251,0.112267],137.304],["Land_GasTank_01_blue_F",[-2.60547,3.45093,0.112267],197.304],["Land_Sacks_goods_F",[2.63867,3.5769,0.112267],37.0699],["Land_Sacks_goods_F",[0.0976563,3.60352,0.112267],234.105],["Land_Sack_F",[0.322266,0.36084,0.112267],-3.7146]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_Hospital_side1_F":
				{
				_templates =  [[["Land_ChairPlastic_F",[9.42212,-19.2959,-7.89858],188.066],["Land_ChairPlastic_F",[9.04297,-15.5488,-7.89656],188.066],["Land_ChairPlastic_F",[4.56348,-13.6055,-7.89818],284.444],["Land_ChairPlastic_F",[1.71143,-13.3193,-7.89874],254.879],["Land_TableDesk_F",[4.10132,-11.7012,-7.89764],358.663],["Land_TableDesk_F",[-1.35913,-11.5898,-7.89979],358.425],["Land_TableDesk_F",[-5.66235,-8.60059,-7.90144],269.576],["Land_TableDesk_F",[-5.86011,-1.98242,-7.8973],270.471],["Land_TableDesk_F",[-1.4624,2.29688,-7.89318],178.873],["Land_TableDesk_F",[1.95679,-4.00195,-7.89482],0.476471],["Land_TableDesk_F",[1.97754,-5.08398,-7.89636],181.152],["Land_OfficeChair_01_F",[-4.32422,-8.56055,-7.89995],313.018],["Land_OfficeChair_01_F",[-1.21265,-10.2383,-7.89867],58.5525],["Land_OfficeChair_01_F",[4.05371,-10.1025,-7.89685],88.9229],["Land_OfficeChair_01_F",[2.17676,-6.82617,-7.89763],214.224],["Land_OfficeChair_01_F",[-4.2937,-2.12891,-7.89715],242.717],["Land_OfficeChair_01_F",[-1.40942,1.15234,-7.89421],223.927],["Land_OfficeCabinet_01_F",[7.79297,2.79004,-7.89371],357.304],["Land_OfficeCabinet_01_F",[9.58325,0.0595703,-7.89311],266.017],["Land_OfficeCabinet_01_F",[9.56909,-4.06836,-7.8938],269.959],["OfficeTable_01_new_F",[9.26563,-6.82129,-7.89424],269.959],["OfficeTable_01_old_F",[9.32349,-9.87891,-7.89488],269.959],["Land_OfficeChair_01_F",[8.59033,-8.10254,-7.89442],269.959]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_Hospital_main_F":
				{
				_templates =  [[["Land_OfficeChair_01_F",[11.8662,-0.567383,-8.01427],222.703],["Land_OfficeChair_01_F",[11.7969,-3.79395,-8.01486],274.093],["Land_OfficeChair_01_F",[11.4407,-8.85156,-8.01543],319.189],["Land_OfficeCabinet_01_F",[14.1477,-6.70703,-8.0136],265.536],["Land_OfficeCabinet_01_F",[12.4312,-12.6191,-8.01581],179.788],["Land_ChairPlastic_F",[6.1792,-20.7314,-8.01654],94.5191],["Land_ChairPlastic_F",[3.07446,-20.4092,-8.01648],109.751],["Land_ChairPlastic_F",[-0.787842,-20.3115,-8.01649],108.606],["Land_ChairPlastic_F",[-1.89111,-20.3066,-8.01653],99.6855],["Land_ChairPlastic_F",[-4.32666,-19.9893,-8.0165],107.424],["Land_ChairPlastic_F",[-3.1875,-15.2627,-8.01654],81.1865],["Land_ChairPlastic_F",[-1.81909,-15.0957,-8.01653],81.1865],["Land_ChairPlastic_F",[-0.109375,-15.2178,-8.01653],81.1865],["Land_ChairPlastic_F",[1.57642,-15.2334,-8.01654],81.1865],["Land_ChairPlastic_F",[2.07031,-16.7422,-8.01461],282.006],["Land_ChairPlastic_F",[-0.0100098,-16.6426,-8.01463],285.361],["Land_ChairPlastic_F",[-1.99756,-16.2695,-8.01462],256.266],["Land_ChairPlastic_F",[-3.42603,-16.9844,-8.01462],256.266],["Land_ChairPlastic_F",[13.9829,8.11816,-8.01143],188.066],["Land_ChairPlastic_F",[14.0769,10.2412,-8.01076],188.066],["Land_ChairPlastic_F",[8.24146,9.00488,-8.01239],172.315],["Land_ChairPlastic_F",[8.09619,10.5889,-8.01216],172.315],["Land_ChairPlastic_F",[8.20923,11.9453,-8.0126],103.496],["Land_ChairPlastic_F",[9.56494,11.8906,-8.01273],0.41571],["Land_ChairPlastic_F",[9.24878,10.4707,-8.01311],21.2025],["Land_ChairPlastic_F",[9.7793,8.59961,-8.01328],14.2363],["Land_OfficeChair_01_F",[11.8389,0.361328,-8.01363],157.688]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_CarService_F":
				{
				_templates =  [[["Land_CashDesk_F",[3.88208,4.31836,-1.25606],-1.00175],["Land_CashDesk_F",[2.05688,4.36133,-1.25606],-1.56795],["Land_CampingChair_V2_F",[3.76758,5.55859,-1.25606],-118.775],["Land_CampingChair_V2_F",[1.88794,5.36035,-1.25606],-43.7752],["Land_Icebox_F",[4.27637,0.712891,-1.25606],-87.8782],["Land_ShelvesMetal_F",[0.783203,1.16211,-1.25606],1.65422],["Land_Metal_rack_Tall_F",[4.55444,2.36426,-1.25606],-91.1416],["Land_PlasticCase_01_small_F",[-4.2146,7.78027,-1.28121],90.8949],["Land_Suitcase_F",[-4.93677,6.48242,-1.34064],105.895],["Land_CanisterFuel_F",[-0.868164,7.85742,-1.30537],-0.733185]],[["Land_ToiletBox_F",[-0.798828,7.31836,-1.32612],0.968552],["Land_Bucket_painted_F",[-0.462891,5.04395,-1.278],-71.4945],["Land_Bucket_painted_F",[-0.608154,4.67285,-1.24443],-106.827],["Land_WoodenCrate_01_F",[-0.680664,3.60938,-1.33706],180.4],["Land_CratesShabby_F",[-0.635986,2.24707,-1.29713],-169.719],["Land_GarbageHeap_02_F",[-4.33325,0.924805,-1.22588],-91.2802],["Land_JunkPile_F",[-3.68066,6.94531,-1.27075],150.141],["Land_GarbageContainer_open_F",[-4.62915,4.7793,-1.37846],-90.1608],["Land_BarrelTrash_grey_F",[-1.77881,7.99512,-1.30081],172.032],["Land_BarrelTrash_grey_F",[-0.58252,-1.36426,-1.31081],13.9082],["Land_BarrelTrash_grey_F",[-1.08813,-1.625,-1.31081],65.0054],["Land_BarrelTrash_F",[-0.581543,-0.772461,-1.31081],11.4019],["Land_BarrelTrash_F",[-1.08911,-0.880859,-1.31081],92.8956],["Land_BarrelTrash_grey_F",[-0.84375,-0.214844,-1.33429],92.8956],["Land_Bench_F",[3.48486,-1.49902,-1.30274],89.7291],["Land_Bench_F",[4.6604,-0.145508,-1.30274],180.127],["Land_CampingTable_small_F",[3.05859,0.424805,-1.26256],180.69],["Land_TableDesk_F",[0.55835,4.63867,-1.31312],-89.651],["Land_CashDesk_F",[1.00659,3.35938,-1.25606],-0.0212708],["Land_OfficeChair_01_F",[1.36133,4.96289,-1.28048],-47.8687],["Land_Laptop_F",[0.598877,4.59863,-0.477567],-71.2],["Land_WaterCooler_01_new_F",[4.19897,8.28125,-1.28813],0.889847],["Land_GarbageBin_01_F",[0.657715,2.4834,-1.07014],51.5958],["Land_WoodenTable_large_F",[4.37793,2.99805,-1.28836],0.963593],["Land_WoodenBox_F",[4.36182,4.68066,-1.25606],-95.1816],["Land_MetalBarrel_F",[3.87524,5.82617,-1.27874],168.715],["Land_OfficeCabinet_01_F",[4.71704,6.91309,-1.28656],-89.9677],["Land_MetalBarrel_F",[4.56836,6.11426,-1.27874],-167.391],["Land_WoodenBox_F",[1.43311,7.91992,-1.25606],15.5185],["Land_Bucket_painted_F",[2.25732,8.05859,-0.844428],17.3957]],[["Land_ToolTrolley_02_F",[-2.38179,8.11719,-1.25895],100.507],["Land_FireExtinguisher_F",[-0.417236,5.28027,-1.27571],-93.779],["Land_Portable_generator_F",[-4.87378,-1.19531,-1.29026],117.014],["Land_ShelvesMetal_F",[3.96167,6.56836,-1.25896],-88.0102],["Land_ShelvesMetal_F",[3.97021,4.44238,-1.25896],-91.3878],["Land_ShelvesMetal_F",[3.96313,2.28418,-1.25896],-90.6151],["Land_ShelvesMetal_F",[3.97681,-0.105469,-1.25896],-90.5952],["Land_Icebox_F",[1.14746,8.05176,-1.32831],0.0249939],["Land_CashDesk_F",[0.947021,4.26953,-1.25606],0.30426],["Land_ChairWood_F",[1.47119,4.97461,-1.2554],-29.5835],["Land_Sacks_heap_F",[-0.883789,-0.820313,-1.39342],87.6564],["Land_CratesShabby_F",[-0.793701,7.8877,-1.3059],50.5728],["Fridge_01_closed_F",[-0.591309,0.416992,-1.34517],-89.5873],["Land_ShelvesWooden_F",[0.428223,1.4209,-1.30785],-0.325439],["Land_ShelvesWooden_F",[0.424072,0.461914,-1.30785],-0.0588226],["Land_Metal_rack_Tall_F",[-5.21143,1.6709,-1.28708],90.0396],["Land_Metal_rack_Tall_F",[-5.21851,2.42773,-1.28782],91.2058],["Land_Metal_rack_Tall_F",[-5.2251,3.19531,-1.28848],89.5169],["Land_Leaflet_03_F",[0.120361,5.06445,0.438939],87.9245],["Land_ToolTrolley_01_F",[-4.87061,4.38574,-1.28081],16.925],["Land_Bucket_clean_F",[-0.414551,4.47949,-1.29443],-71.43],["Land_WoodenCounter_01_F",[-0.675293,2.49414,-1.3137],-90.0238],["Land_CanisterFuel_F",[-5.11694,6.9668,-1.22956],29.9609]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_Offices_01_V1_F":
				{
				_templates =  [[["Fridge_01_closed_F",[12.4102,7.64551,-7.05996],-5.12289],["OfficeTable_01_old_F",[12.3311,5.58691,-7.05911],-90.1258],["OfficeTable_01_new_F",[9.46436,1.22266,-7.05802],182.067],["Land_OfficeChair_01_F",[9.61328,2.63672,-7.05802],182.067],["Land_OfficeChair_01_F",[11.332,5.65723,-7.05974],32.2299],["Land_OfficeCabinet_01_F",[8.37646,7.09961,-7.05887],89.6796],["Land_Metal_rack_Tall_F",[12.4795,2.72168,-7.05914],-88.3314]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};			
				
			case "Land_i_Garage_V1_F ":
				{
				_templates = [[["Land_Metal_rack_F",[4.7627,-0.800781,-0.0950508],-91.2214],["Land_CratesShabby_F",[2.29297,-2.11328,-0.0996742],-171.421],["Land_CanisterFuel_F",[3.56641,2.48047,-0.0946388],-6.2593],["Land_CanisterPlastic_F",[4.41992,2.11523,-0.094635],-6.2593],["Land_GasTank_01_blue_F",[4.30371,-1.75781,-0.0975342],-134.613]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_i_Garage_V2_F ":
				{
				_templates = [[["Land_Metal_rack_F",[4.7627,-0.800781,-0.0950508],-91.2214],["Land_CratesShabby_F",[2.29297,-2.11328,-0.0996742],-171.421],["Land_CanisterFuel_F",[3.56641,2.48047,-0.0946388],-6.2593],["Land_CanisterPlastic_F",[4.41992,2.11523,-0.094635],-6.2593],["Land_GasTank_01_blue_F",[4.30371,-1.75781,-0.0975342],-134.613]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
				
			case "Land_House_Small_05_F":
				{
				_templates = [[["Land_TablePlastic_01_F",[-2.27759,4.47461,-1.08479],-0.0303669],["Land_ChairPlastic_F",[-2.06104,3.22852,-1.08459],-300.03],["Land_ChairPlastic_F",[-0.758789,4.20215,-1.08459],-205.387],["Land_Metal_rack_F",[1.06372,4.9,-1.0843],1.95515],["Fridge_01_closed_F",[-3.58472,-0.962402,-1.08638],-180.638],["Land_Basket_F",[-3.49634,2.08154,-1.08658],-235.633],["Land_Sack_F",[-3.47778,3.04053,-1.08616],-259.309],["Land_BarrelWater_F",[1.37671,2.81934,-1.08389],-28.8263],["Land_PlasticCase_01_small_F",[1.41821,0.745117,-1.08353],1.17369],["Land_CanisterFuel_F",[1.39722,-1.11133,-1.08453],-61.7261],["Land_GasTank_01_blue_F",[1.41504,-0.307617,-1.0839],-34.2241],["Land_WoodenTable_small_F",[-1.54272,-0.849121,-1.08609],-91.1185]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			// MALDEN
			case "Land_i_House_Small_02_c_blue_F":
				{
				_templates = [[["Land_WoodenTable_large_F",[-4.35205,1.75879,-0.588531],89.4604],["Land_RattanChair_01_F",[-4.56323,0.762695,-0.591324],113.514],["Land_ChairWood_F",[-2.03955,-3.35156,-0.590698],-96.5497],["Land_WoodenCounter_01_F",[-1.59277,-1.3916,-0.591003],90.9182],["OfficeTable_01_old_F",[-0.425537,-2.26367,-0.585556],85.8564],["Land_OfficeChair_01_F",[0.479248,-2.42969,-0.583649],-58.6722],["Land_OfficeCabinet_01_F",[4.42212,-3.48242,-0.582565],179.174],["Land_TableDesk_F",[5.18848,0.793945,-0.581619],89.4624],["Land_RattanChair_01_F",[4.26758,0.782227,-0.582291],119.297],["Land_PlasticCase_01_small_F",[-0.213379,-1.15918,-0.584213],-108.662],["Land_Suitcase_F",[3.31689,-3.47559,-0.583481],0.036087]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	
			case "Land_i_House_Small_02_c_yellow_F":
				{
				_templates = [[["Land_WoodenTable_large_F",[-4.35205,1.75879,-0.588531],89.4604],["Land_RattanChair_01_F",[-4.56323,0.762695,-0.591324],113.514],["Land_ChairWood_F",[-2.03955,-3.35156,-0.590698],-96.5497],["Land_WoodenCounter_01_F",[-1.59277,-1.3916,-0.591003],90.9182],["OfficeTable_01_old_F",[-0.425537,-2.26367,-0.585556],85.8564],["Land_OfficeChair_01_F",[0.479248,-2.42969,-0.583649],-58.6722],["Land_OfficeCabinet_01_F",[4.42212,-3.48242,-0.582565],179.174],["Land_TableDesk_F",[5.18848,0.793945,-0.581619],89.4624],["Land_RattanChair_01_F",[4.26758,0.782227,-0.582291],119.297],["Land_PlasticCase_01_small_F",[-0.213379,-1.15918,-0.584213],-108.662],["Land_Suitcase_F",[3.31689,-3.47559,-0.583481],0.036087]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	
			case "Land_i_House_Small_02_c_pink_F":
				{
				_templates = [[["Land_WoodenTable_large_F",[-4.35205,1.75879,-0.588531],89.4604],["Land_RattanChair_01_F",[-4.56323,0.762695,-0.591324],113.514],["Land_ChairWood_F",[-2.03955,-3.35156,-0.590698],-96.5497],["Land_WoodenCounter_01_F",[-1.59277,-1.3916,-0.591003],90.9182],["OfficeTable_01_old_F",[-0.425537,-2.26367,-0.585556],85.8564],["Land_OfficeChair_01_F",[0.479248,-2.42969,-0.583649],-58.6722],["Land_OfficeCabinet_01_F",[4.42212,-3.48242,-0.582565],179.174],["Land_TableDesk_F",[5.18848,0.793945,-0.581619],89.4624],["Land_RattanChair_01_F",[4.26758,0.782227,-0.582291],119.297],["Land_PlasticCase_01_small_F",[-0.213379,-1.15918,-0.584213],-108.662],["Land_Suitcase_F",[3.31689,-3.47559,-0.583481],0.036087]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	
			case "Land_i_House_Small_02_c_brown_F":
				{
				_templates = [[["Land_WoodenTable_large_F",[-4.35205,1.75879,-0.588531],89.4604],["Land_RattanChair_01_F",[-4.56323,0.762695,-0.591324],113.514],["Land_ChairWood_F",[-2.03955,-3.35156,-0.590698],-96.5497],["Land_WoodenCounter_01_F",[-1.59277,-1.3916,-0.591003],90.9182],["OfficeTable_01_old_F",[-0.425537,-2.26367,-0.585556],85.8564],["Land_OfficeChair_01_F",[0.479248,-2.42969,-0.583649],-58.6722],["Land_OfficeCabinet_01_F",[4.42212,-3.48242,-0.582565],179.174],["Land_TableDesk_F",[5.18848,0.793945,-0.581619],89.4624],["Land_RattanChair_01_F",[4.26758,0.782227,-0.582291],119.297],["Land_PlasticCase_01_small_F",[-0.213379,-1.15918,-0.584213],-108.662],["Land_Suitcase_F",[3.31689,-3.47559,-0.583481],0.036087]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	
			case "Land_i_House_Small_02_c_whiteblue_F":
				{
				_templates = [[["Land_WoodenTable_large_F",[-4.35205,1.75879,-0.588531],89.4604],["Land_RattanChair_01_F",[-4.56323,0.762695,-0.591324],113.514],["Land_ChairWood_F",[-2.03955,-3.35156,-0.590698],-96.5497],["Land_WoodenCounter_01_F",[-1.59277,-1.3916,-0.591003],90.9182],["OfficeTable_01_old_F",[-0.425537,-2.26367,-0.585556],85.8564],["Land_OfficeChair_01_F",[0.479248,-2.42969,-0.583649],-58.6722],["Land_OfficeCabinet_01_F",[4.42212,-3.48242,-0.582565],179.174],["Land_TableDesk_F",[5.18848,0.793945,-0.581619],89.4624],["Land_RattanChair_01_F",[4.26758,0.782227,-0.582291],119.297],["Land_PlasticCase_01_small_F",[-0.213379,-1.15918,-0.584213],-108.662],["Land_Suitcase_F",[3.31689,-3.47559,-0.583481],0.036087]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	
			case "Land_i_House_Small_02_c_white_F":
				{
				_templates = [[["Land_WoodenTable_large_F",[-4.35205,1.75879,-0.588531],89.4604],["Land_RattanChair_01_F",[-4.56323,0.762695,-0.591324],113.514],["Land_ChairWood_F",[-2.03955,-3.35156,-0.590698],-96.5497],["Land_WoodenCounter_01_F",[-1.59277,-1.3916,-0.591003],90.9182],["OfficeTable_01_old_F",[-0.425537,-2.26367,-0.585556],85.8564],["Land_OfficeChair_01_F",[0.479248,-2.42969,-0.583649],-58.6722],["Land_OfficeCabinet_01_F",[4.42212,-3.48242,-0.582565],179.174],["Land_TableDesk_F",[5.18848,0.793945,-0.581619],89.4624],["Land_RattanChair_01_F",[4.26758,0.782227,-0.582291],119.297],["Land_PlasticCase_01_small_F",[-0.213379,-1.15918,-0.584213],-108.662],["Land_Suitcase_F",[3.31689,-3.47559,-0.583481],0.036087]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};					

			case "Land_i_House_Small_01_b_blue_F":
				{
				_templates = [[["Land_CanisterPlastic_F",[2.08398,4.49023,-1.03958],46.0271],["Land_ChairPlastic_F",[3.7832,4.11719,-1.07374],-119.167],["Land_ChairPlastic_F",[-4.08203,-3.82422,-1.02398],35.2988],["Land_TablePlastic_01_F",[-3.9375,-0.464844,-1.0852],88.3407],["Land_ChairPlastic_F",[-2.68652,-0.84375,-1.07325],157.217],["Land_ChairPlastic_F",[-2.85938,0.480469,-1.02343],187.217],["Land_WoodenTable_large_F",[0.878906,-2.44531,-1.02346],1.58008],["Land_RattanChair_01_F",[0.158203,-2.23047,-1.04972],46.5948],["Land_PlasticCase_01_small_F",[0.764648,-2.24219,-0.147858],23.7305],["Land_Sack_F",[-0.423828,4.31641,-1.03956],45.0582],["Land_Sack_F",[-1.82422,4.45703,-1.03967],150.058],["Land_Basket_F",[-1.30469,0.972656,-1.18567],-106.466],["Fridge_01_closed_F",[-1.40723,-3.88477,-1.15955],176.421]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};			

			case "Land_i_House_Small_02_b_blue_F":
				{
				_templates = [[["Land_CampingTable_F",[-4.52881,1.90137,-0.588028],3.24768],["Land_CampingChair_V2_F",[-4.48291,1.12305,-0.590683],168.248],["Land_CampingChair_V2_F",[-3.00928,1.77588,-0.588455],-131.752],["Land_WoodenTable_small_F",[-2.12305,-2.80664,-0.590919],87.1347],["Land_OfficeCabinet_01_F",[-1.4624,-0.292969,-0.590393],-90.5812],["Fridge_01_closed_F",[-5.25928,-0.675781,-0.588394],88.6826],["Land_LuggageHeap_01_F",[-1.61865,-1.7002,-0.587791],-161.539],["Land_ShelvesWooden_F",[0.768555,-3.10889,-0.585327],-92.9928],["Land_Basket_F",[-0.217773,-2.94922,-0.585205],-126.326],["Land_CratesShabby_F",[-0.103516,-1.70996,-0.584274],-153.962],["Land_Sack_F",[-0.279297,-0.504883,-0.584274],170.58],["Land_PlasticCase_01_large_F",[4.97168,2.19385,-0.580101],88.9096],["Land_BarrelWater_F",[2.10889,-3.2334,-0.582039],-131.095],["Land_Metal_rack_Tall_F",[1.45605,2.21289,-0.582809],-1.64015],["Land_ChairWood_F",[4.00488,-3.11963,-0.580872],125.577]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	


			case "Land_i_House_Big_01_b_blue_F":
				{
				_templates =  [[["Land_TablePlastic_01_F",[-0.279297,6.46289,-2.56494],-1.34801],["Land_ChairPlastic_F",[-1.7832,6.5752,-2.56494],-2.40092],["Land_ChairPlastic_F",[-0.296875,5.48828,-2.56494],83.7812],["Land_ChairPlastic_F",[1.53516,5.89844,-2.56494],158.718],["Land_WoodenTable_small_F",[-3.31641,3.84277,-2.56494],-87.8386],["Land_OfficeCabinet_01_F",[-3.44141,6.89551,-2.56494],0.909653],["OfficeTable_01_new_F",[3.79883,3.84375,-2.56494],0.0835114],["Land_CampingChair_b_blue_F",[2.08691,3.57324,-2.56494],-179.825],["Fridge_01_closed_F",[-3.81738,1.63281,-2.56494],96.9639],["Land_BarrelWater_F",[-3.84668,2.35742,-2.56494],64.9382],["Land_WoodenTable_large_F",[1.39258,-0.125977,-2.56494],0.560516],["Land_ChairWood_F",[0.290039,-0.0556641,-2.56494],146.572],["Land_ChairWood_F",[1.24316,-1.74121,-2.56494],-188.069],["Land_ChairWood_F",[2.2627,-0.65918,-2.56494],-98.0686],["Land_WoodenCounter_01_F",[-1.12305,-2.81348,-2.56494],-90.0677],["Land_Metal_rack_F",[1.48145,-6.75977,-2.56494],-179.451],["Land_Metal_rack_Tall_F",[4.22559,-3.98535,-2.56494],-92.7952],["Land_LuggageHeap_01_F",[3.68945,-3.7207,0.855064],-58.1014],["Land_PlasticCase_01_large_F",[1.82031,-6.79102,0.855064],-90.0129],["Land_Suitcase_F",[4.0957,-6.70996,0.855064],19.5407],["Land_Sleeping_bag_F",[2.91797,-5.13184,0.855064],56.2859],["Land_Sleeping_bag_blue_folded_F",[3.84668,-4.60449,0.855064],65.0301],["Land_Ground_sheet_folded_F",[1.4502,-3.76074,0.855064],81.098],["Land_FMradio_F",[2.75195,-6.65527,0.855064],32.7554],["Land_CampingTable_small_F",[-1.75977,-6.37012,0.855064],-0.760391],["Land_CampingChair_b_blue_F",[-1.91211,-5.57031,0.855064],3.5764],["Land_CampingChair_b_blue_F",[-2.87891,-6.31641,0.855064],63.5764],["Land_ShelvesWooden_F",[4.18848,-1.94336,0.855064],-179.129],["Land_Sack_F",[2.32324,0.673828,0.855064],-141.559],["Land_Sack_F",[2.17188,-0.499023,0.855064],-105.913],["Land_Sacks_goods_F",[1.00977,-1.98047,0.855064],-177.147],["Land_CanisterPlastic_F",[-3.76758,2.36816,0.855066],-5.05688],["Land_CanisterPlastic_F",[-3.91016,-1.09863,0.855064],39.9431],["Land_GasTank_01_blue_F",[0.870117,0.0986328,0.855064],-61.4245]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};


			case "Land_i_House_Big_02_b_blue_F":
				{
				_templates = [[["Fridge_01_closed_F",[2.12891,-1.1084,-2.62491],-94.3556],["Land_Basket_F",[1.83203,-1.92969,-2.62556],-106.438],["Land_ShelvesWooden_F",[-3.38086,-1.18848,-2.6199],90.0902],["Land_ShelvesMetal_F",[1.80664,0.173828,-2.6269],-89.9523],["Land_ShelvesWooden_F",[4.19531,0.828125,-2.62674],-4.50794],["Land_TableDesk_F",[4.08984,3.54492,-2.62547],90.2152],["Land_OfficeChair_01_F",[2.99219,3.5459,-2.62547],90.2152],["Land_OfficeChair_01_F",[4.18359,1.91211,-2.62514],-203.348],["Land_WoodenCounter_01_F",[-4.02344,2.15625,-2.6219],90.2379],["Land_ChairWood_F",[-3.32422,4.33008,-2.62135],35.4309],["Land_CanisterPlastic_F",[-3.94336,0.236328,-2.6234],69.1718],["Land_CanisterPlastic_F",[-3.85547,-1.22266,0.787415],0.607124],["Land_CanisterPlastic_F",[-3.81055,-1.83594,0.787415],30.6071],["Land_CanisterPlastic_F",[-3.80469,-2.80664,0.787415],75.6071],["Land_GasTank_01_blue_F",[-3.82422,-3.73633,0.786346],103.539],["Land_PlasticCase_01_large_F",[2.38477,0.078125,0.780411],-97.4489],["Land_BarrelWater_F",[4.38086,0.0273438,0.780487],-85.2888],["Land_Sacks_heap_F",[3.78906,1.19043,0.780487],-85.2888],["Land_Sacks_heap_F",[3.85352,3.10742,0.781708],87.4758],["Land_Sleeping_bag_blue_folded_F",[1.67969,4.63672,0.784164],-231.154],["Land_Sleeping_bag_blue_folded_F",[2.46094,4.43945,0.784164],-201.154],["Land_LuggageHeap_02_F",[-0.681641,4.61914,0.787247],-142.198],["Land_CratesShabby_F",[-3.80078,0.439453,0.784561],-30.6144],["Land_Sack_F",[-3.97266,1.52148,0.784927],-51.4324],["Land_ChairWood_F",[1.04102,0.108398,0.780457],-193.077],["Land_WoodenTable_small_F",[-1.17578,-3.37305,0.782806],87.3334]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
 	
			case "Land_i_Shop_01_b_blue_F":
				{
				_templates =  [[["Land_ShelvesMetal_F",[-1.84546,0.521484,-2.76157],-0.0969238],["Land_ShelvesMetal_F",[1.35376,1.49023,-2.76157],177.141],["Land_CashDesk_F",[-2.81934,4.38867,-2.76157],-1.98949],["Land_OfficeChair_01_F",[-2.66797,5.48828,-2.76158],52.5127],["Fridge_01_closed_F",[3.04639,4.69727,-2.76157],182.912],["Land_ShelvesWooden_F",[-3.10693,6.19922,1.10981],182.241],["Land_WoodenCounter_01_F",[1.44971,0.595703,1.10873],-91.404],["Land_WoodenTable_large_F",[-2.93579,2.07227,1.10927],179.546],["Land_CampingChair_V2_F",[-1.72656,2.06836,1.1089],-120.454],["Land_CampingChair_V2_F",[-2.604,0.347656,1.1095],145.662],["Land_LuggageHeap_02_F",[-2.92627,3.92969,1.10938],103.453]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};		

			case "Land_i_Shop_02_b_blue_F":
				{
				_templates =  [[["Land_Sacks_heap_F",[-1.2666,-3.29004,-2.66902],-58.4311],["Land_Sacks_heap_F",[-0.532227,-0.748779,-2.67464],1.56894],["Land_Sacks_goods_F",[2.1123,-2.18286,-2.67087],24.3402],["Land_Sacks_goods_F",[-3.8877,3.24756,-2.6676],-10.5067],["Land_Sack_F",[-3.05078,-3.62305,-2.68017],-184.254],["Land_WoodenCounter_01_F",[-2.94922,-3.90747,1.23761],-179.59],["Land_CampingChair_V2_F",[-1.03711,0.518066,1.23843],-36.8381],["Land_CampingChair_V2_F",[-0.660156,-2.07642,1.23843],38.1618],["Land_CampingTable_small_F",[-2.09277,-1.02124,1.23843],98.1618]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
			case "Land_i_House_Small_01_b_white_F":
				{
				_templates = [[["Land_CanisterPlastic_F",[2.08398,4.49023,-1.03958],46.0271],["Land_ChairPlastic_F",[3.7832,4.11719,-1.07374],-119.167],["Land_ChairPlastic_F",[-4.08203,-3.82422,-1.02398],35.2988],["Land_TablePlastic_01_F",[-3.9375,-0.464844,-1.0852],88.3407],["Land_ChairPlastic_F",[-2.68652,-0.84375,-1.07325],157.217],["Land_ChairPlastic_F",[-2.85938,0.480469,-1.02343],187.217],["Land_WoodenTable_large_F",[0.878906,-2.44531,-1.02346],1.58008],["Land_RattanChair_01_F",[0.158203,-2.23047,-1.04972],46.5948],["Land_PlasticCase_01_small_F",[0.764648,-2.24219,-0.147858],23.7305],["Land_Sack_F",[-0.423828,4.31641,-1.03956],45.0582],["Land_Sack_F",[-1.82422,4.45703,-1.03967],150.058],["Land_Basket_F",[-1.30469,0.972656,-1.18567],-106.466],["Fridge_01_closed_F",[-1.40723,-3.88477,-1.15955],176.421]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};			
		 
			case "Land_i_House_Small_02_b_white_F":
				{
				_templates = [[["Land_CampingTable_F",[-4.52881,1.90137,-0.588028],3.24768],["Land_CampingChair_V2_F",[-4.48291,1.12305,-0.590683],168.248],["Land_CampingChair_V2_F",[-3.00928,1.77588,-0.588455],-131.752],["Land_WoodenTable_small_F",[-2.12305,-2.80664,-0.590919],87.1347],["Land_OfficeCabinet_01_F",[-1.4624,-0.292969,-0.590393],-90.5812],["Fridge_01_closed_F",[-5.25928,-0.675781,-0.588394],88.6826],["Land_LuggageHeap_01_F",[-1.61865,-1.7002,-0.587791],-161.539],["Land_ShelvesWooden_F",[0.768555,-3.10889,-0.585327],-92.9928],["Land_Basket_F",[-0.217773,-2.94922,-0.585205],-126.326],["Land_CratesShabby_F",[-0.103516,-1.70996,-0.584274],-153.962],["Land_Sack_F",[-0.279297,-0.504883,-0.584274],170.58],["Land_PlasticCase_01_large_F",[4.97168,2.19385,-0.580101],88.9096],["Land_BarrelWater_F",[2.10889,-3.2334,-0.582039],-131.095],["Land_Metal_rack_Tall_F",[1.45605,2.21289,-0.582809],-1.64015],["Land_ChairWood_F",[4.00488,-3.11963,-0.580872],125.577]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	


			case "Land_i_House_Big_01_b_white_F":
				{
				_templates =  [[["Land_TablePlastic_01_F",[-0.279297,6.46289,-2.56494],-1.34801],["Land_ChairPlastic_F",[-1.7832,6.5752,-2.56494],-2.40092],["Land_ChairPlastic_F",[-0.296875,5.48828,-2.56494],83.7812],["Land_ChairPlastic_F",[1.53516,5.89844,-2.56494],158.718],["Land_WoodenTable_small_F",[-3.31641,3.84277,-2.56494],-87.8386],["Land_OfficeCabinet_01_F",[-3.44141,6.89551,-2.56494],0.909653],["OfficeTable_01_new_F",[3.79883,3.84375,-2.56494],0.0835114],["Land_CampingChair_b_white_F",[2.08691,3.57324,-2.56494],-179.825],["Fridge_01_closed_F",[-3.81738,1.63281,-2.56494],96.9639],["Land_BarrelWater_F",[-3.84668,2.35742,-2.56494],64.9382],["Land_WoodenTable_large_F",[1.39258,-0.125977,-2.56494],0.560516],["Land_ChairWood_F",[0.290039,-0.0556641,-2.56494],146.572],["Land_ChairWood_F",[1.24316,-1.74121,-2.56494],-188.069],["Land_ChairWood_F",[2.2627,-0.65918,-2.56494],-98.0686],["Land_WoodenCounter_01_F",[-1.12305,-2.81348,-2.56494],-90.0677],["Land_Metal_rack_F",[1.48145,-6.75977,-2.56494],-179.451],["Land_Metal_rack_Tall_F",[4.22559,-3.98535,-2.56494],-92.7952],["Land_LuggageHeap_01_F",[3.68945,-3.7207,0.855064],-58.1014],["Land_PlasticCase_01_large_F",[1.82031,-6.79102,0.855064],-90.0129],["Land_Suitcase_F",[4.0957,-6.70996,0.855064],19.5407],["Land_Sleeping_bag_F",[2.91797,-5.13184,0.855064],56.2859],["Land_Sleeping_bag_blue_folded_F",[3.84668,-4.60449,0.855064],65.0301],["Land_Ground_sheet_folded_F",[1.4502,-3.76074,0.855064],81.098],["Land_FMradio_F",[2.75195,-6.65527,0.855064],32.7554],["Land_CampingTable_small_F",[-1.75977,-6.37012,0.855064],-0.760391],["Land_CampingChair_b_white_F",[-1.91211,-5.57031,0.855064],3.5764],["Land_CampingChair_b_white_F",[-2.87891,-6.31641,0.855064],63.5764],["Land_ShelvesWooden_F",[4.18848,-1.94336,0.855064],-179.129],["Land_Sack_F",[2.32324,0.673828,0.855064],-141.559],["Land_Sack_F",[2.17188,-0.499023,0.855064],-105.913],["Land_Sacks_goods_F",[1.00977,-1.98047,0.855064],-177.147],["Land_CanisterPlastic_F",[-3.76758,2.36816,0.855066],-5.05688],["Land_CanisterPlastic_F",[-3.91016,-1.09863,0.855064],39.9431],["Land_GasTank_01_blue_F",[0.870117,0.0986328,0.855064],-61.4245]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};


			case "Land_i_House_Big_02_b_white_F":
				{
				_templates = [[["Fridge_01_closed_F",[2.12891,-1.1084,-2.62491],-94.3556],["Land_Basket_F",[1.83203,-1.92969,-2.62556],-106.438],["Land_ShelvesWooden_F",[-3.38086,-1.18848,-2.6199],90.0902],["Land_ShelvesMetal_F",[1.80664,0.173828,-2.6269],-89.9523],["Land_ShelvesWooden_F",[4.19531,0.828125,-2.62674],-4.50794],["Land_TableDesk_F",[4.08984,3.54492,-2.62547],90.2152],["Land_OfficeChair_01_F",[2.99219,3.5459,-2.62547],90.2152],["Land_OfficeChair_01_F",[4.18359,1.91211,-2.62514],-203.348],["Land_WoodenCounter_01_F",[-4.02344,2.15625,-2.6219],90.2379],["Land_ChairWood_F",[-3.32422,4.33008,-2.62135],35.4309],["Land_CanisterPlastic_F",[-3.94336,0.236328,-2.6234],69.1718],["Land_CanisterPlastic_F",[-3.85547,-1.22266,0.787415],0.607124],["Land_CanisterPlastic_F",[-3.81055,-1.83594,0.787415],30.6071],["Land_CanisterPlastic_F",[-3.80469,-2.80664,0.787415],75.6071],["Land_GasTank_01_blue_F",[-3.82422,-3.73633,0.786346],103.539],["Land_PlasticCase_01_large_F",[2.38477,0.078125,0.780411],-97.4489],["Land_BarrelWater_F",[4.38086,0.0273438,0.780487],-85.2888],["Land_Sacks_heap_F",[3.78906,1.19043,0.780487],-85.2888],["Land_Sacks_heap_F",[3.85352,3.10742,0.781708],87.4758],["Land_Sleeping_bag_blue_folded_F",[1.67969,4.63672,0.784164],-231.154],["Land_Sleeping_bag_blue_folded_F",[2.46094,4.43945,0.784164],-201.154],["Land_LuggageHeap_02_F",[-0.681641,4.61914,0.787247],-142.198],["Land_CratesShabby_F",[-3.80078,0.439453,0.784561],-30.6144],["Land_Sack_F",[-3.97266,1.52148,0.784927],-51.4324],["Land_ChairWood_F",[1.04102,0.108398,0.780457],-193.077],["Land_WoodenTable_small_F",[-1.17578,-3.37305,0.782806],87.3334]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
 	
			case "Land_i_Shop_01_b_white_F":
				{
				_templates =  [[["Land_ShelvesMetal_F",[-1.84546,0.521484,-2.76157],-0.0969238],["Land_ShelvesMetal_F",[1.35376,1.49023,-2.76157],177.141],["Land_CashDesk_F",[-2.81934,4.38867,-2.76157],-1.98949],["Land_OfficeChair_01_F",[-2.66797,5.48828,-2.76158],52.5127],["Fridge_01_closed_F",[3.04639,4.69727,-2.76157],182.912],["Land_ShelvesWooden_F",[-3.10693,6.19922,1.10981],182.241],["Land_WoodenCounter_01_F",[1.44971,0.595703,1.10873],-91.404],["Land_WoodenTable_large_F",[-2.93579,2.07227,1.10927],179.546],["Land_CampingChair_V2_F",[-1.72656,2.06836,1.1089],-120.454],["Land_CampingChair_V2_F",[-2.604,0.347656,1.1095],145.662],["Land_LuggageHeap_02_F",[-2.92627,3.92969,1.10938],103.453]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};		

			case "Land_i_Shop_02_b_white_F":
				{
				_templates =  [[["Land_Sacks_heap_F",[-1.2666,-3.29004,-2.66902],-58.4311],["Land_Sacks_heap_F",[-0.532227,-0.748779,-2.67464],1.56894],["Land_Sacks_goods_F",[2.1123,-2.18286,-2.67087],24.3402],["Land_Sacks_goods_F",[-3.8877,3.24756,-2.6676],-10.5067],["Land_Sack_F",[-3.05078,-3.62305,-2.68017],-184.254],["Land_WoodenCounter_01_F",[-2.94922,-3.90747,1.23761],-179.59],["Land_CampingChair_V2_F",[-1.03711,0.518066,1.23843],-36.8381],["Land_CampingChair_V2_F",[-0.660156,-2.07642,1.23843],38.1618],["Land_CampingTable_small_F",[-2.09277,-1.02124,1.23843],98.1618]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_i_House_Small_01_b_brown_F":
				{
				_templates = [[["Land_CanisterPlastic_F",[2.08398,4.49023,-1.03958],46.0271],["Land_ChairPlastic_F",[3.7832,4.11719,-1.07374],-119.167],["Land_ChairPlastic_F",[-4.08203,-3.82422,-1.02398],35.2988],["Land_TablePlastic_01_F",[-3.9375,-0.464844,-1.0852],88.3407],["Land_ChairPlastic_F",[-2.68652,-0.84375,-1.07325],157.217],["Land_ChairPlastic_F",[-2.85938,0.480469,-1.02343],187.217],["Land_WoodenTable_large_F",[0.878906,-2.44531,-1.02346],1.58008],["Land_RattanChair_01_F",[0.158203,-2.23047,-1.04972],46.5948],["Land_PlasticCase_01_small_F",[0.764648,-2.24219,-0.147858],23.7305],["Land_Sack_F",[-0.423828,4.31641,-1.03956],45.0582],["Land_Sack_F",[-1.82422,4.45703,-1.03967],150.058],["Land_Basket_F",[-1.30469,0.972656,-1.18567],-106.466],["Fridge_01_closed_F",[-1.40723,-3.88477,-1.15955],176.421]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};			
		 
			case "Land_i_House_Small_02_b_brown_F":
				{
				_templates = [[["Land_CampingTable_F",[-4.52881,1.90137,-0.588028],3.24768],["Land_CampingChair_V2_F",[-4.48291,1.12305,-0.590683],168.248],["Land_CampingChair_V2_F",[-3.00928,1.77588,-0.588455],-131.752],["Land_WoodenTable_small_F",[-2.12305,-2.80664,-0.590919],87.1347],["Land_OfficeCabinet_01_F",[-1.4624,-0.292969,-0.590393],-90.5812],["Fridge_01_closed_F",[-5.25928,-0.675781,-0.588394],88.6826],["Land_LuggageHeap_01_F",[-1.61865,-1.7002,-0.587791],-161.539],["Land_ShelvesWooden_F",[0.768555,-3.10889,-0.585327],-92.9928],["Land_Basket_F",[-0.217773,-2.94922,-0.585205],-126.326],["Land_CratesShabby_F",[-0.103516,-1.70996,-0.584274],-153.962],["Land_Sack_F",[-0.279297,-0.504883,-0.584274],170.58],["Land_PlasticCase_01_large_F",[4.97168,2.19385,-0.580101],88.9096],["Land_BarrelWater_F",[2.10889,-3.2334,-0.582039],-131.095],["Land_Metal_rack_Tall_F",[1.45605,2.21289,-0.582809],-1.64015],["Land_ChairWood_F",[4.00488,-3.11963,-0.580872],125.577]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	


			case "Land_i_House_Big_01_b_brown_F":
				{
				_templates =  [[["Land_TablePlastic_01_F",[-0.279297,6.46289,-2.56494],-1.34801],["Land_ChairPlastic_F",[-1.7832,6.5752,-2.56494],-2.40092],["Land_ChairPlastic_F",[-0.296875,5.48828,-2.56494],83.7812],["Land_ChairPlastic_F",[1.53516,5.89844,-2.56494],158.718],["Land_WoodenTable_small_F",[-3.31641,3.84277,-2.56494],-87.8386],["Land_OfficeCabinet_01_F",[-3.44141,6.89551,-2.56494],0.909653],["OfficeTable_01_new_F",[3.79883,3.84375,-2.56494],0.0835114],["Land_CampingChair_b_brown_F",[2.08691,3.57324,-2.56494],-179.825],["Fridge_01_closed_F",[-3.81738,1.63281,-2.56494],96.9639],["Land_BarrelWater_F",[-3.84668,2.35742,-2.56494],64.9382],["Land_WoodenTable_large_F",[1.39258,-0.125977,-2.56494],0.560516],["Land_ChairWood_F",[0.290039,-0.0556641,-2.56494],146.572],["Land_ChairWood_F",[1.24316,-1.74121,-2.56494],-188.069],["Land_ChairWood_F",[2.2627,-0.65918,-2.56494],-98.0686],["Land_WoodenCounter_01_F",[-1.12305,-2.81348,-2.56494],-90.0677],["Land_Metal_rack_F",[1.48145,-6.75977,-2.56494],-179.451],["Land_Metal_rack_Tall_F",[4.22559,-3.98535,-2.56494],-92.7952],["Land_LuggageHeap_01_F",[3.68945,-3.7207,0.855064],-58.1014],["Land_PlasticCase_01_large_F",[1.82031,-6.79102,0.855064],-90.0129],["Land_Suitcase_F",[4.0957,-6.70996,0.855064],19.5407],["Land_Sleeping_bag_F",[2.91797,-5.13184,0.855064],56.2859],["Land_Sleeping_bag_blue_folded_F",[3.84668,-4.60449,0.855064],65.0301],["Land_Ground_sheet_folded_F",[1.4502,-3.76074,0.855064],81.098],["Land_FMradio_F",[2.75195,-6.65527,0.855064],32.7554],["Land_CampingTable_small_F",[-1.75977,-6.37012,0.855064],-0.760391],["Land_CampingChair_b_brown_F",[-1.91211,-5.57031,0.855064],3.5764],["Land_CampingChair_b_brown_F",[-2.87891,-6.31641,0.855064],63.5764],["Land_ShelvesWooden_F",[4.18848,-1.94336,0.855064],-179.129],["Land_Sack_F",[2.32324,0.673828,0.855064],-141.559],["Land_Sack_F",[2.17188,-0.499023,0.855064],-105.913],["Land_Sacks_goods_F",[1.00977,-1.98047,0.855064],-177.147],["Land_CanisterPlastic_F",[-3.76758,2.36816,0.855066],-5.05688],["Land_CanisterPlastic_F",[-3.91016,-1.09863,0.855064],39.9431],["Land_GasTank_01_blue_F",[0.870117,0.0986328,0.855064],-61.4245]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};


			case "Land_i_House_Big_02_b_brown_F":
				{
				_templates = [[["Fridge_01_closed_F",[2.12891,-1.1084,-2.62491],-94.3556],["Land_Basket_F",[1.83203,-1.92969,-2.62556],-106.438],["Land_ShelvesWooden_F",[-3.38086,-1.18848,-2.6199],90.0902],["Land_ShelvesMetal_F",[1.80664,0.173828,-2.6269],-89.9523],["Land_ShelvesWooden_F",[4.19531,0.828125,-2.62674],-4.50794],["Land_TableDesk_F",[4.08984,3.54492,-2.62547],90.2152],["Land_OfficeChair_01_F",[2.99219,3.5459,-2.62547],90.2152],["Land_OfficeChair_01_F",[4.18359,1.91211,-2.62514],-203.348],["Land_WoodenCounter_01_F",[-4.02344,2.15625,-2.6219],90.2379],["Land_ChairWood_F",[-3.32422,4.33008,-2.62135],35.4309],["Land_CanisterPlastic_F",[-3.94336,0.236328,-2.6234],69.1718],["Land_CanisterPlastic_F",[-3.85547,-1.22266,0.787415],0.607124],["Land_CanisterPlastic_F",[-3.81055,-1.83594,0.787415],30.6071],["Land_CanisterPlastic_F",[-3.80469,-2.80664,0.787415],75.6071],["Land_GasTank_01_blue_F",[-3.82422,-3.73633,0.786346],103.539],["Land_PlasticCase_01_large_F",[2.38477,0.078125,0.780411],-97.4489],["Land_BarrelWater_F",[4.38086,0.0273438,0.780487],-85.2888],["Land_Sacks_heap_F",[3.78906,1.19043,0.780487],-85.2888],["Land_Sacks_heap_F",[3.85352,3.10742,0.781708],87.4758],["Land_Sleeping_bag_blue_folded_F",[1.67969,4.63672,0.784164],-231.154],["Land_Sleeping_bag_blue_folded_F",[2.46094,4.43945,0.784164],-201.154],["Land_LuggageHeap_02_F",[-0.681641,4.61914,0.787247],-142.198],["Land_CratesShabby_F",[-3.80078,0.439453,0.784561],-30.6144],["Land_Sack_F",[-3.97266,1.52148,0.784927],-51.4324],["Land_ChairWood_F",[1.04102,0.108398,0.780457],-193.077],["Land_WoodenTable_small_F",[-1.17578,-3.37305,0.782806],87.3334]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
 	
			case "Land_i_Shop_01_b_brown_F":
				{
				_templates =  [[["Land_ShelvesMetal_F",[-1.84546,0.521484,-2.76157],-0.0969238],["Land_ShelvesMetal_F",[1.35376,1.49023,-2.76157],177.141],["Land_CashDesk_F",[-2.81934,4.38867,-2.76157],-1.98949],["Land_OfficeChair_01_F",[-2.66797,5.48828,-2.76158],52.5127],["Fridge_01_closed_F",[3.04639,4.69727,-2.76157],182.912],["Land_ShelvesWooden_F",[-3.10693,6.19922,1.10981],182.241],["Land_WoodenCounter_01_F",[1.44971,0.595703,1.10873],-91.404],["Land_WoodenTable_large_F",[-2.93579,2.07227,1.10927],179.546],["Land_CampingChair_V2_F",[-1.72656,2.06836,1.1089],-120.454],["Land_CampingChair_V2_F",[-2.604,0.347656,1.1095],145.662],["Land_LuggageHeap_02_F",[-2.92627,3.92969,1.10938],103.453]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};		

			case "Land_i_Shop_02_b_brown_F":
				{
				_templates =  [[["Land_Sacks_heap_F",[-1.2666,-3.29004,-2.66902],-58.4311],["Land_Sacks_heap_F",[-0.532227,-0.748779,-2.67464],1.56894],["Land_Sacks_goods_F",[2.1123,-2.18286,-2.67087],24.3402],["Land_Sacks_goods_F",[-3.8877,3.24756,-2.6676],-10.5067],["Land_Sack_F",[-3.05078,-3.62305,-2.68017],-184.254],["Land_WoodenCounter_01_F",[-2.94922,-3.90747,1.23761],-179.59],["Land_CampingChair_V2_F",[-1.03711,0.518066,1.23843],-36.8381],["Land_CampingChair_V2_F",[-0.660156,-2.07642,1.23843],38.1618],["Land_CampingTable_small_F",[-2.09277,-1.02124,1.23843],98.1618]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
				
			case "Land_i_House_Small_01_b_pink_F":
				{
				_templates = [[["Land_CanisterPlastic_F",[2.08398,4.49023,-1.03958],46.0271],["Land_ChairPlastic_F",[3.7832,4.11719,-1.07374],-119.167],["Land_ChairPlastic_F",[-4.08203,-3.82422,-1.02398],35.2988],["Land_TablePlastic_01_F",[-3.9375,-0.464844,-1.0852],88.3407],["Land_ChairPlastic_F",[-2.68652,-0.84375,-1.07325],157.217],["Land_ChairPlastic_F",[-2.85938,0.480469,-1.02343],187.217],["Land_WoodenTable_large_F",[0.878906,-2.44531,-1.02346],1.58008],["Land_RattanChair_01_F",[0.158203,-2.23047,-1.04972],46.5948],["Land_PlasticCase_01_small_F",[0.764648,-2.24219,-0.147858],23.7305],["Land_Sack_F",[-0.423828,4.31641,-1.03956],45.0582],["Land_Sack_F",[-1.82422,4.45703,-1.03967],150.058],["Land_Basket_F",[-1.30469,0.972656,-1.18567],-106.466],["Fridge_01_closed_F",[-1.40723,-3.88477,-1.15955],176.421]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};			
		 
			case "Land_i_House_Small_02_b_pink_F":
				{
				_templates = [[["Land_CampingTable_F",[-4.52881,1.90137,-0.588028],3.24768],["Land_CampingChair_V2_F",[-4.48291,1.12305,-0.590683],168.248],["Land_CampingChair_V2_F",[-3.00928,1.77588,-0.588455],-131.752],["Land_WoodenTable_small_F",[-2.12305,-2.80664,-0.590919],87.1347],["Land_OfficeCabinet_01_F",[-1.4624,-0.292969,-0.590393],-90.5812],["Fridge_01_closed_F",[-5.25928,-0.675781,-0.588394],88.6826],["Land_LuggageHeap_01_F",[-1.61865,-1.7002,-0.587791],-161.539],["Land_ShelvesWooden_F",[0.768555,-3.10889,-0.585327],-92.9928],["Land_Basket_F",[-0.217773,-2.94922,-0.585205],-126.326],["Land_CratesShabby_F",[-0.103516,-1.70996,-0.584274],-153.962],["Land_Sack_F",[-0.279297,-0.504883,-0.584274],170.58],["Land_PlasticCase_01_large_F",[4.97168,2.19385,-0.580101],88.9096],["Land_BarrelWater_F",[2.10889,-3.2334,-0.582039],-131.095],["Land_Metal_rack_Tall_F",[1.45605,2.21289,-0.582809],-1.64015],["Land_ChairWood_F",[4.00488,-3.11963,-0.580872],125.577]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	


			case "Land_i_House_Big_01_b_pink_F":
				{
				_templates =  [[["Land_TablePlastic_01_F",[-0.279297,6.46289,-2.56494],-1.34801],["Land_ChairPlastic_F",[-1.7832,6.5752,-2.56494],-2.40092],["Land_ChairPlastic_F",[-0.296875,5.48828,-2.56494],83.7812],["Land_ChairPlastic_F",[1.53516,5.89844,-2.56494],158.718],["Land_WoodenTable_small_F",[-3.31641,3.84277,-2.56494],-87.8386],["Land_OfficeCabinet_01_F",[-3.44141,6.89551,-2.56494],0.909653],["OfficeTable_01_new_F",[3.79883,3.84375,-2.56494],0.0835114],["Land_CampingChair_b_pink_F",[2.08691,3.57324,-2.56494],-179.825],["Fridge_01_closed_F",[-3.81738,1.63281,-2.56494],96.9639],["Land_BarrelWater_F",[-3.84668,2.35742,-2.56494],64.9382],["Land_WoodenTable_large_F",[1.39258,-0.125977,-2.56494],0.560516],["Land_ChairWood_F",[0.290039,-0.0556641,-2.56494],146.572],["Land_ChairWood_F",[1.24316,-1.74121,-2.56494],-188.069],["Land_ChairWood_F",[2.2627,-0.65918,-2.56494],-98.0686],["Land_WoodenCounter_01_F",[-1.12305,-2.81348,-2.56494],-90.0677],["Land_Metal_rack_F",[1.48145,-6.75977,-2.56494],-179.451],["Land_Metal_rack_Tall_F",[4.22559,-3.98535,-2.56494],-92.7952],["Land_LuggageHeap_01_F",[3.68945,-3.7207,0.855064],-58.1014],["Land_PlasticCase_01_large_F",[1.82031,-6.79102,0.855064],-90.0129],["Land_Suitcase_F",[4.0957,-6.70996,0.855064],19.5407],["Land_Sleeping_bag_F",[2.91797,-5.13184,0.855064],56.2859],["Land_Sleeping_bag_blue_folded_F",[3.84668,-4.60449,0.855064],65.0301],["Land_Ground_sheet_folded_F",[1.4502,-3.76074,0.855064],81.098],["Land_FMradio_F",[2.75195,-6.65527,0.855064],32.7554],["Land_CampingTable_small_F",[-1.75977,-6.37012,0.855064],-0.760391],["Land_CampingChair_b_pink_F",[-1.91211,-5.57031,0.855064],3.5764],["Land_CampingChair_b_pink_F",[-2.87891,-6.31641,0.855064],63.5764],["Land_ShelvesWooden_F",[4.18848,-1.94336,0.855064],-179.129],["Land_Sack_F",[2.32324,0.673828,0.855064],-141.559],["Land_Sack_F",[2.17188,-0.499023,0.855064],-105.913],["Land_Sacks_goods_F",[1.00977,-1.98047,0.855064],-177.147],["Land_CanisterPlastic_F",[-3.76758,2.36816,0.855066],-5.05688],["Land_CanisterPlastic_F",[-3.91016,-1.09863,0.855064],39.9431],["Land_GasTank_01_blue_F",[0.870117,0.0986328,0.855064],-61.4245]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};


			case "Land_i_House_Big_02_b_pink_F":
				{
				_templates = [[["Fridge_01_closed_F",[2.12891,-1.1084,-2.62491],-94.3556],["Land_Basket_F",[1.83203,-1.92969,-2.62556],-106.438],["Land_ShelvesWooden_F",[-3.38086,-1.18848,-2.6199],90.0902],["Land_ShelvesMetal_F",[1.80664,0.173828,-2.6269],-89.9523],["Land_ShelvesWooden_F",[4.19531,0.828125,-2.62674],-4.50794],["Land_TableDesk_F",[4.08984,3.54492,-2.62547],90.2152],["Land_OfficeChair_01_F",[2.99219,3.5459,-2.62547],90.2152],["Land_OfficeChair_01_F",[4.18359,1.91211,-2.62514],-203.348],["Land_WoodenCounter_01_F",[-4.02344,2.15625,-2.6219],90.2379],["Land_ChairWood_F",[-3.32422,4.33008,-2.62135],35.4309],["Land_CanisterPlastic_F",[-3.94336,0.236328,-2.6234],69.1718],["Land_CanisterPlastic_F",[-3.85547,-1.22266,0.787415],0.607124],["Land_CanisterPlastic_F",[-3.81055,-1.83594,0.787415],30.6071],["Land_CanisterPlastic_F",[-3.80469,-2.80664,0.787415],75.6071],["Land_GasTank_01_blue_F",[-3.82422,-3.73633,0.786346],103.539],["Land_PlasticCase_01_large_F",[2.38477,0.078125,0.780411],-97.4489],["Land_BarrelWater_F",[4.38086,0.0273438,0.780487],-85.2888],["Land_Sacks_heap_F",[3.78906,1.19043,0.780487],-85.2888],["Land_Sacks_heap_F",[3.85352,3.10742,0.781708],87.4758],["Land_Sleeping_bag_blue_folded_F",[1.67969,4.63672,0.784164],-231.154],["Land_Sleeping_bag_blue_folded_F",[2.46094,4.43945,0.784164],-201.154],["Land_LuggageHeap_02_F",[-0.681641,4.61914,0.787247],-142.198],["Land_CratesShabby_F",[-3.80078,0.439453,0.784561],-30.6144],["Land_Sack_F",[-3.97266,1.52148,0.784927],-51.4324],["Land_ChairWood_F",[1.04102,0.108398,0.780457],-193.077],["Land_WoodenTable_small_F",[-1.17578,-3.37305,0.782806],87.3334]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
 	
			case "Land_i_Shop_01_b_pink_F":
				{
				_templates =  [[["Land_ShelvesMetal_F",[-1.84546,0.521484,-2.76157],-0.0969238],["Land_ShelvesMetal_F",[1.35376,1.49023,-2.76157],177.141],["Land_CashDesk_F",[-2.81934,4.38867,-2.76157],-1.98949],["Land_OfficeChair_01_F",[-2.66797,5.48828,-2.76158],52.5127],["Fridge_01_closed_F",[3.04639,4.69727,-2.76157],182.912],["Land_ShelvesWooden_F",[-3.10693,6.19922,1.10981],182.241],["Land_WoodenCounter_01_F",[1.44971,0.595703,1.10873],-91.404],["Land_WoodenTable_large_F",[-2.93579,2.07227,1.10927],179.546],["Land_CampingChair_V2_F",[-1.72656,2.06836,1.1089],-120.454],["Land_CampingChair_V2_F",[-2.604,0.347656,1.1095],145.662],["Land_LuggageHeap_02_F",[-2.92627,3.92969,1.10938],103.453]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};		

			case "Land_i_Shop_02_b_pink_F":
				{
				_templates =  [[["Land_Sacks_heap_F",[-1.2666,-3.29004,-2.66902],-58.4311],["Land_Sacks_heap_F",[-0.532227,-0.748779,-2.67464],1.56894],["Land_Sacks_goods_F",[2.1123,-2.18286,-2.67087],24.3402],["Land_Sacks_goods_F",[-3.8877,3.24756,-2.6676],-10.5067],["Land_Sack_F",[-3.05078,-3.62305,-2.68017],-184.254],["Land_WoodenCounter_01_F",[-2.94922,-3.90747,1.23761],-179.59],["Land_CampingChair_V2_F",[-1.03711,0.518066,1.23843],-36.8381],["Land_CampingChair_V2_F",[-0.660156,-2.07642,1.23843],38.1618],["Land_CampingTable_small_F",[-2.09277,-1.02124,1.23843],98.1618]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
				
			case "Land_i_House_Small_01_b_yellow_F":
				{
				_templates = [[["Land_CanisterPlastic_F",[2.08398,4.49023,-1.03958],46.0271],["Land_ChairPlastic_F",[3.7832,4.11719,-1.07374],-119.167],["Land_ChairPlastic_F",[-4.08203,-3.82422,-1.02398],35.2988],["Land_TablePlastic_01_F",[-3.9375,-0.464844,-1.0852],88.3407],["Land_ChairPlastic_F",[-2.68652,-0.84375,-1.07325],157.217],["Land_ChairPlastic_F",[-2.85938,0.480469,-1.02343],187.217],["Land_WoodenTable_large_F",[0.878906,-2.44531,-1.02346],1.58008],["Land_RattanChair_01_F",[0.158203,-2.23047,-1.04972],46.5948],["Land_PlasticCase_01_small_F",[0.764648,-2.24219,-0.147858],23.7305],["Land_Sack_F",[-0.423828,4.31641,-1.03956],45.0582],["Land_Sack_F",[-1.82422,4.45703,-1.03967],150.058],["Land_Basket_F",[-1.30469,0.972656,-1.18567],-106.466],["Fridge_01_closed_F",[-1.40723,-3.88477,-1.15955],176.421]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};			
		 
			case "Land_i_House_Small_02_b_yellow_F":
				{
				_templates = [[["Land_CampingTable_F",[-4.52881,1.90137,-0.588028],3.24768],["Land_CampingChair_V2_F",[-4.48291,1.12305,-0.590683],168.248],["Land_CampingChair_V2_F",[-3.00928,1.77588,-0.588455],-131.752],["Land_WoodenTable_small_F",[-2.12305,-2.80664,-0.590919],87.1347],["Land_OfficeCabinet_01_F",[-1.4624,-0.292969,-0.590393],-90.5812],["Fridge_01_closed_F",[-5.25928,-0.675781,-0.588394],88.6826],["Land_LuggageHeap_01_F",[-1.61865,-1.7002,-0.587791],-161.539],["Land_ShelvesWooden_F",[0.768555,-3.10889,-0.585327],-92.9928],["Land_Basket_F",[-0.217773,-2.94922,-0.585205],-126.326],["Land_CratesShabby_F",[-0.103516,-1.70996,-0.584274],-153.962],["Land_Sack_F",[-0.279297,-0.504883,-0.584274],170.58],["Land_PlasticCase_01_large_F",[4.97168,2.19385,-0.580101],88.9096],["Land_BarrelWater_F",[2.10889,-3.2334,-0.582039],-131.095],["Land_Metal_rack_Tall_F",[1.45605,2.21289,-0.582809],-1.64015],["Land_ChairWood_F",[4.00488,-3.11963,-0.580872],125.577]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	


			case "Land_i_House_Big_01_b_yellow_F":
				{
				_templates =  [[["Land_TablePlastic_01_F",[-0.279297,6.46289,-2.56494],-1.34801],["Land_ChairPlastic_F",[-1.7832,6.5752,-2.56494],-2.40092],["Land_ChairPlastic_F",[-0.296875,5.48828,-2.56494],83.7812],["Land_ChairPlastic_F",[1.53516,5.89844,-2.56494],158.718],["Land_WoodenTable_small_F",[-3.31641,3.84277,-2.56494],-87.8386],["Land_OfficeCabinet_01_F",[-3.44141,6.89551,-2.56494],0.909653],["OfficeTable_01_new_F",[3.79883,3.84375,-2.56494],0.0835114],["Land_CampingChair_b_yellow_F",[2.08691,3.57324,-2.56494],-179.825],["Fridge_01_closed_F",[-3.81738,1.63281,-2.56494],96.9639],["Land_BarrelWater_F",[-3.84668,2.35742,-2.56494],64.9382],["Land_WoodenTable_large_F",[1.39258,-0.125977,-2.56494],0.560516],["Land_ChairWood_F",[0.290039,-0.0556641,-2.56494],146.572],["Land_ChairWood_F",[1.24316,-1.74121,-2.56494],-188.069],["Land_ChairWood_F",[2.2627,-0.65918,-2.56494],-98.0686],["Land_WoodenCounter_01_F",[-1.12305,-2.81348,-2.56494],-90.0677],["Land_Metal_rack_F",[1.48145,-6.75977,-2.56494],-179.451],["Land_Metal_rack_Tall_F",[4.22559,-3.98535,-2.56494],-92.7952],["Land_LuggageHeap_01_F",[3.68945,-3.7207,0.855064],-58.1014],["Land_PlasticCase_01_large_F",[1.82031,-6.79102,0.855064],-90.0129],["Land_Suitcase_F",[4.0957,-6.70996,0.855064],19.5407],["Land_Sleeping_bag_F",[2.91797,-5.13184,0.855064],56.2859],["Land_Sleeping_bag_blue_folded_F",[3.84668,-4.60449,0.855064],65.0301],["Land_Ground_sheet_folded_F",[1.4502,-3.76074,0.855064],81.098],["Land_FMradio_F",[2.75195,-6.65527,0.855064],32.7554],["Land_CampingTable_small_F",[-1.75977,-6.37012,0.855064],-0.760391],["Land_CampingChair_b_yellow_F",[-1.91211,-5.57031,0.855064],3.5764],["Land_CampingChair_b_yellow_F",[-2.87891,-6.31641,0.855064],63.5764],["Land_ShelvesWooden_F",[4.18848,-1.94336,0.855064],-179.129],["Land_Sack_F",[2.32324,0.673828,0.855064],-141.559],["Land_Sack_F",[2.17188,-0.499023,0.855064],-105.913],["Land_Sacks_goods_F",[1.00977,-1.98047,0.855064],-177.147],["Land_CanisterPlastic_F",[-3.76758,2.36816,0.855066],-5.05688],["Land_CanisterPlastic_F",[-3.91016,-1.09863,0.855064],39.9431],["Land_GasTank_01_blue_F",[0.870117,0.0986328,0.855064],-61.4245]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};


			case "Land_i_House_Big_02_b_yellow_F":
				{
				_templates = [[["Fridge_01_closed_F",[2.12891,-1.1084,-2.62491],-94.3556],["Land_Basket_F",[1.83203,-1.92969,-2.62556],-106.438],["Land_ShelvesWooden_F",[-3.38086,-1.18848,-2.6199],90.0902],["Land_ShelvesMetal_F",[1.80664,0.173828,-2.6269],-89.9523],["Land_ShelvesWooden_F",[4.19531,0.828125,-2.62674],-4.50794],["Land_TableDesk_F",[4.08984,3.54492,-2.62547],90.2152],["Land_OfficeChair_01_F",[2.99219,3.5459,-2.62547],90.2152],["Land_OfficeChair_01_F",[4.18359,1.91211,-2.62514],-203.348],["Land_WoodenCounter_01_F",[-4.02344,2.15625,-2.6219],90.2379],["Land_ChairWood_F",[-3.32422,4.33008,-2.62135],35.4309],["Land_CanisterPlastic_F",[-3.94336,0.236328,-2.6234],69.1718],["Land_CanisterPlastic_F",[-3.85547,-1.22266,0.787415],0.607124],["Land_CanisterPlastic_F",[-3.81055,-1.83594,0.787415],30.6071],["Land_CanisterPlastic_F",[-3.80469,-2.80664,0.787415],75.6071],["Land_GasTank_01_blue_F",[-3.82422,-3.73633,0.786346],103.539],["Land_PlasticCase_01_large_F",[2.38477,0.078125,0.780411],-97.4489],["Land_BarrelWater_F",[4.38086,0.0273438,0.780487],-85.2888],["Land_Sacks_heap_F",[3.78906,1.19043,0.780487],-85.2888],["Land_Sacks_heap_F",[3.85352,3.10742,0.781708],87.4758],["Land_Sleeping_bag_blue_folded_F",[1.67969,4.63672,0.784164],-231.154],["Land_Sleeping_bag_blue_folded_F",[2.46094,4.43945,0.784164],-201.154],["Land_LuggageHeap_02_F",[-0.681641,4.61914,0.787247],-142.198],["Land_CratesShabby_F",[-3.80078,0.439453,0.784561],-30.6144],["Land_Sack_F",[-3.97266,1.52148,0.784927],-51.4324],["Land_ChairWood_F",[1.04102,0.108398,0.780457],-193.077],["Land_WoodenTable_small_F",[-1.17578,-3.37305,0.782806],87.3334]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
 	
			case "Land_i_Shop_01_b_yellow_F":
				{
				_templates =  [[["Land_ShelvesMetal_F",[-1.84546,0.521484,-2.76157],-0.0969238],["Land_ShelvesMetal_F",[1.35376,1.49023,-2.76157],177.141],["Land_CashDesk_F",[-2.81934,4.38867,-2.76157],-1.98949],["Land_OfficeChair_01_F",[-2.66797,5.48828,-2.76158],52.5127],["Fridge_01_closed_F",[3.04639,4.69727,-2.76157],182.912],["Land_ShelvesWooden_F",[-3.10693,6.19922,1.10981],182.241],["Land_WoodenCounter_01_F",[1.44971,0.595703,1.10873],-91.404],["Land_WoodenTable_large_F",[-2.93579,2.07227,1.10927],179.546],["Land_CampingChair_V2_F",[-1.72656,2.06836,1.1089],-120.454],["Land_CampingChair_V2_F",[-2.604,0.347656,1.1095],145.662],["Land_LuggageHeap_02_F",[-2.92627,3.92969,1.10938],103.453]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};		

			case "Land_i_Shop_02_b_yellow_F":
				{
				_templates =  [[["Land_Sacks_heap_F",[-1.2666,-3.29004,-2.66902],-58.4311],["Land_Sacks_heap_F",[-0.532227,-0.748779,-2.67464],1.56894],["Land_Sacks_goods_F",[2.1123,-2.18286,-2.67087],24.3402],["Land_Sacks_goods_F",[-3.8877,3.24756,-2.6676],-10.5067],["Land_Sack_F",[-3.05078,-3.62305,-2.68017],-184.254],["Land_WoodenCounter_01_F",[-2.94922,-3.90747,1.23761],-179.59],["Land_CampingChair_V2_F",[-1.03711,0.518066,1.23843],-36.8381],["Land_CampingChair_V2_F",[-0.660156,-2.07642,1.23843],38.1618],["Land_CampingTable_small_F",[-2.09277,-1.02124,1.23843],98.1618]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

							case "Land_i_House_Small_01_b_whiteblue_F":
				{
				_templates = [[["Land_CanisterPlastic_F",[2.08398,4.49023,-1.03958],46.0271],["Land_ChairPlastic_F",[3.7832,4.11719,-1.07374],-119.167],["Land_ChairPlastic_F",[-4.08203,-3.82422,-1.02398],35.2988],["Land_TablePlastic_01_F",[-3.9375,-0.464844,-1.0852],88.3407],["Land_ChairPlastic_F",[-2.68652,-0.84375,-1.07325],157.217],["Land_ChairPlastic_F",[-2.85938,0.480469,-1.02343],187.217],["Land_WoodenTable_large_F",[0.878906,-2.44531,-1.02346],1.58008],["Land_RattanChair_01_F",[0.158203,-2.23047,-1.04972],46.5948],["Land_PlasticCase_01_small_F",[0.764648,-2.24219,-0.147858],23.7305],["Land_Sack_F",[-0.423828,4.31641,-1.03956],45.0582],["Land_Sack_F",[-1.82422,4.45703,-1.03967],150.058],["Land_Basket_F",[-1.30469,0.972656,-1.18567],-106.466],["Fridge_01_closed_F",[-1.40723,-3.88477,-1.15955],176.421]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};			
		 
			case "Land_i_House_Small_02_b_whiteblue_F":
				{
				_templates = [[["Land_CampingTable_F",[-4.52881,1.90137,-0.588028],3.24768],["Land_CampingChair_V2_F",[-4.48291,1.12305,-0.590683],168.248],["Land_CampingChair_V2_F",[-3.00928,1.77588,-0.588455],-131.752],["Land_WoodenTable_small_F",[-2.12305,-2.80664,-0.590919],87.1347],["Land_OfficeCabinet_01_F",[-1.4624,-0.292969,-0.590393],-90.5812],["Fridge_01_closed_F",[-5.25928,-0.675781,-0.588394],88.6826],["Land_LuggageHeap_01_F",[-1.61865,-1.7002,-0.587791],-161.539],["Land_ShelvesWooden_F",[0.768555,-3.10889,-0.585327],-92.9928],["Land_Basket_F",[-0.217773,-2.94922,-0.585205],-126.326],["Land_CratesShabby_F",[-0.103516,-1.70996,-0.584274],-153.962],["Land_Sack_F",[-0.279297,-0.504883,-0.584274],170.58],["Land_PlasticCase_01_large_F",[4.97168,2.19385,-0.580101],88.9096],["Land_BarrelWater_F",[2.10889,-3.2334,-0.582039],-131.095],["Land_Metal_rack_Tall_F",[1.45605,2.21289,-0.582809],-1.64015],["Land_ChairWood_F",[4.00488,-3.11963,-0.580872],125.577]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	


			case "Land_i_House_Big_01_b_whiteblue_F":
				{
				_templates =  [[["Land_TablePlastic_01_F",[-0.279297,6.46289,-2.56494],-1.34801],["Land_ChairPlastic_F",[-1.7832,6.5752,-2.56494],-2.40092],["Land_ChairPlastic_F",[-0.296875,5.48828,-2.56494],83.7812],["Land_ChairPlastic_F",[1.53516,5.89844,-2.56494],158.718],["Land_WoodenTable_small_F",[-3.31641,3.84277,-2.56494],-87.8386],["Land_OfficeCabinet_01_F",[-3.44141,6.89551,-2.56494],0.909653],["OfficeTable_01_new_F",[3.79883,3.84375,-2.56494],0.0835114],["Land_CampingChair_b_whiteblue_F",[2.08691,3.57324,-2.56494],-179.825],["Fridge_01_closed_F",[-3.81738,1.63281,-2.56494],96.9639],["Land_BarrelWater_F",[-3.84668,2.35742,-2.56494],64.9382],["Land_WoodenTable_large_F",[1.39258,-0.125977,-2.56494],0.560516],["Land_ChairWood_F",[0.290039,-0.0556641,-2.56494],146.572],["Land_ChairWood_F",[1.24316,-1.74121,-2.56494],-188.069],["Land_ChairWood_F",[2.2627,-0.65918,-2.56494],-98.0686],["Land_WoodenCounter_01_F",[-1.12305,-2.81348,-2.56494],-90.0677],["Land_Metal_rack_F",[1.48145,-6.75977,-2.56494],-179.451],["Land_Metal_rack_Tall_F",[4.22559,-3.98535,-2.56494],-92.7952],["Land_LuggageHeap_01_F",[3.68945,-3.7207,0.855064],-58.1014],["Land_PlasticCase_01_large_F",[1.82031,-6.79102,0.855064],-90.0129],["Land_Suitcase_F",[4.0957,-6.70996,0.855064],19.5407],["Land_Sleeping_bag_F",[2.91797,-5.13184,0.855064],56.2859],["Land_Sleeping_bag_blue_folded_F",[3.84668,-4.60449,0.855064],65.0301],["Land_Ground_sheet_folded_F",[1.4502,-3.76074,0.855064],81.098],["Land_FMradio_F",[2.75195,-6.65527,0.855064],32.7554],["Land_CampingTable_small_F",[-1.75977,-6.37012,0.855064],-0.760391],["Land_CampingChair_b_whiteblue_F",[-1.91211,-5.57031,0.855064],3.5764],["Land_CampingChair_b_whiteblue_F",[-2.87891,-6.31641,0.855064],63.5764],["Land_ShelvesWooden_F",[4.18848,-1.94336,0.855064],-179.129],["Land_Sack_F",[2.32324,0.673828,0.855064],-141.559],["Land_Sack_F",[2.17188,-0.499023,0.855064],-105.913],["Land_Sacks_goods_F",[1.00977,-1.98047,0.855064],-177.147],["Land_CanisterPlastic_F",[-3.76758,2.36816,0.855066],-5.05688],["Land_CanisterPlastic_F",[-3.91016,-1.09863,0.855064],39.9431],["Land_GasTank_01_blue_F",[0.870117,0.0986328,0.855064],-61.4245]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};


			case "Land_i_House_Big_02_b_whiteblue_F":
				{
				_templates = [[["Fridge_01_closed_F",[2.12891,-1.1084,-2.62491],-94.3556],["Land_Basket_F",[1.83203,-1.92969,-2.62556],-106.438],["Land_ShelvesWooden_F",[-3.38086,-1.18848,-2.6199],90.0902],["Land_ShelvesMetal_F",[1.80664,0.173828,-2.6269],-89.9523],["Land_ShelvesWooden_F",[4.19531,0.828125,-2.62674],-4.50794],["Land_TableDesk_F",[4.08984,3.54492,-2.62547],90.2152],["Land_OfficeChair_01_F",[2.99219,3.5459,-2.62547],90.2152],["Land_OfficeChair_01_F",[4.18359,1.91211,-2.62514],-203.348],["Land_WoodenCounter_01_F",[-4.02344,2.15625,-2.6219],90.2379],["Land_ChairWood_F",[-3.32422,4.33008,-2.62135],35.4309],["Land_CanisterPlastic_F",[-3.94336,0.236328,-2.6234],69.1718],["Land_CanisterPlastic_F",[-3.85547,-1.22266,0.787415],0.607124],["Land_CanisterPlastic_F",[-3.81055,-1.83594,0.787415],30.6071],["Land_CanisterPlastic_F",[-3.80469,-2.80664,0.787415],75.6071],["Land_GasTank_01_blue_F",[-3.82422,-3.73633,0.786346],103.539],["Land_PlasticCase_01_large_F",[2.38477,0.078125,0.780411],-97.4489],["Land_BarrelWater_F",[4.38086,0.0273438,0.780487],-85.2888],["Land_Sacks_heap_F",[3.78906,1.19043,0.780487],-85.2888],["Land_Sacks_heap_F",[3.85352,3.10742,0.781708],87.4758],["Land_Sleeping_bag_blue_folded_F",[1.67969,4.63672,0.784164],-231.154],["Land_Sleeping_bag_blue_folded_F",[2.46094,4.43945,0.784164],-201.154],["Land_LuggageHeap_02_F",[-0.681641,4.61914,0.787247],-142.198],["Land_CratesShabby_F",[-3.80078,0.439453,0.784561],-30.6144],["Land_Sack_F",[-3.97266,1.52148,0.784927],-51.4324],["Land_ChairWood_F",[1.04102,0.108398,0.780457],-193.077],["Land_WoodenTable_small_F",[-1.17578,-3.37305,0.782806],87.3334]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
 	
			case "Land_i_Shop_01_b_whiteblue_F":
				{
				_templates =  [[["Land_ShelvesMetal_F",[-1.84546,0.521484,-2.76157],-0.0969238],["Land_ShelvesMetal_F",[1.35376,1.49023,-2.76157],177.141],["Land_CashDesk_F",[-2.81934,4.38867,-2.76157],-1.98949],["Land_OfficeChair_01_F",[-2.66797,5.48828,-2.76158],52.5127],["Fridge_01_closed_F",[3.04639,4.69727,-2.76157],182.912],["Land_ShelvesWooden_F",[-3.10693,6.19922,1.10981],182.241],["Land_WoodenCounter_01_F",[1.44971,0.595703,1.10873],-91.404],["Land_WoodenTable_large_F",[-2.93579,2.07227,1.10927],179.546],["Land_CampingChair_V2_F",[-1.72656,2.06836,1.1089],-120.454],["Land_CampingChair_V2_F",[-2.604,0.347656,1.1095],145.662],["Land_LuggageHeap_02_F",[-2.92627,3.92969,1.10938],103.453]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};		

			case "Land_i_Shop_02_b_whiteblue_F":
				{
				_templates =  [[["Land_Sacks_heap_F",[-1.2666,-3.29004,-2.66902],-58.4311],["Land_Sacks_heap_F",[-0.532227,-0.748779,-2.67464],1.56894],["Land_Sacks_goods_F",[2.1123,-2.18286,-2.67087],24.3402],["Land_Sacks_goods_F",[-3.8877,3.24756,-2.6676],-10.5067],["Land_Sack_F",[-3.05078,-3.62305,-2.68017],-184.254],["Land_WoodenCounter_01_F",[-2.94922,-3.90747,1.23761],-179.59],["Land_CampingChair_V2_F",[-1.03711,0.518066,1.23843],-36.8381],["Land_CampingChair_V2_F",[-0.660156,-2.07642,1.23843],38.1618],["Land_CampingTable_small_F",[-2.09277,-1.02124,1.23843],98.1618]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

				
											
				
			/*	
			case "":
				{
				_templates = [];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
				
			*/		
			
			default
				{
					_bld setvariable ["tpw_furnished",-1]; // non furnishable houses will subsequently be ignored
					diag_log format ["BUILDING %1 HAS NOT FURNITURE TEMPLATE",_type]; 
					
				};
						
			};
		};
		
	// Furnish house  if list is assigned and no people inside
	if (_bld getvariable "tpw_furnished" == 1 ) then //&& {count (_bld nearEntities ["Man", 7]) == 0}) then
		{
		_items = _bld getvariable ["tpw_furniture",[]];
		_bld setvariable ["tpw_furnished",2];
		_dir = getdir _bld;
		_spawned = [];
			{
			_item = _x select 0;
			_offset = _x select 1;
			_angle = _x select 2;
			_dir = getdir _bld;
			_pos = _bld modeltoworld _offset;
			_item = _item createVehicle [0,0,0]; //createvehiclelocal [0,0,0];
			_item setposatl _pos;
			_item setdir (_dir - _angle);
			_spawned pushback _item;
			_item enableSimulationGlobal false;
			_item enablesimulation false;
			_item allowDamage false;
			_item enableDynamicSimulation true;
			} count _items;
		_bld setvariable ["tpw_spawned",_spawned]; // array of spawned furniture for this house, for subsequent removal
		[stw_furniture_houses,_bld] call stwfList_add; 
		};
	};

// MAIN LOOP
private ["_blds","_item","_bld","_the_player","_other_player","_min_distance","_house_distance"];
while {true} do
{
	//FOR EACH PLAYER
	{
		_the_player=  _x;
		// Scan for houses to furnish
		//&& {_the_player == vehicle _the_player}) then 
		// && {_the_player  distance tpw_furniture_lastpos > (tpw_furniture_radius / 2) }) then
		//tpw_furniture_lastpos = position _the_player;
		_speed=speed _the_player;
		_height=[_the_player] call stwf_getUnitZ;
		if ((_speed<25)&&(_height<40)) then
		{
		_blds = _the_player nearObjects ["House",tpw_furniture_radius];
			{
				_alreadyFurnished=_x getvariable "stw_furnished";
				if (isNil("_alreadyFurnished")) then
				{
					//diag_log "Placing furniture";
					_x setVariable ["stw_furnished",1];
					0 = [_x] spawn tpw_furniture_fnc_populate;
					sleep 0.1;
				};
			} count _blds;
		};
	} forEach allPlayers;
	
	// Delete furniture from distant houses 
	_nHouses=[stw_furniture_houses] call stwfList_size;
	_houses= [stw_furniture_houses] call stwfList_getArray;
	_housesToDelete = [] call stwfList_construct;
	
	for "_i" from 0 to _nHouses - 1 do
	 {
		_bld = _houses select _i;
			
		_min_distance=[getPos _bld] call stwf_getMinimumDistanceToPlayers;
							
		if (_min_distance > tpw_furniture_radius) then
		{
			{
				deletevehicle _x;
			} count (_bld getvariable "tpw_spawned");
					
			_bld setVariable ["stw_furnished",nil];
			_bld setvariable ["tpw_furnished",1];
			_bld setvariable ["tpw_spawned",[]];	
			[_housesToDelete,_bld] call stwfList_add; 	
		};
	 };
			
	 _housesToDeleteArray=[_housesToDelete] call stwfList_getArray;	//tpw_furniture_houses = tpw_furniture_houses - [-1];
	 {
		[stw_furniture_houses,_x] call stwfList_removeAll;
	 } forEach _housesToDeleteArray;
						
	 sleep tpw_furniture_scantime;
}; //END OF WHILE TRUE