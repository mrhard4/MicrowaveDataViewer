//
//  ComplexMatrix.h
//  MicrowaveAnalyzer
//
//  Created by mrhard on 19.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Matrix.h"
#import "ComplexNumber.h"

@interface ComplexMatrix : NSObject

- (id)initWithReMatrix:(Matrix *)reMatrix imMatrix:(Matrix *)imMatrix isReAndIm:(BOOL)isReAndIm;

- (ComplexNumber *)elementForColumn:(int)column row:(int)row;

@end
