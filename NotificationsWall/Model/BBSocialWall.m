//
//  BBSocialWall.m
//  NotificationsWall
//
//  Created by Błażej Biesiada on 4/18/12.
//  Copyright (c) 2012 Błażej Biesiada. All rights reserved.
//

#import "BBSocialWall.h"

#define MAX_MESSAGES_COUNT 32

@implementation BBSocialWall

- (id)init
{
    if (self = [super init]) {
        self.streamMessages = [[NSMutableArray alloc] initWithCapacity:MAX_MESSAGES_COUNT+2];
    }
    return self;
}

- (void)start
{
    [self.feeds makeObjectsPerformSelector:@selector(startFeed)];
}

- (void)stop
{
    [self.feeds makeObjectsPerformSelector:@selector(stopFeed)];
}

- (void)insertMessage:(id)msg atIndex:(NSUInteger)index
{
    NSIndexSet *changeSet = [NSIndexSet indexSetWithIndex:index];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:changeSet forKey:@"streamMessages"];
    [(NSMutableArray *)self.streamMessages insertObject:msg atIndex:index];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:changeSet forKey:@"streamMessages"];
}

- (void)removeMessageAtIndex:(NSUInteger)index
{
    NSIndexSet *changeSet = [NSIndexSet indexSetWithIndex:index];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:changeSet forKey:@"streamMessages"];
    [(NSMutableArray *)self.streamMessages removeObjectAtIndex:index];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:changeSet forKey:@"streamMessages"];
}

- (void)removeMessagesInRange:(NSRange)range
{
    NSIndexSet *changeSet = [NSIndexSet indexSetWithIndexesInRange:range];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:changeSet forKey:@"streamMessages"];
    [(NSMutableArray *)self.streamMessages removeObjectsInRange:range];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:changeSet forKey:@"streamMessages"];
}

- (void)removeOldestMessagesIfNecessary
{
	NSUInteger messagesCount = [self.streamMessages count];
	if (messagesCount >= MAX_MESSAGES_COUNT) {
		NSRange indexesToRemoveRange = {MAX_MESSAGES_COUNT, messagesCount-MAX_MESSAGES_COUNT};
        [self removeMessagesInRange:indexesToRemoveRange];
	}
}

@end
