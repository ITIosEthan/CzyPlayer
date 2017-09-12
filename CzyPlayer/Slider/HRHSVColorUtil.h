

typedef struct {
    CGFloat h;
    CGFloat s;
    CGFloat v;
} HRHSVColor;

void HSVColorFromUIColor(UIColor *, HRHSVColor *outHSV);

