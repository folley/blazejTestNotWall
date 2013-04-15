//
//  BBRemoteImage.m
//  NotificationsWall
//
//  Created by Błażej Biesiada on 4/15/13.
//  Copyright (c) 2013 Błażej Biesiada. All rights reserved.
//

#import "BBRemoteImage.h"
#import "AFNetworking.h"

@interface BBRemoteImage ()

@property (nonatomic, readwrite) CGSize size;
@property (nonatomic, readwrite) UIImage *image;
@property (nonatomic, readwrite) NSURL *_URL;

@end

@implementation BBRemoteImage

- (id)initWithURL:(NSURL*)imageURL size:(CGSize)size
{
    self = [super init];
    
    if (self && imageURL && !CGSizeEqualToSize(size, CGSizeZero)) {
        self.size = size;
        self._URL = imageURL;
    }
    else {
        self = nil;
    }
    
    return self;
}

- (void)downloadImageWithCompletionHandler:(void (^)(UIImage *image))handler
{
    if (self.image) {
        handler(self.image);
    }
    else {
        NSURLRequest *request = [NSURLRequest requestWithURL:self._URL];
        AFImageRequestOperation *requestOperation = [AFImageRequestOperation imageRequestOperationWithRequest:request
                                                                                                      success:^ (UIImage *image)
                                                     {
                                                         self.image = image;
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             handler(image);
                                                         });
                                                     }];
        [requestOperation start];
    }
}

@end
