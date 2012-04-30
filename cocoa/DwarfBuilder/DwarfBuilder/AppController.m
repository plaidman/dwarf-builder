
#import "AppController.h"
#import "DwarfBuilderSettings.h"

@implementation AppController

@synthesize settings;
@synthesize fileManager;
@synthesize baseAppDir;

-(id)init {
    self = [super init];
    
    if (self) {
        settings = [[DwarfBuilderSettings alloc] init];
        fileManager = [NSFileManager defaultManager];
#ifdef DEBUG
        //baseAppDir = @"/Users/jtomsic/Downloads/dwarf-builder";
        baseAppDir = @"/Users/jrtomsic/devel/dwarf-builder";
#else
        //set path to bundle path
#endif
    }
    
    return self;
}

-(IBAction)constructAction:(id)sender {
    [self constructDwarfFortress];
}

/* * * * * * * * * * * * *
 * -- HELPER FUNCTIONS -- 
 * * * * * * * * * * * * */

-(NSString*)boolToInit:(bool)optionValue optionName:(NSString*)optionName {
    if (optionValue) return [NSString stringWithFormat:@"[%@:YES]", optionName];
    else return [NSString stringWithFormat:@"[%@:NO]", optionName];
}

-(NSString*)intToInit:(int)optionValue optionName:(NSString*)optionName {
    return [NSString stringWithFormat:@"[%@:%d]", optionName, optionValue];
}

-(NSString*)stringToInit:(NSString*)optionValue optionName:(NSString*)optionName {
    return [NSString stringWithFormat:@"[%@:%@]", optionName, optionValue];
}

-(NSString*)embarkToInit:(NSString*)width height:(NSString*)height {
    return [NSString stringWithFormat:@"[EMBARK_RECTANGLE:%@:%@]", width, height];
}

-(NSString*)childToInit:(NSString*)hard percentage:(NSString*)percentage {
    return [NSString stringWithFormat:@"[BABY_CHILD_CAP:%@:%@]", hard, percentage];
}

-(NSString*)autosaveToInit:(int)option {
    if (option == asSeasonal) return @"[AUTOSAVE:SEASONAL]";
    if (option == asYearly) return @"[AUTOSAVE:YEARLY]";
    return @"[AUTOSAVE:NONE]";
}

-(NSString*)idlersToInit:(int)option {
    if (option == siTop) return @"[IDLERS:TOP]";
    if (option == siBottom) return @"[IDLERS:BOTTOM]";
    return @"[IDLERS:OFF]";
}

-(void)linuxCPFromPath:(NSString*)fromPath toPath:(NSString*)toPath {
    NSEnumerator *itemReader = [fileManager enumeratorAtPath:fromPath];
    NSString *item, *pathFromItem, *pathToItem, *itemType;
    
    while (item = [itemReader nextObject]) {
        pathFromItem = [NSString stringWithFormat:@"%@/%@", fromPath, item];
        pathToItem = [NSString stringWithFormat:@"%@/%@", toPath, item];
        itemType = [[fileManager attributesOfItemAtPath:pathFromItem error:nil] valueForKey:NSFileType];
        
        if ([NSFileTypeDirectory isEqualToString:itemType]) {
            [fileManager createDirectoryAtPath:pathToItem withIntermediateDirectories:true attributes:nil error:nil];
        } else {
            if ([fileManager fileExistsAtPath:pathToItem]) {
                [fileManager removeItemAtPath:pathToItem error:nil];
            }
            
            [fileManager copyItemAtPath:pathFromItem toPath:pathToItem error:nil];
        }
    }
}

-(void)translateTextFile:(NSString*)textFile changes:(NSDictionary*)changes {
    NSMutableString *fileContents = [NSMutableString stringWithContentsOfFile:textFile
        encoding:NSISOLatin1StringEncoding error:nil];
    
    NSEnumerator *changeKeys = [changes keyEnumerator];
    NSString *changeKey;
    NSRegularExpression *regex;
    
    while (changeKey = [changeKeys nextObject]) {
        regex = [NSRegularExpression regularExpressionWithPattern:changeKey options:0 error:nil];
        [regex replaceMatchesInString:fileContents options:0 range:NSMakeRange(0, [fileContents length])
            withTemplate:[changes valueForKey:changeKey]];
    }
    
    [fileContents writeToFile:textFile atomically:true encoding:NSISOLatin1StringEncoding error:nil];
}

