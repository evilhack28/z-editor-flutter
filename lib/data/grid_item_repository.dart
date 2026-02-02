/// Grid item info. Ported from Z-Editor-master GridItemRepository.kt
class GridItemInfo {
  const GridItemInfo({
    required this.typeName,
    required this.name,
    required this.category,
    this.icon,
  });

  final String typeName;
  final String name;
  final GridItemCategory category;
  /// Icon filename in assets/images/griditems/ (e.g. 'gravestone_egypt.png').
  /// Null = use placeholder icon.
  final String? icon;
}

enum GridItemCategory {
  all('All'),
  scene('Scene'),
  trap('Trap'),
  plants('Plants');

  const GridItemCategory(this.label);
  final String label;
}

/// Grid item repository. Icons from assets/images/griditems/.
/// Items without matching icon use placeholder.
class GridItemRepository {
  GridItemRepository._();

  static final List<GridItemInfo> staticItems = [
    GridItemInfo(typeName: 'gravestone_egypt', name: 'Egypt gravestone', category: GridItemCategory.scene, icon: 'gravestone_egypt.png'),
    GridItemInfo(typeName: 'gravestone_dark', name: 'Dark gravestone', category: GridItemCategory.scene, icon: 'gravestone_dark.png'),
    GridItemInfo(typeName: 'gravestoneZombieOnDestruction', name: 'Zombie gravestone', category: GridItemCategory.scene, icon: 'gravestone_dark.png'),
    GridItemInfo(typeName: 'gravestonePlantfoodOnDestruction', name: 'Plant food gravestone', category: GridItemCategory.scene, icon: 'gravestonePlantfoodOnDestruction.png'),
    GridItemInfo(typeName: 'gravestoneSunOnDestruction', name: 'Sun gravestone', category: GridItemCategory.scene, icon: 'gravestoneSunOnDestruction.png'),
    GridItemInfo(typeName: 'gravestone_battlez_sun', name: 'BattleZ sun gravestone', category: GridItemCategory.scene, icon: 'gravestoneSunOnDestruction.png'),
    GridItemInfo(typeName: 'heian_box_sun', name: 'Heian sun box', category: GridItemCategory.scene, icon: 'heian_box_sun.png'),
    GridItemInfo(typeName: 'heian_box_plantfood', name: 'Heian plant food box', category: GridItemCategory.scene, icon: 'heian_box_plantfood.png'),
    GridItemInfo(typeName: 'heian_box_levelup', name: 'Heian levelup box', category: GridItemCategory.scene, icon: 'heian_box_levelup.png'),
    GridItemInfo(typeName: 'heian_box_seedpacket', name: 'Heian seed box', category: GridItemCategory.scene, icon: 'heian_box_seedpacket.png'),
    GridItemInfo(typeName: 'goldtile', name: 'Gold tile', category: GridItemCategory.scene, icon: 'goldtile.png'),
    GridItemInfo(typeName: 'fake_mold', name: 'Fake mold', category: GridItemCategory.scene, icon: 'fake_mold.png'),
    GridItemInfo(typeName: 'printer_small_paper', name: 'Paper scraps', category: GridItemCategory.scene),
    GridItemInfo(typeName: 'pvz1grid', name: 'PVZ1 gravestone', category: GridItemCategory.scene),
    GridItemInfo(typeName: 'score_2x_tile', name: '2x score tile', category: GridItemCategory.scene),
    GridItemInfo(typeName: 'score_3x_tile', name: '3x score tile', category: GridItemCategory.scene),
    GridItemInfo(typeName: 'score_5x_tile', name: '5x score tile', category: GridItemCategory.scene),
    GridItemInfo(typeName: 'zombiepotion_speed', name: 'Speed potion', category: GridItemCategory.trap, icon: 'zombiepotion_speed.png'),
    GridItemInfo(typeName: 'zombiepotion_toughness', name: 'Toughness potion', category: GridItemCategory.trap, icon: 'zombiepotion_toughness.png'),
    GridItemInfo(typeName: 'zombiepotion_invisible', name: 'Invisible potion', category: GridItemCategory.trap, icon: 'zombiepotion_invisible.png'),
    GridItemInfo(typeName: 'zombiepotion_poison', name: 'Poison potion', category: GridItemCategory.trap, icon: 'zombiepotion_poison.png'),
    GridItemInfo(typeName: 'boulder_trap_falling_forward', name: 'Boulder trap', category: GridItemCategory.trap, icon: 'boulder_trap_falling_forward.png'),
    GridItemInfo(typeName: 'flame_spreader_trap', name: 'Flame trap', category: GridItemCategory.trap, icon: 'flame_spreader_trap.png'),
    GridItemInfo(typeName: 'bufftile_shield', name: 'Shield tile', category: GridItemCategory.trap, icon: 'bufftile_shield.png'),
    GridItemInfo(typeName: 'bufftile_speed', name: 'Speed tile', category: GridItemCategory.trap, icon: 'bufftile_speed.png'),
    GridItemInfo(typeName: 'bufftile_attack', name: 'Attack tile', category: GridItemCategory.trap, icon: 'bufftile_attack.png'),
    GridItemInfo(typeName: 'zombie_bound_tile', name: 'Zombie springboard', category: GridItemCategory.trap, icon: 'zombie_bound_tile.png'),
    GridItemInfo(typeName: 'zombie_changer', name: 'Zombie changer', category: GridItemCategory.trap, icon: 'zombie_changer.png'),
    GridItemInfo(typeName: 'slider_up', name: 'Slider up', category: GridItemCategory.trap, icon: 'slider_up.png'),
    GridItemInfo(typeName: 'slider_down', name: 'Slider down', category: GridItemCategory.trap, icon: 'slider_down.png'),
    GridItemInfo(typeName: 'slider_up_modern', name: 'Modern slider up', category: GridItemCategory.trap, icon: 'slider_up_modern.png'),
    GridItemInfo(typeName: 'slider_down_modern', name: 'Modern slider down', category: GridItemCategory.trap, icon: 'slider_down_modern.png'),
    GridItemInfo(typeName: 'steam_up', name: 'Steam up', category: GridItemCategory.trap, icon: 'steam_up.png'),
    GridItemInfo(typeName: 'steam_down', name: 'Steam down', category: GridItemCategory.trap, icon: 'steam_down.png'),
    GridItemInfo(typeName: 'magic_mirror', name: 'Magic mirror', category: GridItemCategory.trap, icon: 'magic_mirror.png'),
    GridItemInfo(typeName: 'magic_mirror1', name: 'Magic mirror 1', category: GridItemCategory.trap, icon: 'magic_mirror1.png'),
    GridItemInfo(typeName: 'magic_mirror2', name: 'Magic mirror 2', category: GridItemCategory.trap, icon: 'magic_mirror2.png'),
    GridItemInfo(typeName: 'magic_mirror3', name: 'Magic mirror 3', category: GridItemCategory.trap, icon: 'magic_mirror3.png'),
    GridItemInfo(typeName: 'christmas_protect', name: 'Christmas protect', category: GridItemCategory.trap),
    GridItemInfo(typeName: 'dumpling', name: 'Dumpling', category: GridItemCategory.trap),
    GridItemInfo(typeName: 'turkey', name: 'Turkey', category: GridItemCategory.trap),
    GridItemInfo(typeName: 'tangyuan', name: 'Tangyuan', category: GridItemCategory.trap),
    GridItemInfo(typeName: 'lilypad', name: 'Lily pad', category: GridItemCategory.plants, icon: 'lilypad.jpg'),
    GridItemInfo(typeName: 'flowerpot', name: 'Flower pot', category: GridItemCategory.plants),
    GridItemInfo(typeName: 'FrozenIcebloom', name: 'Frozen ice bloom', category: GridItemCategory.plants),
    GridItemInfo(typeName: 'FrozenChillyPepper', name: 'Frozen chilly pepper', category: GridItemCategory.plants),
    GridItemInfo(typeName: 'cavalrygun', name: 'Cavalry gun', category: GridItemCategory.plants),
    GridItemInfo(typeName: 'surfboard', name: 'Surfboard', category: GridItemCategory.plants),
    GridItemInfo(typeName: 'backpack', name: 'Backpack', category: GridItemCategory.plants),
    GridItemInfo(typeName: 'eightiesarcadecabinet', name: 'Arcade cabinet', category: GridItemCategory.plants),
    GridItemInfo(typeName: 'gridItem_sushi', name: 'Sushi', category: GridItemCategory.plants),
    GridItemInfo(typeName: 'dinoegg_zomshell', name: 'Dino egg imp', category: GridItemCategory.plants),
    GridItemInfo(typeName: 'dinoegg_ptero', name: 'Dino egg ptero', category: GridItemCategory.plants),
    GridItemInfo(typeName: 'dinoegg_bronto', name: 'Dino egg bronto', category: GridItemCategory.plants),
    GridItemInfo(typeName: 'dinoegg_tyranno', name: 'Dino egg tyranno', category: GridItemCategory.plants),
    GridItemInfo(typeName: 'lollipops', name: 'Lollipops', category: GridItemCategory.plants),
    GridItemInfo(typeName: 'gliding', name: 'Gliding wreck', category: GridItemCategory.plants),
    GridItemInfo(typeName: 'heavy_shield', name: 'Heavy shield', category: GridItemCategory.plants),
  ];

