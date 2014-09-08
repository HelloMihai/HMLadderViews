//
//  HMLadderViews.m
//  TodayMenuSlides
//
//  Created by Hello Mihai on 9/6/14.
//  Available under the MIT License. See the LICENSE file for more.
//

#import "HMLadderViews.h"
#import "HMBasicAnimation.h"

static NSTimeInterval const ANIMATION_TIME_TO_CENTER = 0.5;
static NSTimeInterval const ANIMATION_TIME_TO_EDGE = ANIMATION_TIME_TO_CENTER * 1.5;
static CGFloat const EDGE_SCALE = 0.4;
static CGFloat const ALPHA_STEP = 0.3;

@interface HMLadderViews ()
@property (strong, nonatomic) UIView* holder;
@property (strong, nonatomic) UIButton* itemButtonTop;
@property (strong, nonatomic) UIButton* itemButtonBottom;
@property (strong, nonatomic) NSArray* views;
@property (nonatomic) int currentViewIndex;
@property (nonatomic) CGSize windowSize;
@property (nonatomic) float offsetTop;
@property (nonatomic) float offsetBottom;
@property (nonatomic) BOOL useTopNavButton;
@property (nonatomic) BOOL useBottomNavButton;
@property (nonatomic) BOOL fadeViewsOutOfCenter;
@end

@implementation HMLadderViews

#pragma mark : accessors

- (CGSize)windowSize
{
    if (CGSizeEqualToSize(_windowSize, CGSizeZero)) // not set
        _windowSize = [[UIApplication sharedApplication] keyWindow].frame.size;
    return _windowSize;
}

- (UIButton*)itemButtonBottom
{
    if (!_itemButtonBottom) {
        _itemButtonBottom = [UIButton buttonWithType:UIButtonTypeRoundedRect]; //[[UIButton alloc] init];
        [_itemButtonBottom addTarget:self action:@selector(showNext) forControlEvents:UIControlEventTouchUpInside];
    }
    return _itemButtonBottom;
}

- (UIButton*)itemButtonTop
{
    if (!_itemButtonTop) {
        _itemButtonTop = [UIButton buttonWithType:UIButtonTypeRoundedRect]; //[[UIButton alloc] init];
        [_itemButtonTop addTarget:self action:@selector(showPrevious) forControlEvents:UIControlEventTouchUpInside];
    }
    return _itemButtonTop;
}

#pragma public

- (instancetype)initWithViews:(NSArray*)views
                    andHolder:(UIView*)holder
                 andTopOffset:(CGFloat)topOffset
              andBottomOffset:(CGFloat)bottomOffset
              useTopNavButton:(BOOL)useTopNavButton
           useBottomNavButton:(BOOL)useBottomNavButton
         fadeViewsOutOfCenter:(BOOL)fadeViewsOutOfCenter
       useSwipesForNavigation:(BOOL)useSwipesForNavigation
{
    if (self = [super init]) {
        self.holder = holder;
        self.views = views;
        self.offsetTop = topOffset;
        self.offsetBottom = bottomOffset;
        self.useTopNavButton = useTopNavButton;
        self.useBottomNavButton = useBottomNavButton;
        self.fadeViewsOutOfCenter = fadeViewsOutOfCenter;

        [holder addSubview:self.itemButtonTop];
        [holder addSubview:self.itemButtonBottom];

        if (useSwipesForNavigation) {
            UISwipeGestureRecognizer* swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureSwipeUp:)];
            UISwipeGestureRecognizer* swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureSwipeDown:)];
            swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
            swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
            [holder addGestureRecognizer:swipeUp];
            [holder addGestureRecognizer:swipeDown];
        }
    }
    return self;
}

- (void)showViewIndex:(int)index
{
    [self showViewIndex:index withAnimationTime:ANIMATION_TIME_TO_EDGE];
}

