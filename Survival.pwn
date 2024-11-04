// Index dos attached object: 0 = Mochilas, 1 = Colete, 2 = Capacete, 3 = Particula do Sangue, 4 = Mascara, 5 -- 9 = armas
// # Includes

#include <a_samp>
#include <streamer>
#include <foreach>
#include <sscanf2>
#include <zcmd>
#include <YSI\y_hooks>
//include <nex-ac>
// # Defines #

#undef MAX_PLAYERS
#define MAX_PLAYERS (100)

#define MODENAME "gamemodetext DayZ"
#define HOSTNAME "hostname Apocalypse Rising #1"
#define LANGUAGE "language PT/EN"
#define RCON     "rcon_password hBrRPQMG6Aq"
#define WEBURL   "weburl SOON XD"

#define FORUM    ""

#define MALE_SKIN (299)
#define FEMALE_SKIN (63)

#define IDIOMA_PORTUGUES           (1)
#define IDIOMA_INGLES              (2)

// # Cores #

#define COR_CINZA          0xBABABAFF
#define COR_VERMELHO       0xDE6847FF
#define COR_AMARELO        0xEDC72DFF
#define COR_ROSA           0xC756A5FF
#define COR_BAN            0xFF0000FF //vermelho comum
#define COR_ROXO           0xAB8FC5FF

// # Dialogs #

#define D_Senha            (0)
#define D_Sexo             (1)
#define D_Inventario       (2)
#define D_UsarDropar       (3)
#define D_PegarItem        (4)
#define D_CorpoItems       (5)
#define D_Idioma           (6)
#define D_Radio            (7)
#define D_Skills           (8)
#define D_Config           (9)
// # Market Dialogs
#define D_Market           (10)
// 
#define D_NullMSG          (99)

// # Enumeradores e Variaveis #

static
	armedbody_pTick[MAX_PLAYERS];


new DB:STA_DATA;

enum Player_Data
{
	ID,
	pSenha[65],
	pInputSenha[24],
	bool:pConectado,
	bool:pExistente,
	pTentativas,
	pIdioma,
    pAdmin,
    pAviso,
    bool:pMute,
    bool:pBlockPM,
    bool:pInterface,
    bool:pSpectando,
    pGenero,
    
    Float:pHealth,
    pSkin,
    Float:pX, Float:pY, Float:pZ,

    pChat,
    pBackpack,
    pSlots,
    
    pHeadshots,
    pKills,
    pBanditKills,
	pFome,
	pSede,
	pInfection,
	bool:inInfection,

	pArma[12], pMunicao[12],
	
	pPlayTime,
	pLevel,
	pMoney,

	pRespawn,
	pSangrando,
	pQuebrado,
	pTemGPS,
	pTemColete,
	pTemCapacete,
	pTemMascara,

	pVipLevel,
	pVipTime,

	pColor,
};

new pInfo[MAX_PLAYERS][Player_Data];

enum Vehicle_Data
{
	vCombustivel,
	bool:vTemMotor,
	bool:vMotor,
	vPneus,
};

new vInfo[MAX_VEHICLES][Vehicle_Data];

new horas, minutos;
new engine, lights, alarm, doors, bonnet, boot, objective;
new gps;

new bool:GlobalChat = true;

enum RandomMSG
{
	Portugues[128],
	Ingles[128],
};

// # Arrays #

new RandomMessages[][RandomMSG] =
{
	{"# {F28A3F}Heheboy chora pro Reymon.",}
};

new GunName[47][20] = 
{
	"Fist","Brass Knuckles","Golf Club","Nightstick","Combat Knife","Baseball Bat","Shovel","Pool Cue","Sword","Chainsaw","Double-ended Dildo","Dildo","Vibrator",
	"Silver Vibrator","Flowers","Cane","Frag Grenade","Tear Gas","Molotov","?","?","?","Colt 45","Silenced Pistol","Desert Eagle","Remington","Sawed-off Shotgun",
	"SPAS-12","Micro-SMG","MP5","AK-47","M4A1","Tec-9","Winchester","Sniper Rifle","RPG-7","HS-RPG","Flame-Thrower","Minigun","Satchel Charge","Detonator",
	"Spray Can","Fire Extinguisher","Binoculars","Night Goggles","Thermal Goggles","Parachute"
};

/* by Scorpion */
new Vehicle_Tires[212][2] =
{
	{400,1},//Landstalker
	{401,1},//Bravura
	{402,1},//Buffalo
	{403,0},//Linerunner
	{404,1},//Perenail
	{405,1},//Sentinel
	{406,1},//Dumper
	{407,1},//Firetruck
	{408,1},//Trashmaster
	{409,4},//Stretch
	{410,4},//Manana
	{411,4},//Infernus
	{412,4},//Voodoo
	{413,4},//Pony
	{414,4},//Mule
	{415,4},//Cheetah
	{416,4},//Ambulance
	{417,0},//Leviathan
	{418,4},//Moonbeam
	{419,4},//Esperanto
	{420,4},//Taxi
	{421,4},//Washington
	{422,4},//Bobcat
	{423,4},//Mr Whoopee
	{424,4},//BF Injection
	{425,0},//Hunter
	{426,4},//Premier
	{427,4},//Enforcer
	{428,4},//Securicar
	{429,4},//Banshee
	{430,0},//Predator
	{431,6},//Bus
	{432,12},//Rhino
	{433,6},//Barracks
	{434,4},//Hotknife
	{435,0},//Artic Trailer 1
	{436,4},//Previon
	{437,6},//Coach
	{438,4},//Cabbie
	{439,4},//Stallion
	{440,4},//Rumpo
	{441,0},//RC Bandit
	{442,4},//Romero
	{443,6},//Packer
	{444,4},//Monster
	{445,4},//Admiral
	{446,0},//Squalo
	{447,0},//Seasparrow
	{448,2},//Pizza Boy
	{449,0},//Tram
	{450,0},//Artic Trailer 2
	{451,4},//Turismo
	{452,0},//Speeder
	{453,0},//Reefer
	{454,0},//Tropic
	{455,6},//Flatbed
	{456,4},//Yankee
	{457,4},//Caddy
	{458,4},//Solair
	{459,4},//Top Fun
	{460,0},//Skimmer
	{461,2},//PCJ-600
	{462,2},//Faggio
	{463,2},//Freeway
	{464,0},//RC Baron
	{465,0},//RC Raider
	{466,4},//Glendale
	{467,4},//Oceanic
	{468,2},//Sanchez
	{469,0},//Sparrow
	{470,4},//Patriot
	{471,4},//Quad
	{472,0},//Coastguard
	{473,0},//Dinghy
	{474,4},//Hermes
	{475,4},//Sabre
	{476,0},//Rustler
	{477,4},//ZR-350
	{478,4},//Walton
	{479,4},//Regina
	{480,1},//Comet
	{481,0},//BMX
	{482,4},//Burrito
	{483,4},//Camper
	{484,0},//Marquis
	{485,4},//Baggage
	{486,4},//Dozer
	{487,0},//Maverick
	{488,0},//SAN Maverick
	{489,4},//Rancher
	{490,4},//FBI Rancher
	{491,4},//Virgo
	{492,4},//Greenwood
	{493,0},//Jetmax
	{494,4},//Hotring
	{495,4},//Sandking
	{496,4},//Blista Compact
	{497,0},//Police Maverick
	{498,4},//Boxvillie
	{499,4},//Benson
	{500,4},//Mesa
	{501,0},//RC Goblin
	{502,4},//Hotring A
	{503,4},//Hotring B
	{504,4},//Bloodring Banger
	{505,4},//Rancher (lure)
	{506,4},//Super GT
	{507,4},//Elegant
	{508,4},//Journey
	{509,0},//Bike
	{510,0},//Mountain bike
	{511,0},//Beagle
	{512,0},//Cropduster
	{513,0},//Stuntplane
	{514,6},//Petrol
	{515,6},//Roadtrain
	{516,4},//Nebula
	{517,4},//Majestic
	{518,4},//Buccaneer
	{519,0},//Shamal
	{520,0},//Hydra
	{521,2},//FCR-900
	{522,2},//NRG-500
	{523,2},//HPV-1000
	{524,6},//Cement Truck
	{525,4},//Tow Truck
	{526,4},//Fortune
	{527,4},//Cadrona
	{528,4},//FBI Truck
	{529,4},//Williard
	{530,4},//Forklift
	{531,4},//Tractor
	{532,4},//Combine
	{533,4},//Feltzer
	{534,4},//Remington
	{535,4},//Slamvan
	{536,4},//Blade
	{537,0},//Freight
	{538,0},//Streak
	{539,0},//Vortex
	{540,4},//Vincent
	{541,4},//Bullet
	{542,4},//Clover
	{543,4},//Sadler
	{544,4},//Firetruck LS
	{545,4},//Hustler
	{546,4},//Intruder
	{547,4},//Primo
	{548,0},//Cargobob
	{549,4},//Tampa
	{550,4},//Sunrise
	{551,4},//Merit
	{552,4},//Utility Van
	{553,0},//Nevada
	{554,4},//Yosemite
	{555,4},//Windsor
	{556,4},//Monster A
	{557,4},//Monster B
	{558,4},//Uranus
	{559,4},//Jester
	{560,4},//Sultan
	{561,4},//Stratum
	{562,4},//Elegy
	{563,0},//Raindance
	{564,0},//RC Tiger
	{565,4},//Flash
	{566,4},//Tahoma
	{567,4},//Savanna
	{568,4},//Bandito
	{569,0},//Freight Flat
	{570,0},//Streak
	{571,0},//Kart
	{572,4},//Mower
	{573,4},//Duneride
	{574,4},//Sweeper
	{575,4},//Broadway
	{576,4},//Tornado
	{577,0},//AT-400
	{578,4},//DFT-30
	{579,1},//Huntley
	{580,4},//Stafford
	{581,2},//BF-400
	{582,4},//News van
	{583,4},//Tug
	{584,0},//Petrol Tanker
	{585,4},//Emperor
	{586,2},//Wayfarer
	{587,4},//Euros
	{588,4},//Hotdog
	{589,4},//Club
	{590,0},//Freight Box
	{591,0},//Artic Trailer
	{592,0},//Andromada
	{593,0},//Dodo
	{594,0},//RC Cam
	{595,0},//Launch
	{596,4},//Cop Car LS
	{597,4},//Cop Car SF
	{598,4},//Cop Car LV
	{599,4},//Ranger
	{600,4},//Picador
	{601,4},//Swat Tank
	{602,4},//Alpha
	{603,4},//Phoenix
	{604,0},//Glendale (damaged)
	{605,0},//Sadler (damaged)
	{606,0},//Bag Box A
	{607,0},//Bag Box B
	{608,0},//Stairs
	{609,9},//Boxville (black)
	{610,0},//Farm Trailer
	{611,0}//Utility Trailer
};

new Float:Respawns[][] =
{

    {1907.1178, 1003.2074, 9.8195}

};

new Float:WaterPumps[][] =
{
	{-71.0858300,-1574.0048820,2.9290050},
    {-1648.2658690,-2225.1152340,31.0465620},
    {-2293.9353020,-2449.4165030,25.8521900},
    {-2844.4064940,151.1351620,14.1765480},
    {-2282.8835440,-224.8368370,42.0017770},
    {-935.5426020,-505.2821040,26.1720820},
    {-499.6838370,-195.9230490,78.6065750},
    {918.0520010,-347.3332210,51.3789970},
    {2586.5637200,1504.8028560,10.9931750},
    {2369.2873530,-1042.1469720,54.3486670},
    {2448.3786620,-1714.9991450,13.8221300},
    {1146.3027340,-2020.3424070,69.1742930},
    {1800.6409910,172.9230950,31.5583780},
    {1379.4053950,352.4748220,19.7465260},
    {256.8574210,1138.6696770,11.1060220}
};

new Float:GasStations[][] = 
{
	{615.5672,1689.7476,6.9922},
    {2146.6218,2747.4570,10.8203},
    {2640.7183,1106.8115,10.8203},
    {2115.5269,920.8984,10.8203},
    {-1328.0162,2677.8120,50.0625},
    {1382.0696,462.7734,20.1372},
    {1939.2244,-1773.6395,13.3828}, 
    {1004.3527,-934.0197,42.1797},
    {654.7863,-565.1791,16.3359},
    {-92.2858,-1168.8105,2.4530},
    {-1675.4385,413.3332,7.1797},
    {-2413.3279,976.6518,45.2969},
    {-2244.2778,-2561.7581,31.9219},
    {-1606.5472,-2713.8796,48.5335},
    {-1471.3381,1863.5159,32.6328}
};

new InfectedAreas[6];
new gZ_Infected[6];
new Float:InfectionZones[][] =
{
	{26.672454, 1734.880493, 386.672454, 2110.880371}, // Area-51
	{2535.515380, -2573.710449, 2815.515380, -2325.710449}, // Docas
	{585.928955, -669.003662, 849.928955, -389.003662}, // Dillimore
	{1155.1213,-4465.0840, 1492.9769,-4688.4814},//Island Town 1
	{1080.1702,-4245.9019, 654.3192,-4845.5171} //Island Town 2
};

