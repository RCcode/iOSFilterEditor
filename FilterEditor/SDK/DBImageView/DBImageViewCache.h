//
//  DBImageViewCache.h
//  DBImageView
//
//  Created by iBo on 25/08/14.
//  Copyright (c) 2014 Daniele Bogo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DBImageViewCache : NSObject
@property (nonatomic, strong) NSString *localDirectory;

+ (instancetype) cache;
- (void) clearCache;
- (void) imageForURL:(NSURL *)imageURL found:(void(^)(UIImage* image))found notFound:(void(^)())notFound;
- (BOOL) saveImageFromName:(NSString *)imageName data:(NSData *)imageData;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