  static List<GridItemInfo> get allItems => staticItems;

  static List<GridItemInfo> getByCategory(GridItemCategory category) {
    if (category == GridItemCategory.all) return allItems;
    return allItems.where((i) => i.category == category).toList();
  }

  static String getName(String aliases) {
    final typeName = aliases == 'gravestone' ? 'gravestone_egypt' : aliases;
    for (final i in allItems) {
      if (i.typeName == typeName) return i.name;
    }
    return typeName;
  }

  /// Returns asset path for icon, or null if no icon (use placeholder).
  static String? getIconPath(String aliases) {
    final typeName = aliases == 'gravestone' ? 'gravestone_egypt' : aliases;
    for (final i in allItems) {
      if (i.typeName == typeName && i.icon != null) {
        return 'assets/images/griditems/${i.icon}';
      }
    }
    return null;
  }

  static bool isValid(String typeName) {
    return allItems.any((i) => i.typeName == typeName);
  }

  static String buildGridAliases(String id) {
    if (id == 'gravestone_egypt') return 'gravestone';
    return id;
  }

  static List<GridItemInfo> search(String query) {
    if (query.trim().isEmpty) return allItems;
    return allItems
        .where((i) =>
            i.name.toLowerCase().contains(query.toLowerCase()) ||
            i.typeName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
