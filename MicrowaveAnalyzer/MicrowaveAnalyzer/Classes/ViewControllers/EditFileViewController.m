//
//  EditFileViewController.m
//  MicrowaveAnalyzer
//
//  Created by mrhard on 05.06.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "EditFileViewController.h"
#import "S2PLoader.h"
#import <BlocksKit/UIAlertView+BlocksKit.h>

@interface EditFileViewController ()

@property (nonatomic, weak) IBOutlet UITextView *textView;

@end

@implementation EditFileViewController {
    NSString *_fileName;
}

- (id)initWithFileName:(NSString *)fileName
{
    self = [super init];
    if (self) {
        _fileName = fileName;
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                              target:self
                                                                                              action:@selector(onCancelButtonTap:)];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                              target:self
                                                                                              action:@selector(onSaveButtonTap:)];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    return self;
}

- (void)onCancelButtonTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onSaveButtonTap:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Enter file name"];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alert textFieldAtIndex:0].text = _fileName;
    
    __weak id weakAlert = alert;
    __weak id this = self;
    
    [alert setCancelButtonWithTitle:@"Cancel" handler:nil];
    [alert addButtonWithTitle:@"Save" handler:^{
        [[S2PLoader sharedInstance] saveFileWithContent:self.textView.text fileName:[weakAlert textFieldAtIndex:0].text];
        
        [this dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert setShouldEnableFirstOtherButtonBlock:^BOOL(UIAlertView *alert) {
        return [alert textFieldAtIndex:0].text.length > 0;
    }];
    
    [alert show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView.text = [[S2PLoader sharedInstance] fileContent:_fileName];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

@end