// # Forwards #

forward AtualizarPlayer();
forward AtualizarFome();
forward AtualizarSede();
forward AtualizarGasolina();
forward AtualizarSangramento();
forward DelayedKick(playerid);
forward Unfreeze(playerid);
forward AtualizarHM();
forward MensagemRandomica();
forward IniciarDepois();

// # Macros #

// Keys
#define PRESSED(%0) (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define RELEASED(%0) (((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))
#define HOLDING(%0) ((newkeys & (%0)) == (%0))

// # Modulos #

//include "modulos/antcheater.inc"
#include "modulos/admin.inc"
#include "modulos/textdraws.inc"
#include "modulos/items.inc"
#include "modulos/inventario.inc"
#include "modulos/loot.inc"
#include "modulos/market.inc"
#include "modulos/mapas-veiculos.inc"
#include "modulos/corpos.inc"
#include "modulos/login-cadastro.inc"
#include "modulos/comandos.inc"
#include "modulos/nametags.inc"
//#include "modulos/tenda.inc"
#include "modulos/armas_dropadas.inc"
#include "modulos/antigbug.inc"
//include "modulos/RemoverMapa.inc"
//include "modulos/colete.inc"

enum MarketSpawnData
{
	mSkin,
	Float:mPosX,
	Float:mPosY,
	Float:mPosZ,
	Float:mAngle,
	mProdutos,
};

new MarketSpawns[][MarketSpawnData] =
{
	{303,1616.3143,1822.2401,15.8125,79.7079, MEDICAL}, // medic_npc
	{303,-1434.8766,1496.8126,1.8672,220.0177, SPECIAL}, // misc_npc
	{303,1406.2230,-1300.3016,13.5436,266.9152, WEAPON}, // weapon_npc
	{303,251.4559,-54.2945,1.5776,202.8446, FOOD} // food_npc
};


main()
{
	print("\n----------------------------------");
	print(" Gamemode - Iniciado!");
	print("----------------------------------\n");
}


public OnGameModeInit()
{
	if((STA_DATA = db_open("sta_database.db")) == DB:0)
	{
		print("| ERRO |: N�o foi poss�vel conectar o Database.");
		SendRconCommand("exit");
	}
	else 
	{
		print("| INFO |: Database conectado com sucesso!"); 

		new DBResult:check;

		check = db_query(STA_DATA, "SELECT name FROM sqlite_master WHERE type='table' AND name='Usuarios'");

		if(!db_num_rows(check))
		{

			print("| DATABASE |: N�o foi possivel encontrar a tabela Usuarios.");

			new DBResult:result;

			result = db_query(STA_DATA, "CREATE TABLE IF NOT EXISTS `Usuarios` (\
				`ID`	INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,\
				`Nome`	TEXT,\
				`Senha`	TEXT,\
				`Admin`	INTEGER,\
				`VipLevel` INTEGER,\
				`VipTime` INTEGER,\
				`Dinheiro`	INTEGER,\
				`Avisos`	INTEGER,\
				`Saude`	INTEGER,\
				`Skin`	INTEGER,\
				`PX`	INTEGER,\
				`PY`	INTEGER,\
				`PZ`	INTEGER,\
				`Chat`	INTEGER,\
				`Backpack`	INTEGER,\
				`Slots`	INTEGER,\
				`Headshots`	INTEGER,\
				`Vitimas`	INTEGER,\
				`BanditKills`	INTEGER,\
				`Fome`	INTEGER,\
				`Sede`	INTEGER,\
				`Infeccao`	INTEGER,\
				`PlayTime`	INTEGER,\
				`Level`	INTEGER,\
				`Respawn`	INTEGER,\
				`Sangrando`	INTEGER,\
				`PernaQuebrada`	INTEGER,\
				`GPS`	INTEGER,\
				`Colete`	INTEGER,\
				`Capacete`	INTEGER,\
				`Mascara`	INTEGER,\
				`Genero`	INTEGER,\
				`Arma1`		INTEGER,\
				`Municao1`	INTEGER,\
				`Arma2`		INTEGER,\
				`Municao2`	INTEGER,\
				`Arma3`		INTEGER,\
				`Municao3`	INTEGER,\
				`Arma4`		INTEGER,\
				`Municao4`	INTEGER,\
				`Arma5`		INTEGER,\
				`Municao5`	INTEGER,\
				`Arma6`		INTEGER,\
				`Municao6`	INTEGER,\
				`Arma7`		INTEGER,\
				`Municao7`	INTEGER,\
				`Arma8`		INTEGER,\
				`Municao8`	INTEGER,\
				`Arma9`		INTEGER,\
				`Municao9`	INTEGER,\
				`Arma10`	INTEGER,\
				`Municao10`	INTEGER,\
				`Arma11`	INTEGER,\
				`Municao11`	INTEGER,\
				`Arma12`	INTEGER,\
				`Municao12`	INTEGER,\
				`InvSlot`	TEXT,\
				`Color`		INTEGER\
			)");

			print("| DATABASE |: Tabela Usuarios criado com sucesso!");

			db_free_result(result);
		}
		db_free_result(check);


		check = db_query(STA_DATA, "SELECT name FROM sqlite_master WHERE type='table' AND name='Banidos'");

		if(!db_num_rows(check))
		{

			print("| DATABASE |: N�o foi possivel encontrar a tabela Banidos.");

			new DBResult:result;

			result = db_query(STA_DATA, "CREATE TABLE IF NOT EXISTS `Banidos` (\
				`Nome`	TEXT,\
				`Admin`	TEXT,\
				`Motivo`	TEXT,\
				`Dia`	INTEGER,\
				`Mes`	INTEGER,\
				`Ano`	INTEGER,\
				`IP`	TEXT\
			)");

			print("| DATABASE |: Tabela Banidos criado com sucesso!");

			db_free_result(result);
		}
		db_free_result(check);		
    }
    
    SendRconCommand(MODENAME), SendRconCommand(HOSTNAME), SendRconCommand(LANGUAGE), SendRconCommand(RCON), SendRconCommand(WEBURL);
	DisableInteriorEnterExits(), EnableStuntBonusForAll(false), UsePlayerPedAnims(), ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF);
	ShowNameTags(0), ManualVehicleEngineAndLights();

	SpawnLoots();
	CarregarVeiculos();
	CarregarObjetos();
	CriarActors();
    CarregarTextDraws();

    SetWeather(4);

    SetTimer("AntCheatRunTime", 100, true);
    SetTimer("AtualizarPlayer", 200, true);
    SetTimer("AtualizarHM", 60000, true);
    SetTimer("AtualizarFome", 180000, true);
	SetTimer("AtualizarSede", 120000, true);
	SetTimer("AtualizarSangramento", 10000, true);
	SetTimer("AtualizarGasolina", 60000, true);
	SetTimer("DeleteWorldBodies", 1500000, true);
	SetTimer("OnPlaneCrash", 1860000, true);
	SetTimer("MensagemRandomica", 600000, true);
	SetTimer("RespawnItems1", 3600000, true);
	SetTimer("RespawnItems2", 3600500, true);
	SetTimer("UpdateNametag", 500, true);
	SetTimer("IniciarDepois", 2000, false);
	SetTimer("Setarlimite", 1, true);

	gps = GangZoneCreate(-3334.758544, -3039.903808, 3049.241455, 3184.096191); // Gangzone do tamanho do mapa pra esconder o mapa do jogador
	return 1;
}

public IniciarDepois()
{
	new i;
//	print("1");

	// Text 3D's

//	print("2");
	for(i = 0; i < sizeof(WaterPumps); i++)	
	{
		CreateDynamic3DTextLabel("{FFFFFF}[{DEBB21}Water Pump{FFFFFF}]\nUse [{DEBB21}Empty Water Bottle{FFFFFF}] {FFFFFF}to refil.", -1, WaterPumps[i][0], WaterPumps[i][1], WaterPumps[i][2], 1.5);
	}
//	print("3");
	for(i = 0; i < sizeof(GasStations); i++)	
	{
//		print("aaa");
		CreateDynamic3DTextLabel("{FFFFFF}[{DEBB21}Gas Station{FFFFFF}]\nUse [{DEBB21}Empty Jerry Can{FFFFFF}] {FFFFFF}to refil.", -1, GasStations[i][0], GasStations[i][1], GasStations[i][2], 10.0);
	}

	for(i = 0; i < sizeof(MarketSpawns); i++)	
	{
//		print("ppp");
		CreateActor(MarketSpawns[i][mSkin], MarketSpawns[i][mPosX], MarketSpawns[i][mPosY], MarketSpawns[i][mPosZ], MarketSpawns[i][mAngle]);
		
		switch(MarketSpawns[i][mProdutos])
		{
			case MEDICAL: 
			{
				CreateDynamic3DTextLabel("{BF2855}[Medical Store]\n{FFFFFF}Press 'F' to Buy.", -1, MarketSpawns[i][mPosX], MarketSpawns[i][mPosY], MarketSpawns[i][mPosZ], 1.5);
			}
			case FOOD: 
			{
				CreateDynamic3DTextLabel("{D6B11D}[Food Store]\n{FFFFFF}Press 'F' to Buy.", -1, MarketSpawns[i][mPosX], MarketSpawns[i][mPosY], MarketSpawns[i][mPosZ], 1.5);
			}
			case WEAPON: 
			{
				CreateDynamic3DTextLabel("{5B594E}[Weponry Store]\n{FFFFFF}Press 'F' to Buy.", -1, MarketSpawns[i][mPosX], MarketSpawns[i][mPosY], MarketSpawns[i][mPosZ], 1.5);
			}
			case SPECIAL: 
			{
				CreateDynamic3DTextLabel("{2255B5}[Gear Store]\n{FFFFFF}Press 'F' to Buy.", -1, MarketSpawns[i][mPosX], MarketSpawns[i][mPosY], MarketSpawns[i][mPosZ], 1.5);
			}			
		}
	}


	for(i = 0; i < sizeof(InfectedAreas); i++)	
	{
//		print("bbb");
		InfectedAreas[i] = CreateDynamicRectangle(InfectionZones[i][0], InfectionZones[i][1], InfectionZones[i][2], InfectionZones[i][3]);
//		print("ccc");
		gZ_Infected[i] = GangZoneCreate(InfectionZones[i][0], InfectionZones[i][1], InfectionZones[i][2], InfectionZones[i][3]);
//		print("ddd");
	}

	return 1;
}

public OnGameModeExit()
{
	foreach(new i : Player)
	{
		if(pInfo[i][pConectado] == true && !IsPlayerNPC(i))
		{
			SalvarPlayer(i);
		}
	}		
	db_close(STA_DATA);
	return 1;
}

