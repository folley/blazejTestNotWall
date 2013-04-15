//
//  BBSocialWallFeedProtocol.h
//  NotificationsWall
//
//  Created by Błażej Biesiada on 4/14/13.
//  Copyright (c) 2013 Błażej Biesiada. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BBSocialWall;

@protocol BBSocialWallFeedProtocol

@optional
@property (readwrite, assign) NSTimeInterval refreshInterval;

@required
- (id)initWithWall:(BBSocialWall *)wall;
- (void)startFeed;
- (void)stopFeed;

@end
