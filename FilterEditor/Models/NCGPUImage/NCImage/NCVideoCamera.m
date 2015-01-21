
#import "NCFilters.h"
#import "UIImage+SubImage.h"
#import "UIImage+Rotate.h"
#import "NCAmaroFilter.h"
#import "MBProgressHUD.h"
#import "CMethods.h"
#import "UIDevice+DeviceInfo.h"

@interface NCVideoCamera () <NCImageFilterDelegate>
{
    //滤镜处理完成之后的回调
    FilterCompletionBlock _filterCompletionBlock;
    CGFloat filterValue;
}

@property (nonatomic, strong) GPUImagePicture *sourcePicture1;
@property (nonatomic, strong) GPUImagePicture *sourcePicture2;
@property (nonatomic, strong) GPUImagePicture *sourcePicture3;
@property (nonatomic, strong) GPUImagePicture *sourcePicture4;
@property (nonatomic, strong) GPUImagePicture *sourcePicture5;

@property (nonatomic, strong) GPUImageFilter *internalFilter;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture1;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture2;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture3;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture4;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture5;

@property (strong, readwrite) GPUImageView *gpuImageView_HD;
@property (strong, readwrite) GPUImageView *gpuImageView;

@property (nonatomic, strong) GPUImageFilter *rotationFilter;
@property (nonatomic, unsafe_unretained) NCFilterType currentFilterType;

@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;

@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic, unsafe_unretained, readwrite) BOOL isRecordingMovie;
@property (nonatomic, strong) AVAudioRecorder *soundRecorder;
@property (nonatomic, strong) AVMutableComposition *mutableComposition;
@property (nonatomic, strong) AVAssetExportSession *assetExportSession;

@property (nonatomic ,strong) UIImage *resultImage;

@end

@implementation NCVideoCamera

@synthesize filter;
@synthesize sourcePicture1;
@synthesize sourcePicture2;
@synthesize sourcePicture3;
@synthesize sourcePicture4;
@synthesize sourcePicture5;

@synthesize internalFilter;
@synthesize internalSourcePicture1;
@synthesize internalSourcePicture2;
@synthesize internalSourcePicture3;
@synthesize internalSourcePicture4;
@synthesize internalSourcePicture5;

@synthesize gpuImageView;
@synthesize gpuImageView_HD;
@synthesize rotationFilter;
@synthesize currentFilterType;
@synthesize rawImage;
@synthesize stillImageSource;
@synthesize stillImageOutput;
@synthesize photoDelegate;
@synthesize movieWriter;
@synthesize isRecordingMovie;
@synthesize soundRecorder;
@synthesize mutableComposition;
@synthesize assetExportSession;

#pragma mark - Switch Filter
- (void)switchToNewFilter
{
    if (self.stillImageSource == nil) {
        [self.stillCamera removeTarget:self.filter];
        self.filter = self.internalFilter;
        [self.stillCamera addTarget:self.filter];
    } else {
        [self.stillImageSource removeTarget:self.filter];
        self.filter = self.internalFilter;
        [self.stillImageSource addTarget:self.filter];
    }
    
    if(self.internalSourcePicture1){
        self.sourcePicture1 = self.internalSourcePicture1;
        [self.sourcePicture1 addTarget:self.filter];
        [self.sourcePicture1 processImage];
    }
    if(self.internalSourcePicture2){
        self.sourcePicture2 = self.internalSourcePicture2;
        [self.sourcePicture2 addTarget:self.filter];
        [self.sourcePicture2 processImage];
    }
    if(self.internalSourcePicture3){
        self.sourcePicture3 = self.internalSourcePicture3;
        [self.sourcePicture3 addTarget:self.filter];
        [self.sourcePicture3 processImage];
    }
    if(self.internalSourcePicture4){
        self.sourcePicture4 = self.internalSourcePicture4;
        [self.sourcePicture4 addTarget:self.filter];
        [self.sourcePicture4 processImage];
    }
    if(self.internalSourcePicture5){
        self.sourcePicture5 = self.internalSourcePicture5;
        [self.sourcePicture5 addTarget:self.filter];
        [self.sourcePicture5 processImage];
    }

    if (self.stillImageSource != nil)
    {
        [self.filter addTarget:self.gpuImageView];
        [self.filter useNextFrameForImageCapture];
        [self updateFilterParmas:filterValue withProcess:NO];
        [self.stillImageSource processImageWithCompletionHandler:^{
            UIImage *result = [self.filter imageFromCurrentFramebuffer];
            self.resultImage = nil;
            self.resultImage = result;
            if (self.resultImage)
            {
                NSArray *resultArray = [NSArray arrayWithObjects:self.resultImage,[NSNumber numberWithInt:currentFilterType], nil];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([photoDelegate respondsToSelector:@selector(videoCameraResultImage:filterType:)])
                    {
                        [photoDelegate videoCameraResultImage:resultArray filterType:currentFilterType];
                    }
                });
            }
        }];
    }
    else
    {
        [self.filter addTarget:self.gpuImageView];
        [self.filter setFloat:filterValue forUniformName:@"specIntensity"];
        [self.filter useNextFrameForImageCapture];
        self.resultImage = [self.filter imageFromCurrentFramebuffer];
        if (self.resultImage != nil)
        {
            if ([_stillCameraDelegate respondsToSelector:@selector(stillCameraResultImage:)])
            {
                [_stillCameraDelegate performSelector:@selector(stillCameraResultImage:) withObject:self.resultImage];
            }
        }
    }
}

