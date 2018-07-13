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

- (instancetype)init{
    
    if (self == [super init]) {
        _rtcEngine = [AgoraConst share].rtcEngine;
    }
    
    return self;
}

- (void)setShowLocalVideo:(BOOL)showLocalVideo {
    if (showLocalVideo) {
        AgoraRtcVideoCanvas *canvas = [[AgoraRtcVideoCanvas alloc] init];
        canvas.uid = [AgoraConst share].localUid;
        canvas.view = self;
        canvas.renderMode = AgoraVideoRenderModeHidden;
        [_rtcEngine setupLocalVideo:canvas];
    }
    [AgoraVideoManager share].avRootView = self;
}

-(void)setRemoteUid:(NSInteger)remoteUid {
    if (remoteUid > 0) {
        AgoraRtcVideoCanvas *canvas = [[AgoraRtcVideoCanvas alloc] init];
        canvas.uid = remoteUid;
        canvas.view = self;
        canvas.renderMode = AgoraVideoRenderModeHidden;
        [_rtcEngine setupRemoteVideo:canvas];
    }
}

@end
