//
//  MyModel.m
//  TabViewMultiselect
//
//  Created by KT on 2017/6/10.
//  Copyright © 2017年 zrgg. All rights reserved.
//

#import "MyModel.h"

@implementation MyModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    _isOpen = NO;
    _isSelect = NO;
}

@end
