//
//  ScreenshotBorder.m
//  PRJ_Test
//
//  Created by 贺瑞 on 14-4-16.
//  Copyright (c) 2014年 rcplatfrom. All rights reserved.
//

#import "ScreenshotBorderView.h"
#import "UIImage+SubImage.h"
#import "ControlBorder.h"
#import "ImageScaleUtil.h"
#import "CMethods.h"
#import "PRJ_Global.h"

@interface ScreenshotBorderView() <CameraApertureDelegate>

{
    //透明截图框
    CameraApertureView *_cameraAperture;
    
    //四周遮盖
    UIView *_topCover;
    UIView *_bottomCover;
    UIView *_leftCover;
    UIView *_rightCover;
    
    //四个按钮
    
    UIImageView *ltImageView;
    UIImageView *lbImageView;
    UIImageView *rtImageView;
    UIImageView *rbImageView;
    
    //srcIamge对象的尺寸
    CGSize _srcImageSize;

    ControlBorder *_controlBorder;
    CGPoint _center;
    
}

@end


@implementation ScreenshotBorderView

#pragma mark - setter method
- (void)setSrcImage:(UIImage *)srcImage{
    
    [self setImage:srcImage];
    
    
    //初始化其它子控件
    [self setupChildViews];
}

- (void)resetSrcImage:(UIImage *)srcImage
{
    [self setImage:srcImage];
    [self setupChildViews];
}

- (void)setImage:(UIImage *)image
{
    _srcImage = image;
    //初始化srcImageSize
    _srcImageSize = _srcImage.size;
    
    //2448 3264
    //    NSAssert(_srcImageSize.width >= 100 && _srcImageSize.height >= 100,
    //             @"被用于截图的图片，尺寸不能小于100*100");
    
    CGFloat scale = [ImageScaleUtil getTheScaleForImageSize:_srcImageSize];

    _srcImageSize.height = _srcImageSize.height / scale;
    _srcImageSize.width = _srcImageSize.width / scale;
    
    CGSize size = self.frame.size;
    //等比缩放（针对大图片超出界面的情况）
    if(_srcImageSize.width > size.width){
        CGFloat scale = _srcImageSize.width / _srcImageSize.height;
        _srcImageSize.width = size.width;
        _srcImageSize.height = _srcImageSize.width / scale;
    }
    if(_srcImageSize.height > size.height){
        CGFloat scale = _srcImageSize.width / _srcImageSize.height;
        _srcImageSize.height = size.height;
        _srcImageSize.width = _srcImageSize.height * scale;
    }
    
    //初始化 borderRect
    if (_srcImageSize.width > DefaultBorderSizeDiff && _srcImageSize.height > DefaultBorderSizeDiff) {
        CGSize borderSize = CGSizeMake(_srcImageSize.width ,_srcImageSize.height);
        CGPoint boderOrigin = CGPointMake(0 ,0);
        CGRect rect = self.borderRect;
        rect.origin = boderOrigin;
        rect.size = borderSize;
        self.borderRect = rect;
    }
    else if(_srcImageSize.width > DefaultBorderSizeDiff)
    {
        CGSize borderSize = CGSizeMake(_srcImageSize.width - DefaultBorderSizeDiff,
                                       _srcImageSize.height);
        CGPoint boderOrigin = CGPointMake(DefaultBorderSizeDiff / 2,
                                          0);
        
        CGRect rect = self.borderRect;
        rect.origin = boderOrigin;
        rect.size = borderSize;
        self.borderRect = rect;
    }
    else if(_srcImageSize.height > DefaultBorderSizeDiff)
    {
        CGSize borderSize = CGSizeMake(_srcImageSize.width,
                                       _srcImageSize.height - DefaultBorderSizeDiff);
        CGPoint boderOrigin = CGPointMake(0,
                                          DefaultBorderSizeDiff / 2);
        
        CGRect rect = self.borderRect;
        rect.origin = boderOrigin;
        rect.size = borderSize;
        self.borderRect = rect;
    }
    else
    {
        CGSize borderSize = CGSizeMake(_srcImageSize.width,
                                       _srcImageSize.height);
        CGPoint boderOrigin = CGPointMake(0,
                                          _srcImageSize.width);
        
        CGRect rect = self.borderRect;
        rect.origin = boderOrigin;
        rect.size = borderSize;
        self.borderRect = rect;
    }
}

