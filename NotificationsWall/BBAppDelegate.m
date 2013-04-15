//
//  BBAppDelegate.m
//  NotificationsWall
//
//  Created by Błażej Biesiada on 4/17/12.
//  Copyright (c) 2012 Błażej Biesiada. All rights reserved.
//

#import "BBAppDelegate.h"
#import "BBSettingsViewController.h"

@interface BBAppDelegate ()

- (void)_screenDidConnect;
- (void)_screenDidDisconnect;
- (void)_findAndInitExternalDisplay;

@end

@implementation BBAppDelegate

@synthesize window = _window;
@synthesize externalScreen = _externalScreen;
@synthesize externalWindow = _externalWindow;
@synthesize wallViewController = _wallViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Create main (internal) window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [BBSettingsViewController new];
    [self.window makeKeyAndVisible];
    
    // Create external display window
    self.externalWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    self.externalWindow.hidden = YES;
    
    // Don't turn off the app automatically
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_screenDidConnect)
                                                 name:UIScreenDidConnectNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_screenDidDisconnect)
                                                 name:UIScreenDidDisconnectNotification
                                               object:nil];
    
    // if an external screen is already connect find it
    [self _findAndInitExternalDisplay];
    
    return YES;
}

#pragma mark - BBAppDelegate ()

- (void)_screenDidConnect
{
    [self _findAndInitExternalDisplay];
}

- (void)_screenDidDisconnect
{
    self.wallViewController = nil;
    self.externalWindow = nil;
    self.externalScreen = nil;
}

- (void)_findAndInitExternalDisplay
{
    if (self.externalScreen == nil && [[UIScreen screens] count] > 1) {
        self.externalScreen = [[UIScreen screens] objectAtIndex:1];
        
        // Allow user to choose from available screen-modes (pixel-sizes).
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"External Display Size" 
                                                        message:@"Choose a size for the external display." 
                                                       delegate:self 
                                              cancelButtonTitle:nil 
                                              otherButtonTitles:nil];
        for (UIScreenMode *mode in self.externalScreen.availableModes) {
            CGSize modeScreenSize = mode.size;
            [alert addButtonWithTitle:[NSString stringWithFormat:@"%.0f x %.0f pixels", modeScreenSize.width, modeScreenSize.height]];
        }
        [alert show];
    }
}

#pragma mark - <UIAlertViewDelegate>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	UIScreenMode *desiredMode = [self.externalScreen.availableModes objectAtIndex:buttonIndex];
	self.externalScreen.currentMode = desiredMode;
	
	self.externalWindow.screen = self.externalScreen;
	
	CGRect rect = CGRectZero;
	rect.size = desiredMode.size;
	self.externalWindow.frame = rect;
	self.externalWindow.clipsToBounds = YES;
	
	self.externalWindow.hidden = NO;
    self.wallViewController = [BBWallViewController new];
    self.externalWindow.rootViewController = self.wallViewController;
	[self.externalWindow makeKeyAndVisible];
}

@end
