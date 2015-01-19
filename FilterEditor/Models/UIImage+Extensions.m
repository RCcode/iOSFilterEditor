//
//  UIImage+Extensions.m
//  MirrorDemo
//
//  Created by gaoluyangrc on 14-6-19.
//  Copyright (c) 2014年 rcplatformhk. All rights reserved.
//

#import "UIImage+Extensions.h"
#import "CMethods.h"
@import AssetsLibrary;

@implementation UIImage (Extensions)

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};

CGSize workOutSize(float imageWidth,float imageHeight,float orWidth,float orHeight,float widthScole,float heightScole)
{
    float width;
    float height;
    
    //高大于宽
    if (imageWidth < imageHeight)
    {
        float scale = imageWidth/(orWidth * widthScole + 10);
        if (imageHeight/scale < orHeight * heightScole + 10)
        {
            height = orHeight * heightScole + 10;
            width =  imageWidth * (height / imageHeight);
        }
        else
        {
            width = orWidth * widthScole + 10;
            height = imageHeight/scale;
        }
    }
    //高小于宽
    else
    {
        if (widthScole < 1)
        {
            float scale = imageWidth/(orWidth * widthScole + 10);
            
            if (imageHeight/scale < orHeight * heightScole + 10)
            {
                height = orHeight * heightScole + 10;
                width =  imageWidth * (height / imageHeight);
            }
            else
            {
                width = orWidth * widthScole + 10;
                height = imageHeight/scale;
            }
        }
        else
        {
            float scale = imageWidth/(orWidth * widthScole + 10);
            
            if (imageHeight/scale > orHeight * heightScole + 10)
            {
                width = orWidth * widthScole + 10;
                height = imageHeight/scale;
            }
            else
            {
                height = orHeight * heightScole + 10;
                width = imageWidth / (imageHeight/(orHeight * heightScole + 10));
            }
        }
    }
    
    CGSize size = CGSizeMake(width, height);
    
    return size;
}

CGSize workImageSize(float imageWidth,float imageHeight,float orWidth,float orHeight)
{
    float width;
    float height;
    
    //高大于宽
    if (imageWidth < imageHeight)
    {
        float scale = imageWidth/orWidth;
        if (imageHeight/scale > orHeight)
        {
            height = orHeight;
            width =  imageWidth * (height / imageHeight);
        }
        else
        {
            width = orWidth;
            height = imageHeight/scale;
        }
    }
    //高小于宽
    else
    {
        float scale = imageWidth/orWidth;
        
        if (imageHeight/scale < orHeight)
        {
            width = orWidth;
            height = imageHeight/scale;
        }
        else
        {
            height = orHeight;
            width = imageWidth / (imageHeight/orHeight);
        }
    }
    
    CGSize size = CGSizeMake(width, height);
    
    return size;
}