- (void)hiddenBorderView
{
    _topCover.hidden = YES;
    _leftCover.hidden = YES;
    _rightCover.hidden = YES;
    _bottomCover.hidden = YES;
    _cameraAperture.hidden = YES;
}

- (void)showBorderView
{
    _topCover.hidden = NO;
    _leftCover.hidden = NO;
    _rightCover.hidden = NO;
    _bottomCover.hidden = NO;
    _cameraAperture.hidden = NO;
}

#pragma mark - private method

#pragma mark 初始化子控件
- (void)setupChildViews{
    
    if(_srcImage == nil) return;
    
    //初始化imageVIew
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:(CGRect){CGPointZero, _srcImageSize}];
        [self addSubview:_imageView];

     }else{
        _imageView.frame = (CGRect){CGPointZero,_srcImageSize};
    }
    _imageView.center = self.center;
    _imageView.image = _srcImage;
    _imageView.userInteractionEnabled = YES;
    
    //初始化四周遮盖
    if (_topCover == nil) {
        _topCover = [[UIView alloc] init];
        _bottomCover = [[UIView alloc] init];
        _leftCover = [[UIView alloc] init];
        _rightCover = [[UIView alloc] init];
        
        [_imageView addSubview:_topCover];
        [_imageView addSubview:_bottomCover];
        [_imageView addSubview:_leftCover];
        [_imageView addSubview:_rightCover];
    }
    
    
    //初始化取景框
    if (_cameraAperture == nil) {
        _cameraAperture = [[CameraApertureView alloc] initWithFrame:_borderRect];
        [_imageView addSubview:_cameraAperture];
    }else{
        _cameraAperture.frame = _borderRect;
    }
    
    _center = _cameraAperture.center;
    _cameraAperture.delegate = self;
    
    //初始化操控边框
    if (_controlBorder == nil) {
        _controlBorder = [ControlBorder controlBorder];
        [_imageView addSubview:_controlBorder];
    }
    
    
    CGFloat margin = 15.0f;
    _controlBorder.frame = CGRectMake(_cameraAperture.frame.origin.x - margin,
               _cameraAperture.frame.origin.y - margin,
               _cameraAperture.frame.size.width + margin * 2 ,
               _cameraAperture.frame.size.height + margin * 2);
//    controlBorder.frame = _cameraAperture.frame;
    
    _cameraAperture.controlBorder = _controlBorder;
    
    if (ltImageView == nil) {
        ltImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
        lbImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
        rtImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
        rbImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
        
        [ltImageView setImage:[UIImage imageNamed:@"fe_btn_Cutting frame"]];
        [lbImageView setImage:[UIImage imageNamed:@"fe_btn_Cutting frame"]];
        [rtImageView setImage:[UIImage imageNamed:@"fe_btn_Cutting frame"]];
        [rbImageView setImage:[UIImage imageNamed:@"fe_btn_Cutting frame"]];
        
        [_imageView addSubview:ltImageView];
        [_imageView addSubview:lbImageView];
        [_imageView addSubview:rtImageView];
        [_imageView addSubview:rbImageView];
    }

    //设置遮盖背景为半透明黑色
    UIColor * background = [colorWithHexString(@"#000000") colorWithAlphaComponent:0.45];
    _topCover.backgroundColor = background;
    _bottomCover.backgroundColor = background;
    _leftCover.backgroundColor = background;
    _rightCover.backgroundColor = background;
    
    //计算各个cover的frame
    [self cameraApertureFrameChanged:nil];
}


#pragma mark - open method

#pragma mark 快速实例化
+ (instancetype)screenshotBorderWithSrcImage:(UIImage *)srcImage{
    
    ScreenshotBorderView *instance = [[[self class] alloc] initWithFrame:(CGRect){CGPointZero, srcImage.size}];
    //初始化 srcImage
    instance.srcImage = srcImage;
    
    return instance;
}

#pragma mark 截图
- (UIImage *)subImage
{
    //缩放比例
    CGFloat scaleX = _srcImage.size.width / _imageView.frame.size.width;
    CGFloat scaleY =  _srcImage.size.height / _imageView.frame.size.height;

    CGFloat x = _cameraAperture.frame.origin.x * scaleX;
    CGFloat y = _cameraAperture.frame.origin.y * scaleY;
    CGFloat width = _cameraAperture.frame.size.width * scaleX;
    CGFloat height = _cameraAperture.frame.size.height * scaleY;
    if (x+width > _srcImage.size.width) {
        width = _srcImage.size.width - x;
    }
    if (y+height > _srcImage.size.height) {
        height = _srcImage.size.height - y;
    }
    return [_srcImage subImageWithRect:CGRectMake(x, y, width, height)];
}

