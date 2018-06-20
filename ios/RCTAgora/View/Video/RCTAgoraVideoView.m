//
//  RCTAgoraVideoView.m
//  RCTAgora
//
//  Created by Learnta on 2017/12/21.
//  Copyright © 2017年 Learnta Inc. All rights reserved.
//

#import "RCTAgoraVideoView.h"
#import "AgoraVideoManager.h"

@implementation RCTAgoraVideoView

- (instancetype)init {
    
    if (self == [super init]) {
        _rtcEngine = [AgoraConst share].rtcEngine;
    }
    
    return self;
}

/**
 * 渲染本地视频画面
 * showLocalVideo: 用户id
 */
- (void)setShowLocalVideo:(BOOL)showLocalVideo {
    if (showLocalVideo) {
        AgoraRtcVideoCanvas *canvas = [[AgoraRtcVideoCanvas alloc] init];
        canvas.uid = [AgoraConst share].localUid;
        canvas.view = self;
        canvas.renderMode = AgoraVideoRenderModeHidden;
        [_rtcEngine setupLocalVideo:canvas];
    }
}

/**
 * 根据远端用户id渲染对应视频画面
 * remoteUid: 远端用户id
 */
- (void)setRemoteUid:(NSInteger)remoteUid {
    if (remoteUid > 0) {
        AgoraRtcVideoCanvas *canvas = [[AgoraRtcVideoCanvas alloc] init];
        canvas.uid = remoteUid;
        canvas.view = self;
        canvas.renderMode = AgoraVideoRenderModeHidden;
        [_rtcEngine setupRemoteVideo:canvas];
    }
}

/**
 * 根据用户id渲染对应视频画面
 * renderUid: 用户id
 */
- (void)setRenderUid:(NSInteger)renderUid {
    AgoraRtcVideoCanvas *canvas = [[AgoraRtcVideoCanvas alloc] init];
    canvas.uid = renderUid;
    canvas.view = self;
    canvas.renderMode = AgoraVideoRenderModeHidden;
    if ([AgoraConst share].localUid == renderUid) {
        // 本地视频流
        [_rtcEngine setupLocalVideo:canvas];
    } else {
        // 远端视频流
        [_rtcEngine setupRemoteVideo:canvas];
    }
    [AgoraVideoManager.share setAvRootView:self];
}

@end
