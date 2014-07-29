// UIImage+Alpha.h
// Created by Trevor Harmon on 9/20/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

// Helper methods for adding an alpha layer to an image

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (Alpha)

- (BOOL)hasAlpha;
- (UIImage *)imageWithAlpha;
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize;
- (CGImageRef)newBorderMask:(NSUInteger)borderSize size:(CGSize)size;

- (UIImage *)applyBlurOnImageWithRadius:(CGFloat)blurRadius;

- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;

#pragma mark - pixel


- (UIColor *) getPixelColorAtLocation:(CGPoint)point;

- (BOOL)isNearBlackOrWhite:(float)width height:(float)height;


@end


@interface UIColor (Colours)

#pragma mark - Distance between Colors


// ColorDistance
typedef NS_ENUM(NSInteger, ColorDistance) {
    ColorDistanceCIE76,
    ColorDistanceCIE94,
    ColorDistanceCIE2000,
};

typedef NS_ENUM(NSInteger, ColorComparison) {
    ColorComparisonDarkness,
    ColorComparisonLightness,
    ColorComparisonDesaturated,
    ColorComparisonSaturated,
    ColorComparisonRed,
    ColorComparisonGreen,
    ColorComparisonBlue
};

/**
 *  Returns a float of the distance between 2 colors. Defaults to the
 *  CIE94 specification found here: http://en.wikipedia.org/wiki/Color_difference
 *
 *  @param color Color to check self with.
 *
 *  @return CGFloat
 */
- (CGFloat)distanceFromColor:(id)color;

/**
 *  Returns a float of the distance between 2 colors, using one of
 *
 *
 *  @param color        Color to check against
 *  @param distanceType Formula to calculate with
 *
 *  @return CGFloat
 */
- (CGFloat)distanceFromColor:(id)color type:(ColorDistance)distanceType;


#pragma mark - Compare Colors

+ (NSArray *)sortColors:(NSArray *)colors withComparison:(ColorComparison)comparison;

+ (NSComparisonResult)compareColor:(id)colorA andColor:(id)colorB withComparison:(ColorComparison)comparison;

@end
