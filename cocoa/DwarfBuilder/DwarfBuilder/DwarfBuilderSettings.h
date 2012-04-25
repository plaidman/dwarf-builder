//
//  DwarfBuilderSettings.h
//  DwarfBuilder
//
//  Created by Tomsic, Jason on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DwarfBuilderSettings : NSObject {
    /* APPLICATION OPTIONS */
    bool enableSound;
    bool extendedOST;
    bool compressSaves;
    bool pauseOnLoad;
    bool pauseOnSave;
    bool autoBackupSaves;
    
    NSString *cFPSCap;
    NSString *gFPSCap;
    
    NSNumber *volume;
    NSNumber *keybindings;
    NSNumber *autosave;
    
    /* VISUAL SETTINGS */
    bool fullscreen;
    bool showIntro;
    bool showFPS;
    bool showDepth;
    bool creatureGraphics;
    bool useFont;
    
    NSString *windowWidth;
    NSString *windowHeight;
    
    NSNumber *showIdlers;
    NSNumber *tileset;
    NSNumber *font;
    
    /* GAMEPLAY SETTINGS */
    bool skillRust;
    bool embarkWarning;
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

@property bool enableSound, extendedOST, compressSaves,
    pauseOnLoad, pauseOnSave, autoBackupSaves;
@property (retain) NSString *cFPSCap, *gFPSCap;
@property (retain) NSNumber *volume, *keybindings, *autosave;

@property bool fullscreen, showIntro, showFPS,
    showDepth, creatureGraphics, useFont;
@property (retain) NSString *windowWidth, *windowHeight;
@property (retain) NSNumber *showIdlers, *tileset, *font;

@property bool skillRust, embarkWarning, grazingAnimals,
    pauseOnCaveIns, extraShellItems, pauseOnWarmDampStone, 
    temperature, aquifers, caveIns, invaders, weather;
@property (retain) NSString *dwarfCap, *childHardCap,
    *childPercentageCap, *embarkWidth, *embarkHeight;

enum {
    kDefault = 0,
    kLaptop
};

enum {
    asSeasonal = 0,
    asYearly,
    asDisabled
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

@end