- (void)forceSwitchToNewFilter:(NCFilterType)type
{
    self.internalSourcePicture1 = nil;
    self.internalSourcePicture2 = nil;
    self.internalSourcePicture3 = nil;
    self.internalSourcePicture4 = nil;
    self.internalSourcePicture5 = nil;
    currentFilterType = type;

    switch (type) {
        case IF_0: {
            self.internalFilter = [[NCNormalFilter alloc] init];
            break;
        }
            
        case IF_202:
        {
            self.internalFilter = [[IFShadowFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shadow_06" ofType:@"jpg"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shadow_m_04" ofType:@"jpg"]]];
            [self.internalFilter setFloat:(0.00) forUniformName:@"specIntensity3"];
            break;
        }
        case IF_242: {
            self.internalFilter = [[IFShadowFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shadow_80" ofType:@"jpg"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shadow_m_04" ofType:@"jpg"]]];
            [self.internalFilter setFloat:(0.00) forUniformName:@"specIntensity3"];

            break;
        }
        case IF_243: {
            self.internalFilter = [[IFShadowFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shadow_81" ofType:@"jpg"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shadow_m_04" ofType:@"jpg"]]];
            [self.internalFilter setFloat:(0.00) forUniformName:@"specIntensity3"];
            break;
        }
        case IF_251: {
            self.internalFilter = [[IFShadowFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shadow_new_91" ofType:@"jpg"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shadow_m_04" ofType:@"jpg"]]];
            [self.internalFilter setFloat:(0.00) forUniformName:@"specIntensity3"];

            break;
        }
        case IF_252: {
            self.internalFilter = [[IFShadowFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shadow_new_92" ofType:@"jpg"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shadow_m_04" ofType:@"jpg"]]];
            [self.internalFilter setFloat:(0.00) forUniformName:@"specIntensity3"];

            break;
        }
        case IF_253: {
            self.internalFilter = [[IFShadowFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shadow_new_93" ofType:@"jpg"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shadow_m_04" ofType:@"jpg"]]];
            [self.internalFilter setFloat:(0.00) forUniformName:@"specIntensity3"];

            break;
        }
        case IF_254: {
            self.internalFilter = [[IFShadowFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shadow_new_94" ofType:@"jpg"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shadow_m_04" ofType:@"jpg"]]];
            [self.internalFilter setFloat:(0.00) forUniformName:@"specIntensity3"];

            break;
        }
        case IF_255: {
            self.internalFilter = [[IFShadowFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shadow_new_95" ofType:@"jpg"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shadow_m_04" ofType:@"jpg"]]];
            [self.internalFilter setFloat:(0.00) forUniformName:@"specIntensity3"];

            break;
        }
            
        case IF_22: {
            //黑白
            self.internalFilter = [[IFInkwellFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52000" ofType:@"png"]]];
            break;
        }
        case IF_23: {
            //绿色
            self.internalFilter = [[IFBrannanFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52001" ofType:@"png"]]];
            
            break;
        }
        case IF_26: {
            //新滤镜-水灵
            self.internalFilter = [[IFNewTwoFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_shuiling" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_shuiling" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.61) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.43) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(-0.26) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.17) forUniformName:@"specIntensity7"];
            
            [self.internalFilter setFloat:(0.52) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            
            [self.internalFilter setFloat:(0.06) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.08) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.19) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.02) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(-0.02) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_40: {
            //新滤镜－阳光
            self.internalFilter = [[IFNewTwoFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_1" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.21) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(0.17) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.27) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.04) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(1.0) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(1.0) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(1.0) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.0) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.03) forUniformName:@"specIntensity12"];
            break;
        }
            
        case IF_42:
        {
            //新滤镜－冷灰
            self.internalFilter = [[IFNewTwoFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_secai_heibai" ofType:@"png"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_secai_heibai" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.80) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.21) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-1.00) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.12) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.47) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(1.00) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.90) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(-0.79) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.23) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.02) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_50: {
            //新滤镜－黄灰
            self.internalFilter = [[IFNewTwoFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_5" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_5" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.58) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.50) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.20) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.12) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(-0.09) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.60) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.14) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.03) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(-0.1) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_63: {
            //新滤镜－newfilter_64
            self.internalFilter = [[IFNewTwoFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng1019_11" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng1019_11" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.48) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.28) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(-0.10) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.65) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.44) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.50) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(-0.29) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.52) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(-0.02) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_74: {
            self.internalFilter = [[IFNewTwoFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng1022_8" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng1022_8" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.48) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.25) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(1.0) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(-0.07) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.18) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(-0.03) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(0.75) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity12"];
            break;
        }

        case IF_78: {
            self.internalFilter = [[IFNewTwoFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.06) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-1.0) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.06) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.05) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.88) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(1.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.35) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.35) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.67) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.31) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_80: {
            self.internalFilter = [[IFNewTwoFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.10) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-1.0) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(-0.25) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.15) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.5) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.03) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.04) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.11) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(0.95) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(-0.13) forUniformName:@"specIntensity12"];
            break;
        }

        case IF_83: {
            self.internalFilter = [[IFNewTwoFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.17) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.30) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(-0.38) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.06) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.54) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.06) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.37) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.55) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.12) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(-0.09) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_86: {
            self.internalFilter = [[IFNewTwoFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.07) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.10) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(-0.23) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.14) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.17) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.06) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(-0.08) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.33) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(-0.04) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_92:
        {
            self.internalFilter = [[IFNewTwoFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.15) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.28) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(-0.19) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.07) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(-0.26) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.29) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(-0.17) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(0.93) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity12"];
            break;
        }
            //---------tf begin---------------
        case IF_93: { //A01
            self.internalFilter = [[IFNewTfFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.25) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.19) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(-0.21) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.28) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(-0.05) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.36) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(0.93) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.05) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_94: { //A02
            self.internalFilter = [[IFNewTfFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.44) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-1.00) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.61) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.03) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.02) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.07) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.03) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(-0.14) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_95: { //A03
            self.internalFilter = [[IFNewTfFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.44) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-1.00) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.61) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.03) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.05) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.02) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.03) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(0.71) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.09) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_96: { //A04
            self.internalFilter = [[IFNewTfFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.59) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-1.00) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(-0.30) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.29) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(0.75) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(-0.21) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_97: {  //A05
            self.internalFilter = [[IFNewTfFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.32) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.95) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(-0.06) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.25) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.70) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.10) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.13) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.22) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.30) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_98: {  //A06
            self.internalFilter = [[IFNewTfFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.27) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-1.0) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.07) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.38) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.31) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.09) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(-0.47) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.46) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.30) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_99: {  //A07
            self.internalFilter = [[IFNewTfFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.20) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.70) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.72) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.23) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.57) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.32) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.22) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.30) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_100: {  //A08
            self.internalFilter = [[IFNewTfFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.36) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.43) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.31) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.14) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.19) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.30) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(-1.0) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(0.67) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(-0.08) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_101: {  //A09
            self.internalFilter = [[IFNewTfFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.27) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.45) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.61) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.61) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.17) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.04) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.17) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(0.71) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.09) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_102: {  //A10
            self.internalFilter = [[IFNewTfFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.22) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.23) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.63) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.64) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.08) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.09) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.40) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.14) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.30) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_103: {  //A11
            self.internalFilter = [[IFNewTfFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.22) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.46) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.46) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.57) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.27) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.13) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.15) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.20) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.23) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_104: {  //A12
            self.internalFilter = [[IFNewTfFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.18) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.30) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.49) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.22) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.51) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.10) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.17) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.60) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.13) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.28) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_105: {  //A13
            self.internalFilter = [[IFNewTfFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.17) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.34) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.30) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.55) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.17) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.29) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.36) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(0.83) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_106: {  //A14
            self.internalFilter = [[IFNewTfFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.16) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.19) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.24) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.70) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(-0.15) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.39) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.71) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.04) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.21) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_107: {  //A15
            self.internalFilter = [[IFNewTfFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.20) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.28) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.14) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(-0.08) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.05) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.15) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(0.95) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.07) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_108: {  //A16
            self.internalFilter = [[IFNewTfFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.24) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.29) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.29) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-1.00) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(1.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.22) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.37) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(1.00) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(0.80) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.01) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_109: {  //A17
            self.internalFilter = [[IFNewTfFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.31) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.30) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.43) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.29) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.51) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(1.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(-0.04) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.01) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.29) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(0.81) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.05) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_110: {  //A18
            self.internalFilter = [[IFNewTfFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.27) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.30) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.46) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.11) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.51) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.05) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.08) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.09) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(0.99) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.28) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_111: {  //A19
            self.internalFilter = [[IFNewTfFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.24) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.47) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.42) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.31) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(1.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(-0.32) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.02) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.20) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.16) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.30) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_112: {  //A20
            self.internalFilter = [[IFNewTfFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.31) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.30) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.43) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.29) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.51) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(1.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(-0.04) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.01) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.29) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(0.81) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.05) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_113: {  //A21
            self.internalFilter = [[IFNewTfFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.19) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(0.11) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(-0.47) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.21) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.00) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.00) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.00) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(0.97) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.30) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_114: {  //A22
            self.internalFilter = [[IFNewTfFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.10) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.18) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.38) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.57) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.13) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.08) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.21) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.22) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_115: {  //A23
            self.internalFilter = [[IFNewTfFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.05) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.24) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.23) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.07) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(1.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.97) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.21) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(-0.47) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(0.81) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(-0.07) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_116: {  //A24
            self.internalFilter = [[IFNewTfFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.25) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.41) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.34) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.25) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.06) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.07) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(-0.30) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.16) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.16) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_117: {  //A25
            self.internalFilter = [[IFNewTfFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.25) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.41) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.34) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.25) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.17) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.25) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(-0.30) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.16) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.16) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_118: {  //A26
            self.internalFilter = [[IFNewTfFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.13) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.18) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.34) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.25) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.17) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.25) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(-0.23) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.16) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.16) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_119: {  //A27
            self.internalFilter = [[IFNewTfFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.13) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.18) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.24) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.25) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.03) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.50) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(-0.27) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.16) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.26) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_120: {  //A28
            self.internalFilter = [[IFNewTfFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.21) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.18) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.43) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.18) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(1.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.03) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.30) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.03) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.03) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.30) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_121: {  //A29
            self.internalFilter = [[IFNewTfFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.21) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.18) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.45) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.10) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(1.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(-0.03) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.12) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(-0.29) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.12) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.30) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_122: {  //A30
            self.internalFilter = [[IFNewTfFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.21) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.18) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.45) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.10) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.54) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.12) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(-0.29) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.12) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.30) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_123: {  //A31
            self.internalFilter = [[IFNewTfFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.21) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.18) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.45) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.10) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(1.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.84) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.12) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(-0.29) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.12) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.30) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_124: {  //A32
            self.internalFilter = [[IFNewTfFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.21) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.38) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(-0.58) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.31) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.07) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.30) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_125: {  //A33
            self.internalFilter = [[IFNewTfFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.23) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.18) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.10) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.30) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(-0.66) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.47) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(1.0) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(0.91) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.23) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_126: {  //A34
            self.internalFilter = [[IFNewTfFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mengceng_8_2" ofType:@"png"]]];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.21) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.12) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(-0.78) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.31) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.33) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.31) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(-0.08) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(0.97) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.30) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_127: {  //SA01
            self.internalFilter = [[IFNewTfTwoFilter alloc] init];
            
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52001" ofType:@"png"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52005" ofType:@"png"]]];
            
            [self.internalFilter setFloat:(1.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.16) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(-0.34) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.23) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.07) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.16) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.00) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.06) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_128: {  //SA02
            self.internalFilter = [[IFNewTfTwoFilter alloc] init];
            
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52001" ofType:@"png"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52005" ofType:@"png"]]];
            
            [self.internalFilter setFloat:(0.56) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.09) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.20) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(-0.40) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.35) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.07) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.16) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.00) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.16) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_129: {  //SA03
            self.internalFilter = [[IFNewTfTwoFilter alloc] init];
            
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52001" ofType:@"png"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52005" ofType:@"png"]]];
            
            [self.internalFilter setFloat:(0.33) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(0.12) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(-0.43) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.17) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(-0.03) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.02) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(-0.02) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(0.84) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.15) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_130: {  //SA04
            self.internalFilter = [[IFNewTfTwoFilter alloc] init];
            
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52001" ofType:@"png"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52005" ofType:@"png"]]];
            
            [self.internalFilter setFloat:(0.33) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.10) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.20) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(-0.41) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.17) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.64) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.10) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.03) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.08) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.30) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_131: {  //SA05
            self.internalFilter = [[IFNewTfTwoFilter alloc] init];
            
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52001" ofType:@"png"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52005" ofType:@"png"]]];
            
            [self.internalFilter setFloat:(0.73) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.10) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(0.17) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(-0.41) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.17) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.46) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.10) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.03) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.31) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.30) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_132: {  //SA06
            self.internalFilter = [[IFNewTfTwoFilter alloc] init];
            
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52001" ofType:@"png"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52005" ofType:@"png"]]];
            
            [self.internalFilter setFloat:(0.93) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.15) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(0.17) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.18) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.45) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(-0.02) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.34) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.47) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.07) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.27) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_133: {  //SA07
            self.internalFilter = [[IFNewTfTwoFilter alloc] init];
            
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52001" ofType:@"png"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52005" ofType:@"png"]]];
            
            [self.internalFilter setFloat:(0.31) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(0.17) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(-0.71) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.22) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.47) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.19) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.29) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.03) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.17) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_134: {  //SA08
            self.internalFilter = [[IFNewTfTwoFilter alloc] init];
            
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52001" ofType:@"png"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52005" ofType:@"png"]]];
            
            [self.internalFilter setFloat:(0.44) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.44) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(-0.39) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.06) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.03) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.03) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(0.74) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.06) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_135: {  //SA09
            self.internalFilter = [[IFNewTfTwoFilter alloc] init];
            
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52001" ofType:@"png"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52005" ofType:@"png"]]];
            
            [self.internalFilter setFloat:(0.78) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.10) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.17) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(-0.65) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.28) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.49) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.28) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.03) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.11) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.28) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_136: {  //SA10
            self.internalFilter = [[IFNewTfTwoFilter alloc] init];
            
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52001" ofType:@"png"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52005" ofType:@"png"]]];
            
            [self.internalFilter setFloat:(0.78) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.10) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.17) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(-0.65) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.28) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.39) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.21) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.40) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.11) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.28) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_137: {  //SA11
            self.internalFilter = [[IFNewTfTwoFilter alloc] init];
            
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52001" ofType:@"png"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52005" ofType:@"png"]]];
            
            [self.internalFilter setFloat:(0.78) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(0.18) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(-0.65) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.28) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.66) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.13) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.23) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(0.83) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.02) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_138: {  //SA12
            self.internalFilter = [[IFNewTfTwoFilter alloc] init];
            
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52001" ofType:@"png"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52005" ofType:@"png"]]];
            
            [self.internalFilter setFloat:(0.60) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.09) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.03) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.74) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.75) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.21) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.12) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.27) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.11) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.11) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_139: {  //SA15
            self.internalFilter = [[IFNewTfTwoFilter alloc] init];
            
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52001" ofType:@"png"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52005" ofType:@"png"]]];
            
            [self.internalFilter setFloat:(1.00) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.09) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(-0.02) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.02) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(-0.02) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.03) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(-0.02) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.34) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(-0.23) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_140: {  //SA16
            self.internalFilter = [[IFNewTfTwoFilter alloc] init];
            
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52001" ofType:@"png"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52005" ofType:@"png"]]];
            
            [self.internalFilter setFloat:(1.00) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.08) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.09) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.09) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.02) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(-0.06) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.10) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(-0.56) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(0.98) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(-0.23) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_141: {  //SA17
            self.internalFilter = [[IFNewTfTwoFilter alloc] init];
            
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52001" ofType:@"png"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52005" ofType:@"png"]]];
            
            [self.internalFilter setFloat:(1.00) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.08) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.09) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.14) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.02) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.30) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.32) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(-0.83) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(0.98) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(-0.23) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_142: {  //SA18
            self.internalFilter = [[IFNewTfTwoFilter alloc] init];
            
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52001" ofType:@"png"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52005" ofType:@"png"]]];
            
            [self.internalFilter setFloat:(1.00) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.12) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.09) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.14) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.02) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.30) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.32) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(-0.83) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.16) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(-0.06) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_143: {  //SA19
            self.internalFilter = [[IFNewTfTwoFilter alloc] init];
            
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52001" ofType:@"png"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52005" ofType:@"png"]]];
            
            [self.internalFilter setFloat:(1.00) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.04) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(-0.06) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.30) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.68) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.32) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.25) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.03) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(-0.14) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_144: {  //SA20
            self.internalFilter = [[IFNewTfTwoFilter alloc] init];
            
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52001" ofType:@"png"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52005" ofType:@"png"]]];
            
            [self.internalFilter setFloat:(1.00) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(-0.08) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.68) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(-0.63) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.37) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.48) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.11) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(-0.17) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_145: {  //SA21
            self.internalFilter = [[IFNewTfTwoFilter alloc] init];
            
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52001" ofType:@"png"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52005" ofType:@"png"]]];
            
            [self.internalFilter setFloat:(0.43) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.27) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.57) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.43) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.12) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.41) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(0.90) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(-0.09) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_146: {  //SA22
            self.internalFilter = [[IFNewTfTwoFilter alloc] init];
            
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52001" ofType:@"png"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52005" ofType:@"png"]]];
            
            [self.internalFilter setFloat:(1.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(-0.08) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.66) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(-0.70) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.51) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(-0.51) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(0.81) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(-0.19) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_147: {  //SA23
            self.internalFilter = [[IFNewTfTwoFilter alloc] init];
            
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52001" ofType:@"png"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52005" ofType:@"png"]]];
            
            [self.internalFilter setFloat:(1.0) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.42) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.17) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.28) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(-0.64) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.08) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(-0.19) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.38) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.23) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_148: {  //SA24
            self.internalFilter = [[IFNewTfTwoFilter alloc] init];
            
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52001" ofType:@"png"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52005" ofType:@"png"]]];
            
            [self.internalFilter setFloat:(0.74) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.07) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.32) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.24) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(-0.19) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.04) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.15) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.04) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(-0.02) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_149: {  //SA25
            self.internalFilter = [[IFNewTfTwoFilter alloc] init];
            
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52001" ofType:@"png"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52005" ofType:@"png"]]];
            
            [self.internalFilter setFloat:(1.00) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-1.00) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(-0.35) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.18) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(-0.43) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.16) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(-0.19) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(0.95) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(-0.11) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_150: {  //SA26
            self.internalFilter = [[IFNewTfTwoFilter alloc] init];
            
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52001" ofType:@"png"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52005" ofType:@"png"]]];
            
            [self.internalFilter setFloat:(1.00) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.10) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(0.14) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.25) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.32) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.28) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.30) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(-0.59) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(0.87) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(-0.13) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_151: {  //SA27
            self.internalFilter = [[IFNewTfTwoFilter alloc] init];
            
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52001" ofType:@"png"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52005" ofType:@"png"]]];
            
            [self.internalFilter setFloat:(1.00) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.16) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.02) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.33) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.54) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.03) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(-0.39) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.20) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.16) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_152: {  //SA28
            self.internalFilter = [[IFNewTfTwoFilter alloc] init];
            
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52001" ofType:@"png"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52005" ofType:@"png"]]];
            
            [self.internalFilter setFloat:(0.51) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.24) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(0.02) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(-0.29) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.52) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(-0.50) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.24) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(-0.01) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.12) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.30) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_153: {  //SA29
            self.internalFilter = [[IFNewTfTwoFilter alloc] init];
            
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52001" ofType:@"png"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52005" ofType:@"png"]]];
            
            [self.internalFilter setFloat:(0.51) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.24) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(0.17) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(-0.29) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.52) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.45) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.59) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(-0.01) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.12) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.30) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_154: {  //SA30
            self.internalFilter = [[IFNewTfTwoFilter alloc] init];
            
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52001" ofType:@"png"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52005" ofType:@"png"]]];
            
            [self.internalFilter setFloat:(0.51) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.22) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(0.08) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(-0.77) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.02) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(0.28) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.28) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(-0.01) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.07) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.30) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_155: {  //SA31
            self.internalFilter = [[IFNewTfTwoFilter alloc] init];
            
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52001" ofType:@"png"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52005" ofType:@"png"]]];
            
            [self.internalFilter setFloat:(0.61) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.09) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.46) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(0.21) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(-0.12) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.32) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.10) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.07) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_156: {  //SA32
            self.internalFilter = [[IFNewTfTwoFilter alloc] init];
            
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52001" ofType:@"png"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52005" ofType:@"png"]]];
            
            [self.internalFilter setFloat:(1.00) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.07) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(0.31) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.28) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(-0.21) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(0.37) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.08) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(-0.03) forUniformName:@"specIntensity12"];
            break;
        }
        case IF_157: {  //SA33
            self.internalFilter = [[IFNewTfTwoFilter alloc] init];
            
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52001" ofType:@"png"]]];
            self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"52005" ofType:@"png"]]];
            
            [self.internalFilter setFloat:(0.51) forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:(0.11) forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:(-0.38) forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:(-0.19) forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:(-0.31) forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:(0.50) forUniformName:@"specIntensity13"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag2"];
            [self.internalFilter setFloat:(0.0) forUniformName:@"vignetteFlag"];
            [self.internalFilter setFloat:(-0.84) forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:(-0.18) forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:(-0.28) forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:(1.0) forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:(0.11) forUniformName:@"specIntensity12"];
            break;
        }
            //---------tf end-------------
            
        case IF_158: {
            self.internalFilter = [[FC_FogRectangularFilter alloc] init];
            break;
        }
        case IF_159: {
            self.internalFilter = [[FC_FogCircleFilter alloc] init];
            break;
        }
            
        case IF_323: {
            self.internalFilter = [[IFLordKelvinFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"texture_42" ofType:@"jpg"]]];
            break;
        }
        case IF_326: {
            self.internalFilter = [[IFLordKelvinFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"texture_45" ofType:@"jpg"]]];
            break;
        }
        case IF_328: {
            self.internalFilter = [[IFLordKelvinFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"texture_47" ofType:@"jpg"]]];
            break;
        }
        case IF_329: {
            self.internalFilter = [[IFLordKelvinFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"texture_48" ofType:@"jpg"]]];
            break;
        }
        case IF_332: {
            self.internalFilter = [[IFLordKelvinFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"texture_51" ofType:@"jpg"]]];
            break;
        }
        case IF_334: {
            self.internalFilter = [[IFLordKelvinFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"texture_53" ofType:@"jpg"]]];
            break;
        }
        case IF_336: {
            self.internalFilter = [[IFLordKelvinFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"texture_56" ofType:@"jpg"]]];
            break;
        }
        case IF_338: {
            self.internalFilter = [[IFLordKelvinFilter alloc] init];
            self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"texture_58" ofType:@"jpg"]]];
            break;
        }


        default:
            break;
    }
    [self performSelectorOnMainThread:@selector(switchToNewFilter) withObject:nil waitUntilDone:NO];
}

