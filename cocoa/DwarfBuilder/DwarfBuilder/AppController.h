
#import <Foundation/Foundation.h>
@class DwarfBuilderSettings;

@interface AppController : NSObject {
    DwarfBuilderSettings *settings;
}

@property DwarfBuilderSettings *settings;

-(void)processInitTxt;

@end
