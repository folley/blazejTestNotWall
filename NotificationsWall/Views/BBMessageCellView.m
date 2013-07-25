//
//  BBMessageCellView.m
//  TwitterWall
//
//  Created by Błażej Biesiada on 3/8/12.
//  Copyright (c) 2012 Future Simple. All rights reserved.
//

#import "BBMessageCellView.h"
#import <QuartzCore/QuartzCore.h>

#define HORIZONTAL_PADDING 16.0
#define VERTICAL_PADDING 16.0
#define ELEMENTS_SPACING 16.0
#define AVATAR_SIZE 128.0

@interface BBMessageCellView ()

+ (UIFont *)_authorFont;
+ (UIFont *)_contentFont;
+ (CGFloat)_contentPhotoWidthForCellWidth:(CGFloat)width;

@property (nonatomic, readwrite, strong) UIImageView *avatarImageView;
@property (nonatomic, readwrite, strong) UIImageView *sourceImageView;
@property (nonatomic, readwrite, strong) UILabel *authorLabel;
@property (nonatomic, readwrite, strong) UILabel *contentLabel;
@property (nonatomic, readwrite, strong) UIImageView *contentImageView;

@end

@implementation BBMessageCellView

- (UIImage *)contentImage
{
    return self.contentImageView.image;
}

- (void)setContentImage:(UIImage *)contentImage
{
    if (self.contentImageView.image != contentImage) {
        self.contentImageView.image = contentImage;
        self.contentImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self setNeedsDisplay];
    }
}

- (BOOL)showContentImagePlaceholder
{
    return self.contentImageView.image != nil;
}

- (void)setShowContentImagePlaceholder:(BOOL)showContentImagePlaceholder
{
    if (self.showContentImagePlaceholder != showContentImagePlaceholder) {
        UIImage *placeholderImage = [UIImage imageNamed:@"photo-placeholder.jpg"];
        
        if (showContentImagePlaceholder) {
            self.contentImageView.image = placeholderImage;
            self.contentImageView.contentMode = UIViewContentModeCenter;
            self.contentImageView.clipsToBounds = YES;
        }
        else {
            self.contentImageView.image = nil;
        }
        
        [self setNeedsDisplay];
    }
}

- (void)setAuthor:(NSString *)author
{
    if ( ! [self.authorLabel.text isEqualToString:author]) {
        self.authorLabel.text = author;
        [self setNeedsDisplay];
    }
}

#pragma mark - UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(HORIZONTAL_PADDING,
                                                                             VERTICAL_PADDING,
                                                                             AVATAR_SIZE,
                                                                             AVATAR_SIZE)];
        self.avatarImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.avatarImageView.layer.cornerRadius = 8.0;
        self.avatarImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.avatarImageView];
        
        self.authorLabel = [UILabel new];
        self.authorLabel.font = [BBMessageCellView _authorFont];
        [self.contentView addSubview:self.authorLabel];
        
        self.contentLabel = [UILabel new];
        self.contentLabel.font = [BBMessageCellView _contentFont];
        self.contentLabel.contentMode = UIViewContentModeTop;
        self.contentLabel.numberOfLines = 0;
        [self.contentView addSubview:self.contentLabel];
        
        self.sourceImageView = [UIImageView new];
        [self.contentView addSubview:self.sourceImageView];
        
        self.contentImageView = [UIImageView new];
        [self.contentView addSubview:self.contentImageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = self.contentView.bounds;
    
    UIImage *image = self.contentImageView.image;
    CGRect contentImageFrame = CGRectZero;
    if (image) {
        contentImageFrame = CGRectMake(NAN,
                                       VERTICAL_PADDING,
                                       [[self class] _contentPhotoWidthForCellWidth:self.frame.size.width],
                                       bounds.size.height-2*VERTICAL_PADDING);
        contentImageFrame.origin.x = bounds.size.width-(contentImageFrame.size.width+HORIZONTAL_PADDING);
        self.contentImageView.frame = contentImageFrame;
    }
    
//    self.authorLabel.backgroundColor = [UIColor greenColor];
    CGRect authorLabelFrame = CGRectMake(HORIZONTAL_PADDING+AVATAR_SIZE+ELEMENTS_SPACING,
                                         VERTICAL_PADDING,
                                         [self.authorLabel.text sizeWithFont:self.authorLabel.font].width,
                                         self.authorLabel.font.lineHeight);
    self.authorLabel.frame = authorLabelFrame;
    
    CGRect sourceImageFrame = CGRectMake(authorLabelFrame.origin.x+authorLabelFrame.size.width+ELEMENTS_SPACING,
                                         NAN,
                                         32.0,
                                         32.0);
    sourceImageFrame.origin.y = authorLabelFrame.origin.y + (authorLabelFrame.size.height-sourceImageFrame.size.height)/2.0;
    self.sourceImageView.frame = sourceImageFrame;
    
//    self.contentLabel.backgroundColor = [UIColor redColor];
    CGFloat contentRightMargin = HORIZONTAL_PADDING;
    contentRightMargin += contentImageFrame.size.width > 0 ? ELEMENTS_SPACING + contentImageFrame.size.width : 0;
    CGRect contentLabelFrame = CGRectMake(HORIZONTAL_PADDING+AVATAR_SIZE+ELEMENTS_SPACING,
                                          authorLabelFrame.origin.y+authorLabelFrame.size.height+ELEMENTS_SPACING,
                                          bounds.size.width-(HORIZONTAL_PADDING+AVATAR_SIZE+ELEMENTS_SPACING+contentRightMargin),
                                          NAN);
    contentLabelFrame.size.height = bounds.size.height - VERTICAL_PADDING - contentLabelFrame.origin.y;
    self.contentLabel.frame = contentLabelFrame;
}