- (void)setImage:(UIImage *)image WithFilterType:(NCFilterType)filterType andValue:(CGFloat)value
{
    [stillImageSource removeAllTargets];
    stillImageSource = nil;
    self.rawImage = image;
    [self switchFilterType:filterType value:value];
}

- (void)switchFilterType:(NCFilterType)type value:(CGFloat)value
{
    if (self.rawImage && !self.stillImageSource)
    {
        self.stillImageSource = [[GPUImagePicture alloc] initWithImage:self.rawImage];
    }
    filterValue = value;
    [self performSelector:@selector(forceSwitchToNewFilterAfterDelay:) withObject:[NSNumber numberWithInt:type] afterDelay:0.0f];
}

- (void)forceSwitchToNewFilterAfterDelay:(NSNumber *)type
{
    [self forceSwitchToNewFilter:(NCFilterType)type.intValue];
}

#pragma mark - init
- (id)initWithSessionPreset:(NSString *)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition highVideoQuality:(BOOL)isHighQuality WithView:(GPUImageView *)view{
    if (!(self = [super init]))
    {
        return nil;
    }
    self.stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:sessionPreset cameraPosition:cameraPosition];
    
    self.gpuImageView = view;
    self.filter = [[GPUImageFilter alloc] init];
    self.internalFilter = self.filter;
    
    [filter addTarget:self.gpuImageView];
    self.stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    return self;
}

