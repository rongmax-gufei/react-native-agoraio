//
//  RCTAgora.m
//  RCTAgora
//
//  Created by Learnta on 2017/12/21.
//  Copyright © 2017年 Learnta Inc. All rights reserved.
//

#import "RCTAgora.h"

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTBridge.h>
#import <React/RCTUIManager.h>
#import <React/RCTView.h>

#import <videoprp/AgoraYuvEnhancerObjc.h>

#import "AgoraConst.h"
#import "UIUtils.h"
#import "BundleTools.h"

@interface RCTAgora ()<AgoraRtcEngineDelegate>

@property(strong, nonatomic) AgoraRtcEngineKit *rtcEngine;

@property(nonatomic, assign) BOOL isBroadcaster;

@property(nonatomic, strong) AgoraYuvEnhancerObjc *agoraEnhancer;

@end

@implementation RCTAgora

RCT_EXPORT_MODULE();

@synthesize bridge = _bridge;

/**
 *  初始化AgoraKit
 *
 *  @param appid
 *  @param channelProfile  设置频道模式
 *  @param videoProfile    视频模式
 *  @param clientRole      创建角色
 *  @param channelName     频道名称
 *  @param info            附加字段
 *  @param reactTag        绑定view的tag
 *  @return 0 when executed successfully. return negative value if failed.
 */
RCT_EXPORT_METHOD(init:(NSDictionary *)options) {
  
    NSString *appid                     = options[@"appid"];
    AgoraChannelProfile channelProfile  = [options[@"channelProfile"] integerValue];
    AgoraVideoProfile videoProfile      = [options[@"videoProfile"] integerValue];
    BOOL swapWidthAndHeight             = [options[@"swapWidthAndHeight"] boolValue];
    AgoraClientRole role                = [options[@"clientRole"] integerValue];
    
    [AgoraConst share].appid = appid;
    self.isBroadcaster = (role == AgoraClientRoleBroadcaster);
    
    // 初始化RtcEngineKit
    self.rtcEngine = [AgoraRtcEngineKit sharedEngineWithAppId:appid delegate:self];
    [AgoraConst share].rtcEngine = self.rtcEngine;
    
    //频道模式
    [self.rtcEngine setChannelProfile:channelProfile];
    //启用双流模式
    [self.rtcEngine enableDualStreamMode:YES];
    [self.rtcEngine enableVideo];
    [self.rtcEngine setVideoProfile:videoProfile swapWidthAndHeight:swapWidthAndHeight];
    [self.rtcEngine setClientRole:role];
    
    //Agora Native SDK 与 Agora Web SDK 间的互通
    [self.rtcEngine enableWebSdkInteroperability:YES];
    // 打开美颜
    [self openBeautityFace];
}

//加入房间
RCT_EXPORT_METHOD(joinChannel:(NSString *)channelName uid:(NSInteger)uid) {
    //保存一下uid 在自定义视图使用
    [AgoraConst share].localUid = uid;
    [self.rtcEngine joinChannelByToken:nil channelId:channelName info:nil uid:uid joinSuccess:NULL];
}

//离开频道
RCT_EXPORT_METHOD(leaveChannel) {
    // 本地视频释放
    [self.rtcEngine setupLocalVideo:nil];
    // 退出频道
    [self.rtcEngine leaveChannel:^(AgoraChannelStats * _Nonnull stat) {
        NSMutableDictionary *params = @{}.mutableCopy;
        params[@"type"] = @"onLeaveChannel";
        [self sendEvent:params];
    }];
  
    // 如果是主播，关闭预览
    if (self.isBroadcaster) {
        [self.rtcEngine stopPreview];
    }
    
    // 关闭美颜
    [self closeBeautityFace];
}

//销毁引擎实例
RCT_EXPORT_METHOD(destroy) {
    [AgoraRtcEngineKit destroy];
}

//切换角色
RCT_EXPORT_METHOD(changeRole) {
    AgoraClientRole role = self.isBroadcaster ? AgoraClientRoleAudience : AgoraClientRoleBroadcaster;
    self.isBroadcaster = (role == AgoraClientRoleBroadcaster);
    [self.rtcEngine setClientRole:role];
}
;
/**
 *  设置 本地 视频显示属性
 *
 *  @param uid             用户id
 *  @param renderMode      hidden, fit and adaptive
 *  @param reactTag        绑定view的tag
 */
RCT_EXPORT_METHOD(setupLocalVideo:(NSDictionary *)options) {
    AgoraRtcVideoCanvas *canvas = [[AgoraRtcVideoCanvas alloc] init];
    canvas.uid = [options[@"uid"] integerValue];
    canvas.view = [self.bridge.uiManager viewForReactTag:options[@"reactTag"]];
    canvas.renderMode = [options[@"renderMode"] integerValue];
    [self.rtcEngine setupLocalVideo:canvas];
}

