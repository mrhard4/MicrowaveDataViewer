//
//  GraphsInfoViewController.m
//  MicrowaveAnalyzer
//
//  Created by mrhard on 10.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "GraphsInfoViewController.h"

@interface GraphsInfoViewController ()

@end

@implementation GraphsInfoViewController {
    NSDictionary *_characteristicsByColor;
    NSArray *_characteristicsNames;
}

- (id)initWithCharacteristicsByColor:(NSDictionary *)characteristicsByColor 
{
    self = [super init];
    if (self) {
        _characteristicsByColor = characteristicsByColor;
        _characteristicsNames = [_characteristicsByColor allKeys];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self
                                                                                 action:@selector(onDoneTap:)];
    }
    return self;
}

- (void)onDoneTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_characteristicsNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:@"cell"] ? : [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                                            reuseIdentifier:@"cell"];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = [_characteristicsNames[indexPath.row] title];
    cell.backgroundColor = _characteristicsByColor[_characteristicsNames[indexPath.row]];
}

@end
