SUBCLASS.PrintName = "Shinobi" -- Required
SUBCLASS.UnlockCost = 100
SUBCLASS.ParentClass = HORDE.Class_Berserker -- Required for any new classes
SUBCLASS.Icon = "subclasses/shinobi.png" -- Required
SUBCLASS.Description = [[
Berserker subclass.
Specializes in dodge and critical damage.]] -- Required
SUBCLASS.BasePerk = "shinobi_base"
SUBCLASS.Perks = {
    [1] = {title = "Fundamentals", choices = {"shinobi_1_1", "shinobi_1_2"}},
            [2] = {title = "Ninjutsu", choices = {"shinobi_2_1", "shinobi_2_2"}},
            [3] = {title = "Technique", choices = {"shinobi_3_1", "shinobi_3_2"}},
            [4] = {title = "Unyielding", choices = {"shinobi_4_1", "shinobi_4_2"}},
} -- Required