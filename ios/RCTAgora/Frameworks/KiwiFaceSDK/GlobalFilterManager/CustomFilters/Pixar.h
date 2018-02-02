//
//  Pixar.h
//  AGRenderManager
//
//  Created by 伍科 on 17/5/24.
//  Copyright © 2017年 PLMediaStreamingSDK. All rights reserved.
//

#import "GPUImageFilterGroup.h"
#import "AGRenderProtocol.h"
#import "GPUImage.h"

@interface PixarFilter : GPUImageTwoInputFilter

@end

@interface Pixar : GPUImageFilterGroup <AGRenderProtocol>
{
    GPUImagePicture *imageSource;
}

@property(nonatomic, readonly) BOOL needTrackData;

@end
