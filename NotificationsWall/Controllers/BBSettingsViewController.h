//
//  BBSettingsViewController.h
//  TwitterWall
//
//  Created by Błażej Biesiada on 3/8/12.
//  Copyright (c) 2012 Future Simple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBAppDelegate;

@interface BBSettingsViewController : UIViewController

@property (weak, nonatomic) BBAppDelegate *appDelegate;

- (IBAction)playMovieTapped:(id)sender;
- (IBAction)dismissMovieTapped:(id)sender;

@end
