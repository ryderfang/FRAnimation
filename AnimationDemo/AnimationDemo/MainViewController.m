//
//  MainViewController.m
//  AnimationDemo
//
//  Created by Ray Fong on 2016/12/23.
//  Copyright © 2016年 Ray Fong. All rights reserved.
//

#import "MainViewController.h"
#import "ClockViewController.h"
#import "LoginViewController.h"
#import "Masonry.h"

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

@end

@interface MyTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *title;

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

@end

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource>

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
    
    [self initDataSource];
}

- (void)initDataSource {
    self.itemList = @[[MyListItem initWithName:@"一个时针" withClass:[ClockViewController class]],
                      [MyListItem initWithName:@"一个登录界面" withClass:[LoginViewController class]]
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *viewController = [[((MyListItem *)self.itemList[indexPath.row]).object alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
