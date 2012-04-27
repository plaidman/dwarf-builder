
#import "DwarfBuilderSettings.h"

@implementation DwarfBuilderSettings

@synthesize properties;

@synthesize enableSound, extendSoundtk, compressSaves, 
    pauseOnLoad, pauseOnSave, autoBackupSaves;
@synthesize volume, keybindings, autosave;
@synthesize cFPSCap, gFPSCap;

@synthesize fullscreen, showIntro, showFPS,
    liquidDepth, creatureGraphics, useFont;
@synthesize windowWidth, windowHeight;
@synthesize showIdlers, tileset, font;

@synthesize skillRusting, embarkConfirmation, grazingAnimals,
    pauseOnCaveIns, extraShellItems, pauseOnWarmDampStone, 
    temperature, aquifers, caveIns, invaders, weather;
@synthesize dwarfCap, childHardCap, childPercentageCap,
    embarkWidth, embarkHeight;

-(id)init {
    self = [super init];
    
    if (self) {
        [self setProperties:[[NSArray alloc] initWithObjects:@"enableSound", @"extendSoundtk", @"compressSaves", 
                             @"pauseOnLoad", @"pauseOnSave", @"autoBackupSaves", @"volume", @"keybindings", 
                             @"autosave", @"cFPSCap", @"gFPSCap", @"fullscreen", @"showIntro", @"showFPS", 
                             @"liquidDepth", @"creatureGraphics", @"useFont",@"windowWidth", @"windowHeight", 
                             @"showIdlers", @"tileset", @"skillRusting", @"embarkConfirmation", @"grazingAnimals",
                             @"pauseOnCaveIns", @"extraShellItems", @"pauseOnWarmDampStone", @"invaders",
                             @"temperature", @"font", @"aquifers", @"caveIns", @"weather", @"dwarfCap", 
                             @"childHardCap", @"childPercentageCap", @"embarkWidth", @"embarkHeight", nil]];
        [self setPlaidmanDefaults];
    }
    
    return self;
}

-(void)writeSettingsToFile:(NSString *)filename {
    NSDictionary *dict = [self dictionaryWithValuesForKeys:[self properties]];
    [dict writeToFile:filename atomically:true];
}

-(void)readSettingsFromFile:(NSString *)filename {
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filename];
    [self setValuesForKeysWithDictionary:dict];
}

-(void)setPlaidmanDefaults {
//    [self setValuesForKeysWithDictionary:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"blah", nil] forKeys:[self properties]]];
    [self setEnableSound:false];
    [self setExtendSoundtk:false];
    [self setCompressSaves:true];
    [self setPauseOnLoad:true];
    [self setPauseOnSave:true];
    [self setAutoBackupSaves:false];
    [self setVolume:0];
    [self setKeybindings:kbLaptop];
    [self setAutosave:asSeasonal];
    [self setCFPSCap:@"100"];
    [self setGFPSCap:@"50"];
    [self setFullscreen:false];
    [self setShowIntro:false];
    [self setShowFPS:true];
    [self setLiquidDepth:true];
    [self setCreatureGraphics:true];
    [self setUseFont:false];
    [self setWindowWidth:@"1280"];
    [self setWindowHeight:@"600"];
    [self setShowIdlers:siTop];
    [self setTileset:tsIronhand];
    [self setFont:fIronhand];
    [self setSkillRusting:false];
    [self setEmbarkConfirmation:true];
    [self setGrazingAnimals:false];
    [self setPauseOnCaveIns:true];
    [self setExtraShellItems:true];
    [self setPauseOnWarmDampStone:true];
    [self setTemperature:true];
    [self setAquifers:false];
    [self setCaveIns:true];
    [self setInvaders:true];
    [self setWeather:true];
    [self setDwarfCap:@"100"];
    [self setChildHardCap:@"15"];
    [self setChildPercentageCap:@"20"];
    [self setEmbarkWidth:@"3"];
    [self setEmbarkHeight:@"3"];
}

-(void)setDFDefaults {
//    [self setValuesForKeysWithDictionary:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"blah", nil] forKeys:[self properties]]];
    [self setEnableSound:true];
    [self setExtendSoundtk:false];
    [self setCompressSaves:true];
    [self setPauseOnLoad:true];
    [self setPauseOnSave:false];
    [self setAutoBackupSaves:false];
    [self setVolume:255];
    [self setKeybindings:kbDefault];
    [self setAutosave:asDisabled];
    [self setCFPSCap:@"100"];
    [self setGFPSCap:@"50"];
    [self setFullscreen:false];
    [self setShowIntro:true];
    [self setShowFPS:false];
    [self setLiquidDepth:false];
    [self setCreatureGraphics:false];
    [self setUseFont:false];
    [self setWindowWidth:@"1280"];
    [self setWindowHeight:@"600"];
    [self setShowIdlers:siTop];
    [self setTileset:tsDefaultTall];
    [self setFont:fDefault];
    [self setSkillRusting:true];
    [self setEmbarkConfirmation:false];
    [self setGrazingAnimals:true];
    [self setPauseOnCaveIns:true];
    [self setExtraShellItems:false];
    [self setPauseOnWarmDampStone:true];
    [self setTemperature:true];
    [self setAquifers:false];
    [self setCaveIns:true];
    [self setInvaders:true];
    [self setWeather:true];
    [self setDwarfCap:@"200"];
    [self setChildHardCap:@"100"];
    [self setChildPercentageCap:@"1000"];
    [self setEmbarkWidth:@"4"];
    [self setEmbarkHeight:@"4"];
}

@end
