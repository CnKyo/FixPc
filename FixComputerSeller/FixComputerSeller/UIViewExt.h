/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

CGPoint CGRectGetCenter(CGRect rect);
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (ViewFrameGeometry)
@property CGPoint origin;
@property CGSize size;

@property (readonly) CGPoint mbottomLeft;
@property (readonly) CGPoint mbottomRight;
@property (readonly) CGPoint mtopRight;

@property CGFloat mheight;
@property CGFloat mwidth;

@property CGFloat mtop;
@property CGFloat mleft;

@property CGFloat mbottom;
@property CGFloat mright;

- (void) moveBy: (CGPoint) delta;
- (void) scaleBy: (CGFloat) scaleFactor;
- (void) fitInSize: (CGSize) aSize;
@end