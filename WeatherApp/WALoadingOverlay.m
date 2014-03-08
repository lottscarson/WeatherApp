//
//  WALoadingOverlay.m
//  WeatherApp
//
//  Created by Scott Larson on 3/7/14.
//  Copyright (c) 2014 SL. All rights reserved.
//

#import "WALoadingOverlay.h"
#import "FBShimmeringView.h"

static CGFloat const kLoadingLabelHeight    = 60.0f;
static CGFloat const kLoadingLabelFontSize  = 40.0f;
static CGFloat const kAnimationDuration     = 0.3f;
static CGFloat const kOverlayAlpha          = 0.7f;

@interface WALoadingOverlay ()
@property (strong, nonatomic) FBShimmeringView *shimmerView;
@end

@implementation WALoadingOverlay

- (id)init
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    self = [super initWithFrame:keyWindow.bounds];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        self.alpha = kOverlayAlpha;
        
        self.shimmerView = [[FBShimmeringView alloc] initWithFrame:CGRectMake(0, (keyWindow.bounds.size.height / 2) - kLoadingLabelHeight, keyWindow.bounds.size.width, kLoadingLabelHeight)];
        
        [self addSubview:self.shimmerView];
        UILabel *loadingLabel = [[UILabel alloc] initWithFrame:self.shimmerView.bounds];
        loadingLabel.textAlignment = NSTextAlignmentCenter;
        loadingLabel.text = NSLocalizedString(@"Loading...", nil);
        loadingLabel.font = [UIFont fontWithName:@"Avenir-Book" size:kLoadingLabelFontSize];
        loadingLabel.textColor = [UIColor lightGrayColor];
        self.shimmerView.contentView = loadingLabel;
    }
    
    return self;
}

- (void)displayOverlay
{
    self.shimmerView.shimmering = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)dismissOverlay
{
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
