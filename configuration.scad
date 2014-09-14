// Bearing dimensions: ID, OD, W
bearing623 = [3, 10, 4];
bearing624 = [4, 13, 5];
bearing608 = [8, 22, 7];
bearinglm8uu = [8, 15, 25];
bearinglm10uu = [10, 19, 29];

smooth_rod_separation = 60;
//smooth_rod_length = 300; // Rostock mini
//smooth_rod_radius = 4;
//smooth_rod_bearing = bearinglm8uu;
smooth_rod_length = 770;
smooth_rod_radius = 5;
smooth_rod_bearing = bearinglm10uu;

motor_end_height = 44;

idler_end_height = 28;
//idler_bearing = bearing608;  // For 20 tooth GT2
idler_bearing = bearing624;  // For 16 thooth GT2

platform_thickness = 8;
platform_hinge_offset = 33;

bed_thickness = 12;
pcb_thickness = 2;

rod_separation = 50;
//rod_length = 150; // Rostock mini
//rod_radius = 65; // Rostock mini
rod_length = 250;
rod_radius = 124;

// These are needed by modules in a couple of different files
carriage_height = smooth_rod_bearing[2];
carriage_hinge_offset = smooth_rod_bearing[1]/2+14.5;

