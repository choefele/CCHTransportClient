//
//  CCHTransportDEBahnAjaxGetstopGenerator.m
//  Departures
//
//  Created by Claus Höfele on 20.07.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import "CCHTransportDEBahnAjaxGetstopGenerator.h"

#import "CCHTransportDEBahnClientUtils.h"

static NSString * const API_URL_STATIONS_FORMAT = @"http://reiseauskunft.bahn.de/bin/ajax-getstop.exe/%@?getstop=1&REQ0JourneyStopsB=%tu&REQ0JourneyStopsS0A=1&REQ0JourneyStopsS0G=%@?&js=true";

@interface CCHTransportDEBahnAjaxGetstopGenerator()

@property (nonatomic, copy) NSString *searchString;
@property (nonatomic) NSUInteger maxNumberOfResults;

@end

@implementation CCHTransportDEBahnAjaxGetstopGenerator

- (instancetype)initWithSearchString:(NSString *)searchString maxNumberOfResults:(NSUInteger)maxNumberOfResults
{
    self = [super init];
    if (self) {
        _searchString = searchString;
        _maxNumberOfResults = maxNumberOfResults;
    }
    
    return self;
}

- (NSURLRequest *)generateRequest
{
    NSString *languageIdentifier = [CCHTransportDEBahnClientUtils languageIdentifier];
    NSString *encodedSearchString = [CCHTransportDEBahnClientUtils encodeQueryValue:self.searchString withEncoding:NSISOLatin1StringEncoding];
    NSString *urlString = [NSString stringWithFormat:API_URL_STATIONS_FORMAT, languageIdentifier, self.maxNumberOfResults, encodedSearchString];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    return request;
}

@end
