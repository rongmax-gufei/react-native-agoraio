//
//  Freud.h
//  AGRenderManager
//
//  Created by 伍科 on 17/5/18.
//  Copyright © 2017年 PLMediaStreamingSDK. All rights reserved.
//

#import "GPUImageFilterGroup.h"
#import "AGRenderProtocol.h"
#import "GPUImage.h"

@interface FreudFilter : GPUImageTwoInputFilter

@end

@interface Freud : GPUImageFilterGroup <AGRenderProtocol>
{
    GPUImagePicture *imageSource;
}

@property(nonatomic, readonly) BOOL needTrackData;

@end