public OnPlayerConnect(playerid)
{
	RemoveBuildingForPlayer(playerid, 8240, 1586.2578, 1189.5938, 23.4453, 0.25);
	RemoveBuildingForPlayer(playerid, 8241, 1586.2578, 1189.5938, 23.4453, 0.25);
	RemoveBuildingForPlayer(playerid, 8378, 1586.2578, 1222.7031, 19.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 8379, 1586.2578, 1222.7031, 19.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 8501, 2160.2734, 1465.1094, 22.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 2144.5625, 1247.3750, 22.0703, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 2125.5000, 1244.5000, 22.0703, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 2155.7422, 1221.5234, 25.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 2137.5156, 1220.0625, 25.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 2116.7188, 1220.5859, 25.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 2170.4141, 1229.2031, 25.3594, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 2166.4844, 1338.0234, 25.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 2151.4297, 1346.0938, 24.5313, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 2136.8359, 1346.0938, 24.5313, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 2120.7109, 1346.0938, 24.5313, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 2170.9063, 1246.3516, 25.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 2019.8516, 1500.3750, 24.8281, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 1956.0625, 1468.7109, 24.8281, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 1877.6484, 1468.7109, 24.8281, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 1848.5547, 1504.0938, 24.8281, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 1848.5547, 1570.8203, 24.8281, 0.25);
	RemoveBuildingForPlayer(playerid, 8694, 2113.1328, 1465.1094, 22.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 8825, 2057.3906, 1602.5781, 10.5313, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 1845.2266, 1146.7734, 25.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 8930, 2217.7500, 1477.6641, 31.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 8931, 2162.4766, 1403.4375, 14.6563, 0.25);
	RemoveBuildingForPlayer(playerid, 9070, 2111.3203, 1501.1172, 22.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 9071, 2158.4219, 1501.1172, 22.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 9072, 2113.1328, 1465.1094, 22.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 9073, 2158.4219, 1501.1172, 22.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 9074, 2111.3203, 1501.1172, 22.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 9075, 2160.2734, 1465.1094, 22.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 2013.3281, 1047.4844, 25.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 2005.9219, 1059.8672, 25.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 2005.9219, 1048.2266, 25.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 2005.9219, 1036.5859, 25.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 2025.9141, 993.0391, 25.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 2025.9141, 1022.9844, 25.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 2025.9141, 1033.2500, 25.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 2025.9141, 1048.7891, 25.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 2025.9141, 1064.4922, 25.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 1881.8359, 1077.3828, 25.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 1881.8359, 1051.0313, 25.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 1881.8359, 1024.6875, 25.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 1881.8359, 998.3359, 25.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 1881.8359, 971.9922, 25.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 1881.8359, 948.5234, 25.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 2022.6797, 1213.3281, 12.4609, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 1839.4922, 1218.9922, 19.4297, 0.25);
	RemoveBuildingForPlayer(playerid, 737, 2030.0078, 1223.3750, 10.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1840.6797, 1239.3984, 9.8906, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 2022.6797, 1234.0781, 12.4609, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 1843.9531, 1259.6406, 19.4297, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 2022.6797, 1255.0234, 12.4609, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, 2017.2656, 1268.8828, 14.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 1350, 2032.2578, 1267.7031, 9.7422, 0.25);
	RemoveBuildingForPlayer(playerid, 718, 1928.4297, 1305.3672, 8.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 1967.1172, 1305.3984, 8.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 1982.5547, 1305.3984, 8.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 1997.8906, 1305.3984, 8.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 3437, 2023.1016, 1307.2969, 11.5313, 0.25);
	RemoveBuildingForPlayer(playerid, 3437, 2023.8516, 1302.6641, 10.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 3437, 2025.4766, 1298.5547, 9.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2010.4063, 1305.3984, 8.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 3513, 2037.4297, 1302.7422, 13.9922, 0.25);
	RemoveBuildingForPlayer(playerid, 3516, 2040.1719, 1283.0938, 12.9766, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 1983.7266, 1322.7031, 9.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 3511, 1973.4531, 1322.6953, 9.7188, 0.25);
	RemoveBuildingForPlayer(playerid, 8982, 1985.8594, 1356.5781, 8.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 3511, 1993.9688, 1322.6250, 9.7188, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2003.3672, 1322.7031, 9.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 3437, 2022.2813, 1325.1406, 14.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 3437, 2022.3281, 1320.7031, 14.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 3437, 2022.3828, 1316.2578, 13.1875, 0.25);
	RemoveBuildingForPlayer(playerid, 3437, 2022.2813, 1361.0391, 14.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 3437, 2022.5547, 1329.5625, 15.6484, 0.25);
	RemoveBuildingForPlayer(playerid, 3437, 2022.6172, 1311.8594, 12.3516, 0.25);
	RemoveBuildingForPlayer(playerid, 3437, 2022.5547, 1356.6094, 15.6484, 0.25);
	RemoveBuildingForPlayer(playerid, 718, 1890.1563, 1392.4766, 8.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 1850.5000, 1477.7734, 19.1875, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1856.0000, 1472.7422, 9.5078, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, 1857.5469, 1457.4844, 14.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 621, 1891.6250, 1469.6484, 9.2891, 0.25);
	RemoveBuildingForPlayer(playerid, 621, 1864.2266, 1469.6484, 9.2891, 0.25);
	RemoveBuildingForPlayer(playerid, 718, 1909.1406, 1392.4766, 8.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, 1907.9531, 1448.9219, 14.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1924.4453, 1472.7422, 9.5078, 0.25);
	RemoveBuildingForPlayer(playerid, 718, 1928.4297, 1392.4766, 8.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 621, 1930.8906, 1469.6484, 9.2891, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, 1957.5234, 1457.4844, 14.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 1960.6563, 1377.4375, 9.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 1968.3828, 1381.0781, 8.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 1973.2031, 1363.6875, 9.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 3511, 1983.6172, 1363.7813, 9.7188, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 1974.0859, 1377.4375, 9.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 1990.3750, 1377.4375, 9.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 1982.6484, 1381.1953, 8.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 718, 1977.7422, 1420.6016, 8.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 1350, 1977.2813, 1447.6719, 9.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 621, 1982.3906, 1469.6484, 9.2891, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 1993.7734, 1363.6875, 9.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 1998.2500, 1381.1953, 8.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 1998.2500, 1402.5547, 8.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 1998.2500, 1422.0938, 8.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 1997.8984, 1475.4453, 19.1875, 0.25);
	RemoveBuildingForPlayer(playerid, 621, 1992.2813, 1469.6484, 9.2891, 0.25);
	RemoveBuildingForPlayer(playerid, 1350, 1992.9297, 1443.1250, 9.7422, 0.25);
	RemoveBuildingForPlayer(playerid, 1350, 1997.5078, 1458.7734, 9.7969, 0.25);
	RemoveBuildingForPlayer(playerid, 3511, 2003.4141, 1363.7813, 9.7188, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 2004.8203, 1377.4375, 9.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 2004.8203, 1401.9609, 9.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 2004.8203, 1424.3906, 9.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 2013.4453, 1401.9609, 9.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 2013.4453, 1424.3906, 9.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2011.2969, 1381.1953, 8.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 621, 2010.6797, 1469.6484, 9.2891, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2019.2969, 1472.7422, 9.5078, 0.25);
	RemoveBuildingForPlayer(playerid, 3437, 2022.3828, 1369.9219, 13.1875, 0.25);
	RemoveBuildingForPlayer(playerid, 3437, 2022.3281, 1365.4766, 14.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 3437, 2022.6172, 1374.3203, 12.3516, 0.25);
	RemoveBuildingForPlayer(playerid, 3437, 2023.1016, 1378.8828, 11.5313, 0.25);
	RemoveBuildingForPlayer(playerid, 3437, 2023.8516, 1383.5156, 10.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 3437, 2025.4766, 1387.6250, 9.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 3498, 2024.5859, 1483.2344, 6.3281, 0.25);
	RemoveBuildingForPlayer(playerid, 3498, 2028.5391, 1483.2344, 6.3281, 0.25);
	RemoveBuildingForPlayer(playerid, 3498, 2028.3203, 1467.2188, 7.1953, 0.25);
	RemoveBuildingForPlayer(playerid, 3498, 2032.2734, 1463.4375, 7.1953, 0.25);
	RemoveBuildingForPlayer(playerid, 1350, 2032.2734, 1447.6875, 9.7422, 0.25);
	RemoveBuildingForPlayer(playerid, 3513, 2037.4297, 1484.0234, 13.9922, 0.25);
	RemoveBuildingForPlayer(playerid, 3516, 2040.1719, 1463.0938, 12.9766, 0.25);
	RemoveBuildingForPlayer(playerid, 645, 1847.0703, 1489.4297, 9.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1847.5781, 1521.3203, 9.5078, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 1848.9688, 1535.9688, 19.1875, 0.25);
	RemoveBuildingForPlayer(playerid, 645, 1848.3750, 1553.6328, 9.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 621, 1864.2266, 1587.9609, 9.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 1877.7188, 1570.1484, 19.1875, 0.25);
	RemoveBuildingForPlayer(playerid, 621, 1871.3438, 1588.3906, 9.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 621, 1891.7266, 1569.4219, 9.2891, 0.25);
	RemoveBuildingForPlayer(playerid, 3498, 1886.7031, 1587.3125, 7.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 3498, 1886.6953, 1572.2500, 7.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1898.8359, 1557.9922, 9.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 3498, 1900.7813, 1572.2500, 7.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 3498, 1899.7656, 1587.3125, 7.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1917.8516, 1557.9922, 9.7422, 0.25);
	RemoveBuildingForPlayer(playerid, 621, 1930.8906, 1556.3672, 9.2891, 0.25);
	RemoveBuildingForPlayer(playerid, 8837, 1959.5547, 1573.1094, 11.1016, 0.25);
	RemoveBuildingForPlayer(playerid, 1350, 1871.6953, 1722.9063, 9.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 1350, 1887.7188, 1718.8047, 9.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, 1917.2266, 1708.8516, 14.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, 1957.4453, 1717.5781, 14.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 645, 2011.8828, 1489.4297, 9.7188, 0.25);
	RemoveBuildingForPlayer(playerid, 3498, 2022.1328, 1503.2344, 6.3281, 0.25);
	RemoveBuildingForPlayer(playerid, 3498, 2026.0156, 1503.2344, 6.3281, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 2017.2188, 1523.5625, 19.1875, 0.25);
	RemoveBuildingForPlayer(playerid, 621, 2019.7734, 1512.2656, 9.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 3498, 2026.2578, 1523.2734, 6.3281, 0.25);
	RemoveBuildingForPlayer(playerid, 3498, 2021.8594, 1523.2734, 6.3281, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, 2017.2500, 1708.8516, 14.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 8836, 2027.8828, 1552.1641, 11.2578, 0.25);
	RemoveBuildingForPlayer(playerid, 3498, 2029.7891, 1550.5625, 7.6016, 0.25);
	RemoveBuildingForPlayer(playerid, 3498, 2027.8672, 1540.1094, 7.6016, 0.25);
	RemoveBuildingForPlayer(playerid, 1350, 2032.2734, 1707.6797, 9.7422, 0.25);
	RemoveBuildingForPlayer(playerid, 3516, 2050.1719, 1723.0859, 12.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.2891, 1225.1563, 9.8281, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2124.2656, 1218.9297, 9.7266, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2162.4766, 1222.7656, 9.7266, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2145.3203, 1218.9297, 9.7266, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.2500, 1261.4141, 9.8281, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.2578, 1239.9297, 9.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 3463, 2057.4531, 1252.8594, 10.1641, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 2057.5703, 1232.8828, 11.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2168.7969, 1263.0781, 9.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2168.7969, 1236.4219, 9.6484, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.2500, 1323.2813, 9.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.4063, 1305.0938, 9.7813, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.3672, 1288.8984, 9.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 2057.5703, 1298.3672, 11.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 2057.5703, 1318.1406, 11.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2168.7969, 1324.1484, 9.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 2207.4766, 1323.2109, 12.4609, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 2207.4766, 1306.2813, 12.4609, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.2422, 1422.3125, 9.8281, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.2500, 1441.2891, 9.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.2656, 1342.6641, 9.8359, 0.25);
	RemoveBuildingForPlayer(playerid, 8826, 2057.3906, 1422.8281, 10.5313, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.3203, 1385.1328, 9.8203, 0.25);
	RemoveBuildingForPlayer(playerid, 3463, 2057.4531, 1443.3516, 10.1641, 0.25);
	RemoveBuildingForPlayer(playerid, 3463, 2057.4531, 1354.4766, 10.1641, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.5234, 1403.3828, 9.8047, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.5234, 1331.7969, 9.9063, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 2057.5703, 1409.5859, 11.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 3513, 2077.0781, 1342.3672, 13.9922, 0.25);
	RemoveBuildingForPlayer(playerid, 3516, 2074.6016, 1423.3672, 12.9922, 0.25);
	RemoveBuildingForPlayer(playerid, 3516, 2074.5938, 1363.3672, 12.9922, 0.25);
	RemoveBuildingForPlayer(playerid, 1350, 2082.5234, 1378.7734, 9.7969, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, 2087.6172, 1368.8516, 14.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 718, 2088.8906, 1439.5938, 9.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 718, 2088.8906, 1426.4844, 9.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 2099.8125, 1447.9766, 12.4609, 0.25);
	RemoveBuildingForPlayer(playerid, 718, 2098.3828, 1384.3203, 9.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 2100.9922, 1452.1563, 10.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 718, 2116.3594, 1384.3281, 9.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 2110.8906, 1447.9766, 12.4609, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 2121.7266, 1447.9766, 12.4609, 0.25);
	RemoveBuildingForPlayer(playerid, 718, 2121.8359, 1443.2344, 9.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 2117.3281, 1452.1563, 10.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2128.2188, 1345.9141, 9.7813, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, 2133.5859, 1377.4766, 14.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 1341, 2125.1328, 1442.0781, 10.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 718, 2147.6641, 1443.2344, 9.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 718, 2147.1563, 1424.7422, 9.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 1340, 2144.6406, 1441.9297, 10.8516, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 2157.0703, 1452.1563, 10.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2160.2266, 1342.1719, 9.7422, 0.25);
	RemoveBuildingForPlayer(playerid, 8839, 2162.4766, 1403.4375, 14.6563, 0.25);
	RemoveBuildingForPlayer(playerid, 8840, 2162.7891, 1401.4141, 14.3750, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, 2165.1719, 1368.8516, 14.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 718, 2171.8672, 1424.6406, 9.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 2169.5781, 1452.1563, 10.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 2207.4766, 1343.1406, 12.4609, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 2207.4766, 1362.4844, 12.4609, 0.25);
	RemoveBuildingForPlayer(playerid, 1350, 2177.2813, 1367.6719, 9.8047, 0.25);
	RemoveBuildingForPlayer(playerid, 1350, 2197.4922, 1378.7734, 9.8047, 0.25);
	RemoveBuildingForPlayer(playerid, 1350, 2192.9609, 1363.1094, 9.8047, 0.25);
	RemoveBuildingForPlayer(playerid, 1344, 2178.2188, 1418.8438, 10.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 718, 2181.9219, 1443.2344, 9.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 1344, 2181.5625, 1418.8438, 10.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 2181.9922, 1458.7109, 10.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 1350, 2232.9531, 1363.1094, 9.7969, 0.25);
	RemoveBuildingForPlayer(playerid, 1350, 2217.2813, 1367.6797, 9.7422, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, 2217.4063, 1377.4766, 14.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 718, 2236.3594, 1402.1250, 9.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 1350, 2241.8203, 1383.3516, 9.8047, 0.25);
	RemoveBuildingForPlayer(playerid, 3459, 2259.5234, 1382.3750, 17.3125, 0.25);
	RemoveBuildingForPlayer(playerid, 1350, 2257.5000, 1378.8125, 9.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.2891, 1663.2813, 9.7969, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.2500, 1637.0547, 9.8281, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.2422, 1579.9063, 9.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.2891, 1682.9766, 9.7969, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.3359, 1598.1172, 9.8203, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.3594, 1560.7188, 9.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.3594, 1502.7656, 9.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 3463, 2057.4531, 1543.5313, 10.2422, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.5234, 1521.4375, 9.8516, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.3984, 1483.1094, 9.8516, 0.25);
	RemoveBuildingForPlayer(playerid, 3463, 2057.4531, 1652.7578, 10.2578, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.5156, 1618.5859, 9.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 3516, 2074.6016, 1523.3672, 12.9922, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2068.7344, 1726.5313, 9.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 3463, 2074.6016, 1737.6953, 10.2344, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2073.2266, 1734.1875, 9.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 2087.6094, 1463.2500, 12.5234, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 2087.6094, 1503.2344, 12.5234, 0.25);
	RemoveBuildingForPlayer(playerid, 3513, 2077.5234, 1503.6172, 13.9922, 0.25);
	RemoveBuildingForPlayer(playerid, 718, 2088.4766, 1522.0781, 9.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 1350, 2082.5156, 1538.8125, 9.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2089.3203, 1623.4922, 9.7266, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2089.3203, 1603.0625, 9.7266, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2089.3203, 1583.4844, 9.7266, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2089.3203, 1566.1875, 9.7266, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2082.3516, 1752.7188, 9.8594, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 2080.2266, 1748.1875, 11.2422, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2077.2656, 1743.0078, 9.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2086.3750, 1761.0625, 9.8516, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2093.4844, 1638.0703, 9.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2093.7734, 1652.1328, 9.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 8502, 2134.1484, 1483.1172, 21.4844, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 2101.5703, 1514.0781, 10.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 2117.0547, 1514.0781, 10.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 2110.8906, 1518.1328, 12.4609, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 2099.8125, 1518.1328, 12.4609, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 2121.7266, 1518.1328, 12.4609, 0.25);
	RemoveBuildingForPlayer(playerid, 718, 2119.5000, 1522.0781, 9.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, 2117.4297, 1537.5391, 14.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2105.3047, 1638.0703, 9.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2109.0469, 1547.2734, 9.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2116.1016, 1639.3672, 9.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2105.0000, 1652.0313, 9.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2114.2891, 1725.3516, 9.7188, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2114.2891, 1710.8672, 9.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2114.2500, 1653.3906, 9.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2126.4922, 1657.0938, 9.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2126.5625, 1706.2266, 9.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 2182.0547, 1463.2500, 12.5234, 0.25);
	RemoveBuildingForPlayer(playerid, 8852, 2162.1406, 1483.2500, 10.7813, 0.25);
	RemoveBuildingForPlayer(playerid, 8842, 2217.7500, 1477.6641, 31.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 2153.8516, 1518.1328, 12.4609, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 2161.9219, 1518.1328, 12.4609, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 2157.5078, 1514.0781, 10.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 2169.6797, 1518.1328, 12.4609, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 2168.5391, 1514.0781, 10.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 2182.0547, 1503.2344, 12.5234, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 2181.9922, 1500.4375, 10.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2141.3594, 1547.2734, 9.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, 2147.9141, 1528.8906, 14.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 718, 2148.9219, 1522.0781, 9.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 718, 2180.0781, 1521.4375, 9.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 1341, 2175.0859, 1523.4141, 10.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2177.5000, 1547.2734, 9.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, 2187.1484, 1537.5391, 14.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2207.2109, 1547.2734, 9.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2135.6094, 1700.9766, 9.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2135.8984, 1662.5781, 9.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2143.8594, 1691.5547, 9.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2143.8594, 1671.1484, 9.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 3513, 2037.7969, 868.7656, 10.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.5156, 865.3516, 6.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 1894.4609, 947.5234, 9.9453, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 1913.7656, 947.5234, 9.9453, 0.25);
	RemoveBuildingForPlayer(playerid, 9154, 1960.2578, 1004.9219, 18.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1840.6797, 1200.5469, 9.8906, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1840.6797, 1175.5469, 9.8906, 0.25);
	RemoveBuildingForPlayer(playerid, 8846, 1859.9063, 1185.1250, 10.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 621, 1857.3594, 1145.9922, 9.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, 1871.7500, 1063.3594, 14.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 1350, 1877.5156, 1098.7891, 9.7422, 0.25);
	RemoveBuildingForPlayer(playerid, 1350, 1872.9453, 1083.1250, 9.7422, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 1879.8438, 1146.5625, 19.4297, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1881.7969, 1127.1250, 9.8984, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.5156, 873.2891, 6.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.3984, 897.2109, 6.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.2266, 911.2578, 7.5078, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 1995.7734, 944.6953, 19.4297, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 2000.8594, 976.4531, 11.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 1998.9141, 973.1563, 19.4297, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 2003.1172, 979.3359, 11.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 3463, 2057.4531, 950.7969, 9.4844, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.2891, 936.1953, 8.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.5313, 960.8594, 9.5547, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 2007.6406, 982.0000, 19.4297, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 1999.6953, 981.6406, 19.4297, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 2005.8359, 980.9766, 11.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 1999.3281, 981.4453, 11.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 1996.0625, 1039.1094, 19.4297, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 2014.0313, 1039.5938, 19.4297, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 2026.0156, 984.6563, 19.4297, 0.25);
	RemoveBuildingForPlayer(playerid, 8828, 2057.3906, 988.3750, 8.7422, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.2969, 1045.4219, 9.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.4141, 1008.4531, 9.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 3463, 2057.4531, 1033.9063, 10.1641, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.4688, 1021.4531, 9.8594, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 2014.0313, 1055.8984, 19.4297, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 1996.0625, 1055.4141, 19.4297, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, 2017.6797, 1089.0000, 14.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 2022.6797, 1153.2813, 12.4609, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 2022.6797, 1173.7188, 12.4609, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 2022.6797, 1192.8281, 12.4609, 0.25);
	RemoveBuildingForPlayer(playerid, 737, 2030.0078, 1106.1172, 10.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 737, 2030.0078, 1163.4922, 10.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1350, 2032.2969, 1087.6875, 9.7969, 0.25);
	RemoveBuildingForPlayer(playerid, 3516, 2040.1875, 1103.6641, 12.9609, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.2422, 1122.8438, 9.8281, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.2500, 1103.1641, 9.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.2656, 1083.1797, 9.7969, 0.25);
	RemoveBuildingForPlayer(playerid, 8827, 2057.3906, 1192.5859, 10.5313, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.3594, 1205.0156, 9.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.3984, 1180.9063, 9.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.3672, 1161.0391, 9.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.4063, 1060.5391, 9.8516, 0.25);
	RemoveBuildingForPlayer(playerid, 3463, 2057.4531, 1153.3906, 10.1641, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2057.4688, 1143.4766, 9.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2087.5234, 983.3984, 9.5078, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2088.0234, 1002.6875, 9.5078, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2088.1797, 1021.5391, 9.5078, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2102.7109, 1032.2109, 9.7266, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2107.0078, 983.2578, 9.5078, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2126.0156, 983.2578, 9.5078, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2144.2969, 983.2578, 9.5078, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2088.9453, 1055.4688, 9.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2111.4922, 1072.8281, 9.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2117.2578, 1042.6094, 9.7266, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2121.9922, 1097.4375, 9.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2131.6953, 1053.8203, 9.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2147.1016, 1066.5938, 9.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2158.3828, 1080.3750, 9.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2166.7031, 1096.6250, 9.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2172.8125, 1181.3750, 9.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 3509, 2202.6563, 1181.6953, 9.6953, 0.25);

    if(!IsPlayerNPC(playerid))
    {

        new string[40 + MAX_PLAYER_NAME];
        format(string, sizeof(string), "[JOIN]: %s(%i) has joined the server.", PegarNome(playerid), playerid);
        SendAdminMessage(string, COR_CINZA);

        SetPlayerColor(playerid, 0x919191FF);
        CarregarPlayerText(playerid);
        RemoveAllAttachedObjects(playerid);

        new query[100], DBResult:result;

        new plyerip[16];
        GetPlayerIp(playerid, plyerip, sizeof(plyerip));

        format(query, sizeof(query), "SELECT * FROM Banidos WHERE Nome='%s' OR IP='%s'", PegarNome(playerid), plyerip);
        result = db_query(STA_DATA, query);

        if(db_num_rows(result))
        {
            new str[360], name[24], reason[24], adminname[24], ip[16];
            db_get_field_assoc(result, "Nome", name, sizeof(name));
            db_get_field_assoc(result, "Admin", adminname, sizeof(adminname));
            db_get_field_assoc(result, "Motivo", reason, sizeof(reason));
            db_get_field_assoc(result, "IP", ip, sizeof(ip));

            format(str, sizeof(str), "{FFFFFF}\nThis account has been banned from the server, if you think this is mistake\nAcess our forum {FF0000}"FORUM" {FFFFFF}to unban apply.\n\nBan Name: {FF0000}%s\n{FFFFFF}Banned by: {FF0000}%s\n{FFFFFF}Reason: {FF0000}%s\n{FFFFFF}Ban Date: {FF0000}%02d/%02d/%d\n{FFFFFF}Ban IP: {FF0000}%s\n", name, adminname, reason,
                db_get_field_assoc_int(result,"Dia"), db_get_field_assoc_int(result,"Mes"), db_get_field_assoc_int(result,"Ano"), ip);

            ShowPlayerDialog(playerid, D_NullMSG, DIALOG_STYLE_MSGBOX, "{FFFFFF} # {FF0000}Banned {FFFFFF}#", str, "Close", "");
            SetTimerEx("DelayedKick", 1000, false, "i", playerid);
        }
        db_free_result(result);
    }
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    if(IsPlayerConnected(playerid) && !IsPlayerNPC(playerid))
    {    
        if(pInfo[playerid][pConectado] == true)
        {
            if(pInfo[playerid][pSpectando] == false)
            {
                SalvarPlayer(playerid);
            }    

            new string[61 + MAX_PLAYER_NAME];
            switch(reason)
            {
                case 0: format(string, sizeof(string), "[QUIT]: %s(%i) has left the server. [Connection/Crash]", PegarNome(playerid), playerid);
                case 1: format(string, sizeof(string), "[QUIT]: %s(%i) has left the server. [Leaving]", PegarNome(playerid), playerid);
                case 2: format(string, sizeof(string), "[QUIT]: %s(%i) has left the server. [Kicked/Banned]", PegarNome(playerid), playerid);
            }
            SendAdminMessage(string, COR_CINZA);
            SendLocalMessage(playerid, COR_CINZA, string, 20.0);
            pInfo[playerid][pConectado] = false;
        }
        for(new Player_Data:i; i < Player_Data; i++) { pInfo[playerid][i] = 0; }  // Resta os Dados
        for(new Inventory:i; i < Inventory; i++) { Inv[playerid][i] = 0; } // Reseta o Inventario
    }
    return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	if(!IsPlayerNPC(playerid))
	{
		if(pInfo[playerid][pConectado] == false)
		{
			for(new i; i < 60; i++) { SendClientMessage(playerid, -1, " "); }
			ShowPlayerDialog(playerid, D_Idioma, DIALOG_STYLE_MSGBOX, "{FFFFFF}# {9919E3}Language {FFFFFF}#", "{FFFFFF}\nSelect your language.\nSelecione o seu Idioma\n\n{FFE100}Aten��o:{FF0000} O Servidor n�o � 100% traduzido e n�o afeta ao que os outros jogadores falam no chat.", "Portugu�s", "English");
		}
	}
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	if(pInfo[playerid][pConectado] == false) return false;
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(!IsPlayerNPC(playerid) && pInfo[playerid][pConectado] == true) 
	{	
		if(pInfo[playerid][pRespawn] == 1)
		{
			
			new rnd = random(sizeof(Respawns));
			SetPlayerPos(playerid, Respawns[rnd][0], Respawns[rnd][1], Respawns[rnd][2]);
			SetPlayerInterior(playerid, 0), SetPlayerVirtualWorld(playerid, 0);
			ResetarPlayer(playerid);

			if(pInfo[playerid][pIdioma] == 1) ShowPlayerDialog(playerid, D_Sexo, DIALOG_STYLE_MSGBOX, "{FFFFFF}# Selecione seu Personagem #", "{FFFFFF}Voce deseja jogar com um personagem do sexo '{0F8FFF}Masculino{FFFFFF}' ou '{E84ADB}Feminino{FFFFFF}' ?", "Masculino", "Feminino");
			else ShowPlayerDialog(playerid, D_Sexo, DIALOG_STYLE_MSGBOX, "{FFFFFF}# Character Selection #", "{FFFFFF}You want to play as '{0F8FFF}Male{FFFFFF}' or '{E84ADB}Female{FFFFFF}' character ?", "Male", "Female");
		}
		else
		{
			SetPlayerHealth(playerid, pInfo[playerid][pHealth]);
			SetPlayerPos(playerid, pInfo[playerid][pX], pInfo[playerid][pY], pInfo[playerid][pZ]+1.0);
           
            for(new i; i < 8; i++) { GivePlayerWeapon(playerid, pInfo[playerid][pArma][i], pInfo[playerid][pMunicao][i]); }
		}

		SetPlayerSkin(playerid, pInfo[playerid][pSkin]);

		if(pInfo[playerid][pTemGPS] == 1) { MostrarGPS(playerid); }
		else { EsconderGPS(playerid); }

		if(pInfo[playerid][pSangrando] == 1) { PlayerTextDrawShow(playerid, Bleed[playerid]); }
		else { PlayerTextDrawHide(playerid, Bleed[playerid]); }

		if(pInfo[playerid][pQuebrado] == 1) { PlayerTextDrawShow(playerid, BrokenL[playerid]); }
		else { PlayerTextDrawHide(playerid, BrokenL[playerid]); }

		if(Inv[playerid][IsOpenedTD] == true) { HideInventory(playerid); }

		SetPlayerObject(playerid);
        
        TogglePlayerControllable(playerid, false);
		SetTimerEx("Unfreeze", 2000, false, "i", playerid);
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(!IsPlayerNPC(playerid) && IsPlayerConnected(playerid) && pInfo[playerid][pConectado] == true)
	{
		if(killerid != INVALID_PLAYER_ID)
		{
			pInfo[killerid][pKills]++;
			pInfo[killerid][pMoney] += 10;
			GameTextForPlayer(killerid, "~w~(Player Kill)~n~~g~+$10", 2500, 3);
		}

		pInfo[playerid][pRespawn] = 1;

		CreatePlayerBody(playerid);

	}

	static str[128];
	format(str, sizeof(str), "[KILL]: Player %s has been killed by %s with a %s.", PegarNome(playerid), PegarNome(killerid), GunName[GetPlayerWeapon(killerid)]);
	SendLocalMessage(killerid, -1, str, 5.0);
	return 1;
}

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid)
{
	if(damagedid != INVALID_PLAYER_ID && weaponid != 0)
	{
		PlayerPlaySound(playerid, 17802, 0.0, 0.0, 0.0);
	}
	return 1;
}


