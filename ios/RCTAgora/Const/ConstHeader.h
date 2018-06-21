//
//  ConstHeader.h
//  RCTAgora
//
//  Created by Learnta on 2018/6/13.
//  Copyright © 2018年 Learnta Inc. All rights reserved.
//

#ifndef ConstHeader_h
#define ConstHeader_h

#import "AgoraConst.h"

/******************** local param **********************/
#define kAppid              @"appid"
#define kChannelProfile     @"channelProfile"
#define kVideoProfile       @"videoProfile"
#define kSwapWidthAndHeight @"swapWidthAndHeight"
#define kClientRole         @"clientRole"
#define kCode               @"code"
#define kType               @"type"
#define kMsg                @"msg"
#define kChannel            @"channel"
#define kUid                @"uid"
#define kWidth              @"width"
#define kHeight             @"height"
#define kVolume             @"volume"
#define kSpeakers           @"speakers"
#define kTotalVolume        @"totalVolume"
#define kRenderMode         @"renderMode"
#define kReactTag           @"reactTag"
#define kAgoraEvent         @"agoraEvent"

/******************** event cmd **********************/
#define kOnAgoraRtcError                @"onError"
#define kOnAgoraRtcWarning              @"onWarning"
#define kOnJoinChannelSuccess           @"onJoinChannelSuccess"
#define kOnReJoinChannelSuccess         @"onReJoinChannelSuccess"
#define kOnFirstLocalVideoFrameWithSize @"onFirstLocalVideoFrameWithSize"
#define kOnFirstRemoteVideoDecoded      @"onFirstRemoteVideoDecoded"
#define kOnFirstRemoteVideoFrameOfUid   @"onFirstRemoteVideoFrameOfUid"
#define kOnUserJoined                   @"onUserJoined"
#define kOnUserOffline                  @"onUserOffline"
#define kOnAudioVolumeIndication        @"onAudioVolumeIndication"
#define kOnConnectionDidInterrupted     @"onConnectionDidInterrupted"
#define kOnConnectionDidLost            @"onConnectionDidLost"
#define kOnConnectionDidBanned          @"onConnectionDidBanned"
#define kOnBoardcast                    @"onBoardcast"
#define kOnLeaveChannel                 @"onLeaveChannel"

/******************** local code **********************/
#define kSuccess        1000
#define kFail           1001
#define kScreenShareEnd -1

/******************** app groups **********************/
#define kAppGroups @"group.ilive.broadcast"

#endif /* ConstHeader_h */
