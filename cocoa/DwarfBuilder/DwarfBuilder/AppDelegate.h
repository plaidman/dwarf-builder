
#import <Cocoa/Cocoa.h>
@class DwarfBuilderSettings;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (unsafe_unretained) IBOutlet NSWindow *window;

@property DwarfBuilderSettings *settings;
@property NSFileManager *fileManager;
@property NSString *baseAppDir, *settingsFile;

-(IBAction)constructDFAction:(id)sender;
-(IBAction)constructDTAction:(id)sender;
-(IBAction)constructSSAction:(id)sender;
-(IBAction)setInstallFolderAction:(id)sender;

-(NSString*)boolToInit:(bool)optionValue optionName:(NSString*)optionName;
-(NSString*)intToInit:(int)optionValue optionName:(NSString*)optionName;
-(NSString*)stringToInit:(NSString*)optionValue optionName:(NSString*)optionName;
-(NSString*)embarkToInit:(NSString*)width height:(NSString*)height;
-(NSString*)childToInit:(NSString*)hard percentage:(NSString*)percentage;
-(NSString*)autosaveToInit:(int)option;
-(NSString*)idlersToInit:(int)option;

-(void)linuxCPFromPath:(NSString*)fromPath toPath:(NSString*)toPath;
-(void)translateTextFile:(NSString*)textFile changes:(NSDictionary*)changes;
-(void)translateKeybinds:(NSMutableString*)fileContents bindLabel:(NSString*)bindLabel
                 fromKey:(NSString*)fromKey toKey:(NSString*)toKey;
-(void)addExtraShellItem:(NSMutableString*)fileContents shellItem:(NSString*)shellItem;

-(void)copyVanilla;
-(void)copyTileset;
-(void)processInitTxt;
-(void)processDInitTxt;
-(void)removeAquifers;
-(void)removeGrazing;
-(void)disablePausingWarmDampStone;
-(void)disablePausingCaveIns;
-(void)updateKeybinds;
-(void)disableSkillRusting;
-(void)addExtraShellItems;
-(void)copySoundtrack;
-(void)copyFont;
-(void)addWorldGens;
-(void)copyEmbarkProfiles;
-(void)setupDwarfFortressApp;

@end
