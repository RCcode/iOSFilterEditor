//
//  UIImage+Rotate.m
//  BeautySelfie
//
//  Created by MAXToooNG on 14-5-23.
//  Copyright (c) 2014年 Chen.Liu. All rights reserved.
//

#import "UIImage+Rotate.h"
#import <QuartzCore/QuartzCore.h>


@implementation UIImage (Rotate)
+ (UIImage *)rotate: (UIImage *)image
{
    double angle = 80 ;
    CGSize s = {image.size.width, image.size.height};
    UIGraphicsBeginImageContext(s);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0,image.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextRotateCTM(ctx, 2*M_PI*angle/360);
    
    CGContextDrawImage(ctx,CGRectMake(0,0,image.size.width, image.size.height),image.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //    NSString  *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.png"];
    //    [UIImagePNGRepresentation(newImage) writeToFile:pngPath atomically:YES];
    //
    //    CGSize size =  sizeOfImage;
    //    UIGraphicsBeginImageContext(s);
    //    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //    CGContextRotateCTM(ctx, 2*M_PI*angle/360);
    //
    //    CGContextDrawImage(UIGraphicsGetCurrentContext(),
    //                       CGRectMake(0,0,s.width, s.height),
    //                       image.CGImage);
    //    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    ////    return image;
    return newImage;
}

- (UIImage *)fixOrientation:(UIImageOrientation)orientation
{
    
    // No-op if the orientation is already correct
    if (orientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (orientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationLeft:
            
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (orientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    CGContextConcatCTM(ctx, transform);
    switch (orientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    //    NSString  *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.png"];
    //    [UIImagePNGRepresentation(img) writeToFile:pngPath atomically:YES];
    return img;
    
}

#pragma mark - 水平镜像
- (UIImage *)imageForMirrorHorizontally{
    CGSize size = self.size;
    
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM (ctx, size.width, size.height);
    CGContextRotateCTM(ctx, M_PI);
    CGContextDrawImage(ctx, CGRectMake(0,0,size.width, size.height), self.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    ImageWrite2SandBox(newImage, @"HorMirrImage.jpg");
    
    return newImage;
}


#pragma mark - 垂直镜像
- (UIImage *)imageForMirrorVertically{
    CGSize size = self.size;
    
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextDrawImage(ctx, CGRectMake(0,0,size.width, size.height), self.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    ImageWrite2SandBox(newImage, @"VerMirrImage.jpg");
    
    return newImage;
}


#pragma mark 获取不同朝向的image对象
- (UIImage *)rotateImageWithOrientation:(Orientation)orientation{
    
    CGSize size = self.size;
    
    CGSize contentS = CGSizeZero;
    CGSize translateParS = CGSizeZero;
    CGFloat rotatePar = 0.0;
    
    switch (orientation) {
        case kOrientationUp:
        {
            contentS = size;
        }
            break;

        case kOrientationRight:
        {
            contentS = CGSizeMake(size.height, size.width);
            translateParS = CGSizeMake(size.height, 0);
            rotatePar = M_PI_2;
        }
            break;
            
        case kOrientationDown:
        {
            contentS = size;
            translateParS = size;
            rotatePar = M_PI;
        }
            break;
            
        case kOrientationLeft:
        {
            contentS = CGSizeMake(size.height, size.width);
            translateParS = CGSizeMake(0, size.width);
            rotatePar = -M_PI_2;
        }
            break;
        default:
            return nil;
    }
    
    UIGraphicsBeginImageContext(contentS);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM (ctx, translateParS.width, translateParS.height);
    CGContextRotateCTM(ctx, rotatePar);
    [self drawInRect:(CGRect){CGPointZero, size}];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    NSString *fileName = [NSString stringWithFormat:@"orientation - %d.jpg", orientation];
//    ImageWrite2SandBox(newImage, fileName);
    
    return newImage;
}


- (UIImage*)rotateImageWithRadian:(CGFloat)radian cropMode:(RotateImageCropMode)cropMode
{
    CGSize imgSize = CGSizeMake(self.size.width * self.scale, self.size.height * self.scale);
    CGSize outputSize = imgSize;
    if (cropMode == kRotateImageCropModeExpand) {
        CGRect rect = CGRectMake(0, 0, imgSize.width, imgSize.height);
        rect = CGRectApplyAffineTransform(rect, CGAffineTransformMakeRotation(radian));
        outputSize = CGSizeMake(CGRectGetWidth(rect), CGRectGetHeight(rect));
    }
    
    UIGraphicsBeginImageContext(outputSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, outputSize.width / 2, outputSize.height / 2);
    CGContextRotateCTM(context, radian);
    CGContextTranslateCTM(context, -imgSize.width / 2, -imgSize.height / 2);
    
    [self drawInRect:CGRectMake(0, 0, imgSize.width, imgSize.height)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