-(void)translateKeybinds:(NSMutableString*)fileContents bindLabel:(NSString*)bindLabel fromKey:(NSString*)fromKey toKey:(NSString*)toKey {
    NSRange keysRange;
    NSString *bindLabelRegex = [NSString stringWithFormat:@"\\[BIND:%@\\]", bindLabel];
    NSString *fromKeyRegex = [NSString stringWithFormat:@"\\[KEY:%@\\]", fromKey];
    NSString *toKeyTag = [NSString stringWithFormat:@"[KEY:%@]", toKey];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:bindLabelRegex options:0 error:nil];
    NSRange range = [regex rangeOfFirstMatchInString:fileContents options:0 range:NSMakeRange(0, [fileContents length])];
    keysRange.location = range.location;
    range.location += 6;
    range.length = [fileContents length] - range.location;
    
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\[BIND" options:0 error:nil];
    range = [regex rangeOfFirstMatchInString:fileContents options:0 range:range];
    keysRange.length = range.location - keysRange.location;
    
    regex = [NSRegularExpression regularExpressionWithPattern:fromKeyRegex options:0 error:nil];
    [regex replaceMatchesInString:fileContents options:0 range:keysRange withTemplate:toKeyTag];
}

-(void)addExtraShellItem:(NSMutableString *)fileContents shellItem:(NSString *)shellItem {
    NSString *shellItemRegex = [NSString stringWithFormat:@"\\[MATERIAL_TEMPLATE:%@\\]", shellItem];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:shellItemRegex options:0 error:nil];
    NSRange range = [regex rangeOfFirstMatchInString:fileContents
        options:0 range:NSMakeRange(0, [fileContents length])];
    range.length = [fileContents length] - range.location;
    
    regex = [NSRegularExpression regularExpressionWithPattern:@"^\\s*$" options:NSRegularExpressionAnchorsMatchLines error:nil];
    range = [regex rangeOfFirstMatchInString:fileContents options:NSRegularExpressionAnchorsMatchLines range:range];
    
    [fileContents insertString:@"\t[SHELL]\r\n" atIndex:range.location];
}

/* * * * * * * * * * * * * * * *
 * -- CONSTRUCTION FUNCTIONS --
 * * * * * * * * * * * * * * * */

-(void)constructDwarfFortress {
    [self copyVanilla];
//    [self copyTileset];
//    [self processInitTxt];
//    [self processDInitTxt];
//    [self removeAquifers];
//    [self removeGrazing];
//    [self disablePausingWarmDampStone];
//    [self disablePausingCaveIns];
//    [self updateKeybinds];
//    [self disableSkillRusting];
//    [self addExtraShellItems];
//    [self copySoundtrack];
//    [self copyFont];
//    [self addWorldGens];
//    [self copyEmbarkProfiles];
    [self setupDwarfFortressApp];
}

-(void)copyVanilla {
    NSString *vanillaFolder = [NSString stringWithFormat:@"%@/vanilla", baseAppDir];
    NSString *buildFolder = [NSString stringWithFormat:@"%@/build", baseAppDir];
    
    [fileManager removeItemAtPath:buildFolder error:nil];
    [fileManager copyItemAtPath:vanillaFolder toPath:buildFolder error:nil];
    
    NSString *dfScriptFile = [NSString stringWithFormat:@"%@/%@", buildFolder, @"df"];
    
    NSDictionary *changes = [NSDictionary dictionaryWithObjectsAndKeys:
        @"dwarfort.exe& > stdout.txt 2> stderr.txt", @"dwarfort\\.exe", nil];
    
    [self translateTextFile:dfScriptFile changes:changes];
}

