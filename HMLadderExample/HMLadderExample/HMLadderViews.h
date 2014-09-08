//
//  HMLadderViews.h
//  TodayMenuSlides
//
//  Created by Hello Mihai on 9/6/14.
//  Available under the MIT License. See the LICENSE file for more.
//

#import <Foundation/Foundation.h>

@interface HMLadderViews : NSObject

- (instancetype)initWithViews:(NSArray*)views
                    andHolder:(UIView*)holder
                 andTopOffset:(CGFloat)topOffset
              andBottomOffset:(CGFloat)bottomOffset;
- (void)showViewIndex:(int)index;
- (void)showViewIndex:(int)index withAnimationTime:(NSTimeInterval)animationTime;
- (void)showNext;
- (void)showPrevious;

@end
