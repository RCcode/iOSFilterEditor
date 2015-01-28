//
//  ImageEditView.m
//  FilterGrid
//
//  Created by herui on 16/9/14.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import "ImageEditView.h"
#import "ImageEditTopBar.h"
#import "ImageEditFilterView.h"
#import "ImageEditAdjustView.h"
#import "FilterIntensitySliderView.h"
#import "CMethods.h"
#import "IS_Tools.h"
#import "PRJ_Global.h"

@interface ImageEditView() <ImageEditTopBarDelegate, ImageEditFilterViewDelegate, ImageEditAdjustViewDelegate>
{
    ImageEditTopBar *_topBar;
    UIButton *_currTopBarItem;
    ImageEditFilterView *_filterView;
    ImageEditAdjustView *_adjustView;
    UIView *_filterAndAdjustView;
    FilterIntensitySliderView *_filterIntensitySliderView;
    NCFilterType _filterType;
    NSInteger _filterId;
    AdjustImageParam _adjustImageParam;
    BOOL filterIntensitySliderIsShow;
}
@end

@implementation ImageEditView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = colorWithHexString(@"#2f2f2f");
        self.clipsToBounds = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollerDidDrag) name:@"scrollerDidDrag" object:nil];
        
        CGFloat topBarY = self.bounds.size.height;
        CGFloat topBarW = self.bounds.size.width;

        CGFloat H = self.bounds.size.height;
        CGFloat W = self.bounds.size.width;
        
        _filterAndAdjustView = [[UIView alloc]initWithFrame:self.bounds];
        _filterAndAdjustView.backgroundColor = colorWithHexString(@"#2f2f2f");
        [self addSubview:_filterAndAdjustView];
        
        _filterView = [[ImageEditFilterView alloc] initWithFrame:CGRectMake(0, 0, W, H)];
        _filterView.clipsToBounds = YES;
        [_filterAndAdjustView addSubview:_filterView];
        _filterView.delegate = self;

        _adjustView = [[ImageEditAdjustView alloc] initWithFrame:CGRectMake(0, H, W, H)];
        [_filterAndAdjustView addSubview:_adjustView];
        _adjustView.delegate = self;
        
        _topBar = [[ImageEditTopBar alloc] initWithFrame:CGRectMake(0, topBarY, topBarW, 0)];
        [_filterAndAdjustView addSubview:_topBar];
        _topBar.delegate = self;

        _filterIntensitySliderView = [[FilterIntensitySliderView alloc]initWithFrame:self.bounds];
        __weak ImageEditView *imageEditView = self;

        //强度值完成和取消
        [_filterIntensitySliderView setCloseBlock:^(BOOL isCross) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showTools" object:nil];
            [imageEditView showFilterAndAdjustView];
            [imageEditView imageIsCross:isCross];
        }];
        
        [_filterIntensitySliderView.sliderView.slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_filterIntensitySliderView];
    }
    return self;
}

- (void)scrollerDidDrag
{
    if (filterIntensitySliderIsShow)
    {
        [self showFilterAndAdjustView];
        [self imageIsCross:YES];
    }
}

- (void)setStarValue:(float)starValue
{
    _starValue = starValue;
    _filterIntensitySliderView.startValue = _starValue;
}

- (void)setEndValue:(float)endValue
{
    _endValue = endValue;
    _filterIntensitySliderView.endValue = _endValue;
}

- (void)imageIsCross:(BOOL)isCross
{
    if (_delegate && [_delegate respondsToSelector:@selector(imageEditViewRecover:)])
    {
        [_delegate imageEditViewRecover:isCross];
    }
}

-(void)hideFilterIntensitySliderView
{
    [self showFilterAndAdjustView];
}

- (void)setEditAdjustViewParam:(AdjustImageParam)param{
    _adjustView.adjustImageParam = param;
}