-(void)copyTileset {
    NSString *buildDataFolder = [NSMutableString stringWithFormat:@"%@/build/data", baseAppDir];
    NSString *buildRawFolder = [NSMutableString stringWithFormat:@"%@/build/raw", baseAppDir];
    
    if ([settings tileset] == tsIronhand) {
        NSString *tilesetDataFolder = [NSString stringWithFormat:@"%@/ironhand/data", baseAppDir];
        NSString *tilesetRawFolder = [NSString stringWithFormat:@"%@/ironhand/raw", baseAppDir];
        
        [self linuxCPFromPath:tilesetDataFolder toPath:buildDataFolder];
        [self linuxCPFromPath:tilesetRawFolder toPath:buildRawFolder];
    } else if ([settings tileset] == tsPhoebus) {
        NSString *tilesetDataFolder = [NSString stringWithFormat:@"%@/phoebus/data", baseAppDir];
        NSString *tilesetRawFolder = [NSString stringWithFormat:@"%@/phoebus/raw", baseAppDir];
        
        [self linuxCPFromPath:tilesetDataFolder toPath:buildDataFolder];
        [self linuxCPFromPath:tilesetRawFolder toPath:buildRawFolder];
    } else if ([settings tileset] == tsJollyTall) {
        NSString *tilesetDataFolder = [NSString stringWithFormat:@"%@/jolly/9x12 (recommended)/data", baseAppDir];
        NSString *tilesetRawFolder = [NSString stringWithFormat:@"%@/jolly/9x12 (recommended)/raw", baseAppDir];
        
        [self linuxCPFromPath:tilesetDataFolder toPath:buildDataFolder];
        [self linuxCPFromPath:tilesetRawFolder toPath:buildRawFolder];
    } else if ([settings tileset] == tsJollySquare) {
        NSString *tilesetDataFolder = [NSString stringWithFormat:@"%@/jolly/12x12/data", baseAppDir];
        NSString *tilesetRawFolder = [NSString stringWithFormat:@"%@/jolly/12x12/raw", baseAppDir];
        
        [self linuxCPFromPath:tilesetDataFolder toPath:buildDataFolder];
        [self linuxCPFromPath:tilesetRawFolder toPath:buildRawFolder];
    } else if ([settings tileset] == tsMayday) {
        NSString *tilesetDataFolder = [NSString stringWithFormat:@"%@/mayday/data", baseAppDir];
        NSString *tilesetRawFolder = [NSString stringWithFormat:@"%@/mayday/raw", baseAppDir];
        
        [self linuxCPFromPath:tilesetDataFolder toPath:buildDataFolder];
        [self linuxCPFromPath:tilesetRawFolder toPath:buildRawFolder];
    } else if ([settings tileset] == tsDefaultTall) {
        NSString *initTxtFile = [NSString stringWithFormat:@"%@/build/data/init/init.txt", baseAppDir];
        NSDictionary *changes = [NSDictionary dictionaryWithObjectsAndKeys:
            [self stringToInit:@"curses_square_16x16.png" optionName:@"FONT"], @"\\[FONT:.*\\]",
            [self stringToInit:@"curses_square_16x16.png" optionName:@"FULLFONT"], @"\\[FULLFONT:.*\\]",
            [self stringToInit:@"curses_square_16x16.png" optionName:@"GRAPHICS_FULLFONT"], @"\\[GRAPHICS_FULLFONT:.*\\]",
            [self stringToInit:@"curses_square_16x16.png" optionName:@"GRAPHICS_FULLFONT"], @"\\[GRAPHICS_FULLFONT:.*\\]",
            nil];
        
        [self translateTextFile:initTxtFile changes:changes];
    } else if ([settings tileset] == tsDefaultSquare) {
        NSString *initTxtFile = [NSString stringWithFormat:@"%@/build/data/init/init.txt", baseAppDir];
        NSDictionary *changes = [NSDictionary dictionaryWithObjectsAndKeys:
            [self stringToInit:@"curses_800x600.png" optionName:@"FONT"], @"\\[FONT:.*\\]",
            [self stringToInit:@"curses_800x600.png" optionName:@"FULLFONT"], @"\\[FULLFONT:.*\\]",
            [self stringToInit:@"curses_800x600.png" optionName:@"GRAPHICS_FULLFONT"], @"\\[GRAPHICS_FULLFONT:.*\\]",
            [self stringToInit:@"curses_800x600.png" optionName:@"GRAPHICS_FULLFONT"], @"\\[GRAPHICS_FULLFONT:.*\\]",
            nil];
        
        [self translateTextFile:initTxtFile changes:changes];
    }
}

