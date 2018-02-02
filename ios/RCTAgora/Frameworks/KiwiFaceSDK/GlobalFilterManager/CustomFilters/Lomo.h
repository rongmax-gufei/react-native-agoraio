#import "GPUImageFilterGroup.h"
#import "AGRenderProtocol.h"
#import "GPUImage.h"

@interface LomoFilter : GPUImageThreeInputFilter

@end

@interface Lomo : GPUImageFilterGroup <AGRenderProtocol>
{
    GPUImagePicture *imageSource1;
    GPUImagePicture *imageSource2;
}
@property(nonatomic, readonly) BOOL needTrackData;

@end
