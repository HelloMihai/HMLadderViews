//
//  HMBasicAnimation.m
//  HMSideDrawerDirectionalExample
//
//  Created by Hello Mihai on 9/2/14.
//  Available under the MIT License. See the LICENSE file for more.
//

#import "HMBasicAnimation.h"

@implementation HMBasicAnimation

#pragma mark : convenience methods,  forward with ease=NONE and delay=0

+ (void)animate:(CALayer*)layer toValue:(id)toValue duration:(CGFloat)duration keyPath:(NSString*)keyPath
{
    [self animate:layer toValue:toValue duration:duration delaySeconds:0 keyPath:keyPath withEase:HMBasicAnimation_EASING_NONE];
}

+ (void)rotate2D:(CALayer*)layer toDegreeAngle:(float)toDegreeAngle duration:(CGFloat)duration
{
    [self rotate2D:layer toDegreeAngle:toDegreeAngle duration:duration delaySeconds:0 withEase:HMBasicAnimation_EASING_NONE];
}

+ (void)rotate3D:(CALayer*)layer toDegreeAngle:(float)toDegreeAngle duration:(CGFloat)duration keyPath:(NSString*)keyPath
{
    [self rotate3D:layer toDegreeAngle:toDegreeAngle duration:duration delaySeconds:0 keyPath:keyPath withEase:HMBasicAnimation_EASING_NONE];
}

#pragma mark : convenience methods, forward with ease=NONE

+ (void)animate:(CALayer*)layer toValue:(id)toValue duration:(CGFloat)duration delaySeconds:(CGFloat)delaySeconds keyPath:(NSString*)keyPath
{
    [self animate:layer toValue:toValue duration:duration delaySeconds:delaySeconds keyPath:keyPath withEase:HMBasicAnimation_EASING_NONE];
}

+ (void)rotate2D:(CALayer*)layer toDegreeAngle:(float)toDegreeAngle duration:(CGFloat)duration delaySeconds:(CGFloat)delaySeconds
{
    [self rotate2D:layer toDegreeAngle:toDegreeAngle duration:duration delaySeconds:delaySeconds withEase:HMBasicAnimation_EASING_NONE];
}

+ (void)rotate3D:(CALayer*)layer toDegreeAngle:(float)toDegreeAngle duration:(CGFloat)duration delaySeconds:(CGFloat)delaySeconds keyPath:(NSString*)keyPath
{
    [self rotate3D:layer toDegreeAngle:toDegreeAngle duration:duration delaySeconds:delaySeconds keyPath:keyPath withEase:HMBasicAnimation_EASING_NONE];
}

#pragma mark : final methods

+ (void)rotate3D:(CALayer*)layer toDegreeAngle:(float)toDegreeAngle duration:(CGFloat)duration delaySeconds:(CGFloat)delaySeconds keyPath:(NSString*)keyPath withEase:(int)ease
{
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / 500.0;
    layer.transform = transform;

    float radian = [self degreeToRadian:toDegreeAngle];
    [self animate:layer toValue:@(radian) duration:duration delaySeconds:delaySeconds keyPath:keyPath withEase:ease];
}

+ (void)rotate2D:(CALayer*)layer toDegreeAngle:(float)toDegreeAngle duration:(CGFloat)duration delaySeconds:(CGFloat)delaySeconds withEase:(int)ease
{
    float radian = [self degreeToRadian:toDegreeAngle];
    [self animate:layer toValue:@(radian) duration:duration delaySeconds:delaySeconds keyPath:HMBasicAnimation_ROTATION withEase:ease];
}

+ (void)animate:(CALayer*)layer
         toValue:(id)toValue
        duration:(CGFloat)duration
    delaySeconds:(CGFloat)delaySeconds
         keyPath:(NSString*)keyPath
        withEase:(int)ease
{
    // on delay set the value to the model (animating presentation layer wont update model)
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, delaySeconds * NSEC_PER_SEC);
    dispatch_after(when, dispatch_get_main_queue(), ^(void) {
        id currentValue = [layer valueForKeyPath:keyPath];
        if (duration > 0) {
            CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:keyPath];
            animation.fromValue = currentValue;
            animation.toValue = toValue;
            animation.duration = duration;
            [self setEaseTypeToAniamtion:animation withEaseType:ease];
            [layer addAnimation:animation forKey:keyPath]; // start animation
        }
        [layer setValue:toValue forKeyPath:keyPath];
    });
}

#pragma mark : helpers

+ (void)setEaseTypeToAniamtion:(CABasicAnimation*)animation withEaseType:(int)easeType
{
    // check if we have a valid type
    int lastType = HMBasicAnimation_EASING_DEFAULT;
    BOOL hasEase = easeType > HMBasicAnimation_EASING_NONE && easeType <= lastType;

    // get the appropriate ease function
    NSString* easeFunction;
    switch (easeType) {
    case HMBasicAnimation_EASING_LINEAR:
        easeFunction = kCAMediaTimingFunctionLinear;
        break;
    case HMBasicAnimation_EASING_EASE_IN:
        easeFunction = kCAMediaTimingFunctionEaseIn;
        break;
    case HMBasicAnimation_EASING_EASE_OUT:
        easeFunction = kCAMediaTimingFunctionEaseOut;
        break;
    case HMBasicAnimation_EASING_EASE_IN_OUT:
        easeFunction = kCAMediaTimingFunctionEaseInEaseOut;
        break;
    case HMBasicAnimation_EASING_DEFAULT:
        easeFunction = kCAMediaTimingFunctionDefault;
        break;
    default:
        easeFunction = kCAMediaTimingFunctionLinear;
        break;
    }

    // set the ease
    if (hasEase)
        animation.timingFunction = [CAMediaTimingFunction functionWithName:easeFunction];
}

+ (float)degreeToRadian:(float)degrees
{
    return degrees * M_PI / 180;
}

@end
