
#import <Foundation/Foundation.h>
@class DwarfBuilderSettings;

@interface AppController : NSObject {
    DwarfBuilderSettings *settings;
}

@property (retain) DwarfBuilderSettings *settings;

@end
