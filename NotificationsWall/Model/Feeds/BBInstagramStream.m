//
//  BBInstagramStream.m
//  NotificationsWall
//
//  Created by Błażej Biesiada on 4/19/12.
//  Copyright (c) 2012 Błażej Biesiada. All rights reserved.
//

#import "BBInstagramStream.h"
#import "BBSocialWall.h"
#import "AFNetworking.h"
#import "AFJSONUtilities.h"
#import "BBInstagramMessage.h"

#define CLIENT_ID       @"27902d08b46a4dfd81f3bea932fece5a"
#define CLIENT_SECRET   @"a5c123362fae4986b4b40e5e5b4968e9"

#define DEFAULT_INTERVAL 8
#define DEFAULT_RADIUS 400
#define DEFAULT_COORDINATES CLLocationCoordinate2DMake(37.3231, -122.0311) // Cupertino

@interface BBInstagramStream ()

@property (strong, nonatomic) AFHTTPClient *instagramSearchClient;
@property (strong, nonatomic) NSDate *lastSearchMaxTimestamp;

- (void)_processSearchResponse:(id)responseObject;

@end

@implementation BBInstagramStream
{
    dispatch_queue_t _backgroundQueue;
}

#pragma mark - <BBSocialWall>

@synthesize refreshInterval;

- (id)initWithWall:(BBSocialWall *)wall
{
    if (self = [super init]) {
        self.wall = wall;
        self.refreshInterval = DEFAULT_INTERVAL;
        self.searchRadius = DEFAULT_RADIUS;
        self.instagramSearchClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"https://api.instagram.com/"]];
        _backgroundQueue = dispatch_queue_create(NULL, NULL);
        self.lastSearchMaxTimestamp = [NSDate dateWithTimeIntervalSinceNow:-3600.0*8.0]; // since last 8hrs
    }
    return self;
}

- (void)startFeed
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:3];
    [parameters setObject:CLIENT_ID forKey:@"client_id"];
	[parameters setObject:[NSNumber numberWithDouble:self.coordinates.latitude] forKey:@"lat"];
	[parameters setObject:[NSNumber numberWithDouble:self.coordinates.longitude] forKey:@"lng"];
	[parameters setObject:[NSNumber numberWithInteger:self.searchRadius] forKey:@"distance"];
	if ([self.lastSearchMaxTimestamp timeIntervalSince1970] > 0) {
		[parameters setObject:[NSNumber numberWithLongLong:(long long)[self.lastSearchMaxTimestamp timeIntervalSince1970]] forKey:@"min_timestamp"];
	}
    
    [self.instagramSearchClient getPath:@"v1/media/search"
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
    [self.instagramSearchClient.operationQueue cancelAllOperations];
}

- (void)_processSearchResponse:(id)responseObject
{
    // parse
    NSError *parseError = nil;
    NSDictionary *responseDict = AFJSONDecode(responseObject, &parseError);
    if (parseError != nil) {
        NSLog(@"PARSE ERROR: %@", parseError);
    }
//    NSLog(@"%@", responseDict);
    
    // deserialize to obj-c
    NSDate *thisSearchMaxTimestamp = self.lastSearchMaxTimestamp;
    NSArray *instagrams = [responseDict objectForKey:@"data"];
    NSUInteger index = 0; // reverse order
    for (NSDictionary *instagramDict in instagrams) {
        BBInstagramMessage *newInstagram = [[BBInstagramMessage alloc] initWithJSONDict:instagramDict];
        
        // save only instagrams that are actually new (avoid duplicates)
        if ([newInstagram.timestamp compare:self.lastSearchMaxTimestamp] == NSOrderedDescending) {
            [self.wall insertMessage:newInstagram atIndex:index++];
            
            if ([newInstagram.timestamp compare:self.lastSearchMaxTimestamp] == NSOrderedDescending) {
                thisSearchMaxTimestamp = newInstagram.timestamp;
            }
        }
    }
    
    self.lastSearchMaxTimestamp = thisSearchMaxTimestamp;
    
//    if ([instagrams count] > 0)
//    {
//        self.lastSearchMaxTimestamp = [self.lastSearchMaxTimestamp dateByAddingTimeInterval:20.0]; // add 20[s] to avoid duplicates (why sooo long Instagram? caches... ?!)
//    }
    
    // remove over-limit messages
    [self.wall removeOldestMessagesIfNecessary];
}

@end
