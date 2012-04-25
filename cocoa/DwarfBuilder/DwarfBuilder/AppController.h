//
//  AppController.h
//  DwarfBuilder
//
//  Created by Tomsic, Jason on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DwarfBuilderSettings;

@interface AppController : NSObject {
    DwarfBuilderSettings *settings;
}

@property (retain) DwarfBuilderSettings *settings;

@end
