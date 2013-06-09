//
//  ColorCell.m
//  MicrowaveAnalyzer
//
//  Created by mrhard on 08.06.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "ColorCell.h"
#import <WEPopover/WEPopoverController.h>

@interface PopoverController : WEPopoverController

- (UIView *)keyView;

@end

@implementation PopoverController

- (UIView *)keyView {
	UIWindow *w = [[UIApplication sharedApplication] keyWindow];
	if (w.subviews.count > 0) {
		return [w.subviews lastObject];
	} else {
		return w;
	}
}

@end

@implementation ColorCell {
    IBOutlet UIButton *_colorPreviewButton;
    WEPopoverController *_wePopoverController;
}

- (void)setColor:(UIColor *)color {
    _colorPreviewButton.backgroundColor = color;
    _color = color;
}

- (IBAction)onColorButtonTap:(id)sender {
    if (!_wePopoverController) {
        ColorViewController *colorVC = [[ColorViewController alloc] init];
        colorVC.delegate = self;
        
        _wePopoverController = [[PopoverController alloc] initWithContentViewController:colorVC];
        
    }
    [_wePopoverController presentPopoverFromRect:_colorPreviewButton.frame
                                          inView:self
                        permittedArrowDirections:(UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown)
                                        animated:YES];
}

-(void)colorPopoverControllerDidSelectColor:(NSString *)hexColor{
    self.color = [GzColors colorFromHex:hexColor];
    
    //[self.view setNeedsDisplay];
    [_wePopoverController dismissPopoverAnimated:YES];
    //self.wePopoverController = nil;
}

@end
