//
//  ImageEditAdjustView.m
//  FilterGrid
//
//  Created by herui on 16/9/14.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import "ImageEditAdjustView.h"
#import "ImageEditAdjustViewBottomBar.h"
#import "SliderView.h"
#import "CMethods.h"
#import "PRJ_Global.h"

@interface ImageEditAdjustView() <ImageEditAdjustViewBottomBarDelegate>
{
    NSMutableArray *_sliders;
    
    CGFloat _preValue;
    ImageEditAdjustViewBottomBar *bottomBar;
}

@property (nonatomic, assign) ImageAdjustItemType adjsutType;

@end

@implementation ImageEditAdjustView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = colorWithHexString(@"#282828");
        
        CGFloat bottomBarH = 44;
        CGFloat bottomBarW = self.bounds.size.width;
        CGFloat bottomBarY = self.bounds.size.height - bottomBarH;
        bottomBar = [[ImageEditAdjustViewBottomBar alloc] initWithFrame:CGRectMake(0, bottomBarY, bottomBarW, bottomBarH)];
        [self addSubview:bottomBar];
        bottomBar.delegate = self;
        
        _slidersBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 60)];
        [self addSubview:_slidersBgView];
        
        _sliders = [NSMutableArray arrayWithCapacity:kImageAdjustItemTypeTotalNumber];
        
    }
    return self;
}

- (void)sliderValueDidChange:(UISlider *)slider
{
    bottomBar.userInteractionEnabled = YES;
    self.superview.userInteractionEnabled = YES;
    switch (_adjsutType) {
        case kImageAdjustItemTypeBrightness:
            [PRJ_Global event:@"editgrid_light" label:@"EditGrid"];
            break;
            
        case kImageAdjustItemTypeContrast:
            [PRJ_Global event:@"editgrid_contrast" label:@"EditGrid"];
            break;
            
        case kImageAdjustItemTypeSaturation:
            [PRJ_Global event:@"editgrid_saturation" label:@"EditGrid"];
            break;
            
        case kImageAdjustItemTypeColorTemperature:
        {
            
        }
            break;;
            
        case kImageAdjustItemTypeSharpening:
        {
            
        }
            break;
        default:
            break;
    }
}

- (void)sliderValueChange:(UISlider *)slider
{
    bottomBar.userInteractionEnabled = NO;
    self.superview.userInteractionEnabled = NO;
    CGFloat val = slider.value;
    ((SliderView *)slider.superview).value = slider.value;
    SliderView *sli =(SliderView *)(slider.superview);
    int num = (val-sli.minimumValue)/(sli.maximumValue-sli.minimumValue)*100;
    showLabelHUD([NSString stringWithFormat:@"%d",num]);
    NSLog(@"slider.value:%f",slider.value);
    _preValue = val;
    NSLog(@"val - %.2f", val);
    
    switch (_adjsutType) {
        case kImageAdjustItemTypeBrightness:
            _adjustImageParam.brightness = val;
            break;
            
        case kImageAdjustItemTypeContrast:
            _adjustImageParam.contrast = val;
            break;
            
        case kImageAdjustItemTypeSaturation:
            _adjustImageParam.saturation = val;
            break;
            
        case kImageAdjustItemTypeColorTemperature:
            _adjustImageParam.colorTemperature = val;
            break;
            
        case kImageAdjustItemTypeSharpening:
            _adjustImageParam.sharpening = val;
            break;
            
        default:
            break;
    }
    
    if([_delegate respondsToSelector:@selector(imageEditAdjustView:WithAdjustImageParam:)])
    {
        [_delegate imageEditAdjustView:self WithAdjustImageParam:_adjustImageParam];
    }
}

- (void)setAdjsutType:(ImageAdjustItemType)adjsutType
{
    _adjsutType = adjsutType;
    
    for (UIView *child in _slidersBgView.subviews) {
        if([child isKindOfClass:[SliderView class]]){
            child.hidden = YES;
        }
    }
    SliderView *slider = _sliders[adjsutType];
    slider.hidden = NO;
    
    CGFloat val = 1;
    switch (_adjsutType) {
        case kImageAdjustItemTypeBrightness:
            val = _adjustImageParam.brightness;
            break;
            
        case kImageAdjustItemTypeContrast:
            val = _adjustImageParam.contrast;
            break;
            
        case kImageAdjustItemTypeSaturation:
            val = _adjustImageParam.saturation;
            break;
            
        case kImageAdjustItemTypeColorTemperature:
            val = _adjustImageParam.colorTemperature;
            break;
            
        case kImageAdjustItemTypeSharpening:
            val = _adjustImageParam.sharpening;
            break;
            
        default:
            break;
    }
    
    slider.value = val;
    _preValue = val;
}

#pragma mark - ImageEditAdjustViewBottomBarDelegate
- (void)imageEditAdjustViewBottomBar:(ImageEditAdjustViewBottomBar *)imageEditAdjustViewBottomBar DidSelectTyep:(ImageAdjustItemType)type
{
    self.adjsutType = type;
}

@end
