
#import "HRBrightnessCursor.h"
#import "HRHSVColorUtil.h"


@implementation HRBrightnessCursor {
    CALayer *_backLayer;
    CALayer *_colorLayer;
    UILabel *_brightnessLabel;
    BOOL _editing;
}

- (id)init {
    self = [super initWithFrame:CGRectMake(0, 0, 28, 28)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        _backLayer = [[CALayer alloc] init];
        _backLayer.frame = self.frame;
        _backLayer.cornerRadius = CGRectGetHeight(self.frame) / 2;
        _backLayer.borderColor = [[UIColor colorWithWhite:0.65 alpha:1.] CGColor];
        _backLayer.borderWidth = 1.0 / [[UIScreen mainScreen] scale];
        _backLayer.backgroundColor = [[UIColor colorWithWhite:1. alpha:.7] CGColor];
        [self.layer addSublayer:_backLayer];

        _colorLayer = [[CALayer alloc] init];
        _colorLayer.frame = CGRectInset(self.frame, 5.5, 5.5);
        _colorLayer.cornerRadius = CGRectGetHeight(_colorLayer.frame) / 2;
        [self.layer addSublayer:_colorLayer];

        _brightnessLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 16)];
        _brightnessLabel.center = CGPointMake(CGRectGetWidth(self.frame) / 2 + 2, -20);
        _brightnessLabel.backgroundColor = [UIColor clearColor];
        _brightnessLabel.textAlignment = NSTextAlignmentCenter;
        _brightnessLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        _brightnessLabel.alpha = 0;
        [self addSubview:_brightnessLabel];
    }
    return self;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    [CATransaction begin];
    [CATransaction setValue:(id) kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    _colorLayer.backgroundColor = [color CGColor];
    [CATransaction commit];

    HRHSVColor hsvColor;
    HSVColorFromUIColor(_color, &hsvColor);

    NSMutableAttributedString *status;
    NSString *percent = [NSString stringWithFormat:@"%d", (int) ((1-hsvColor.v) * 100)];
    NSDictionary *attributes = @{
            NSFontAttributeName : [UIFont systemFontOfSize:14],
            NSForegroundColorAttributeName : [UIColor colorWithWhite:0.5 alpha:1]};

    status = [[NSMutableAttributedString alloc] initWithString:percent
                                                    attributes:attributes];

    NSDictionary *signAttributes = @{
            NSFontAttributeName : [UIFont systemFontOfSize:12],
            NSForegroundColorAttributeName : [UIColor colorWithWhite:0.5 alpha:1]};

    NSAttributedString *percentSign;
    percentSign = [[NSAttributedString alloc] initWithString:@"%"
                                                  attributes:signAttributes];

    [status appendAttributedString:percentSign];

    _brightnessLabel.attributedText = status;
}

- (void)setEditing:(BOOL)editing {
    if (editing == _editing) {
        return;
    }
    _editing = editing;
    void (^showState)() = ^{
        _brightnessLabel.alpha = 1.;
        _brightnessLabel.transform = CGAffineTransformIdentity;
        _backLayer.transform = CATransform3DMakeScale(1.6, 1.6, 1.0);
        _colorLayer.transform = CATransform3DMakeScale(1.4, 1.4, 1.0);
    };
    void (^hiddenState)() = ^{
        _brightnessLabel.alpha = 0.;
        _brightnessLabel.transform = CGAffineTransformMakeTranslation(0, 10);
        _backLayer.transform = CATransform3DIdentity;
        _colorLayer.transform = CATransform3DIdentity;
    };
    if (_editing) {
        hiddenState();
    } else {
        showState();
    }
    [UIView animateWithDuration:0.1
                     animations:_editing ? showState : hiddenState];
}

@end
