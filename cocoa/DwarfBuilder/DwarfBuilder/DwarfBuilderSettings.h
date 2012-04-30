
#import <Foundation/Foundation.h>

@interface DwarfBuilderSettings : NSObject {
    NSArray *propertyNames;
    
    /* APPLICATION OPTIONS */
    bool enableSound, extendSoundtk, compressSaves, pauseOnLoad, pauseOnSave, autoBackupSaves;
    NSString *cFPSCap, *gFPSCap;
    int volume, keybindings, autosave;
    
    /* VISUAL SETTINGS */
    bool fullscreen, showIntro, showFPS, liquidDepth, creatureGraphics, useFont, resizable;
    NSString *windowWidth, *windowHeight;
    int showIdlers, tileset, font;
    
    /* GAMEPLAY SETTINGS */
    bool skillRusting, embarkConfirmation, grazingAnimals, pauseOnCaveIns, extraShellItems, pauseOnWarmDampStone,
         temperature, aquifers, caveIns, invaders, weather;
    NSString *dwarfCap, *childHardCap, *childPercentageCap, *embarkWidth, *embarkHeight;
}

@property NSArray *propertyNames;

/* APPLICATION OPTIONS */
@property bool enableSound, extendSoundtk, compressSaves, pauseOnLoad, pauseOnSave, autoBackupSaves;
@property NSString *cFPSCap, *gFPSCap;
@property int volume, keybindings, autosave;

/* VISUAL SETTINGS */
@property bool fullscreen, showIntro, showFPS, liquidDepth, creatureGraphics, useFont, resizable;
@property NSString *windowWidth, *windowHeight;
@property int showIdlers, tileset, font;

/* GAMEPLAY SETTINGS */
@property bool skillRusting, embarkConfirmation, grazingAnimals, pauseOnCaveIns, extraShellItems,
    pauseOnWarmDampStone, temperature, aquifers, caveIns, invaders, weather;
@property NSString *dwarfCap, *childHardCap,
    *childPercentageCap, *embarkWidth, *embarkHeight;

enum {kbDefault = 0, kbLaptop};
enum {asDisabled = 0, asSeasonal, asYearly};
enum {siTop = 0, siBottom, siDisabled};
enum {tsDefaultTall = 0, tsIronhand, tsPhoebus, tsJollySquare, tsJollyTall, tsMayday, tsDefaultSquare};
enum {fDefault = 0, fIronhand, fPhoebus, fMasterwork, fTuffy};

-(void)writeSettingsToFile:(NSString*)filename;
-(void)readSettingsFromFile:(NSString*)filename;

-(void)setPlaidmanDefaults;
-(void)setDFDefaults;

@end
