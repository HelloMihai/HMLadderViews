//
//  HMBasicAnimation.h
//  HMSideDrawerDirectionalExample
//
//  Created by Hello Mihai on 9/2/14.
//  Available under the MIT License. See the LICENSE file for more.
//

#import <Foundation/Foundation.h>

static NSString* const HMBasicAnimation_OPACITY       = @"opacity";
static NSString* const HMBasicAnimation_ROTATION      = @"transform.rotation";
static NSString* const HMBasicAnimation_ROTATION_Y    = @"transform.rotation.y";
static NSString* const HMBasicAnimation_ROTATION_X    = @"transform.rotation.x";
static NSString* const HMBasicAnimation_ROTATION_Z    = @"transform.rotation.z";
static NSString* const HMBasicAnimation_SCALE_X       = @"transform.scale.x";
static NSString* const HMBasicAnimation_SCALE_Y       = @"transform.scale.y";
static NSString* const HMBasicAnimation_SCALE_Z       = @"transform.scale.z";
static NSString* const HMBasicAnimation_TRANSLATION_X = @"transform.translation.x"; // relative change from current x
static NSString* const HMBasicAnimation_TRANSLATION_Y = @"transform.translation.y"; // relative change from current y
static NSString* const HMBasicAnimation_TRANSLATION_Z = @"transform.translation.z"; // relative change from current z
static NSString* const HMBasicAnimation_POSITION_X    = @"position.x"; // center is registration point
static NSString* const HMBasicAnimation_POSITION_Y    = @"position.y"; // center is registration point

typedef enum {
    HMBasicAnimation_EASING_NONE, // no ease
    HMBasicAnimation_EASING_LINEAR, // kCAMediaTimingFunctionLinear
    HMBasicAnimation_EASING_EASE_IN, // kCAMediaTimingFunctionEaseIn
    HMBasicAnimation_EASING_EASE_OUT, // kCAMediaTimingFunctionEaseOut
    HMBasicAnimation_EASING_EASE_IN_OUT, // kCAMediaTimingFunctionEaseInEaseOut
    HMBasicAnimation_EASING_DEFAULT, // kCAMediaTimingFunctionDefault
} HMBasicAnimation_EASING;

@interface HMBasicAnimation : NSObject

#pragma mark : convenience methods, forward with ease=NONE and delay=0

+ (void)rotate2D:(CALayer*)layer toDegreeAngle:(float)toDegreeAngle duration:(CGFloat)duration;
+ (void)rotate3D:(CALayer*)layer toDegreeAngle:(float)toDegreeAngle duration:(CGFloat)duration keyPath:(NSString*)keyPath;
+ (void)animate:(CALayer*)layer toValue:(id)toValue duration:(CGFloat)duration keyPath:(NSString*)keyPath;

#pragma mark : convenience methods, forward with ease=NONE

+ (void)rotate2D:(CALayer*)layer toDegreeAngle:(float)toDegreeAngle duration:(CGFloat)duration delaySeconds:(CGFloat)delaySeconds;
+ (void)rotate3D:(CALayer*)layer toDegreeAngle:(float)toDegreeAngle duration:(CGFloat)duration delaySeconds:(CGFloat)delaySeconds keyPath:(NSString*)keyPath;
+ (void)animate:(CALayer*)layer toValue:(id)toValue duration:(CGFloat)duration delaySeconds:(CGFloat)delaySeconds keyPath:(NSString*)keyPath;

#pragma mark : complete methods

+ (void)rotate3D:(CALayer*)layer toDegreeAngle:(float)toDegreeAngle duration:(CGFloat)duration delaySeconds:(CGFloat)delaySeconds keyPath:(NSString*)keyPath withEase:(int)ease;
+ (void)rotate2D:(CALayer*)layer toDegreeAngle:(float)toDegreeAngle duration:(CGFloat)duration delaySeconds:(CGFloat)delaySeconds withEase:(int)ease;
+ (void)animate:(CALayer*)layer toValue:(id)toValue duration:(CGFloat)duration delaySeconds:(CGFloat)delaySeconds keyPath:(NSString*)keyPath withEase:(int)ease;

@end
