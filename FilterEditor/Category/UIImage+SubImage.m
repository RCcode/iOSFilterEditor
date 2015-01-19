//
//  UIImage+SubImage.m
//  PRJ_Test
//
//  Created by 贺瑞 on 14-4-16.
//  Copyright (c) 2014年 rcplatfrom. All rights reserved.
//

#import "UIImage+SubImage.h"
#import "PRJ_Global.h"


@implementation UIImage (SubImage)

- (UIImage *)subImageWithRect:(CGRect)rect{
    CGImageRef newImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    return newImage;
}

#pragma mark 指定size，获取新的image对象
- (UIImage *)rescaleImageToSize:(CGSize)size
{
    //等比缩放
    CGSize origin_size = self.size;
    if(origin_size.width < size.width && origin_size.height < size.height)
    {
        size = origin_size;
    }
    
    CGRect rect = (CGRect){CGPointZero, size};
    
    UIGraphicsBeginImageContext(rect.size);
    
    [self drawInRect:rect]; // scales image to rect
    
    UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resImage;
}

#pragma mark 指定size，获取新的image对象
- (CGSize)scaleImageToSize:(CGSize)size
{
    //等比缩放
    CGSize origin_size = self.size;
    if(origin_size.width < size.width && origin_size.height < size.height)
    {
        size = origin_size;
    }
    
    return size;
}

