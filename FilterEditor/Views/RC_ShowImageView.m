//
//  RC_ShowImageView.m
//  FilterEditor
//
//  Created by gaoluyangrc on 15-1-14.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "RC_ShowImageView.h"
#import "EditViewController.h"
#import "PRJ_Global.h"
#import "CMethods.h"
#define ALLCount 63  //所有的滤镜效果

@interface RC_ShowImageView()
{
    NSUInteger _w;
    NSUInteger _h;
    NSInteger groupType;
    UIImage *filter_result_image;
    NSMutableArray *_filterTypeArrays;
    NSArray *list_Array;
    CGPoint beginPoint;
    CGPoint endPoint;
    NSMutableArray *filter_image_array;
}
@end

@implementation RC_ShowImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        filter_image_array = [[NSMutableArray alloc] initWithCapacity:0];
        
        _w = CGRectGetWidth(frame);
        _h = CGRectGetHeight(frame);
        
        list_Array = @[@[@74,@130,@131,@134,@135,@137,@142,@156],
                       @[@338,@336,@332,@323,@326,@328,@329,@334],
                       @[@108,@109,@111,@112,@115,@120,@121,@123],
                       @[@105,@107,@116,@117,@122,@143,@145,@146],
                       @[@23,@26,@40,@50,@63,@83,@86,@92],
                       @[@202,@242,@243,@251,@252,@253,@254,@255],
                       @[@42,@99,@100,@101,@102,@103,@110,@114],
                       @[@22,@78,@80,@94,@95,@96,@97,@98]];
        _filterTypeArrays = [[NSMutableArray alloc] init];
        //加载全部滤镜
        [list_Array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[NSArray class]])
            {
                NSArray *array = (NSArray *)obj;
                [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [_filterTypeArrays addObject:obj];
                }];
            }
        }];
        //侦听滤镜结果图
        [EditViewController receiveFilterResult:^(UIImage *filterImage) {
            if (groupType == 0)
            {
                filter_result_image = nil;
                filter_result_image = filterImage;
            }
            else
            {
                [filter_image_array replaceObjectAtIndex:[PRJ_Global shareStance].draggingIndex withObject:filterImage];
            }
        }];
        //侦听点击分组名字
        [[PRJ_Global shareStance] changeFilterGroup:^(NSInteger number) {
            groupType = number;
            [PRJ_Global shareStance].draggingIndex = 0;
            if (number == 0)
            {
                [_filterTypeArrays removeAllObjects];
                //加载全部滤镜
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
                //加载分组滤镜
                [_filterTypeArrays removeAllObjects];
                [filter_image_array removeAllObjects];
                for (NSInteger i = 0; i < [list_Array[number - 1] count] ; i++)
                {
                    [filter_image_array addObject:@""];
                    [_filterTypeArrays addObject:list_Array[number - 1][i]];
                }
                _randomNumber([_filterTypeArrays[[PRJ_Global shareStance].draggingIndex] integerValue],YES);
            }
        }];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    beginPoint = [touch locationInView:self];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    endPoint = [touch locationInView:self];

    //随机所有滤镜
    if (groupType == 0)
    {
        //防止没有滑动，起来就换滤镜
        if (endPoint.x - beginPoint.x >= -20 && endPoint.x - beginPoint.x <= 20)
            return;
        
        self.image = filter_result_image;
        
        id filter_number = _filterTypeArrays[random()%ALLCount];
        NSInteger filterType = [filter_number integerValue];
        showLabelHUD([PRJ_Global shareStance].filterTitle);
        _randomNumber(filterType,YES);
        
        //避免重复，如果数组空的话再重新加载所有数据
        [_filterTypeArrays removeObject:filter_number];
        if (_filterTypeArrays.count == 0)
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
    }
    //顺序分组中的滤镜
    else
    {
        //前进
        if (endPoint.x - beginPoint.x < -20)
        {
            [PRJ_Global shareStance].draggingIndex++;
            if ([PRJ_Global shareStance].draggingIndex == _filterTypeArrays.count)
            {
                [PRJ_Global shareStance].draggingIndex = 0;
                self.image = [filter_image_array lastObject];
            }
            else
            {
                self.image = filter_image_array[[PRJ_Global shareStance].draggingIndex - 1];
            }
        }
        //后退
        else if (endPoint.x - beginPoint.x > 20)
        {
            [PRJ_Global shareStance].draggingIndex--;
            if ([PRJ_Global shareStance].draggingIndex == -1)
            {
                [PRJ_Global shareStance].draggingIndex = _filterTypeArrays.count - 1;
                if ([filter_image_array[filter_image_array.count - 2] isKindOfClass:[UIImage class]])
                {
                    self.image = filter_image_array[filter_image_array.count - 2];
                }
                else
                {
                    [PRJ_Global shareStance].draggingIndex = 0;
                    return;
                }
            }
            else
            {
                if ([PRJ_Global shareStance].draggingIndex == 0)
                {
                    self.image = [filter_image_array lastObject];
                }
                else
                {
                    if ([filter_image_array[[PRJ_Global shareStance].draggingIndex - 1] isKindOfClass:[UIImage class]])
                    {
                        self.image = filter_image_array[[PRJ_Global shareStance].draggingIndex - 1];
                    }
                    else
                    {
                        [PRJ_Global shareStance].draggingIndex = 0;
                        return;
                    }
                }
            }
        }
        else
        {
            return;
        }
        
        id filter_number = _filterTypeArrays[[PRJ_Global shareStance].draggingIndex];
        //分类每次滑动结束发送回调
        [PRJ_Global shareStance].isDragging = YES;
        [PRJ_Global shareStance].selectedFilterID([PRJ_Global shareStance].draggingIndex);
        NSInteger filterType = [filter_number integerValue];
        
        if ([filter_image_array[[PRJ_Global shareStance].draggingIndex] isEqual:@""])
        {
            _randomNumber(filterType,YES);
        }
        else
        {
            _randomNumber(filterType,NO);
        }
    }
}

- (void)receiveRandomNumber:(RandomNumber)numberValue;
{
    _randomNumber = numberValue;
}

@end
