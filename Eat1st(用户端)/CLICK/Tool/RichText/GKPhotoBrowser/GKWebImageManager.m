//
//  GKWebImageManager.m
//  GKPhotoBrowser
//
//  Created by QuintGao on 2017/11/14.
//  Copyright © 2017年 QuintGao. All rights reserved.
//

#import "GKWebImageManager.h"

@implementation GKWebImageManager

- (id)loadImageWithURL:(NSURL *)url progress:(gkWebImageProgressBlock)progress completed:(gkWebImageCompletionBlock)completion {
    // 进度block

    
    SDImageLoaderProgressBlock progressBlock = ^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL) {
        !progress ? : progress(receivedSize, expectedSize);
    };
    
    // 图片加载完成block
    SDInternalCompletionBlock completionBlock = ^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        !completion ? : completion(image, data, error, cacheType, finished, imageURL);
    };
    
    return [[SDWebImageManager sharedManager] loadImageWithURL:url options:SDWebImageRetryFailed progress:progressBlock completed:completionBlock];
}

- (void)cancelImageRequestWithImageView:(UIImageView *)imageView {
    [imageView sd_cancelCurrentImageLoad];
}

- (UIImage *)imageFromMemoryForURL:(NSURL *)url {
    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
    return [[SDImageCache sharedImageCache] imageFromCacheForKey:key];
}

@end
