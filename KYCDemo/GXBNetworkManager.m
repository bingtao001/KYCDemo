//
//  GXNetworkManager.m
//  HeHe
//
//  Created by huxingwang on 2019/1/7.
//  Copyright © 2019 huxingwang. All rights reserved.
//

#import "GXBNetworkManager.h"
#import "GXAFNetworking.h"
#import <CommonCrypto/CommonDigest.h>

static NSString *appID = @"gxba57f409ca1fe2dfa";
static NSString *appSecret = @"2d1844d9dd8540149e936b0125c4f8de";
@implementation GXBNetworkManager

+ (void)getGXBTokenWithName:(NSString *)name IdCard:(NSString *)idCard Success:(void (^)(id _Nonnull))success Fail:(void (^)(NSError * _Nonnull, id _Nonnull))fail {
    GXAFHTTPRequestOperationManager *manager = [GXAFHTTPRequestOperationManager manager];
    manager.requestSerializer = [GXAFJSONRequestSerializer serializer];
    manager.responseSerializer = [GXAFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain", nil];
    long long timestamp = [[NSDate date] timeIntervalSince1970] * 1000;
    NSInteger sequenNO = arc4random();
    NSString *signPre = [NSString stringWithFormat:@"%@%@kyc%lld%ld",appID, appSecret,timestamp, sequenNO];
    NSString *signedStr = [[self class] md5:signPre];
    NSDictionary *dic = @{
                          @"appid":appID,
                          @"appsecret":appSecret,
                          @"authItem":@"kyc",
                          @"sequenceNo":@(sequenNO),
                          @"timestamp":@(timestamp),
                          @"sign":signedStr,
                          @"phone":@"18258171452",
                          @"idcard":idCard,
                          @"name":name
                          };
    NSString *urlStr = @"http://test.gxb.io:8081/crawler/auth/v2/get_auth_token";
    GXAFJSONRequestSerializer *serializer = [GXAFJSONRequestSerializer serializer];
    [serializer setTimeoutInterval:5];
    NSMutableURLRequest *request = [serializer requestWithMethod:@"POST" URLString:urlStr parameters:dic error:nil];
    GXAFHTTPRequestOperation* requestOperation = [manager HTTPRequestOperationWithRequest:request success:^(GXAFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            if (success) {
                NSDictionary *dic = [responseObject objectForKey:@"data"];
                if (dic) {
                    success(dic);
                }
                else {
                    success(responseObject);
                }
            }
        }
    } failure:^(GXAFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error,operation.responseObject);
        }
    }];
    [manager.operationQueue addOperation:requestOperation];
}

+ (void)getKYCResultWithToken:(NSString *)token Success:(void (^)(id response))success Fail:(void (^)(NSError* error,id responseData))fail {
    GXAFHTTPRequestOperationManager *manager = [GXAFHTTPRequestOperationManager manager];
    manager.requestSerializer = [GXAFJSONRequestSerializer serializer];
    manager.responseSerializer = [GXAFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain", nil];
    long long timestamp = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *signPre = [NSString stringWithFormat:@"%@%@%lld",appID, appSecret,timestamp];
    NSString *signedStr = [[self class] md5:signPre];
    NSDictionary *dic = @{
                          @"appId":appID,
                          @"token":token,
                          @"timestamp":@(timestamp),
                          @"sign":signedStr
                          };
    NSString *urlStr = @"http://test.gxb.io:8081/crawler/auth/kyc/get_result";
    GXAFJSONRequestSerializer *serializer = [GXAFJSONRequestSerializer serializer];
    [serializer setTimeoutInterval:5];
    NSMutableURLRequest *request = [serializer requestWithMethod:@"POST" URLString:urlStr parameters:dic error:nil];
    GXAFHTTPRequestOperation* requestOperation = [manager HTTPRequestOperationWithRequest:request success:^(GXAFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            NSDictionary *resultDic = [responseObject objectForKey:@"data"];
            if (success) {
                success(resultDic);
            }
        }
    } failure:^(GXAFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error,operation.responseObject);
        }
    }];
    [manager.operationQueue addOperation:requestOperation];
}

+ (NSString *)md5:(NSString *)contentStr {
    const char *cStr = [contentStr UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
