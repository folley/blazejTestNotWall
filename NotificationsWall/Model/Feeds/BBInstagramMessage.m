//
//  BBInstagramMessage.m
//  NotificationsWall
//
//  Created by Błażej Biesiada on 4/19/12.
//  Copyright (c) 2012 Błażej Biesiada. All rights reserved.
//

#import "BBInstagramMessage.h"
#import "AFNetworking.h"

@implementation BBInstagramMessage

- (id)initWithJSONDict:(NSDictionary *)msgDict
{
    if (self = [super init]) {
        self.sourceType = BBMessageInstagramFeed;
        
        NSDictionary *caption = BBReadJsonObject([msgDict objectForKey:@"caption"]);
		self.text = BBReadJsonObject([caption objectForKey:@"text"]);
//        self.textHtmlSafe = [self _escapeHtmlUnsafeCharactersIn:newMessage.text];
        
        NSDictionary *userDict = BBReadJsonObject([msgDict objectForKey:@"user"]);
		self.author = BBReadJsonObject([userDict objectForKey:@"username"]);
		self.authorAvatarURL = BBReadJsonObject([userDict objectForKey:@"profile_picture"]);
        
        NSNumber *createdTime = BBReadJsonObject([msgDict objectForKey:@"created_time"]);
        self.timestamp = [NSDate dateWithTimeIntervalSince1970:[createdTime doubleValue]];
        
        // attached objects
        NSDictionary *images = BBReadJsonObject([msgDict objectForKey:@"images"]);
        NSDictionary *stdRes = BBReadJsonObject([images objectForKey:@"standard_resolution"]);
        NSString *imageURL = BBReadJsonObject([stdRes objectForKey:@"url"]);
        CGFloat height = [BBReadJsonObject([stdRes objectForKey:@"height"]) floatValue];
        CGFloat width = [BBReadJsonObject([stdRes objectForKey:@"width"]) floatValue];
        self.attachedImage = [[BBRemoteImage alloc] initWithURL:[NSURL URLWithString:imageURL]
                                                           size:CGSizeMake(width, height)];
    }
    return self;
}

@end
