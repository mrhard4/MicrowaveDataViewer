//
//  BaseTableViewController.h
//  MicrowaveAnalyzer
//
//  Created by mrhard on 01.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseTableViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong, readonly) UITableView *tableView;

- (id)initWithTableViewStyle:(UITableViewStyle)style;

@end
