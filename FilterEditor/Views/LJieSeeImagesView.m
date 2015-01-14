//
//  LJieSeeImagesView.m
//  LJieSeeImages
//
//  Created by liangjie on 14/11/27.
//  Copyright (c) 2014年 liangjie. All rights reserved.
//

#import "LJieSeeImagesView.h"
#import "EditViewController.h"
#import "PRJ_Global.h"

#define IMAGEVIEWCOUNT  2   // 只有2个imageView
#define ALLCount 63  //所有的滤镜效果

@interface LJieSeeImagesView() <UIScrollViewDelegate>
@end

@implementation LJieSeeImagesView
{
    NSUInteger _w;
    NSUInteger _h;
    NSUInteger _nImageCount;
    NSMutableArray * _imageViews;
    NSMutableArray *_filterTypeArrays;
    NSInteger groupType;
    int _curImageViewNum;
    // 纪录上一次坐标
    CGFloat _preOption;
    UIImage *currentImage;
    NSArray *list_Array;
    BOOL isFirst;
    BOOL isChanged;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _curImageViewNum = 0;
        _w = CGRectGetWidth(frame);
        _h = CGRectGetHeight(frame);
        _imageViews = [[NSMutableArray alloc] init];
        self.frame = frame;
        self.delegate = self;
        list_Array = @[@[@74,@130,@131,@134,@135,@137,@142,@156],
                       @[@338,@336,@332,@323,@326,@328,@329,@334],
                       @[@108,@109,@111,@112,@115,@120,@121,@123],
                       @[@105,@107,@116,@117,@122,@143,@145,@146],
                       @[@23,@26,@40,@50,@63,@83,@86,@92],
                       @[@202,@242,@243,@251,@252,@253,@254,@255],
                       @[@42,@99,@100,@101,@102,@103,@110,@114],
                       @[@22,@78,@80,@94,@95,@96,@97,@98]];
        _filterTypeArrays = [[NSMutableArray alloc] init];
        [list_Array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[NSArray class]])
            {
                NSArray *array = (NSArray *)obj;
                [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [_filterTypeArrays addObject:obj];
                }];
            }
        }];
        for (int i=0; i<IMAGEVIEWCOUNT; ++i)
        {
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_w * i, 0, _w, _h)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [_imageViews addObject:imageView];
        }
        //侦听滤镜结果图
        [EditViewController receiveFilterResult:^(UIImage *filterImage) {
            currentImage = nil;
            currentImage = filterImage;
            if (isFirst)
            {
                int currentNum = _curImageViewNum + 1;
                UIImageView * imv;
                if (currentNum % 2)
                {
                    imv = _imageViews[1];
                }
                else
                {
                    imv = _imageViews[0];
                }
                imv.frame = CGRectMake(currentNum*_w, 0, _w, _h);
                imv.image = currentImage;
                isFirst = !isFirst;
            }
        }];
        //侦听点击分组名字
        [[PRJ_Global shareStance] changeFilterGroup:^(NSInteger number) {
            groupType = number;
            [PRJ_Global shareStance].draggingIndex = 0;
            if (number == 0)
            {
                [_filterTypeArrays removeAllObjects];
                [list_Array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if ([obj isKindOfClass:[NSArray class]])
                    {
                        NSArray *array = (NSArray *)obj;
                        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            [_filterTypeArrays addObject:obj];
                        }];
                    }
                }];
            }
            else
            {
                isFirst = YES;
                _filterTypeArrays = nil;
                _filterTypeArrays = [[NSMutableArray alloc] initWithArray:list_Array[number - 1]];
                _randomNumber([_filterTypeArrays[[PRJ_Global shareStance].draggingIndex] integerValue]);
            }
        }];
    }
    
    return self;
}

