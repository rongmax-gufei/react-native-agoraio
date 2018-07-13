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
        self.sharedView = [[RPScreenRecorder sharedRecorder] cameraPreviewView];
//        self.sharedView = self;
        [[UIUtils currentRootView] addSubview:self.sharedView];
    }
    
    return self;
}

- (void)setShowSharedScreen:(BOOL)showSharedScreen {
    if (showSharedScreen) {
        [AgoraScreenShareManager.share setSharedView:self.sharedView];
    }
}

@end
