//
//  LJieSeeImagesView.m
//  LJieSeeImages
//
//  Created by liangjie on 14/11/27.
//  Copyright (c) 2014年 liangjie. All rights reserved.
//

#import "LJieSeeImagesView.h"
#import "EditViewController.h"

#define IMAGEVIEWCOUNT  2   // 只有2个imageView
#define ALLCount 47  //所有的滤镜效果

@interface LJieSeeImagesView() <UIScrollViewDelegate>
@end

@implementation LJieSeeImagesView
{
    NSUInteger _w;
    NSUInteger _h;
    NSUInteger _nImageCount;

    NSMutableArray * _imageViews;
    NSMutableArray *_filterTypeArrays;
    
    int _curImageViewNum;
    // 纪录上一次坐标
    CGFloat _preOption;
    UIImage *currentImage;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _w = [UIScreen mainScreen].applicationFrame.size.width;
        _h = [UIScreen mainScreen].applicationFrame.size.height;
        _imageViews = [[NSMutableArray alloc] init];
        self.frame = CGRectMake(0, 20, _w, _h);
        self.delegate = self;
        for (int i=0; i<IMAGEVIEWCOUNT; ++i)
        {
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_w * i, 0, _w, _h)];
            [_imageViews addObject:imageView];
        }
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _w = CGRectGetWidth(frame);
        _h = CGRectGetHeight(frame);
        _imageViews = [[NSMutableArray alloc] init];
        self.frame = frame;
        self.delegate = self;
        NSArray *filtersArray = @[@108,@109,@111,@112,@115,@120,@121,@123,
                              @105,@107,@116,@117,@122,@143,@145,@146,
                              @23,@26,@40,@50,@63,@83,@86,@92,
                              @42,@99,@100,@101,@102,@103,@110,@114,
                              @22,@78,@80,@94,@95,@96,@97,@98,
                              @202,@242,@243,@251,@252,@253,@254,@255];
        _filterTypeArrays = [filtersArray mutableCopy];
        for (int i=0; i<IMAGEVIEWCOUNT; ++i)
        {
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_w * i, 0, _w, _h)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [_imageViews addObject:imageView];
        }
        
        [EditViewController receiveFilterResult:^(UIImage *filterImage) {
            currentImage = nil;
            currentImage = filterImage;
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
        if (currentNum % 2)
        {
            UIImageView * imv = _imageViews[1];
            imv.frame = CGRectMake(currentNum*_w, 0, _w, _h);
            imv.image = currentImage;
        }
        else
        {
            UIImageView * imv = _imageViews[0];
            imv.frame = CGRectMake(currentNum*_w, 0, _w, _h);
            imv.image = currentImage;
        }
    }
    //向前看
    else if (scrollView.contentOffset.x >= currentNum*_w)
    {
        if (scrollView.contentOffset.x < _nImageCount*_w-_w)
        {
            if (currentNum % 2)
            {
                UIImageView * imv = _imageViews[0];
                imv.frame = CGRectMake(currentNum*_w+_w, 0, _w, _h);
                imv.image = currentImage;
            }
            else
            {
                UIImageView * imv = _imageViews[1];
                imv.frame = CGRectMake(currentNum*_w+_w, 0, _w, _h);
                imv.image = currentImage;
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int currentNum = scrollView.contentOffset.x / _w;
    if (currentNum != _curImageViewNum)
    {
        id number = _filterTypeArrays[random()%_filterTypeArrays.count];
        NSInteger filterType = [number integerValue];
        _randomNumber(filterType);
        [_filterTypeArrays removeObject:number];
        if (_filterTypeArrays.count == 0)
        {
            NSArray *filtersArray = @[@108,@109,@111,@112,@115,@120,@121,@123,
                                      @105,@107,@116,@117,@122,@143,@145,@146,
                                      @23,@26,@40,@50,@63,@83,@86,@92,
                                      @42,@99,@100,@101,@102,@103,@110,@114,
                                      @22,@78,@80,@94,@95,@96,@97,@98,
                                      @202,@242,@243,@251,@252,@253,@254,@255];
            _filterTypeArrays = nil;
            _filterTypeArrays = [filtersArray mutableCopy];
        }
    }
    _curImageViewNum = currentNum;
}

- (void)receiveRandomNumber:(RandomNumber)numberValue;
{
    _randomNumber = numberValue;
}

@end
