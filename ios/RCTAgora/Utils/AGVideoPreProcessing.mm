//
//  AGVideoPreProcessing.m
//  OpenVideoCall
//
//  Created by Learnta on 2018/2/1.
//  Copyright © 2018年 Learnta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGVideoPreProcessing.h"

#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>
#import <AgoraRtcEngineKit/IAgoraRtcEngine.h>
#import <AgoraRtcEngineKit/IAgoraMediaEngine.h>
#import <string.h>
#import <CoreVideo/CVPixelBuffer.h>

#import "FaceTracker.h"

#import "libyuv.h"
#import "AGUIManager.h"
#import "AGRenderManager.h"
#import "AGStickerManager.h"

class AgoraAudioFrameObserver : public agora::media::IAudioFrameObserver
{
public:
    virtual bool onRecordAudioFrame(AudioFrame& audioFrame) override
    {
        return true;
    }
    virtual bool onPlaybackAudioFrame(AudioFrame& audioFrame) override
    {
        return true;
    }
    virtual bool onPlaybackAudioFrameBeforeMixing(unsigned int uid, AudioFrame& audioFrame) override
    {
        return true;
    }
};

NSTimeInterval _lastTime;
NSUInteger _count;

AGUIManager *UIManager;
AGRenderManager *renderManager;

CFDictionaryRef empty; // empty value for attr value.
CFMutableDictionaryRef attrs;

class AgoraVideoFrameObserver : public agora::media::IVideoFrameObserver
{
public:
    
    virtual bool onCaptureVideoFrame(VideoFrame& videoFrame) override
    {
        
        /* 判断是否有渲染任务  如果没有则不需要格式转换 直接跳过渲染工作 */
        if ([[AGRenderManager sharedManager].renderer getAllUsingFiltersCount] <= 0) {
            return true;
        }

        /* 横竖屏时更新sdk内置UI 坐标 */
        [UIManager resetScreemMode];
        
        if (_lastTime == 0) {
            _lastTime = [[NSDate date] timeIntervalSince1970];
        }
        else
        {
            _count++;
            NSTimeInterval delta = [[NSDate date] timeIntervalSince1970] - _lastTime;
            if (delta >= 1) {
                /* 计算fps */
                //                _lastTime = [[NSDate date] timeIntervalSince1970];
                //                float fps = _count / delta;
                //                _count = 0;
                //
                //                if ((int)round(fps) > 0) {
                //                    NSLog(@"FPS: %d",(int)round(fps));
                //                }
            }
        }
        
        
        VideoFrame frame;
        
        frame.type = (VIDEO_FRAME_TYPE)videoFrame.type;
        
        frame.width = videoFrame.width;
        
        frame.height = videoFrame.height;
        
        frame.yBuffer = videoFrame.yBuffer;
        
        frame.uBuffer = videoFrame.uBuffer;
        
        frame.vBuffer = videoFrame.vBuffer;
        
        frame.yStride = videoFrame.yStride;
        
        frame.uStride = videoFrame.uStride;
        
        frame.vStride = videoFrame.vStride;
        
        
        uint8_t *argb = (uint8_t *)malloc(frame.width * frame.height * 4 * sizeof(uint8_t));
        
        libyuv::I420ToBGRA((uint8_t *)frame.yBuffer,
                           frame.yStride,
                           (uint8_t *)frame.uBuffer,
                           frame.uStride,
                           (uint8_t *)frame.vBuffer,
                           frame.vStride,
                           argb,
                           frame.width * 4,
                           frame.width,
                           frame.height);
        
        CVReturn err = 0;
        CVPixelBufferRef renderTarget;
        
        
        
        err = CVPixelBufferCreate(kCFAllocatorDefault, (int)videoFrame.width, (int)videoFrame.height, kCVPixelFormatType_32BGRA, attrs, &renderTarget);
        
        if (err)
        {
            NSLog(@"FBO size: %d, %d", videoFrame.width, videoFrame.height);
            //            NSAssert(err, @"Error at CVPixelBufferCreate %d", err);
        }
        
        
        CVPixelBufferLockBaseAddress(renderTarget, 0);
        unsigned char *baseAddress = (unsigned char *)CVPixelBufferGetBaseAddress(renderTarget);
        
        libyuv::ARGBToBGRA(argb,
                           videoFrame.width * 4,
                           baseAddress,
                           videoFrame.width * 4,
                           videoFrame.width,
                           videoFrame.height);
        
        CVPixelBufferUnlockBaseAddress(renderTarget, 0);
        
        free(argb);
        
        [AGRenderManager processPixelBuffer:renderTarget];
        
        if (!renderManager.renderer.trackResultState) {
            //没有捕捉到人脸
            NSLog(@"没有捕捉到人脸");
        } else {
            //捕捉到人脸
            NSLog(@"捕捉到人脸");
        }
        
        CVPixelBufferLockBaseAddress(renderTarget, 0);
        baseAddress = (unsigned char *)CVPixelBufferGetBaseAddress(renderTarget);
        
        libyuv::ARGBToI420(baseAddress,
                           (int)CVPixelBufferGetBytesPerRow(renderTarget),
                           (uint8 *)videoFrame.yBuffer,
                           videoFrame.yStride,
                           (uint8 *)videoFrame.uBuffer,
                           videoFrame.uStride,
                           (uint8 *)videoFrame.vBuffer,
                           videoFrame.vStride,
                           videoFrame.width,
                           videoFrame.height);
        
        CVPixelBufferUnlockBaseAddress(renderTarget, 0);
        
        CFRelease(renderTarget);
        
        return true;
    }
    
