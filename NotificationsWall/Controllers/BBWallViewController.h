//
//  BBWallViewController.h
//  TwitterWall
//
//  Created by Błażej Biesiada on 3/8/12.
//  Copyright (c) 2012 Błażej Biesiada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface BBWallViewController : UIViewController <
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, readwrite, strong) MPMoviePlayerController *movieController;

- (void)playTimerMovie;
- (void)dismissTimerMovie;
- (BOOL)isPlayingTimerMovie;

@end
