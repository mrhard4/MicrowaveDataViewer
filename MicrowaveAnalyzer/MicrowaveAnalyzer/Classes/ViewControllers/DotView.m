//
//  DotView.m
//  MicrowaveAnalyzer
//
//  Created by mrhard on 11.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "DotView.h"

@implementation DotView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(ctx);
    [[UIColor whiteColor] setFill];
    
    CGContextFillEllipseInRect(ctx, self.bounds);
    
    CGContextSetLineWidth(ctx, 1.0f);
    [[UIColor blackColor] setStroke];
    CGContextAddEllipseInRect(ctx, CGRectInset(self.bounds, 1.f, 1.f));
    
    CGContextStrokePath(ctx);
    
    UIGraphicsPopContext();
}




@end
