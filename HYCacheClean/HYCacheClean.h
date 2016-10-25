//
//  HYCacheClean.h
//  HYCacheCleanDemo
//
//  Created by 徐天宇 on 2016/10/24.
//  Copyright © 2016年 devhy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CacheCleanCompleteBlock)();
typedef void(^CacheCleanSizeCompleteBlock)(float filesSize);

@interface HYCacheClean : NSObject

/**
 获取路径数组所有文件大小总和，同时计算SDWebImageDisk
 */
+ (void)cacheSizeWithPaths:(NSArray<NSString *> *)paths complete:(CacheCleanSizeCompleteBlock)complete;

/**
 删除路径数组所有文件，同时清除SDWebImageDisk
 */
+ (void)cacheCleanWithPaths:(NSArray<NSString *> *)paths complete:(CacheCleanCompleteBlock)complete;

@end
