// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '我的关卡库';

  @override
  String get about => '关于';

  @override
  String get back => '返回';

  @override
  String get refresh => '刷新';

  @override
  String get toggleTheme => '切换主题';

  @override
  String get switchFolder => '切换目录';

  @override
  String get clearCache => '释放缓存';

  @override
  String get uiSize => '界面大小';

  @override
  String get aboutSoftware => '关于软件';

  @override
  String get selectFolder => '选择文件夹';

  @override
  String get initSetup => '初始化设置';

  @override
  String get selectFolderPrompt => '请选择一个文件夹作为关卡存储目录。';

  @override
  String get selectFolderButton => '选择文件夹';

  @override
  String get emptyFolder => '文件夹为空';

  @override
  String get newFolder => '新建文件夹';

  @override
  String get newLevel => '新建关卡';

  @override
  String get rename => '重命名';

  @override
  String get delete => '删除';

  @override
  String get copy => '复制';

  @override
  String get move => '移动';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确定';

  @override
  String get create => '创建';

  @override
  String get newName => '新名称';

  @override
  String get folderName => '文件夹名称';

  @override
  String get confirmDelete => '确认删除';

  @override
  String confirmDeleteMessage(Object detail, Object name) {
    return '确定要删除 \"$name\" 吗？$detail';
  }

  @override
  String get folderDeleteDetail => '如果是文件夹，其内容也将被删除。';

  @override
  String get levelDeleteDetail => '此操作不可恢复。';

  @override
  String get confirmDeleteCheckbox => '我确定要永久删除';

  @override
  String get renameSuccess => '重命名成功';

  @override
  String get renameFail => '重命名失败，已有同名文件';

  @override
  String get deleted => '已删除';

  @override
  String get copyLevel => '复制关卡';

  @override
  String get newFileName => '新文件名';

  @override
  String get copySuccess => '复制成功';

  @override
  String get copyFail => '复制失败';

  @override
  String moving(Object name) {
    return '正在移动: $name';
  }

  @override
  String get movePrompt => '请导航至目标文件夹，然后点击粘贴';

  @override
  String get paste => '粘贴';

  @override
  String get folderCreated => '文件夹创建成功';

  @override
  String get createFail => '创建失败';

  @override
  String get noTemplates => '未找到模板';

  @override
  String get newLevelTemplate => '新建关卡 - 选择模板';

  @override
  String get nameLevel => '命名关卡';

  @override
  String get levelCreated => '创建成功';

  @override
  String get levelCreateFail => '创建失败，已有同名文件';

  @override
  String get adjustUiSize => '调整界面大小';

  @override
  String currentScale(Object percent) {
    return '当前缩放: $percent%';
  }

  @override
  String get small => '小';

  @override
  String get standard => '标准';

  @override
  String get large => '大';

  @override
  String get done => '完成';

  @override
  String get reset => '重置';

  @override
  String cacheCleared(Object count) {
    return '已清理 $count 个缓存文件';
  }

  @override
  String get returnUp => '返回上一级';

  @override
  String get jsonFile => 'JSON 文件';

  @override
  String get softwareIntro => '软件介绍';

  @override
  String get zEditor => 'Z-Editor';

  @override
  String get pvzEditorSubtitle => 'PVZ2 关卡可视化编辑器';

  @override
  String get introSection => '简介';

  @override
  String get introText => 'Z-Editor 是一款专为《植物大战僵尸2》设计的可视化关卡编辑工具。它旨在解决直接修改 JSON 文件繁琐、易错的问题，提供直观的图形界面来管理关卡配置。';

  @override
  String get featuresSection => '核心功能';

  @override
  String get feature1 => '模块化编辑：对关卡模块和事件进行模块化管理。';

  @override
  String get feature2 => '多模式支持：我是僵尸、砸罐子、坚不可摧、僵王战等。';

  @override
  String get feature3 => '自定义注入：在关卡内注入并管理自定义僵尸。';

  @override
  String get feature4 => '智能校验：检测模块依赖缺失、引用失效等问题。';

  @override
  String get usageSection => '使用说明';

  @override
  String get usageText => '1. 目录设置：首次进入请选择存放 JSON 关卡文件的目录。\n2. 导入/新建：点击列表项编辑现有关卡，或使用右下角按钮基于模板新建。\n3. 模块管理：在编辑器中可添加新模块。\n4. 保存关卡：编辑完成后点击保存，文件将回写到原 JSON。\n交流 QQ 群：562251204';

  @override
  String get creditsSection => '致谢名单';

  @override
  String get authorLabel => '软件作者：';

  @override
  String get authorName => '降维打击';

  @override
  String get thanksLabel => '特别鸣谢：';

  @override
  String get thanksNames => '星寻、metal海枣、超越自我3333、桃酱、凉沈、小小师、顾小言、PhiLia093、咖啡、不留名';

  @override
  String get tagline => '穿越时空 创造无穷可能';

  @override
  String version(Object version) {
    return '版本 $version';
  }

  @override
  String get language => '语言';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChinese => '中文';

  @override
  String get languageRussian => 'Русский';

  @override
  String get templateBlankLevel => '空白关卡';

  @override
  String get templateCardPickExample => '自选卡示例';

  @override
  String get templateConveyorExample => '传送带示例';

  @override
  String get templateLastStandExample => '坚不可摧示例';

  @override
  String get templateIZombieExample => '我是僵尸示例';

  @override
  String get templateVaseBreakerExample => '砸罐子示例';

  @override
  String get templateZombossExample => '僵王战示例';

  @override
  String get templateCustomZombieExample => '自定义僵尸示例';

  @override
  String get templateIPlantExample => '我是植物示例';

  @override
  String get unsavedChanges => '未保存的更改';

  @override
  String get saveBeforeLeaving => '离开前是否保存？';

  @override
  String get discard => '放弃';

  @override
  String get saved => '已保存';

  @override
  String get failedToLoadLevel => '加载关卡失败';

  @override
  String get noLevelDefinition => '未找到关卡定义';

  @override
  String get noLevelDefinitionHint => '当前关卡内未找到关卡定义模块 (LevelDefinition)，这是关卡文件的基础节点。请尝试手动添加。';

  @override
  String get levelBasicInfo => '关卡基本信息';

  @override
  String get levelBasicInfoSubtitle => '名称、序号、描述、地图背景';

  @override
  String get removeModule => '移除模块';

  @override
  String get zombieCategoryMain => 'By World';

  @override
  String get zombieCategorySize => 'By Size';

  @override
  String get zombieCategoryOther => 'Other';

  @override
  String get zombieCategoryCollection => 'My Collection';

  @override
  String get zombieTagAll => 'All Zombies';

  @override
  String get zombieTagEgyptPirate => 'Egypt/Pirate';

  @override
  String get zombieTagWestFuture => 'West/Future';

  @override
  String get zombieTagDarkBeach => 'Dark/Beach';

  @override
  String get zombieTagIceageLostcity => 'Ice Age/Lost City';

  @override
  String get zombieTagKongfuSkycity => 'Kongfu/Sky City';

  @override
  String get zombieTagEightiesDino => '80s/Dino';

  @override
  String get zombieTagModernPvz1 => 'Modern/Pvz1';

  @override
  String get zombieTagSteamRenai => 'Steam/Renaissance';

  @override
  String get zombieTagHenaiAtlantis => 'Heian/Atlantis';

  @override
  String get zombieTagTaleZCorp => 'Fairytale/ZCorp';

  @override
  String get zombieTagParkourSpeed => 'Parkour/Speed';

  @override
  String get zombieTagTothewest => 'Journey to West';

  @override
  String get zombieTagMemory => 'Memory Journey';

  @override
  String get zombieTagUniverse => 'Parallel Universe';

  @override
  String get zombieTagFestival1 => 'Festival 1';

  @override
  String get zombieTagFestival2 => 'Festival 2';

  @override
  String get zombieTagRoman => 'Roman';

  @override
  String get zombieTagPet => 'Pet';

  @override
  String get zombieTagImp => 'Imp';

  @override
  String get zombieTagBasic => 'Basic';

  @override
  String get zombieTagFat => 'Fat';

  @override
  String get zombieTagStrong => 'Strong';

  @override
  String get zombieTagGargantuar => 'Gargantuar';

  @override
  String get zombieTagElite => 'Elite';

  @override
  String get zombieTagEvildave => 'Evil Dave';

  @override
  String get plantCategoryQuality => 'By Quality';

  @override
  String get plantCategoryRole => 'By Role';

  @override
  String get plantCategoryAttribute => 'By Attribute';

  @override
  String get plantCategoryOther => 'Other';

  @override
  String get plantCategoryCollection => 'My Collection';

  @override
  String get plantTagAll => 'All Plants';

  @override
  String get plantTagWhite => 'White Quality';

  @override
  String get plantTagGreen => 'Green Quality';

  @override
  String get plantTagBlue => 'Blue Quality';

  @override
  String get plantTagPurple => 'Purple Quality';

  @override
  String get plantTagOrange => 'Orange Quality';

  @override
  String get plantTagAssist => 'Assist';

  @override
  String get plantTagRemote => 'Remote';

  @override
  String get plantTagProductor => 'Producer';

  @override
  String get plantTagDefence => 'Defense';

  @override
  String get plantTagVanguard => 'Vanguard';

  @override
  String get plantTagTrapper => 'Trapper';

  @override
  String get plantTagFire => 'Fire';

  @override
  String get plantTagIce => 'Ice';

  @override
  String get plantTagMagic => 'Magic';

  @override
  String get plantTagPoison => 'Poison';

  @override
  String get plantTagElectric => 'Electric';

  @override
  String get plantTagPhysics => 'Physics';

  @override
  String get plantTagOriginal => 'Original PvZ1';

  @override
  String get plantTagParallel => 'Parallel World';

  @override
  String get removeModuleConfirm => '确定要移除该模块吗？本地自定义模块(@CurrentLevel)及其关联数据将一并删除，不可恢复。';

  @override
  String get confirmRemove => '确认移除';

  @override
  String get addModule => '添加模块';

  @override
  String get settings => '设置';

  @override
  String get timeline => '波次时间线';

  @override
  String get iZombie => '我是僵尸';

  @override
  String get vaseBreaker => '砸罐子';

  @override
  String get zomboss => '僵王战';

  @override
  String get moveSourceSameAsDest => '源目录和目标目录相同';

  @override
  String get moveSuccess => '移动成功';

  @override
  String get moveFail => '移动失败';

  @override
  String get rootFolder => '根目录';

  @override
  String get createEmptyWave => '创建空波次容器';

  @override
  String get noWaveManager => '未找到波次管理器';

  @override
  String get noWaveManagerHint => '此关卡有波次管理模块但缺少 WaveManagerProperties 对象。';

  @override
  String get waveTimelineHint => '点击事件编辑，点击 + 添加事件。';

  @override
  String get waveTimelineHintDetail => '左滑波次可删除。';

  @override
  String get waveManagerSettings => '波次管理器设置';

  @override
  String get flagInterval => '旗帜间隔';

  @override
  String get noWaves => '暂无波次';

  @override
  String get addFirstWave => '添加第一个波次。';

  @override
  String get deleteWave => '删除';

  @override
  String deleteWaveConfirm(int count) {
    return '将移除此波次及其 $count 个事件。';
  }

  @override
  String get addEvent => '添加事件';

  @override
  String get emptyWave => '空波次';

  @override
  String get addWave => '添加波次';

  @override
  String get expectation => '期望';

  @override
  String get close => '关闭';

  @override
  String get editProperties => '编辑属性';

  @override
  String get deleteEntity => '删除实体';

  @override
  String get moduleEditorInProgress => '模块编辑器开发中';

  @override
  String get dataEmpty => '数据为空';

  @override
  String get saveSuccess => '保存成功';

  @override
  String get saveFail => '保存失败';

  @override
  String get confirmRemoveRef => '移除引用';

  @override
  String get confirmRemoveRefMessage => '确定要移除此引用吗？实体数据将保留直至所有引用被移除。';

  @override
  String get code => '代码';

  @override
  String get name => '名称';

  @override
  String get description => '描述';

  @override
  String get levelNumber => '关卡序号';

  @override
  String get startingSun => '初始阳光';

  @override
  String get stageModule => '关卡地图';

  @override
  String get musicType => '音乐类型';

  @override
  String get loot => '关卡默认掉落';

  @override
  String get victoryModule => '胜利结算方式';

  @override
  String get missingModules => '缺失模块';

  @override
  String get moduleConflict => '模块冲突';

  @override
  String get editableModules => '可用编辑模块';

  @override
  String get parameterModules => '默认参数模块';

  @override
  String get addNewModule => '添加新模块';

  @override
  String get selectStage => '选择地图';

  @override
  String get searchStage => '搜索地图名称或代号';

  @override
  String get noStageFound => '未找到相关地图';

  @override
  String get stageTypeAll => '全部地图';

  @override
  String get stageTypeMain => '主线世界';

  @override
  String get stageTypeExtra => '活动/秘境';

  @override
  String get stageTypeSeasons => '一代/季节';

  @override
  String get stageTypeSpecial => '小游戏';

  @override
  String get search => '搜索';

  @override
  String get disablePeavine => '禁用豆藤共生';

  @override
  String get disableArtifact => '禁用神器';

  @override
  String get selectPlant => '选择植物';

  @override
  String get searchPlant => '搜索植物';

  @override
  String get noPlantFound => '未找到植物';

  @override
  String noResultsFor(Object query) {
    return '没有关于“$query”的结果';
  }

  @override
  String get noModulesInCategory => '该分类下没有模块';

  @override
  String addEventForWave(int wave) {
    return '为第 $wave 波添加事件';
  }

  @override
  String get waveLabel => '波次';

  @override
  String get pointsLabel => '点数';

  @override
  String get noDynamicZombies => '没有动态僵尸';

  @override
  String get moduleTitle_WaveManagerModuleProperties => 'Wave Manager';

  @override
  String get moduleDesc_WaveManagerModuleProperties => 'Manage level wave events';

  @override
  String get moduleTitle_CustomLevelModuleProperties => 'Lawn Module';

  @override
  String get moduleDesc_CustomLevelModuleProperties => 'Enable custom lawn framework';

  @override
  String get moduleTitle_StandardLevelIntroProperties => 'Intro Animation';

  @override
  String get moduleDesc_StandardLevelIntroProperties => 'Camera pan at level start';

  @override
  String get moduleTitle_ZombiesAteYourBrainsProperties => 'Failure Condition';

  @override
  String get moduleDesc_ZombiesAteYourBrainsProperties => 'Zombie enters house condition';

  @override
  String get moduleTitle_ZombiesDeadWinConProperties => 'Death Drop';

  @override
  String get moduleDesc_ZombiesDeadWinConProperties => 'Required for level stability';

  @override
  String get moduleTitle_PennyClassroomModuleProperties => 'Plant Tier';

  @override
  String get moduleDesc_PennyClassroomModuleProperties => 'Global plant tier definition';

  @override
  String get moduleTitle_SeedBankProperties => 'Seed Bank';

  @override
  String get moduleDesc_SeedBankProperties => 'Preset plants and selection method';

  @override
  String get moduleTitle_ConveyorSeedBankProperties => 'Conveyor Belt';

  @override
  String get moduleDesc_ConveyorSeedBankProperties => 'Preset conveyor plants and weights';

  @override
  String get moduleTitle_SunDropperProperties => 'Sun Dropper';

  @override
  String get moduleDesc_SunDropperProperties => 'Control falling sun frequency';

  @override
  String get moduleTitle_LevelMutatorMaxSunProps => 'Max Sun';

  @override
  String get moduleDesc_LevelMutatorMaxSunProps => 'Override maximum sun limit';

  @override
  String get moduleTitle_LevelMutatorStartingPlantfoodProps => 'Starting Plant Food';

  @override
  String get moduleDesc_LevelMutatorStartingPlantfoodProps => 'Override initial plant food';

  @override
  String get moduleTitle_StarChallengeModuleProperties => 'Challenges';

  @override
  String get moduleDesc_StarChallengeModuleProperties => 'Level restrictions and goals';

  @override
  String get moduleTitle_LevelScoringModuleProperties => 'Scoring';

  @override
  String get moduleDesc_LevelScoringModuleProperties => 'Enable score points for kills';

  @override
  String get moduleTitle_BowlingMinigameProperties => 'Bowling Bulb';

  @override
  String get moduleDesc_BowlingMinigameProperties => 'Set line and disable shovel';

  @override
  String get moduleTitle_NewBowlingMinigameProperties => 'Wall-nut Bowling';

  @override
  String get moduleDesc_NewBowlingMinigameProperties => 'Bowling line setup';

  @override
  String get moduleTitle_VaseBreakerPresetProperties => 'Vase Layout';

  @override
  String get moduleDesc_VaseBreakerPresetProperties => 'Configure vase contents';

  @override
  String get moduleTitle_VaseBreakerArcadeModuleProperties => 'Vase Breaker Mode';

  @override
  String get moduleDesc_VaseBreakerArcadeModuleProperties => 'Enable vase breaker UI';

  @override
  String get moduleTitle_VaseBreakerFlowModuleProperties => 'Vase Animation';

  @override
  String get moduleDesc_VaseBreakerFlowModuleProperties => 'Control vase drop animation';

  @override
  String get moduleTitle_EvilDaveProperties => 'I, Zombie';

  @override
  String get moduleDesc_EvilDaveProperties => 'Enable I, Zombie mode';

  @override
  String get moduleTitle_ZombossBattleModuleProperties => 'Zomboss Battle';

  @override
  String get moduleDesc_ZombossBattleModuleProperties => 'Boss battle parameters';

  @override
  String get moduleTitle_ZombossBattleIntroProperties => 'Zomboss Intro';

  @override
  String get moduleDesc_ZombossBattleIntroProperties => 'Boss intro and health bar';

  @override
  String get moduleTitle_SeedRainProperties => 'Seed Rain';

  @override
  String get moduleDesc_SeedRainProperties => 'Falling plants/zombies/items';

  @override
  String get moduleTitle_LastStandMinigameProperties => 'Last Stand';

  @override
  String get moduleDesc_LastStandMinigameProperties => 'Initial resources and setup phase';

  @override
  String get moduleTitle_PVZ1OverwhelmModuleProperties => 'Overwhelm';

  @override
  String get moduleDesc_PVZ1OverwhelmModuleProperties => 'Overwhelm minigame';

  @override
  String get moduleTitle_SunBombChallengeProperties => 'Sun Bombs';

  @override
  String get moduleDesc_SunBombChallengeProperties => 'Falling sun bomb config';

  @override
  String get moduleTitle_IncreasedCostModuleProperties => 'Inflation';

  @override
  String get moduleDesc_IncreasedCostModuleProperties => 'Sun cost increases with planting';

  @override
  String get moduleTitle_DeathHoleModuleProperties => 'Death Holes';

  @override
  String get moduleDesc_DeathHoleModuleProperties => 'Plants leave unplantable holes';

  @override
  String get moduleTitle_ZombieMoveFastModuleProperties => 'Fast Entry';

  @override
  String get moduleDesc_ZombieMoveFastModuleProperties => 'Zombies move fast on entry';

  @override
  String get moduleTitle_InitialPlantEntryProperties => 'Initial Plants';

  @override
  String get moduleDesc_InitialPlantEntryProperties => 'Plants present at start';

  @override
  String get moduleTitle_InitialZombieProperties => 'Initial Zombies';

  @override
  String get moduleDesc_InitialZombieProperties => 'Zombies present at start';

  @override
  String get moduleTitle_InitialGridItemProperties => 'Initial Grid Items';

  @override
  String get moduleDesc_InitialGridItemProperties => 'Grid items present at start';

  @override
  String get moduleTitle_ProtectThePlantChallengeProperties => 'Protect Plants';

  @override
  String get moduleDesc_ProtectThePlantChallengeProperties => 'Plants that must be protected';

  @override
  String get moduleTitle_ProtectTheGridItemChallengeProperties => 'Protect Items';

  @override
  String get moduleDesc_ProtectTheGridItemChallengeProperties => 'Items that must be protected';

  @override
  String get moduleTitle_ZombiePotionModuleProperties => 'Zombie Potions';

  @override
  String get moduleDesc_ZombiePotionModuleProperties => 'Dark Ages potion generation';

  @override
  String get moduleTitle_PiratePlankProperties => 'Pirate Planks';

  @override
  String get moduleDesc_PiratePlankProperties => 'Pirate Seas plank rows';

  @override
  String get moduleTitle_RailcartProperties => 'Railcarts';

  @override
  String get moduleDesc_RailcartProperties => 'Minecart and track layout';

  @override
  String get moduleTitle_PowerTileProperties => 'Power Tiles';

  @override
  String get moduleDesc_PowerTileProperties => 'Future power tile layout';

  @override
  String get moduleTitle_ManholePipelineModuleProperties => 'Manholes';

  @override
  String get moduleDesc_ManholePipelineModuleProperties => 'Steam Age pipelines';

  @override
  String get moduleTitle_RoofProperties => 'Roof Pots';

  @override
  String get moduleDesc_RoofProperties => 'Roof level pot columns';

  @override
  String get moduleTitle_TideProperties => 'Tide System';

  @override
  String get moduleDesc_TideProperties => 'Enable tide system';

  @override
  String get moduleTitle_WarMistProperties => 'War Mist';

  @override
  String get moduleDesc_WarMistProperties => 'Fog of war system';

  @override
  String get moduleTitle_RainDarkProperties => 'Weather';

  @override
  String get moduleDesc_RainDarkProperties => 'Rain, snow, storm effects';

  @override
  String get eventTitle_SpawnZombiesFromGroundSpawnerProps => '地底出怪';

  @override
  String get eventDesc_SpawnZombiesFromGroundSpawnerProps => '从地下生成僵尸';

  @override
  String get eventTitle_SpawnZombiesJitteredWaveActionProps => '标准出怪';

  @override
  String get eventDesc_SpawnZombiesJitteredWaveActionProps => '基本自然出怪';

  @override
  String get eventTitle_FrostWindWaveActionProps => '霜冻风';

  @override
  String get eventDesc_FrostWindWaveActionProps => '行上的冰冻风';

  @override
  String get eventTitle_BeachStageEventZombieSpawnerProps => '低潮';

  @override
  String get eventDesc_BeachStageEventZombieSpawnerProps => '僵尸在低潮时出现';

  @override
  String get eventTitle_TidalChangeWaveActionProps => '潮汐变化';

  @override
  String get eventDesc_TidalChangeWaveActionProps => '改变潮位位置';

  @override
  String get eventTitle_ModifyConveyorWaveActionProps => '传送带修改';

  @override
  String get eventDesc_ModifyConveyorWaveActionProps => '动态添加/移除卡牌';

  @override
  String get eventTitle_DinoWaveActionProps => '恐龙召唤';

  @override
  String get eventDesc_DinoWaveActionProps => '在行上召唤恐龙';

  @override
  String get eventTitle_SpawnModernPortalsWaveActionProps => '时空裂隙';

  @override
  String get eventDesc_SpawnModernPortalsWaveActionProps => '生成时空裂隙';

  @override
  String get eventTitle_StormZombieSpawnerProps => '风暴出怪';

  @override
  String get eventDesc_StormZombieSpawnerProps => '沙尘暴或暴雪出怪';

  @override
  String get eventTitle_RaidingPartyZombieSpawnerProps => '海盗掠夺队';

  @override
  String get eventDesc_RaidingPartyZombieSpawnerProps => '海盗僵尸入侵';

  @override
  String get eventTitle_ZombiePotionActionProps => '药水掉落';

  @override
  String get eventDesc_ZombiePotionActionProps => '在网格上生成药水';

  @override
  String get eventTitle_SpawnGravestonesWaveActionProps => '墓碑生成';

  @override
  String get eventDesc_SpawnGravestonesWaveActionProps => '生成墓碑';

  @override
  String get eventTitle_SpawnZombiesFromGridItemSpawnerProps => '墓碑出怪';

  @override
  String get eventDesc_SpawnZombiesFromGridItemSpawnerProps => '从墓碑生成僵尸';

  @override
  String get eventTitle_FairyTaleFogWaveActionProps => '童话迷雾';

  @override
  String get eventDesc_FairyTaleFogWaveActionProps => '生成迷雾';

  @override
  String get eventTitle_FairyTaleWindWaveActionProps => '童话之风';

  @override
  String get eventDesc_FairyTaleWindWaveActionProps => '吹散迷雾';

  @override
  String get eventTitle_SpiderRainZombieSpawnerProps => '小鬼雨';

  @override
  String get eventDesc_SpiderRainZombieSpawnerProps => '小鬼从天而降';

  @override
  String get eventTitle_ParachuteRainZombieSpawnerProps => '降落伞雨';

  @override
  String get eventDesc_ParachuteRainZombieSpawnerProps => '僵尸带降落伞降落';

  @override
  String get eventTitle_BassRainZombieSpawnerProps => '低音/喷气背包雨';

  @override
  String get eventDesc_BassRainZombieSpawnerProps => '低音/喷气背包僵尸降落';

  @override
  String get eventTitle_BlackHoleWaveActionProps => '黑洞';

  @override
  String get eventDesc_BlackHoleWaveActionProps => '黑洞吸引植物';

  @override
  String get eventTitle_WaveActionMagicMirrorTeleportationArrayProps2 => '魔镜';

  @override
  String get eventDesc_WaveActionMagicMirrorTeleportationArrayProps2 => '镜子传送门';

  @override
  String get weatherOption_DefaultSnow_label => 'Frostbite Caves (DefaultSnow)';

  @override
  String get weatherOption_DefaultSnow_desc => 'Snowing effect from Frostbite Caves';

  @override
  String get weatherOption_LightningRain_label => 'Thunderstorm (LightningRain)';

  @override
  String get weatherOption_LightningRain_desc => 'Rain and lightning from Dark Ages Day 8';

  @override
  String get weatherOption_DefaultRainDark_label => 'Dark Ages (DefaultRainDark)';

  @override
  String get weatherOption_DefaultRainDark_desc => 'Rain effect from Dark Ages';

  @override
  String get iZombiePlantReserveLabel => '植物预留列（PlantDistance）';

  @override
  String get column => '列';

  @override
  String get iZombieInfoText => '在“我是僵尸”模式下，需在关卡模块（预设植物）和种子库中配置预设植物与僵尸。';

  @override
  String get vaseRangeTitle => '花瓶生成范围与黑名单';

  @override
  String get startColumnLabel => '起始列（最小）';

  @override
  String get endColumnLabel => '结束列（最大）';

  @override
  String get toggleBlacklistHint => '点击切换黑名单';

  @override
  String get vaseCapacityTitle => '花瓶容量';

  @override
  String vaseCapacitySummary(Object current, Object total) {
    return '已分配：$current / 总槽位：$total';
  }

  @override
  String get vaseListTitle => '花瓶列表';

  @override
  String get addVaseTitle => '添加花瓶';

  @override
  String get plantVaseOption => '植物花瓶';

  @override
  String get zombieVaseOption => '僵尸花瓶';

  @override
  String get selectZombie => '选择僵尸';

  @override
  String get searchZombie => '搜索僵尸';

  @override
  String get noZombieFound => '未找到僵尸';

  @override
  String get unknownVaseLabel => '未知花瓶';

  @override
  String get plantLabel => '植物';

  @override
  String get zombieLabel => '僵尸';

  @override
  String get itemLabel => '物品';

  @override
  String get railcartSettings => '矿车轨道设置';

  @override
  String get railcartType => '矿车类型';

  @override
  String get layRails => '铺设轨道';

  @override
  String get placeCarts => '放置矿车';

  @override
  String get railSegments => '轨道段数';

  @override
  String get railcartCount => '矿车数量';

  @override
  String get clearAll => '清空所有配置';
}
