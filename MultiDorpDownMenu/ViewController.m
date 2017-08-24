//
//  ViewController.m
//  ceshi
//
//  Created by KT on 2017/6/11.
//  Copyright © 2017年 KEENTEAM. All rights reserved.
//
#define KT_CLOSEFOOT   1
#define KT_ROWNUM         10
#define KTPATH @"MyTableCell"
#define SWIDTH [UIScreen mainScreen].bounds.size.width
#define SHEIGHT [UIScreen mainScreen].bounds.size.height
#define CellHeight 44
#import "UIView+Addition.h"
#import "ViewController.h"
#import "MyTableCell.h"
#import "MyModel.h"
@interface ViewController ()
{
    NSMutableArray *dataSource;
    NSMutableArray *nameMArr;
    NSMutableArray *idMArr;
    UITableView * _tableView;
    BOOL isOpenAll;
    UIView *headView;
    UIButton *selectAllCell;
    NSString *_rectificationQueryUrl;

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isOpenAll = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createDataSource];
    
}

- (void)createDataSource{
    
    dataSource = [NSMutableArray array];
    nameMArr = [NSMutableArray array];
    idMArr = [NSMutableArray array];
    
        
        
    NSArray * tempData = @[
  @{
    @"Id" : @1,
    @"Name" : @"姓氏",
    @"ListTeam" : @[@{
                        @"Id" : @1,
                        @"Name" : @"李",
                        @"UserList" : @"17214,17479",
                        @"ListUser" :             @[
                                @{
                                    @"UserId" : @17214,
                                    @"UserName" : @"李四",
                                    },
                                @{
                                    @"UserId" : @17479,
                                    @"UserName" : @"李四",
                                    }
                                ],
                        
                        },
                    @{
                        @"Id" : @2,
                        @"Name" : @"王",
                        @"UserList" : @"90716,16757",
                        @"ListUser" :             @[
                                @{
                                    @"UserId" : @90716,
                                    @"UserName" : @"王四",
                                    },
                                @{
                                    @"UserId" : @16757,
                                    @"UserName" : @"王四",
                                    }
                                ],
                        
                        },
                    @{
                        @"Id" : @3,
                        @"Name" : @"赵",
                        @"UserList" : @"90566,16318",
                        @"ListUser" :             @[
                                @{
                                    @"UserId" : @90566,
                                    @"UserName" : @"赵三",
                                    },
                                @{
                                    @"UserId" : @16318,
                                    @"UserName" : @"赵三",
                                    }
                                ],
                        
                        }
                    ],
    
    }];
    
        for (NSInteger i = 0; i < tempData.count; i ++) {
            NSArray *array = tempData[i][@"ListTeam"];
            MyModel *model11 = [[MyModel alloc]init];
            [model11 setValuesForKeysWithDictionary:tempData[i]];
            NSMutableArray *data2 = [NSMutableArray array];
            for (NSInteger j = 0; j< array.count; j ++) {
                NSArray *arr = array[j][@"ListUser"];
                MyModel *model1 = [[MyModel alloc]init];
                [model1 setValuesForKeysWithDictionary:array[j]];
                NSMutableArray *data1 = [NSMutableArray array];
                for (NSInteger t = 0; t < arr.count; t ++) {
                    MyModel *model = [[MyModel alloc]init];
                    [model setValuesForKeysWithDictionary:arr[t]];
                    [data1 addObject:model];
                }
                model1.ListUser = data1;
                [data2 addObject:model1];
            }
            model11.ListTeam = data2;
            [dataSource addObject:model11];
        }
        
        if (!_tableView) {
            [self createTableView];
        }
        else{
            [_tableView reloadData];
        }
        
}

- (void)createTableView{
    
    headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SWIDTH, CellHeight)];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, 375, 603) style:UITableViewStyleGrouped];
    
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _tableView.tableHeaderView = headView;
    UIView *tt = [self createHeadView];
    tt.backgroundColor = [UIColor whiteColor];
    [headView addSubview:tt];
    selectAllCell = [tt viewWithTag:2];
    [selectAllCell addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *openBtn = [tt viewWithTag:3];
    [openBtn addTarget:self action:@selector(openAll:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel = [tt viewWithTag:1];
    titleLabel.text = @"全部";
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.left = 5;
    
    _tableView.tableFooterView = [[UIView alloc]init];
    
}

- (void)openAll:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected==YES) {
        isOpenAll = NO;
    }else{
        isOpenAll = YES;
    }
    [_tableView reloadData];
}

