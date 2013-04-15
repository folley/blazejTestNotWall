//
//  BBAppDelegate.h
//  NotificationsWall
//
//  Created by Błażej Biesiada on 4/17/12.
//  Copyright (c) 2012 Błażej Biesiada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBWallViewController.h"

@interface BBAppDelegate : UIResponder <
UIApplicationDelegate,
UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIScreen *externalScreen;
@property (strong, nonatomic) UIWindow *externalWindow;
@property (strong, nonatomic) BBWallViewController *wallViewController;

@end
