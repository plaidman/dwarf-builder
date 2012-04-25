//
//  AppController.m
//  DwarfBuilder
//
//  Created by Tomsic, Jason on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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
