//
//  VisualSettingsViewController.m
//  MicrowaveAnalyzer
//
//  Created by mrhard on 08.06.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "VisualSettingsViewController.h"
#import "BaseCharacteristic.h"
#import "BaseCell.h"
#import "ColorCell.h"
#import "WidthCell.h"

enum {
    VisualSettingsViewControllerCellColor = 0,
    VisualSettingsViewControllerCellLineWidth,
    VisualSettingsViewControllerCellsCount
};

@interface VisualSettingsViewController ()

@end

@implementation VisualSettingsViewController {
    BaseCharacteristic *_characteristic;
    
    NSArray *_cellsClasses;
}

- (id)initWithCharacteristic:(BaseCharacteristic *)characteristic
{
    self = [super initWithTableViewStyle:UITableViewStyleGrouped];
    if (self) {
        _characteristic = characteristic;
        
        self.navigationItem.title = @"Visual settings";
        
        _cellsClasses = @[@"ColorCell", @"WidthCell"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    _characteristic.lineColor = ((ColorCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:VisualSettingsViewControllerCellColor inSection:0]]).color;
    _characteristic.lineWidth = ((WidthCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:VisualSettingsViewControllerCellLineWidth inSection:0]]).width;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return VisualSettingsViewControllerCellsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseId = [NSString stringWithFormat:@"%d", indexPath.row];
    return [tableView dequeueReusableCellWithIdentifier:reuseId] ? : [NSClassFromString(_cellsClasses[indexPath.row]) cellWithReuseIdentifier:reuseId];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case VisualSettingsViewControllerCellColor:
            ((ColorCell *)cell).color = _characteristic.lineColor;
            break;
            
        case VisualSettingsViewControllerCellLineWidth:
            ((WidthCell *)cell).width = _characteristic.lineWidth;
            break;
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [NSClassFromString(_cellsClasses[indexPath.row]) cellHeight];
}

@end
