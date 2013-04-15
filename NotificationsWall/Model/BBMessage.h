//
//  BBMessage.h
//  numote_generic
//
//  Created by Błażej Biesiada on 2/16/11.
//  Copyright 2011 Błażej Biesiada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBRemoteImage.h"

#define BBReadJsonObject( obj ) (obj) != [NSNull null] ? (obj) : nil

typedef enum {
    BBMessageUnknownSource = 0,
	BBMessageTwitterFeed,
    BBMessageFacebookFeed,
    BBMessageInstagramFeed
} BBMessageSourceType;

@interface BBMessage : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *textHtmlSafe;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *authorAvatarURL;
@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, strong) BBRemoteImage *attachedImage;
@property (nonatomic, assign) BBMessageSourceType sourceType;

@end
