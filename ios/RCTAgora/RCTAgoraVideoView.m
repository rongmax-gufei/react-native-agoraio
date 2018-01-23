//
//  RCTAgoraVideoView.m
//  RCTAgora
//
//  Created by Learnta on 2017/12/21.
//  Copyright © 2017年 Learnta Inc. All rights reserved.
//

#import "RCTAgoraVideoView.h"

@implementation RCTAgoraVideoView

- (instancetype)init{
    
    if (self == [super init]) {
        _rtcEngine = [AgoraConst share].rtcEngine;
    }
    
    return self;
}

- (void)setShowLocalVideo:(Boolean)showLocalVideo {
    if (showLocalVideo) {
        AgoraRtcVideoCanvas *canvas = [[AgoraRtcVideoCanvas alloc] init];
        canvas.uid = [AgoraConst share].localUid;
        canvas.view = self;
        canvas.renderMode = AgoraRtc_Render_Hidden;
        [_rtcEngine setupLocalVideo:canvas];
    }
}

-(void)setRemoteUid:(NSInteger)remoteUid {
    if (remoteUid > 0) {
        AgoraRtcVideoCanvas *canvas = [[AgoraRtcVideoCanvas alloc] init];
        canvas.uid = remoteUid;
        canvas.view = self;
        canvas.renderMode = AgoraRtc_Render_Hidden;
        [_rtcEngine setupRemoteVideo:canvas];
    }
}

@end
