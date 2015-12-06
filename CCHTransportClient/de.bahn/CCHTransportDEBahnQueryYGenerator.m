//
//  CCHTransportDEBahnQueryYGenerator.m
//  CCHTransportClient
//
//  Copyright (C) 2015 Claus Höfele
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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