public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	static animlib[32], animname[32];
	GetAnimationName(GetPlayerAnimationIndex(playerid), animlib, 32, animname, 32);

	if(pInfo[playerid][pQuebrado] == 0) // Checa se o jogador nao estiver com a perna quebrada
	{
		if(amount > 15 && strcmp("FALL_FALL", animname, true) == 0) // Quando cai de uma certa altura
		{
			if(pInfo[playerid][pQuebrado] == 0)
			{
				pInfo[playerid][pQuebrado] = 1;
				GameTextForPlayer(playerid, "~w~Broken Leg!", 1500, 3);
				PlayerTextDrawShow(playerid, BrokenL[playerid]);
			}
		}
	}

	if(amount > 20)
    {
        if(pInfo[playerid][pSangrando] == 0)
        {
            pInfo[playerid][pSangrando] = 1;
            PlayerTextDrawShow(playerid, Bleed[playerid]);
        }
        SetPlayerDrunkLevel(playerid, 0);
    }

	if(issuerid != INVALID_PLAYER_ID && weaponid != 0)
	{
		if(weaponid == 34 && bodypart == 9)
		{

			if(pInfo[playerid][pTemCapacete] == 1)
			{
					GameTextForPlayer(issuerid, "~y~Player Using Helmet!", 2000, 3);
					GameTextForPlayer(playerid, "~g~Helmet Protected You!", 2000, 3);
			}
			else
			{
				SetPlayerHealth(playerid, 0);
				GameTextForPlayer(issuerid, "~r~Headshot!", 2000, 3);
				pInfo[issuerid][pHeadshots]++;
			}
		}

		if(bodypart == 7 || bodypart == 8)
		{
			if(pInfo[playerid][pQuebrado] == 0) // Checa se o jogador n ta com a perna quebrada
			{
				pInfo[playerid][pQuebrado] = 1;
				GameTextForPlayer(playerid, "~w~Broken Leg!", 1500, 3);
				PlayerTextDrawShow(playerid, BrokenL[playerid]);
			}
		}

		if(GetPlayerWeapon(issuerid) == 2) // knockback
		{
			static Float:Pos[4];
			GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
			if(IsPlayerInRangeOfPoint(issuerid, 5.0, Pos[0], Pos[1], Pos[2]))
			{
			   	if(pInfo[issuerid][pVipLevel] > 0)
			    {
			    	#define VELOCIDADE (1.5)

					GetPlayerVelocity(playerid, Pos[0], Pos[1], Pos[2]);
					GetPlayerFacingAngle(playerid, Pos[3]);
					        
					SetPlayerVelocity(playerid, VELOCIDADE * floatsin(-(Pos[3] + (180 % 360)), degrees), VELOCIDADE * floatcos(-(Pos[3] + (180 % 360)), degrees), Pos[2] + 0.1);
					ApplyAnimation(playerid, "ped", "FALL_back", 4.1, 0, 0, 0, 0, 0, 1);
			    }
			    else
			    {
			    	if(pInfo[playerid][pTemColete] == 0)
			    	{
					    static Float:health;
						GetPlayerHealth(playerid, health);
						SetPlayerHealth(playerid, health-25);
						ApplyAnimation(playerid, "MISC", "plyr_shkhead", 4.0, 0, 1, 1, 1, -1);
						GameTextForPlayer(playerid, "~r~Injured!", 1500, 3);
						SetPlayerDrunkLevel(playerid, 9999);
					}
				}
			} 
		}
	}	
	return 1;
}

