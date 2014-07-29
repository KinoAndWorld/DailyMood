// UIImage+Alpha.m
// Created by Trevor Harmon on 9/20/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

#import "UIImage+Alpha.h"

#import <Accelerate/Accelerate.h>

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@implementation UIImage (Alpha)

// Returns true if the image has an alpha layer
- (BOOL)hasAlpha {
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

// Returns a copy of the given image, adding an alpha channel if it doesn't already have one
- (UIImage *)imageWithAlpha {
    if ([self hasAlpha]) {
        return self;
    }
    
    CGImageRef imageRef = self.CGImage;
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    // The bitsPerComponent and bitmapInfo values are hard-coded to prevent an "unsupported parameter combination" error
    CGContextRef offscreenContext = CGBitmapContextCreate(NULL,
                                                          width,
                                                          height,
                                                          8,
                                                          0,
                                                          CGImageGetColorSpace(imageRef),
                                                          kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    
    // Draw the image into the context and retrieve the new image, which will now have an alpha layer
    CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef imageRefWithAlpha = CGBitmapContextCreateImage(offscreenContext);
    UIImage *imageWithAlpha = [UIImage imageWithCGImage:imageRefWithAlpha];
    
    // Clean up
    CGContextRelease(offscreenContext);
    CGImageRelease(imageRefWithAlpha);
    
    return imageWithAlpha;
}

// Returns a copy of the image with a transparent border of the given size added around its edges.
// If the image has no alpha layer, one will be added to it.
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize {
    // If the image does not have an alpha layer, add one
    UIImage *image = [self imageWithAlpha];
    
    CGRect newRect = CGRectMake(0, 0, image.size.width + borderSize * 2, image.size.height + borderSize * 2);
    
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(self.CGImage),
                                                0,
                                                CGImageGetColorSpace(self.CGImage),
                                                CGImageGetBitmapInfo(self.CGImage));
    
    // Draw the image in the center of the context, leaving a gap around the edges
    CGRect imageLocation = CGRectMake(borderSize, borderSize, image.size.width, image.size.height);
    CGContextDrawImage(bitmap, imageLocation, self.CGImage);
    CGImageRef borderImageRef = CGBitmapContextCreateImage(bitmap);
    
    // Create a mask to make the border transparent, and combine it with the image
    CGImageRef maskImageRef = [self newBorderMask:borderSize size:newRect.size];
    CGImageRef transparentBorderImageRef = CGImageCreateWithMask(borderImageRef, maskImageRef);
    UIImage *transparentBorderImage = [UIImage imageWithCGImage:transparentBorderImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(borderImageRef);
    CGImageRelease(maskImageRef);
    CGImageRelease(transparentBorderImageRef);
    
    return transparentBorderImage;
}

#pragma mark -
#pragma mark Private helper methods

// Creates a mask that makes the outer edges transparent and everything else opaque
// The size must include the entire mask (opaque part + transparent border)
// The caller is responsible for releasing the returned reference by calling CGImageRelease
- (CGImageRef)newBorderMask:(NSUInteger)borderSize size:(CGSize)size {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Build a context that's the same dimensions as the new size
    CGContextRef maskContext = CGBitmapContextCreate(NULL,
                                                     size.width,
                                                     size.height,
                                                     8, // 8-bit grayscale
                                                     0,
                                                     colorSpace,
                                                     kCGBitmapByteOrderDefault | kCGImageAlphaNone);
    
    // Start with a mask that's entirely transparent
    CGContextSetFillColorWithColor(maskContext, [UIColor blackColor].CGColor);
    CGContextFillRect(maskContext, CGRectMake(0, 0, size.width, size.height));
    
    // Make the inner part (within the border) opaque
    CGContextSetFillColorWithColor(maskContext, [UIColor whiteColor].CGColor);
    CGContextFillRect(maskContext, CGRectMake(borderSize, borderSize, size.width - borderSize * 2, size.height - borderSize * 2));
    
    // Get an image of the context
    CGImageRef maskImageRef = CGBitmapContextCreateImage(maskContext);
    
    // Clean up
    CGContextRelease(maskContext);
    CGColorSpaceRelease(colorSpace);
    
    return maskImageRef;
}




- (UIImage *)applyBlurOnImageWithRadius:(CGFloat)blurRadius{
    if ((blurRadius <= 0.0f) || (blurRadius > 1.0f)) {
        blurRadius = 0.5f;
    }
    
    int boxSize = (int)(blurRadius * 100);
    boxSize -= (boxSize % 2) + 1;
    
    CGImageRef rawImage = self.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(rawImage);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(rawImage);
    inBuffer.height = CGImageGetHeight(rawImage);
    inBuffer.rowBytes = CGImageGetBytesPerRow(rawImage);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(rawImage) * CGImageGetHeight(rawImage));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(rawImage);
    outBuffer.height = CGImageGetHeight(rawImage);
    outBuffer.rowBytes = CGImageGetBytesPerRow(rawImage);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL,
                                       0, 0, boxSize, boxSize, NULL,
                                       kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(self.CGImage));
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    return returnImage;
}

- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor
{
    //image must be nonzero size
    if (floorf(self.size.width) * floorf(self.size.height) <= 0.0f) return self;
    
    //boxsize must be an odd integer
    uint32_t boxSize = (uint32_t)(radius * self.scale);
    if (boxSize % 2 == 0) boxSize ++;
    
    //create image buffers
    CGImageRef imageRef = self.CGImage;
    vImage_Buffer buffer1, buffer2;
    buffer1.width = buffer2.width = CGImageGetWidth(imageRef);
    buffer1.height = buffer2.height = CGImageGetHeight(imageRef);
    buffer1.rowBytes = buffer2.rowBytes = CGImageGetBytesPerRow(imageRef);
    size_t bytes = buffer1.rowBytes * buffer1.height;
    buffer1.data = malloc(bytes);
    buffer2.data = malloc(bytes);
    
    //create temp buffer
    void *tempBuffer = malloc((size_t)vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, NULL, 0, 0, boxSize, boxSize,
                                                                 NULL, kvImageEdgeExtend + kvImageGetTempBufferSize));
    
    //copy image data
    CFDataRef dataSource = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
    memcpy(buffer1.data, CFDataGetBytePtr(dataSource), bytes);
    CFRelease(dataSource);
    
    for (NSUInteger i = 0; i < iterations; i++)
    {
        //perform blur
        vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, tempBuffer, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        
        //swap buffers
        void *temp = buffer1.data;
        buffer1.data = buffer2.data;
        buffer2.data = temp;
    }
    
    //free buffers
    free(buffer2.data);
    free(tempBuffer);
    
    //create image context from buffer
    CGContextRef ctx = CGBitmapContextCreate(buffer1.data, buffer1.width, buffer1.height,
                                             8, buffer1.rowBytes, CGImageGetColorSpace(imageRef),
                                             CGImageGetBitmapInfo(imageRef));
    
    //apply tint
    if (tintColor && CGColorGetAlpha(tintColor.CGColor) > 0.0f)
    {
        CGContextSetFillColorWithColor(ctx, [tintColor colorWithAlphaComponent:0.25].CGColor);
        CGContextSetBlendMode(ctx, kCGBlendModePlusLighter);
        CGContextFillRect(ctx, CGRectMake(0, 0, buffer1.width, buffer1.height));
    }
    
    //create image from context
    imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    CGContextRelease(ctx);
    free(buffer1.data);
    return image;
}


#pragma mark - pixel


- (UIColor *) getPixelColorAtLocation:(CGPoint)point{
    
    UIColor* color = nil;
    CGImageRef inImage = self.CGImage;
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:
                          inImage];
    
    if (cgctx == NULL) { return nil; /* error */ }
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    CGContextDrawImage(cgctx, rect, inImage);
    unsigned char* data = CGBitmapContextGetData (cgctx);
    
    if (data != NULL) {
        int offset = 4*((w*round(point.y))+round(point.x));
        int alpha =  data[offset];
        int red = data[offset+1];
        int green = data[offset+2];
        int blue = data[offset+3];
//        NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,
//              blue,alpha);
//        NSLog(@"x:%f y:%f", point.x, point.y);
        color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:
                 (blue/255.0f) alpha:(alpha/255.0f)];
    }
    CGContextRelease(cgctx);
    if (data) { free(data); }
    return color;
}

- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
    
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL){
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    bitmapData = malloc( bitmapByteCount );
    
    if (bitmapData == NULL){
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,
                                     bitmapBytesPerRow,
                                     colorSpace,
                                    kCGImageAlphaPremultipliedFirst);
    
//    CGBitmapInfo
    CGBitmapContextCreate(bitmapData, pixelsWide, pixelsWide, 8, bitmapBytesPerRow, colorSpace, kCGBitmapByteOrderDefault);
    
    if (context == NULL){
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    CGColorSpaceRelease( colorSpace );
    return context;
    
}

- (BOOL)isNearBlackOrWhite:(float)width height:(float)height{
    
    CGFloat sum = 0.0;
    float times1 = (width-10) / 10;
    float times2 = (height-10) / 10;
    
    for (int ptx = 10; ptx <= width; ptx+=10) {
        for (int pty = 10; pty <= height; pty+=10) {
            //获取颜色分量
            UIColor *color4Pt = [self getPixelColorAtLocation:CGPointMake(ptx, pty)];
//            NSLog(@"%@",NSStringFromClass([realColor class]));
            
//            const CGFloat* components = CGColorGetComponents(color4Pt.CGColor);
//            CGFloat red, green, blue, alpha;
//            red = components[0];
//            green = components[1];
//            blue = components[2];
//            alpha = components[3];
//            
//            //
//            UIColor *whiteColor = [UIColor blackColor];
//            const CGFloat* components2 = CGColorGetComponents(whiteColor.CGColor);
//            CGFloat red2, green2, blue2, alpha2;
//            red2 = components2[0];
//            green2 = components2[1];
//            blue2 = components2[2];
//            alpha2 = components2[3];
//            
//            //向量比较
//            float difference = pow( pow((red - red2), 2) + pow((green - green2), 2) +
//                                   pow((blue - blue2), 2), 0.5 );
            
            UIColor *whiteColor = [UIColor whiteColor];
            CGFloat difference = [color4Pt distanceFromColor:whiteColor];
            sum += difference;
            NSLog(@"%f",difference);
            
        }
    }
    sum = (sum / (times1*times2));
    if (sum > 30.f) {
        return NO;
    }
    
    return YES;
}

@end

@implementation UIColor (Colours)


#pragma mark - RGBA from Color
- (NSArray *)rgbaArray
{
    CGFloat r=0,g=0,b=0,a=0;
    
    if ([self respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [self getRed:&r green:&g blue:&b alpha:&a];
    }
    else {
        const CGFloat *components = CGColorGetComponents(self.CGColor);
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    }
    
    return @[@(r),
             @(g),
             @(b),
             @(a)];
}


#pragma mark - LAB from Color


#pragma mark - Static Block
static CGFloat (^RAD)(CGFloat) = ^CGFloat (CGFloat degree){
    return degree * M_PI/180;
};



- (NSArray *)CIE_LabArray {
    // Convert Color to XYZ format first
    NSArray *rgba = [self rgbaArray];
    CGFloat R = [rgba[0] floatValue];
    CGFloat G = [rgba[1] floatValue];
    CGFloat B = [rgba[2] floatValue];
    
    // Create deltaR block
    void (^deltaRGB)(CGFloat *R);
    deltaRGB = ^(CGFloat *R) {
        *R = (*R > 0.04045) ? pow((*R + 0.055)/1.055, 2.40) : (*R/12.92);
    };
    deltaRGB(&R);
    deltaRGB(&G);
    deltaRGB(&B);
    CGFloat X = R*41.24 + G*35.76 + B*18.05;
    CGFloat Y = R*21.26 + G*71.52 + B*7.22;
    CGFloat Z = R*1.93 + G*11.92 + B*95.05;
    
    // Convert XYZ to L*a*b*
    X = X/95.047;
    Y = Y/100.000;
    Z = Z/108.883;
    
    // Create deltaF block
    void (^deltaF)(CGFloat *f);
    deltaF = ^(CGFloat *f){
        *f = (*f > pow((6.0/29.0), 3.0)) ? pow(*f, 1.0/3.0) : (1/3)*pow((29.0/6.0), 2.0) * *f + 4/29.0;
    };
    deltaF(&X);
    deltaF(&Y);
    deltaF(&Z);
    NSNumber *L = @(116*Y - 16);
    NSNumber *a = @(500 * (X - Y));
    NSNumber *b = @(200 * (Y - Z));
    
    return @[L,
             a,
             b,
             rgba[3]];
}

#pragma mark - Distance between Colors
/**
 *  Returns a float of the distance between 2 colors. Defaults to the
 *  CIE94 specification found here: http://en.wikipedia.org/wiki/Color_difference
 *
 *  @param color Color to check self with.
 *
 *  @return CGFloat
 */
- (CGFloat)distanceFromColor:(id)color{
    // Defaults to CIE94
    return [self distanceFromColor:color type:ColorDistanceCIE76];
}

/**
 *  Returns a float of the distance between 2 colors, using one of
 *
 *
 *  @param color        Color to check against
 *  @param distanceType Formula to calculate with
 *
 *  @return CGFloat
 */
- (CGFloat)distanceFromColor:(id)color type:(ColorDistance)distanceType{
    /**
     *
     *  Detecting a difference in two colors is not as trivial as it sounds.
     *  One's first instinct is to go for a difference in RGB values, leaving
     *  you with a sum of the differences of each point. It looks great! Until
     *  you actually start comparing colors. Why do these two reds have a different
     *  distance than these two blues *in real life* vs computationally?
     *  Human visual perception is next in the line of things between a color
     *  and your brain. Some colors are just perceived to have larger variants inside
     *  of their respective areas than others, so we need a way to model this
     *  human variable to colors. Enter CIELAB. This color formulation is supposed to be
     *  this model. So now we need to standardize a unit of distance between any two
     *  colors that works independent of how humans visually perceive that distance.
     *  Enter CIE76,94,2000. These are methods that use user-tested data and other
     *  mathematically and statistically significant correlations to output this info.
     *  You can read the wiki articles below to get a better understanding historically
     *  of how we moved to newer and better color distance formulas, and what
     *  their respective pros/cons are.
     *
     *  References:
     *
     *  http://en.wikipedia.org/wiki/Color_difference
     *  http://en.wikipedia.org/wiki/Just_noticeable_difference
     *  http://en.wikipedia.org/wiki/CIELAB
     *
     */
    
    // Check if it's a color
//    if (![color isKindOfClass:[self class]] || ![color isMemberOfClass:[self class]]) {
//         NSLog(@"Not a %@ object.", NSStringFromClass([self class]));
//        return MAXFLOAT;
//    }
    
    
    // Set Up Common Variables
    NSArray *lab1 = [self CIE_LabArray];
    NSArray *lab2 = [color CIE_LabArray];
    CGFloat L1 = [lab1[0] floatValue];
    CGFloat A1 = [lab1[1] floatValue];
    CGFloat B1 = [lab1[2] floatValue];
    CGFloat L2 = [lab2[0] floatValue];
    CGFloat A2 = [lab2[1] floatValue];
    CGFloat B2 = [lab2[2] floatValue];
    
    // CIE76 first
    if (distanceType == ColorDistanceCIE76) {
        CGFloat distance = sqrtf(pow((L1-L2), 2) + pow((A1-A2), 2) + pow((B1-B2), 2));
        return distance;
    }
    
    // More Common Variables
    CGFloat kL = 1;
    CGFloat kC = 1;
    CGFloat kH = 1;
    CGFloat k1 = 0.045;
    CGFloat k2 = 0.015;
    CGFloat deltaL = L1 - L2;
    CGFloat C1 = sqrt((A1*A1) + (B1*B1));
    CGFloat C2 = sqrt((A2*A2) + (B2*B2));
    CGFloat deltaC = C1 - C2;
    CGFloat deltaH = sqrt(pow((A1-A2), 2.0) + pow((B1-B2), 2.0) - pow(deltaC, 2.0));
    CGFloat sL = 1;
    CGFloat sC = 1 + k1*(sqrt((A1*A1) + (B1*B1)));
    CGFloat sH = 1 + k2*(sqrt((A1*A1) + (B1*B1)));
    
    // CIE94
    if (distanceType == ColorDistanceCIE94) {
        return sqrt(pow((deltaL/(kL*sL)), 2.0) + pow((deltaC/(kC*sC)), 2.0) + pow((deltaH/(kH*sH)), 2.0));
    }
    
    // CIE2000
    // More variables
    CGFloat deltaLPrime = L2 - L1;
    CGFloat meanL = (L1 + L2)/2;
    CGFloat meanC = (C1 + C2)/2;
    CGFloat aPrime1 = A1 + A1/2*(1 - sqrt(pow(meanC, 7.0)/(pow(meanC, 7.0) + pow(25.0, 7.0))));
    CGFloat aPrime2 = A2 + A2/2*(1 - sqrt(pow(meanC, 7.0)/(pow(meanC, 7.0) + pow(25.0, 7.0))));
    CGFloat cPrime1 = sqrt((aPrime1*aPrime1) + (B1*B1));
    CGFloat cPrime2 = sqrt((aPrime2*aPrime2) + (B2*B2));
    CGFloat cMeanPrime = (cPrime1 + cPrime2)/2;
    CGFloat deltaCPrime = cPrime1 - cPrime2;
    CGFloat hPrime1 = atan2(B1, aPrime1);
    CGFloat hPrime2 = atan2(B2, aPrime2);
    hPrime1 = fmodf(hPrime1, RAD(360.0));
    hPrime2 = fmodf(hPrime2, RAD(360.0));
    CGFloat deltahPrime = 0;
    if (fabsf(hPrime1 - hPrime2) <= RAD(180.0)) {
        deltahPrime = hPrime2 - hPrime1;
    }
    else {
        deltahPrime = (hPrime2 <= hPrime1) ? hPrime2 - hPrime1 + RAD(360.0) : hPrime2 - hPrime1 - RAD(360.0);
    }
    CGFloat deltaHPrime = 2 * sqrt(cPrime1*cPrime2) * sin(deltahPrime/2);
    CGFloat meanHPrime = (fabsf(hPrime1 - hPrime2) <= RAD(180.0)) ? (hPrime1 + hPrime2)/2 : (hPrime1 + hPrime2 + RAD(360.0))/2;
    CGFloat T = 1 - 0.17*cos(meanHPrime - RAD(30.0)) + 0.24*cos(2*meanHPrime)+0.32*cos(3*meanHPrime + RAD(6.0)) - 0.20*cos(4*meanHPrime - RAD(63.0));
    sL = 1 + (0.015 * pow((meanL - 50), 2))/sqrt(20 + pow((meanL - 50), 2));
    sC = 1 + 0.045*cMeanPrime;
    sH = 1 + 0.015*cMeanPrime*T;
    CGFloat Rt = -2 * sqrt(pow(cMeanPrime, 7)/(pow(cMeanPrime, 7) + pow(25.0, 7))) * sin(RAD(60.0)* exp(-1 * pow((meanHPrime - RAD(275.0))/RAD(25.0), 2)));
    
    // Finally return CIE2000 distance
    return sqrt(pow((deltaLPrime/(kL*sL)), 2) + pow((deltaCPrime/(kC*sC)), 2) + pow((deltaHPrime/(kH*sH)), 2) + Rt*(deltaC/(kC*sC))*(deltaHPrime/(kH*sH)));
}




@end
