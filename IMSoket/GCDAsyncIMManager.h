//
//  GCDAsyncIMManager.h
//  IMSoket
//
//  Created by mac on 2017/6/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDAsyncIMManager : NSObject
- (BOOL)connect;
- (void)disConnect;
- (void)sentMsg:(NSString *)msg;
+ (instancetype)share;
@end
