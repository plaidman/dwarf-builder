
#import "AppController.h"
#import "DwarfBuilderSettings.h"

@implementation AppController

@synthesize settings;

-(id)init {
    self = [super init];
    
    if (self) {
        settings = [[DwarfBuilderSettings alloc] init];
    }
    
    return self;
}

@end
