//
//  GraphsInfoViewController.m
//  MicrowaveAnalyzer
//
//  Created by mrhard on 10.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "GraphsInfoViewController.h"
#import "BaseCharacteristic.h"
#import "GraphDataSource.h"
#import "VisualSettingsViewController.h"

@interface GraphsInfoViewController ()

@end

@implementation GraphsInfoViewController {
    NSMutableArray *_characteristics;
    NSMutableArray *_source;
    BOOL _SmithMode;
}

- (id)initWithCharacteristics:(NSMutableArray *)characteristics SmithMode:(BOOL)SmithMode
{
    self = [super init];
    if (self) {
        _characteristics = characteristics;
        _SmithMode = SmithMode;
        
        _source = SmithMode ? [[GraphDataSource smithCharacteristicsInArray:_characteristics] mutableCopy] : _characteristics;
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self
                                                                                 action:@selector(onDoneTap:)];
    }
    return self;
}

- (void)onDoneTap:(id)sender {
    if (self.willDismissCallback) {
        self.willDismissCallback();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_source count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:@"cell"] ? : [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                                            reuseIdentifier:@"cell"];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = _SmithMode ? [_source[indexPath.row] SmithDescription] : [_source[indexPath.row] fullTitle];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = _source[indexPath.row];
    [_characteristics removeObject:object];
    [_source removeObject:object];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:[[VisualSettingsViewController alloc] initWithCharacteristic:_source[indexPath.row]] animated:YES];
}

@end
