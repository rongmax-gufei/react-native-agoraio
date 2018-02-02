//
//  AGStickerManager.h
//  AGMediaStreamingKitDemo
//
//  Created by ChenHao on 2016/10/13.
//  Copyright © 2016年 0dayZh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGSticker.h"

/**
 Sticker operation management class
 */
@interface AGPresentStickerManager : NSObject

+ (instancetype)sharedManager;

/**
 Asynchronous mode reads all the sticker information from the file
 
 @param completion Read the callback after completion
 */
- (void)loadStickersWithCompletion:(void (^)(NSMutableArray<AGSticker *> *stickers))completion;

/*
 * Get the sticker path
 */
- (NSString *)getStickerPath;

/**
 Update StickerConfig's sticker download status
 */
- (void)updateConfigJSON;


@end
