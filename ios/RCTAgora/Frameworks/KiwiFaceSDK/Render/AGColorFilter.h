#import "GPUImageFilterGroup.h"
#import "AGRenderProtocol.h"

@class GPUImagePicture;



@interface AGColorFilter : GPUImageFilterGroup <AGRenderProtocol>

@property(nonatomic, assign) CGImageRef currentImage;

@property(nonatomic, strong) GPUImagePicture *lookupImageSource;

@property(nonatomic, readonly) BOOL needTrackData;

@property(nonatomic, strong) NSString *colorFilterName;

@property(nonatomic, strong) NSString *colorFilterDir;


/**
 根据图片路径 初始化滤镜类
 */
- (id)initWithDir:(NSString *)colorFilterDir;

@end
