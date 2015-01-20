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

@interface RC_ShowImageView()
{
    NSUInteger _w;
    NSUInteger _h;
    NSArray *list_Array;
    CGPoint beginPoint;
    CGPoint endPoint;
}

@property (nonatomic ,strong) UIImage *filter_result_image;

@end

@implementation RC_ShowImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        [PRJ_Global shareStance].filter_image_array = [[NSMutableArray alloc] initWithCapacity:0];
        
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
        [PRJ_Global shareStance].filterTypeArrays = [[NSMutableArray alloc] init];
        //加载全部滤镜
        [list_Array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[NSArray class]])
            {
                NSArray *array = (NSArray *)obj;
                [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [[PRJ_Global shareStance].filterTypeArrays addObject:obj];
                }];
            }
        }];
        //侦听滤镜结果图
        __weak RC_ShowImageView *weakSelf = self;
        [EditViewController receiveFilterResult:^(UIImage *filterImage) {
            
            [weakSelf performSelector:@selector(hiddenCoverView) withObject:nil afterDelay:0.7f];
            if ([PRJ_Global shareStance].groupType == 0)
            {
                weakSelf.filter_result_image = nil;
                weakSelf.filter_result_image = filterImage;
            }
            else
            {
                [[PRJ_Global shareStance].filter_image_array replaceObjectAtIndex:[PRJ_Global shareStance].draggingIndex withObject:filterImage];
            }
        }];
        //侦听点击分组名字
        [[PRJ_Global shareStance] changeFilterGroup:^(NSInteger number) {
            [PRJ_Global shareStance].groupType = number;
            [PRJ_Global shareStance].draggingIndex = 0;
            if (number == 0)
            {
                [[PRJ_Global shareStance].filterTypeArrays removeAllObjects];
                //加载全部滤镜
                [list_Array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if ([obj isKindOfClass:[NSArray class]])
                    {
                        NSArray *array = (NSArray *)obj;
                        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            [[PRJ_Global shareStance].filterTypeArrays addObject:obj];
                        }];
                    }
                }];
            }
            else
            {
                //加载分组滤镜
                [[PRJ_Global shareStance].filterTypeArrays removeAllObjects];
                [[PRJ_Global shareStance].filter_image_array removeAllObjects];
                for (NSInteger i = 0; i < [list_Array[number - 1] count] ; i++)
                {
                    [[PRJ_Global shareStance].filter_image_array addObject:@""];
                    [[PRJ_Global shareStance].filterTypeArrays addObject:list_Array[number - 1][i]];
                }
                [PRJ_Global shareStance].randomNumber([[PRJ_Global shareStance].filterTypeArrays[[PRJ_Global shareStance].draggingIndex] integerValue],YES);
            }
        }];
    }
    
    return self;
}

- (void)hiddenCoverView
{
    hiddenCoverViewForWindow();
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
    if ([PRJ_Global shareStance].groupType == 0)
    {
        //防止没有滑动，起来就换滤镜
        if (endPoint.x - beginPoint.x >= -20 && endPoint.x - beginPoint.x <= 20)
            return;
        showCoverViewForWindow();
        
        self.image = _filter_result_image;
        
        id filter_number = [PRJ_Global shareStance].filterTypeArrays[random()%[PRJ_Global shareStance].filterTypeArrays.count];
        NSInteger filterType = [filter_number integerValue];
        showLabelHUD([PRJ_Global shareStance].filterTitle);
        [PRJ_Global event:[PRJ_Global shareStance].filterTitle label:@"RANDOM"];
        [PRJ_Global shareStance].randomNumber(filterType,YES);
        
        //避免重复，如果数组空的话再重新加载所有数据
        [[PRJ_Global shareStance].filterTypeArrays removeObject:filter_number];
        if ([PRJ_Global shareStance].filterTypeArrays.count == 0)
        {
            [[PRJ_Global shareStance].filterTypeArrays removeAllObjects];
            [list_Array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[NSArray class]])
                {
                    NSArray *array = (NSArray *)obj;
                    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        [[PRJ_Global shareStance].filterTypeArrays addObject:obj];
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
            if ([PRJ_Global shareStance].draggingIndex >= [PRJ_Global shareStance].filterTypeArrays.count)
            {
                [PRJ_Global shareStance].draggingIndex = 0;
                if ([[[PRJ_Global shareStance].filter_image_array lastObject] isKindOfClass:[UIImage class]]) {
                    self.image = [[PRJ_Global shareStance].filter_image_array lastObject];
                }
                else
                {
                    return;
                }
            }
            else
            {
                if ([[PRJ_Global shareStance].filter_image_array[[PRJ_Global shareStance].draggingIndex - 1] isKindOfClass:[UIImage class]]) {
                    self.image = [PRJ_Global shareStance].filter_image_array[[PRJ_Global shareStance].draggingIndex - 1];
                }
                else
                {
                    return;
                }
            }
        }
        //后退
        else if (endPoint.x - beginPoint.x > 20)
        {
            [PRJ_Global shareStance].draggingIndex--;
            if ([PRJ_Global shareStance].draggingIndex == -1)
            {
                if ([[PRJ_Global shareStance].filter_image_array[[PRJ_Global shareStance].filter_image_array.count - 2] isKindOfClass:[UIImage class]])
                {
                    [PRJ_Global shareStance].draggingIndex = [PRJ_Global shareStance].filterTypeArrays.count - 1;
                    self.image = [PRJ_Global shareStance].filter_image_array[[PRJ_Global shareStance].filter_image_array.count - 2];
                }
                else
                {
                    [PRJ_Global shareStance].draggingIndex++;
                    return;
                }
            }
            else
            {
                if ([PRJ_Global shareStance].draggingIndex == 0)
                {
                    if ([[[PRJ_Global shareStance].filter_image_array lastObject] isKindOfClass:[UIImage class]]) {
                        self.image = [[PRJ_Global shareStance].filter_image_array lastObject];
                    }
                    else
                    {
                        return;
                    }
                }
                else
                {
                    if ([[PRJ_Global shareStance].filter_image_array[[PRJ_Global shareStance].draggingIndex - 1] isKindOfClass:[UIImage class]])
                    {
                        self.image = [PRJ_Global shareStance].filter_image_array[[PRJ_Global shareStance].draggingIndex - 1];
                    }
                    else
                    {
                        [PRJ_Global shareStance].draggingIndex++;
                        return;
                    }
                }
            }
        }
        else
        {
            return;
        }
        showCoverViewForWindow();
        
        id filter_number = [PRJ_Global shareStance].filterTypeArrays[[PRJ_Global shareStance].draggingIndex];
        //分类每次滑动结束发送回调
        [PRJ_Global shareStance].isDragging = YES;
        [PRJ_Global shareStance].selectedFilterID([PRJ_Global shareStance].draggingIndex);
        NSInteger filterType = [filter_number integerValue];
        
        if ([[PRJ_Global shareStance].filter_image_array[[PRJ_Global shareStance].draggingIndex] isEqual:@""])
        {
            [PRJ_Global shareStance].randomNumber(filterType,YES);
        }
        else
        {
            [PRJ_Global shareStance].randomNumber(filterType,NO);
        }
    }
}

@end
