/* Const macros */
#define B2OP_VER "4.11"
#define DEPRECATION 5304
#define VER_ANCIENT 353
#define VER_MODERN 1824
#define VER_2905 2905
#define VER_3K 3042
#define VER_4K 4516
#define NET_FRAME_SOLO 100
#define NET_FRAME_COOP 50
#define MAX_VALID_HEALTH 1044606905
#define LUI_ROUND_PULSE_TIMES_MIN 2
#define LUI_ROUND_MAX 100
#define LUI_ROUND_PULSE_TIMES_DELTA 5
#define LUI_PULSE_DURATION 500
#define LUI_FIRST_ROUND_DURATION 1000
#define STAT_TURBINE "turbine"
#define STAT_SPRINGPAD "springpad_zm"
#define STAT_SUBWOOFER "subwoofer_zm"
#define BOXTRACKER_KEY_JOKER "joker"
#define BOXTRACKER_KEY_TOTAL "total"
#define WEAPON_NAME_MK1 "ray_gun_zm"
#define WEAPON_NAME_MK2 "raygun_mark2_zm"
#define WEAPON_NAME_MONK "cymbal_monkey_zm"
#define WEAPON_NAME_EMP "emp_grenade_zm"
#define RNG_ROUND 11
#define COL_BLACK "^0"
#define COL_RED "^1"
#define COL_GREEN "^2"
#define COL_YELLOW "^3"
#define COL_BLUE "^4"
#define COL_LIGHT_BLUE "^5"
#define COL_PURPLE "^6"
#define COL_WHITE "^7"
#define COL_VARIABLE "^8"
#define COL_GREY "^9"
#define TXT_AVAILABLE COL_GREEN + "AVAILABLE" + COL_WHITE
#define TXT_DISABLED COL_RED + "DISABLED" + COL_WHITE
#define SPLITS_FILE "b2op/splits.txt"
#define LOCATION_CAFE "cafe"
#define LOCATION_WARDEN "warden"
#define STAT_CHAR_MAP "zm_highrise"
#define STAT_CHAR_VICTIS "clip"
#define STAT_CHAR_PRISON "stock"
#define STAT_CHAR_TOMB "alt_clip"
#define STAT_CHAR_SURVIVAL "lh_clip"
#define STAT_RETICLE_MAP "zm_tomb"
#define STAT_RETICLE "stock"
#define STAT_CAMO_MAP "zm_tomb"
#define STAT_CAMO "alt_clip"
#define STAT_KEY_MAP "zm_prison"
#define STAT_KEY "clip"
#define WATERMARK_SLOT_PERM 0
#define WATERMARK_SLOT_TEMP 1
#define SLOT_ARRAY array(0, -90, 90, -180, 180, -270, 270, -360, 360, -450, 450, -540, 540, -630, 630)
#define G_LOG_BOXOPEN "O"
#define G_LOG_LOADOUT "L"
#define G_LOG_BOX "B"
#define DVAR_INIT_ONLY 1
#define DVAR_PROTECT 2
#define DVAR_PROTECT_LOWER 4
#define DVAR_PROTECT_HIGHER 8
#define DVAR_CLIENT 16

/* B2 flags */
#define F_FRIDGE_LOCKED 1
#define F_FIRSTBOX_LOCKED 2
#define F_BOXLOCATION_LOCKED 4

/* Feature flags */
#define FEATURE_HUD 1
#define FEATURE_PERMAPERKS 1
#define FEATURE_FIRSTBOX 1
#define FEATURE_BOX_LOCATION 1
#define FEATURE_FRIDGE 1
#define FEATURE_HORDES 0
#define FEATURE_SPH 0
#define FEATURE_CHARACTERS 1
#define FEATURE_BOXTRACKER 1
#define FEATURE_CONNECTOR 0
#define FEATURE_MOB_KEY 1
#define FEATURE_ORIGINS_TANK_DEPATCH 1
#define FEATURE_ANIMATED_CAMOS 1
#define FEATURE_TOMAHAWK_STATE 1
#define FEATURE_BOXTRACKER_INTEGRATION 1

/* Snippet macros */
#define LEVEL_ENDON \
    level endon("end_game");
#define PLAYER_ENDON \
    LEVEL_ENDON \
    self endon("disconnect");

/* Function macros */
#define COLOR_TXT(__txt, __color) __color + __txt + COL_WHITE
#define CLEAR(__var) __var = undefined;
#define MS_TO_SECONDS(__ms) int(__ms / 1000)
#define STR(__val) "" + (__val)
#if PLUTO == 1 && DEBUG == 1
#define DEBUG_PRINT(__txt) printf("DEBUG [" + convert_time() + "]: ^5" + __txt + "^7");
#elif DEBUG == 1
#define DEBUG_PRINT(__txt) iprintln("DEBUG: ^5" + __txt);
#else
#define DEBUG_PRINT(__txt)
#endif
