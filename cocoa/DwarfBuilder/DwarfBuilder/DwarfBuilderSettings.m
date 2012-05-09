
#import "DwarfBuilderSettings.h"

@implementation DwarfBuilderSettings

@synthesize propertyNames;
@synthesize dbVersionNumber;

/* APPLICATION OPTIONS */
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
@synthesize installDir;

-(id)init {
    self = [super init];
    
    if (self) {
        propertyNames = [[NSArray alloc] initWithObjects:@"dbVersionNumber", @"enableSound", @"extendSoundtk",
            @"compressSaves", @"pauseOnLoad", @"pauseOnSave", @"autoBackupSaves", @"volume", @"keybindings",
            @"autosave", @"pFPSCap", @"gFPSCap", @"fullscreen", @"showIntro", @"showFPS", @"liquidDepth",
            @"creatureGraphics", @"useFont", @"windowWidth", @"windowHeight", @"showIdlers", @"tileset",
            @"skillRusting", @"embarkConfirmation", @"grazingAnimals", @"pauseOnCaveIns", @"extraShellItems",
            @"pauseOnWarmDampStone", @"invaders", @"temperature", @"font", @"aquifers", @"caveIns", @"weather",
            @"resizable", @"dwarfCap", @"childHardCap", @"childPercentageCap", @"embarkWidth", @"embarkHeight",
            @"colors", @"useTilesetColors", nil];
        [self setDFDefaults];
    }
    
    return self;
}

-(void)writeSettingsToFile:(NSString*)filename {
    NSDictionary *dict = [self dictionaryWithValuesForKeys:[self propertyNames]];
    [dict writeToFile:filename atomically:true];
}

-(void)readSettingsFromFile:(NSString*)filename {
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filename];
    
    if ([[dict valueForKey:@"dbVersionNumber"] isEqualToString:@"10"]) {
        [self setValuesForKeysWithDictionary:dict];
        return;
    } else if ([[dict valueForKey:@"dbVersionNumber"] isEqualToString:@"7"]) {
        [self setValuesForKeysWithDictionary:dict];
        [self setDbVersionNumber:@"10"];
        return;
    }
}

-(void)setPlaidmanDefaults {
    NSNumber *trueObj = [NSNumber numberWithBool:true];
    NSNumber *falseObj = [NSNumber numberWithBool:false];
    
    [self
        setValuesForKeysWithDictionary:[NSDictionary
            dictionaryWithObjects:[NSArray arrayWithObjects:@"10", falseObj, falseObj, trueObj, trueObj, trueObj,
                falseObj, [NSNumber numberWithInt:0], [NSNumber numberWithInt:kbLaptop],
                [NSNumber numberWithInt:asSeasonal], @"100", @"50", falseObj, falseObj, trueObj, trueObj, trueObj,
                falseObj, @"1280", @"600", [NSNumber numberWithInt:siTop], [NSNumber numberWithInt:tsIronhand],
                falseObj, trueObj, falseObj, trueObj, trueObj, trueObj, trueObj, trueObj,
                [NSNumber numberWithInt:fIronhand], falseObj, trueObj, trueObj, trueObj, @"100", @"15", @"20", @"3",
                @"3", [NSNumber numberWithInt:cIronhand], trueObj, nil
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
            dictionaryWithObjects:[NSArray arrayWithObjects:@"10", trueObj, falseObj, trueObj, trueObj, falseObj,
                falseObj, [NSNumber numberWithInt:255], [NSNumber numberWithInt:kbDefault],
                [NSNumber numberWithInt:asDisabled], @"100", @"50", falseObj, trueObj, falseObj, falseObj, falseObj,
                falseObj, @"1280", @"600", [NSNumber numberWithInt:siTop], [NSNumber numberWithInt:tsDefaultTall],
                trueObj, falseObj, trueObj, trueObj, falseObj, trueObj, trueObj, trueObj,
                [NSNumber numberWithInt:fDefault], trueObj, trueObj, trueObj, trueObj, @"200", @"100", @"1000", @"4",
                @"4", [NSNumber numberWithInt:cDefault], trueObj, nil
            ]
            forKeys:propertyNames
        ]
    ];
}

@end
