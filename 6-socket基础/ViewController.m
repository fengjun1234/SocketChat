//
//  ViewController.m
//  6-socket基础
//
//  Created by fengjun on 16/6/2.
//  Copyright © 2016年 fengjun. All rights reserved.
//

#import "ViewController.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>


@interface ViewController ()

@end

@implementation ViewController{
    int _clientId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self connect];
    
    [self send];
}
/**
 * 连接到服务器 baike.baidu.com
 */
- (void)connect {
    
    // 1. 建立 socket（准备 sim 卡）
    /*
     参数：
     
     1. domain：协议域，又称协议族（family）。常用的协议族有AF_INET，如AF_INET决定了要用ipv4地址
     2. type：指定Socket类型。常用的socket类型有SOCK_STREAM（TCP）、SOCK_DGRAM（UDP）
     3. protocol：指定协议。常用协议有IPPROTO_TCP、IPPROTO_UDP
     注意：
     1. type 和 protocol 不可以随意组合，如SOCK_STREAM不可以跟IPPROTO_UDP组合
     2. 当第三个参数为0时，会自动选择第二个参数类型对应的默认协议
     
     返回值：如果调用成功就返回新创建的套接字的描述符，失败返回 -1
     */
    int clientId = socket(AF_INET, SOCK_STREAM, 0);
    // 记录成员变量
    _clientId = clientId;
    
    if (clientId < 0) {
        NSLog(@"创建 socket 失败");
        
        return;
    }
    
    NSLog(@"%d", clientId);
    
    // 2. 连接到主机（拨打电话）
    /**
     参数一：套接字描述符
     参数二：指向数据结构sockaddr的指针，其中包括目的端口和IP地址
     参数三：参数二sockaddr的长度，可以通过sizeof（struct sockaddr）获得
     
     addr.sin_family = AF_INET;
     addr.sin_port=htons(PORT);
     addr.sin_addr.s_addr = inet_addr(SERVER_IP);
     
     返回值：成功则返回0，失败返回非0
     */
    struct sockaddr_in serverAddr;
    
    serverAddr.sin_family = AF_INET;
    serverAddr.sin_addr.s_addr = inet_addr("127.0.0.1");
    serverAddr.sin_port = htons(12345);
    
    int result = connect(clientId, (const struct sockaddr *)&serverAddr, sizeof(serverAddr));
    
    if (result != 0) {
        NSLog(@"连接失败");
        return;
    }
    NSLog(@"连接成功");
}

- (void)send{
    // 1. 发送数据
    /**
     参数
     1> 客户端socket
     2> 发送内容地址 void * == id
     3> 发送内容长度，字节数
     4> 发送方式标志，一般为0
     
     返回值
     如果成功，则返回发送的字节数，失败则返回SOCKET_ERROR
     
     一个中文对应 3 个字节！UTF8 编码！
     */
    const char *msg = "约吗？";
    ssize_t sendLen = send(_clientId, msg, strlen(msg), 0);
    
    NSLog(@"发送了 %ld 字节", sendLen);
    
    
    
    
    // 2. 接收数据
    /**
     参数
     1> 客户端socket
     2> 接收内容缓冲区地址
     3> 接收内容缓存区长度
     4> 接收方式，0表示阻塞，必须等待服务器返回数据，否则不继续往下执行
     
     返回值
     如果成功，则返回读入的字节数，失败则返回SOCKET_ERROR
     */
    // 接收数据的缓冲区，定义一个长度为 1024 的数组
    // C 语言中，数组名是指向数组第一个元素的指针
    uint8_t buffer[1024];
    ssize_t recvLen = recv(_clientId, buffer, sizeof(buffer), 0);
    
    NSLog(@"接收了 %ld 个字节", recvLen);
    
    // 从缓冲区取取出 recvLen 长度的数据
    NSData *data = [NSData dataWithBytes:buffer length:recvLen];
    // 将二进制数据转换成字符串
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", str);
    
    
}

@end
