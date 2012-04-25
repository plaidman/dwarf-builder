//
//  DwarfBuilderSettings.m
//  DwarfBuilder
//
//  Created by Tomsic, Jason on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DwarfBuilderSettings.h"

@implementation DwarfBuilderSettings

@synthesize enableSound, extendedOST, compressSaves, 
    pauseOnLoad, pauseOnSave, autoBackupSaves;
@synthesize volume, keybindings, autosave;
@synthesize cFPSCap, gFPSCap;

@synthesize fullscreen, showIntro, showFPS,
    showDepth, creatureGraphics, useFont;
@synthesize windowWidth, windowHeight;
@synthesize showIdlers, tileset, font;

@synthesize skillRust, embarkWarning, grazingAnimals,
    pauseOnCaveIns, extraShellItems, pauseOnWarmDampStone, 
    temperature, aquifers, caveIns, invaders, weather;
@synthesize dwarfCap, childHardCap, childPercentageCap,
    embarkWidth, embarkHeight;

-(id)init {
    self = [super init];
    
    if (self) {
        self.enableSound = true;
        self.windowHeight = @"600";
        
        NSArray *array = [NSArray arrayWithObjects:@"enableSound", @"windowHeight", nil];
        NSDictionary *dict = [self dictionaryWithValuesForKeys:array];
        
        NSLog(@"%@", dict);
    }
    
    return self;
}

@end
