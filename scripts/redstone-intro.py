from manim import *

config.background_color = "#090d12"

class RedstoneBootIntro(Scene):
    def construct(self):
        # Subtle deepslate-style pixel grid.
        grid = VGroup()
        for x in range(-9, 10):
            grid.add(Line([x * 0.8, -4.5, 0], [x * 0.8, 4.5, 0],
                          color="#26313b", stroke_width=1, stroke_opacity=0.32))
        for y in range(-6, 7):
            grid.add(Line([-8, y * 0.8, 0], [8, y * 0.8, 0],
                          color="#26313b", stroke_width=1, stroke_opacity=0.32))
        self.play(FadeIn(grid), run_time=0.35)

        # A stepped redstone circuit snakes in from the edges.
        circuit_points = [
            [-7.0, -1.8, 0], [-5.8, -1.8, 0], [-5.8, -0.9, 0],
            [-4.4, -0.9, 0], [-4.4, 0.2, 0], [-2.8, 0.2, 0],
            [-2.8, 1.25, 0], [-1.3, 1.25, 0], [-1.3, 2.1, 0],
            [0.2, 2.1, 0], [0.2, 1.25, 0], [1.8, 1.25, 0],
            [1.8, 0.2, 0], [3.4, 0.2, 0], [3.4, -0.9, 0],
            [4.8, -0.9, 0], [4.8, -1.8, 0], [6.8, -1.8, 0]
        ]
        circuit = VMobject(color="#7f2929", stroke_width=8)
        circuit.set_points_as_corners([np.array(p) for p in circuit_points])
        self.play(Create(circuit), run_time=1.0)

        # Pixel-like junctions along the circuit.
        nodes = VGroup(*[
            Square(side_length=0.18, fill_color="#a93632",
                   fill_opacity=1, stroke_width=0).move_to(p)
            for p in circuit_points[1:-1:2]
        ])
        self.play(FadeIn(nodes, lag_ratio=0.08), run_time=0.35)

        # Isometric redstone block: top, left and right faces.
        top = Polygon([-0.0, 1.65, 0], [1.75, 0.72, 0],
                      [0.0, -0.2, 0], [-1.75, 0.72, 0],
                      color="#ff9b68", fill_color="#b94b37",
                      fill_opacity=1, stroke_width=3)
        left = Polygon([-1.75, 0.72, 0], [0.0, -0.2, 0],
                       [0.0, -2.15, 0], [-1.75, -1.18, 0],
                       color="#a43c32", fill_color="#87332f",
                       fill_opacity=1, stroke_width=3)
        right = Polygon([1.75, 0.72, 0], [0.0, -0.2, 0],
                        [0.0, -2.15, 0], [1.75, -1.18, 0],
                        color="#742a2b", fill_color="#61252a",
                        fill_opacity=1, stroke_width=3)
        block = VGroup(left, right, top).move_to(ORIGIN + DOWN * 0.15)
        self.play(FadeIn(block, scale=0.72), run_time=0.7)

        # Bright redstone core and blocky torch.
        core = Square(side_length=0.58, fill_color="#ff553e",
                      fill_opacity=1, stroke_color="#ffd0a0", stroke_width=3)
        core.move_to([0, 0.72, 0])
        torch_stem = Rectangle(width=0.22, height=0.75,
                               fill_color="#9a5a3c", fill_opacity=1,
                               stroke_width=0).move_to([0, 2.05, 0])
        flame = VGroup(
            Square(0.34, fill_color="#ff4b35", fill_opacity=1, stroke_width=0),
            Square(0.16, fill_color="#ffc16b", fill_opacity=1, stroke_width=0)
        ).arrange(ORIGIN).move_to([0, 2.55, 0])
        self.play(FadeIn(core, scale=0.4), run_time=0.3)
        self.play(FadeIn(torch_stem), FadeIn(flame, scale=0.3), run_time=0.45)

        # A travelling power pulse races around the circuit and into the core.
        pulse_path = VMobject()
        pulse_path.set_points_as_corners(
            [np.array(p) for p in circuit_points] +
            [np.array([0.0, 2.55, 0])]
        )
        pulse = Dot(color="#ffb06b", radius=0.13)
        pulse.set_glow_factor(0.8) if hasattr(pulse, "set_glow_factor") else None
        self.add(pulse)
        self.play(MoveAlongPath(pulse, pulse_path), run_time=2.0, rate_func=linear)
        self.play(
            core.animate.set_fill("#ffb36b").scale(1.12),
            flame.animate.scale(1.35),
            run_time=0.35
        )
        self.play(
            core.animate.set_fill("#ff553e").scale(1 / 1.12),
            flame.animate.scale(1 / 1.35),
            run_time=0.25
        )

        # Title reveal, with a stepped underline.
        title = Text("REDSTONE OS", font="DejaVu Sans Mono",
                     weight=BOLD, font_size=48, color="#f5eee8")
        title.move_to([0, -2.85, 0])
        tagline = Text("POWERED BY REDSTONE",
                       font="DejaVu Sans Mono", font_size=15,
                       color="#ff8967")
        tagline.move_to([0, -3.48, 0])
        underline = VGroup(
            Rectangle(width=1.2, height=0.055, fill_color="#8d302e",
                      fill_opacity=1, stroke_width=0),
            Rectangle(width=2.1, height=0.055, fill_color="#e34b3f",
                      fill_opacity=1, stroke_width=0),
            Rectangle(width=1.2, height=0.055, fill_color="#8d302e",
                      fill_opacity=1, stroke_width=0)
        ).arrange(RIGHT, buff=0.08).move_to([0, -3.83, 0])
        self.play(Write(title), run_time=0.75)
        self.play(FadeIn(tagline, shift=UP * 0.12), Create(underline), run_time=0.45)
        self.wait(0.9)


