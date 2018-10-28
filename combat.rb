#!/usr/bin/env ruby
#
# combat.rb
# A basic combat tracker, using the rules that I play with in D&D 5e.
# Feel free to play around with the script if you do things otherwise.
#
# Written by:  Mohsin Rizvi
# Last edited: 03/14/18

require "readline"

# Combat
# Used to represent a combat scene.
class Combat

    # initialize
    # Purpose:    Run the combat tracker.
    # Parameters: n/a
    # Return:     n/a
    def initialize()
        info()
        initFighters(inpMinNum(2, "> How many combatants are there?"))
        surprise()
        fight()
    end

    # initFighters
    # Purpose:    Initialize the fighters in combat.
    # Parameters: The amount of fighters to initialize.
    # Return:     n/a
    def initFighters(len)
        @fighters = []
        count = 1
        while count <= len
            maxhp = -1
            puts "\n> Creating combatant #{count}..."

            # Get combatant data - currently only supports 1 word names
            puts "> What is this combatant's name?"
            name  = read().chomp
            hp    = inpMinNum(1, "> What is this combatant's current HP?")
            maxhp = inpMinNum(1, "> What is this combatant's max HP?")
            while maxhp < hp
                maxhp = inpMinNum(1, "> Please enter a max HP greater than " +
                                     "or equal to the combatant's HP.")
            end
            init  = inpMinNum(1, "> What is this combatant's initiative?")

            # Create the combatant
            f = Fighter.new(name, hp, maxhp, init)
            puts f.to_s()
            @fighters.push f

            count += 1
        end

        # Sort the combatants
        @fighters = @fighters.sort_by {|i| i.init}.reverse
    end


    # info
    # Purpose:    Print out program info.
    # Parameters: n/a
    # Return:     n/a
    def info()
        puts ">> dm-tools combat tracker 0.1\n" + 
             ">> created by Mohsin Rizvi\n" +
             ">> enter \"q\" to exit at any time\n" + 
             "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    end

    # surprise
    # Purpose:    Give fighters a surprise round
    # Parameters: n/a
    # Return:     n/a
    def surprise()
        curr = ""
        while true
            # Get the next person to act
            while !(inNames(curr))
                puts "> Who has the next surprise attack? If nobody does, " + 
                     "type \"none\"."
                curr = read().chomp.downcase
                if curr == "none"
                    return
                end
            end

            # Do the person's action
            action(curr)
            curr = ""
        end
    end

    # fight
    # Purpose:    Have everyone fight!
    # Parameters: n/a
    # Return:     n/a
    def fight()
        puts ""
        # Begin fighting loop
        while true
            # Loop through fighters in order of initiative
            for curr in @fighters
                puts "> It is #{curr.name()}'s turn!"
                action(curr.name())
            end
        end
    end

    # inNames
    # Purpose:    Check if a given name is the name of a fighter.
    # Parameters: A name to check
    # Return:     True if the name is a fighter, false otherwise
    def inNames(name)
        for i in @fighters
            if i.name().downcase == name
                return true
            end
        end
        return false
    end

    # action
    # Purpose:    Let a fighter make an action.
    # Parameters: The name of the fighter, assumed to be valid
    # Return:     n/a
    def action(name)
        puts "> What does #{name} do? The commands are as follows:\n" + 
             "> attack:   [a target_name damage_dealt]\n" +
             "> heal:     [h target_name health_healed]\n" + 
             "> end turn: [e]"

        # Begin the action REPL
        while true
            # Get a valid action
            actions = "x"
            while validAction(actions) == "x"
                actions = read().chomp.downcase.split()
            end

            # Loop through possible actions
            case (actions[0])
            when "a"
                attack(actions[1], actions[2])
            when "h"
                heal(actions[1], actions[2])
            when "e"
                return
            end
        end
    end

    # validAction
    # Purpose:    Check if a given action string is valid.
    # Parameters: An array of strings in one of the following forms, where 
    #             elements of the string are separated below by spaces:
    #             attack:  [a target_name damage_dealt]
    #             heal:    [h target_name health_healed]
    #             end turn [e]
    # Return:     Returns "x" if action is invalid, "a" if a successful attack
    #             is done, "h" if a successful heal is done, and "e" if a turn
    #             is successfully ended.
    def validAction(actions)
        # Loop through possible actions
        case (actions[0])
        when "a"
            if inNames(actions[1]) and actions.length >= 3
                return "a"
            end
        when "h"
            if inNames(actions[1]) and actions.length >= 3
                return "h"
            end
        when "e"
            return "e"
        end

        return "x"
    end

    # attack
    # Purpose:    Deal damage to a Fighter.
    # Parameters: The name of the Fighter to take damage and the damage dealt.
    # Return:     n/a
    def attack(target, dmg)
        dmg = dmg.to_i
        for i in @fighters
            if i.name() == target
                # Update target's HP
                i.updateHP(-dmg)

                # Report target status
                if i.hp() == 0
                    puts "#{target} is unconscious! Enter \"q\" if combat " +
                         "is over now."
                elsif i.hp() <= (i.maxhp() / 2)
                    puts "#{target} is bloodied!"
                else
                    puts "#{target} now has #{i.hp()} health!"
                end
            end
        end
    end

    # heal
    # Purpose:    Heal a Fighter.
    # Parameters: The name of the Fighter to heal and the health restored.
    # Return:     n/a
    def heal(target, heal)
        heal = heal.to_i
        for i in @fighters
            if i.name() == target
                # Update target HP and report target status
                i.updateHP(heal)
                puts "#{target} now has #{i.hp()} health!"
            end
        end
    end