-(void)processInitTxt {
    NSString *initTxtFile = [NSString stringWithFormat:@"%@/build/data/init/init.txt", baseAppDir];
    NSDictionary *changes = [NSDictionary dictionaryWithObjectsAndKeys:
        [self boolToInit:[settings enableSound] optionName:@"SOUND"], @"\\[SOUND:.*\\]",
        [self intToInit:[settings volume] optionName:@"VOLUME"], @"\\[VOLUME:.*\\]",
        [self boolToInit:[settings showIntro] optionName:@"INTRO"], @"\\[INTRO:.*\\]",
        [self boolToInit:![settings fullscreen] optionName:@"WINDOWED"], @"\\[WINDOWED:.*\\]",
        [self boolToInit:[settings resizable] optionName:@"RESIZABLE"], @"\\[RESIZABLE:.*\\]",
        [self stringToInit:[settings windowWidth] optionName:@"WINDOWEDX"], @"\\[WINDOWEDX:.*\\]",
        [self stringToInit:[settings windowHeight] optionName:@"WINDOWEDY"], @"\\[WINDOWEDY:.*\\]",
        [self stringToInit:[settings windowWidth] optionName:@"GRAPHICS_WINDOWEDX"], @"\\[GRAPHICS_WINDOWEDX:.*\\]",
        [self stringToInit:[settings windowHeight] optionName:@"GRAPHICS_WINDOWEDY"], @"\\[GRAPHICS_WINDOWEDY:.*\\]",
        [self boolToInit:[settings creatureGraphics] optionName:@"GRAPHICS"], @"\\[GRAPHICS:.*\\]",
        [self boolToInit:[settings useFont] optionName:@"TRUETYPE"], @"\\[TRUETYPE:.*\\]",
        [self boolToInit:[settings showFPS] optionName:@"FPS"], @"\\[FPS:.*\\]",
        [self stringToInit:[settings cFPSCap] optionName:@"FPS_CAP"], @"\\[FPS_CAP:.*\\]",
        [self stringToInit:[settings gFPSCap] optionName:@"G_FPS_CAP"], @"\\[G_FPS_CAP:.*\\]",
        [self boolToInit:[settings compressSaves] optionName:@"COMPRESSED_SAVES"], @"\\[COMPRESSED_SAVES:.*\\]",
        nil];
    
    [self translateTextFile:initTxtFile changes:changes];
}

