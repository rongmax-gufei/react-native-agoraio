//
//  AGGlobalFilterManager.h
//  AGFaceKitDemo
//
//  Created by zhaoyichao on 2017/3/4.
//  Copyright © 2017年 0dayZh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGColorFilter.h"

@class AGGlobalFilter;

@interface AGGlobalFilterManager : NSObject



+ (instancetype)sharedManager;

/**
 Asynchronous mode reads all the sticker information from the file
 
 @param completion Read the callback after completion
 */
- (void)loadColorFiltersWithCompletion:(void (^)(NSMutableArray<AGGlobalFilter *> *filters))completion;

+ (void)removeAllColorFilters;

@end
