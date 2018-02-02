//
//  AGGlobalFilter.h
//  AGFaceKitDemo
//
//  Created by jacoy on 2017/8/9.
//  Copyright © 2017年 0dayZh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AGFilterType)
{
    AGFilterTypeDefault,//0  AG's downloadURL
    AGFilterTypeInner,//1 your own downloadURL
};

@interface AGGlobalFilter : NSObject

@property(nonatomic, copy) NSString *name;

@property(nonatomic, copy) NSString *filterResourceDir;

@property(nonatomic, assign) AGFilterType type;

- (instancetype)initWithName:(NSString *)name filterResourceDir:(NSString *)filterResourceDir type:(AGFilterType)type;

- (id)getShaderFilter;

@end
