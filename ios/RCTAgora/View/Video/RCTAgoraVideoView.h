//
//  RCTAgoraVideoView.h
//  RCTAgora
//
//  Created by Learnta on 2017/12/21.
//  Copyright © 2017年 Learnta Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgoraConst.h"

@interface RCTAgoraVideoView : UIView

@property (strong, nonatomic) AgoraRtcEngineKit *rtcEngine;

@property (nonatomic) BOOL showLocalVideo;
@property (nonatomic) NSInteger remoteUid;

@end
