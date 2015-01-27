//
//  PRJ_Global.m
//  IOSNoCrop
//
//  Created by rcplatform on 14-4-18.
//  Copyright (c) 2014年 rcplatformhk. All rights reserved.
//

#import "PRJ_Global.h"
#import "UIImage+SubImage.h"
#import "MobClick.h"
#import "CMethods.h"

@implementation PRJ_Global

//@synthesize originalImage = _originalImage;
@synthesize compressionImage = _compressionImage;

+ (void)load
{

}

static PRJ_Global *_glo = nil;

+ (PRJ_Global *)shareStance
{
    if (_glo == nil)
    {
        _glo = [[PRJ_Global alloc]init];
        if (kScreen3_5)
        {
            _glo.maxScaleValue = 1080.f;
        }
        else
        {
            _glo.maxScaleValue = 3240.f;
        }
        _glo.draggingIndex = 0;
    }
    return _glo;
}

- (id)init
{
    if(self = [super init])
    {
        self.outputResolutionType = (OutputResolutionType)[[NSUserDefaults standardUserDefaults] integerForKey:UDKEY_OutputResolutionType];
    }
    return self;
}

+ (void)event:(NSString *)desc label:(NSString *)eventID{
    
    //友盟
    [MobClick event:eventID label:desc];
}

- (NSString *)getCurrentOutputResolutionStr
{
    return [self getOutputResolutionStrWithType:_outputResolutionType];
}

- (NSString *)getOutputResolutionStrWithType:(OutputResolutionType)type
{
    switch (type)
    {
        case kOutputResolutionType1080_1080:
            return LocalizedString(@"standard", nil);
        case kOutputResolutionType3240_3240:
            return LocalizedString(@"HD", nil);
        default:
            return nil;
    }
}

- (void)changeFilterGroup:(ChangeType)changeGroupType
{
    _changeType = changeGroupType;
}

- (void)selectedFilterID:(SelectFilterID)selectedID
{
    _selectedFilterID = selectedID;
}

- (void)receiveRandomNumber:(RandomNumber)numberValue
{
    _randomNumber = numberValue;
}

- (void)receiveFilterResult:(ResiveFilerResult)resultImage
{
    _filterResultImage = resultImage;
}

@end
