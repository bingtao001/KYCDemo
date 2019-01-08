//
//  GXNetworkManager.h
//  HeHe
//
//  Created by huxingwang on 2019/1/7.
//  Copyright © 2019 huxingwang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GXBNetworkManager : NSObject

+ (void)getGXBTokenWithName:(NSString *)name IdCard:(NSString *)idCard Success:(void (^)(id _Nonnull))success Fail:(void (^)(NSError * _Nonnull, id _Nonnull))fail;

+ (void)getKYCResultWithToken:(NSString *)token Success:(void (^)(id response))success Fail:(void (^)(NSError* error,id responseData))fail;
@end

NS_ASSUME_NONNULL_END
