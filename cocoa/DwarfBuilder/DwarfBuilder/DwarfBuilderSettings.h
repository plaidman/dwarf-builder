
#import <Foundation/Foundation.h>

@interface DwarfBuilderSettings : NSObject {
    NSArray *propertyNames;
    NSString *dbSettingsVersion, *dbCurrentVersion, *dfCurrentVersion;
    
    /* APPLICATION SETTINGS */
    bool enableSound, extendSoundtk, compressSaves, pauseOnLoad, pauseOnSave, autoBackupSaves;
    NSString *pFPSCap, *gFPSCap;
    int volume, keybindings, autosave;
    
    /* VISUAL SETTINGS */
    bool fullscreen, showIntro, showFPS, liquidDepth, creatureGraphics, useFont, resizable,
        useTilesetColors, variedGroundTiles;
    NSString *windowWidth, *windowHeight;
    int showIdlers, tileset, font, colors;
    
    /* GAMEPLAY SETTINGS */
    bool skillRusting, embarkConfirmation, grazingAnimals, pauseOnCaveIns, extraShellItems,
        pauseOnWarmDampStone, temperature, aquifers, caveIns, invaders, weather, petCoffins;
    NSString *dwarfCap, *childHardCap, *childPercentageCap, *embarkWidth, *embarkHeight;
    
    /* FILE SETTINGS */
    bool backupExternally, externalSaveDir, externalDFDir;
    NSString *installDir;
}

@property NSArray *propertyNames;
@property NSString *dbSettingsVersion, *dbCurrentVersion, *dfCurrentVersion;

/* APPLICATION SETTINGS */
@property bool enableSound, extendSoundtk, compressSaves, pauseOnLoad, pauseOnSave, autoBackupSaves;
@property NSString *pFPSCap, *gFPSCap;
@property int volume, keybindings, autosave;

/* VISUAL SETTINGS */
@property bool fullscreen, showIntro, showFPS, liquidDepth, creatureGraphics, useFont, resizable,
    useTilesetColors, variedGroundTiles;
@property NSString *windowWidth, *windowHeight;
@property int showIdlers, tileset, font, colors;

/* GAMEPLAY SETTINGS */
@property bool skillRusting, embarkConfirmation, grazingAnimals, pauseOnCaveIns, extraShellItems,
    pauseOnWarmDampStone, temperature, aquifers, caveIns, invaders, weather, petCoffins;
@property NSString *dwarfCap, *childHardCap, *childPercentageCap, *embarkWidth, *embarkHeight;

/* FILE SETTINGS */
@property bool backupExternally, externalSaveDir, externalDFDir;
@property NSString *installDir;

enum {kbDefault = 0, kbLaptop};
enum {asDisabled = 0, asSeasonal, asYearly};
enum {siTop = 0, siBottom, siDisabled};
enum {tsDefaultTall = 0, tsPhoebus, tsJollySquare, tsJollyTall, tsMayday, tsDefaultSquare, tsVherid};
enum {fDefault = 0, fPhoebus, fMasterwork, fTuffy};
enum {cDefault = 0, cDefaultPlus, cJolly, cJollyWarm, cKremlin, cMatrix, cMayday, cNatural, cNES, cPhoebus,
    cPlagueWarm, cWarm, cWasteland};

-(void)writeSettingsToFile:(NSString*)filename;
-(void)readSettingsFromFile:(NSString*)filename;

-(void)setPlaidmanDefaults;
-(void)setDFDefaults;

@end