/**一级目录*/
- (void)selectAllBtnClick:(UIButton *)sender{
    
    /**清空名字和用户ID数组数据*/
    [self removeNameIdAllObjects];
    sender.selected = !sender.selected;
    for (NSInteger i = 0; i < dataSource.count; i ++) {
        
        MyModel *model11 = dataSource[i];
        model11.isSelect = sender.selected;
        for (NSInteger j = 0; j< model11.ListTeam.count; j ++) {
            MyModel *model1 = model11.ListTeam[j];
            model1.isSelect = sender.selected;;
            for (NSInteger t = 0; t < model1.ListUser.count; t ++) {
                MyModel *model = model1.ListUser[t];
                model.isSelect = sender.selected;
                
                if (model.isSelect) {
                    
                    [nameMArr addObject:model.UserName];
                    [idMArr addObject:model.UserId];
                    
                }
            }
        }
    }
    
    [_tableView reloadData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (isOpenAll) {
        return dataSource.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    MyModel *model = dataSource[section];
    if (model.isOpen) {
        return model.ListTeam.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyTableCell * cell = (MyTableCell *)[tableView dequeueReusableCellWithIdentifier:KTPATH];
    if (!cell) {
        NSArray * nib = [[NSBundle mainBundle]loadNibNamed:KTPATH owner:[MyTableCell class] options:nil];
        cell =(MyTableCell *)[nib objectAtIndex:0];
    }
    
    MyModel *model = dataSource[indexPath.section];
    MyModel *dicModel = model.ListTeam[indexPath.row];
    cell.titleLabel.text = dicModel.Name;
    cell.titleLabel.textColor = [UIColor redColor];
    [cell.goodsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (dicModel.isOpen) {
        cell.goodsView.height = dicModel.ListUser.count*CellHeight;
        NSString *str = [NSString stringWithFormat:@"%ld%ld",indexPath.section+1,indexPath.row];
        for (NSInteger i = 0; i < dicModel.ListUser.count; i++) {
            MyModel *tempModel = dicModel.ListUser[i];
            UIView *view = [self createHeadView];
            view.top = i *CellHeight;
            view.tag = 500+i+[str integerValue]*100;
            
            UIButton *openBtn = [view viewWithTag:3];
            openBtn.hidden = YES;
            
            UIButton *sss = [view viewWithTag:2];
            [sss addTarget:self action:@selector(selectTempSingle:) forControlEvents:UIControlEventTouchUpInside];
            sss.selected = tempModel.isSelect;
            
            UILabel *titleLabel = [view viewWithTag:1];
            titleLabel.left = 30;
            titleLabel.text = tempModel.UserName;
            titleLabel.font = [UIFont systemFontOfSize:13];
            titleLabel.textColor = [UIColor blueColor];
            [cell.goodsView addSubview:view];
        }
    }else{
        cell.goodsView.height = 0;
    }
    
    cell.secondSelectBtn.selected = dicModel.isSelect;
    cell.isOpenSelectBtn.selected = dicModel.isOpen;
    [cell.secondSelectBtn addTarget:self action:@selector(CellHeadSelectClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.isOpenSelectBtn addTarget:self action:@selector(CellOpenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

/**三级目录*/
- (void)CellHeadSelectClick:(UIButton *)sender {
    
     /**清空名字和用户ID数组数据*/
    [self removeNameIdAllObjects];
    sender.selected = !sender.selected;
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    MyModel *model = dataSource[indexPath.section];
    MyModel *dicModel = model.ListTeam[indexPath.row];
    dicModel.isSelect = sender.selected;
    for (NSInteger i = 0; i < dicModel.ListUser.count; i ++) {
        MyModel *tempModel = dicModel.ListUser[i];
        tempModel.isSelect = sender.selected;
    }
    if (sender.selected==NO) {
        selectAllCell.selected = NO;
        model.isSelect = NO;
    }
    
    for (NSInteger i = 0; i< dataSource.count; i ++) {
        MyModel *tempModel1 = dataSource[i];
        
        for (NSInteger j = 0; j< tempModel1.ListTeam.count; j ++) {
            MyModel *tempModel2 = tempModel1.ListTeam[j];
            for (int x=0; x<tempModel2.ListUser.count; x++) {
                MyModel *tempModel3 =tempModel2.ListUser[x];
                if (tempModel3.isSelect) {
                    
                    [nameMArr addObject:tempModel3.UserName];
                    [idMArr addObject:tempModel3.UserId];
                    
                }
                
            }
        }
    }
    
    NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:indexPath.section];
    [_tableView reloadSections:indexset withRowAnimation:UITableViewRowAnimationFade];
    
}

- (void)CellOpenBtnClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    MyModel *model = dataSource[indexPath.section];
    MyModel *dicModel = model.ListTeam[indexPath.row];
    dicModel.isOpen = sender.selected;
    [_tableView reloadData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyModel *model = dataSource[indexPath.section];
    MyModel *dicModel = model.ListTeam[indexPath.row];
    if (dicModel.isOpen) {
        return 44 + dicModel.ListUser.count*44;
    }else{
        return 44;
    }
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *tt = [self createHeadView];
    tt.tag =  100+section;
    
    UIButton *openBtn = [tt viewWithTag:3];
    [openBtn addTarget:self action:@selector(openBtnTempAll:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *sss = [tt viewWithTag:2];
    [sss addTarget:self action:@selector(sectionSlectTap:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel = [tt viewWithTag:1];
    titleLabel.left = 15;
    titleLabel.font = [UIFont systemFontOfSize:15];
    MyModel *model = dataSource[section];
    titleLabel.text =model.Name;
    openBtn.selected = model.isOpen;
    sss.selected = model.isSelect;
    
    return tt;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return CellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

/**二级目录*/
- (void)sectionSlectTap:(UIButton *)sender{
    
    /**清空名字和用户ID数组数据*/
    [self removeNameIdAllObjects];
    sender.selected = !sender.selected;
    UIView *view = sender.superview;
    MyModel *model = dataSource[view.tag-100];
    model.isSelect = sender.selected;
    for (NSInteger j = 0; j< model.ListTeam.count; j ++) {
        MyModel *model1 = model.ListTeam[j];
        model1.isSelect = sender.selected;;
        for (NSInteger t = 0; t < model1.ListUser.count; t ++) {
            MyModel *model = model1.ListUser[t];
            model.isSelect = sender.selected;;
        }
    }
    if (sender.selected==NO) {
        selectAllCell.selected = NO;
    }
    
    for (NSInteger j = 0; j< dataSource.count; j ++) {
        MyModel *model = dataSource[j];
        for (int i= 0; i<model.ListTeam.count; i++) {
            MyModel *model1 =model.ListTeam[i];
            for (int j=0; j<model1.ListUser.count; j++) {
                MyModel *model2 =model1.ListUser[j];
                if (model2.isSelect) {
                    
                    [nameMArr addObject:model2.UserName];
                    [idMArr addObject:model2.UserId];
                    
                }
            }
        }
    }
    
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:view.tag-100];
    [_tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
    
}


- (void)openBtnTempAll:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    UIView *view = sender.superview;
    MyModel *model = dataSource[view.tag-100];
    model.isOpen = sender.selected;
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:view.tag-100];
    [_tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
    
}

/**四级目录*/
- (void)selectTempSingle:(UIButton *)sender{
    
    /**清空名字和用户ID数组数据*/
    [self removeNameIdAllObjects];
    sender.selected = !sender.selected;
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview.superview.superview;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    MyModel *model = dataSource[indexPath.section];
    MyModel *dicModel = model.ListTeam[indexPath.row];
    NSString *str = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section+1,(long)indexPath.row];
    NSInteger index = sender.superview.tag-500-[str integerValue]*100;
    
    MyModel *thhreeModel = dicModel.ListUser[index];
    thhreeModel.isSelect = sender.selected ;
    if (sender.selected==NO) {
        selectAllCell.selected = NO;
        model.isSelect = NO;
        dicModel.isSelect = NO;
    }
    
    for (NSInteger i = 0; i< dataSource.count; i ++) {
        MyModel *tempModel1 = dataSource[i];
        
        for (NSInteger j = 0; j< tempModel1.ListTeam.count; j ++) {
            MyModel *tempModel2 = tempModel1.ListTeam[j];
            
            for (NSInteger t = 0; t < tempModel2.ListUser.count; t ++) {
                MyModel *tempModel3 = tempModel2.ListUser[t];
                
                if (tempModel3.isSelect) {
                    
                    [nameMArr addObject:tempModel3.UserName];
                    [idMArr addObject:tempModel3.UserId];
                    
                }
            }
        }
    }
    
    NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:indexPath.section];
    [_tableView reloadSections:indexset withRowAnimation:UITableViewRowAnimationFade];
    
}

- (UIView *)createHeadView{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SWIDTH, CellHeight)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *titlae = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SWIDTH-10*2-70, view.height)];
    titlae.font = [UIFont systemFontOfSize:14];
    titlae.tag = 1;
    [view addSubview:titlae];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SWIDTH-70, view.height)];
    btn.tag = 3;
    [view addSubview:btn];
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(SWIDTH-70, 0, 60, view.height)];
    btn1.tag = 2;
    btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btn1 setImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    [view addSubview:btn1];
    UIView *label = [[UIView alloc]initWithFrame:CGRectMake(0, view.height-0.5, SWIDTH, 0.5)];
    [view addSubview:label];
    label.backgroundColor = [UIColor colorWithRed:0.7333 green:0.7294 blue:0.749 alpha:1.0];
    
    return view;
}

/**不显示选中颜色*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

 /**清空名字和用户ID数组数据*/
- (void)removeNameIdAllObjects{

    [nameMArr removeAllObjects];
    [idMArr removeAllObjects];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end



















