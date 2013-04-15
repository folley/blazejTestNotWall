//
//  BBMessageCellView.h
//  TwitterWall
//
//  Created by Błażej Biesiada on 3/8/12.
//  Copyright (c) 2012 Future Simple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBMessageCellView : UITableViewCell

+ (CGFloat)heightForWidth:(CGFloat)width
              contentText:(NSString *)message
         contentImageSize:(CGSize)imageSize;

@property (nonatomic, readonly, strong) UIImageView *avatarImageView;
@property (nonatomic, readonly, strong) UIImageView *sourceImageView;
@property (nonatomic, readwrite, strong) NSString *author;
@property (nonatomic, readonly, strong) UILabel *contentLabel;
@property (nonatomic, readwrite) BOOL showContentImagePlaceholder;
@property (nonatomic, readwrite, strong) UIImage *contentImage;

@end
