//
//  YPBlockDef.h
//  testProjj
//
//  Created by 易家杨 on 2020/8/4.
//  Copyright © 2020 易家杨. All rights reserved.
//

struct BNBlockDescriptor {
    unsigned long reserved;
    unsigned long size;
    void *rest[1];
};

struct BNBlock{
    void *isa;
    int flags;
    int reserved;
    void *invoke;
   
    struct BNBlockDescriptor *descriptor;
};


