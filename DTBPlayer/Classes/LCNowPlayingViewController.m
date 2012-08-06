//
//  LCNowPlayingViewController.m
//  DTBPlayer
//
//  Created by Jason Harwig on 8/6/12.
//  Copyright (c) 2012 Jason Harwig. All rights reserved.
//

#import "LCNowPlayingViewController.h"

@interface LCNowPlayingViewController ()

@end

@implementation LCNowPlayingViewController
@synthesize controls;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    controls.frame = CGRectMake(10, self.tabBarController.view.bounds.size.height - controls.bounds.size.height - 40, controls.bounds.size.width - 20, controls.bounds.size.height);
    [self.tabBarController.view addSubview:controls];
}

- (void)viewWillAppear:(BOOL)animated {
    controls.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    controls.hidden = YES;
}

- (void)viewDidUnload {
    [self setControls:nil];
    [super viewDidUnload];
}
@end