#pragma mark - CameraApertureDelegate
- (void)cameraApertureFrameChanged:(CameraApertureView *)cameraAperture
{
    //根据_cameraAperture.frame，计算四个遮盖的frame
    CGRect cameraApertureF = _cameraAperture.frame;
    
    CGFloat topX = 0;
    CGFloat topY = 0;
    CGFloat topW = _imageView.frame.size.width;
    CGFloat topH = cameraApertureF.origin.y;
    CGRect topF = CGRectMake(topX, topY, topW, topH);
    
    CGFloat buttomX = topX;
    CGFloat buttomY = CGRectGetMaxY(cameraApertureF);
    CGFloat buttomW = topW;
    CGFloat buttomH = _imageView.frame.size.height - buttomY;
    CGRect buttomF = CGRectMake(buttomX, buttomY, buttomW, buttomH);
    
    CGFloat leftX = topX;
    CGFloat leftY = CGRectGetMaxY(topF);
    CGFloat leftW = cameraApertureF.origin.x;
    CGFloat leftH = cameraApertureF.size.height;
    CGRect leftF = CGRectMake(leftX, leftY, leftW, leftH);
    
    CGFloat rightX = CGRectGetMaxX(cameraApertureF);
    CGFloat rightY = cameraApertureF.origin.y;
    CGFloat rightW = _imageView.frame.size.width - rightX;
    CGFloat rightH = cameraApertureF.size.height;
    CGRect rightF = CGRectMake(rightX, rightY, rightW, rightH);
    
    _topCover.frame = topF;
    _bottomCover.frame = buttomF;
    _leftCover.frame = leftF;
    _rightCover.frame = rightF;
    
    [ltImageView setCenter:CGPointMake(CGRectGetMinX(cameraApertureF), CGRectGetMinY(cameraApertureF))];
    [lbImageView setCenter:CGPointMake(CGRectGetMinX(cameraApertureF), CGRectGetMaxY(cameraApertureF))];
    [rtImageView setCenter:CGPointMake(CGRectGetMaxX(cameraApertureF), CGRectGetMinY(cameraApertureF))];
    [rbImageView setCenter:CGPointMake(CGRectGetMaxX(cameraApertureF), CGRectGetMaxY(cameraApertureF))];
}