#pragma mark - ImageEditTopBarDelegate
- (void)imageEditTopBar:(ImageEditTopBar *)imageEditTopBar DidSelectItemWithType:(ImageEditTopBarItemType)itemType
{
    //切换filter、adjust
    switch (itemType)
    {
        case kImageEditTopBarItemTypeFilter:
        {
            CGFloat H = self.bounds.size.height;
            CGFloat W = self.bounds.size.width;
            [IS_Tools ViewAnimation:_filterView withFrame:CGRectMake(0, 0, W, H)];
            [IS_Tools ViewAnimation:_adjustView withFrame:CGRectMake(0, H, W, H)];
        }
            break;
            
        case kImageEditTopBarItemTypeAdjust:
        {
            CGFloat H = self.bounds.size.height;
            CGFloat W = self.bounds.size.width;
            [IS_Tools ViewAnimation:_filterView withFrame:CGRectMake(0, H, W, H)];
            [IS_Tools ViewAnimation:_adjustView withFrame:CGRectMake(0, 0, W, H)];
        }
            break;
            
        case kImageEditTopBarItemTypeConfirm:
        {
            //
            NSString *filterTypeEvent = [NSString stringWithFormat:@"editgrid_%ld", (long)_filterId];
            [PRJ_Global event:filterTypeEvent label:@"EditGrid"];
            //退出
            if([_delegate respondsToSelector:@selector(imageEditViewConfirm:)]){
                [_delegate imageEditViewConfirm:self];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -sliderValueChange
- (void)sliderValueChange:(UISlider *)slider
{
    if (!filterIntensitySliderIsShow)
    {
        return;
    }
    _filterIntensitySliderView.sliderView.value = slider.value;
    SliderView *sli = (_filterIntensitySliderView.sliderView);
    int num = (slider.value-sli.minimumValue)/(sli.maximumValue-sli.minimumValue)*100;
    showLabelHUD([NSString stringWithFormat:@"%d",num]);
    if (_delegate && [_delegate respondsToSelector:@selector(imageEditView:ChangeFilterIntensity:WithFilterId:)])
    {
        [_delegate imageEditView:self ChangeFilterIntensity:slider.value WithFilterId:_filterId];
    }
}

- (void)imageEditFilterViewGroupName:(NSString *)name
{
    if (_delegate && [_delegate respondsToSelector:@selector(imageEditViewGropName:)])
    {
        [_delegate imageEditViewGropName:name];
    }
}

#pragma mark - ImageEditFilterViewDelegate
-(void)imageEditFilterView:(ImageEditFilterView *)imageEditFilterView ChangeFilterId:(NSInteger)filterId btnTag:(NSInteger)buttonTag
{
    _filterId = filterId;
    if (_delegate && [_delegate respondsToSelector:@selector(imageEditView:ChangeFilterId:btnTag:)])
    {
        [_delegate imageEditView:self ChangeFilterId:_filterId btnTag:buttonTag];
    }
}

-(void)secondTimeSelectListView
{
    NSString *fileName = [NSString stringWithFormat:@"com_rcplatform_filter_config_%ld",(long)_filterId];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];

    NSArray *keyArray = [dictionary allKeys];
    if ([keyArray containsObject:@"progressConfig"])
    {
        NSDictionary *dic = [dictionary objectForKey:@"progressConfig"];
        NSArray *keys = [dic allKeys];
        if ([keys containsObject:@"startProgress"])
        {
            float startProgress = [[dic objectForKey:@"startProgress"]integerValue]/100.0;
            _filterIntensitySliderView.startValue = startProgress;
        }
        if ([keys containsObject:@"endProgress"])
        {
            float endProgress = [[dic objectForKey:@"endProgress"]integerValue]/100.0;
            _filterIntensitySliderView.endValue = endProgress;
        }
        if ([keys containsObject:@"defaultProgress"])
        {
            float defaultProgress = [[dic objectForKey:@"defaultProgress"]integerValue]/100.0;
            _filterIntensitySliderView.currentValue = defaultProgress;
        }
    }
    
    [IS_Tools ViewAnimation:_filterIntensitySliderView withFrame:CGRectMake(0, 0, CGRectGetWidth(_filterIntensitySliderView.frame), CGRectGetHeight(_filterIntensitySliderView.frame))];
    [IS_Tools ViewAnimation:_filterAndAdjustView withFrame:CGRectMake(0, CGRectGetHeight(_filterAndAdjustView.frame), CGRectGetWidth(_filterAndAdjustView.frame), CGRectGetHeight(_filterAndAdjustView.frame))];
    filterIntensitySliderIsShow = YES;
}

-(void)showFilterAndAdjustView
{
    [IS_Tools ViewAnimation:_filterIntensitySliderView withFrame:CGRectMake(0, CGRectGetHeight(_filterIntensitySliderView.frame), CGRectGetWidth(_filterIntensitySliderView.frame), CGRectGetHeight(_filterIntensitySliderView.frame))];
    [IS_Tools ViewAnimation:_filterAndAdjustView withFrame:CGRectMake(0, 0, CGRectGetWidth(_filterAndAdjustView.frame), CGRectGetHeight(_filterAndAdjustView.frame))];
    filterIntensitySliderIsShow = NO;
}

#pragma mark - ImageEditAdjustViewDelegate
- (void)imageEditAdjustView:(ImageEditAdjustView *)imageEditAdjustView WithAdjustImageParam:(AdjustImageParam)adjustImageParam{
    
    _adjustImageParam = adjustImageParam;
    
    if([_delegate respondsToSelector:@selector(imageEditView:AdjustImageWithAdjustImageParam:)]){
        [_delegate imageEditView:self AdjustImageWithAdjustImageParam:adjustImageParam];
    }
}

@end
