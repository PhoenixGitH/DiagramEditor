//
//  UserAnnotation.m
//  DiagramEditor
//
//  Created by Miso on 25/4/17.
//  Copyright © 2017 Javier. All rights reserved.
//

#import "UserAnnotation.h"

@implementation UserAnnotation

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation
                             name:(NSString *)name
                       temperature:(float)temp
                             money:(float)money{
    _name = name;
    _money = money;
    _temperature = temp;
    self = [super initWithAnnotation:annotation
                     reuseIdentifier:nil];

    // Callout settings - if you want a callout bubble
    self.canShowCallout = YES;
    self.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(200, 200, 200, 200)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.text = [NSString stringWithFormat:@"Nombre %@\nTemperature: %f\nMoney: %f\n", self.name,self.temperature,self.money];
    label.font = [label.font fontWithSize:10];
    [self addSubview:label];
    
    return self;
}


- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView* hitView = [super hitTest:point withEvent:event];
    if (hitView != nil)
    {
        [self.superview bringSubviewToFront:self];
    }
    return hitView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect rect = self.bounds;
    BOOL isInside = CGRectContainsPoint(rect, point);
    if(!isInside)
    {
        for (UIView *view in self.subviews)
        {
            isInside = CGRectContainsPoint(view.frame, point);
            if(isInside)
                break;
        }
    }
    return isInside;
}


@end