public OnPlayerText(playerid, text[])
{
    if(pInfo[playerid][pConectado] == true && IsPlayerConnected(playerid) && !IsPlayerNPC(playerid))
    {
    	static str[144];
    	if(pInfo[playerid][pMute] == true)
    	{
    		SendClientMessage(playerid, COR_VERMELHO, Translate(pInfo[playerid][pIdioma], "[INFO]: Voc� est� mutado, portanto n�o pode usar o chat.", "[INFO]: You are muted."));
    		return false;
    	}

    	if(strlen(text) > 91)
    	{
    		SendClientMessage(playerid, COR_VERMELHO, Translate(pInfo[playerid][pIdioma], "[INFO]: Seu texto ultrapassou os 91 caract�res.", "[INFO]: Your text exceeded the 91 characters."));
    		return false;
    	}

    	if(pInfo[playerid][pVipLevel] > 0)
    	{
	        format(str, sizeof(str), "{A1D490}[LOCAL]{FFFFFF}: [%s{FFFFFF}] %s(%i): %s", GetVipNameWithColor(playerid), PegarNome(playerid), playerid, text);
	        SendLocalMessage(playerid, -1, str, 10.0);
    	}
        else
    	{
	        format(str, sizeof(str), "{A1D490}[LOCAL]{FFFFFF}: %s(%i): %s", PegarNome(playerid), playerid, text);
	        SendLocalMessage(playerid, -1, str, 10.0);
    	}
    }
	return 0;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(pInfo[playerid][pConectado] == true && IsPlayerConnected(playerid) && !IsPlayerNPC(playerid))
	{
		if(PRESSED(KEY_YES))
		{
			cmd_inv(playerid);
		}
        if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
        {
		    if(pInfo[playerid][pQuebrado] == 1)
            {
        	    if(PRESSED(KEY_JUMP) || RELEASED(KEY_JUMP) || HOLDING(KEY_JUMP)) { ApplyAnimation(playerid, "GYMNASIUM", "gym_jog_falloff", 4.1, 0, 1, 1, 0, 0, 1); }
        	    if(PRESSED(KEY_SPRINT) || RELEASED(KEY_SPRINT) || HOLDING(KEY_SPRINT)) { ApplyAnimation(playerid, "GYMNASIUM", "gym_jog_falloff", 4.1, 0, 1, 1, 0, 0, 1); }
            }

            if(PRESSED(KEY_SECONDARY_ATTACK))
            {
            	new storeid = GetClosestStoreFromPlayer(playerid);
            	if(storeid != -1)
            	{
            		DisplayMarketForPlayer(playerid, MarketSpawns[storeid][mProdutos]);
            	}
            }

            if(PRESSED(KEY_HANDBRAKE) && GetPlayerWeapon(playerid) == 34)
            {
            	RemoveAllAttachedObjects(playerid);
            }
            if(RELEASED(KEY_HANDBRAKE) && GetPlayerWeapon(playerid) == 34)
            {
            	SetPlayerObject(playerid);
            }
        }
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			if(PRESSED(KEY_LOOK_BEHIND))
			{
				cmd_engine(playerid);
			}
		}
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case D_Sexo:
		{
			if(response)
			{
				SetPlayerSkin(playerid, 299),
				pInfo[playerid][pGenero] = 0;
				SendClientMessage(playerid, COR_CINZA, Translate(pInfo[playerid][pIdioma], "[INFO]: Personagem 'Masculino' selecionado.", "[INFO] 'Male' character selected."));
			}
			if(!response)
			{
				SetPlayerSkin(playerid, 63),
				pInfo[playerid][pGenero] = 1;
				SendClientMessage(playerid, COR_CINZA, Translate(pInfo[playerid][pIdioma], "[INFO]: Personagem 'Feminino' selecionado.", "[INFO] 'Female' character selected."));
			}			
		}
		case D_Radio:
		{
			if(response)
			{
				if(!strval(inputtext) || strval(inputtext) > 100 || strval(inputtext) < 0)
				{
					SendClientMessage(playerid, COR_VERMELHO, Translate(pInfo[playerid][pIdioma], "[RADIO]: Frequ�ncia Inv�lida, Tente (0-100).", "[RADIO] Invalid Frequency, Try (0-100)."));
					if(pInfo[playerid][pIdioma] == 1) ShowPlayerDialog(playerid, D_Radio, DIALOG_STYLE_INPUT, "{FFFFFF}# Frequencia do Radio #", "{FFFFFF}Frequencias Disponiveis: (0 - 100)", "Selecionar", "Fechar");
	                else ShowPlayerDialog(playerid, D_Radio, DIALOG_STYLE_INPUT, "{FFFFFF}# Radio Frequency #", "{FFFFFF}Frequencys Avaliables: (0 - 100)", "Set", "Close");
					return 1;
				}

				new str[80];
                
                pInfo[playerid][pChat] = strval(inputtext);

				if(pInfo[playerid][pIdioma] == 1) format(str, sizeof(str), "[RADIO]: Frequ�ncia alterada para '%i'.", strval(inputtext));
				else format(str, sizeof(str), "[RADIO]: Frequency changed to '%i'.", strval(inputtext));
				SendClientMessage(playerid, COR_CINZA, str);
				PlayerPlaySound(playerid, 45400, 0.0, 0.0, 0.0);
			}
		}
		case D_Idioma:
		{
			if(response)
			{
				SetarIdioma(playerid, IDIOMA_PORTUGUES);

				SendClientMessage(playerid, COR_CINZA, "[IDIOMA]: Voc� selecionou o Idioma 'Portugu�s'.");

                ShowLoginScreenForPlayer(playerid);
			}
			else
			{
				SetarIdioma(playerid, IDIOMA_INGLES);

				SendClientMessage(playerid, COR_CINZA, "[LANGUAGE]: The language has set to 'English'.");

				ShowLoginScreenForPlayer(playerid);	
			}
		}
		case D_Config:
		{
			if(response)
			{
			    switch(listitem)
			    {
				    case 0:
				    {
					    if(pInfo[playerid][pIdioma] == IDIOMA_INGLES)
					    {
						    SetarIdioma(playerid, IDIOMA_PORTUGUES);
						    SendClientMessage(playerid, COR_CINZA, "[IDIOMA]: Idioma alterado para 'Portugu�s'.");
					    }
					    else
					    {
						    SetarIdioma(playerid, IDIOMA_INGLES);
						    SendClientMessage(playerid, COR_CINZA, "[LANGUAGE]: Language changed to 'English'.");
					    }
				    }
				    case 1: cmd_hud(playerid);
				    case 2: cmd_blockpm(playerid);
				    case 3:
				    {
				    	if(Inv[playerid][pInvType] == false)
				    	{
				    		if(Inv[playerid][IsOpenedTD]) { HideInventory(playerid); } // Evitar que ambos os inventarios sejam exibidos
				    		Inv[playerid][pInvType] = true;
				    		SendClientMessage(playerid, COR_CINZA, Translate(pInfo[playerid][pIdioma], "[INVENTARIO]: Invent�rio alterado para 'Dialog'.", "[INVENTORY]: Inventory changed to 'Dialog'."));
				    	}
				    	else
				    	{
				    		Inv[playerid][pInvType] = false;
				    		SendClientMessage(playerid, COR_CINZA, Translate(pInfo[playerid][pIdioma], "[INVENTARIO]: Invent�rio alterado para 'Textdraw'.", "[INVENTORY]: Inventory changed to 'Textdraw'."));
				    	}
				    }
			    }
		    }

		}
		case D_NullMSG: PlayerPlaySound(playerid, 1138, 0.0, 0.0, 0.0);
	}
	return 1;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	INV_OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid);
	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(Inv[playerid][IsOpenedTD] == true)
	{
		if(clickedid == Text:INVALID_TEXT_DRAW)
		{
			HideInventory(playerid);
		}
	}
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	vInfo[vehicleid][vCombustivel] = random(20);
	vInfo[vehicleid][vTemMotor] = false;
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(pInfo[playerid][pConectado] == true && IsPlayerConnected(playerid) && !IsPlayerNPC(playerid))
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			
			new vehicleid = GetPlayerVehicleID(playerid);
			GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

			if(!IsABike(vehicleid))
			{
				if(vInfo[vehicleid][vTemMotor] == true && vInfo[vehicleid][vMotor] == false) SendClientMessage(playerid, COR_AMARELO, Translate(pInfo[playerid][pIdioma], "[INFO]: Digite: '/motor' ou aperte '2' para ligar o motor.", 
				"[INFO]: Type: '/engine or press '2' to start vehicle engine."));

				if(vInfo[vehicleid][vMotor] == true) PlayerTextDrawColor(playerid,VEH_HUD[playerid][4], 0x00FF1EFF);
				else PlayerTextDrawColor(playerid,VEH_HUD[playerid][4], 0xFF0000FF);

				if(vInfo[vehicleid][vCombustivel] == 0) SetVehicleParamsEx(vehicleid, 0, lights, alarm, doors, bonnet, boot, objective);
				if(vInfo[vehicleid][vTemMotor] == false) SetVehicleParamsEx(vehicleid, 0, lights, alarm, doors, bonnet, boot, objective);
                if(vInfo[vehicleid][vPneus] != Vehicle_Tires[GetVehicleModel(vehicleid)-400][1]) SetVehicleParamsEx(vehicleid, 0, lights, alarm, doors, bonnet, boot, objective);

				new str[64];
				format(str, sizeof(str), "Fuel: ~y~%i~n~~w~Engine: %s~n~~w~Tires: (%i/%i)", 
				    vInfo[vehicleid][vCombustivel], vInfo[vehicleid][vTemMotor] ? ("~g~YES") : ("~r~NO"), vInfo[vehicleid][vPneus], Vehicle_Tires[GetVehicleModel(vehicleid)-400][1]);
				PlayerTextDrawSetString(playerid, VEH_HUD[playerid][3], str);

				for(new i; i < 5; i++) { PlayerTextDrawShow(playerid, VEH_HUD[playerid][i]); }
			}
			else
			{
				SetVehicleParamsEx(vehicleid, 1, lights, alarm, doors, bonnet, boot, objective); // Liga a bicicleta
			}
		}
		else
		{
			for(new i; i < 5; i++) { PlayerTextDrawHide(playerid, VEH_HUD[playerid][i]); }
		}
	}
	return 1;
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
	if(pInfo[playerid][pConectado] == true && IsPlayerConnected(playerid) && !IsPlayerNPC(playerid))
	{
	    for(new i = 0; i < sizeof(InfectedAreas); i++)
	    {
		    if(areaid == InfectedAreas[i])
		    {
		    	pInfo[playerid][inInfection] = true;
		    	PlayerTextDrawShow(playerid, TOPOMENSAGEM[playerid]);
		    }
	    }	
    }
	return 1;
}

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
	if(pInfo[playerid][pConectado] == true && IsPlayerConnected(playerid) && !IsPlayerNPC(playerid))
	{
	    for(new i = 0; i < sizeof(InfectedAreas); i++)
	    {
		    if(areaid == InfectedAreas[i])
		    {
		    	pInfo[playerid][inInfection] = false;
		    	PlayerTextDrawHide(playerid, TOPOMENSAGEM[playerid]);
		    }
	    }	
    }
	return 1;
}

