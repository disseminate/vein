V.Music = { -- vein/[name].mp3, song duration
	{ "preface", 35.6048 },
	{ "theme", 68.3102 },
	{ "tune1", 135 },
	{ "tune2", 78.08 },
	{ "tune3", 60.0816 },
	{ "tune4", 115 },
	{ "tune5", 96.0783 },
	{ "tune6", 116.6628 },
	{ "tune7", 61.4661 },
	{ "tune8", 33.0971 },
	{ "tune9", 79.27 },
	{ "tune10", 72 },
	{ "tune11", 58.17 },
	{ "tune12", 61.75 },
	{ "tune13", 85 },
	{ "tune14", 56 },
	{ "tune15", 76 },
	{ "tune16", 46 },
	{ "tune17", 15 },
	{ "tune18", 11.285 },
	{ "tune19", 130 },
	{ "youaredead", 68.5191 },
};

if( CLIENT ) then
	
	V.EF.GenericPlayable = { -- List of songs to play when nothing much is happening.
		"tune1",
		"tune2",
		"tune3",
		"tune4",
		"tune5",
		"tune9",
		"tune10",
		"tune11",
		"tune12",
		"tune13",
		"tune19"
	}

	V.EF.SafeActionPlayable = { -- Action music to play when everything's gonna be OK.
		"tune6",
	}

	V.EF.ActionPlayable = { -- Action music (aka, near zombies).
		"tune7",
		"tune14",
		"tune15",
	}

	V.EF.HardcoreActionPlayable = { -- "This is how you died"-calibre.
		"tune16",
	}
	
end