/**
 *  设置 远端 视频显示视图
 *
 *  @param uid             用户id
 *  @param renderMode      hidden, fit and adaptive
 *  @param reactTag        绑定view的tag
 */
RCT_EXPORT_METHOD(setupRemoteVideo:(NSDictionary *)options) {
    AgoraRtcVideoCanvas *canvas = [[AgoraRtcVideoCanvas alloc] init];
    canvas.uid = [options[@"uid"] integerValue];
    canvas.view = [self.bridge.uiManager viewForReactTag:options[@"reactTag"]];
    canvas.renderMode = [options[@"renderMode"] integerValue];
    [self.rtcEngine setupRemoteVideo:canvas];
}

//开启视频预览
RCT_EXPORT_METHOD(startPreview){
    [self.rtcEngine startPreview];
}

//配置旁路直播推流(configPublisher)
//请确保用户已经调用 setClientRole() 且已将用户角色设为主播
//主播必须在加入频道前调用本API
RCT_EXPORT_METHOD(configPublisher:(NSDictionary *)config) {
    AgoraPublisherConfiguration *apc = [AgoraPublisherConfiguration new];
    
    apc.width = [config[@"width"] integerValue];  //旁路直播的输出码流的宽度
    apc.height = [config[@"height"] integerValue]; //旁路直播的输出码流的高度
    apc.framerate = [config[@"framerate"] integerValue]; //旁路直播的输出码率帧率
    apc.bitrate = [config[@"bitrate"] integerValue]; //旁路直播输出码流的码率
    apc.defaultLayout = [config[@"defaultLayout"] integerValue]; //设置流生命周期
    apc.lifeCycle = [config[@"lifeCycle"] integerValue]; //默认合图布局
    apc.publishUrl = config[@"publishUrl"]; //合图推流地址
    apc.rawStreamUrl = config[@"rawStreamUrl"]; //单流地址
    apc.extraInfo = config[@"extraInfo"]; //其他信息
    apc.owner = [config[@"owner"] boolValue]; //是否将当前主播设为该 RTMP 流的主人
    
    [self.rtcEngine configPublisher:apc];
}

//设置本地视频显示模式
RCT_EXPORT_METHOD(setLocalRenderMode:(NSUInteger)mode) {
    [self.rtcEngine setLocalRenderMode:mode];
}

//设置远端视频显示模式
RCT_EXPORT_METHOD(setRemoteRenderMode:(NSUInteger)uid mode:(NSUInteger)mode) {
    [self.rtcEngine setRemoteRenderMode:uid mode:mode];
}

//启用说话者音量提示
RCT_EXPORT_METHOD(enableAudioVolumeIndication:(NSUInteger)interval smooth:(NSUInteger)smooth) {
    [self.rtcEngine enableAudioVolumeIndication:interval smooth:smooth];
}

//开启屏幕共享
//RCT_EXPORT_METHOD(startScreenCapture:(NSUInteger)windowId){
//
//}

//关闭视频预览
RCT_EXPORT_METHOD(stopPreview) {
    [self.rtcEngine stopPreview];
}

//切换前置/后置摄像头
RCT_EXPORT_METHOD(switchCamera) {
    [self.rtcEngine switchCamera];
}

//开启视频模式
RCT_EXPORT_METHOD(enableVideo) {
    [self.rtcEngine enableVideo];
}

//关闭视频
RCT_EXPORT_METHOD(disableVideo) {
    [self.rtcEngine disableVideo];
}

//打开外放  Yes: 音频输出至扬声器  No: 音频输出至听筒
RCT_EXPORT_METHOD(setEnableSpeakerphone:(BOOL)enableSpeaker) {
    [self.rtcEngine setEnableSpeakerphone: enableSpeaker];
}

//将自己静音
RCT_EXPORT_METHOD(muteLocalAudioStream:(BOOL)mute) {
    [self.rtcEngine muteLocalAudioStream:mute];
}

//静音所有远端 音频
RCT_EXPORT_METHOD(muteAllRemoteAudioStreams:(BOOL)mute) {
    [self.rtcEngine muteAllRemoteAudioStreams:mute];
}

//静音指定用户 音频
RCT_EXPORT_METHOD(muteRemoteAudioStream:(NSUInteger)uid muted:(BOOL)mute) {
    [self.rtcEngine muteRemoteAudioStream:uid mute:mute];
}

//设置是否打开闪光灯
RCT_EXPORT_METHOD(setCameraTorchOn:(BOOL)isOn) {
    [self.rtcEngine setCameraTorchOn:isOn];
}

