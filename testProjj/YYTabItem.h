//
//  YYTabItem.h
//  testProjj
//
//  Created by 易家杨 on 2020/7/16.
//  Copyright © 2020 易家杨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YPTabProtocal.h"
NS_ASSUME_NONNULL_BEGIN

@interface YYTabItem : NSObject <YYMeCardCellProtocol>
@property(nonatomic,copy) void(^testBlock)(NSString *testStr);
@end

NS_ASSUME_NONNULL_END
