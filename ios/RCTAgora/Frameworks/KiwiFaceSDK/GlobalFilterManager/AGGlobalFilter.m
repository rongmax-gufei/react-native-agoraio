//
//  AGGlobalFilter.m
//  AGFaceKitDemo
//
//  Created by jacoy on 2017/8/9.
//  Copyright © 2017年 0dayZh. All rights reserved.
//

#import "AGGlobalFilter.h"
#import "AGColorFilter.h"

@implementation AGGlobalFilter

- (instancetype)initWithName:(NSString *)name filterResourceDir:(NSString *)filterResourceDir type:(AGFilterType)type {
    if (self = [super init]) {
        self.name = name;
        self.type = type;
        self.filterResourceDir = filterResourceDir;
    }
    return self;
}

- (id)getShaderFilter {

    GPUImageOutput <GPUImageInput, AGRenderProtocol> *shaderFilter;

    if (self.type == AGFilterTypeDefault) {

        shaderFilter = [[AGColorFilter alloc] initWithDir:self.filterResourceDir];

    } else {
        NSLog(@"getShaderFilter name : %@",self.name);
        Class class = NSClassFromString(self.name);
        NSLog(@"getShaderFilter class:%@",NSStringFromClass(class));
        shaderFilter = [[class alloc] init];
    }

    return shaderFilter;
}

@end