//设置是否开启人脸对焦功能
RCT_EXPORT_METHOD(setCameraAutoFocusFaceModeEnabled:(BOOL)enable) {
    [self.rtcEngine setCameraAutoFocusFaceModeEnabled:enable];
}

//修改默认的语音路由 True: 默认路由改为外放(扬声器) False: 默认路由改为听筒
RCT_EXPORT_METHOD(setDefaultAudioRouteToSpeakerphone:(BOOL)defaultToSpeaker) {
    [self.rtcEngine setDefaultAudioRouteToSpeakerphone:defaultToSpeaker];
}

//暂停发送本地 视频流
RCT_EXPORT_METHOD(muteLocalVideoStream:(BOOL)muted) {
    [self.rtcEngine muteLocalVideoStream:muted];
}

//禁用本地视频功能
RCT_EXPORT_METHOD(enableLocalVideo:(BOOL)enabled) {
    [self.rtcEngine enableLocalVideo:enabled];
}

//暂停所有远端视频流
RCT_EXPORT_METHOD(muteAllRemoteVideoStreams:(BOOL)muted) {
    [self.rtcEngine muteAllRemoteVideoStreams:muted];
}

//暂停指定远端视频流
RCT_EXPORT_METHOD(muteRemoteVideoStream:(NSUInteger)uid mute:(BOOL)mute) {
    [self.rtcEngine muteRemoteVideoStream:uid mute:mute];
}

//启动服务端录制服务
RCT_EXPORT_METHOD(startRecordingService:(NSString*)recordingKey) {
    [self.rtcEngine startRecordingService:recordingKey];
}

//停止服务端录制服务
RCT_EXPORT_METHOD(stopRecordingService:(NSString*)recordingKey) {
    [self.rtcEngine stopRecordingService:recordingKey];
}

//获取版本号
RCT_EXPORT_METHOD(getSdkVersion:(RCTResponseSenderBlock)callback) {
    callback(@[[AgoraRtcEngineKit getSdkVersion]]);
}

#pragma mask BeautityFace EXPORT_METHODS
//打开美颜
- (void)openBeautityFace {
    if (!self.agoraEnhancer) {
        AgoraYuvEnhancerObjc *enhancer = [[AgoraYuvEnhancerObjc alloc] init];
        [enhancer turnOn];
        self.agoraEnhancer = enhancer;
    }
}

//关闭美颜
- (void)closeBeautityFace {
    if (self.agoraEnhancer) {
        [self.agoraEnhancer turnOff];
        self.agoraEnhancer = nil;
    }
}

/*
 * 该回调方法表示SDK运行时出现了（网络或媒体相关的）错误。通常情况下，SDK上报的错误意味着SDK无法自动恢复，需要应用程序干预或提示用户。
 * 比如启动通话失败时，SDK会上报AgoraRtc_Error_StartCall(1002)错误。
 * 应用程序可以提示用户启动通话失败，并调用leaveChannel退出频道。
 */
#pragma mark AgoraSDK

- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didOccurError:(AgoraErrorCode)errorCode {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"type"] = @"onError";
    params[@"err"] = [NSNumber numberWithInteger:errorCode];;
    
    [self sendEvent:params];
}

/*
 * 警告
 */
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didOccurWarning:(AgoraWarningCode)warningCode {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"type"] = @"onWarning";
    params[@"err"] = [NSNumber numberWithInteger:warningCode];;
    
    [self sendEvent:params];
}

