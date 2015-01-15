
#import "GPUImage.h"
#import "NCFilters.h"
#import "NCImageFilter.h"
#import "Common.h"

@class NCVideoCamera;

typedef void(^FilterCompletionBlock) (UIImage *filterImage);

@protocol IFVideoCameraDelegate <NSObject>
@optional
- (void)videoCameraResultImage:(NSArray *)array;
- (void)stillCameraResultImage:(UIImage *)image;
- (void)videoCameraFrame:(CGRect)rawFrame FilterType:(NSInteger)filterID;
@end

@interface NCVideoCamera : NSObject
{
    CGRect cropRect;
    BOOL isSquare;
}
@property (nonatomic, strong) GPUImageStillCamera *stillCamera;
@property (strong, readonly) GPUImageView *gpuImageView;
@property (strong, readonly) GPUImageView *gpuImageView_HD;
@property (nonatomic, strong) GPUImagePicture *stillImageSource;
@property (nonatomic, strong) UIImage *rawImage;
@property (nonatomic, assign) id<IFVideoCameraDelegate> photoDelegate;
@property (nonatomic, assign) id<IFVideoCameraDelegate> stillCameraDelegate;
@property (nonatomic, unsafe_unretained, readonly) BOOL isRecordingMovie;
@property (nonatomic, strong) GPUImageFilter *filter;


/**
 *  addSubView展示即可
 */
//@property (strong, nonatomic) GPUImageView *gpuImageView;

- (id)initWithSessionPreset:(NSString *)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition highVideoQuality:(BOOL)isHighQuality WithView:(GPUImageView *)view;

- (id)initWithImage:(UIImage *)newImageSource andOutputView:(GPUImageView *)view;

- (void)stopStillCamera;

/**
 *  选择不同的滤镜类型
 */
- (void)switchFilterType:(NCFilterType)type value:(CGFloat)value;

/**
 *  快速实例化对象
 *
 *  @param frame    gpuImageView的frame
 *  @param rawImage 需要进行滤镜处理的image对象
 */

- (void)setImage:(UIImage *)image WithFilterType:(NCFilterType)filterType andValue:(CGFloat)value;

- (void)switchFilter:(NCFilterType)type value:(CGFloat)value withCompletionBlock:(FilterCompletionBlock)filterCompletionBlock;

- (void)updateFilterParmas:(CGFloat)value;

- (void)updateFilterParmasNew:(CGFloat)value second: (CGFloat)value2 Third: (CGFloat)value3;

@end
