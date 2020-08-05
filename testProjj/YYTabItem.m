//
//  YYTabItem.m
//  testProjj
//
//  Created by 易家杨 on 2020/7/16.
//  Copyright © 2020 易家杨. All rights reserved.
//

#import "YYTabItem.h"

@implementation YYTabItem


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self viewInit];
    }
    return self;
}

- (void)viewInit{
    
    self.testBlock(@"abc");
    
    
}
@end
