// ============================================================
//  Metatron's Cube — OpenSCAD
//  1 center + 6 inner (at 2R) + 6 outer (at 4R) = 13 circles
//  All 78 center-to-center line segments are drawn with hull()
//  Bob Heida 2021-2026
// ============================================================

$fn = 360;

// ── parameters ───────────────────────────────────────────────
R      = 12;    // circle radius (touching circles → centers 2R apart)
ring_w = .8;  // circle stroke width
line_r = .4;  // half-thickness of connecting lines
Z      = 1;   // extrusion depth
// ─────────────────────────────────────────────────────────────

// ── 13 centres ───────────────────────────────────────────────
inner_pts = [ for(i=[0:5]) [ 2*R*cos(i*60), 2*R*sin(i*60) ] ];
outer_pts = [ for(i=[0:5]) [ 4*R*cos(i*60), 4*R*sin(i*60) ] ];
all_pts   = concat([ [0,0] ], inner_pts, outer_pts);

// ── hollow ring ──────────────────────────────────────────────
module ring(p) {
    translate([p[0], p[1], 0])
    linear_extrude(Z)
    difference() {
        circle(R);
        circle(R - ring_w);
    }
}

// ── line segment via hull of two flat discs ───────────────────
// This avoids any atan2 / rotate issues entirely.
module seg(a, b) {
    hull() {
        translate([a[0], a[1], 0])
            cylinder(r=line_r, h=Z, center=false, $fn=8);
        translate([b[0], b[1], 0])
            cylinder(r=line_r, h=Z, center=false, $fn=8);
    }
}

// ── all 78 lines ─────────────────────────────────────────────
module all_lines() {
    n = len(all_pts);
    for (i=[0:n-2])
        for (j=[i+1:n-1])
            seg(all_pts[i], all_pts[j]);
}

// ── all 13 circles ───────────────────────────────────────────
module all_circles() {
    for (p = all_pts) ring(p);
}

// ── render ───────────────────────────────────────────────────
color([0.85, 0.65, 0.10])  all_lines();
color([0.20, 0.55, 1.00])  all_circles();
