//
//  Person.m
//  RunTimeDemo
//
//  Created by lidaojian on 2017/3/1.
//  Copyright © 2017年 lidaojian. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>

#define LOG_ClassAndFunctionName  NSLog(@"%@ %s", [self class], __func__)

@interface ForwardClass : NSObject

- (void)logUserName;

@end

@implementation ForwardClass

- (void)forwardLogUserName:(NSString *)userName;
{
    LOG_ClassAndFunctionName;
    NSLog(@"userName = %@",userName);
}

- (void)logUserName
{
    LOG_ClassAndFunctionName;
}

@end

@interface Person()

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, strong) ForwardClass *forwardClass;

@end

@implementation Person

void dynamicMethodIMP(id self, SEL _cmd)
{
    LOG_ClassAndFunctionName;
}

- (instancetype)initWithUserName:(NSString *)userName
{
    self = [super init];
    if (self) {
        _userName = [userName copy];
        _forwardClass = [[ForwardClass alloc] init];
    }
    return self;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    LOG_ClassAndFunctionName;
    if (sel == @selector(logUserName)) {
        /// 动态的为这个类去添加方法
        class_addMethod([self class], sel, (IMP)dynamicMethodIMP, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}


- (id)forwardingTargetForSelector:(SEL)aSelector
{
    LOG_ClassAndFunctionName;
    id fowarding = [super forwardingTargetForSelector:aSelector];
    if (!fowarding) {
        /// 进行拦截，让ForwardClass的示例进行执行aSelector方法
        fowarding = [[ForwardClass alloc] init];
    }
    return fowarding;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    LOG_ClassAndFunctionName;
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        /// 方法签名为nil，就生成一个forwardClass的方法签名并制定selector
        signature = [self.forwardClass methodSignatureForSelector:@selector(forwardLogUserName:)];
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    LOG_ClassAndFunctionName;
    /// 重定向方法
    [anInvocation setSelector:@selector(forwardLogUserName:)];
    /// 假如调用的函数需要参数的话，在这里调用anInvocation的setArgument:atIndex:方法来进行设置; 指定参数，以指针方式，并且第一个参数的起始index是2，因为index为1，2的分别是self和selector
    NSString *userName = self.userName;
    [anInvocation setArgument:&userName atIndex:2];
    /// ForwardClass 接受转发的消息
    [anInvocation invokeWithTarget:[[ForwardClass alloc] init]];
}

- (void)doesNotRecognizeSelector:(SEL)aSelector
{
    LOG_ClassAndFunctionName;
}

@end
