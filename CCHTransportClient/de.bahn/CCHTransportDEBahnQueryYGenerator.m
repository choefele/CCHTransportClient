//
//  CCHTransportDEBahnQueryYGenerator.m
//  Departures
//
//  Created by Claus Höfele on 18.07.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import "CCHTransportDEBahnQueryYGenerator.h"

#import "CCHTransportDEBahnClientUtils.h"

static NSString * const API_URL_STATIONS_FORMAT = @"http://reiseauskunft.bahn.de/bin/query.exe/%@y?performLocating=2&tpl=stop2json&look_maxno=%tu&look_maxdist=%.f&look_stopclass=111111111111111111&look_x=%.f&look_y=%.f&look_nv=get_stopweight%%7Cyes";

@interface CCHTransportDEBahnQueryYGenerator()

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) CLLocationDistance maxDistance;
@property (nonatomic) NSUInteger maxNumberOfResults;

@end

@implementation CCHTransportDEBahnQueryYGenerator

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate maxDistance:(CLLocationDistance)maxDistance maxNumberOfResults:(NSUInteger)maxNumberOfResults
{
    self = [super init];
    if (self) {
        _coordinate = coordinate;
        _maxDistance = maxDistance;
        _maxNumberOfResults = maxNumberOfResults;
    }
    
    return self;
}

- (NSURLRequest *)generateRequest
{
    double x = self.coordinate.longitude * 1E6;
    double y = self.coordinate.latitude * 1E6;
    NSString *languageIdentifier = [CCHTransportDEBahnClientUtils languageIdentifier];
    NSString *urlString = [NSString stringWithFormat:API_URL_STATIONS_FORMAT, languageIdentifier, self.maxNumberOfResults, self.maxDistance, x, y];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];

    return request;
}

@end
