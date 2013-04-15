//
//  BBRemoteImage.h
//  NotificationsWall
//
//  Created by Błażej Biesiada on 4/15/13.
//  Copyright (c) 2013 Błażej Biesiada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBRemoteImage : NSObject

@property (nonatomic, readonly) CGSize size;
@property (nonatomic, readonly) UIImage *image;

- (id)initWithURL:(NSURL*)imageURL size:(CGSize)size;
- (void)downloadImageWithCompletionHandler:(void (^)(UIImage *image))success;

@end
