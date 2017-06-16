//
//  MainViewController.m
//  AnimationDemo
//
//  Created by Ray Fong on 2016/12/23.
//  Copyright © 2016年 Ray Fong. All rights reserved.
//

#import "MainViewController.h"
#import "AnimationDemo-Swift.h"
#import "ClockViewController.h"
#import "LoginViewController.h"
#import "IconFontViewController.h"
#import "Masonry.h"
#import "UIDefs.h"
#import <StoreKit/StoreKit.h>
#import "objc/runtime.h"

#define FRTableCellIdentifier @"FRTableCellIdentifier"

@interface MyListItem : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) id object;

@end

@implementation MyListItem

+ (instancetype)initWithName:(NSString *)name withClass:(Class)type {
    MyListItem *item = [[MyListItem alloc] init];
    item.name = name;
    item.object = type;
    return item;
}

+ (void)fuckClass {
    NSLog(@"shit");
}

@end

@interface MyTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIView *shadowView;

@end

@implementation MyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.title];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(12);
            make.centerY.equalTo(self.contentView);
        }];
        [self.contentView addSubview:self.shadowView];
        [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:14];
        _title.textColor = [UIColor darkTextColor];
    }
    return _title;
}

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = [UIColor blackColor];
        _shadowView.alpha = 0.04;
        _shadowView.hidden = YES;
    }
    return _shadowView;
}

@end

@interface MainViewController () <
    UITableViewDelegate,
    UITableViewDataSource,
    SKStoreProductViewControllerDelegate
>

@property (nonatomic, strong) UITableView *mainTable;
@property (nonatomic, strong) NSArray *itemList;

@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.mainTable];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationItem.title = @"动画学习";

    // Check Fonts
    for (NSString* family in [UIFont familyNames]) {
        NSLog(@"%@", family);
        for (NSString* name in [UIFont fontNamesForFamilyName: family]) {
            NSLog(@"  %@", name);
        }
    }

    [self initDataSource];
}

- (void)initDataSource {
    self.itemList = @[[MyListItem initWithName:@"一个时针" withClass:[ClockViewController class]],
                      [MyListItem initWithName:@"一个登录界面" withClass:[LoginViewController class]],
                      [MyListItem initWithName:@"雪花粒子动画" withClass:[EmitterSnowController class]],
                      [MyListItem initWithName:@"IconFont测试" withClass:[IconFontViewController class]],
                      [MyListItem initWithName:@"App内打开AppStore" withClass:[UIViewController class]]
                     ];
}

- (UITableView *)mainTable {
    if (!_mainTable) {
        _mainTable = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _mainTable.backgroundColor = [UIColor whiteColor];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        [_mainTable registerClass:[MyTableViewCell class] forCellReuseIdentifier:FRTableCellIdentifier];
    }
    return _mainTable;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FRTableCellIdentifier];
    [cell.title setText:((MyListItem *)self.itemList[indexPath.row]).name];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.shadowView.alpha = 0;
    cell.shadowView.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        cell.shadowView.alpha = 0.04;
    }];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.shadowView.alpha = 0.04;
    [UIView animateWithDuration:0.2 animations:^{
        cell.shadowView.alpha = 0;
    } completion:^(BOOL finished) {
        cell.shadowView.hidden = YES;
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.itemList.count - 1) {
        SKStoreProductViewController *storeVC = [[SKStoreProductViewController alloc] init];
        storeVC.delegate = self;
        [storeVC loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier: @"1108397779"}
                           completionBlock:^(BOOL result, NSError * _Nullable error) {
                               if (result && !error) {
                                   // nothing
                               }
        }];
        [self.navigationController presentViewController:storeVC animated:YES completion:nil];
    } else {
        UIViewController *viewController = [[((MyListItem *)self.itemList[indexPath.row]).object alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - SKStoreProductViewControllerDelegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
