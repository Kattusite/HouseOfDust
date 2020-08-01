rect = """
[Meter{i}{x}]
Meter=Shape
MyGradient=180 | #Background# ; 0.0 | #Background2# ; 1.0
Shape=Rectangle 0,0,#RectWidth#,#RectHeight#,#RectRadius# | Fill LinearGradient MyGradient | Stroke Color 0,0,0,1
"""

sm_rect = """
[Meter{i}{x}]
Meter=Shape
Shape=Rectangle 0,0,5,#RectHeight# | Fill Color 150,0,0 | Stroke Color 0,0,0,1
"""

text = """
[Meter{i}{x}]
Meter=String
MeasureName=MyMeasure
"""

with open("@Resources/Meters.inc", "w") as f:
    for i in range(1,20):
        for x in "PQABCD":
            vars = {'i': i, 'x': x}
            if x == 'P':
                print(rect.format(**vars), file=f)
            elif x == 'Q':
                print(sm_rect.format(**vars), file=f)
            else:
                print(text.format(**vars), file=f)
