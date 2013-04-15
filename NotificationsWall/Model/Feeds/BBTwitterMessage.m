//
//  BBTwitterMessage.m
//  NotificationsWall
//
//  Created by Błażej Biesiada on 4/18/12.
//  Copyright (c) 2012 Błażej Biesiada. All rights reserved.
//

#import "BBTwitterMessage.h"
#import "AFNetworking.h"

@interface BBTwitterMessage ()

- (NSString *)_unescapeTwitterSpecialCharactersIn:(NSString *)text;
- (NSDate *)_dateFromTwitterDateString:(NSString *)twitterDateString;

@end

@implementation BBTwitterMessage

- (id)initWithJSONDict:(NSDictionary *)msgDict
{
    if (self = [super init]) {
        self.sourceType = BBMessageTwitterFeed;
        
		self.text = [self _unescapeTwitterSpecialCharactersIn:BBReadJsonObject([msgDict objectForKey:@"text"])];
//        self.textHtmlSafe = [self _escapeHtmlUnsafeCharactersIn:newMessage.text];
		self.author = BBReadJsonObject([msgDict objectForKey:@"from_user"]);
		self.authorAvatarURL = BBReadJsonObject([msgDict objectForKey:@"profile_image_url"]);
        self.timestamp = [self _dateFromTwitterDateString:BBReadJsonObject([msgDict objectForKey:@"created_at"])];
        
        // attached objects
        NSDictionary *entities = BBReadJsonObject([msgDict objectForKey:@"entities"]);
        NSArray *media = BBReadJsonObject([entities objectForKey:@"media"]);
        for (NSDictionary *mediaDict in media) {
            NSString *type = BBReadJsonObject([mediaDict objectForKey:@"type"]);
            if ([type isEqualToString:@"photo"]) {
                NSString *imageURL = BBReadJsonObject([mediaDict objectForKey:@"media_url"]);

                if ([imageURL length] > 0) {
                    NSDictionary *sizes = BBReadJsonObject([mediaDict objectForKey:@"sizes"]);
                    NSDictionary *originalSize = BBReadJsonObject([sizes objectForKey:@"orig"]);
                    CGFloat height = [BBReadJsonObject([originalSize objectForKey:@"h"]) floatValue];
                    CGFloat width = [BBReadJsonObject([originalSize objectForKey:@"w"]) floatValue];
                    
                    self.attachedImage = [[BBRemoteImage alloc] initWithURL:[NSURL URLWithString:imageURL]
                                                                       size:CGSizeMake(width, height)];
                    break; // For now download only 1 image per msg
                }
            }
        }
    }
    return self;
}

#pragma mark - BBTwitterMessage ()

- (NSString *)_unescapeTwitterSpecialCharactersIn:(NSString *)text
{
    NSString *result = [text stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    result = [result stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    result = [result stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    return [result stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
}

- (NSDate *)_dateFromTwitterDateString:(NSString *)twitterDateString
{
	static NSDateFormatter *dateFormatter = nil;
    
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setDateStyle:NSDateFormatterNoStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setDateFormat:@"EEE, dd LLL yyyy HH:mm:ss Z"]; // search API
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    }

	return [dateFormatter dateFromString:twitterDateString];
}

@end
