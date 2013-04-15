//
//  BBSocialWall.h
//  NotificationsWall
//
//  Created by Błażej Biesiada on 4/18/12.
//  Copyright (c) 2012 Błażej Biesiada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBInstagramStream.h"
#import "BBTwitterStream.h"

@interface BBSocialWall : NSObject

@property (strong, nonatomic) NSArray *streamMessages;
@property (strong, nonatomic) NSMutableSet *feeds;

- (void)start;
- (void)stop;
- (void)insertMessage:(id)msg atIndex:(NSUInteger)index;
- (void)removeMessageAtIndex:(NSUInteger)index;
- (void)removeMessagesInRange:(NSRange)range;
- (void)removeOldestMessagesIfNecessary;

@end
