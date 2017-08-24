//
//  MyModel.h
//  TabViewMultiselect
//
//  Created by KT on 2017/6/10.
//  Copyright © 2017年 zrgg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyModel : NSObject

@property (nonatomic , copy)NSString *Name;
@property (nonatomic , copy)NSString *UserName;
@property (nonatomic , copy)NSString *UserId;
@property (nonatomic , retain)NSArray *ListTeam;
@property (nonatomic , retain)NSArray *ListUser;
@property (nonatomic , assign)BOOL isOpen;
@property (nonatomic , assign)BOOL isSelect;

@end