-(void)processDInitTxt {
    NSString *dInitTxtFile = [NSString stringWithFormat:@"%@/build/data/init/d_init.txt", baseAppDir];
    NSDictionary *changes = [NSDictionary dictionaryWithObjectsAndKeys:
        [self autosaveToInit:[settings autosave]], @"\\[AUTOSAVE:.*\\]",
        [self boolToInit:[settings autoBackupSaves] optionName:@"AUTOBACKUP"], @"\\[AUTOBACKUP:.*\\]",
        [self boolToInit:[settings pauseOnSave] optionName:@"AUTOSAVE_PAUSE"], @"\\[AUTOSAVE_PAUSE:.*\\]",
        [self boolToInit:[settings pauseOnLoad] optionName:@"PAUSE_ON_LOAD"], @"\\[PAUSE_ON_LOAD:.*\\]",
        [self boolToInit:[settings temperature] optionName:@"TEMPERATURE"], @"\\[TEMPERATURE:.*\\]",
        [self boolToInit:[settings weather] optionName:@"WEATHER"], @"\\[WEATHER:.*\\]",
        [self boolToInit:[settings invaders] optionName:@"INVADERS"], @"\\[INVADERS:.*\\]",
        [self boolToInit:[settings caveIns] optionName:@"CAVEINS"], @"\\[CAVEINS:.*\\]",
        [self embarkToInit:[settings embarkWidth] height:[settings embarkHeight]], @"\\[EMBARK_RECTANGLE:.*\\]",
        [self idlersToInit:[settings showIdlers]], @"\\[IDLERS:.*\\]",
        [self stringToInit:[settings dwarfCap] optionName:@"POPULATION_CAP"], @"\\[POPULATION_CAP:.*\\]",
        [self childToInit:[settings childHardCap] percentage:[settings childPercentageCap]], @"\\[BABY_CHILD_CAP:.*\\]",
        [self boolToInit:[settings liquidDepth] optionName:@"SHOW_FLOW_AMOUNTS"], @"\\[SHOW_FLOW_AMOUNTS:.*\\]",
        [self boolToInit:[settings embarkConfirmation] optionName:@"EMBARK_WARNING_ALWAYS"],
        @"\\[EMBARK_WARNING_ALWAYS:.*\\]", nil];
    
    [self translateTextFile:dInitTxtFile changes:changes];
}

-(void)removeAquifers {
    if (![settings aquifers]) {
        NSString *rawObjectsPath = [NSString stringWithFormat:@"%@/build/raw/objects", baseAppDir];
        NSEnumerator *itemReader = [fileManager enumeratorAtPath:rawObjectsPath];
        NSString *item, *fullItemPath, *itemType;
        NSDictionary *changes = [NSDictionary dictionaryWithObjectsAndKeys:@"(AQUIFER)", @"\\[AQUIFER\\]", nil];
    
        while (item = [itemReader nextObject]) {
            fullItemPath = [NSString stringWithFormat:@"%@/%@", rawObjectsPath, item];
            itemType = [[fileManager attributesOfItemAtPath:fullItemPath error:nil] valueForKey:NSFileType];
        
            if ([itemType isEqualToString:NSFileTypeRegular]) {
                if ([[item lastPathComponent] hasPrefix:@"inorganic_stone_"]) {
                    [self translateTextFile:fullItemPath changes:changes];
                }
            }
        }
    }
}

-(void)removeGrazing {
    if (![settings grazingAnimals]) {
        NSString *rawObjectsPath = [NSString stringWithFormat:@"%@/build/raw/objects", baseAppDir];
        NSEnumerator *itemReader = [fileManager enumeratorAtPath:rawObjectsPath];
        NSString *item, *fullItemPath, *itemType;
        NSDictionary *changes = [NSDictionary dictionaryWithObjectsAndKeys:@"(GRAZER:$1)", @"\\[GRAZER:(.*)\\]", nil];

        while (item = [itemReader nextObject]) {
            fullItemPath = [NSString stringWithFormat:@"%@/%@", rawObjectsPath, item];
            itemType = [[fileManager attributesOfItemAtPath:fullItemPath error:nil] valueForKey:NSFileType];
            
            if ([itemType isEqualToString:NSFileTypeRegular] && [[item lastPathComponent] hasPrefix:@"creature_"]) {
                [self translateTextFile:fullItemPath changes:changes];
            }
        }
    }
}

-(void)disablePausingWarmDampStone {
    if (![settings pauseOnWarmDampStone]) {
        NSString *initTxtFile = [NSString stringWithFormat:@"%@/build/data/init/announcements.txt", baseAppDir];
        NSDictionary *changes = [NSDictionary dictionaryWithObjectsAndKeys:
            @"[DIG_CANCEL_WARM:A_D:D_D]", @"\\[DIG_CANCEL_WARM:.*\\]",
            @"[DIG_CANCEL_DAMP:A_D:D_D]", @"\\[DIG_CANCEL_DAMP:.*\\]", nil];

        [self translateTextFile:initTxtFile changes:changes];
    }
};