class RedstonePulseIntro(Scene):
    """A fast boot sting: the circuit charges, then the Redstone mark ignites."""
    def construct(self):
        grid = VGroup(*[
            Line([x, -4, 0], [x, 4, 0], color="#26313b", stroke_opacity=0.25)
            for x in np.arange(-8, 8.1, 0.8)
        ])
        self.add(grid)
        points = [(-7, -1.2, 0), (-4, -1.2, 0), (-4, 0.4, 0),
                  (-1.5, 0.4, 0), (-1.5, 1.7, 0), (1.5, 1.7, 0),
                  (1.5, 0.4, 0), (4, 0.4, 0), (4, -1.2, 0), (7, -1.2, 0)]
        path = VMobject(color="#e34b3f", stroke_width=9)
        path.set_points_as_corners([np.array(p) for p in points])
        self.play(Create(path), run_time=1.0)
        pulse = Dot(points[0], color="#ffc16b", radius=0.16)
        self.add(pulse)
        self.play(MoveAlongPath(pulse, path), run_time=1.25, rate_func=linear)
        flash = Square(1.2, fill_color="#ff553e", fill_opacity=1, stroke_color="#ffd0a0")
        self.play(FadeIn(flash, scale=0.2), run_time=0.2)
        title = Text("REDSTONE OS", font="DejaVu Sans Mono", weight=BOLD,
                     color="#f5eee8", font_size=54)
        sub = Text("POWERED BY REDSTONE", font="DejaVu Sans Mono",
                   color="#ff8967", font_size=18)
        title.move_to(DOWN * 2.3)
        sub.next_to(title, DOWN, buff=0.25)
        self.play(FadeOut(flash), Write(title), FadeIn(sub), run_time=0.8)
        self.wait(0.7)


class RedstoneOrbitIntro(Scene):
    """A calmer cinematic reveal with orbiting redstone nodes."""
    def construct(self):
        self.camera.background_color = "#090d12"
        ring = Circle(radius=2.0, color="#713039", stroke_width=5)
        inner = Circle(radius=1.35, color="#293b46", stroke_width=2)
        core = Square(1.25, fill_color="#a83b35", fill_opacity=1,
                      stroke_color="#ffad78", stroke_width=4)
        core.rotate(PI / 4)
        nodes = VGroup(*[
            Dot(ring.point_at_angle(a), radius=0.13, color="#ff684f")
            for a in np.linspace(0, TAU, 8, endpoint=False)
        ])
        self.play(Create(ring), Create(inner), FadeIn(core), run_time=0.9)
        self.play(FadeIn(nodes, lag_ratio=0.08), run_time=0.45)
        self.play(Rotate(nodes, angle=TAU, about_point=ORIGIN),
                  Rotate(ring, angle=-PI / 8), run_time=2.0, rate_func=linear)
        glow = Circle(radius=0.75, color="#ff9a6b", stroke_width=12)
        glow.move_to(ORIGIN)
        self.play(FadeIn(glow), core.animate.set_fill("#f15b45"), run_time=0.4)
        title = Text("REDSTONE OS", font="DejaVu Sans Mono", weight=BOLD,
                     color="#f5eee8", font_size=52)
        subtitle = Text("A SYSTEM WITH A SIGNAL", font="DejaVu Sans Mono",
                        color="#ff8967", font_size=17)
        title.move_to(DOWN * 2.8)
        subtitle.next_to(title, DOWN, buff=0.22)
        self.play(Write(title), FadeIn(subtitle), run_time=0.8)
        self.wait(0.9)
