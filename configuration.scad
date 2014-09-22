// Bearing dimensions: ID, OD, W
bearing623 = [3, 10, 4];
bearing624 = [4, 13, 5];
bearing608 = [8, 22, 7];
bearinglm8uu = [8, 15, 25];
bearinglm10uu = [10, 19, 29];
bearinglm12uu = [12, 21, 31];

mini = true; // true = Rostock mini, false = whatever ya want

small_pulley = mini ? false : true;  // true = 16 thooth GT2, false = 20 tooth GT2

smooth_rod_separation = 60;
smooth_rod_length = mini ? 450 : 770;
smooth_rod_radius = mini ? 4 : 6;
smooth_rod_bearing = mini ? bearinglm8uu : bearinglm12uu;

bracket_fin_length = mini ? 45 : 70;

motor_end_height = 44;

idler_end_height = 28;
idler_bearing = small_pulley ? bearing624 : bearing608;

platform_thickness = 8;
platform_hinge_offset = 33;

bed_thickness = 12;
pcb_thickness = 2;

rod_separation = 50;
rod_length = mini ? 150 : 250;
rod_radius = mini ? 75 : 124;

// These are needed by modules in a couple of different files
carriage_height = smooth_rod_bearing[2];
carriage_hinge_offset = smooth_rod_bearing[1]/2+14.5;

idler_fins = mini ? false : true;       // If true, add fins to the idler brackets for extra stability at the top
box_idler = mini ? false : true;        // If true, add boxing around idler bearing to reduce axle torque

bottom_endstops = false; // If true, adds extra mount points to the platform

ball_joints = mini ? false : true;
ball_rad = 9.5 / 2 + 0.2; // Add a little extra radius for glue
cup_rad = ball_rad + 1;
cup_offset = cup_rad-platform_thickness/2;