- (id)initWithImage:(UIImage *)newImageSource andOutputView:(GPUImageView *)view
{
    if (self = [super init])
    {
        self.rawImage = newImageSource;
        self.gpuImageView = view;
        self.filter = [[GPUImageFilter alloc] init];
    }
    return self;
}

- (void)switchFilter:(NCFilterType)type value:(CGFloat)value withCompletionBlock:(FilterCompletionBlock)filterCompletionBlock{
    [self switchFilterType:type value:value];
    _filterCompletionBlock = filterCompletionBlock;
}

#pragma mark - NCImageFilterDelegate
- (void)imageFilterdidFinishRender:(NCImageFilter *)imageFilter
{
    //截图
    return;
}

#pragma mark 保存至本地相册 结果反馈
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if(error == nil)
    {
        MBProgressHUD *hud = showMBProgressHUD(LocalizedString(@"saved_in_album", nil), NO);
        [hud performSelector:@selector(hide:) withObject:nil afterDelay:1.5];
    }
}

- (void)stopStillCamera
{
    [self.stillCamera stopCameraCapture];
    [self.stillCamera removeAllTargets];
}

- (void)updateFilterParmas:(CGFloat)value withProcess:(BOOL)process
{
    [self.filter setFloat:value forUniformName:@"specIntensity"];
    
    if (self.internalSourcePicture1) {
        [self.sourcePicture1 processImage];
    }
    if (self.internalSourcePicture2) {
        [self.sourcePicture2 processImage];
    }
    if (self.internalSourcePicture3) {
        [self.sourcePicture3 processImage];
    }
    if (self.internalSourcePicture4) {
        [self.sourcePicture4 processImage];
    }
    if (self.internalSourcePicture5) {
        [self.sourcePicture5 processImage];
    }
    
    if (process)
    {
        [self.stillImageSource processImage];
    }
}

