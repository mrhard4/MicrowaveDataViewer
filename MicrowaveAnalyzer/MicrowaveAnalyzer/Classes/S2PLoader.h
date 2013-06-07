//
//  S2PLoader.h
//  MicrowaveAnalyzer
//
//  Created by mrhard on 01.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Measurements;

@interface S2PLoader : NSObject

+ (S2PLoader *)sharedInstance;

- (NSArray *)listOfFiles;
- (BOOL)removeS2PFile:(NSString *)fileName;
- (NSDictionary *)loadFile:(NSString *)fileName;
- (NSString *)fileContent:(NSString *)fileName;
- (void)saveFileWithContent:(NSString *)fileContent fileName:(NSString *)fileName;

@end