public OnPlayerUpdate(playerid){
	if(GetTickCount() - armedbody_pTick[playerid] > 113){ //prefix check itter
		new
			weaponid[13],weaponammo[13],pArmedWeapon;
		pArmedWeapon = GetPlayerWeapon(playerid);
		GetPlayerWeaponData(playerid,6,weaponid[1],weaponammo[1]);
		GetPlayerWeaponData(playerid,2,weaponid[2],weaponammo[2]);
		GetPlayerWeaponData(playerid,4,weaponid[4],weaponammo[4]);
		GetPlayerWeaponData(playerid,5,weaponid[5],weaponammo[5]);
		GetPlayerWeaponData(playerid,3,weaponid[7],weaponammo[7]);
		if(weaponid[1] && weaponammo[1] > 0){
			if(pArmedWeapon != weaponid[1]){
				if(!IsPlayerAttachedObjectSlotUsed(playerid,5)){
					SetPlayerAttachedObject(playerid,5,GetWeaponModel(weaponid[1]),1, 0.1829, -0.2199, 0.0989, -91.7000, -6.0999, -179.1000, 1.0000, 1.0000, 1.0000);
				}
			}
			else {
				if(IsPlayerAttachedObjectSlotUsed(playerid,5)){
					RemovePlayerAttachedObject(playerid,5);
				}
			}
		}
		else if(IsPlayerAttachedObjectSlotUsed(playerid,5)){
			RemovePlayerAttachedObject(playerid,5);
		}
		if(weaponid[2] && weaponammo[2] > 0){
			if(pArmedWeapon != weaponid[2]){
				if(!IsPlayerAttachedObjectSlotUsed(playerid,6)){
					SetPlayerAttachedObject(playerid,6,GetWeaponModel(weaponid[2]),8, -0.079999, -0.039999, 0.109999, -90.100006, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
				}
			}
			else {
				if(IsPlayerAttachedObjectSlotUsed(playerid,6)){
					RemovePlayerAttachedObject(playerid,6);
				}
			}
		}
		else if(IsPlayerAttachedObjectSlotUsed(playerid,6)){
			RemovePlayerAttachedObject(playerid,6);
		}
		if(weaponid[4] && weaponammo[4] > 0){
			if(pArmedWeapon != weaponid[4]){
				if(!IsPlayerAttachedObjectSlotUsed(playerid,7)){
					SetPlayerAttachedObject(playerid,7,GetWeaponModel(weaponid[4]),7, 0.000000, -0.100000, -0.080000, -95.000000, -10.000000, 0.000000, 1.000000, 1.000000, 1.000000);
				}
			}
			else {
				if(IsPlayerAttachedObjectSlotUsed(playerid,7)){
					RemovePlayerAttachedObject(playerid,7);
				}
			}
		}
		else if(IsPlayerAttachedObjectSlotUsed(playerid,7)){
			RemovePlayerAttachedObject(playerid,7);
		}
		if(weaponid[5] && weaponammo[5] > 0){
			if(pArmedWeapon != weaponid[5]){
				if(!IsPlayerAttachedObjectSlotUsed(playerid,8)){
					SetPlayerAttachedObject(playerid,8,GetWeaponModel(weaponid[5]),1, 0.2180, -0.2180, -0.2030, 92.4999, -177.0998, 0.0999, 1.0000, 1.0000, 1.0000);
				}
			}
			else {
				if(IsPlayerAttachedObjectSlotUsed(playerid,8)){
					RemovePlayerAttachedObject(playerid,8);
				}
			}
		}
		else if(IsPlayerAttachedObjectSlotUsed(playerid,8)){
			RemovePlayerAttachedObject(playerid,8);
		}
		if(weaponid[7] && weaponammo[7] > 0){
			if(pArmedWeapon != weaponid[7]){
				if(!IsPlayerAttachedObjectSlotUsed(playerid,9)){
					SetPlayerAttachedObject(playerid,9,GetWeaponModel(weaponid[7]),1, 0.2390, -0.1860, -0.1639, 92.3999, -168.2999, 2.8999, 1.0000, 1.0000, 1.0000);
				}
			}
			else {
				if(IsPlayerAttachedObjectSlotUsed(playerid,9)){
					RemovePlayerAttachedObject(playerid,9);
				}
			}
		}
		else if(IsPlayerAttachedObjectSlotUsed(playerid,9)){
			RemovePlayerAttachedObject(playerid,9);
		}
		armedbody_pTick[playerid] = GetTickCount();
	}
	return true;
}

forward Setarlimite();
public Setarlimite()
{
    foreach(new i : Player)
	{
		if(pInfo[i][pConectado] == true && !IsPlayerNPC(i))
		{
			if(pInfo[i][pFome] > 100) pInfo[i][pFome] = 100;
            if(pInfo[i][pSede] > 100) pInfo[i][pSede] = 100;
        }
    }    
    return 1;
} 
public AtualizarPlayer()
{
	foreach(new i : Player)
	{
		if(pInfo[i][pConectado] == true && !IsPlayerNPC(i))
		{
			static str[128];
		
            static Float:health;
            GetPlayerHealth(i, health);
			format(str, sizeof(str), "%.0f", (health*100));
			PlayerTextDrawSetString(i, PLAYER_HUD[i][1], str);

			format(str, sizeof(str), "%.0i%", pInfo[i][pSede]);
			PlayerTextDrawSetString(i, PLAYER_HUD[i][5], str);

			format(str, sizeof(str), "%.0i%", pInfo[i][pFome]);
			PlayerTextDrawSetString(i, PLAYER_HUD[i][3], str);

			format(str, sizeof(str), "%.0i%", pInfo[i][pInfection]);
			PlayerTextDrawSetString(i, PLAYER_HUD[i][7], str);

			format(str, sizeof(str), "Headshots: %i~n~Murders: %i~n~Level: %i~n~~g~$%04i~n~~n~~n~~w~Weapon: %s - Ammo: %i", 
			pInfo[i][pHeadshots], pInfo[i][pKills], pInfo[i][pLevel], pInfo[i][pMoney], GunName[GetPlayerWeapon(i)], GetPlayerAmmo(i));
			PlayerTextDrawSetString(i, PLAYER_HUD[i][8], str);

		}
	}
	return 1;
}

public AtualizarGasolina()
{
	foreach(new i : Player)
	{
		if(pInfo[i][pConectado] == true && !IsPlayerNPC(i))
		{
			if(GetPlayerState(i) == PLAYER_STATE_DRIVER)
			{
				new vehicleid = GetPlayerVehicleID(i);
				if(!IsABike(vehicleid))
				{
				    if(vInfo[vehicleid][vCombustivel] > 0 && vInfo[vehicleid][vMotor] == true) vInfo[vehicleid][vCombustivel]--;
				    if(vInfo[vehicleid][vCombustivel] == 0)
				    {
					    GameTextForPlayer(i, "~r~Empty Fuel", 2000, 3);
					    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
					    SetVehicleParamsEx(vehicleid, 0, lights, alarm, doors, bonnet, boot, objective);
				    }

				    static str[64];
				    format(str, sizeof(str), "Fuel: ~y~%i~n~~w~Engine: %s~n~~w~Tires: (%i/%i)", 
				    	vInfo[vehicleid][vCombustivel], vInfo[vehicleid][vTemMotor] ? ("~g~YES") : ("~r~NO"), vInfo[vehicleid][vPneus], Vehicle_Tires[GetVehicleModel(vehicleid)-400][1]);
				    PlayerTextDrawSetString(i, VEH_HUD[i][3], str);
			    }
			}
		}
	}
	return 1;
}

public AtualizarFome()
{
	foreach(new i : Player)
	{
		if(pInfo[i][pConectado] == true && !IsPlayerNPC(i))
		{
			if(pInfo[i][pFome] > 0) pInfo[i][pFome]--;
			if(pInfo[i][pFome] == 5) 
			{
				SendClientMessage(i, COR_AMARELO, Translate(pInfo[i][pIdioma], "[FOME]: Voc� est� ficando com fome, coma alguma coisa ou ir� morrer.", 
			    "[HUNGER]: You're getting hungry, eat something or you will die!"));
			    SetPlayerDrunkLevel(i, 0);
			}     
			if(pInfo[i][pFome] == 0)
			{
				static Float:health;
				GetPlayerHealth(i, health), SetPlayerHealth(i, health-300);
				new str[128];
			    format(str, sizeof(str), "* %s(%i) has died from hunger!", PegarNome(i), i);
                SendLocalMessage(i, COR_ROXO, str, 10.0);
			}
		}
	}
	return 1;
}

public AtualizarSede()
{
	foreach(new i : Player)
	{
		if(pInfo[i][pConectado] == true && !IsPlayerNPC(i))
		{
			if(pInfo[i][pSede] > 0) pInfo[i][pSede]--;
			if(pInfo[i][pSede] == 5) 
            {
			    SendClientMessage(i, COR_AMARELO, Translate(pInfo[i][pIdioma], "[SEDE]: Voc� est� ficando com sede, beba alguma coisa ou ir� morrer.", 
			    "[THIRST]: You're getting thirsty, drink something or you will die!"));
			    SetPlayerDrunkLevel(i, 0);
			}	
			if(pInfo[i][pSede] == 0)
			{
				static Float:health;
				GetPlayerHealth(i, health), SetPlayerHealth(i, health-300);
                new str[128];
			    format(str, sizeof(str), "* %s(%i) has died from thirst!", PegarNome(i), i);
                SendLocalMessage(i, COR_ROXO, str, 10.0);
			}
		}
	}
	return 1;
}

public AtualizarSangramento()
{
    foreach(new i : Player)
    {
        if(pInfo[i][pConectado] == true && !IsPlayerNPC(i))
        {
            if(pInfo[i][pSangrando] == 1)
            {
                static Float:health;
                GetPlayerHealth(i, health);
                if(health > 0.0)
                {
                    SetPlayerAttachedObject(i, 3, 18668, 1, 0.000000, 0.000000, -1.837002, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000, 0, 0);
                    SetPlayerDrunkLevel(i, 0);
                    SetPlayerHealth(i, health-5);
                }
            }
            if(pInfo[i][inInfection] == true && pInfo[i][pSpectando] == false)
            {
                if(pInfo[i][pTemMascara] == 0)
                {
                    pInfo[i][pInfection] += 5;
                    SetPlayerDrunkLevel(i, 4500);
                    if(pInfo[i][pInfection] > 100)
                    {
                        pInfo[i][pInfection] = 0;
                        SetPlayerHealth(i, 0);
                        new str[128];
                        format(str, sizeof(str), "* %s(%i) has died from radiation.", PegarNome(i), i);
                        SendLocalMessage(i, COR_ROXO, str, 10.0);
                    }
                }
            }
        }
    }
    return 1;
}

public DelayedKick(playerid)
{
    Kick(playerid);
    return 1;
}

public Unfreeze(playerid)
{
	TogglePlayerControllable(playerid, true);
	return 1;
}

public AtualizarHM() // H = Horas, M = Minutos
{
	gettime(horas, minutos);
	foreach(new i : Player)
	{
		if(pInfo[i][pConectado] == true && !IsPlayerNPC(i))
		{
			SetPlayerTime(i, horas, minutos);

			pInfo[i][pPlayTime]++;
			if(pInfo[i][pPlayTime] >= 60)
			{
				pInfo[i][pLevel]++;
				SetPlayerScore(i, pInfo[i][pLevel]);
				pInfo[i][pPlayTime] = 0;
				GameTextForPlayer(i, "~y~(LEVEL UP!) + ~g~$10", 4000, 3);
				pInfo[i][pMoney] += 10;
			}
		}
	}
	return 1;
}

public MensagemRandomica()
{
    foreach(new i : Player)
    {
    	if(pInfo[i][pConectado] == true)
    	{
    		if(pInfo[i][pIdioma] == IDIOMA_PORTUGUES) { SendClientMessage(i, -1, RandomMessages[random(sizeof(RandomMessages))][Portugues]); }
    		else { SendClientMessage(i, -1, RandomMessages[random(sizeof(RandomMessages))][Ingles]); }
    	}
    }
	return 1;
}

stock ResetarPlayer(playerid)
{
	ResetPlayerInventory(playerid);
	ResetPlayerWeapons(playerid);
    
    pInfo[playerid][pRespawn] = 0;
	pInfo[playerid][pChat] = 0;
	pInfo[playerid][pQuebrado] = 0;
	pInfo[playerid][pSangrando] = 0;
	pInfo[playerid][pHeadshots] = 0;
	pInfo[playerid][pKills] = 0;
	pInfo[playerid][pInfection] = 0;
	pInfo[playerid][pTemColete] = 0;
	pInfo[playerid][pTemCapacete] = 0;
	pInfo[playerid][pTemMascara] = 0;
	pInfo[playerid][pTemGPS] = 0;
	pInfo[playerid][inInfection] = false;

    switch(pInfo[playerid][pVipLevel])
    {
    	case 0: // Sem Vip
    	{
			pInfo[playerid][pBackpack] = 5;
			pInfo[playerid][pFome] = 50;
			pInfo[playerid][pSede] = 50;

			AddItem(playerid, 11, 1); // Water Canteen
			AddItem(playerid, 6, 1); // Bandage

			SetPlayerHealth(playerid, 120);
		}	
		case 1: // Vip Bronze
    	{
			pInfo[playerid][pBackpack] = 10;
			pInfo[playerid][pFome] = 70;
			pInfo[playerid][pSede] = 70;

			AddItem(playerid, 11, 1); // Water Canteen
			AddItem(playerid, 6, 1); // Bandage
			AddItem(playerid, 5, 1); // Medkit
			AddItem(playerid, 69, 2); // Tire

			SetPlayerHealth(playerid, 140);
		}
		case 2: // Vip Silver
    	{
			pInfo[playerid][pBackpack] = 10;
			pInfo[playerid][pFome] = 80;
			pInfo[playerid][pSede] = 80;

			AddItem(playerid, 11, 1); // Water Canteen
			AddItem(playerid, 6, 1); // Bandage
			AddItem(playerid, 5, 1); // Medkit
			AddItem(playerid, 69, 2); // Tire
			AddItem(playerid, 60, 1); // Engine
			AddItem(playerid, 66, 1); // Full Jerry Can
			
			SetPlayerHealth(playerid, 150);
		}
		case 3: // Vip Gold
    	{
			pInfo[playerid][pBackpack] = 16;
			pInfo[playerid][pFome] = 90;
			pInfo[playerid][pSede] = 90;

			AddItem(playerid, 11, 1); // Water Canteen
			AddItem(playerid, 6, 1); // Bandage;
			AddItem(playerid, 5, 1); // Medkit
			AddItem(playerid, 69, 3); // Tire
			AddItem(playerid, 8, 1); // Painkiller
			AddItem(playerid, 9, 3); // Blood bag
			AddItem(playerid, 69, 2); // Tire
			AddItem(playerid, 35, 1); // M4
			AddItem(playerid, 48, 1); // Assault Ammo
			AddItem(playerid, 60, 1); // Engine
			AddItem(playerid, 66, 1); // Full Jerry Can
			
			SetPlayerHealth(playerid, 165);
		}
		case 4: // Vip Specialist
    	{
			pInfo[playerid][pBackpack] = 24;
			pInfo[playerid][pFome] = 90;
			pInfo[playerid][pSede] = 90;

			AddItem(playerid, 11, 1); // Water Canteen
			AddItem(playerid, 6, 1); // Bandage;
			AddItem(playerid, 5, 1); // Medkit
			AddItem(playerid, 8, 1); // Painkiller
			AddItem(playerid, 9, 2); // Blood bag
			AddItem(playerid, 69, 4); // Tire
			AddItem(playerid, 35, 1); // M4
			AddItem(playerid, 48, 2); // Assault Ammo
			AddItem(playerid, 34, 1); // Sniper
			AddItem(playerid, 52, 1); // Sniper Ammo
			AddItem(playerid, 60, 1); // Engine
			AddItem(playerid, 66, 1); // Full Jerry Can
			AddItem(playerid, 58, 1); // Sheriff Skin
			AddItem(playerid, 65, 1); // Helmet
			
			SetPlayerHealth(playerid, 175);
		}
		case 5: // Vip BlackZ
    	{
			pInfo[playerid][pBackpack] = 40;
			pInfo[playerid][pFome] = 50;
			pInfo[playerid][pSede] = 50;

			AddItem(playerid, 11, 1); // Water Canteen
			AddItem(playerid, 6, 1); // Bandage;
			AddItem(playerid, 5, 1); // Medkit
			AddItem(playerid, 8, 1); // Painkiller
			AddItem(playerid, 9, 2); // Blood bag
			AddItem(playerid, 69, 6); // Tire
			AddItem(playerid, 35, 1); // M4
			AddItem(playerid, 48, 5); // Assault Ammo
			AddItem(playerid, 37, 1); // MP-133 Shotgun
			AddItem(playerid, 49, 2); // Shotgun Ammo
			AddItem(playerid, 34, 1); // Sniper
			AddItem(playerid, 52, 2); // Sniper Ammo
			AddItem(playerid, 60, 1); // Engine
			AddItem(playerid, 66, 1); // Full Jerry Can
			AddItem(playerid, 65, 1); // Helmet
			AddItem(playerid, 57, 1); // Black Officer
			AddItem(playerid, 61, 1); // Toolbox
			AddItem(playerid, 85, 1); // Cooked
			AddItem(playerid, 72, 1); // Smirnoff
			
			SetPlayerHealth(playerid, 200);
		}
		case 6: // Vip Hunter
    	{
			pInfo[playerid][pBackpack] = 40;
			pInfo[playerid][pFome] = 100;
			pInfo[playerid][pSede] = 100;

			AddItem(playerid, 11, 1); // Water Canteen
			AddItem(playerid, 6, 1); // Bandage;
			AddItem(playerid, 5, 2); // Medkit
			AddItem(playerid, 8, 1); // Painkiller
			AddItem(playerid, 9, 2); // Blood bag
			AddItem(playerid, 69, 6); // Tire
			AddItem(playerid, 35, 1); // M4
			AddItem(playerid, 48, 5); // Assault Ammo
			AddItem(playerid, 37, 1); // MP-133 Shotgun
			AddItem(playerid, 49, 2); // Shotgun Ammo
			AddItem(playerid, 34, 1); // Sniper
			AddItem(playerid, 52, 4); // Sniper Ammo
			AddItem(playerid, 60, 1); // Engine
			AddItem(playerid, 66, 1); // Full Jerry Can
			AddItem(playerid, 65, 1); // Helmet
			AddItem(playerid, 100, 1); // M�fia Skin
			AddItem(playerid, 61, 1); // Toolbox
			AddItem(playerid, 85, 2); // Cooked
			AddItem(playerid, 72, 2); // Smirnoff
			
			SetPlayerHealth(playerid, 255);
		}											
	}		
	return 1;
}

stock GetVipName(playerid)
{
	new str[24];
	switch(pInfo[playerid][pVipLevel])
	{
		case 1: str = "Bronze Premium";
		case 2: str = "Silver Premium";
		case 3: str = "Gold Premium";
		case 4: str = "Specialist Premium";
		case 5: str = "BlackZ Premium";
		case 6: str = "Hunter Premium";
	}
	return str;
}

stock GetVipNameWithColor(playerid)
{
	new str[32];
	switch(pInfo[playerid][pVipLevel])
	{
		case 1: str = "{824220}Bronze Premium";
		case 2: str = "{ADADAD}Silver Premium";
		case 3: str = "{D1B22B}Gold Premium";
		case 4: str = "{9102FF}Specialist Premium";
		case 5: str = "{FA0804}BlackZ Premium";
		case 6: str = "{FA8E01}Hunter Premium";
	}
	return str;
}

stock SetVipColor(playerid)
{
	switch(pInfo[playerid][pVipLevel])
	{
		case 1: SetPlayerColor(playerid,0x824220FF);
		case 2: SetPlayerColor(playerid,0xADADADFF);
		case 3: SetPlayerColor(playerid,0xD1B22BFF);
		case 4: SetPlayerColor(playerid,0x9102FFFF);
		case 5: SetPlayerColor(playerid,0xFA0804FF);
		case 6: SetPlayerColor(playerid,0xFA8E01FF);
	}
	return 1;
}

stock SetPlayerObject(playerid)
{
	// # Mochilas #
	switch(pInfo[playerid][pBackpack])
    {
        case 5: SetPlayerAttachedObject(playerid, 0, 363, 1, 0.265998, -0.145998, 0.232999, 11.199977, 88.300025, -10.800001, 1.213999, 1.000000, 1.079999, 0xFF6C4C00);
        case 10: SetPlayerAttachedObject(playerid, 0, 3026, 1, -0.110999, -0.086999, 0.002999, 0.000000, 0.000000, 0.000000, 0.996999, 1.053998, 1.064001 );
        case 16: SetPlayerAttachedObject(playerid, 0, 371, 1, 0.0280, -0.1370, 0.0030, -0.5999, 87.9000, 0.8999, 1.0000, 1.0000, 1.0000 );
        case 24: SetPlayerAttachedObject(playerid, 0, 1310, 1, -0.027999, -0.150999, 0.000000, 3.000000, 90.000000, 1.000000, 0.832000, 0.909000, 0.838000 );
        case 32: SetPlayerAttachedObject( playerid, 0, 1550, 1, 0.107000, -0.270999, 0.006999, 0.000000, 85.000000, 0.000000, 0.968999, 1.000000, 0.973999 );
        case 40: SetPlayerAttachedObject(playerid, 0, 19559, 1, 0.081000, -0.063000, 0.000000, 0.000000, 88.899955, 0.000000, 1.000000, 1.259000, 1.000000 );
        default: RemovePlayerAttachedObject(playerid, 0);
    }

    if(pInfo[playerid][pTemCapacete] == 1) SetPlayerAttachedObject(playerid, 2, 19514, 2, 0.105000, 0.000000, 0.000000);
    else RemovePlayerAttachedObject(playerid, 2);

    if(pInfo[playerid][pTemMascara] == 1) SetPlayerAttachedObject(playerid, 4, 19472, 2, -0.000999, 0.150999, -0.009999, 19.100006, 82.700119, 71.200050, 1.068000, 1.134999, 1.146000);
    else RemovePlayerAttachedObject(playerid, 4);

    if(pInfo[playerid][pTemColete] == 1)
    {
    	if(pInfo[playerid][pGenero] == 1) SetPlayerAttachedObject(playerid, 1, 19515, 1, 0.157899, 0.053999, 0.000000, 0.000000, 0.000000, 0.000000, 0.886999, 1.120999, 0.894899, 0xFF2E2D33, 0xFFFFFFFF);
        else SetPlayerAttachedObject(playerid, 1, 19515, 1, 0.078899, 0.050000, 0.000000, 0.000000, 0.000000, 0.000000, 1.047000, 1.252998, 1.130900, 0xFF2E2D33, 0xFFFFFFFF);
    }
    else RemovePlayerAttachedObject(playerid, 1);
	return 1;
}

stock RemoveAllAttachedObjects(playerid)
{
	for(new i; i < MAX_PLAYER_ATTACHED_OBJECTS; i++) { RemovePlayerAttachedObject(playerid, i); }
}

stock MostrarInterface(playerid)
{
	new i;
	for(i = 0; i < 14; i++) { TextDrawShowForPlayer(playerid, PLAYER_HUD_DESIGN[i]); }
	for(i = 0; i < 10; i++) { PlayerTextDrawShow(playerid, PLAYER_HUD[playerid][i]); }
	pInfo[playerid][pInterface] = true;

	new str[34];
	format(str, sizeof(str), "[~y~%s~w~]", PegarNome(playerid));
	PlayerTextDrawSetString(playerid, PLAYER_HUD[playerid][9], str);	
	return 1;
}

stock EsconderInterface(playerid)
{
	new i;
	for(i = 0; i < 14; i++) { TextDrawHideForPlayer(playerid, PLAYER_HUD_DESIGN[i]); }	
	for(i = 0; i < 10; i++) { PlayerTextDrawHide(playerid, PLAYER_HUD[playerid][i]); }
	pInfo[playerid][pInterface] = false;
	return 1;
}

stock MostrarGPS(playerid)
{
	GangZoneHideForPlayer(playerid, gps);
	for(new i = 0; i < 3; i++) { TextDrawHideForPlayer(playerid, GPS_HUD[i]); }
	return 1;
}

stock EsconderGPS(playerid)
{
	GangZoneShowForPlayer(playerid, gps, 0x000000FF);
	for(new i = 0; i < 3; i++) { TextDrawShowForPlayer(playerid, GPS_HUD[i]); }
	return 1;
}

stock SetarIdioma(playerid, idiomaid)
{
	switch(idiomaid)
	{
		case IDIOMA_PORTUGUES:
		{
			pInfo[playerid][pIdioma] = IDIOMA_PORTUGUES;

			PlayerTextDrawSetString(playerid, Bleed[playerid], "~r~SANGRANDO");
            PlayerTextDrawSetString(playerid, BrokenL[playerid], "PERNA QUEBRADA");
            PlayerTextDrawSetString(playerid, TOPOMENSAGEM[playerid], "~y~[ ! ]~r~ Zona Infectada ~y~[ ! ]");
            PlayerTextDrawSetString(playerid, LOGIN[playerid][0], "Nome:");
            PlayerTextDrawSetString(playerid, LOGIN[playerid][2], "Senha:");
            PlayerTextDrawSetString(playerid, LOGIN[playerid][3], "Insira sua senha aqui");
            PlayerTextDrawSetString(playerid, LOGIN[playerid][5], "Registrar");
		}
		case IDIOMA_INGLES:
		{
			pInfo[playerid][pIdioma] = IDIOMA_INGLES;

			PlayerTextDrawSetString(playerid, Bleed[playerid], "~r~BLEEDING");
            PlayerTextDrawSetString(playerid, BrokenL[playerid], "BROKEN LEG");
            PlayerTextDrawSetString(playerid, TOPOMENSAGEM[playerid], "~y~[ ! ]~r~ Infected Zone ~y~[ ! ]");
		}
	}
	return 1;
}

stock Translate(language, text_PT[], text_EN[]) 
{ 
    new string[256]; 
     
    if(language == 1) format(string, sizeof(string), text_PT); 
    else if(language == 2) format(string, sizeof(string), text_EN); 
         
    return string; 
}

stock RemovePlayerWeapon(playerid, weaponid)
{
    new
        plyWeapons[ 12 ], plyAmmo[ 12 ];

    for( new slot = 0; slot != 12; slot ++ )
    {
        new
            weap, ammo;
            
        GetPlayerWeaponData( playerid, slot, weap, ammo );
        if( weap != weaponid )
        {
            GetPlayerWeaponData( playerid, slot, plyWeapons[ slot ], plyAmmo[ slot ] );
        }
    }
    ResetPlayerWeapons( playerid );
    for( new slot = 0; slot != 12; slot ++ )
    {
        GivePlayerWeapon( playerid, plyWeapons[ slot ], plyAmmo[ slot ] );
    }
} 

stock IsABike(vehicleid)
{
    switch(GetVehicleModel(vehicleid))
    {
        case 481, 509, 510: return 1;
        default: return 0;
    }
    return -1;
}

stock GetClosestStoreFromPlayer(playerid, Float:range = 1.5)
{
    for(new i = 0; i < sizeof(MarketSpawns); i++)	
    {
    	if(IsPlayerInRangeOfPoint(playerid, range, MarketSpawns[i][mPosX], MarketSpawns[i][mPosY], MarketSpawns[i][mPosZ]))
    	{
    		return i;
    	}
    }
	return -1;
}

stock NearPump(playerid)
{
    for(new i = 0; i < sizeof(WaterPumps); i++)	
    {
    	if(IsPlayerInRangeOfPoint(playerid, 1.0, WaterPumps[i][0], WaterPumps[i][1], WaterPumps[i][2]))
    	{
    		return true;
    	}
    }
	return false;
}

stock NearGasStation(playerid)
{
    for(new i = 0; i < sizeof(GasStations); i++)	
    {
    	if(IsPlayerInRangeOfPoint(playerid, 10.0, GasStations[i][0], GasStations[i][1], GasStations[i][2]))
    	{
    		return true;
    	}
    }
	return false;
} 

stock GetClosestVehicle(playerid, Float:range)
{
	new Float:Pos[3];
    for(new i = 1, j = GetVehiclePoolSize(); i <= j; i++) // Loop nos ve�culos existentes
    {
        if(i != INVALID_VEHICLE_ID) // Se o ve�culo for diferente de um ve�culo invalido
        {
            GetVehiclePos(i, Pos[0], Pos[1], Pos[2]); // Pega a coordenada do ve�culo
            if(IsPlayerInRangeOfPoint(playerid, range, Pos[0], Pos[1], Pos[2])) // Verifica se o jogador est� na distancia do ve�culo
            {
                return i; // Retorna o ID do ve�culo
            }
        }
    }
    return INVALID_VEHICLE_ID; // Retorna Ve�culo Invalido
}  

stock GetClosestItemID(playerid, Float:range = 1.5)
{
	for(new i; i < MAX_DROPS; i++) 
	{
		if(IsPlayerInRangeOfPoint(playerid, range, DropInfo[i][dPosX], DropInfo[i][dPosY], DropInfo[i][dPosZ]))
		{
			return i;
		}
	}
	return -1;
}

stock Banir(playerid, adminname[], motivo[])
{
	new query[180], DBResult:result, ip[16], dia, mes, ano;
	GetPlayerIp(playerid, ip, sizeof(ip));
	getdate(ano, mes, dia);
	format(query, sizeof(query), "INSERT INTO `Banidos` (`Nome`,`Admin`,`Motivo`,`IP`,`Dia`,`Mes`,`Ano`) VALUES ('%s','%s','%s','%s','%i','%i','%i')", PegarNome(playerid), adminname, motivo, ip, dia, mes, ano);

	result = db_query(STA_DATA, query);
    db_free_result(result);

    printf("| BAN-INFO |: O Jogador(a) %s foi banido(a) pelo(a) Administrador(a) %s, motivo: %s", PegarNome(playerid), adminname, motivo);

    Kick(playerid);
	return 1;
}

stock SendLocalMessage(playerid, color, message[], Float:range)
{
	new Float:pos[3];
	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	foreach(new i : Player)
	{
		if(IsPlayerInRangeOfPoint(i, range, pos[0], pos[1], pos[2]))
		{
			SendClientMessage(i, color, message);
		}
	}
	return 1;
}

stock SendAdminMessage(message[], cor)
{
	foreach(new i : Player)
	{
		if(pInfo[i][pAdmin] > 0)
		{
			SendClientMessage(i, cor, message);
		}
	}
	return 1;
}

stock IsForbiddenWeapon(weaponid)
{
	switch(weaponid)
	{
		case 35..40,44,45: return true;
		default: return false;
	}
	return false;
}

stock PegarNome(playerid)
{ 
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, MAX_PLAYER_NAME);
	return name;
}

GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
	new Float:a;
	GetPlayerPos(playerid, x, y, a);
	GetPlayerFacingAngle(playerid, a);
	if (GetPlayerVehicleID(playerid))
	{
	    GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
	}
	x += (distance * floatsin(-a, degrees));
	y += (distance * floatcos(-a, degrees));
}

stock ConvertToDays(n)
{
    new t[5], String[75];

    t[4] = n-gettime();
    t[0] = t[4] / 3600;
    t[1] = ((t[4] / 60) - (t[0] * 60));
    t[2] = (t[4] - ((t[0] * 3600) + (t[1] * 60)));
    t[3] = (t[0]/24);

    if(t[3] > 0)
        t[0] = t[0] % 24,
        format(String, sizeof(String), "%d d, %02dh %02dm %02ds", t[3], t[0], t[1], t[2]);
    else if(t[0] > 0)
        format(String, sizeof(String), "%02dh %02dm %02ds", t[0], t[1], t[2]);
    else
        format(String, sizeof(String), "%02dm %02ds", t[1], t[2]);
    return String;
}

forward Float:frandom(Float:max, Float:min = 0.0, dp = 4);
Float:frandom(Float:max, Float:min = 0.0, dp = 4)
{
    new
        // Get the multiplication for storing fractional parts.
        Float:mul = floatpower(10.0, dp),
        // Get the max and min as integers, with extra dp.
        imin = floatround(min * mul),
        imax = floatround(max * mul);
    // Get a random int between two bounds and convert it to a float.
    return float(random(imax - imin) + imin) / mul;
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
	if(pInfo[playerid][pConectado] == false) return SendClientMessage(playerid, COR_VERMELHO, Translate(pInfo[playerid][pIdioma], "[ERRO]: Voce precisa estar logado para usar este comando.", "[ERROR]: You must be logged to use this command."));
    if(!success)
    {
    	SendClientMessage(playerid, COR_VERMELHO, Translate(pInfo[playerid][pIdioma], "[ERRO]: Comando Inv�lido.", "[ERROR]: Unknown Command."));
    }
    return 1;
}

