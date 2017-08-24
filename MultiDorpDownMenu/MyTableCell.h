//
//  MyTableCell.h
//  TabViewMultiselect
//
//  Created by KT on 2017/6/10.
//  Copyright © 2017年 zrgg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *goodsView;
@property (weak, nonatomic) IBOutlet UIButton *secondSelectBtn;
@property (nonatomic , assign)BOOL isGoodSelect;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *isOpenSelectBtn;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