- (void)setSubViewBorder
{
    CGFloat margin = 15.0f;
    CGRect frame;
    CGSize borderSize = CGSizeMake(_srcImageSize.width ,_srcImageSize.height);
    CGPoint boderOrigin = CGPointMake(0 ,0);
    CGRect rect = self.borderRect;
    rect.origin = boderOrigin;
    rect.size = borderSize;
    self.borderRect = rect;
    frame = self.borderRect;
    [UIView animateWithDuration:0.3 animations:^{
        _cameraAperture.frame = frame;
        _controlBorder.frame = CGRectMake(_cameraAperture.frame.origin.x - margin,
                                          _cameraAperture.frame.origin.y - margin,
                                          _cameraAperture.frame.size.width + margin * 2 ,
                                          _cameraAperture.frame.size.height + margin * 2);
        _cameraAperture.controlBorder = _controlBorder;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setCameraCropStyle:(AspectRatio)style
{
    CGFloat margin = 15.0f;
    CGRect frame;
    switch (style)
    {
        case kAspectRatioFree:
        {
            frame = self.borderRect;
        }
            break;
            
        case kAspectRatio1_1:
        {
            CGFloat length = 0;
               length = self.borderRect.size.width > self.borderRect.size.height ? self.borderRect.size.height : self.borderRect.size.width;
            
            frame = self.borderRect;
            frame.size = CGSizeMake(length, length);
            if (self.borderRect.size.width > self.borderRect.size.height) {
                frame.origin.x += (self.borderRect.size.width - length) / 2;
            }else{
                frame.origin.y += (self.borderRect.size.height - length) / 2;
            }
        }
            break;
            
        case kAspectRatio2_3:
        {
            frame = self.borderRect;
            if (self.borderRect.size.height <= self.borderRect.size.width)
            {
                float width = frame.size.height * 2 / 3;
                if (width >= frame.size.width)
                {
                    width = frame.size.width;
                    float height = width * 3 / 2;
                    frame.origin.y += (frame.size.height - height) / 2;
                    frame.size.height = height;
                }
                frame.origin.x += (frame.size.width - width) /2 ;
                frame.size.width = width;
            }else{
                if (self.borderRect.size.height * 2 / 3 > self.borderRect.size.width )
                {
                    float height = frame.size.width * 3 / 2;
                    if (height >= frame.size.height)
                    {
                        height = frame.size.height;
                        float width = height * 2 / 3;
                        frame.origin.x += (frame.size.width - width) / 2;
                        frame.size.width = width;
                    }
                    frame.origin.y += (frame.size.height - height) / 2;
                    frame.size.height = height;
                }else{
                    float width = frame.size.height * 2 / 3;
                    if (width >= frame.size.width)
                    {
                        width = frame.size.width;
                        float height = width * 3 / 2;
                        frame.origin.y += (frame.size.height - height) / 2;
                        frame.size.height = height;
                    }
                    frame.origin.x += (frame.size.width - width) / 2;
                    frame.size.width = width;
                }
            }
        }
            break;
            
        case kAspectRatio3_2:
        {
            frame = self.borderRect;
            if (self.borderRect.size.height <= self.borderRect.size.width) {
                float width = frame.size.height * 3 / 2;
                if (width >= frame.size.width)
                {
                    width = frame.size.width;
                    float height = width * 2 / 3;
                    frame.origin.y += (frame.size.height - height) / 2;
                    frame.size.height = height;
                }
                frame.origin.x += (frame.size.width - width) / 2 ;
                frame.size.width = width;
            }else{
                if (self.borderRect.size.height * 3 / 2 > self.borderRect.size.width )
                {
                    float height = frame.size.width * 2 / 3;
                    if (height >= frame.size.height)
                    {
                        height = frame.size.height;
                        float width = height * 3 / 2;
                        frame.origin.x += (frame.size.width - width) / 2;
                        frame.size.width = width;
                    }
                    frame.origin.y += (frame.size.height - height) / 2;
                    frame.size.height = height;
                }else{
                    float width = frame.size.height * 3 / 2;
                    if (width >= frame.size.width)
                    {
                        width = frame.size.width;
                        float height = width * 2 / 3;
                        frame.origin.y += (frame.size.height - height) / 2;
                        frame.size.height = height;
                    }
                    frame.origin.x += (frame.size.width - width) / 2;
                    frame.size.width = width;
                    
                }
            }
        }
            break;
            
        case kAspectRatio3_4:
        {
            frame = self.borderRect;
            if (self.borderRect.size.height <= self.borderRect.size.width) {
                float width = frame.size.height * 3 / 4;
                if (width >= frame.size.width)
                {
                    width = frame.size.width;
                    float height = width * 4 / 3;
                    frame.origin.y += (frame.size.height - height) / 2;
                    frame.size.height = height;
                }
                frame.origin.x += (frame.size.width - width) /2 ;
                frame.size.width = width;
            }else{
                if (self.borderRect.size.height * 3 / 4 > self.borderRect.size.width )
                {
                    float height = frame.size.width * 4 / 3;
                    if (height >= frame.size.height)
                    {
                        height = frame.size.height;
                        float width = height * 3 / 4;
                        frame.origin.x += (frame.size.width - width) / 2;
                        frame.size.width = width;
                    }
                    frame.origin.y += (frame.size.height - height) / 2;
                    frame.size.height = height;
                }else{
                    float width = frame.size.height * 3 / 4;
                    if (width >= frame.size.width)
                    {
                        width = frame.size.width;
                        float height = width * 4 / 3;
                        frame.origin.y += (frame.size.height - height) / 2;
                        frame.size.height = height;
                    }
                    frame.origin.x += (frame.size.width - width) / 2;
                    frame.size.width = width;
                    
                }
            }
        }
            break;
            
        case kAspectRatio4_3:
        {
            frame = self.borderRect;
            if (self.borderRect.size.height <= self.borderRect.size.width)
            {
                float width = frame.size.height * 4 / 3;
                if (width >= frame.size.width)
                {
                    width = frame.size.width;
                    float height = width * 3 / 4;
                    frame.origin.y += (frame.size.height - height) / 2;
                    frame.size.height = height;
                }
                frame.origin.x += (frame.size.width - width) / 2 ;
                frame.size.width = width;
            }
            else
            {
                if (self.borderRect.size.height * 4 / 3 > self.borderRect.size.width)
                {
                    float height = frame.size.width * 3 / 4;
                    if (height >= frame.size.height)
                    {
                        height = frame.size.height;
                        float width = height * 4 / 3;
                        frame.origin.x += (frame.size.width - width) / 2;
                        frame.size.width = width;
                    }
                    frame.origin.y += (frame.size.height - height) / 2;
                    frame.size.height = height;
                }else{
                    float width = frame.size.height * 4 / 3;
                    if (width >= frame.size.width)
                    {
                        width = frame.size.width;
                        float height = width * 3 / 4;
                        frame.origin.y += (frame.size.height - height) / 2;
                        frame.size.height = height;
                    }
                    frame.origin.x += (frame.size.width - width) / 2;
                    frame.size.width = width;
                    
                }
            }
        }
            break;
            
        case kAspectRatio9_16:
        {
            frame = self.borderRect;
            if (self.borderRect.size.height <= self.borderRect.size.width) {
                float width = frame.size.height * 9 / 16;
                if (width >= frame.size.width)
                {
                    width = frame.size.width;
                    float height = width * 16 / 9;
                    frame.origin.y += (frame.size.height - height) / 2;
                    frame.size.height = height;
                }
                frame.origin.x += (frame.size.width - width) /2 ;
                frame.size.width = width;
            }else{
                if (self.borderRect.size.height * 9 / 16 > self.borderRect.size.width )
                {
                    float height = frame.size.width * 16 / 9;
                    if (height >= frame.size.height)
                    {
                        height = frame.size.height;
                        float width = height * 9 / 16;
                        frame.origin.x += (frame.size.width - width) / 2;
                        frame.size.width = width;
                    }
                    frame.origin.y += (frame.size.height - height) / 2;
                    frame.size.height = height;
                }else{
                    float width = frame.size.height * 9 / 16;
                    if (width >= frame.size.width)
                    {
                        width = frame.size.width;
                        float height = width * 16 / 9;
                        frame.origin.y += (frame.size.height - height) / 2;
                        frame.size.height = height;
                    }
                    frame.origin.x += (frame.size.width - width) / 2;
                    frame.size.width = width;
                }
            }
        }
            break;
            
        case kAspectRatio16_9:
        {
            frame = self.borderRect;
            if (self.borderRect.size.height <= self.borderRect.size.width)
            {
                float width = frame.size.height * 16 / 9;
                if (width >= frame.size.width)
                {
                    width = frame.size.width;
                    float height = width * 9 / 16;
                    frame.origin.y += (frame.size.height - height) / 2;
                    frame.size.height = height;
                }
                frame.origin.x += (frame.size.width - width) /2 ;
                frame.size.width = width;
            }
            else
            {
                if (self.borderRect.size.height * 16 / 9 > self.borderRect.size.width)
                {
                    float height = frame.size.width * 9 / 16;
                    if (height >= frame.size.height)
                    {
                        height = frame.size.height;
                        float width = height * 16 / 9;
                        frame.origin.x += (frame.size.width - width) / 2;
                        frame.size.width = width;
                    }
                    frame.origin.y += (frame.size.height - height) / 2;
                    frame.size.height = height;
                }else{
                    float width = frame.size.height * 16 / 9;
                    if (width >= frame.size.width)
                    {
                        width = frame.size.width;
                        float height = width * 9 / 16;
                        frame.origin.y += (frame.size.height - height) / 2;
                        frame.size.height = height;
                    }
                    frame.origin.x += (frame.size.width - width) / 2;
                    frame.size.width = width;
                }
            }
        }
            break;
            
        default:
            break;
    }
    _cameraAperture.style = style;
    [UIView animateWithDuration:0.3 animations:^{
        _cameraAperture.frame = frame;
        _controlBorder.frame = CGRectMake(_cameraAperture.frame.origin.x - margin,
                                          _cameraAperture.frame.origin.y - margin,
                                          _cameraAperture.frame.size.width + margin * 2 ,
                                          _cameraAperture.frame.size.height + margin * 2);
        
        _cameraAperture.controlBorder = _controlBorder;
    } completion:^(BOOL finished) {
        
    }];
}

@end
