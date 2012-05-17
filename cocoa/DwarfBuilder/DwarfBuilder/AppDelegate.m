// if an app is already compiled, give the user the option to start the app or recompile
// test manual raw transfer from 7 to 8
// test raw update with mac-copy from 7 to 8
// test raw update with linux-cp from 7 to 8
// external backup dir
// account for symlinks in update raws, backup df dir, restore df dir

#import "AppDelegate.h"
#import "DwarfBuilderSettings.h"
#import "RegexKitLite.h"

@implementation AppDelegate

@synthesize window = _window;

@synthesize settings;
@synthesize fileManager;
@synthesize aboutWindow;
@synthesize settingsFile, dbResources, installDirString;

-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return true;
}

-(void)applicationWillTerminate:(NSNotification *)notification {
    [settings writeSettingsToFile:settingsFile];
}

-(id)init {
    self = [super init];
    
    if (self) {
        settings = [[DwarfBuilderSettings alloc] init];
        fileManager = [NSFileManager defaultManager];
        
#ifdef DEBUG
//        dbResources = @"/Users/jtomsic/Downloads/dwarf-builder";
        dbResources = @"/Users/jrtomsic/devel/dwarf-builder";
        [self updateInstallDir:dbResources];
#else
        dbResources = [NSString stringWithFormat:@"%@/Contents/Resources", [[NSBundle mainBundle] bundlePath]];
        [self updateInstallDir:[[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent]];
#endif
        settingsFile = [NSString stringWithFormat:@"%@/settings.plist", dbResources];

        if ([fileManager fileExistsAtPath:settingsFile]) {
            [settings readSettingsFromFile:settingsFile];
        }
    }
    
    return self;
}


/* * * * * * * * * * * * * * *
 *  -- INTERFACE FUNCTIONS --
 * * * * * * * * * * * * * * */

-(IBAction)constructDFAction:(id)sender {
    @try {
        [self copyVanilla];
        [self copyTileset];
        [self processInitTxt];
        [self processDInitTxt];
        [self removeAquifers];
        [self removeGrazing];
        [self disablePausingWarmDampStone];
        [self disablePausingCaveIns];
        [self updateKeybinds];
        [self disableSkillRusting];
        [self addExtraShellItems];
        [self copySoundtrack];
        [self copyFont];
        [self copyColors];
        [self addWorldGens];
        [self copyEmbarkProfiles];
        [self setupDwarfFortressApp];
    }
    @catch (NSException *exception) {
        [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/build", dbResources] error:nil];
        [self errorDialog:[exception name] message:[exception reason]];
    }
}

-(IBAction)constructDTAction:(id)sender {
    NSString *pathFromApp = [NSString stringWithFormat:@"%@/extras/shells/DwarfTherapist.app", dbResources];
    NSString *pathToApp = [NSString stringWithFormat:@"%@/DwarfTherapist.app", [settings installDir]];
    NSString *pathFromMemDir = [NSString stringWithFormat:@"%@/extras/memory_layouts/osx", dbResources];
    NSString *pathToMemDir = [NSString stringWithFormat:@"%@/Contents/MacOS/etc/memory_layouts/osx", pathToApp];
    
    if (![fileManager fileExistsAtPath:pathToMemDir]) {
        [fileManager removeItemAtPath:pathToApp error:nil];
        [fileManager copyItemAtPath:pathFromApp toPath:pathToApp error:nil];
    }
    
    [fileManager removeItemAtPath:pathToMemDir error:nil];
    [fileManager copyItemAtPath:pathFromMemDir toPath:pathToMemDir error:nil];
}

-(IBAction)constructSSAction:(id)sender {
    NSString *pathFromApp = [NSString stringWithFormat:@"%@/extras/shells/SoundSense.app", dbResources];
    NSString *pathToApp = [NSString stringWithFormat:@"%@/SoundSense.app", [settings installDir]];
    NSString *pathFromResources = [NSString stringWithFormat:@"%@/soundsense", dbResources];
    NSString *pathToResources = [NSString stringWithFormat:@"%@/Contents/Resources", pathToApp];
    
    NSString *configurationFile = [NSString stringWithFormat:@"%@/configuration.xml", pathToResources];
    NSDictionary *changes = [NSDictionary dictionaryWithObjectsAndKeys:@"<gamelog path=\"../../../DwarfFortress.app/Contents/Resources/gamelog.txt\" />", @"<gamelog path=\".*\" />", nil];
    
    @try {
        if ([fileManager fileExistsAtPath:pathToApp]) {
            if (![self confirmDialog:@"SoundSense.app detected."
                    message:@"Would you like me to overwrite it?\nYou may lose your downloaded audio files."]) {
                return;
            }
        }
    
        [fileManager removeItemAtPath:pathToApp error:nil];
        [fileManager copyItemAtPath:pathFromApp toPath:pathToApp error:nil];
        [fileManager removeItemAtPath:pathToResources error:nil];
        [fileManager copyItemAtPath:pathFromResources toPath:pathToResources error:nil];
    
        [self translateTextFile:configurationFile changes:changes];
        
        [[NSWorkspace sharedWorkspace] setIcon:[[NSImage alloc]
            initByReferencingFile:[NSString stringWithFormat:@"%@/%@", dbResources, @"SoundSense.png"]]
            forFile:pathToApp options:0];
    }
    @catch (NSException *exception) {
        [fileManager removeItemAtPath:pathToApp error:nil];
        [self errorDialog:[exception name] message:[exception reason]];
    }
}

-(IBAction)setInstallFolderAction:(id)sender {
    NSOpenPanel *installDirOpenPanel = [NSOpenPanel openPanel];
    [installDirOpenPanel setCanChooseFiles:false];
    [installDirOpenPanel setCanChooseDirectories:true];
    [installDirOpenPanel setTitle:@"Dwarf Fortress Installation Folder"];
    [installDirOpenPanel setDirectoryURL:[NSURL fileURLWithPath:[settings installDir]]];
    
    NSInteger result = [installDirOpenPanel runModal];
    if (result != NSOKButton) return;

    [self updateInstallDir:[[installDirOpenPanel URL] path]];
}

-(IBAction)saveSettingsAction:(id)sender {
    NSSavePanel *settingsSavePanel = [NSSavePanel savePanel];
    [settingsSavePanel setTitle:@"Save Dwarf Builder Settings"];
    [settingsSavePanel setAllowedFileTypes:[NSArray arrayWithObjects:@"dbs", nil]];
    [settingsSavePanel setAllowsOtherFileTypes:false];
    [settingsSavePanel setDirectoryURL:[NSURL fileURLWithPath:[settings installDir]]];
    
    NSInteger result = [settingsSavePanel runModal];
    if (result != NSOKButton) return;
    
    [settings writeSettingsToFile:[[settingsSavePanel URL] path]];
}

-(IBAction)loadSettingsAction:(id)sender {
    NSOpenPanel *settingsOpenPanel = [NSOpenPanel openPanel];
    [settingsOpenPanel setCanChooseFiles:true];
    [settingsOpenPanel setCanChooseDirectories:false];
    [settingsOpenPanel setAllowedFileTypes:[NSArray arrayWithObjects:@"dbs", nil]];
    [settingsOpenPanel setAllowsOtherFileTypes:false];
    [settingsOpenPanel setTitle:@"Load Dwarf Builder Settings"];
    [settingsOpenPanel setDirectoryURL:[NSURL fileURLWithPath:[settings installDir]]];
    
    NSInteger result = [settingsOpenPanel runModal];
    if (result != NSOKButton) return;
    
    [settings readSettingsFromFile:[[settingsOpenPanel URL] path]];
}

-(IBAction)plaidmanSettingsAction:(id)sender {
    [settings setPlaidmanDefaults];
}

-(IBAction)defaultSettingsAction:(id)sender {
    [settings setDFDefaults];
}

-(IBAction)backupDFFilesAction:(id)sender {
    NSString *pathToAppSaves = [NSString stringWithFormat:@"%@/%@", [settings installDir],
        @"DwarfFortress.app/Contents/Resources/data/save"];
    NSString *pathToSavedSaves = [NSString stringWithFormat:@"%@/df_backup", dbResources];
    
    if ([fileManager fileExistsAtPath:pathToAppSaves]) {
        NSLog(@"%@", [fileManager attributesOfItemAtPath:pathToAppSaves error:nil]);
        return;
        
        if ([fileManager fileExistsAtPath:pathToSavedSaves]) {
            if (![self confirmDialog:@"I am currently storing an older backup for you."
                    message:@"Would you like me to overwrite it?"]) {
                return;
            }
        }

        [fileManager removeItemAtPath:pathToSavedSaves error:nil];
        [fileManager copyItemAtPath:pathToAppSaves toPath:pathToSavedSaves error:nil];
    } else {
        [self errorDialog:@"I couldn't find any files to back up." message:@""];
    }
}

-(IBAction)restoreDFFilesAction:(id)sender {
    NSString *pathToSavedSaves = [NSString stringWithFormat:@"%@/df_backup", dbResources];
    NSString *pathToAppSaves = [NSString stringWithFormat:@"%@/%@", [settings installDir],
        @"DwarfFortress.app/Contents/Resources/data/save"];
    
    if ([fileManager fileExistsAtPath:pathToSavedSaves]) {
        if ([fileManager fileExistsAtPath:pathToAppSaves]) {
            if (![self confirmDialog:@"There is already a save game here."
                    message:@"Would you like me to overwrite it?"]) {
                return;
            }
        }
        
        [fileManager removeItemAtPath:pathToAppSaves error:nil];
        [fileManager copyItemAtPath:pathToSavedSaves toPath:pathToAppSaves error:nil];
    } else {
        [self errorDialog:@"You have not backed up any files to restore." message:@""];
    }
}

-(IBAction)aboutMenuAction:(id)sender {
    if (!aboutWindow) {
        aboutWindow = [[NSWindowController alloc] initWithWindowNibName:@"About"];
    }
    [aboutWindow showWindow:nil];
}

-(IBAction)openDFAppAction:(id)sender {
    NSString *dfDir = [NSString stringWithFormat:@"%@/%@", [settings installDir],
        @"DwarfFortress.app/Contents/Resources"];
    
    if (![fileManager fileExistsAtPath:dfDir]) {
        [self errorDialog:@"Sorry, I couldn't find your Dwarf Fortress app." message:@""];
        return;
    }
    
    [[NSWorkspace sharedWorkspace] openFile:dfDir];
}

-(IBAction)updateDFRawsAction:(id)sender {
    [self updateSaveRaws];
}


/* * * * * * * * * * * * * * *
 * -- SERIALIZER FUNCTIONS -- 
 * * * * * * * * * * * * * * */

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


/* * * * * * * * * * * * *
 * -- HELPER FUNCTIONS -- 
 * * * * * * * * * * * * */

-(void)linuxCPFromPath:(NSString*)fromPath toPath:(NSString*)toPath {
    NSEnumerator *itemReader = [fileManager enumeratorAtPath:fromPath];
    NSString *item, *pathFromItem, *pathToItem, *itemType;
    
    while (item = [itemReader nextObject]) {
        pathFromItem = [NSString stringWithFormat:@"%@/%@", fromPath, item];
        pathToItem = [NSString stringWithFormat:@"%@/%@", toPath, item];
        itemType = [[fileManager attributesOfItemAtPath:pathFromItem error:nil]
            valueForKey:NSFileType];
        
        if ([NSFileTypeDirectory isEqualToString:itemType]) {
            [fileManager createDirectoryAtPath:pathToItem withIntermediateDirectories:true
                attributes:nil error:nil];
        } else {
            if ([fileManager fileExistsAtPath:pathToItem]) {
                [fileManager removeItemAtPath:pathToItem error:nil];
            }
            
            [fileManager copyItemAtPath:pathFromItem toPath:pathToItem error:nil];
        }
    }
}

-(void)translateTextFile:(NSString*)textFile changes:(NSDictionary*)changes {
    NSStringEncoding encoding = NSUTF8StringEncoding;
    NSError *error;
    NSMutableString *fileContents = [NSMutableString stringWithContentsOfFile:textFile
        encoding:encoding error:&error];
    
    if (error) {
        error = nil;
        encoding = NSISOLatin1StringEncoding;
        fileContents = [NSMutableString stringWithContentsOfFile:textFile encoding:encoding error:&error];
        if (error) @throw [NSException exceptionWithName:@"Something went terribly wrong."
            reason:[NSString stringWithFormat:@"Failed opening %@", textFile] userInfo:nil];
    }
    
    NSEnumerator *changeKeys = [changes keyEnumerator];
    NSString *changeKey;
    
    while (changeKey = [changeKeys nextObject]) {
        [fileContents replaceOccurrencesOfRegex:changeKey withString:[changes valueForKey:changeKey]];
    }
    
    [fileContents writeToFile:textFile atomically:true encoding:encoding error:nil];
}

-(void)translateKeybinds:(NSMutableString*)fileContents bindLabel:(NSString*)bindLabel
        fromKey:(NSString*)fromKey toKey:(NSString*)toKey {
    NSString *bindLabelRegex = [NSString stringWithFormat:@"\\[BIND:%@\\](.|\\r|\\n)*?\\[BIND", bindLabel];
    NSString *fromKeyRegex = [NSString stringWithFormat:@"\\[%@\\]", fromKey];
    NSString *toKeyTag = [NSString stringWithFormat:@"[%@]", toKey];
    
    NSRange keysRange = [fileContents rangeOfRegex:bindLabelRegex];
    [fileContents replaceOccurrencesOfRegex:fromKeyRegex withString:toKeyTag range:keysRange];
}

-(void)addExtraShellItem:(NSMutableString *)fileContents shellItem:(NSString *)shellItem {
    NSString *shellItemRegex = [NSString stringWithFormat:@"\\[MATERIAL_TEMPLATE:%@\\]%@",
        shellItem, @"(.|\\r|\\n)*?\\[MATERIAL_TEMPLATE"];
    
    NSRange range = [fileContents rangeOfRegex:shellItemRegex];
    range.location = (range.location + range.length - 25);
    range.length = 1;
    
    while (![[fileContents substringWithRange:range] isEqualToString:@"]"]) range.location++;
    range.location++;
    
    [fileContents insertString:@"\r\n\t[SHELL]" atIndex:range.location];
}


/* * * * * * * * * * * * * * * * * *
 *  -- DF CONSTRUCTION FUNCTIONS --
 * * * * * * * * * * * * * * * * * */

-(void)copyVanilla {
    NSString *vanillaFolder = [NSString stringWithFormat:@"%@/dwarfort", dbResources];
    NSString *buildFolder = [NSString stringWithFormat:@"%@/build", dbResources];
    
    [fileManager removeItemAtPath:buildFolder error:nil];
    [fileManager copyItemAtPath:vanillaFolder toPath:buildFolder error:nil];
    
    NSString *dfScriptFile = [NSString stringWithFormat:@"%@/%@", buildFolder, @"df"];
    
    NSDictionary *changes = [NSDictionary dictionaryWithObjectsAndKeys:
        @"dwarfort.exe& > stdout.txt 2> stderr.txt", @"dwarfort\\.exe", nil];
    
    [self translateTextFile:dfScriptFile changes:changes];
}

-(void)copyTileset {
    NSString *buildDataFolder = [NSMutableString stringWithFormat:@"%@/build/data", dbResources];
    NSString *buildRawFolder = [NSMutableString stringWithFormat:@"%@/build/raw", dbResources];
    
    if ([settings tileset] == tsIronhand) {
        NSString *tilesetDataFolder = [NSString stringWithFormat:@"%@/extras/tilesets/ironhand/data", dbResources];
        NSString *tilesetRawFolder = [NSString stringWithFormat:@"%@/extras/tilesets/ironhand/raw", dbResources];
        
        [self linuxCPFromPath:tilesetDataFolder toPath:buildDataFolder];
        [self linuxCPFromPath:tilesetRawFolder toPath:buildRawFolder];
    } else if ([settings tileset] == tsPhoebus) {
        NSString *tilesetDataFolder = [NSString stringWithFormat:@"%@/extras/tilesets/phoebus/data", dbResources];
        NSString *tilesetRawFolder = [NSString stringWithFormat:@"%@/extras/tilesets/phoebus/raw", dbResources];
        
        [self linuxCPFromPath:tilesetDataFolder toPath:buildDataFolder];
        [self linuxCPFromPath:tilesetRawFolder toPath:buildRawFolder];
    } else if ([settings tileset] == tsJollyTall) {
        NSString *tilesetDataFolder = [NSString stringWithFormat:@"%@/extras/tilesets/jolly_tall/data", dbResources];
        NSString *tilesetRawFolder = [NSString stringWithFormat:@"%@/extras/tilesets/jolly_tall/raw", dbResources];
        
        [self linuxCPFromPath:tilesetDataFolder toPath:buildDataFolder];
        [self linuxCPFromPath:tilesetRawFolder toPath:buildRawFolder];
    } else if ([settings tileset] == tsJollySquare) {
        NSString *tilesetDataFolder = [NSString stringWithFormat:@"%@/extras/tilesets/jolly_square/data", dbResources];
        NSString *tilesetRawFolder = [NSString stringWithFormat:@"%@/extras/tilesets/jolly_square/raw", dbResources];
        
        [self linuxCPFromPath:tilesetDataFolder toPath:buildDataFolder];
        [self linuxCPFromPath:tilesetRawFolder toPath:buildRawFolder];
    } else if ([settings tileset] == tsVherid) {
        NSString *tilesetDataFolder = [NSString stringWithFormat:@"%@/extras/tilesets/vherid/data", dbResources];
        NSString *tilesetRawFolder = [NSString stringWithFormat:@"%@/extras/tilesets/vherid/raw", dbResources];
        
        [self linuxCPFromPath:tilesetDataFolder toPath:buildDataFolder];
        [self linuxCPFromPath:tilesetRawFolder toPath:buildRawFolder];
    } else if ([settings tileset] == tsMayday) {
        NSString *tilesetDataFolder = [NSString stringWithFormat:@"%@/extras/tilesets/mayday/data", dbResources];
        NSString *tilesetRawFolder = [NSString stringWithFormat:@"%@/extras/tilesets/mayday/raw", dbResources];
        
        [self linuxCPFromPath:tilesetDataFolder toPath:buildDataFolder];
        [self linuxCPFromPath:tilesetRawFolder toPath:buildRawFolder];
    } else if ([settings tileset] == tsDefaultSquare) {
        NSString *initTxtFile = [NSString stringWithFormat:@"%@/build/data/init/init.txt", dbResources];
        NSDictionary *changes = [NSDictionary dictionaryWithObjectsAndKeys:
            [self stringToInit:@"curses_square_16x16.png" optionName:@"FONT"], @"\\[FONT:.*\\]",
            [self stringToInit:@"curses_square_16x16.png" optionName:@"FULLFONT"], @"\\[FULLFONT:.*\\]",
            [self stringToInit:@"curses_square_16x16.png" optionName:@"GRAPHICS_FULLFONT"],
                @"\\[GRAPHICS_FULLFONT:.*\\]",
            [self stringToInit:@"curses_square_16x16.png" optionName:@"GRAPHICS_FULLFONT"],
                @"\\[GRAPHICS_FULLFONT:.*\\]",
            nil];
        
        [self translateTextFile:initTxtFile changes:changes];
    } else if ([settings tileset] == tsDefaultTall) {
        NSString *initTxtFile = [NSString stringWithFormat:@"%@/build/data/init/init.txt", dbResources];
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
    NSString *initTxtFile = [NSString stringWithFormat:@"%@/build/data/init/init.txt", dbResources];
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
        [self stringToInit:[settings pFPSCap] optionName:@"FPS_CAP"], @"\\[FPS_CAP:.*\\]",
        [self stringToInit:[settings gFPSCap] optionName:@"G_FPS_CAP"], @"\\[G_FPS_CAP:.*\\]",
        [self boolToInit:[settings compressSaves] optionName:@"COMPRESSED_SAVES"], @"\\[COMPRESSED_SAVES:.*\\]",
        nil];
    
    [self translateTextFile:initTxtFile changes:changes];
}

-(void)processDInitTxt {
    NSString *dInitTxtFile = [NSString stringWithFormat:@"%@/build/data/init/d_init.txt", dbResources];
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
        NSString *rawObjectsPath = [NSString stringWithFormat:@"%@/build/raw/objects", dbResources];
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
        NSString *rawObjectsPath = [NSString stringWithFormat:@"%@/build/raw/objects", dbResources];
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
        NSString *initTxtFile = [NSString stringWithFormat:@"%@/build/data/init/announcements.txt", dbResources];
        NSDictionary *changes = [NSDictionary dictionaryWithObjectsAndKeys:
            @"[DIG_CANCEL_WARM:A_D:D_D]", @"\\[DIG_CANCEL_WARM:.*\\]",
            @"[DIG_CANCEL_DAMP:A_D:D_D]", @"\\[DIG_CANCEL_DAMP:.*\\]", nil];
        
        [self translateTextFile:initTxtFile changes:changes];
    }
};

-(void)disablePausingCaveIns {
    if (![settings pauseOnCaveIns]) {
        NSString *initTxtFile = [NSString stringWithFormat:@"%@/build/data/init/announcements.txt", dbResources];
        NSDictionary *changes = [NSDictionary dictionaryWithObjectsAndKeys:
            @"[CAVE_COLLAPSE:A_D:D_D]", @"\\[CAVE_COLLAPSE:.*\\]", nil];
        
        [self translateTextFile:initTxtFile changes:changes];
    }
};

-(void)updateKeybinds {
    NSError *error;
    NSString *keybindFile = [NSString stringWithFormat:@"%@/build/data/init/interface.txt", dbResources];
    NSMutableString *fileContents = [NSMutableString stringWithContentsOfFile:keybindFile
                                                                     encoding:NSUTF8StringEncoding error:&error];
    if (error) @throw [NSException exceptionWithName:@"Something went terribly wrong."
        reason:[NSString stringWithFormat:@"Failed opening %@", keybindFile] userInfo:nil];
    
    if ([settings keybindings] == kbLaptop) {
        [self translateKeybinds:fileContents bindLabel:@"SECONDSCROLL_DOWN:REPEAT_SLOW"
            fromKey:@"KEY:\\+" toKey:@"KEY:="];
        [self translateKeybinds:fileContents bindLabel:@"SECONDSCROLL_PAGEUP:REPEAT_SLOW"
            fromKey:@"KEY:/" toKey:@"KEY:_"];
        [self translateKeybinds:fileContents bindLabel:@"SECONDSCROLL_PAGEDOWN:REPEAT_SLOW"
            fromKey:@"KEY:\\*" toKey:@"KEY:+"];
        [self translateKeybinds:fileContents bindLabel:@"D_MILITARY_SUPPLIES_WATER_UP:REPEAT_NOT"
            fromKey:@"KEY:\\+" toKey:@"KEY:="];
        [self translateKeybinds:fileContents bindLabel:@"D_MILITARY_SUPPLIES_FOOD_DOWN:REPEAT_NOT"
            fromKey:@"KEY:/" toKey:@"KEY:_"];
        [self translateKeybinds:fileContents bindLabel:@"D_MILITARY_SUPPLIES_FOOD_UP:REPEAT_NOT"
            fromKey:@"KEY:\\*" toKey:@"KEY:+"];
        [self translateKeybinds:fileContents bindLabel:@"D_MILITARY_AMMUNITION_RAISE_AMOUNT:REPEAT_NOT"
            fromKey:@"KEY:\\+" toKey:@"KEY:="];
        [self translateKeybinds:fileContents bindLabel:@"D_MILITARY_AMMUNITION_LOWER_AMOUNT_LOTS:REPEAT_NOT"
            fromKey:@"KEY:/" toKey:@"KEY:_"];
        [self translateKeybinds:fileContents bindLabel:@"D_MILITARY_AMMUNITION_RAISE_AMOUNT_LOTS:REPEAT_NOT"
            fromKey:@"KEY:\\*" toKey:@"KEY:+"];
    }
    
    [self translateKeybinds:fileContents bindLabel:@"STRING_A127:REPEAT_SLOW"
        fromKey:@"KEY:.*?" toKey:@"SYM:2:Backspace"];
    
    [fileContents writeToFile:keybindFile atomically:true encoding:NSUTF8StringEncoding error:nil];
}

-(void)disableSkillRusting {
    if (![settings skillRusting]) {
        NSString *dwarfCreatureFile = [NSString stringWithFormat:@"%@/%@", dbResources,
            @"build/raw/objects/creature_standard.txt"];
        NSString *rustProofFile = [NSString stringWithFormat:@"%@/extras/rust_proof.txt", dbResources];
        
        NSError *error;
        NSMutableString *dwarfFileContents = [NSMutableString stringWithContentsOfFile:dwarfCreatureFile
            encoding:NSUTF8StringEncoding error:&error];
        if (error) @throw [NSException exceptionWithName:@"Something went terribly wrong."
            reason:[NSString stringWithFormat:@"Failed opening %@", dwarfCreatureFile] userInfo:nil];
        NSString *rustFileContents = [NSString stringWithContentsOfFile:rustProofFile
            encoding:NSUTF8StringEncoding error:&error];
        if (error) @throw [NSException exceptionWithName:@"Something went terribly wrong."
            reason:[NSString stringWithFormat:@"Failed opening %@", rustProofFile] userInfo:nil];
        
        NSRange range = [dwarfFileContents rangeOfRegex:@"\\[CREATURE:DWARF\\](.|\\r|\\n)*?\\[PHYS_ATT_RANGE:"];
        range.location = (range.location + range.length - 25);
        range.length = 1;
        
        while (![[dwarfFileContents substringWithRange:range] isEqualToString:@"."]) range.location++;
        range.location++;
        
        [dwarfFileContents insertString:[NSString stringWithFormat:@"\r\n\r\n\r\n%@", rustFileContents]
            atIndex:range.location];
        [dwarfFileContents writeToFile:dwarfCreatureFile atomically:true encoding:NSUTF8StringEncoding error:nil];
    }
}

-(void)addExtraShellItems {
    if ([settings extraShellItems]) {
        NSError *error;
        NSString *materialFile = [NSString stringWithFormat:@"%@/build/raw/objects/material_template_default.txt",
            dbResources];
        NSMutableString *materialFileContents = [NSMutableString stringWithContentsOfFile:materialFile
            encoding:NSUTF8StringEncoding error:&error];
        if (error) @throw [NSException exceptionWithName:@"Something went terribly wrong."
            reason:[NSString stringWithFormat:@"Failed opening %@", materialFile] userInfo:nil];
        
        [self addExtraShellItem:materialFileContents shellItem:@"SCALE_TEMPLATE"];
        [self addExtraShellItem:materialFileContents shellItem:@"HORN_TEMPLATE"];
        [self addExtraShellItem:materialFileContents shellItem:@"HOOF_TEMPLATE"];
        [self addExtraShellItem:materialFileContents shellItem:@"CHITIN_TEMPLATE"];
        
        [materialFileContents writeToFile:materialFile atomically:true encoding:NSUTF8StringEncoding error:nil];
    }
}

-(void)copySoundtrack {
    if ([settings extendSoundtk]) {
        NSString *pathFromItem = [NSString stringWithFormat:@"%@/extras/extended.ogg", dbResources];
        NSString *pathToItem = [NSString stringWithFormat:@"%@/build/data/sound/song_game.ogg", dbResources];
        
        [fileManager removeItemAtPath:pathToItem error:nil];
        [fileManager copyItemAtPath:pathFromItem toPath:pathToItem error:nil];
    }
}

-(void)copyFont {
    NSString *pathFromItem = [NSString stringWithFormat:@"%@/extras/fonts/default.ttf", dbResources];
    NSString *pathToItem = [NSMutableString stringWithFormat:@"%@/build/data/art/font.ttf", dbResources];
    
    if ([settings font] == fIronhand) {
        pathFromItem = [NSString stringWithFormat:@"%@/extras/fonts/ironhand.ttf", dbResources];
    } else if ([settings font] == fPhoebus) {
        pathFromItem = [NSString stringWithFormat:@"%@/extras/fonts/phoebus.ttf", dbResources];
    } else if ([settings font] == fTuffy) {
        pathFromItem = [NSString stringWithFormat:@"%@/extras/fonts/tuffy.ttf", dbResources];
    } else if ([settings font] == fMasterwork) {
        pathFromItem = [NSString stringWithFormat:@"%@/extras/fonts/masterwork.ttf", dbResources];
    }
    
    [fileManager removeItemAtPath:pathToItem error:nil];
    [fileManager copyItemAtPath:pathFromItem toPath:pathToItem error:nil];
}

-(void)copyColors {
    if (![settings useTilesetColors]) {
        NSString *pathFromItem = [NSString stringWithFormat:@"%@/extras/colors/default.txt", dbResources];
        NSString *pathToItem = [NSMutableString stringWithFormat:@"%@/build/data/init/colors.txt", dbResources];
        
        if ([settings colors] == cIronhand) {
            pathFromItem = [NSString stringWithFormat:@"%@/extras/colors/ironhand.txt", dbResources];
        } else if ([settings colors] == cPhoebus) {
            pathFromItem = [NSString stringWithFormat:@"%@/extras/colors/phoebus.txt", dbResources];
        } else if ([settings colors] == cMayday) {
            pathFromItem = [NSString stringWithFormat:@"%@/extras/colors/mayday.txt", dbResources];
        } else if ([settings colors] == cJolly) {
            pathFromItem = [NSString stringWithFormat:@"%@/extras/colors/jolly.txt", dbResources];
        } else if ([settings colors] == cDefaultPlus) {
            pathFromItem = [NSString stringWithFormat:@"%@/extras/colors/default+.txt", dbResources];
        } else if ([settings colors] == cJollyWarm) {
            pathFromItem = [NSString stringWithFormat:@"%@/extras/colors/jolly_warm.txt", dbResources];
        } else if ([settings colors] == cKremlin) {
            pathFromItem = [NSString stringWithFormat:@"%@/extras/colors/kremlin.txt", dbResources];
        } else if ([settings colors] == cMatrix) {
            pathFromItem = [NSString stringWithFormat:@"%@/extras/colors/matrix.txt", dbResources];
        } else if ([settings colors] == cNatural) {
            pathFromItem = [NSString stringWithFormat:@"%@/extras/colors/natural.txt", dbResources];
        } else if ([settings colors] == cNES) {
            pathFromItem = [NSString stringWithFormat:@"%@/extras/colors/nes.txt", dbResources];
        } else if ([settings colors] == cPlagueWarm) {
            pathFromItem = [NSString stringWithFormat:@"%@/extras/colors/plague_warm.txt", dbResources];
        } else if ([settings colors] == cWarm) {
            pathFromItem = [NSString stringWithFormat:@"%@/extras/colors/warm.txt", dbResources];
        } else if ([settings colors] == cWasteland) {
            pathFromItem = [NSString stringWithFormat:@"%@/extras/colors/wasteland.txt", dbResources];
        }
        
        [fileManager removeItemAtPath:pathToItem error:nil];
        [fileManager copyItemAtPath:pathFromItem toPath:pathToItem error:nil];
    }
}

-(void)addWorldGens {
    NSString *worldGenFile = [NSString stringWithFormat:@"%@/build/data/init/world_gen.txt", dbResources];
    NSString *extraWorldGenFile = [NSString stringWithFormat:@"%@/extras/extra_world_gen.txt", dbResources];
    
    NSError *error;
    NSMutableString *worldGenFileContents = [NSMutableString stringWithContentsOfFile:worldGenFile
        encoding:NSUTF8StringEncoding error:&error];
    if (error) @throw [NSException exceptionWithName:@"Something went terribly wrong."
        reason:[NSString stringWithFormat:@"Failed opening %@", worldGenFile] userInfo:nil];
    NSString *extraWorldGenFileContents = [NSString stringWithContentsOfFile:extraWorldGenFile
        encoding:NSUTF8StringEncoding error:&error];
    if (error) @throw [NSException exceptionWithName:@"Something went terribly wrong."
        reason:[NSString stringWithFormat:@"Failed opening %@", extraWorldGenFile] userInfo:nil];
    
    [worldGenFileContents appendString:extraWorldGenFileContents];
    [worldGenFileContents writeToFile:worldGenFile atomically:true encoding:NSUTF8StringEncoding error:nil];
}

-(void)copyEmbarkProfiles {
    NSString *pathFromItem = [NSString stringWithFormat:@"%@/extras/embark_profiles.txt", dbResources];
    NSString *pathToItem = [NSString stringWithFormat:@"%@/build/data/init/embark_profiles.txt", dbResources];
    
    [fileManager removeItemAtPath:pathToItem error:nil];
    [fileManager copyItemAtPath:pathFromItem toPath:pathToItem error:nil];
}

-(void)setupDwarfFortressApp {
    NSString *pathToAppShell = [NSString stringWithFormat:@"%@/extras/shells/DwarfFortress.app", dbResources];
    NSString *pathToConstructedApp = [NSString stringWithFormat:@"%@/DwarfFortress.app", [settings installDir]];
    NSString *pathToStagedResources = [NSString stringWithFormat:@"%@/build", dbResources];
    NSString *pathToAppResources = [NSString stringWithFormat:@"%@/Contents/Resources", pathToConstructedApp];
    NSString *pathToExternalResources = [NSString stringWithFormat:@"%@/df_files", [settings installDir]];
    NSString *resourcesFileType = [[fileManager attributesOfItemAtPath:pathToAppResources error:nil]
        valueForKey:NSFileType];
    NSString *pathToAppSaves = [NSString stringWithFormat:@"%@/data/save", pathToAppResources];
    NSString *pathToSavedSaves = [NSString stringWithFormat:@"%@/cons_backup", dbResources];
    NSString *pathToExternalSaves = [NSString stringWithFormat:@"%@/df_saves", [settings installDir]];
    NSString *saveFileType = [[fileManager attributesOfItemAtPath:pathToAppSaves error:nil]
        valueForKey:NSFileType];
    NSString *pathToAppVersionFile = [NSString stringWithFormat:@"%@/df_version", pathToAppResources];
    NSString *pathToSavedVersionFile = [NSString stringWithFormat:@"%@/df_version", pathToSavedSaves];
    NSString *pathToGameLog = [NSString stringWithFormat:@"%@/gamelog.txt", pathToAppResources];
    
    [fileManager removeItemAtPath:pathToSavedSaves error:nil];
    if ([fileManager fileExistsAtPath:pathToAppSaves]) {
        if ([self confirmDialog:@"Found a save in the exiting DF.app."
                message:@"Would you like me to transfer it to the new app for you?"]) {
            
            if ([NSFileTypeSymbolicLink isEqualToString:resourcesFileType]) {
                [fileManager removeItemAtPath:pathToAppResources error:nil];
                [fileManager moveItemAtPath:pathToExternalResources toPath:pathToAppResources error:nil];
            }
            
            if ([NSFileTypeSymbolicLink isEqualToString:saveFileType]) {
                [fileManager removeItemAtPath:pathToAppSaves error:nil];
                [fileManager moveItemAtPath:pathToExternalSaves toPath:pathToAppSaves error:nil];
            }

            [fileManager copyItemAtPath:pathToAppSaves toPath:pathToSavedSaves error:nil];
            if ([fileManager fileExistsAtPath:pathToAppVersionFile]) {
                [fileManager copyItemAtPath:pathToAppVersionFile toPath:pathToSavedVersionFile error:nil];
            } else {
                [@"0.34.07" writeToFile:pathToSavedVersionFile atomically:true
                    encoding:NSUTF8StringEncoding error:nil];
            }
        }
    }
    
    [fileManager removeItemAtPath:pathToConstructedApp error:nil];
    [fileManager copyItemAtPath:pathToAppShell toPath:pathToConstructedApp error:nil];
    [fileManager removeItemAtPath:pathToAppResources error:nil];
    if ([settings externalDFDir]) {
        [fileManager removeItemAtPath:pathToExternalResources error:nil];
        [fileManager moveItemAtPath:pathToStagedResources toPath:pathToExternalResources error:nil];
        [fileManager createSymbolicLinkAtPath:pathToAppResources
            withDestinationPath:pathToExternalResources error:nil];
    } else {
        [fileManager moveItemAtPath:pathToStagedResources toPath:pathToAppResources error:nil];
    }
    
    if ([fileManager fileExistsAtPath:pathToSavedVersionFile]) {
        [fileManager moveItemAtPath:pathToSavedVersionFile toPath:pathToAppVersionFile error:nil];
    } else {
        [[settings dfCurrentVersion] writeToFile:pathToAppVersionFile atomically:true
            encoding:NSUTF8StringEncoding error:nil];
    }
    
    if ([fileManager fileExistsAtPath:pathToSavedSaves]) {
        [fileManager copyItemAtPath:pathToSavedSaves toPath:pathToAppSaves error:nil];
        [fileManager removeItemAtPath:pathToSavedSaves error:nil];
        [self updateSaveRaws];
    }
    
    if ([settings externalSaveDir]) {
        if (![fileManager fileExistsAtPath:pathToAppSaves]) {
            [fileManager createDirectoryAtPath:pathToAppSaves withIntermediateDirectories:true
                attributes:nil error:nil];
        }
        
        [fileManager removeItemAtPath:pathToExternalSaves error:nil];
        [fileManager moveItemAtPath:pathToAppSaves toPath:pathToExternalSaves error:nil];
        [fileManager createSymbolicLinkAtPath:pathToAppSaves
            withDestinationPath:pathToExternalSaves error:nil];
    }
    
    [@"" writeToFile:pathToGameLog atomically:true encoding:NSUTF8StringEncoding error:nil];
    
    [[NSWorkspace sharedWorkspace] setIcon:[[NSImage alloc]
        initByReferencingFile:[NSString stringWithFormat:@"%@/%@", dbResources, @"DwarfFortress.png"]]
        forFile:pathToConstructedApp options:0];
    [[NSWorkspace sharedWorkspace] setIcon:[[NSImage alloc]
        initByReferencingFile:[NSString stringWithFormat:@"%@/%@", dbResources, @"DwarfFortress.png"]]
        forFile:[NSString stringWithFormat:@"%@/%@", pathToAppResources, @"dwarfort.exe"] options:0];
}


/* * * * * * * * * * * * * * * * * * * 
 *  -- BEHIND THE SCENES FUNCTIONS --
 * * * * * * * * * * * * * * * * * * */

-(void)updateSaveRaws {
    NSString *appDir = [NSString stringWithFormat:@"%@/%@", [settings installDir],
        @"DwarfFortress.app/Contents/Resources"];
    NSString *rawDir = [NSString stringWithFormat:@"%@/raw", appDir];
    NSString *saveDir = [NSString stringWithFormat:@"%@/data/save", appDir];
    NSString *versionFile = [NSString stringWithFormat:@"%@/df_version", appDir];
    NSString *dfSaveVersion;
    
    if (![fileManager fileExistsAtPath:saveDir]) {
        [self errorDialog:@"I couldn't find any saved regions." message:@""];
        return;
    }
    
    if ([fileManager fileExistsAtPath:versionFile]) {
        dfSaveVersion = [NSString stringWithContentsOfFile:versionFile
            encoding:NSUTF8StringEncoding error:nil];
    } else {
        dfSaveVersion = @"0.34.07";
    }
    
    if (![dfSaveVersion isEqualToString:[settings dfCurrentVersion]]) {
        [self errorDialog:@"Sorry, I can't translate raws between versions." message:@""];
        return;
    }
    
    NSEnumerator *itemReader = [fileManager enumeratorAtPath:saveDir];
    NSString *item, *fullItemPath, *itemType;
    
    while (item = [itemReader nextObject]) {
        fullItemPath = [NSString stringWithFormat:@"%@/%@/raw", saveDir, item];
        itemType = [[fileManager attributesOfItemAtPath:fullItemPath error:nil] valueForKey:NSFileType];
        
        if ([itemType isEqualToString:NSFileTypeDirectory]) {
            [fileManager removeItemAtPath:fullItemPath error:nil];
            [fileManager copyItemAtPath:rawDir toPath:fullItemPath error:nil];
        }
    }
}

-(void)updateInstallDir:(NSString*)directory {
    [settings setInstallDir:directory];
    [self setInstallDirString:directory];
    
    if ([directory length] > 50) {
        NSString *trunc = [directory substringWithRange:NSMakeRange([directory length]-47, 47)];
        [self setInstallDirString:[NSString stringWithFormat:@"...%@", trunc]];
    }
}

-(bool)confirmDialog:(NSString*)alert message:(NSString*)message {
    NSAlert *confirm = [NSAlert alertWithMessageText:alert defaultButton:@"YES" alternateButton:@"NO"
        otherButton:nil informativeTextWithFormat:message];
    
    NSInteger result = [confirm runModal];
    if (result == NSOKButton) {
        return true;
    }
    return false;
}

-(void)errorDialog:(NSString *)alert message:(NSString *)message {
    NSAlert *confirm = [NSAlert alertWithMessageText:alert defaultButton:@"OK" alternateButton:nil
        otherButton:nil informativeTextWithFormat:message];
    [confirm runModal];
}

@end
