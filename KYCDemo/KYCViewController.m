//
//  KYCViewController.m
//  HeHe
//
//  Created by huxingwang on 2019/1/2.
//  Copyright © 2019 huxingwang. All rights reserved.
//

#import "KYCViewController.h"
#import <GXBKYCSDK/GXBKYCSDK.h>
#import "GXBNetworkManager.h"

@interface KYCViewController ()

@property (nonatomic ,strong) NSString *GXBToken;
@property (weak, nonatomic) IBOutlet UITextField *nameTextView;
@property (weak, nonatomic) IBOutlet UITextField *idCardTextView;

@end

@implementation KYCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)clickStartBtn:(UIButton *)sender {
    if (self.nameTextView.text.length == 0 && self.idCardTextView.text.length == 0) {
        [self aletErrorWithContent:@"请填写信息"];
        return;
    }
    [GXBNetworkManager getGXBTokenWithName:self.nameTextView.text IdCard:self.idCardTextView.text Success:^(id  _Nonnull response) {
        self.GXBToken = [response objectForKey:@"token"];
        if (self.GXBToken) {
            [GXBKYCSDK startWithToken:self.GXBToken completed:^(AuthStatus auditState) {
                if (auditState == AUTH_PASS) {
                    [GXBNetworkManager getKYCResultWithToken:self.GXBToken Success:^(id  _Nonnull response) {
                        [self aletErrorWithContent:[NSString stringWithFormat:@"%@", response]];
                    } Fail:^(NSError * _Nonnull error, id  _Nonnull responseData) {}];
                }
            } withVC:self.navigationController];

        }
        else {
            [self aletErrorWithContent:[response objectForKey:@"retMsg"]];
        }
    } Fail:^(NSError * _Nonnull error, id  _Nonnull responseData) {
        NSDictionary *errDic = responseData;
        NSString *msg = [errDic objectForKey:@"retMsg"]?:@"unknown error";
        [self aletErrorWithContent:msg];
    }];

}

- (void)aletErrorWithContent:(NSString *)content {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:content message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.nameTextView resignFirstResponder];
    [self.idCardTextView resignFirstResponder];
}

@end
