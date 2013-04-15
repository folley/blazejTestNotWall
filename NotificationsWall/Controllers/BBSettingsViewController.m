//
//  BBSettingsViewController.m
//  TwitterWall
//
//  Created by Błażej Biesiada on 3/8/12.
//  Copyright (c) 2012 Future Simple. All rights reserved.
//

#import "BBSettingsViewController.h"
#import "BBAppDelegate.h"
#import "BBWallViewController.h"

@implementation BBSettingsViewController

@synthesize appDelegate = _appDelegate;

- (id)init
{
    if (self = [super initWithNibName:@"SettingsView" bundle:nil]) {
        self.appDelegate = (BBAppDelegate *)[UIApplication sharedApplication].delegate;
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)playMovieTapped:(id)sender
{
    [self.appDelegate.wallViewController playTimerMovie];
}

- (IBAction)dismissMovieTapped:(id)sender
{
    [self.appDelegate.wallViewController dismissTimerMovie];
}

@end
