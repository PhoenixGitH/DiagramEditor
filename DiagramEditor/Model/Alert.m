//
//  Alert.m
//  DiagramEditor
//
//  Created by Diego on 17/5/16.
//  Copyright © 2016 Diego Vaquero Melchor. All rights reserved.
//

#import "Alert.h"
#import "AlertAnnotationView.h"

@implementation Alert

@synthesize attach, text, who, date, aCId, associatedComponent, identifier;

- (void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeObject:self.attach  forKey:@"attach"];
    [coder encodeObject:self.text  forKey:@"text"];
    [coder encodeObject:self.who  forKey:@"who"];
    [coder encodeObject:self.date  forKey:@"date"];
    [coder encodeObject:self.associatedComponent forKey:@"associatedComponent"];
    [coder encodeInt:self.identifier forKey:@"identifier"];
    [coder encodeFloat:_location.coordinate.latitude forKey:@"latitude"];
    [coder encodeFloat:_location.coordinate.longitude forKey:@"longitude"];
    [coder encodeFloat:self.center.x forKey:@"centerx"];
    [coder encodeFloat:self.center.y forKey:@"centery"];

}


- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.attach = [coder decodeObjectForKey:@"attach"];
        self.text = [coder decodeObjectForKey:@"text"];
        self.who = [coder decodeObjectForKey:@"who"];
        self.date = [coder decodeObjectForKey:@"date"];
        self.associatedComponent = [coder decodeObjectForKey:@"associatedComponent"];
        self.identifier = [coder decodeIntForKey:@"identifier"];
        float latitude = [coder decodeFloatForKey:@"latitude"];
        float longitude = [coder decodeFloatForKey:@"longitude"];
        _location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        float centerx = [coder decodeFloatForKey:@"centerx"];
        float centery = [coder decodeFloatForKey:@"centery"];
        self.center = CGPointMake(centerx,centery);

    }
    return self;
}
@end