//if defined FILTERSCRIPT // sistema de dano nas armas - bugado //
//define AkDano          60.0
//define M4Dano          40.5
//define ShotgunDano     60.0
//define SwanDano        0.0
//define SpasDano        40.5
//define MP5Dano         30.5
//define SniperDano      80.0

//public OnFilterScriptInit()
//{}

//public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid)
//{
//if(issuerid != INVALID_PLAYER_ID)
//{
   //new Float:DSVida;
   //GetPlayerHealth(playerid, DSVida);
   //if(weaponid == 30)
   //{
       // SetPlayerHealth(playerid, DSVida - AkDano);
  // }
   //if(weaponid == 31)
 //  {
        //SetPlayerHealth(playerid, DSVida - M4Dano);
  // }
   //if(weaponid == 25)
  // {
  //      SetPlayerHealth(playerid, DSVida - ShotgunDano);
  // }

   //if(weaponid == 27)
  // {
  //      SetPlayerHealth(playerid, DSVida - SpasDano);
  // }
   //if(weaponid == 29)
  // {
  //      SetPlayerHealth(playerid, DSVida - MP5Dano);
  // }
   //if(weaponid == 34)
  // {
 //       SetPlayerHealth(playerid, DSVida - SniperDano);
  // }
//}
//return 1;
//}
//endif
