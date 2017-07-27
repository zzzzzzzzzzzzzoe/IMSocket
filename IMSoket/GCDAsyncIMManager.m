//
//  GCDAsyncIMManager.m
//  IMSoket
//
//  Created by mac on 2017/6/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "GCDAsyncIMManager.h"

#import "GCDAsyncSocket.h" // for TCP

static  NSString * Khost = @"127.0.0.1";
static const uint16_t Kport = 6969;

@interface GCDAsyncIMManager ()<GCDAsyncSocketDelegate>{
    GCDAsyncSocket * gcdSocket;
}

@end

@implementation GCDAsyncIMManager
+ (instancetype)share{
    static dispatch_once_t onceToken;
    static GCDAsyncIMManager * instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
        [instance initSocket];
    });
    return instance;
    
}

- (void)initSocket{
    gcdSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
}

- (BOOL)connect{
    return [gcdSocket connectToHost:Khost onPort:Kport error:nil];
}

- (void)disConnect{
    [gcdSocket disconnect];
}

- (void)sentMsg:(NSString *)msg{
    [gcdSocket writeData:[msg dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:110];
}

//监听最新的消息
- (void)pullTheMsg
{
    //监听读数据的代理  -1永远监听，不超时，但是只收一次消息，
    //所以每次接受到消息还得调用一次
    [gcdSocket readDataWithTimeout:-1 tag:110];
    
}

- (void)checkPingPong{
    [gcdSocket readDataWithTimeout:3 tag:110];
}

//断开连接的时候调用
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err
{
    NSLog(@"断开连接,host:%@,port:%d",sock.localHost,sock.localPort);
    [self connect];
    //断线重连写在这...
    
}

//写成功的回调
- (void)socket:(GCDAsyncSocket*)sock didWriteDataWithTag:(long)tag
{
    //    NSLog(@"写的回调,tag:%ld",tag);
    [self checkPingPong];

}

//收到消息的回调
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    
    NSString *msg = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"收到消息：%@",msg);
    
    [self pullTheMsg];
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"连接成功,host:%@,port:%d",host,port);
    
    [self pullTheMsg];

    //心跳写在这...
}
@end
