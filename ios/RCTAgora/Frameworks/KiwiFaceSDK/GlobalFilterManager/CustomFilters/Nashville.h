#import "GPUImageTwoInputFilter.h"
#import "AGRenderProtocol.h"
#import "GPUImage.h"

@interface NashvilleFilter : GPUImageTwoInputFilter


@end

@interface Nashville : GPUImageFilterGroup <AGRenderProtocol>
{
    GPUImagePicture *imageSource;
}

@property(nonatomic, readonly) BOOL needTrackData;

@end
