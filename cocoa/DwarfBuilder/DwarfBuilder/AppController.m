
#import "AppController.h"
#import "DwarfBuilderSettings.h"

@implementation AppController

@synthesize settings;

-(id)init {
    self = [super init];
    
    if (self) {
#ifdef DEBUG
        NSString *plistFolder = @"/Users/jtomsic/Downloads";
//        NSString *plistFolder = @"/Users/Jason/Downloads";
        NSString *plistFile = [NSString stringWithFormat:@"%@/%@", plistFolder, @"settings.plist"];
        //set path to downloads directory
#else
        //set path to bundle path
#endif
        
        settings = [[DwarfBuilderSettings alloc] init];
        [settings writeSettingsToFile:plistFile];
        [self processInitTxt];
    }
    
    return self;
}

//copying folders and files [NSFileManager copyItemAtPath: toPath: error:]

//stackoverflow.com/questions/491809/best-way-to-copy-or-move-files-with-objective-c
//developer.apple.com/library/mac/#documentation/Cocoa/Reference/Foundation/Classes/NSFileManager_Class/Reference/Reference.html#//apple_ref/occ/instm/NSFileManager/copyItemAtPath:toPath:error:

-(void)processInitTxt {
#ifdef DEBUG
    NSString *devFolder = @"/Users/jtomsic/Downloads/dwarf-builder";
//    NSString *devFolder = @"/Users/Jason/devel/dwarf-builder";
    NSString *initTxtFile = [NSString stringWithFormat:@"%@/%@", devFolder, @"vanilla/data/init/init.txt"];
#else
    //set path to bundle path
#endif
    
    NSString *initContents = [NSString stringWithContentsOfFile:initTxtFile encoding:NSUTF8StringEncoding error:nil];
    NSArray *initLines = [initContents componentsSeparatedByString:@"\r\n"];
    
    NSString *newInitContents;
    NSMutableArray *newInitLines = [[NSMutableArray alloc] init];
    
    NSEnumerator *lineReader = [initLines objectEnumerator];
    NSString *line;
    
    while (line = [lineReader nextObject]) {
        if ([line rangeOfString:@"[INTRO"].location != NSNotFound) {
            [newInitLines addObject:@"[INTRO:NO]"];
        } else if ([line rangeOfString:@"[SOUND"].location != NSNotFound) {
            [newInitLines addObject:@"[SOUND:0]"];
        //etc etc etc
        } else {
            [newInitLines addObject:line];
        }
    }
    
    newInitContents = [newInitLines componentsJoinedByString:@"\r\n"];
    NSLog(@"%@", newInitContents);
}

@end
