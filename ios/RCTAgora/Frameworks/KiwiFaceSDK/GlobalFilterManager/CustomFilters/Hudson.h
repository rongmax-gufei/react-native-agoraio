#import "GPUImageFilterGroup.h"
#import "AGRenderProtocol.h"
#import "GPUImage.h"
#import "GPUImageFourInputFilter.h"

@interface HudsonFilter : GPUImageFourInputFilter

@end

@interface Hudson : GPUImageFilterGroup <AGRenderProtocol>
{
    GPUImagePicture *imageSource1;
    GPUImagePicture *imageSource2;
    GPUImagePicture *imageSource3;
}

@property(nonatomic, readonly) BOOL needTrackData;

@end
