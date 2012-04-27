
#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

-(void)applicationDidFinishLaunching:(NSNotification *)aNotification { }

-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return true;
}

@end
