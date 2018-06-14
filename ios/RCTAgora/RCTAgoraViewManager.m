//
//  AgoraViewManager.m
//  RCTAgora
//
//  Created by Learnta on 2017/12/21.
//  Copyright © 2017年 Learnta Inc. All rights reserved.
//

#import "RCTAgoraViewManager.h"
#import "RCTAgoraVideoView.h"

@implementation RCTAgoraViewManager

RCT_EXPORT_MODULE()

RCT_EXPORT_VIEW_PROPERTY(showLocalVideo, BOOL)
RCT_EXPORT_VIEW_PROPERTY(remoteUid, NSInteger)

- (UIView *)view {
    return [RCTAgoraVideoView new];
}

@end
