//
//  GeoComponentPointAnnotation.m
//  DiagramEditor
//
//  Created by Diego on 4/10/16.
//  Copyright © 2016 Diego Vaquero Melchor. All rights reserved.
//

#import "GeoComponentPointAnnotation.h"


@implementation GeoComponentPointAnnotation

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_component forKey:@"component"];
    
    
    
    
}

- (id)initWithCoder:(NSCoder *)coder {
    
    self = [self init];
    
    if (self) {
        
        _component = [coder decodeObjectForKey:@"component"];

    }
    return self;
}

@end