#pragma mark 指定大小生成一个平铺的图片
- (UIImage *)getTiledImageWithSize:(CGSize)size{
    
    UIView *tempView = [[UIView alloc] init];
    tempView.bounds = (CGRect){CGPointZero, size};
    tempView.backgroundColor = [UIColor colorWithPatternImage:self];
    
    UIGraphicsBeginImageContext(size);
    [tempView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return bgImage;
}

+ (NSData *)createThumbImage:(UIImage *)image size:(CGSize )thumbSize percent:(float)percent
{
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat scaleFactor = 0.0;
    CGPoint thumbPoint = CGPointMake(0.0,0.0);
    CGFloat widthFactor = thumbSize.width / width;
    CGFloat heightFactor = thumbSize.height / height;
    if (widthFactor > heightFactor)  {
        scaleFactor = widthFactor;
    }
    else {
        scaleFactor = heightFactor;
    }
    CGFloat scaledWidth  = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    if (widthFactor > heightFactor)
    {
        thumbPoint.y = (thumbSize.height - scaledHeight) * 0.5;
    }
    else if (widthFactor < heightFactor)
    {
        thumbPoint.x = (thumbSize.width - scaledWidth) * 0.5;
    }
    UIGraphicsBeginImageContext(thumbSize);
    CGRect thumbRect = CGRectZero;
    thumbRect.origin = thumbPoint;
    thumbRect.size.width  = scaledWidth;
    thumbRect.size.height = scaledHeight;
    [image drawInRect:thumbRect];
    
    UIImage *thumbImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *thumbImageData = UIImageJPEGRepresentation(thumbImage, percent);

    return thumbImageData;
}

#pragma mark - 压缩图片至指定像素
- (UIImage *)rescaleImageToPX:(CGFloat )toPX
{
    //等比缩放
    CGSize size = self.size;
    if(size.width < toPX && size.height < toPX)
        return self;
    
    CGFloat scale = size.width / size.height;
    if(size.width > size.height)
    {
        size.width = toPX;
        size.height = floorf(size.width / scale);
    }
    else
    {
        size.height = toPX;
        size.width = floorf(size.height * scale);
    }
    
    UIImage *img = [self rescaleImageToSize:size];
    //图片质量
    return [UIImage imageWithData:UIImageJPEGRepresentation(img, 0.7)];
}


#pragma mark - 指定宽高比，获取新的图片
- (UIImage *)subImageWithAspectRatio:(AspectRatio)aspectRatio
{
    CGFloat scaleW = 1;
    CGFloat scaleH = 1;

    switch (aspectRatio)
    {
        case kAspectRatioFree:
            scaleW = [PRJ_Global shareStance].freeScale;
            scaleH = 1;
            
            break;
        case kAspectRatio1_1:
            break;
            
        case kAspectRatio2_3:
            scaleW = 2;
            scaleH = 3;
            break;
            
        case kAspectRatio3_2:
            scaleW = 3;
            scaleH = 2;
            break;
            
        case kAspectRatio3_4:
            scaleW = 3;
            scaleH = 4;
            break;
            
        case kAspectRatio4_3:
            scaleW = 4;
            scaleH = 3;
            break;
            
        case kAspectRatio9_16:
            scaleW = 9;
            scaleH = 16;
            break;
            
        case kAspectRatio16_9:
            scaleW = 16;
            scaleH = 9;
            break;
            
        default:
            break;
    }
    
    CGFloat w = self.size.width;
    CGFloat h = self.size.height;
    
    if(scaleW > scaleH){
        h = w / (scaleW / scaleH);
    }else{
        w = h * (scaleW / scaleH);
    }
    
    CGFloat x = (self.size.width - w) * 0.5;
    CGFloat y = (self.size.height - h) * 0.5;
    
    return [self subImageWithRect:CGRectMake(x, y, w, h)];
}


#pragma mark 获取在ScaleAspectFit模式下，image所处imageView的frame
- (CGRect)frameOnScaleAspectFitModeWithViewSize:(CGSize)viewS
{
    CGSize imageS = self.size;
    if(!(imageS.width && imageS.height && viewS.width && viewS.height))
    {
        return CGRectZero;
    }
    
    //等比缩放，image最大尺寸 等于view的对应边框尺寸
    CGFloat scale = imageS.width / imageS.height;
    if(viewS.width < viewS.height){
        imageS.width = viewS.width;
        imageS.height = imageS.width / scale;
    }else{
        imageS.height = viewS.height;
        imageS.width = imageS.height * scale;
    }
    
    CGFloat x = (viewS.width - imageS.width) * 0.5;
    CGFloat y = (viewS.height - imageS.height) * 0.5;
    
    return (CGRect){(CGPoint){x, y}, imageS};
}

#pragma mark 获取在ScaleAspectFill模式下，image显示部分的frame
- (CGRect)frameOnScaleAspectFillMode{
    CGSize size = self.size;
    CGFloat WH = (size.width < size.height) ? size.width : size.height;
    CGFloat X = (WH == size.width) ? 0 : (size.width - WH) * 0.5;
    CGFloat Y = (WH == size.height) ? 0 : (size.height - WH) * 0.5;
    return CGRectMake(X, Y, WH, WH);
}

- (void)adjustImageWithParam:(AdjustImageParam)param CompletionResult:(AdjustImageCompletion)completion
{
    static BOOL inProgress = NO;
    if(inProgress)  return;
    inProgress = YES;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        CIContext *context = [CIContext contextWithOptions: nil];
        
        CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
        
        CIImage *cisourceImg = [[CIImage alloc] initWithImage:self];
        
        [filter setValue:cisourceImg forKey:kCIInputImageKey];
        [filter setValue:[NSNumber numberWithFloat:param.saturation] forKey:kCIInputSaturationKey]; //饱和度
        [filter setValue:[NSNumber numberWithFloat:param.contrast] forKey:kCIInputContrastKey];//对比度
        
        CIImage *tempImage = [filter outputImage];
        filter = [CIFilter filterWithName:@"CIExposureAdjust"];
        [filter setValue:tempImage forKey:kCIInputImageKey];
        [filter setValue:[NSNumber numberWithFloat:param.brightness] forKey:@"inputEV"]; //-10~10
        
        // 得到过滤后的图片
        CIImage *outputImage = [filter outputImage];
        
        // 转换图片
        CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
        UIImage *newImg = [UIImage imageWithCGImage:cgimg]; 
        
        // 释放C对象
        CGImageRelease(cgimg);
        
        inProgress = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(newImg);
        });
    });
}

@end
