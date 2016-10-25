//
//  HYCacheClean.m
//  HYCacheCleanDemo
//
//  Created by 徐天宇 on 2016/10/24.
//  Copyright © 2016年 devhy. All rights reserved.
//

#import "HYCacheClean.h"
#import <SDWebImage/SDImageCache.h>

@implementation HYCacheClean
/**
 计算一个文件的大小
 */
+ (float)fileSizeAtPath:(NSString *)path{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    BOOL isDirectory;
    BOOL isExist = [fileManager fileExistsAtPath:path isDirectory:&isDirectory];
    
    if(isExist && !isDirectory){
        
        NSDictionary<NSFileAttributeKey, id> *fileInfoDict= [fileManager attributesOfItemAtPath:path error:nil];
        long long size = fileInfoDict.fileSize;
        
        return size/1024.0/1024.0;
    }
    
    return 0;
}

/**
 计算一个文件夹内所有文件的大小总和
 */
+ (float)folderSizeAtPath:(NSString *)path{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    float folderSize;
    BOOL isDirectory;
    BOOL isExist = [fileManager fileExistsAtPath:path isDirectory:&isDirectory];
    
    if (!isExist)
        return 0;
    
    if (isDirectory) {
        
        //subpathsOfDirectoryAtPath可以获取所有子文件的路径，不管你有几层
        NSArray *childerFiles=[fileManager subpathsOfDirectoryAtPath:path error:nil];
        for (NSString *fileName in childerFiles) {
            
            folderSize += [self fileSizeAtPath:[path stringByAppendingPathComponent:fileName]];
        }
    } else {
        
        folderSize += [self fileSizeAtPath:path];
    }
    
    return folderSize;
}

/**
 根据路径删除路径下所有文件，包括子文件
 */
+ (void)cacheCleanWithPath:(NSString *)path{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:path];
    
    if (!isExist)
        return;
    
    NSArray *childerFiles=[fileManager subpathsAtPath:path];
    
    for (NSString *fileName in childerFiles) {
        
        NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
        [fileManager removeItemAtPath:absolutePath error:nil];
    }
}

#pragma mark - public api
/**
 获取路径数组所有文件大小总和，同时计算SDWebImageDisk
 */
+ (void)cacheSizeWithPaths:(NSArray<NSString *> *)paths complete:(CacheCleanSizeCompleteBlock)complete{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        float cacheSize;
        for (NSString *path in paths) {
            cacheSize += [self folderSizeAtPath:path];
        }
        
        cacheSize += [SDImageCache sharedImageCache].getSize/1024.0/1024.0;
        
        if (complete) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(cacheSize);
            });
        }
    });
}

/**
 删除路径数组所有文件，同时清除SDWebImageDisk
 */
+ (void)cacheCleanWithPaths:(NSArray<NSString *> *)paths complete:(CacheCleanCompleteBlock)complete{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSString *path in paths) {
            [self cacheCleanWithPath:path];
        }
        
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            if (complete) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    complete();
                });
            }
        }];
    });
}

@end
