
#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return true;
}

-(void)applicationDidFinishLaunching:(NSNotification *)aNotification {

}

-(void)applicationWillTerminate:(NSNotification *)notification {
    
}

@end