-(void)disablePausingCaveIns {
    if (![settings pauseOnCaveIns]) {
        NSString *initTxtFile = [NSString stringWithFormat:@"%@/build/data/init/announcements.txt", baseAppDir];
        NSDictionary *changes = [NSDictionary dictionaryWithObjectsAndKeys:
            @"[CAVE_COLLAPSE:A_D:D_D]", @"\\[CAVE_COLLAPSE:.*\\]", nil];
        
        [self translateTextFile:initTxtFile changes:changes];
    }
};

-(void)updateKeybinds {
    if ([settings keybindings] == kbLaptop) {
        NSString *keybindFile = [NSString stringWithFormat:@"%@/build/data/init/interface.txt", baseAppDir];
        NSMutableString *fileContents = [NSMutableString stringWithContentsOfFile:keybindFile
            encoding:NSISOLatin1StringEncoding error:nil];
        
        [self translateKeybinds:fileContents bindLabel:@"SECONDSCROLL_DOWN:REPEAT_SLOW"
            fromKey:@"\\+" toKey:@"="];
        [self translateKeybinds:fileContents bindLabel:@"SECONDSCROLL_PAGEUP:REPEAT_SLOW"
            fromKey:@"/" toKey:@"_"];
        [self translateKeybinds:fileContents bindLabel:@"SECONDSCROLL_PAGEDOWN:REPEAT_SLOW"
            fromKey:@"\\*" toKey:@"+"];
        [self translateKeybinds:fileContents bindLabel:@"D_MILITARY_SUPPLIES_WATER_UP:REPEAT_NOT"
            fromKey:@"\\+" toKey:@"="];
        [self translateKeybinds:fileContents bindLabel:@"D_MILITARY_SUPPLIES_FOOD_DOWN:REPEAT_NOT"
            fromKey:@"/" toKey:@"_"];
        [self translateKeybinds:fileContents bindLabel:@"D_MILITARY_SUPPLIES_FOOD_UP:REPEAT_NOT"
            fromKey:@"\\*" toKey:@"+"];
        [self translateKeybinds:fileContents bindLabel:@"D_MILITARY_AMMUNITION_RAISE_AMOUNT:REPEAT_NOT"
            fromKey:@"\\+" toKey:@"="];
        [self translateKeybinds:fileContents bindLabel:@"D_MILITARY_AMMUNITION_LOWER_AMOUNT_LOTS:REPEAT_NOT"
            fromKey:@"/" toKey:@"_"];
        [self translateKeybinds:fileContents bindLabel:@"D_MILITARY_AMMUNITION_RAISE_AMOUNT_LOTS:REPEAT_NOT"
            fromKey:@"\\*" toKey:@"+"];
        
        [fileContents writeToFile:keybindFile atomically:true encoding:NSISOLatin1StringEncoding error:nil];
    }
}

-(void)disableSkillRusting {
    if (![settings skillRusting]) {
        NSString *dwarfCreatureFile = [NSString stringWithFormat:@"%@/build/raw/objects/creature_standard.txt", baseAppDir];
        NSString *rustProofFile = [NSString stringWithFormat:@"%@/extras/rust_proof.txt", baseAppDir];
        
        NSMutableString *dwarfFileContents = [NSMutableString stringWithContentsOfFile:dwarfCreatureFile
            encoding:NSISOLatin1StringEncoding error:nil];
        NSString *rustFileContents = [NSMutableString stringWithContentsOfFile:rustProofFile
            encoding:NSISOLatin1StringEncoding error:nil];
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[CREATURE:DWARF\\]"
            options:0 error:nil];
        NSRange range = [regex rangeOfFirstMatchInString:dwarfFileContents 
            options:0 range:NSMakeRange(0, [dwarfFileContents length])];
        range.length = [dwarfFileContents length] - range.location;
        
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\s*\\[PHYS_ATT_RANGE:" options:0 error:nil];
        range = [regex rangeOfFirstMatchInString:dwarfFileContents options:0 range:range];
        
        [dwarfFileContents insertString:rustFileContents atIndex:range.location];
        [dwarfFileContents writeToFile:dwarfCreatureFile atomically:true encoding:NSISOLatin1StringEncoding error:nil];
    }
}

