# react-native-agoraio 

[![npm version](https://badge.fury.io/js/react-native-agoraio.svg)](https://badge.fury.io/js/react-native-agoraio)
[![npm](https://img.shields.io/npm/dt/react-native-agoraio.svg)](https://www.npmjs.com/package/react-native-agoraio)
![Platform - Android and iOS](https://img.shields.io/badge/platform-Android%20%7C%20iOS-yellow.svg)
![MIT](https://img.shields.io/dub/l/vibe-d.svg)

| Author        |     E-mail      |
| ------------- |:---------------:|
| gufei         | 799170694@qq.com|


## 功能介绍

- 支持 iOS、Android 声网Agora多人互动直播
- 支持 免费的基础美颜：美白、磨皮、红润等
- 高级美颜功能，请自行接入Kiwi、Sentime、FaceU等服务商的SDK

## 安装使用

 `npm install --save react-native-agoraio`

Then link with:

 `react-native link react-native-agoraio`

#### iOS

TARGETS->Build Phases-> Link Binary With Libaries中点击“+”按钮，选择

    libresolv.tbd
    libc++.tbd
    AVFoundation.framework
    AudioToolbox.framework
    VideoToolbox.framework
    CoreMotion.framework
    CoreMedia.framework
    CoreTelephony.framework
    
TARGETS->Build Phases-> Link Binary With Libaries中点击“+”按钮，在弹出的窗口中点击“Add Other”按钮，选择
```
node_modules/react-native-agoraio/ios/RCTAgora/Frameworks/AgoraSDK/libcrypto.a
node_modules/react-native-agoraio/ios/RCTAgora/Frameworks/AgoraSDK/AgoraRtcCryptoLoader.framework
node_modules/react-native-agoraio/ios/RCTAgora/Frameworks/AgoraSDK/AgoraRtcEngineKit.framework
node_modules/react-native-agoraio/ios/RCTAgora/Frameworks/AgoraSDK/videoprp.framework
```
TARGETS->Build Settings->Search Paths->Framework Search Paths添加
```
"$(SRCROOT)/../node_modules/react-native-agoraio/ios/RCTAgora/Frameworks/AgoraSDK"
```    
TARGETS->Build Settings->Search Paths->Library Search Paths添加
```
"$(SRCROOT)/../node_modules/react-native-agoraio/ios/RCTAgora/Frameworks/AgoraSDK"
```   
TARGETS->Build Settings->Enable Bitcode设置为No

TARGETS->Capabilities->Background Modes->Modes勾选Audio,AirPlay,and Picture In Picture

项目目录->Info.plist->增加2项

    "Privacy - Camera Usage Description":"use camera to start video call"
    "Privacy - Microphone Usage Description":"use microphone to start video call"

#### Android

Add following to `AndroidManifest.xml`

    <uses-permission android:name="android.permission.RECORD_AUDIO" />
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />

当您在写混淆代码时，请添加以下代码:

    -keep class io.agora.**{*;}

## Documentation

[声网API](https://docs.agora.io/cn/2.0.2)<br>

##### RtcEngine方法

| Property                         | Type                                     | Description                           |
| -------------------------------- | ---------------------------------------- | ------------------------------------- |
| init                             | <br>{<br>appid: 'agora注册的应用id', <br>channelProfile: '频道模式', <br>videoProfile: '视频模式', <br>clientRole: '角色', <br>swapWidthAndHeight: 'bool值'<br>} | 初始化Agora引擎                            |
| joinChannel                      | string: channelName（房间名称)<br>number: uid（uid=0系统自动分配） | 加入房间                                  |
| leaveChannel                     |                                          | 离开频道                                |
| changeRole                       |                                          | 切换角色                                 |
| destroy                          |                                          | 销毁引擎实例                             |
| configPublisher                  | object{} config参数请前往Agora文档查看      | 配置旁路直播推流方法                               |
| setLocalRenderMode               | number: mode (1 2 3)                     | 设置本地视频显示模式                                |
| setRemoteRenderMode              | number: uid <br>number: mode (1 2 3)     | 设置远端视频显示模式                                |
| enableAudioVolumeIndication      | number: interval (时间间隔) <br>number: smooth(平滑系数，可以设置为3)                                         | 启用说话者音量提示                                |
| startPreview                     |                                          | 开启视频预览                                |
| stopPreview                      |                                          | 关闭视频预览                                |
| switchCamera                     |                                          | 切换（前置/后置）摄像头                            |
| enableVideo                      |                                          | 开启视频模式                                |
| disableVideo                     |                                          | 关闭视频                                  |
| setCameraAutoFocusFaceModeEnabled|                                          | 开/关 人脸对焦功能                                  |
| setDefaultAudioRouteToSpeakerphone|                                         | 修改默认的语音路由                                  |
| setCameraTorchOn                 |                                          | 开/关 闪光灯            |
| setEnableSpeakerphone            | bool                                     | 开/关 扬声器 |
| muteLocalAudioStream             | bool (default false)                     | 将自己静音                                 |
| muteAllRemoteAudioStreams        | bool (default false)                     | 静音所有远端音频                             |
| muteRemoteAudioStream            | number: uid（用户uid）<br>bool: mute（是否静音）| 静音指定用户音频                             |
| muteLocalVideoStream             | bool (default false)                     | 暂停发送本地视频流                            |
| enableLocalVideo                 | bool (default false)                     | 禁用本地视频功能                              |
| muteAllRemoteVideoStreams        | bool (default false)                     | 暂停所有远端视频流                             |
| muteRemoteVideoStream            | number: uid（用户uid）<br>bool: mute（是否暂停）| 暂停指定远端视频流                             |
| startRecordingService (iOS only) | string: recordingKey                     | 启动服务端录制服务                             |
| stopRecordingService (iOS only)  | string: recordingKey                     | 停止服务端录制服务                             |
| getSdkVersion                    | callback                                 | 获取版本号                                 |
| openMask                         |                                          | 打开贴纸，可设置瘦脸、大眼、美颜、人脸捕捉特效 |
| openFilter                       |                                          | 打开滤镜                                 |

##### 原生通知事件

```
RtcEngine.eventEmitter({
  onFirstRemoteVideoDecoded: data => {},
  onFirstRemoteVideoFrameOfUid: data => {},
  onFirstLocalVideoFrameWithSize: data => {},
  onJoinChannelSuccess: data => {},
  onReJoinChannelSuccess: data => {},
  onUserOffline: data => {},
  onUserJoined: data => {},
  onError: data => {},
  onWarning: data => {},
  onLeaveChannel: data => {},
  onAudioVolumeIndication: data => {},
  onConnectionDidInterrupted: data => {},
  onConnectionDidLost: data => {},
  onConnectionDidBanned: data => {}
})
```

| Name                      | Description  |
| ------------------------- | ------------ |
| onFirstRemoteVideoDecoded | 远端首帧视频接收解码回调 |
| onFirstRemoteVideoFrameOfUid | 远端首帧视频显示回调 |
| onFirstLocalVideoFrameWithSize | 本地首帧视频显示回调 |
| onJoinChannelSuccess      | 加入频道成功的回调    |
| onReJoinChannelSuccess      | 重新加入频道回调    |
| onUserOffline             | 其他用户离开当前频道   |
| onUserJoined              | 其他用户加入当前频道   |
| onError                   | 错误信息         |
| onWarning                 | 警告           |
| onLeaveChannel            | 退出频道         |
| onAudioVolumeIndication   | 音量提示回调         |
| onConnectionDidInterrupted   | 网络连接中断回调         |
| onConnectionDidLost   | 网络连接丢失回调         |
| onConnectionDidBanned   | 连接已被禁止回调         |


##### AgoraView 组件

| Name           | Description          |
| -------------- | -------------------- |
| showLocalVideo | 是否显示本地视频（bool）       |
| remoteUid      | 显示远程视频（number 传入uid） |
| zOrderMediaOverlay (Android only)      | 多视频界面覆盖 设置为true优先在上层（bool） |


## 运行示例

[Example](https://github.com/midas-gufei/RNAgoraExample)<br>
[Experience Package](https://fir.im/agoraio)<br>

<center class="half">
    <a href="https://raw.githubusercontent.com/midas-gufei/react-native-agora/master/screenshot/ios.png"><img width="375" height="667" src="https://raw.githubusercontent.com/midas-gufei/react-native-agora/master/screenshot/ios.png"/></a>
    <a href="https://raw.githubusercontent.com/midas-gufei/react-native-agora/master/screenshot/android.jpeg"><img width="375" height="750" src="https://raw.githubusercontent.com/midas-gufei/react-native-agora/master/screenshot/android.jpeg"/></a>
</center>

## 更新信息

#### 2.1.1 版 : 发布于 2018 年 3 月 16 日

 - 请正在或已集成 2.1 SDK 的客户尽快升级更新！ 本次发版修复了一个的系统风险，请尽快升级以免对服务造成影响。

#### 2.0.0 

 - andoid && iOS自带基础美颜功能
 - android新增切换角色方法

#### 1.10.12 

 - 集成Kiwi人脸跟踪及特效（贴纸、美颜、滤镜、哈哈镜） - iOS版
 - 新增切换角色方法

#### 1.10.10

 - 重新加入频道回调

 - 本地首帧视频显示回调

 - 远端首帧视频显示回调

 - 主播离线回调

 - 网络连接中断回调

 - 网络连接丢失回调

 - 连接已被禁止回调

#### 1.10.6

 - 更新Agora SDK为2.2.0

 - 新增方法 是否开启人脸对焦功能 setCameraAutoFocusFaceModeEnabled

 - 新增方法 修改默认的语音路由 setDefaultAudioRouteToSpeakerphone

 - 新增方法 是否打开闪光灯 setCameraTorchOn

 - 修复 Android 说话者音量提示bug

#### 1.0.8

 - 更新Agora SDK为1.12

 - init 不再默认开启视频预览 根据自己需求和时机调用startPreview

 - init options 新增参数  是否交换宽和高 swapWidthAndHeight 默认false

 - 新增方法 配置旁路直播推流方法 configPublisher

 - 新增方法 设置本地视频显示模式 setLocalRenderMode

 - 新增方法 设置远端视频显示模式 setRemoteRenderMode

 - 新增方法 启用说话者音量提示 enableAudioVolumeIndication

 - 新增音量提示回调 onAudioVolumeIndication

 - Android AgoraView 新增zOrderMediaOverlay属性 解决多视频界面覆盖 设置为true优先在上层
