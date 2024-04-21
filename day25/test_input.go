package main

// You can use graphviz's neato to find the edges that need to break
var excluded = [][2]string {
	{"nvd", "jqt"},
	{"cmg", "bvb"},
	{"pzl", "hfx"},
}

var connections = [][]string{
	{"jqt", "rhn", "xhk", "nvd"},
	{"rsh", "frs", "pzl", "lsr"},
	{"xhk", "hfx"},
	{"cmg", "qnr", "nvd", "lhk", "bvb"},
	{"rhn", "xhk", "bvb", "hfx"},
	{"bvb", "xhk", "hfx"},
	{"pzl", "lsr", "hfx", "nvd"},
	{"qnr", "nvd"},
	{"ntq", "jqt", "hfx", "bvb", "xhk"},
	{"nvd", "lhk"},
	{"lsr", "lhk"},
	{"rzs", "qnr", "cmg", "lsr", "rsh"},
	{"frs", "qnr", "lhk", "lsr"},
}
