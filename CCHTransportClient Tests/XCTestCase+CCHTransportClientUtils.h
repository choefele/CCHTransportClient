//
//  XCTestCase+CCHTransportClientUtils.h
//  Departures
//
//  Created by Claus Höfele on 15.07.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

@interface XCTestCase (CCHTransportClientUtils)

+ (NSData *)loadDataWithFileName:(NSString *)fileName ofType:(NSString *)type;
+ (NSDate *)dateFromGMTWithMonth:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute;

@end
