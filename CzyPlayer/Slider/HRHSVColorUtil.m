
#import "HRHSVColorUtil.h"

void HSVColorFromUIColor(UIColor *uiColor, HRHSVColor *hsv) {
    CGFloat alpha;
    [uiColor getHue:&hsv->h saturation:&hsv->s brightness:&hsv->v alpha:&alpha];
}

