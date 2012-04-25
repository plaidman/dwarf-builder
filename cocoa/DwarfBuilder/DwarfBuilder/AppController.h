//
//  AppController.h
//  DwarfBuilder
//
//  Created by Jason Tomsic on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppController : NSObject

/* VISUAL SETTINGS */
@property (assign) IBOutlet NSButton *fullscreenCheckbox;
@property (assign) IBOutlet NSTextField *windowWidthField;
@property (assign) IBOutlet NSTextField *windowHeightField;

@property (assign) IBOutlet NSMatrix *tilesetRadio;
@property (assign) IBOutlet NSButton *creatureCheckbox;

@property (assign) IBOutlet NSButton *introCheckbox;
@property (assign) IBOutlet NSButton *fPSCheckbox;
@property (assign) IBOutlet NSButton *liquidDepthCheckbox;
@property (assign) IBOutlet NSPopUpButton *idlersPopup;

@property (assign) IBOutlet NSMatrix *fontRadio;
@property (assign) IBOutlet NSButton *fontCheckbox;

/* APPLICATION SETTINGS */
@property (assign) IBOutlet NSBox *soundCheckbox;
@property (assign) IBOutlet NSBox *extendOSTCheckbox;
@property (assign) IBOutlet NSSlider *volumeSlider;

@property (assign) IBOutlet NSMatrix *autosaveRadio;
@property (assign) IBOutlet NSButton *compressSavesCheckbox;
@property (assign) IBOutlet NSButton *pauseOnSaveCheckbox;
@property (assign) IBOutlet NSButton *pauseOnLoadCheckbox;
@property (assign) IBOutlet NSButton *autoBackupSavesCheckbox;

@property (assign) IBOutlet NSTextField *cFPSCapField;
@property (assign) IBOutlet NSTextField *gFPSCapField;

@property (assign) IBOutlet NSMatrix *keybindingsRadio;

/* GAMEPLAY SETTINGS */
@property (assign) IBOutlet NSButton *skillRustCheckbox;
@property (assign) IBOutlet NSButton *embarkWarningCheckbox;
@property (assign) IBOutlet NSButton *grazingAnimalCheckbox;
@property (assign) IBOutlet NSButton *pauseCaveinCheckbox;
@property (assign) IBOutlet NSButton *extraShellCheckbox;
@property (assign) IBOutlet NSButton *pauseWarmDampCheckbox;
@property (assign) IBOutlet NSButton *temperatureCheckbox;
@property (assign) IBOutlet NSButton *aquiferCheckbox;
@property (assign) IBOutlet NSButton *caveinCheckbox;
@property (assign) IBOutlet NSButton *invaderCheckbox;
@property (assign) IBOutlet NSButton *weatherCheckbox;

@property (assign) IBOutlet NSTextField *dwarfCapField;
@property (assign) IBOutlet NSTextField *childHardCapField;
@property (assign) IBOutlet NSTextField *childPercentCapField;

@property (assign) IBOutlet NSTextField *embarkWidthField;
@property (assign) IBOutlet NSTextField *embarkHeightField;

/* FILE SETTINGS */

@end
