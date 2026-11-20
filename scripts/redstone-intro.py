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
