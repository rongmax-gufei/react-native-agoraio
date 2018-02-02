#import "GPUImageFourInputFilter.h"
#import "AGRenderProtocol.h"

@interface FiveInputFilter : GPUImageFourInputFilter <AGRenderProtocol>
{
    GPUImageFramebuffer *fifthInputFramebuffer;

    GLint filterFifthTextureCoordinateAttribute;
    GLint filterInputTextureUniform5;
    GPUImageRotationMode inputRotation5;
    GLuint filterSourceTexture5;
    CMTime fifthFrameTime;

    BOOL hasSetFourthTexture, hasReceivedFifthFrame, fifthFrameWasVideo;
    BOOL fifthFrameCheckDisabled;
}

- (void)disableFifthFrameCheck;

@end
