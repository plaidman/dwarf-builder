
#import <Foundation/Foundation.h>

@interface DwarfBuilderSettings : NSObject {
    NSArray *properties;
    
    /* APPLICATION OPTIONS */
    bool enableSound;
    bool extendSoundtk;
    bool compressSaves;
    bool pauseOnLoad;
    bool pauseOnSave;
    bool autoBackupSaves;
    
    NSString *cFPSCap;
    NSString *gFPSCap;
    
    int volume;
    int keybindings;
    int autosave;
    
    /* VISUAL SETTINGS */
    bool fullscreen;
    bool showIntro;
    bool showFPS;
    bool liquidDepth;
    bool creatureGraphics;
    bool useFont;
    
    NSString *windowWidth;
    NSString *windowHeight;
    
    int showIdlers;
    int tileset;
    int font;
    
    /* GAMEPLAY SETTINGS */
    bool skillRusting;
    bool embarkConfirmation;
    bool grazingAnimals;
    bool pauseOnCaveIns;
    bool extraShellItems;
    bool pauseOnWarmDampStone;
    bool temperature;
    bool aquifers;
    bool caveIns;
    bool invaders;
    bool weather;
    
    NSString *dwarfCap;
    NSString *childHardCap;
    NSString *childPercentageCap;
    NSString *embarkWidth;
    NSString *embarkHeight;
}

@property (retain) NSArray *properties;

@property bool enableSound, extendSoundtk, compressSaves,
    pauseOnLoad, pauseOnSave, autoBackupSaves;
@property (retain) NSString *cFPSCap, *gFPSCap;
@property int volume, keybindings, autosave;

@property bool fullscreen, showIntro, showFPS,
    liquidDepth, creatureGraphics, useFont;
@property (retain) NSString *windowWidth, *windowHeight;
@property int showIdlers, tileset, font;

@property bool skillRusting, embarkConfirmation, grazingAnimals,
    pauseOnCaveIns, extraShellItems, pauseOnWarmDampStone, 
    temperature, aquifers, caveIns, invaders, weather;
@property (retain) NSString *dwarfCap, *childHardCap,
    *childPercentageCap, *embarkWidth, *embarkHeight;

enum {
    kbDefault = 0,
    kbLaptop
};

enum {
    asDisabled = 0,
    asSeasonal,
    asYearly
};

enum {
    siTop = 0,
    siBottom,
    siDisabled
};

enum {
    tsDefaultTall = 0,
    tsIronhand,
    tsPhoebus,
    tsJollySquare,
    tsJollyTall,
    tsMayday,
    tsDefaultSquare
};

enum {
    fDefault = 0,
    fIronhand,
    fPhoebus,
    fMasterwork,
    fTuffy
};

-(void)writeSettingsToFile: (NSString*)filename;
-(void)readSettingsFromFile: (NSString*)filename;

-(void)setPlaidmanDefaults;
-(void)setDFDefaults;

@end
