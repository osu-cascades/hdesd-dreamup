defmodule DreamUp.Code do

  @adjective ["Fluffy", "Spicy", "Spiky", "Fuzzy", "Bland", "Blah", "Zippy", "Speedy", "Funky", "Sweet", "Silly", "Funny", "Maniacal", "Melancholy", "Modish", "Myriad", "Magnetic", "Majestic", "Masterful", "Melodramatic", "Memorable ", "Metallic ", "Meticulous", "miserly", "mild", "modern", "modest", "moody", "mundane", "mysterious", "Achy", "Adequate", "Affordable", "Ageless", "Austere", "Authentic", "Attentive", "Articulate", "Angelic", "Bitty", "Burly", "Busy", "Tiny", "Calm", "Charming", "Clean", "Cogent", "Cute", "Dapper", "Dramatic", "Easy-going", "Evanescent", "Exemplary", "Efficacious", "Fabulous", "Fidgety", "Florid", "Fussy", "Frugal", "Goofy", "Ghostly", "Hungry", "Headstrong", "Hilarious", "Impervious", "Introverted", "Improbable", "Inclined", "Joyous", "Judicious", "Jovial", "Jesting", "Knowledgeable", "Kindly", "Keen", "Kingly", "Lanky", "Loud", "Lucky", "Lyrical", "Magical", "Noble", "Odd", "Opulent", "Palatable", "Peaceful", "Poetic", "Popular", "Quick", "Quirky", "Quaint", "Realistic", "Rhyming", "Rustic", "Radiant", "Saintly", "Thoughtful", "Tranquil", "Ultra", "Useful", "Wacky", "Wild", "Youthful", "Zany", "Zealous", "Zestful"]
  @color ["Blue", "Red", "Yellow", "Green", "Purple", "Pink", "White", "Brown ", "Black", "Gray", "Magenta", "Violet", "Turqoiuse", "Amber", "Aqua", "Aquamarine", "Burgundy", "Fuscia", "Azure", "Beige", "Blond", "Brown ", "Celadon", "Charcoal", "Citron", "Copper", "Coral", "Crimson", "Cyrstal", "Cyan", "Taupe", "Emerald", "Fuchsia", "Fulvous", "Gold", "Goldenrod", "Indigo", "Lavender", "Lemon", "Linen", "Marigold", "Maroon", "mauve", "Mint", "Navy", "Nickel", "ocean", "ochre", "lace", "olive", "onyx", "opal", "orange", "orchid", "peach", "Perwinkle", "Phlox", "Pink", "Pistachio", "Plum", "Platinum", "Prune", "Pumpkin", "Rose", "Ruby", "Saffron", "Sage", "Sand", "Salmon", "Sepia", "Sienna", "Silver", "Slate", "Snow", "Straw", "Strawberry", "Sunglow", "Sunset", "Tangerine", "Taupe", "Teal", "Torquise", "Umber", "Vanilla", "Vermillion", "Violet", "Viridian", "Wheat", "Zaffre", "Zomp"]
  @animal ["Alpaca", "Ant", "Anteater", "Antelope", "Armadillo", "Badger", "Bat", "Bear", "Bird", "Bison", "Buffalo", "Bunny", "Butterfly", "Camel", "Cheetah", "Chicken", "Chipmunk", "Cougar", "Cow", "Coyote", "Crab", "Dog", "Dolphin", "Donkey", "Dragonfly", "Duck", "Elephant", "Fish", "Flamingo", "Fox", "Frog", "Gazelle", "Gerbil", "Giraffe", "Goat", "Gorilla", "Grasshopper", "Groundhog", "Hamster", "Hippopotamus", "Horse", "Iguana", "Iguana", "Jaguar", "Kangaroo", "Kitten", "Koala", "Ladybug", "Lemur", "Leopard", "Lion", "Lizard", "Llama", "Lobster", "Mongoose", "Monkey", "Mouse", "Mule", "Octopus", "Ostrich", "Otter", "Panda", "Panther", "Parrot", "Penguin", "Puppy", "Rabbit", "Raccoon", "Rat", "Reindeer", "Rhinoceros", "Salamander", "Salmon", "Seahorse", "Seal", "Shark", "Sheep", "Shrimp", "Skunk", "Sloth", "Squid", "Squirrel", "Tiger", "Tortoise", "Turtle", "Whale", "Worm", "Yak", "Zebra", "Owl", "Meercat", "Cat", "Narwhal", "Puma", "Porpoise", "Pig"]

  def random_code do
    String.capitalize(Enum.at(Enum.take_random(@adjective, 1), 0))
    <> String.capitalize(Enum.at(Enum.take_random(@color, 1), 0))
    <> String.capitalize(Enum.at(Enum.take_random(@animal, 1), 0))
  end

end
