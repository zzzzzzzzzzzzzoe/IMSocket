//
//  IMSocketManager.m
//  IMSoket
//
//  Created by mac on 2017/6/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "IMSocketManager.h"
#import <sys/types.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
static const char * server_ip="127.0.0.1";
static short server_port=6969;

@interface IMSocketManager()
@property (nonatomic,assign) int clientSocket;
@end
@implementation IMSocketManager
+ (instancetype)share{
    static IMSocketManager * instance = nil;
    static dispatch_once_t onceTaken;
    dispatch_once(&onceTaken, ^{
    
        instance = [[IMSocketManager alloc]init];
                [instance pullMsg];
    });
    return instance;
}

- (void)initScoket{
    if (_clientSocket != 0) {
        [self disConnect];
        _clientSocket = 0;
    }
    
    _clientSocket =  socket(AF_INET, SOCK_STREAM, 0);
    if (ConnectionToServer(_clientSocket, server_ip, server_port) == 0) {
        printf("shibai");
    }
    printf("ok");

}

int ConnectionToServer(int client_socket,const char * server_ip,unsigned short port){
    struct sockaddr_in sAddr ={0};
    sAddr.sin_len = sizeof(sAddr);
    sAddr.sin_family = AF_INET;
    inet_aton(server_ip, &sAddr.sin_addr);
    sAddr.sin_port = htons(port);
    if (connect(client_socket, (struct sockaddr *)&sAddr, sizeof(sAddr)) == 0) {
        return client_socket;
    }
    return 0;
    
}

#pragma mark - 新线程来接收消息

- (void)pullMsg
{
//    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(recieveAction) object:nil];
//    [thread start];
    
//    dispatch_queue_t queue = dispatch_queue_create("tk.bourne.testQueue", NULL);

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (1) {
            char recv_Message[1024] = {0};
            recv(self.clientSocket, recv_Message, sizeof(recv_Message), 0);
            printf("%s\n",recv_Message);
        }
    });
}

#pragma mark - 对外逻辑

- (void)connect
{
    [self initScoket];
}
- (void)disConnect
{
    //关闭连接
    close(self.clientSocket);
}

//发送消息
- (void)sendMsg:(NSString *)msg
{
    
    const char *send_Message = [msg UTF8String];
    send(self.clientSocket,send_Message,strlen(send_Message)+1,0);
    
}

//收取服务端发送的消息
- (void)recieveAction{
    while (1) {
        char recv_Message[1024] = {0};
        recv(self.clientSocket, recv_Message, sizeof(recv_Message), 0);
        printf("%s\n",recv_Message);
    }
}
@end
