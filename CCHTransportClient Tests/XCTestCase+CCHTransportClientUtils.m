//
//  XCTestCase+CCHTransportClientUtils.m
//  Departures
//
//  Created by Claus Höfele on 15.07.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import "XCTestCase+CCHTransportClientUtils.h"

@implementation XCTestCase (CCHTransportClientUtils)

+ (NSData *)loadDataWithFileName:(NSString *)fileName ofType:(NSString *)type
{
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString *filePath = [bundle pathForResource:fileName ofType:type];
    
    return [NSData dataWithContentsOfFile:filePath];
}

+ (NSDate *)dateFromGMTWithMonth:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    dateComponents.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    dateComponents.year = 2014;
    dateComponents.month = month;
    dateComponents.day = day;
    dateComponents.hour = hour;
    dateComponents.minute = minute;
    dateComponents.second = 0;
    
    return dateComponents.date;
}

@end
