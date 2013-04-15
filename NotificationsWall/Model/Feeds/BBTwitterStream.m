//
//  BBTwitterStream.m
//  NotificationsWall
//
//  Created by Błażej Biesiada on 4/18/12.
//  Copyright (c) 2012 Błażej Biesiada. All rights reserved.
//

#import "BBTwitterStream.h"
#import "BBSocialWall.h"
#import "AFNetworking.h"
#import "AFJSONUtilities.h"
#import "BBTwitterMessage.h"

#define DEFAULT_INTERVAL 8
#define DEFAULT_HASHTAGS @[@"iOS"]

@interface BBTwitterStream ()

@property (strong, nonatomic) AFHTTPClient *twitterSearchClient;
@property (strong, nonatomic) NSNumber *lastSearchID;

- (void)_processSearchResponse:(id)responseObject;

@end

@implementation BBTwitterStream
{
    dispatch_queue_t _backgroundQueue;
}

- (void)dealloc
{
    dispatch_release(_backgroundQueue);
}

#pragma mark - <BBSocialWallFeed>

@synthesize refreshInterval;

- (id)initWithWall:(BBSocialWall *)wall
{
    if (self = [super init]) {
        self.wall = wall;
        self.refreshInterval = DEFAULT_INTERVAL;
        self.hashtags = DEFAULT_HASHTAGS;
        self.twitterSearchClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"https://search.twitter.com/"]];
        _backgroundQueue = dispatch_queue_create(NULL, NULL);
    }
    return self;
}

- (void)startFeed
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:3];
	[parameters setObject:[self.hashtags componentsJoinedByString:@" OR "] forKey:@"q"];
	[parameters setObject:[NSNumber numberWithInteger:10] forKey:@"rpp"];
    [parameters setObject:[NSNumber numberWithBool:YES] forKey:@"include_entities"];
	if ([self.lastSearchID longLongValue] > 0) {
		[parameters setObject:self.lastSearchID forKey:@"since_id"];
	}
    
    [self.twitterSearchClient getPath:@"search.json"
                           parameters:parameters
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [self _processSearchResponse:responseObject];
                                  
                                  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.refreshInterval * NSEC_PER_SEC));
                                  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                      [self startFeed];
                                  });
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [self startFeed]; // ???
                              }];
}

- (void)stopFeed
{
    [self.twitterSearchClient.operationQueue cancelAllOperations];
}

#pragma mark - BBTwitterStream ()

- (void)_processSearchResponse:(id)responseObject
{    
    NSError *parseError = nil;
    NSDictionary *responseDict = AFJSONDecode(responseObject, &parseError);
    if (parseError != nil) {
        NSLog(@"PARSE ERROR: %@", parseError);
    }
//    NSLog(@"%@", responseDict);
    
    self.lastSearchID = [responseDict objectForKey:@"max_id"];
    
    NSArray *twitts = [responseDict objectForKey:@"results"];
    NSUInteger index = 0; // reverse order
    for (NSDictionary *twittDict in twitts) {
        BBTwitterMessage *newTwitt = [[BBTwitterMessage alloc] initWithJSONDict:twittDict];
        [self.wall insertMessage:newTwitt atIndex:index++];
    }
    
    // remove over-limit messages
    [self.wall removeOldestMessagesIfNecessary];
}

@end