- (void)updateFilterParmasNew:(CGFloat)value second:(CGFloat)value2 Third:(CGFloat)value3
{
    NSLog(@"value: %f", value);
    if (currentFilterType == IF_93){
        [(FC_FogRectangularFilter *)self.filter setTopFocusLevel :value];
        [(FC_FogRectangularFilter *)self.filter setBottomFocusLevel :value];
        [(FC_FogRectangularFilter *)self.filter setFocusFallOffRate: value2];
        [(FC_FogRectangularFilter *)self.filter setAngleRate: value3];
    }
    
    if (currentFilterType == IF_94){
        [(FC_FogCircleFilter *)self.filter setExcludeCircleRadius: value2];
        [(FC_FogCircleFilter *)self.filter setExcludeCirclePoint: CGPointMake(value, value)];  //点的x和y值，值范围参考shader脚本参数说明
        [(FC_FogCircleFilter *)self.filter setExcludeBlurSize: 0.16f];
        [(FC_FogCircleFilter *)self.filter setAspectRatio: 1.0f];
    }
    
    if (self.internalSourcePicture1) {
        [self.sourcePicture1 processImage];
    }
    if (self.internalSourcePicture2) {
        [self.sourcePicture2 processImage];
    }
    if (self.internalSourcePicture3) {
        [self.sourcePicture3 processImage];
    }
    if (self.internalSourcePicture4) {
        [self.sourcePicture4 processImage];
    }
    if (self.internalSourcePicture5) {
        [self.sourcePicture5 processImage];
    }
    
    [self.stillImageSource processImage];
}

@end
