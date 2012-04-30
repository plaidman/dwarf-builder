
#import <Foundation/Foundation.h>
@class DwarfBuilderSettings;

@interface AppController : NSObject {
    DwarfBuilderSettings *settings;
    NSFileManager *fileManager;
    NSString *baseAppDir;
}

@property DwarfBuilderSettings *settings;
@property NSFileManager *fileManager;
@property NSString *baseAppDir;

-(IBAction)constructAction:(id)sender;

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

-(void)constructDwarfFortress;
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
