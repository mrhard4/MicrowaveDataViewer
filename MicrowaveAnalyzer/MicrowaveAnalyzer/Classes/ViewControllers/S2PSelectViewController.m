//
//  S2PSelectViewController.m
//  MicrowaveAnalyzer
//
//  Created by mrhard on 01.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "S2PSelectViewController.h"
#import "S2PLoader.h"
#import "GraphViewController.h"

@interface S2PSelectViewController ()

@end

@implementation S2PSelectViewController {
    NSMutableArray *_listOfFiles;
    UILabel *_warningLabel;
}

- (id)init {
    if ((self = [super init])) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reload)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                               target:self
                                                                                               action:@selector(reload)];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reload {
    _listOfFiles = [[[S2PLoader sharedInstance] listOfFiles] mutableCopy];
    
#ifdef DEBUG
    if (![_listOfFiles count]) {
        _listOfFiles = [@[@"demoFile"] mutableCopy];
    }
#endif
    
    [self.tableView reloadData];
    [self refreshInterface];
}

- (UILabel *)warningLabel {
    if (!_warningLabel) {
        NSString *text = @"Пожалуйста, загрузите S2P файлы через iTunes";
        CGRect frame = self.view.frame;
        UIFont *font = [UIFont systemFontOfSize:18.f];
        _warningLabel = [[UILabel alloc] initWithFrame:frame];
        _warningLabel.text = text;
        _warningLabel.font = font;
        _warningLabel.numberOfLines = 0;
        _warningLabel.backgroundColor = [UIColor clearColor];
        _warningLabel.textColor = [UIColor blackColor];
        _warningLabel.textAlignment = NSTextAlignmentCenter;
        _warningLabel.shadowOffset = CGSizeMake(0.f, 1.f);
        _warningLabel.shadowColor = [UIColor colorWithWhite:.5f alpha:0.5f];
        _warningLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _warningLabel;
}

- (void)refreshInterface {
    if ([_listOfFiles count]) {
        if (_warningLabel) {
            [UIView animateWithDuration:0.3 animations:^{
                _warningLabel.alpha = 0.f;
            } completion:^(BOOL finished) {
                [_warningLabel removeFromSuperview];
                _warningLabel.alpha = 1.f;
            }];
        }
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    } else {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:[self warningLabel]];
        _warningLabel.alpha = 0.f;
        [UIView animateWithDuration:0.3 animations:^{
            _warningLabel.alpha = 1.f;
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reload];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_listOfFiles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"] ? : [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                                                             reuseIdentifier:@"cell"];
    cell.textLabel.text = _listOfFiles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *item = _listOfFiles[indexPath.row];
    if ([[S2PLoader sharedInstance] removeS2PFile:item]) {
        [_listOfFiles removeObject:item];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self refreshInterface];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        [self.navigationController pushViewController:[[GraphViewController alloc] initWithMeasurements:[[S2PLoader sharedInstance]
                                                                                                         loadFile:_listOfFiles[indexPath.row]]
                                                                                               fileName:_listOfFiles[indexPath.row]]
                                             animated:YES];
    }
    @catch (NSException *exception) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Invalid S2P file"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
    @finally {
        
    }
}

@end
