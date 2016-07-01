//
//  Cokey.m
//  demo_msgSend
//
//  Created by doudou on 16/7/1.
//  Copyright © 2016年 doudou. All rights reserved.
//

#import "Cokey.h"
#import "RealCokey.h"
#import <objc/runtime.h>
@interface Cokey()
@property (nonatomic, strong) RealCokey *target;
@end
@implementation Cokey

+ (void)initialize {
    NSLog(@"I'm initialize---1");
}
- (instancetype)init{
    self = [super init];
    if (self) {
        NSLog(@"I'm init---3 (2.alloc 忽略)");
        _target = [RealCokey new];
        [self performSelector:@selector(notFoundMethod) withObject:nil];
        
    }
    return  self;
}

id dynamicMethodIMP(id self, SEL _cmd)
{
    NSLog(@"讲真，我是动态的，%s",__FUNCTION__);
    return @"1";
}

+ (BOOL)resolveInstanceMethod: (SEL)sel __OSX_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_2_0) {
    
    NSLog(@"我正在解析消息---4 ");
    class_addMethod(self.class, sel, (IMP)dynamicMethodIMP, "@@:");
    BOOL result = [super resolveInstanceMethod:sel];
    result = YES;
    return result;
}

- (id)forwardingTargetForSelector:(SEL)aSelector __OSX_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_2_0){
     NSLog(@"我正在转发消息---5 ");
    
    id result = [super forwardingTargetForSelector:aSelector];
    result = self.target;
    return result;
}

- ( NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    
    NSLog(@"羞涩，好像木有方法签名---6 ");
    id result = [super methodSignatureForSelector:aSelector];
    NSMethodSignature *sig = [NSMethodSignature signatureWithObjCTypes:"v@:"];
    result = sig;
    return result;
}
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    [super forwardInvocation:anInvocation];
    [self.target forwardInvocation:anInvocation];
}
- (void)doesNotRecognizeSelector:(SEL)aSelector {
    NSLog(@"买噶，我已经准备好走向crash--- 7");
    [super doesNotRecognizeSelector:aSelector];
   }
@end