NSDictionary* sourchDictionary()
{
    NSDictionary *dic = @{@"itoolImage": [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSArray arrayWithObjects:@"bottom_2D_nomal",@"bottom_3D_nomal",@"bottom_filter_nomal",@"bottom_scale_nomal",@"bottom_move_nomal",@"bottom_cut_nomal", nil],
                                          @"0",
                                          [NSArray arrayWithObjects:@"btn_mirror01",@"btn_mirror02",@"btn_mirror03",@"btn_mirror10",@"btn_mirror11",@"btn_mirror12",@"btn_mirror04",@"btn_mirror05",@"btn_mirror06",@"btn_mirror07",@"btn_mirror08",@"btn_mirror09",nil],
                                          @"1",
                                          [NSArray arrayWithObjects:@"btn_3D09",@"btn_3D10",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"btn_3D01",@"btn_3D02",@"btn_3D03",@"btn_3D04",@"btn_3D05",@"btn_3D06",@"btn_3D07",@"btn_3D08", nil],
                                          @"2",
                                          [NSArray arrayWithObjects:@"btn_scale01",@"btn_scale02",@"btn_scale03",@"btn_scale04",@"btn_scale05",@"btn_scale06",@"btn_scale07",@"btn_scale08",@"btn_scale09",@"btn_scale010",@"btn_scale011", nil],
                                          @"4",
                                          [NSArray arrayWithObjects:@"btn_move01",@"btn_move02",@"btn_move03",@"btn_move04",@"btn_move05",@"btn_move06",@"btn_move07", nil],
                                          @"5",
                                          [NSArray arrayWithObjects:@"bottom_2D_pressed",@"bottom_3D_pressed",@"bottom_filter_pressed",@"bottom_scale_pressed",@"bottom_move_pressed",@"bottom_cut_pressed", nil],
                                          @"6",
                                          nil],
                          
                          @"menuEvents":@[@"edit_2D",@"edit_3D",@"edit_filter",@"edit_scale",@"edlt_move",@"edit_cut"],
                          @"edit2DEvents":@[@"edit_mirror_2dmirror1",@"edit_mirror_2dmirror2",@"edit_mirror_2dmirror3",@"edit_mirror_2dmirror4",@"edit_mirror_2dmirror5",@"edit_mirror_2dmirror6",@"edit_mirror_2dmirror7",@"edit_mirror_2dmirror8",@"edit_mirror_2dmirror9",@"edit_mirror_2dmirror10",@"edit_mirror_2dmirror11",@"edit_mirror_2dmirror12"],
                          @"edit3DEvents":@[@"edit_mirror_3dmirror1",@"edit_mirror_3dmirror2",@"edit_mirror_3dmirror3",@"edit_mirror_3dmirror4",@"edit_mirror_3dmirror5",@"edit_mirror_3dmirror6",@"edit_mirror_3dmirror7",@"edit_mirror_3dmirror8",@"edit_mirror_3dmirror9",@"edit_mirror_3dmirror10",@"edit_mirror_3dmirror11",@"edit_mirror_3dmirror12",@"edit_mirror_3dmirror13",@"edit_mirror_3dmirror14",@"edit_mirror_3dmirror15",@"edit_mirror_3dmirror16",@"edit_mirror_3dmirror17",@"edit_mirror_3dmirror18",@"edit_mirror_3dmirror19",],
                          @"filterEvents":@[@"edit_filter_1",@"edit_filter_2",@"edit_filter_3",@"edit_filter_4",@"edit_filter_5",@"edit_filter_6",@"edit_filter_7",@"edit_filter_8",@"edit_filter_9",@"edit_filter_10",@"edit_filter_11",@"edit_filter_12",@"edit_filter_13",@"edit_filter_14",@"edit_filter_15",@"edit_filter_16",@"edit_filter_17",@"edit_filter_18",@"edit_filter_19",@"edit_filter_20",@"edit_filter_21",@"edit_filter_22",@"edit_filter_23",@"edit_filter_24",@"edit_filter_25",@"edit_filter_26",@"edit_filter_27",@"edit_filter_28",@"edit_filter_29",@"edit_filter_30",@"edit_filter_31",@"edit_filter_32",@"edit_filter_33",@"edit_filter_34",@"edit_filter_35",@"edit_filter_36",@"edit_filter_37",@"edit_filter_38"],
                          
                          @"heartLineRect":@[NSStringFromCGRect(CGRectMake(155, 75, 1, 213)),NSStringFromCGRect(CGRectMake(155, 50, 1, 213)),NSStringFromCGRect(CGRectMake(103, 75, 1, 213)),NSStringFromCGRect(CGRectMake(155, 55.7, 1, 158.8)),NSStringFromCGRect(CGRectMake(116, 73.5, 1, 213.3)),NSStringFromCGRect(CGRectMake(155, 45, 1, 213)),NSStringFromCGRect(CGRectMake(93, 75, 1, 213)),NSStringFromCGRect(CGRectMake(155, 52, 1, 213)),NSStringFromCGRect(CGRectMake(111, 75, 1, 213)),NSStringFromCGRect(CGRectMake(155, 42, 1, 145)),NSStringFromCGRect(CGRectMake(87, 73, 1, 214))],
                          
                          @"shadowArray":[NSArray arrayWithObjects:
                                          [NSArray arrayWithObjects:@"projection1",@"projection2",@"projection3",@"projection4", nil],
                                          [NSArray arrayWithObjects:@"projection5",@"projection6",@"projection7",@"projection8", nil],
                                          [NSArray arrayWithObjects:@"shadow1",@"shadow2",@"shadow3",@"shadow4", nil],
                                          [NSArray arrayWithObjects:@"shadow5",@"shadow6",@"shadow7",@"shadow8", nil],
                                          nil]
                          };
    
    
    return dic;
}

