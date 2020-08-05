//
//  ViewController.m
//  testProjj
//
//  Created by 易家杨 on 2020/7/7.
//  Copyright © 2020 易家杨. All rights reserved.
//

#import "ViewController.h"
#import <objc/message.h>
#import "YYTabItem.h"
#import "YPBlockDef.h"
#define MJRefreshMsgSend(...) ((void (*)(void *, SEL))objc_msgSend)(__VA_ARGS__)
#define MJRefreshMsgTarget(target) (__bridge void *)(target)

//#define Cat_objcMsgSend(...) ((void *)(void *,SEL ))objc_msgSend(__VA_ARGS__)


NSString *testMethodWithItem(NSUInteger index){
    
    NSString *a = @"a";
    NSString *b = @"b";
    NSString *c = @"c";
    NSString *d = @"d";
    NSArray *tmpArr = @[a,b,c,d];
    return tmpArr[index];
}


enum {
    BLOCK_DEALLOCATING =      (0x0001),  // deallocating   正在销毁
    BLOCK_REFCOUNT_MASK =     (0xfffe),  // refcount_mask 引用计数mask
    BLOCK_NEEDS_FREE =        (1 << 24), // 需要释放,则证明block在堆上
    BLOCK_HAS_COPY_DISPOSE =  (1 << 25), // 是copy修饰的
    BLOCK_HAS_CTOR =          (1 << 26), // compiler: helpers have C++ code
    BLOCK_IS_GC =             (1 << 27), // 是自动管理内存
    BLOCK_IS_GLOBAL =         (1 << 28), // 是全局block
    BLOCK_USE_STRET =         (1 << 29), // compiler: undefined if !BLOCK_HAS_SIGNATURE
    BLOCK_HAS_SIGNATURE  =    (1 << 30), // 有方法签名
    BLOCK_HAS_EXTENDED_LAYOUT=(1 << 31)  // 布局
};

struct YPBlock {
    void * isa;
    int Flags;
    uint32_t reserved;
    void *fp;
    struct ypBlock_descriptor_1 *descriptor;
};


struct ypBlock_descriptor_1 {
    uintptr_t reserved;
    uintptr_t block_size;
};

struct ypBlock_descriptor_2 {
    void (* copy)(void *dist,const void *src);
    void (* dispose)(const void *);
};

struct ypBlock_descriptor_3 {
    const char signature;
    const char *layout;
};

NSMutableDictionary *blockSignature(id blockObj){
    if (!blockObj) {
        return NULL;
    }
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    
    struct YPBlock *block = (__bridge struct YPBlock *)(blockObj);
    [dicM setValue:[NSString stringWithFormat:@"%d",block->Flags] forKey:@"Flags"];
    struct ypBlock_descriptor_1 *descriptor = block->descriptor;
    [dicM setValue:[NSString stringWithFormat:@"%lu",descriptor->block_size] forKey:@"block_size"];

    void * _pointer = descriptor;
    _pointer += 2 * sizeof(uintptr_t);
    if (block->Flags & BLOCK_HAS_COPY_DISPOSE) {
        
        [dicM setValue:[NSString stringWithFormat:@"%@",_pointer + sizeof(uintptr_t)] forKey:@"copy"];
        [dicM setValue:[NSString stringWithFormat:@"%@",_pointer + 2*sizeof(uintptr_t)] forKey:@"dispose"];

         _pointer += 2 * sizeof(uintptr_t);
    }
    
    if (block->Flags & BLOCK_HAS_SIGNATURE) {
        const char *signature = (*(const char **)_pointer);
        const char *layout = (*(const char **)_pointer + sizeof(uintptr_t));

        [dicM setValue:[NSString stringWithUTF8String:signature] forKey:@"signature"];
        [dicM setValue:[NSString stringWithUTF8String:layout] forKey:@"layout"];
    }
    
    return dicM;
}


static const  char *BlockSig(id blockObj)
{
    struct BNBlock *block = (__bridge struct BNBlock *)(blockObj);
    struct BNBlockDescriptor *descriptor = block->descriptor;
    
    int copyDisposeFlag = 1 << 25;
    int signature = 1 << 30;
    
    if (!(block->flags & signature)) {
        return NULL;
    }
    
    int index = 0;
    if (block->flags & copyDisposeFlag) {//
        index += 2;
    }
    
    return (char *)(descriptor->rest[index]);
}




@interface ViewController()
@property(nonatomic,copy) void(^testBlock)(NSString *testStr);

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    static const NSInteger a = 6;
    self.testBlock = ^(NSString * _Nonnull testStr) {
        NSLog(@"XXXXXXXXXXXXXXXXXX-%@-%zd",testStr,a);
    };
        
    
    
   NSMutableDictionary *dicM = blockSignature(self.testBlock);//方法签名 "v16@?0@\"NSString\"8"
    
    [dicM enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"-key:%@ value:%@",key,obj);
    }];
    
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.testBlock) {
        self.testBlock(@"___这是一个testBlock___");
    }
    
}

@end
