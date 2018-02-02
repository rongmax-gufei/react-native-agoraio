//
//  AGPoint.h
//  AGMediaStreamingKitDemo
//
//  Created by ChenHao on 16/7/15.
//  Copyright © 2016年 0dayZh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum
{
    AGPositionHair = 1,
    AGPositionEye = 2,
    AGPositionEar = 3,
    AGPositionNose = 4,
    AGPositionNostril = 5,
    AGPositionUperMouth = 6,
    AGPositionMouth = 7,
    AGPositionLip = 8,
    AGPositionChin = 9,
    AGPositionEyebrow,
    AGPositionCheek,
    AGPositionNeck,
    AGPositionFace,
} AGPosition;

/**
 返回某位置对应的点
 */
@interface AGPoint : NSObject

@property(nonatomic) int left;
@property(nonatomic) int center;
@property(nonatomic) int right;

+ (instancetype)facePointForPosition:(AGPosition)position;

@end
