//
//  BBTwitterStream.h
//  NotificationsWall
//
//  Created by Błażej Biesiada on 4/18/12.
//  Copyright (c) 2012 Błażej Biesiada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBSocialWallFeedProtocol.h"

@class BBSocialWall;

@interface BBTwitterStream : NSObject <BBSocialWallFeedProtocol>

@property (nonatomic, strong) NSArray *hashtags;
@property (nonatomic, weak) BBSocialWall *wall;

@end
