//
//  RCTAgoraScreenShareViewManager.m
//  RCTAgora
//
//  Created by Learnta on 2018/6/13.
//  Copyright © 2018年 Learnta Inc. All rights reserved.
//

#import "RCTAgoraScreenShareViewManager.h"
#import "RCTAgoraScreenShareView.h"

@implementation RCTAgoraScreenShareViewManager

RCT_EXPORT_MODULE()
RCT_EXPORT_VIEW_PROPERTY(showSharedScreen, BOOL)

- (UIView *)view {
    return [[RCTAgoraScreenShareView alloc] init];
}

@end



