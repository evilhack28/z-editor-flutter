import 'package:z_editor/data/repository/reference_repository.dart';

/// Grid item info. Ported from Z-Editor-master GridItemRepository.kt
/// For display use ResourceNames.lookup(context, 'griditem_$typeName').
enum GridItemFilterMode { all, restricted }

enum GridItemTag { normal, special }

class GridItemInfo {
  const GridItemInfo({
    required this.typeName,
    required this.name,
    required this.category,
    this.icon,
    this.tag = GridItemTag.normal,
  });

  final String typeName;
  final String name;
  final GridItemCategory category;
  /// Icon filename in assets/images/griditems/ (e.g. 'gravestone_egypt.webp').
  /// Null = use placeholder icon.
  final String? icon;
  final GridItemTag tag;
}

enum GridItemCategory {
  all('全部物品'),
  scene('场景布置'),
  trap('互动陷阱'),
  plants('生成物品');

  const GridItemCategory(this.label);
  final String label;
}

/// Grid item repository. Icons from assets/images/griditems/.
/// Items without matching icon use placeholder.
/// For localized display use getLocalizedName(context, typeName) via ResourceNames.
class GridItemRepository {
  GridItemRepository._();

  static final List<GridItemInfo> staticItems = [
    const GridItemInfo(typeName: 'gravestone_egypt', name: '埃及墓碑', category: GridItemCategory.scene, icon: 'gravestone_egypt.webp'),
    const GridItemInfo(typeName: 'gravestone_dark', name: '黑暗墓碑', category: GridItemCategory.scene, icon: 'gravestone_dark.webp'),
    const GridItemInfo(typeName: 'gravestoneZombieOnDestruction', name: '僵尸墓碑', category: GridItemCategory.scene, icon: 'gravestone_dark.webp'),
    const GridItemInfo(typeName: 'gravestonePlantfoodOnDestruction', name: '能量豆墓碑', category: GridItemCategory.scene, icon: 'gravestonePlantfoodOnDestruction.webp'),
    const GridItemInfo(typeName: 'gravestoneSunOnDestruction', name: '阳光墓碑', category: GridItemCategory.scene, icon: 'gravestoneSunOnDestruction.webp'),
    const GridItemInfo(typeName: 'gravestone_battlez_sun', name: '联赛大阳光墓碑', category: GridItemCategory.scene, icon: 'gravestoneSunOnDestruction.webp'),
    const GridItemInfo(typeName: 'heian_box_sun', name: '阳光赛钱箱', category: GridItemCategory.scene, icon: 'heian_box_sun.webp'),
    const GridItemInfo(typeName: 'heian_box_plantfood', name: '能量豆赛钱箱', category: GridItemCategory.scene, icon: 'heian_box_plantfood.webp'),
    const GridItemInfo(typeName: 'heian_box_levelup', name: '升级赛钱箱', category: GridItemCategory.scene, icon: 'heian_box_levelup.webp'),
    const GridItemInfo(typeName: 'heian_box_seedpacket', name: '种子赛钱箱', category: GridItemCategory.scene, icon: 'heian_box_seedpacket.webp'),
    const GridItemInfo(typeName: 'goldtile', name: '黄金地砖', category: GridItemCategory.scene, icon: 'goldtile.webp', tag: GridItemTag.special),
    const GridItemInfo(typeName: 'fake_mold', name: '霉菌地面', category: GridItemCategory.scene, icon: 'fake_mold.webp', tag: GridItemTag.special),
    const GridItemInfo(typeName: 'printer_small_paper', name: '纸屑', category: GridItemCategory.scene),
    const GridItemInfo(typeName: 'pvz1grid', name: '回忆锤僵尸墓碑', category: GridItemCategory.scene),
    const GridItemInfo(typeName: 'score_2x_tile', name: '联赛2倍分数砖', category: GridItemCategory.scene),
    const GridItemInfo(typeName: 'score_3x_tile', name: '联赛3倍分数砖', category: GridItemCategory.scene),
    const GridItemInfo(typeName: 'score_5x_tile', name: '联赛5倍分数砖', category: GridItemCategory.scene),
    const GridItemInfo(typeName: 'zombiepotion_speed', name: '疾速药水', category: GridItemCategory.trap, icon: 'zombiepotion_speed.webp'),
    const GridItemInfo(typeName: 'zombiepotion_toughness', name: '坚韧药水', category: GridItemCategory.trap, icon: 'zombiepotion_toughness.webp'),
    const GridItemInfo(typeName: 'zombiepotion_invisible', name: '隐身药水', category: GridItemCategory.trap, icon: 'zombiepotion_invisible.webp'),
    const GridItemInfo(typeName: 'zombiepotion_poison', name: '剧毒药水', category: GridItemCategory.trap, icon: 'zombiepotion_poison.webp'),
    const GridItemInfo(typeName: 'boulder_trap_falling_forward', name: '滚石陷阱', category: GridItemCategory.trap, icon: 'boulder_trap_falling_forward.webp'),
    const GridItemInfo(typeName: 'flame_spreader_trap', name: '火焰陷阱', category: GridItemCategory.trap, icon: 'flame_spreader_trap.webp'),
    const GridItemInfo(typeName: 'bufftile_shield', name: '护盾瓷砖', category: GridItemCategory.trap, icon: 'bufftile_shield.webp'),
    const GridItemInfo(typeName: 'bufftile_speed', name: '疾速瓷砖', category: GridItemCategory.trap, icon: 'bufftile_speed.webp'),
    const GridItemInfo(typeName: 'bufftile_attack', name: '攻击瓷砖', category: GridItemCategory.trap, icon: 'bufftile_attack.webp'),
    const GridItemInfo(typeName: 'zombie_bound_tile', name: '僵尸跳板', category: GridItemCategory.trap, icon: 'zombie_bound_tile.webp'),
    const GridItemInfo(typeName: 'zombie_changer', name: '僵尸改造机', category: GridItemCategory.trap, icon: 'zombie_changer.webp'),
    const GridItemInfo(typeName: 'slider_up', name: '上行冰河浮冰', category: GridItemCategory.trap, icon: 'slider_up.webp'),
    const GridItemInfo(typeName: 'slider_down', name: '下行冰河浮冰', category: GridItemCategory.trap, icon: 'slider_down.webp'),
    const GridItemInfo(typeName: 'slider_up_modern', name: '上行摩登浮标', category: GridItemCategory.trap, icon: 'slider_up_modern.webp'),
    const GridItemInfo(typeName: 'slider_down_modern', name: '下行摩登浮标', category: GridItemCategory.trap, icon: 'slider_down_modern.webp'),
    const GridItemInfo(typeName: 'christmas_protect', name: '元宝', category: GridItemCategory.trap, tag: GridItemTag.special),
    const GridItemInfo(typeName: 'dumpling', name: '饺子', category: GridItemCategory.trap),
    const GridItemInfo(typeName: 'turkey', name: '火鸡', category: GridItemCategory.trap),
    const GridItemInfo(typeName: 'tangyuan', name: '汤圆', category: GridItemCategory.trap),
    const GridItemInfo(typeName: 'lilypad', name: '莲叶', category: GridItemCategory.plants),
    const GridItemInfo(typeName: 'flowerpot', name: '花盆', category: GridItemCategory.plants),
    const GridItemInfo(typeName: 'FrozenIcebloom', name: '寒冰蓓蕾', category: GridItemCategory.plants, tag: GridItemTag.special),
    const GridItemInfo(typeName: 'FrozenChillyPepper', name: '寒冰辣椒', category: GridItemCategory.plants, tag: GridItemTag.special),
    const GridItemInfo(typeName: 'cavalrygun', name: '骑兵长枪', category: GridItemCategory.plants),
    const GridItemInfo(typeName: 'surfboard', name: '冲浪板', category: GridItemCategory.plants),
    const GridItemInfo(typeName: 'backpack', name: '冒险家背包', category: GridItemCategory.plants),
    const GridItemInfo(typeName: 'eightiesarcadecabinet', name: '街机', category: GridItemCategory.plants),
    const GridItemInfo(typeName: 'gridItem_sushi', name: '寿司', category: GridItemCategory.plants),
    const GridItemInfo(typeName: 'dinoegg_zomshell', name: '恐龙蛋-小鬼', category: GridItemCategory.plants),
    const GridItemInfo(typeName: 'dinoegg_ptero', name: '恐龙蛋-翼龙', category: GridItemCategory.plants),
    const GridItemInfo(typeName: 'dinoegg_bronto', name: '恐龙蛋-雷龙', category: GridItemCategory.plants),
    const GridItemInfo(typeName: 'dinoegg_tyranno', name: '恐龙蛋-霸王龙', category: GridItemCategory.plants),
    const GridItemInfo(typeName: 'lollipops', name: '棒棒糖', category: GridItemCategory.plants),
    const GridItemInfo(typeName: 'gliding', name: '飞行器残骸', category: GridItemCategory.plants),
    const GridItemInfo(typeName: 'heavy_shield', name: '近卫重盾', category: GridItemCategory.plants),
  ];

