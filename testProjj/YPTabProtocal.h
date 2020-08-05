//
//  YPTabProtocal.h
//  testProjj
//
//  Created by 易家杨 on 2020/7/16.
//  Copyright © 2020 易家杨. All rights reserved.
//


@protocol YYMeCardCellProtocol <NSObject>

@required
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)showRedNew:(BOOL)show;
- (void)showRedPot:(BOOL)show;
- (void)showRedNumber:(NSInteger)number;
- (void)clearRedPoint;

@end
