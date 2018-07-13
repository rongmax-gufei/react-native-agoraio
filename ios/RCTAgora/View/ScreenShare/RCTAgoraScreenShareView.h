//
//  RCTAgoraScreenShareView.h
//  RCTAgora
//
//  Created by Learnta on 2018/6/13.
//  Copyright © 2018年 Learnta Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface RCTAgoraScreenShareView : UIView

@property (strong, nonatomic) AgoraRtcEngineKit *rtcEngine;

@property (nonatomic, strong) UIView *sharedView;
@property (nonatomic) BOOL showSharedScreen;

@end
