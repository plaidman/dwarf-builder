
#import "AppController.h"
#import "DwarfBuilderSettings.h"

@implementation AppController

@synthesize settings;

-(id)init {
    self = [super init];
    
    if (self) {
        settings = [[DwarfBuilderSettings alloc] init];
        [settings writeSettingsToFile:@"/blah.plist"];
    }
    
    return self;
}

@end