+ (UIImage *)zoomImage:(UIImage *)image toSize:(CGSize)size
{
    static UIImage *newImage;
    if (image.size.width > size.width || image.size.height > size.height)
    {
        if (image.size.width >=  image.size.height)
        {
            float scale = image.size.width/size.width;
            float height = image.size.height/scale;
            newImage = [image imageByScalingToSize:CGSizeMake(size.width, height)];
        }
        else
        {
            float scale = image.size.height/size.height;
            float width = image.size.width/scale;
            newImage = [image imageByScalingToSize:CGSizeMake(width, size.height)];
        }
    }
    else
    {
        if (image.size.width >=  image.size.height)
        {
            float scale = size.width/image.size.width;
            float height = image.size.height*scale;
            newImage = [image imageByScalingToSize:CGSizeMake(size.width, height)];
        }
        else
        {
            float scale = size.height/image.size.height;
            float width = image.size.width*scale;
            newImage = [image imageByScalingToSize:CGSizeMake(width, size.height)];
        }
    }
    
    return newImage;
}

- (UIImage *)imageAtRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage* subImage = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    
    return subImage;
}

- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 {
    UIGraphicsBeginImageContext(image2.size);
    
    // Draw image1
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    
    // Draw image2
    [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize
{
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");

    return newImage ;
}


- (UIImage *)imageByScalingToSize:(CGSize)targetSize{
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}


- (UIImage *)imageRotatedByRadians:(CGFloat)radians
{
    return [self imageRotatedByDegrees:RadiansToDegrees(radians)];
}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

- (void)saveToAlbumWithMetadata:(NSDictionary *)metadata
                   customAlbumName:(NSString *)customAlbumName
                   completionBlock:(void (^)(void))completionBlock
                      failureBlock:(void (^)(NSError *error))failureBlock
{
    NSData * imageData = UIImagePNGRepresentation (self);
    ALAssetsLibrary * assetsLibrary = [[ALAssetsLibrary alloc] init];
    void (^ AddAsset )( ALAssetsLibrary * , NSURL * ) = ^ (ALAssetsLibrary * assetsLibrary , NSURL * assetURL ) {
        [assetsLibrary assetForURL : assetURL resultBlock :^ ( ALAsset * asset ) {
            [ assetsLibrary enumerateGroupsWithTypes : ALAssetsGroupAll usingBlock :^ ( ALAssetsGroup * group , BOOL * stop ) {
                if ([[ group valueForProperty : ALAssetsGroupPropertyName ] isEqualToString : customAlbumName ]) {
                    [ group addAsset : asset ];
                    if ( completionBlock ) {
                        completionBlock ();
                    }
                }
            } failureBlock :^ ( NSError * error ) {
                if ( failureBlock ) {
                    failureBlock ( error );
                }
            }];
        } failureBlock :^ ( NSError * error ) {
            if ( failureBlock ) {
                failureBlock ( error );
            }
        }];
    };
    [assetsLibrary writeImageDataToSavedPhotosAlbum : imageData metadata : metadata completionBlock :^ ( NSURL * assetURL , NSError * error ) {
        if (customAlbumName) {
            [assetsLibrary addAssetsGroupAlbumWithName : customAlbumName resultBlock :^ ( ALAssetsGroup * group ) {
                if ( group ) {
                    [assetsLibrary assetForURL:assetURL resultBlock:^ (ALAsset *asset) {
                        [ group addAsset : asset ];
                        if ( completionBlock ) {
                            completionBlock ();
                        }
                    } failureBlock :^ ( NSError * error ) {
                        if ( failureBlock ) {
                            failureBlock ( error );
                        }
                    }];
                } else {
                    AddAsset ( assetsLibrary , assetURL );
                }
            } failureBlock :^ ( NSError * error ) {
                AddAsset ( assetsLibrary , assetURL );
            }];
        } else {
            if ( completionBlock ) {
                completionBlock ();
            }
        }
    }];
}

- (UIImage *)imageWithBackgroundColor:(UIColor *)bgColor
                           shadeAlpha1:(CGFloat)alpha1
                           shadeAlpha2:(CGFloat)alpha2
                           shadeAlpha3:(CGFloat)alpha3
                           shadowColor:(UIColor *)shadowColor
                          shadowOffset:(CGSize)shadowOffset
                            shadowBlur:(CGFloat)shadowBlur {
    UIImage *image = self;
    CGColorRef cgColor = [bgColor CGColor];
    CGColorRef cgShadowColor = [shadowColor CGColor];
    CGFloat components[16] = {1,1,1,alpha1,1,1,1,alpha1,1,1,1,alpha2,1,1,1,alpha3};
    CGFloat locations[4] = {0,0.5,0.6,1};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef colorGradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, (size_t)4);
    CGRect contextRect;
    contextRect.origin.x = 0.0f;
    contextRect.origin.y = 0.0f;
    contextRect.size = [image size];
    //contextRect.size = CGSizeMake([image size].width+5,[image size].height+5);
    // Retrieve source image and begin image context
    UIImage *itemImage = image;
    CGSize itemImageSize = [itemImage size];
    CGPoint itemImagePosition;
    itemImagePosition.x = ceilf((contextRect.size.width - itemImageSize.width) / 2);
    itemImagePosition.y = ceilf((contextRect.size.height - itemImageSize.height) / 2);
    UIGraphicsBeginImageContext(contextRect.size);
    CGContextRef c = UIGraphicsGetCurrentContext();
    // Setup shadow
    CGContextSetShadowWithColor(c, shadowOffset, shadowBlur, cgShadowColor);
    // Setup transparency layer and clip to mask
    CGContextBeginTransparencyLayer(c, NULL);
    CGContextScaleCTM(c, 1.0, -1.0);
    CGContextClipToMask(c, CGRectMake(itemImagePosition.x, -itemImagePosition.y, itemImageSize.width, -itemImageSize.height), [itemImage CGImage]);
    // Fill and end the transparency layer
    CGContextSetFillColorWithColor(c, cgColor);
    contextRect.size.height = -contextRect.size.height;
    CGContextFillRect(c, contextRect);
    CGContextDrawLinearGradient(c, colorGradient,CGPointZero,CGPointMake(contextRect.size.width*1.0/4.0,contextRect.size.height),0);
    CGContextEndTransparencyLayer(c);
    //CGPointMake(contextRect.size.width*3.0/4.0, 0)
    // Set selected image and end context
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(colorGradient);
    return resultImage;
}

- (UIImage *)imageWithShadowColor:(UIColor *)shadowColor
                     shadowOffset:(CGSize)shadowOffset
                       shadowBlur:(CGFloat)shadowBlur
{
    CGColorRef cgShadowColor = [shadowColor CGColor];
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef shadowContext = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                                       CGImageGetBitsPerComponent(self.CGImage), 0,
                                                       colourSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colourSpace);
    
    // Setup shadow
    CGContextSetShadowWithColor(shadowContext, shadowOffset, shadowBlur, cgShadowColor);
    CGRect drawRect = CGRectMake(-shadowBlur, -shadowBlur, self.size.width + shadowBlur, self.size.height + shadowBlur);
    CGContextDrawImage(shadowContext, drawRect, self.CGImage);
    
    CGImageRef shadowedCGImage = CGBitmapContextCreateImage(shadowContext);
    CGContextRelease(shadowContext);
    
    UIImage * shadowedImage = [UIImage imageWithCGImage:shadowedCGImage];
    CGImageRelease(shadowedCGImage);
    
    return shadowedImage;
}

- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, self.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

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
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
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
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
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
    return img;
    
}

- (UIImage *)rotate:(UIImageOrientation)orient
{
    CGRect bnds = CGRectZero;
    UIImage* copy = nil;
    CGContextRef ctxt = nil;
    CGImageRef imag = self.CGImage;
    CGRect rect = CGRectZero;
    CGAffineTransform tran = CGAffineTransformIdentity;
    
    rect.size.width = CGImageGetWidth(imag);
    rect.size.height = CGImageGetHeight(imag);
    
    bnds = rect;
    
    switch (orient)
    {
        case UIImageOrientationUp:
            // would get you an exact copy of the original
            assert(false);
            return nil;
            
        case UIImageOrientationUpMirrored:
            tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown:
            tran = CGAffineTransformMakeTranslation(rect.size.width,
                                                    rect.size.height);
            tran = CGAffineTransformRotate(tran, M_PI);
            break;
            
        case UIImageOrientationDownMirrored:
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
            tran = CGAffineTransformScale(tran, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeft:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
            tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeftMirrored:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(rect.size.height,
                                                    rect.size.width);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRight:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
            tran = CGAffineTransformRotate(tran, M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeScale(-1.0, 1.0);
            tran = CGAffineTransformRotate(tran, M_PI / 2.0);
            break;
            
        default:
            // orientation value supplied is invalid
            assert(false);
            return nil;
    }
    
    UIGraphicsBeginImageContext(bnds.size);
    ctxt = UIGraphicsGetCurrentContext();
    
    switch (orient)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextScaleCTM(ctxt, -1.0, 1.0);
            CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
            break;
            
        default:
            CGContextScaleCTM(ctxt, 1.0, -1.0);
            CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
            break;
    }
    
    CGContextConcatCTM(ctxt, tran);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, imag);
    
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return copy;
}
static CGRect swapWidthAndHeight(CGRect rect)
{
    CGFloat swap = rect.size.width;
    
    rect.size.width = rect.size.height;
    rect.size.height = swap;
    
    return rect;
}

