//
//  CCHTransportDEBahnQueryYGeneratorTests.m
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
#import "XCTestCase+CCHTransportClientUtils.h"

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface CCHTransportDEBahnQueryYGeneratorTests : XCTestCase

@end

@implementation CCHTransportDEBahnQueryYGeneratorTests

- (void)testDate
{
    CCHTransportDEBahnQueryYGenerator *generator = [[CCHTransportDEBahnQueryYGenerator alloc] initWithCoordinate:CLLocationCoordinate2DMake(12.3456, -87.654) maxDistance:0 maxNumberOfResults:0];
    NSURLRequest *request = [generator generateRequest];
    NSString *URLString = request.URL.query;
    XCTAssertTrue([URLString containsString:@"look_x=-87654000&look_y=12345600"]); // x = lon * 1E6
}

- (void)testMaxDistance
{
    CCHTransportDEBahnQueryYGenerator *generator = [[CCHTransportDEBahnQueryYGenerator alloc] initWithCoordinate:CLLocationCoordinate2DMake(0, 0) maxDistance:1234.7 maxNumberOfResults:123];
    NSURLRequest *request = [generator generateRequest];
    NSString *URLString = request.URL.query;
    XCTAssertTrue([URLString containsString:@"look_maxdist=1235"]); // rounded to closest value
}

- (void)testMaxNumberOfResults
{
    CCHTransportDEBahnQueryYGenerator *generator = [[CCHTransportDEBahnQueryYGenerator alloc] initWithCoordinate:CLLocationCoordinate2DMake(0, 0) maxDistance:0 maxNumberOfResults:123];
    NSURLRequest *request = [generator generateRequest];
    NSString *URLString = request.URL.query;
    XCTAssertTrue([URLString containsString:@"look_maxno=123"]);
}

@end
