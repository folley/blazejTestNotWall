//
//  BBWallViewController.m
//  TwitterWall
//
//  Created by Błażej Biesiada on 3/8/12.
//  Copyright (c) 2012 Błażej Biesiada. All rights reserved.
//

#import "BBWallViewController.h"
#import "BBSocialWall.h"
#import "BBTwitterStream.h"
#import "BBMessage.h"
#import "BBMessageCellView.h"
#import "UIImageView+AFNetworking.h"
#import "BBWallView.h"

#define FSLabs CLLocationCoordinate2DMake(50.062785, 19.945987); // aka FS Lab

@interface BBWallViewController ()

@property (strong, nonatomic) BBSocialWall *socialWall;
@property (strong) BBWallView *view;
@property (strong, nonatomic) NSTimer *imageDismissTimer;

- (void)_dismissImage;
- (void)_presentNewImage:(UIImage *)image;

@end

@implementation BBWallViewController

@dynamic view;

- (id)init
{
    if (self = [super init]) {
        // Setup msgs stream
        self.socialWall = [BBSocialWall new];
        BBTwitterStream *twitterStream = [[BBTwitterStream alloc] initWithWall:self.socialWall];
        twitterStream.hashtags = @[@"hackkrk"];
        BBInstagramStream *instagramStream = [[BBInstagramStream alloc] initWithWall:self.socialWall];
        instagramStream.searchRadius = 200;
        instagramStream.coordinates = FSLabs;
        self.socialWall.feeds = [NSMutableSet setWithObjects:twitterStream, instagramStream, nil];

        [self.socialWall addObserver:self
                          forKeyPath:@"streamMessages"
                             options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionPrior
                             context:nil];
        [self.socialWall start];
        
        // Setup timer movie
        NSString *timerMoviePath = [[NSBundle mainBundle] pathForResource:@"zegar15min_iOS" ofType:@"m4v"];
        self.movieController = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:timerMoviePath]];
        self.movieController.controlStyle = MPMovieControlStyleNone;
        self.movieController.shouldAutoplay = NO;
        [self.movieController prepareToPlay];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dismissTimerMovie)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:self.movieController];
    }
    return self;
}

- (void)dealloc
{
    [self.socialWall removeObserver:self forKeyPath:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSKeyValueChange kind = [[change objectForKey:NSKeyValueChangeKindKey] intValue];
    BOOL isPrior = [[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue];
    
    if ([keyPath isEqualToString:@"streamMessages"]) {
        NSIndexSet *indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
        
        if (isPrior == NO) {
            NSMutableArray *indexPathSet = [[NSMutableArray alloc] initWithCapacity:[indexSet count]];
            [indexSet enumerateIndexesUsingBlock: ^(NSUInteger idx, BOOL *stop) {
                [indexPathSet addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
            }];
            
            switch (kind) {
                case NSKeyValueChangeInsertion:
                    [self.view.tableView insertRowsAtIndexPaths:indexPathSet
                                               withRowAnimation:UITableViewRowAnimationTop];
                    break;
                case NSKeyValueChangeRemoval:
                    [self.view.tableView deleteRowsAtIndexPaths:indexPathSet
                                               withRowAnimation:UITableViewRowAnimationBottom];
                    break;
                default:
                    break;
            }
        }
    }    
}

- (void)loadView
{
    self.view = [[BBWallView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    self.view.tableView.delegate = self;
    self.view.tableView.dataSource = self;
}

- (void)playTimerMovie
{
    if (![self isPlayingTimerMovie]) {
        self.movieController.view.frame = self.view.bounds;
        self.movieController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.movieController.view.hidden = NO;
        
        [UIView transitionWithView:self.view
                          duration:0.8
                           options:UIViewAnimationOptionTransitionFlipFromTop
                        animations: ^ {
                            [self.view addSubview:self.movieController.view];
                        }
                        completion: ^ (BOOL finished) {
                            [self.movieController play];
                            
                            [self.socialWall stop];
                        }];
    }
}


- (void)dismissTimerMovie
{
    if ([self isPlayingTimerMovie]) {
        [UIView transitionWithView:self.view
                          duration:0.8
                           options:UIViewAnimationOptionTransitionFlipFromBottom
                        animations: ^ {
                            self.movieController.view.hidden = YES;
                        }
                        completion: ^ (BOOL finished) {
                            [self.movieController.view removeFromSuperview];
                            [self.movieController stop];
//                            [self.movieController prepareToPlay];
                            
                            [self.socialWall start];
                        }];
    }
}

- (BOOL)isPlayingTimerMovie
{
    return self.movieController.view.superview != nil;
}

- (void)_dismissImage
{
    self.imageDismissTimer = nil;
    [UIView transitionWithView:self.view
                      duration:0.4
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations: ^ {
                        self.view.imageView.hidden = YES;
                    }
                    completion:nil];
}

- (void)_presentNewImage:(UIImage *)image
{
    if (![self isPlayingTimerMovie]) {
        self.view.imageView.image = image;
        
        [UIView transitionWithView:self.view
                          duration:0.4
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations: ^ {
                            self.view.imageView.hidden = NO;
                        }
                        completion: ^ (BOOL finished) {
                            [self.imageDismissTimer invalidate];
                            self.imageDismissTimer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                                                      target:self
                                                                                    selector:@selector(_dismissImage)
                                                                                    userInfo:nil
                                                                                     repeats:NO];
                        }];
    }
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.socialWall.streamMessages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    BBMessageCellView *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[BBMessageCellView alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:cellIdentifier];
    }
    
    BBMessage *msg =  [self.socialWall.streamMessages objectAtIndex:indexPath.row];
    cell.contentLabel.text = msg.text;
    cell.author = msg.author;
    cell.avatarImageView.image = nil;
    cell.showContentImagePlaceholder = msg.attachedImage != nil;
    [msg.attachedImage downloadImageWithCompletionHandler:^(UIImage *image) {
        cell.contentImage = image;
        [self _presentNewImage:image];
    }];
    
    if ([msg.author isEqualToString:@"_bejo"]) {
        if ([msg.text rangeOfString:@"break" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self playTimerMovie];
            });
        }
    }
    
    switch (msg.sourceType) {
        case BBMessageTwitterFeed:
            cell.sourceImageView.image = [UIImage imageNamed:@"twitter_icon"];
            break;
        case BBMessageInstagramFeed:
            cell.sourceImageView.image = [UIImage imageNamed:@"instagram_icon"];
            break;
        default:
            cell.sourceImageView.image = nil;
            break;
    }
    
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:msg.authorAvatarURL]];
    
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BBMessage *msg = [self.socialWall.streamMessages objectAtIndex:indexPath.row];
    return [BBMessageCellView heightForWidth:tableView.bounds.size.width
                                 contentText:msg.text
                            contentImageSize:msg.attachedImage.size];
}

@end