  static List<GridItemInfo> get allItems => staticItems;

  static List<GridItemInfo> getByCategory(GridItemCategory category) {
    if (category == GridItemCategory.all) return allItems;
    return allItems.where((i) => i.category == category).toList();
  }

  static List<GridItemInfo> getAll() => allItems;

  static String getName(String aliases) {
    final typeName = aliases == 'gravestone' ? 'gravestone_egypt' : aliases;
    try {
      final item = allItems.firstWhere((i) => i.typeName == typeName);
      return item.name;
    } catch (_) {
      return typeName;
    }
  }

  /// Returns asset path for icon, or unknown placeholder if no icon.
  static String getIconPath(String aliases) {
    final typeName = aliases == 'gravestone' ? 'gravestone_egypt' : aliases;
    try {
      final item = allItems.firstWhere((i) => i.typeName == typeName);
      final icon = item.icon;
      return icon != null
          ? 'assets/images/griditems/$icon'
          : 'assets/images/others/unknown.webp';
    } catch (_) {
      return 'assets/images/others/unknown.webp';
    }
  }

  static bool isValid(String typeName) {
    if (allItems.any((i) => i.typeName == typeName)) return true;
    return ReferenceRepository.instance.isValidGridItem(typeName);
  }

  static String buildGridAliases(String id) {
    if (id == 'gravestone_egypt') return 'gravestone';
    return id;
  }

  static List<GridItemInfo> search(String query) {
    if (query.trim().isEmpty) return allItems;
    final lower = query.toLowerCase();
    return allItems
        .where((i) =>
            i.name.toLowerCase().contains(lower) ||
            i.typeName.toLowerCase().contains(lower))
        .toList();
  }
}
