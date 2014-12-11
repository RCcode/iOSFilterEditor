//
//  DBImageRequest.h
//  DBImageView
//
//  Created by iBo on 25/08/14.
//  Copyright (c) 2014 Daniele Bogo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^DBRequestSuccessHandler)(UIImage *image, NSHTTPURLResponse *response);
typedef void (^DBRequestErrorHandler)(NSError *error);

@interface DBImageRequest : NSObject

- (id) initWithURLRequest:(NSURLRequest*)request;
- (void) downloadImageWithSuccess:(DBRequestSuccessHandler)success error:(DBRequestErrorHandler)error;
- (void) cancel;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
