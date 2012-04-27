
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
    asSeasonal = 0,
    asYearly,
    asDisabled
};

enum {
    siTop = 0,
    siBottom,
    siDisabled
};

enum {
    tsIronhand = 0,
    tsPhoebus,
    tsJollySquare,
    tsJollyTall,
    tsMayday,
    tsDefaultTall,
    tsDefaultSquare
};

enum {
    fIronhand = 0,
    fPhoebus,
    fMasterwork,
    fTuffy,
    fDefault
};

-(void)writeSettingsToFile: (NSString*)filename;
-(void)readSettingsFromFile: (NSString*)filename;

@end
