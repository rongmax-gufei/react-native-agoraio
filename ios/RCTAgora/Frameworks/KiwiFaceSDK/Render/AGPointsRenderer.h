//
//  AGPointsRenderer.h
//  AGFaceKitDemo
//
//  Created by ChenHao on 2016/11/26.
//  Copyright © 2016年 0dayZh. All rights reserved.
//

#import "AGRenderProtocol.h"
#import "GPUImage.h"

/**
 points of renderer class
 */
@interface AGPointsRenderer : GPUImageFilter <AGRenderProtocol>

@property(nonatomic, copy) NSArray<NSArray *> *faces;

@end