/*
 * 加入频道回调
 * 该回调方法表示该客户端成功加入了指定的频道
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinChannel:(NSString*)channel withUid:(NSUInteger)uid elapsed:(NSInteger) elapsed {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"type"] = @"onJoinChannelSuccess";
    params[@"uid"] = [NSNumber numberWithInteger:uid];
    params[@"channel"] = channel;
    
    [self sendEvent:params];
}

/*
 * 重新加入频道回调
 * 有时候由于网络原因，客户端可能会和服务器失去连接，SDK 会进行自动重连，自动重连成功后触发此回调方法。
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didRejoinChannel:(NSString*)channel withUid:(NSUInteger)uid elapsed:(NSInteger) elapsed {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"type"] = @"onReJoinChannelSuccess";
    params[@"uid"] = [NSNumber numberWithInteger:uid];
    params[@"channel"] = channel;
    
    [self sendEvent:params];
}

/*
 * 本地首帧视频显示回调
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstLocalVideoFrameWithSize:(CGSize)size elapsed:(NSInteger)elapsed {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"type"] = @"onFirstLocalVideoFrameWithSize";
    params[@"width"] = [NSNumber numberWithFloat:size.width];
    params[@"height"] = [NSNumber numberWithFloat:size.height];
    
    [self sendEvent:params];
}

/*
 * 远端首帧视频接收解码回调
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoDecodedOfUid:(NSUInteger)uid size:(CGSize)size elapsed:(NSInteger)elapsed {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"type"] = @"onFirstRemoteVideoDecoded";
    params[@"uid"] = [NSNumber numberWithInteger:uid];
    params[@"width"] = [NSNumber numberWithFloat:size.width];
    params[@"height"] = [NSNumber numberWithFloat:size.height];
    
    [self sendEvent:params];
}

/*
 * 远端首帧视频显示回调
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoFrameOfUid:(NSUInteger)uid size:(CGSize)size elapsed:(NSInteger)elapsed {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"type"] = @"onFirstRemoteVideoFrameOfUid";
    params[@"uid"] = [NSNumber numberWithInteger:uid];
    params[@"width"] = [NSNumber numberWithFloat:size.width];
    params[@"height"] = [NSNumber numberWithFloat:size.height];
    
    [self sendEvent:params];
}

/*
 * 主播加入回调
 * 提示有主播加入了频道。如果该客户端加入频道时已经有人在频道中，SDK也会向应用程序上报这些已在频道中的用户。
 * 直播场景下:
 * 主播间能相互收到新主播加入频道的回调，并能获得该主播的 uid
 * 观众也能收到新主播加入频道的回调，并能获得该主播的 uid
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"type"] = @"onUserJoined";
    params[@"uid"] = [NSNumber numberWithInteger:uid];
    
    [self sendEvent:params];
}

/*
 * 主播离线回调
 * 提示有主播离开了频道（或掉线）。
 * SDK 判断用户离开频道（或掉线）的依据是超时: 在一定时间内（15 秒）没有收到对方的任何数据包，判定为对方掉线。
 * 在网络较差的情况下，可能会有误报。建议可靠的掉线检测应该由信令来做。
 */
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"type"] = @"onUserOffline";
    params[@"uid"] = [NSNumber numberWithInteger:uid];
    
    [self sendEvent:params];
}

/*
 * 音量提示回调
 * 需要开启enableAudioVolumeIndication
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine reportAudioVolumeIndicationOfSpeakers:(NSArray*)speakers totalVolume:(NSInteger)totalVolume {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"type"] = @"onAudioVolumeIndication";
    
    NSMutableArray *arr = [NSMutableArray array];
    for (AgoraRtcAudioVolumeInfo *obj in speakers) {
        [arr addObject:@{@"uid":[NSNumber numberWithInteger:obj.uid], @"volume":[NSNumber numberWithInteger:obj.volume]}];
    }
    
    params[@"speakers"] = arr;
    params[@"totalVolume"] = [NSNumber numberWithInteger:totalVolume];
    
    [self sendEvent:params];
}

/*
 * 网络连接中断回调
 * 在 SDK 和服务器失去了网络连接时，触发该回调。失去连接后，除非APP主动调用 leaveChannel，SDK 会一直自动重连。
 */
- (void)rtcEngineConnectionDidInterrupted:(AgoraRtcEngineKit *)engine {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"type"] = @"onConnectionDidInterrupted";
    
    [self sendEvent:params];
}

/*
 * 网络连接丢失回调
 * 在 SDK 和服务器失去了网络连接后，会触发 rtcEngineConnectionDidInterrupted 回调，并自动重连。
 * 在一定时间内（默认 10 秒）如果没有重连成功，触发 rtcEngineConnectionDidLost 回调。
 * 除非 APP 主动调用 leaveChannel，SDK 仍然会自动重连。
 */
- (void)rtcEngineConnectionDidLost:(AgoraRtcEngineKit *)engine {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"type"] = @"onConnectionDidLost";
    
    [self sendEvent:params];
}

/*
 * 连接已被禁止回调
 * 当你被服务端禁掉连接的权限时，会触发该回调。意外掉线之后，SDK 会自动进行重连，重连多次都失败之后，该回调会被触发，判定为连接不可用。
 */
- (void)rtcEngineConnectionDidBanned:(AgoraRtcEngineKit * _Nonnull)engine {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"type"] = @"onConnectionDidBanned";
    
    [self sendEvent:params];
}

// 根据tag找到指定的view
- (UIView *)getViewWithTag:(nonnull NSNumber *)reactTag {
    UIView *view = [self.bridge.uiManager viewForReactTag:reactTag];
    NSLog(@"%@",view);
    return view;
}

#pragma mark - native to js event method
- (NSArray<NSString *> *)supportedEvents {
    return @[@"agoraEvent"];
}

- (void)sendEvent:(NSDictionary *)params {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self sendEventWithName:@"agoraEvent" body:params];
    });
}

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

@end