-(void)addExtraShellItems {
    if ([settings extraShellItems]) {
        NSString *materialFile = [NSString stringWithFormat:@"%@/build/raw/objects/material_template_default.txt", baseAppDir];
        NSMutableString *materialFileContents = [NSMutableString stringWithContentsOfFile:materialFile
            encoding:NSISOLatin1StringEncoding error:nil];
        
        [self addExtraShellItem:materialFileContents shellItem:@"SCALE_TEMPLATE"];
        [self addExtraShellItem:materialFileContents shellItem:@"HORN_TEMPLATE"];
        [self addExtraShellItem:materialFileContents shellItem:@"HOOF_TEMPLATE"];
        [self addExtraShellItem:materialFileContents shellItem:@"CHITIN_TEMPLATE"];

        [materialFileContents writeToFile:materialFile atomically:true encoding:NSISOLatin1StringEncoding error:nil];
    }
}

-(void)copySoundtrack {
    if ([settings extendSoundtk]) {
        NSString *pathFromItem = [NSString stringWithFormat:@"%@/extras/extended.ogg", baseAppDir];
        NSString *pathToItem = [NSString stringWithFormat:@"%@/build/data/sound/song_game.ogg", baseAppDir];
    
        [fileManager removeItemAtPath:pathToItem error:nil];
        [fileManager copyItemAtPath:pathFromItem toPath:pathToItem error:nil];
    }
}

-(void)copyFont {
    NSString *pathFromItem = [NSString stringWithFormat:@"%@/extras/default.ttf", baseAppDir];
    NSString *pathToItem = [NSMutableString stringWithFormat:@"%@/build/data/art/font.ttf", baseAppDir];
    
    if ([settings font] == fIronhand) {
        pathFromItem = [NSString stringWithFormat:@"%@/extras/ironhand.ttf", baseAppDir];
    } else if ([settings font] == fPhoebus) {
        pathFromItem = [NSString stringWithFormat:@"%@/extras/phoebus.ttf", baseAppDir];
    } else if ([settings font] == fTuffy) {
        pathFromItem = [NSString stringWithFormat:@"%@/extras/tuffy.ttf", baseAppDir];
    } else if ([settings font] == fMasterwork) {
        pathFromItem = [NSString stringWithFormat:@"%@/extras/masterwork.ttf", baseAppDir];
    }
    
    [fileManager removeItemAtPath:pathToItem error:nil];
    [fileManager copyItemAtPath:pathFromItem toPath:pathToItem error:nil];
}

-(void)addWorldGens {
    NSString *worldGenFile = [NSString stringWithFormat:@"%@/build/data/init/world_gen.txt", baseAppDir];
    NSString *extraWorldGenFile = [NSString stringWithFormat:@"%@/extras/extra_world_gen.txt", baseAppDir];
    
    NSMutableString *worldGenFileContents = [NSMutableString stringWithContentsOfFile:worldGenFile
        encoding:NSISOLatin1StringEncoding error:nil];
    NSString *extraWorldGenFileContents = [NSString stringWithContentsOfFile:extraWorldGenFile
        encoding:NSISOLatin1StringEncoding error:nil];
    
    [worldGenFileContents appendString:extraWorldGenFileContents];
    
    [worldGenFileContents writeToFile:worldGenFile atomically:true encoding:NSISOLatin1StringEncoding error:nil];
}

-(void)copyEmbarkProfiles {
    NSString *pathFromItem = [NSString stringWithFormat:@"%@/extras/embark_profiles.txt", baseAppDir];
    NSString *pathToItem = [NSMutableString stringWithFormat:@"%@/build/data/init/embark_profiles.txt", baseAppDir];
    
    [fileManager removeItemAtPath:pathToItem error:nil];
    [fileManager copyItemAtPath:pathFromItem toPath:pathToItem error:nil];
}

-(void)setupDwarfFortressApp {
    
}

@end
