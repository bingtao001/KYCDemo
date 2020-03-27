//
//  GXBKYCSDK.h
//  GXBKYCSDK
//
//  Created by huxingwang on 2019/1/2.
//  Copyright © 2019 huxingwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GXBSDKEnv){
    GXBSDKEnvDaily,  // 日常
    GXBSDKEnvPre,    // 预发
    GXBSDKEnvOnline  // 线上
};

typedef NS_ENUM(NSInteger, AuthStatus){
    AUTH_EXCEPTION = -2, //认证异常,网络不通或者环境问题
    AUTH_NOT = -1,       //未认证,用户主动取消
    AUTH_IN_AUDIT = 0,   //认证中
    AUTH_FAIL = 1,       //审核失败
    AUTH_PASS = 2        //审核通过
};


typedef void (^GXCompletedHandler)(AuthStatus auditState);

NS_ASSUME_NONNULL_BEGIN

@interface GXBKYCSDK : NSObject

+ (void)initialize:(GXBSDKEnv)env;

/**
 * 开始认证(一般性认证方式),启动一次认证流程
 *   @param token : 从服务端调获取Token获取(*请参考文档)
 *   @param  completed  认证结束后的结果回调
 *   @param  nav          所属的UINavigationController来管理
 */
+ (void)startWithToken:(NSString *)token completed:(GXCompletedHandler)completed withVC:(UINavigationController *)nav;

@end

NS_ASSUME_NONNULL_END
