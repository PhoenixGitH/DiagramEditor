//
//  DoubleTableViewCell.m
//  DiagramEditor
//
//  Created by Diego on 13/10/16.
//  Copyright © 2016 Diego Vaquero Melchor. All rights reserved.
//

#import "DoubleTableViewCell.h"

@implementation DoubleTableViewCell
@synthesize comp;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _textField.delegate = self;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


#pragma mark UITextField delegate methods
- (void)textFieldDidEndEditing:(UITextField *)tf{
    
    if(tf.text.length > 0){
        
        for(ClassAttribute * atr in comp.attributes){
            if([atr.name isEqualToString:_label.text]){
                atr.currentValue = tf.text;
            }
        }
    }
}


-(BOOL)textField:(UITextField *)tf shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

-(void)textFieldDidChange:(UITextField *)tf
{
    NSLog(@"text changed: %@", tf.text);
    
    NSString * str = tf.text;
    
    if(tf.text.length > 0){
        
        for(ClassAttribute * atr in comp.attributes){
            if([atr.name isEqualToString:_label.text]){
                atr.currentValue = str;
            }
        }
    }
    
}

@end
