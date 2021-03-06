//
//  AlertAnnotationView.m
//  DiagramEditor
//
//  Created by Diego on 10/10/16.
//  Copyright © 2016 Diego Vaquero Melchor. All rights reserved.
//

#import "AlertAnnotationView.h"

@implementation AlertAnnotationView

@synthesize coordinate;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(instancetype)initWithAnnotation:(id<MKAnnotation>)annotation alert:(Alert *)a{
    self = [super initWithAnnotation:annotation reuseIdentifier:nil];
    
    CGRect frame = [a frame];
    frame.origin.x = 0;
    frame.origin.y = 0;
    [a setFrame:frame];
    _alert = a;
    [self setBounds:a.bounds];
    
    [self addSubview:_alert];
    
    //self.coordinate = _alert.location.coordinate;
    
    self.draggable = NO; //Can I drag this?
    
    
    return  self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    [self willChangeValueForKey:@"coordinate"];
    coordinate = newCoordinate;
    [self didChangeValueForKey:@"coordinate"];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch{
    return YES;
}

@end
