//
//  LegendSettingsViewController.m
//  MicrowaveAnalyzer
//
//  Created by mrhard on 08.06.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "LegendSettingsViewController.h"

@interface LegendSettingsViewController ()

@end

@implementation LegendSettingsViewController {
    NSArray *_keys;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self
                                                                                 action:@selector(onCancelTap:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self
                                                                                 action:@selector(onDoneTap:)];
        
        _keys = @[@"minX", @"minY", @"maxX", @"maxY"];
    }
    return self;
}

- (void)onCancelTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onDoneTap:(id)sender {
    if ((self.minX >= self.maxX) || (self.minY >= self.maxY)) {
        [[[UIAlertView alloc] initWithTitle:@""
                                   message:@"Invalid values"
                                  delegate:nil
                         cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
        return;
    }
    
    if (self.willDismissCallback) {
        self.willDismissCallback();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    __weak UIViewController *this = self;
    [_keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UITextField *f = (UITextField *)[this.view viewWithTag:idx + 1];
        f.text = [formatter stringFromNumber:[self valueForKey:obj]];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSString *expression = @"^-?([0-9]+)?(\\,([0-9]+)?)?$";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                        options:0
                                                          range:NSMakeRange(0, [newString length])];
    if (numberOfMatches) {
        NSNumberFormatter *f = [NSNumberFormatter new];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        id value = [f numberFromString:newString];
        [self setValue:value ? : @(0) forKey:_keys[textField.tag - 1]];
    }
    return numberOfMatches != 0;
}

@end
