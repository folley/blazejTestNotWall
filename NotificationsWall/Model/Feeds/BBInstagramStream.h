//
//  BBInstagramStream.h
//  NotificationsWall
//
//  Created by Błażej Biesiada on 4/19/12.
//  Copyright (c) 2012 Błażej Biesiada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBSocialWallFeedProtocol.h"
#import <CoreLocation/CoreLocation.h>

@interface BBInstagramStream : NSObject <BBSocialWallFeedProtocol>

@property (nonatomic) CLLocationCoordinate2D coordinates;
@property (nonatomic) float searchRadius; // in meters
@property (nonatomic, weak) BBSocialWall *wall;

@end
