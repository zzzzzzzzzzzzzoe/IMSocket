//
//  IMSocketManager.h
//  IMSoket
//
//  Created by mac on 2017/6/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMSocketManager : NSObject
+ (instancetype)share ;
- (void)connect;
- (void)sendMsg:(NSString *)msg;
- (void)disConnect;

@end