//截图方法
- (UIImage *)subImageWithRect:(CGRect)rect
{
    CGImageRef newImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    return newImage;
}

//压缩图片
- (UIImage *)rescaleImageToSize:(CGSize)size
{
    CGRect rect = (CGRect){CGPointZero, size};
    
    UIGraphicsBeginImageContext(rect.size);
    
    [self drawInRect:rect]; // scales image to rect
    
    UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resImage;
}

//UIView转化为UIImage
+ (UIImage *)getImageFromView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 *  改变前景颜色
 *
 *  @param tintColor 要改变的前景颜色
 *
 *  @return 改变前景色后的图片
 */
- (UIImage *)changeTintColor:(UIColor *)tintColor
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, 320), NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, 320, 320);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}
/**
 *  改变前景图案
 *
 *  @param image 要改变的前景图案
 *
 *  @return 改变完成后的图片
 */
- (UIImage *)changeGraph:(UIImage *)image
{
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, 320), NO, 0.0f);
    CGRect bounds = CGRectMake(0, 0, 320, 320);
    [image drawInRect:bounds];
    
    //    [view drawViewHierarchyInRect:bounds afterScreenUpdates:YES];
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    
    UIImage *graphImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return graphImage;
}
/**
 *  转变shape的显示模式
 *
 *  @param image 当前图片的背景图
 *
 *  @return 改变模式后的图片
 */
- (UIImage *)turnShapeWithImage:(UIImage *)image
{
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, 320), NO, 0.0f);
    CGRect bounds = CGRectMake(0, 0, 320, 320);
    [image drawInRect:bounds];
    
    //    [view drawViewHierarchyInRect:bounds afterScreenUpdates:YES];
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationOut alpha:1.0f];
    
    UIImage *graphImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return graphImage;
}

/**
 *  根据不同的混合模式合成形状图形
 *
 *  @param _bottomImage 合成所选底图
 *  @param _topImage    合成所选顶图
 *  @param blendMode    混合方式
 *
 *  @return 合成完成后图片
 */
+ (UIImage *)shapeMakeWithBottomImage:(UIImage *)_bottomImage imageBold:(UIImage *)_boldImage andTopImage:(UIImage *)_topImage andBlendMode:(CGBlendMode)blendMode
{
    UIImage *bottomImage = _bottomImage;
    UIImage *topImage = _topImage;
    UIImage *boldImage = _boldImage;
    
    CGSize newSize =CGSizeMake(1080, 1080);
    
    UIGraphicsBeginImageContext(newSize);
    
    [[UIColor whiteColor] setFill];
    CGRect bounds = CGRectMake(0, 0, 1080, 1080);
    UIRectFill(bounds);
    
    // Use existing opacity as is
    [bottomImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Apply supplied opacity
    [topImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:blendMode alpha:1];
    
    [boldImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}


/**
 *  为保证图片质量保存时重绘的图片
 *
 *  @param backView 屏幕显示的出来的view
 *  @param size     保存图片大小
 *
 *  @return 制做完成的图片
 */
+ (UIImage *)getEditFinishedImageWithView:(UIView *)backView andContextSize:(CGSize)size
{
    
    CGSize newSize = size;
    UIGraphicsBeginImageContext( newSize );
    // Use existing opacity as is
    [backView drawViewHierarchyInRect:CGRectMake(0, 0, newSize.width, newSize.height) afterScreenUpdates:YES];
    
    UIImage *newImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end
