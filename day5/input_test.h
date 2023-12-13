/* the tables were presorted with sort -k3 -n */

size_t seeds[] = {
	79, 14,
	55, 13
};

size_t seed_to_soil[][3] = {
	{ 52, 50, 48 },
	{ 50, 98, 2 },
};

size_t soil_to_fertilizer[][3] = {
	{ 39, 0,  15 },
	{ 0,  15, 37 },
	{ 37, 52, 2 },
};

size_t fertilizer_to_water[][3] = {
	{ 42, 0,  7 },
	{ 57, 7,  4 },
	{ 0,  11, 42 },
	{ 49, 53, 8 },
};

size_t water_to_light[][3] = {
	{ 88, 18, 7 },
	{ 18, 25, 70 },
};

size_t light_to_temperature[][3] = {
	{ 81, 45, 19 },
	{ 68, 64, 13 },
	{ 45, 77, 23 },
};

size_t temperature_to_humidity[][3] = {
	{ 1,  0,  69 },
	{ 0,  69, 1 },
};

size_t humidity_to_location[][3] = {
	{ 60, 56, 37 },
	{ 56, 93, 4 },
};
