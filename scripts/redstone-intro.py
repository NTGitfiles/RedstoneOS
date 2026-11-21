from manim import *
import numpy as np
config.background_color="#090d12"
PALETTES=[
("#f04b3e","#ffb078"),("#d9473d","#ff9d73"),("#ff624b","#ffc17c"),("#f15a4b","#7dd3d7"),("#ff493e","#ff9b58"),
("#e84b4b","#b98cff"),("#ff5949","#9bd5d1"),("#e86b48","#e9b17b"),("#ff503e","#ffb15f"),("#e65a52","#a5e2e5"),
("#ee5141","#a8d28c"),("#ff5149","#8c9cff"),("#ff563b","#ffc16c"),("#ef5549","#65c9c4"),("#f15a4a","#ffd09a"),
("#ed5145","#d5a17d"),("#ff514e","#d08cff"),("#f45143","#b2d99a"),("#f04e46","#ffb16b"),("#f85a49","#f5b17a")]
def make_construct(idx,red,accent):
 def construct(self):
  grid=VGroup(*[Line([x,-4.1,0],[x,4.1,0],color="#34404b",stroke_opacity=.22,stroke_width=1) for x in np.arange(-7.5,8,.75)])
  self.add(grid)
  pts=[np.array([-6.8+j*1.36,-1.5+(0.7 if (j+idx)%2 else -0.7)+(0.4 if j in (3,7) and idx%2 else 0),0]) for j in range(11)]
  path=VMobject(color=red,stroke_width=7+idx%4).set_points_as_corners(pts)
  self.play(Create(path),run_time=.75+idx%3*.12)
  pulse=Dot(pts[0],radius=.13+idx%3*.02,color=accent);self.add(pulse)
  self.play(MoveAlongPath(pulse,path),run_time=1+idx%4*.16,rate_func=[linear,smooth,rush_into,rush_from][idx%4])
  top=Polygon([-1.35,.7,0],[0,-.05,0],[1.35,.7,0],[0,1.45,0],color=accent,fill_color=accent,fill_opacity=.85,stroke_width=3)
  left=Polygon([-1.35,.7,0],[0,-.05,0],[0,-1.65,0],[-1.35,-.9,0],color=red,fill_color=red,fill_opacity=.9)
  right=Polygon([1.35,.7,0],[0,-.05,0],[0,-1.65,0],[1.35,-.9,0],color=red,fill_color="#55252d",fill_opacity=1)
  core=Square(.55,fill_color=red,fill_opacity=1,stroke_color=accent,stroke_width=3).move_to([0,.55,0])
  block=VGroup(left,right,top,core)
  if idx%4==0:self.play(FadeIn(block,scale=.35),run_time=.6)
  elif idx%4==1:self.play(FadeIn(block),Rotate(block,angle=PI/4),run_time=.6)
  elif idx%4==2:self.play(block.animate.shift(UP*.5).scale(1.08),run_time=.6)
  else:self.play(SpinInFromNothing(block),run_time=.6)
  if idx%2:self.play(Rotate(core,angle=PI/2),core.animate.set_fill(accent),run_time=.4)
  else:self.play(core.animate.scale(1.3).set_fill(accent),run_time=.4)
  title=Text("REDSTONE OS",font="DejaVu Sans Mono",weight=BOLD,color="#f5eee8",font_size=43).move_to(DOWN*2.85)
  sub=Text(f"POWERED BY REDSTONE / EDITION {idx:02d}",font="DejaVu Sans Mono",color=accent,font_size=13).next_to(title,DOWN,buff=.22)
  if idx%3==0:self.play(Write(title),FadeIn(sub),run_time=.75)
  elif idx%3==1:self.play(FadeIn(title,shift=UP*.4),Write(sub),run_time=.75)
  else:self.play(GrowFromCenter(title),FadeIn(sub),run_time=.75)
  self.wait(.3)
 return construct
for i,(r,a) in enumerate(PALETTES,1):
 name=f"RedstoneMotion{i:02d}"
 globals()[name]=type(name,(Scene,),{"construct":make_construct(i,r,a),"__module__":__name__})
