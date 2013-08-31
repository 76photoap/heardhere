//
//  DateTimePicker.h
//  Heard Here
//
//  Created by Dianna Mertz on 8/13/13.
//  Copyright (c) 2013 Dianna Mertz. All rights reserved.
//

// From http://stackoverflow.com/questions/6231587/iphone-adding-a-done-button-within-a-pop-up-datepicker-frame

#import <UIKit/UIKit.h>

@interface DateTimePicker : UIView {
}

@property (nonatomic, assign, readonly) UIDatePicker *picker;
@property (nonatomic, strong) NSString *myDateString;

- (void) setMode: (UIDatePickerMode) mode;
- (void) addTargetForDoneButton: (id) target action: (SEL) action;
- (NSString *)dateHasChanged:(id)sender;

@end
