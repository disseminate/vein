-- The first argument is the returned item.
-- The second argument is tools used. These are not consumed.
-- The third argument is ingredients used. These are consumed.
-- The fourth argument is how many returned items to produce.

V.I.RegisterRecipe( "bandage", { }, { "tshirt" }, 4 );
V.I.RegisterRecipe( "banana", { }, { "bananabunch" }, 5 );
V.I.RegisterRecipe( "brokenplank", { }, { "plank" }, 1 );
V.I.RegisterRecipe( "molotov", { }, { "beer1", "bandage", "gascan" }, 1 );
V.I.RegisterRecipe( "molotov", { }, { "beer2", "bandage", "gascan" }, 1 );
V.I.RegisterRecipe( "molotov", { }, { "bottle1", "bandage", "gascan" }, 1 );
V.I.RegisterRecipe( "molotov", { }, { "bottle9", "bandage", "gascan" }, 1 );
V.I.RegisterRecipe( "propanebomb", { }, { "propane", "electronicscrap", "lever" }, 1 );