- (void)showViewIndex:(int)index withAnimationTime:(NSTimeInterval)animationTime
{
    if ([self indexIsValid:index]) {
        self.currentViewIndex = index;

        self.itemButtonTop.hidden = YES;
        self.itemButtonBottom.hidden = YES;

        // instances
        CGFloat xCoord = self.windowSize.width / 2;
        CGFloat wHeight = self.windowSize.height;

        UIView* view;
        CGPoint coords = CGPointMake(xCoord, 0);
        BOOL firstAtEdge = true;
        CGFloat priorViewEdgeY = 0;
        CGFloat viewScaledHeightHalf;
        CGFloat alpha = 1;

        // move to center
        view = [self.views objectAtIndex:index];
        coords.y = wHeight / 2;
        [self animateView:view toCoods:coords withTime:animationTime withScale:1 withAlpha:alpha];

        // align above
        for (int i = index - 1; i >= 0; i--) {
            view = [self.views objectAtIndex:i];
            viewScaledHeightHalf = [self viewScaledHeight:view] / 2;
            if (firstAtEdge) {
                coords.y = self.offsetTop + viewScaledHeightHalf;
                if (self.useTopNavButton)
                    [self setTopButtonToView:view atCoords:coords];
            } else {
                coords.y = priorViewEdgeY - viewScaledHeightHalf; // move off screen
            }
            firstAtEdge = false;
            priorViewEdgeY = coords.y - viewScaledHeightHalf;
            alpha = self.fadeViewsOutOfCenter ? alpha - ALPHA_STEP : 1;
            [self animateView:view toCoods:coords withTime:animationTime withScale:EDGE_SCALE withAlpha:alpha];
        }

        // align bottom
        firstAtEdge = true;
        alpha = 1;
        for (int i = index + 1; i < [self.views count]; i++) {
            view = [self.views objectAtIndex:i];
            viewScaledHeightHalf = [self viewScaledHeight:view] / 2;
            if (firstAtEdge) {
                coords.y = wHeight - viewScaledHeightHalf - self.offsetBottom;
                if (self.useBottomNavButton)
                    [self setBottomButtonToView:view atCoords:coords];
            } else {
                coords.y = priorViewEdgeY + viewScaledHeightHalf; // move off screen
            }
            firstAtEdge = false;
            priorViewEdgeY = coords.y + viewScaledHeightHalf;
            alpha = self.fadeViewsOutOfCenter ? alpha - ALPHA_STEP : 1;
            [self animateView:view toCoods:coords withTime:animationTime withScale:EDGE_SCALE withAlpha:alpha];
        }
    }
}

- (void)showNext
{
    if (self.currentViewIndex + 1 >= [self.views count]) // reached the limit
        [self bounceCurrentView:-20];
    else
        [self showViewIndex:self.currentViewIndex + 1];
}

- (void)showPrevious
{
    if (self.currentViewIndex - 1 < 0)
        [self bounceCurrentView:20];
    else
        [self showViewIndex:self.currentViewIndex - 1];
}

- (void)bounceCurrentView:(CGFloat)yOffset
{
    UIView* view = [self.views objectAtIndex:self.currentViewIndex];
    CGFloat originalY = view.center.y;
    CGFloat toY = originalY + yOffset;
    NSTimeInterval duration = 0.3;
    [HMBasicAnimation animate:view.layer toValue:@(toY) duration:duration delaySeconds:0.0 keyPath:HMBasicAnimation_POSITION_Y withEase:HMBasicAnimation_EASING_EASE_IN_OUT];
    [HMBasicAnimation animate:view.layer toValue:@(originalY) duration:duration / 2 delaySeconds:duration keyPath:HMBasicAnimation_POSITION_Y withEase:HMBasicAnimation_EASING_EASE_IN_OUT];
}

#pragma helpers

- (void)gestureSwipeUp:(UISwipeGestureRecognizer*)recognizer
{
    [self showNext];
}

- (void)gestureSwipeDown:(UISwipeGestureRecognizer*)recognizer
{
    [self showPrevious];
}

- (CGFloat)viewScaledHeight:(UIView*)view
{
    CGFloat yScale = view.transform.d;
    return (yScale == 1) ? view.frame.size.height * EDGE_SCALE : view.frame.size.height;
}

- (CGFloat)viewFullNotScaledHeight:(UIView*)view
{
    CGFloat yScale = view.transform.d;
    return (yScale == 1) ? view.frame.size.height : view.frame.size.height / EDGE_SCALE;
}

- (void)setBottomButtonToView:(UIView*)view atCoords:(CGPoint)coords
{
    UIButton* button = self.itemButtonBottom;
    button.hidden = NO;
    button.frame = CGRectMake(0,
                              coords.y - [self viewScaledHeight:view] / 2,
                              self.windowSize.width,
                              self.offsetBottom + [self viewScaledHeight:view]);
}

- (void)setTopButtonToView:(UIView*)view atCoords:(CGPoint)coords
{
    UIButton* button = self.itemButtonTop;
    button.hidden = NO;
    button.frame = CGRectMake(0,
                              0,
                              self.windowSize.width,
                              self.offsetTop + [self viewScaledHeight:view]);
}

- (void)animateView:(UIView*)view
            toCoods:(CGPoint)coords
           withTime:(NSTimeInterval)time
          withScale:(CGFloat)scale
          withAlpha:(CGFloat)alpha
{
    if (alpha < 0)
        alpha = 0;
    void (^animate)(id toValue, NSString * key) = ^void(id toValue, NSString* key) {
            [HMBasicAnimation animate:view.layer toValue:toValue duration:time delaySeconds:0 keyPath:key withEase:HMBasicAnimation_EASING_EASE_IN_OUT];
    };
    animate(@(coords.x), HMBasicAnimation_POSITION_X);
    animate(@(coords.y), HMBasicAnimation_POSITION_Y);
    animate(@(scale), HMBasicAnimation_SCALE_Y);
    animate(@(alpha), HMBasicAnimation_OPACITY);
}

- (BOOL)indexIsValid:(int)index
{
    return (0 <= index && index < [self.views count]);
}

@end
