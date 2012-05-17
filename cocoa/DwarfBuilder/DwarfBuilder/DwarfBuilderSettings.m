
#import "DwarfBuilderSettings.h"

@implementation DwarfBuilderSettings

@synthesize propertyNames;
@synthesize dbSettingsVersion, dbCurrentVersion, dfCurrentVersion;

/* APPLICATION SETTINGS */
@synthesize enableSound, extendSoundtk, compressSaves, pauseOnLoad, pauseOnSave, autoBackupSaves;
@synthesize volume, keybindings, autosave;
@synthesize pFPSCap, gFPSCap;

/* VISUAL SETTINGS */
@synthesize fullscreen, showIntro, showFPS, liquidDepth, creatureGraphics, useFont, resizable, useTilesetColors;
@synthesize windowWidth, windowHeight;
@synthesize showIdlers, tileset, font, colors;

/* GAMEPLAY SETTINGS */
@synthesize skillRusting, embarkConfirmation, grazingAnimals, pauseOnCaveIns, extraShellItems,
    pauseOnWarmDampStone, temperature, aquifers, caveIns, invaders, weather;
@synthesize dwarfCap, childHardCap, childPercentageCap, embarkWidth, embarkHeight;

/* FILE SETTINGS */
@synthesize backupExternally, externalSaveDir, externalDFDir;
@synthesize installDir;

-(id)init {
    self = [super init];
    
    if (self) {
        dbCurrentVersion = @"12";
        dfCurrentVersion = @"0.34.09";
        propertyNames = [[NSArray alloc] initWithObjects:@"dbSettingsVersion", @"enableSound", @"extendSoundtk",
            @"compressSaves", @"pauseOnLoad", @"pauseOnSave", @"autoBackupSaves", @"volume", @"keybindings",
            @"autosave", @"pFPSCap", @"gFPSCap", @"fullscreen", @"showIntro", @"showFPS", @"liquidDepth",
            @"creatureGraphics", @"useFont", @"windowWidth", @"windowHeight", @"showIdlers", @"tileset",
            @"skillRusting", @"embarkConfirmation", @"grazingAnimals", @"pauseOnCaveIns", @"extraShellItems",
            @"pauseOnWarmDampStone", @"invaders", @"temperature", @"font", @"aquifers", @"caveIns", @"weather",
            @"resizable", @"dwarfCap", @"childHardCap", @"childPercentageCap", @"embarkWidth", @"embarkHeight",
            @"colors", @"useTilesetColors", @"backupExternally", @"externalSaveDir", @"externalDFDir", nil];
        [self setDFDefaults];
    }
    
    return self;
}

-(void)writeSettingsToFile:(NSString*)filename {
    NSDictionary *dict = [self dictionaryWithValuesForKeys:[self propertyNames]];
    [dict writeToFile:filename atomically:true];
}

-(void)readSettingsFromFile:(NSString*)filename {
    NSMutableDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filename];
    
    if ([[dict valueForKey:@"dbVersionNumber"] isEqualToString:@"7"]) {
        [dict removeObjectForKey:@"dbVersionNumber"];
    }
    
    [self setValuesForKeysWithDictionary:dict];
    [self setDbSettingsVersion:@"12"];
}

-(void)setPlaidmanDefaults {
    NSNumber *trueObj = [NSNumber numberWithBool:true];
    NSNumber *falseObj = [NSNumber numberWithBool:false];
    
    [self
        setValuesForKeysWithDictionary:[NSDictionary
            dictionaryWithObjects:[NSArray arrayWithObjects:dbCurrentVersion, falseObj, falseObj, trueObj, trueObj,
                trueObj, falseObj, [NSNumber numberWithInt:0], [NSNumber numberWithInt:kbLaptop],
                [NSNumber numberWithInt:asSeasonal], @"100", @"50", falseObj, falseObj, trueObj, trueObj, trueObj,
                falseObj, @"1280", @"600", [NSNumber numberWithInt:siTop], [NSNumber numberWithInt:tsPhoebus],
                falseObj, trueObj, falseObj, trueObj, trueObj, trueObj, trueObj, trueObj,
                [NSNumber numberWithInt:fPhoebus], falseObj, trueObj, trueObj, trueObj, @"100", @"15", @"20", @"3",
                @"3", [NSNumber numberWithInt:cPhoebus], trueObj, falseObj, falseObj, falseObj, nil
            ]
            forKeys:propertyNames
        ]
    ];
}

-(void)setDFDefaults {
    NSNumber *trueObj = [NSNumber numberWithBool:true];
    NSNumber *falseObj = [NSNumber numberWithBool:false];
    
    [self
        setValuesForKeysWithDictionary:[NSDictionary
            dictionaryWithObjects:[NSArray arrayWithObjects:dbCurrentVersion, trueObj, falseObj, trueObj, trueObj,
                falseObj, falseObj, [NSNumber numberWithInt:255], [NSNumber numberWithInt:kbDefault],
                [NSNumber numberWithInt:asDisabled], @"100", @"50", falseObj, trueObj, falseObj, falseObj, falseObj,
                falseObj, @"80", @"25", [NSNumber numberWithInt:siTop], [NSNumber numberWithInt:tsDefaultTall],
                trueObj, falseObj, trueObj, trueObj, falseObj, trueObj, trueObj, trueObj,
                [NSNumber numberWithInt:fDefault], trueObj, trueObj, trueObj, trueObj, @"200", @"100", @"1000", @"4",
                @"4", [NSNumber numberWithInt:cDefault], trueObj, falseObj, falseObj, falseObj, nil
            ]
            forKeys:propertyNames
        ]
    ];
}

@end