    virtual bool onRenderVideoFrame(unsigned int uid, VideoFrame& videoFrame) override
    {
        return true;
    }
};

@interface AGVideoPreProcessing()

@property (nonatomic, weak) AGRenderManager *AGSDK;

@end

static AgoraVideoFrameObserver s_videoFrameObserver;
static NSArray<AGSticker *> *_stickers;
static NSInteger _currentStickerIndex;
static UIViewController *viewController;
@implementation AGVideoPreProcessing
{
    //        __weak __block AGSDK *__weakSelf;
}

+ (void)setViewControllerDelegate:(id)viewController
{
  
}

+ (int) registerVideoPreprocessing: (AgoraRtcEngineKit*) kit
{
    if (!kit) {
        return -1;
    }
    
    agora::rtc::IRtcEngine* rtc_engine = (agora::rtc::IRtcEngine*)kit.getNativeHandle;
    agora::util::AutoPtr<agora::media::IMediaEngine> mediaEngine;
    mediaEngine.queryInterface(rtc_engine, agora::rtc::AGORA_IID_MEDIA_ENGINE);
    if (mediaEngine)
    {
        //mediaEngine->registerAudioFrameObserver(&s_audioFrameObserver);
        mediaEngine->registerVideoFrameObserver(&s_videoFrameObserver);
        
        [[AGStickerManager sharedManager] loadStickersWithCompletion:^(NSArray<AGSticker *> *stickers) {
            _stickers = stickers;
            //            for (AGSticker *sticker in stickers) {
            //                NSLog(@"sticker sound: %@", sticker.stickerSound);
            //            }
            _currentStickerIndex = -1;
        }];
        
        empty = CFDictionaryCreate(kCFAllocatorDefault, NULL, NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks); // our empty IOSurface properties dictionary
        attrs = CFDictionaryCreateMutable(kCFAllocatorDefault, 1, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        CFDictionarySetValue(attrs, kCVPixelBufferIOSurfacePropertiesKey, empty);
        
    }
    return 0;
}


+ (int) deregisterVideoPreprocessing: (AgoraRtcEngineKit*) kit
{
    if (!kit) {
        return -1;
    }
    
    //    NSInteger count2 = CFGetRetainCount(empty);
    //    for (NSInteger i = 0; i < count2 -1; i++) {
    //        CFRelease(empty);
    //    }
    
    
    
    //    NSLog(@"（CF）attrs:%ld,empty:%ld",count1);
    agora::rtc::IRtcEngine* rtc_engine = (agora::rtc::IRtcEngine*)kit.getNativeHandle;
    agora::util::AutoPtr<agora::media::IMediaEngine> mediaEngine;
    mediaEngine.queryInterface(rtc_engine, agora::rtc::AGORA_IID_MEDIA_ENGINE);
    if (mediaEngine)
    {
        //mediaEngine->registerAudioFrameObserver(NULL);
        mediaEngine->registerVideoFrameObserver(NULL);
    }
    
    CFRelease(empty);
    
    NSInteger count1 = CFGetRetainCount(attrs);
    for (NSInteger i = 0; i < count1; i++) {
        CFRelease(attrs);
    }
    
    return 0;
}

@end
