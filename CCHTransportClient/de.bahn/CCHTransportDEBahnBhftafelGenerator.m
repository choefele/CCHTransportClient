//
//  CCHTransportDEBahnBhftafelGenerator.m
//  Departures
//
//  Created by Claus Höfele on 12.07.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import "CCHTransportDEBahnBhftafelGenerator.h"

#import "CCHTransportDEBahnClientUtils.h"

static NSString * const API_URL_DEPARTURES_FORMAT = @"http://reiseauskunft.bahn.de/bin/stboard.exe/%@?productsFilter=111111111111111111&boardType=dep&disableEquivs=no&maxJourneys=%tu&start=yes&L=vs_java3&input=%@&time=%@&date=%@";

@interface CCHTransportDEBahnBhftafelGenerator()

@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSString *stationID;
@property (nonatomic) NSUInteger maxNumberOfResults;

@end

@implementation CCHTransportDEBahnBhftafelGenerator

- (instancetype)initWithDate:(NSDate *)date stationID:(NSString *)stationID maxNumberOfResults:(NSUInteger)maxNumberOfResults
{
    self = [super init];
    if (self) {
        _date = date;
        _stationID = stationID;
        _maxNumberOfResults = maxNumberOfResults;
    }
    
    return self;
}

- (NSURLRequest *)generateRequest
{
    NSString *timeString = [self.class timeStringFromDate:self.date];
    NSString *dateString = [self.class dateStringFromDate:self.date];
    NSString *languageIdentifier = [CCHTransportDEBahnClientUtils languageIdentifier];
    NSString *urlString = [NSString stringWithFormat:API_URL_DEPARTURES_FORMAT, languageIdentifier, self.maxNumberOfResults, self.stationID, timeString, dateString];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    return request;
}

+ (NSString *)timeStringFromDate:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"HH:mm";
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"CET"];
    });

    return [dateFormatter stringFromDate:date];
}

+ (NSString *)dateStringFromDate:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"dd.MM.yy";
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"CET"];
    });
    
    return [dateFormatter stringFromDate:date];
}

@end
