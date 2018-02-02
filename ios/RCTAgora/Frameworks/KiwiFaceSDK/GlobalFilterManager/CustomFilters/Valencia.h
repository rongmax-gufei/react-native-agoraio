#import "GPUImageFilterGroup.h"
#import "AGRenderProtocol.h"
#import "GPUImage.h"
#import "GPUImageFourInputFilter.h"

@interface ValenciaFilter : GPUImageThreeInputFilter

@end

@interface Valencia : GPUImageFilterGroup <AGRenderProtocol>
{
    GPUImagePicture *imageSource1;
    GPUImagePicture *imageSource2;
}

@property(nonatomic, readonly) BOOL needTrackData;

@end
