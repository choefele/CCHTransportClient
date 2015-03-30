//
//  CCHTransportDEBahnQueryGenerator.m
//  Departures
//
//  Created by Claus Höfele on 23.07.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import "CCHTransportDEBahnQueryGenerator.h"

#import "CCHTransportDEBahnClientUtils.h"
#import "CCHTransportLocation.h"
#import "CCHTransportStation.h"

static NSString * const API_URL_TRIPS_FORMAT = @"http://reiseauskunft.bahn.de/bin/query.exe/%@?start=Suchen&REQ0JourneyStopsS0ID=%@&REQ0JourneyStopsZ0ID=%@&REQ0HafasSearchForw=1&REQ0JourneyDate=%@&REQ0JourneyTime=%@&REQ0JourneyProduct_prod_list_1=%@&h2g-direct=11&timesel=depart&clientType=ANDROID";

@interface CCHTransportDEBahnQueryGenerator()

@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) CCHTransportLocation *fromLocation;
@property (nonatomic, copy) CCHTransportLocation *toLocation;
@property (nonatomic) CCHTransportClientMode transportModeMask;

@end

@implementation CCHTransportDEBahnQueryGenerator

- (instancetype)initWithDate:(NSDate *)date fromLocation:(CCHTransportLocation *)fromLocation toLocation:(CCHTransportLocation *)toLocation transportModeMask:(CCHTransportClientMode)transportModeMask
{
    self = [super init];
    if (self) {
        _date = date;
        _fromLocation = fromLocation;
        _toLocation = toLocation;
        _transportModeMask = transportModeMask;
    }
    
    return self;
}

- (NSURLRequest *)generateRequest
{
    NSString *timeString = [self.class timeStringFromDate:self.date];
    NSString *dateString = [self.class dateStringFromDate:self.date];
    NSString *fromLocationString = [self.class stringFromLocation:self.fromLocation];
    NSString *toLocationString = [self.class stringFromLocation:self.toLocation];
    NSString *transportModeMaskString = [self.class stringFromTransportModeMask:self.transportModeMask];
    NSString *languageIdentifier = [CCHTransportDEBahnClientUtils languageIdentifier];
    NSString *urlString = [NSString stringWithFormat:API_URL_TRIPS_FORMAT, languageIdentifier, fromLocationString, toLocationString, dateString, timeString, transportModeMaskString];
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

+ (NSString *)stringFromLocation:(CCHTransportLocation *)location
{
    NSString *string;
    
    if ([location isKindOfClass:CCHTransportStation.class]) {
        CCHTransportStation *station = (CCHTransportStation *)location;
        string = [NSString stringWithFormat:@"A%%3D1@L%%3D%@", station.stationID];
    } else {
        double x = location.coordinate.longitude * 1E6;
        double y = location.coordinate.latitude * 1E6;
        string = [NSString stringWithFormat:@"A%%3D16@X%%3D%.f@Y%%3D%.f", x, y];
    }
    
    return string;
}

+ (NSString *)stringFromTransportModeMask:(CCHTransportClientMode)transportMode
{
    NSMutableString *string = [NSMutableString stringWithString:@"0000000000"];
    
    if ((transportMode & CCHTransportClientModeLongDistanceTrain) != 0) {
        [string replaceCharactersInRange:NSMakeRange(0, 2) withString:@"11"];
    }
    
    if ((transportMode & CCHTransportClientModeRegionalTrain) != 0) {
        [string replaceCharactersInRange:NSMakeRange(2, 2) withString:@"11"];
    }

    if ((transportMode & CCHTransportClientModeSuburbanTrain) != 0) {
        [string replaceCharactersInRange:NSMakeRange(4, 1) withString:@"1"];
    }

    if ((transportMode & CCHTransportClientModeBus) != 0) {
        [string replaceCharactersInRange:NSMakeRange(5, 1) withString:@"1"];
    }
    
    if ((transportMode & CCHTransportClientModeFerry) != 0) {
        [string replaceCharactersInRange:NSMakeRange(6, 1) withString:@"1"];
    }

    if ((transportMode & CCHTransportClientModeSubway) != 0) {
        [string replaceCharactersInRange:NSMakeRange(7, 1) withString:@"1"];
    }
    
    if ((transportMode & CCHTransportClientModeStreetCar) != 0) {
        [string replaceCharactersInRange:NSMakeRange(8, 1) withString:@"1"];
    }
    
    if ((transportMode & CCHTransportClientModeOnDemandService) != 0) {
        [string replaceCharactersInRange:NSMakeRange(9, 1) withString:@"1"];
    }

    return string;
}

@end
