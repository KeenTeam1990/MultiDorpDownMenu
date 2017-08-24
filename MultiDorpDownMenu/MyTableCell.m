//
//  MyTableCell.m
//  TabViewMultiselect
//
//  Created by KT on 2017/6/10.
//  Copyright © 2017年 zrgg. All rights reserved.
//

#import "MyTableCell.h"
#import "UIView+Addition.h"
@implementation MyTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _lineView.top = 42.5;
    _lineView.height = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
