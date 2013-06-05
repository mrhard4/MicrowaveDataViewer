//
//  BaseTableViewController.m
//  MicrowaveAnalyzer
//
//  Created by mrhard on 01.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation BaseTableViewController {
    UITableViewStyle _tableViewStyle;
}

- (id)init {
    if ((self = [super init])) {
        _tableViewStyle = UITableViewStylePlain;
    }
    return self;
}

- (id)initWithTableViewStyle:(UITableViewStyle)style {
    if ((self = [super init])) {
        _tableViewStyle = style;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:_tableViewStyle];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
