# HYCacheClean
缓存垃圾清理工具类

## 功能简介
1. 异步计算 指定文件目录组 下 所有文件 大小
2. 异步清理 指定文件目录组 下 所有文件
3. 计算和清理完成时支持完成回调
4. 默认加入清除SDWebImage DiskCache

## 预览图
![预览图](https://github.com/xtyHY/HYCacheClean/blob/master/HYCacheCleanDemo.gif)

## 使用方式
1. 计算 多个路径 下 所有文件 的 总大小
	
	```Objc
	NSArray *paths = @[@"路径1", @"路径2"];
	[HYCacheClean cacheSizeWithPaths:paths complete:^{
		//获取 路径数组 下 所有文件 总计大小 完成后回调
	}];
	```

2. 删除 多个路径 下 所有文件
	```Objc
	NSArray *paths = @[@"路径1", @"路径2"];
	[HYCacheClean cacheCleanWithPaths:paths complete:^{
		//删除 路径数组 下 所有文件 完成后回调
	}];
	```

## 注意
计算 时会加上SDWebImage Disk缓存的大小
删除 时会删除SDWebImage Disk缓存的文件