end

# Fighter
# Used to represent a combatant.
class Fighter

    # initialize
    # Purpose:    Initialize a Fighter with the given stats.
    # Parameters: A name, the number of hitpoints, and the initiative.
    # Return:     n/a
    def initialize(name, hp, maxhp, init)
        @name  = name
        @hp    = hp
        @maxhp = maxhp
        @init  = init
    end

    # to_s
    # Purpose:    Override the to_s function to allow printing a Fighter.
    # Paramaters: n/a
    # Return:     The string representation of the Fighter.
    def to_s()
        return "#{@name}: HP: #{@hp}/#{@maxhp}, initiative: #{@init}"
    end

    # name
    # Purpose:    Access the name attribute.
    # Parameters: n/a
    # Return:     The name of the Fighter.
    def name()
        return @name
    end

    # hp
    # Purpose:    Access the hp attribute.
    # Parameters: n/a
    # Return:     The hp of the Fighter.
    def hp()
        return @hp
    end

    # maxhp
    # Purpose:    Access the maxhp attribute.
    # Parameters: n/a
    # Return:     The max hp of the Fighter.
    def maxhp()
        return @maxhp
    end

    # init
    # Purpose:    Access the init attribute.
    # Parameters: n/a
    # Return:     The initiative of the Fighter.
    def init()
        return @init
    end

    # updateHP
    # Purpose:    Update the hp attribute.
    # Parameters: The difference in hp of the Fighter.
    # Return:     The new hp of the Fighter.
    def updateHP(diff)
        @hp += diff

        # If target is unconscious, they must have 0 hp
        if (@hp <= 0)
            @hp = 0
        end
        # If target is at full health, they must have full health
        if (@hp > @maxhp)
            @hp = @maxhp
        end

        return @hp
    end

end

# inpMinNum
# Purpose:    Read numbers from standard input until a number is read with 
#             the given minimum value.
# Parameters: A minimum value for the number and a message to print on each
#             attempted read.
# Return:     A number.
def inpMinNum(min, message)
    curr = -1

    # Attempt to get a number
    begin
        puts message
        curr = Integer(read())
        if curr < min
            raise
        end
    # Catch raised exceptions
    rescue
        retry
    end

    return curr
end

# read
# Purpose:    Read something from stdin. If it is the exit character "q", halt
#             execution.
# Parameters: n/a
# Return:     A string read in from stdin.
def read()
    s = gets.chomp
    if s == "q"
        exit
    end
    return s
end

# Clear the screen
system "clear" or system "cls"
# Run combat
c = Combat.new