- (void)scanImagesMode:(UIImage *)image
{
    NSAssert(image, @"imageArray is nil, Should not be so! And imageArray.count must be greater than IMAGEVIEWCOUNT!");
    _nImageCount = ALLCount;
    self.contentSize = CGSizeMake(_w * _nImageCount, 0);
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    
    for (int i=0; i<IMAGEVIEWCOUNT; ++i)
    {
        UIImageView * imageView = _imageViews[i];
        imageView.image = image;
        [self addSubview:imageView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollerDidDrag" object:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int currentNum = scrollView.contentOffset.x / _w;
    // 1. 首先判断方向
    // 2. 判断边界
    // 3. 判断使用哪个imageView显示图片
    if (scrollView.contentOffset.x == currentNum*_w)
    {
        _preOption = scrollView.contentOffset.x;
    }
    //往回看
    else if (scrollView.contentOffset.x < _preOption)
    {
        if (!isChanged)
        {
            [PRJ_Global shareStance].draggingIndex--;
            if ([PRJ_Global shareStance].draggingIndex == -1)
            {
                [PRJ_Global shareStance].draggingIndex = _filterTypeArrays.count - 1;
            }
            isChanged = !isChanged;
        }
        
        UIImageView * imv;
        if (currentNum % 2)
        {
            imv = _imageViews[1];
        }
        else
        {
            imv = _imageViews[0];
        }
        imv.frame = CGRectMake(currentNum*_w, 0, _w, _h);
        imv.image = currentImage;
        if (scrollView.contentOffset.x < 0)
        {
            [scrollView setContentOffset:CGPointMake(ALLCount*_w - _w, 0) animated:NO];
            imv.frame = CGRectMake(ALLCount*_w - _w, 0, _w, _h);
        }
    }
    //向前看
    else if (scrollView.contentOffset.x >= currentNum*_w)
    {
        if (!isChanged)
        {
            [PRJ_Global shareStance].draggingIndex++;
            if ([PRJ_Global shareStance].draggingIndex == _filterTypeArrays.count)
            {
                [PRJ_Global shareStance].draggingIndex = 0;
            }
            isChanged = !isChanged;
        }
        
        if (scrollView.contentOffset.x < _nImageCount*_w-_w)
        {
            UIImageView * imv;
            if (currentNum % 2)
            {
                imv = _imageViews[0];
            }
            else
            {
                imv = _imageViews[1];
            }
            CGRect rect = CGRectMake(currentNum*_w+_w, 0, _w, _h);
            imv.frame = rect;
            imv.image = currentImage;
        }
        else
        {
            UIImageView * imv;
            if (currentNum % 2)
            {
                imv = _imageViews[0];
            }
            else
            {
                imv = _imageViews[1];
            }
            [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
            imv.frame = CGRectMake(0, 0, _w, _h);
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int currentNum = scrollView.contentOffset.x / _w;
    if (currentNum != _curImageViewNum)
    {
        id number;
        if (groupType == 0)
        {
            number = _filterTypeArrays[random()%_filterTypeArrays.count];
        }
        else
        {
            number = _filterTypeArrays[[PRJ_Global shareStance].draggingIndex];
            
            //分类每次滑动结束发送回调
            [PRJ_Global shareStance].isDragging = YES;
            [PRJ_Global shareStance].selectedFilterID([PRJ_Global shareStance].draggingIndex);

        }
        NSInteger filterType = [number integerValue];
        _randomNumber(filterType);
        if (groupType == 0)
        {
            [_filterTypeArrays removeObject:number];
            if (_filterTypeArrays.count == 0)
            {
                _filterTypeArrays = nil;
                _filterTypeArrays = [[NSMutableArray alloc] init];
                [list_Array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if ([obj isKindOfClass:[NSArray class]])
                    {
                        NSArray *array = (NSArray *)obj;
                        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            [_filterTypeArrays addObject:obj];
                        }];
                    }
                }];
            }
        }
    }
    _curImageViewNum = currentNum;
    isChanged = NO;
}

- (void)receiveRandomNumber:(RandomNumber)numberValue;
{
    _randomNumber = numberValue;
}

@end
