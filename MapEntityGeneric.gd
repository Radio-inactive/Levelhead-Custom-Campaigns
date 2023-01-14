## Defines important enums used by map entities. Map entity nodes inherit from this
extends Node2D

# Important enums
enum t_types {LEVEL = 0, ICON_PACK = 1, PATH_SHAPE_ASSIST = 2, PRESENTATION = 3}
enum gr17_present {GR17_NOT_PRESENT = 0, GR17_PRESENT = 1}
enum bug_pieces_present {BUG_PIECES_NOT_PRESENT = 0, BUG_PIECES_PRESENT = 1}
enum pre_all_previous_completed {DONT_REQUIRE_ALL_PREVIOUS_LEVELS = 0, REQUIRE_ALL_PREVIOUS_LEVELS = 1}
enum pre_all_bug_pieces{PREVIOUS_BUG_PIECES_NOT_REQUIRED = 0, PREVIOUS_BUG_PIECES_REQUIRED = 1}
enum pre_coin_all {PREVIOUS_JEMS_NOT_REQUIRED = 0, ALL_PREVIOUS_JEMS_REQUIRED = 1}
enum pre_chall_all {PREVIOUS_GR17S_NOT_REQUIRED = 0, PREVIOUS_GR17S_REQUIRED = 1}
enum has_weather {NO_WEATHER = 0, WEATHER = 1}
enum on_main_path {NOT_ON_MAIN_PATH = 0, ON_MAIN_PATH = 1}
enum bm_biome {TREE_OF_MAARLA = 0, KISTOON_RUINS = 1, AQUADUNES = 2, ASTEROID_TUNNELS = 3}
# short string names used for biomes, used by animation
const biome_names := ["maarla", "kistoon", "aquadunes", "asteroid"]
enum sc_hidden {VISIBLE_BEFORE_UNLOCKED = 0, HIDDEN_UNTIL_UNLOCKED = 1}
enum scpre_hidden {PREVIOUS_PATHS_VISIBLE_BEFORE_UNLOCKED = 0, PREVIOUS_PATHS_HIDDEN_UNTIL_UNLOCKED = 1}
enum scpost_hidden {FOLLOWING_PATHS_VISIBLE_BEFORE_UNLOCKED = 0, FOLLOWING_PATHS_HIDDEN_UNTIL_UNLOCKED = 1}
