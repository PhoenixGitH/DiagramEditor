//
//  UserAnnotation.h
//  DiagramEditor
//
//  Created by Miso on 25/4/17.
//  Copyright © 2017 Javier. All rights reserved.
//

#ifndef UserAnnotation_h
#define UserAnnotation_h

#import <MapKit/MapKit.h>

@interface UserAnnotation : MKAnnotationView

@property NSString* name;
@property float temperature;
@property float money;


- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation
                             name:(NSString*)name
                       temperature:(float)temp
                             money:(float)money;

@end


#endif /* UserAnnotation_h */
