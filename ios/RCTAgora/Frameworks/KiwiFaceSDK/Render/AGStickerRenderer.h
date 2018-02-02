//
//  AGStickerRenderer.h
//  PLMediaStreamingKitDemo
//
//  Created by ChenHao on 2016/11/14.
//  Copyright © 2016年 0dayZh. All rights reserved.
//

#import "AGRenderProtocol.h"
#import "GPUImage.h"

@class AGSticker;

/**
 Sticker rendering classes
 */
@interface AGStickerRenderer : GPUImageFilter <AGRenderProtocol, GPUImageInput>

typedef void(^StickerRendererPlayOverBlock)(void);

@property(nonatomic, copy) StickerRendererPlayOverBlock stickerRendererPlayOverBlock;

/**
 Need to draw the stickers
 */
@property(nonatomic, strong) AGSticker *sticker;

@property(nonatomic, copy) NSArray<NSArray *> *faces;

@property(nonatomic, copy) NSMutableArray<NSMutableDictionary *> *faceOtherInfos;

/**
 Whether the mirror
 */
@property(nonatomic, assign) BOOL isMirrored;

@end