//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    UIColor *startColor = [UIColor lightGrayColor];
//    UIColor *endColor = [UIColor grayColor];
//    
//    // draw gradient
//    size_t locationsCount = 2;
//    CGFloat locations[2] = { 0.0, 1.0 };
//    
//    CGFloat colorComponents[8];
//    size_t oneColorSize = 4*sizeof(CGFloat);
//    memcpy(colorComponents, CGColorGetComponents([startColor CGColor]), oneColorSize);
//    memcpy(colorComponents+4, CGColorGetComponents([endColor CGColor]), oneColorSize);
//    
//    CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
//    CGGradientRef glossGradient = CGGradientCreateWithColorComponents(rgbColorspace,
//                                                                      colorComponents,
//                                                                      locations,
//                                                                      locationsCount);
//    
//    CGPoint topCenter = CGPointMake(CGRectGetMidX(rect),
//                                    0.0f);
//    CGPoint bottomCenter = CGPointMake(CGRectGetMidX(rect),
//                                       rect.size.height);
//    CGContextDrawLinearGradient(context,
//                                glossGradient,
//                                topCenter,
//                                bottomCenter,
//                                0);
//    
//    CGGradientRelease(glossGradient);
//    CGColorSpaceRelease(rgbColorspace);
//}

+ (CGFloat)heightForWidth:(CGFloat)width
              contentText:(NSString *)message
         contentImageSize:(CGSize)imageSize
{
    CGFloat imageViewWidth = 0.0;
    CGFloat imageViewTotalHeight = 0.0;
    if ( ! CGSizeEqualToSize(imageSize, CGSizeZero)) {
        CGFloat imageSizeRatio = imageSize.height/imageSize.width;
        imageViewWidth = [self _contentPhotoWidthForCellWidth:width];
        imageViewTotalHeight = imageViewWidth * imageSizeRatio + 2*VERTICAL_PADDING;
    }
    
    CGFloat avatarViewTotalHeight = AVATAR_SIZE+2*VERTICAL_PADDING;
    
    width -= 2*HORIZONTAL_PADDING+AVATAR_SIZE+ELEMENTS_SPACING+imageViewWidth;
    CGFloat textHeight = [message sizeWithFont:[self _contentFont]
                             constrainedToSize:CGSizeMake(width, MAXFLOAT)
                                 lineBreakMode:UILineBreakModeTailTruncation].height;
    
    CGFloat totalTextHeight = textHeight + 2*VERTICAL_PADDING + ELEMENTS_SPACING + [self _authorFont].lineHeight;
    
    return MAX(MAX(totalTextHeight, imageViewTotalHeight), avatarViewTotalHeight);
}

#pragma mark - BBMessageCellView ()

+ (UIFont *)_authorFont
{
    return [UIFont boldSystemFontOfSize:64.0];
}

+ (UIFont *)_contentFont
{
    return [UIFont systemFontOfSize:64.0];
}

+ (CGFloat)_contentPhotoWidthForCellWidth:(CGFloat)width
{
    return 0.2*width;
}

@end
