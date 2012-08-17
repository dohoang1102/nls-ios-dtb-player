//
//  DTBPlayerTests.m
//  DTBPlayerTests
//
//  Created by Jason Harwig on 8/6/12.
//  Copyright (c) 2012 Jason Harwig. All rights reserved.
//

#import "DTBPlayerTests.h"
#import "LCAppDelegate.h"

@implementation DTBPlayerTests


- (void)testAppDelegate {
    id delegate = [[UIApplication sharedApplication] delegate];
    NSLog(@"%@", delegate);
    LCAppDelegate *d = delegate;
    NSAssert(delegate != nil, @"delegate exists");
    NSAssert(d.window.rootViewController != nil, @"rootViewController exists");
}
@end
