//
//  RCTAgoraScreenShareView.m
//  RCTAgora
//
//  Created by Learnta on 2018/6/13.
//  Copyright © 2018年 Learnta Inc. All rights reserved.
//

#import "RCTAgoraScreenShareView.h"
#import <ReplayKit/ReplayKit.h>
#import "AgoraScreenShareManager.h"

@implementation RCTAgoraScreenShareView

- (instancetype)init {
    
    if (self == [super init]) {
//        _rtcEngine = [AgoraConst share].rtcEngine;
        self.sharedView = [[RPScreenRecorder sharedRecorder] cameraPreviewView];
//        [[UIUtils currentRootView] addSubview:self.sharedView];
    }
    
    return self;
}

- (void)setShowSharedScreen:(BOOL)showSharedScreen {
    if (showSharedScreen) {
//        AgoraRtcVideoCanvas *canvas = [[AgoraRtcVideoCanvas alloc] init];
//        canvas.uid = [AgoraConst share].localUid;
//        canvas.view = self.sharedView;
//        canvas.renderMode = AgoraVideoRenderModeHidden;
//        [_rtcEngine setupLocalVideo:canvas];
        [AgoraScreenShareManager.share setSharedView:self.sharedView];
    }
}

@end
